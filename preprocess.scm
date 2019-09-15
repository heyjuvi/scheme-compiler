(define id-counter 0)
(define (unique-id)
  (set! id-counter (add1 id-counter))
  (string->symbol (format "id~A" (list id-counter))))

(define (escape-id x)
  (let ((x-lst (string->list (symbol->string x))))
    (string->symbol
      (foldr (lambda (s1 s2) (string-append s1 s2))
	(map (lambda (c)
	       (cond
		 ((eq? c #\-) "_dash_")
		 ((eq? c #\!) "_exclmark_")
		 ((eq? c #\?) "_questmark_")
		 ((eq? c #\*) "_star_")
		 ((eq? c #\>) "_greater_")
		 ((eq? c #\<) "_greater_")
		 ((eq? c #\=) "_equal_")
		 (else (char->string c))))
	     x-lst)))))

(define (preprocess x)
  (cond
    ((let*? x)
     (preprocess (preprocess-let*->let x)))
    ((let? x)
     (let ((new-bindings (map (lambda (p)
                                (list (escape-id (let-binding-var p))
                                      (preprocess (let-binding-val p))))
                              (let-bindings x))))
     (make-let new-bindings
	       (make-body
		 (make-begin
		   (make-body
		     (preprocess-vars->refs
		       (preprocess (let-body x))
		       (map let-binding-var new-bindings))))))))
    ((lambda? x)
     (let ((new-args (map escape-id (lambda-args x))))
       (make-lambda new-args
		    (make-body
		      (make-begin
		        (make-body
			  (preprocess-vars->refs
			    (preprocess (lambda-body x))
			    new-args)))))))
    ((if? x)
     (make-if (preprocess (if-test x))
	      (preprocess (if-conseq x))
	      (preprocess (if-altern x))))
    ((begin? x)
     (make-begin (map preprocess (begin-body x))))
    ((define? x)
     (cond
       ((define-function? x)
	(preprocess
          (make-define-var (escape-id (define-function-name x))
			   (make-body
			     (make-lambda
			       (define-function-args x)
			       (make-body
				 (make-begin
				   (define-body x))))))))
       ((define-var? x)
	(make-define-var (escape-id (define-id x))
			 (make-body
			   (preprocess
			     (car (define-body x))))))
       (else
	 (error "define could not be preprocessed: " x))))
    ((cond? x)
     (preprocess (preprocess-cond->if (cond-clauses x))))
    ((immediate? x) x)
    ((string? x) (debug x) x)
    ((or? x)
     (preprocess (preprocess-unfold-or (cdr x))))
    ((and? x)
     (preprocess (preprocess-unfold-and (cdr x))))
    ((or (primcall? x) (set!? x))
     (debug (car x))
     (cons (car x) (map preprocess (cdr x))))
    ((list-primcall? x)
     (preprocess-list->cons (map preprocess (cdr x))))
    ((quote? x)
     (preprocess-quote (quote-content x)))
    ((quasiquote? x)
     (map preprocess
	  (preprocess-quasiquote 1 (quasiquote-content x))))
    ((list? x)
     (map preprocess x))
    ((var? x)
     (escape-id x))
    (else
      (error "Not preprocessable: " x))))

(define (preprocess-unfold-and x)
  (if (equal? (length x) 2)
    (make-if (car x) (cadr x) #f)
    (make-if (car x) (preprocess-unfold-and (cdr x)) #f)))

(define (preprocess-unfold-or x)
  (if (equal? (length x) 2)
    (make-if (car x) #t (cadr x))
    (make-if (car x) #t (preprocess-unfold-or (cdr x)))))

(define (preprocess-let*->let x)
  (let ((bindings (let-bindings x)))
    (if (equal? (length bindings) 1)
      (make-let bindings (let-body x))
      (let ((first-binding (car bindings))
            (rest-bindings (cdr bindings)))
        (make-let
          (list first-binding)
  	  (make-body
            (preprocess-let*->let
              (make-let* rest-bindings (let-body x)))))))))

(define (preprocess-vars->refs_ x arg-id-pairs)
  (cond
    ((set!? x)
     (let ((vec-var (assoc (set!-var x) arg-id-pairs)))
       (if (eq? vec-var #f)
	 x
	 `(vector-set! ,(cdr vec-var)
		       0
		       ,(preprocess-vars->refs_ (set!-val x) arg-id-pairs)))))
    ((var? x)
     (let ((vec-var (assoc x arg-id-pairs)))
       (if (eq? vec-var #f)
	 x
	 `(vector-ref ,(cdr vec-var) 0))))
    ((lambda? x)
     (make-lambda (lambda-args x)
		  (preprocess-vars->refs_ (lambda-body x)
					  arg-id-pairs)))
    ((let? x)
     (make-let (let-bindings x)
	       (preprocess-vars->refs_ (let-body x)
                                       arg-id-pairs)))
    ((immediate? x) x)
    ((string? x) x)
    ((quote? x) x)
    ; this would'nt do anything, closures do not occur at this
    ; stage of compiling
    ;((closure? x) x)
    ((list? x)
     (map (lambda (y) (preprocess-vars->refs_ y arg-id-pairs)) x))
    (else
      (error "preprocess-args->refs has not implemented" x))))
(define (preprocess-vars->refs x args)
  (let ((arg-id-pairs (map (lambda (a) (cons a (unique-id))) args)))
  (make-let (map (lambda (p) `(,(cdr p) (vector ,(car p)))) arg-id-pairs)
	    (make-body
	      (make-begin
		(preprocess-vars->refs_ x arg-id-pairs))))))

(define (preprocess-cond->if x)
  (if (null? x)
    ; this is convention for now, one-handed ifs are not
    ; supported at the moment
    #f
    (let* ((clause (car x))
	   (clause-test (cond-clause-test clause))
	   (clause-body (cond-clause-body clause)))
      (if (eq? clause-test 'else)
        (make-begin clause-body)
        (make-if clause-test
	         (make-begin clause-body)
	         (preprocess-cond->if (cdr x)))))))

(define (preprocess-list->cons x)
  (cond
    ((null? x) x)
    ((pair? x)
     `(cons ,(car x) ,(preprocess-list->cons (cdr x))))
    (else x)))

(define (preprocess-quote content)
  (cond
    ((immediate? content) content)
    ((string? content) content)
    ; make a quote from it again at leaf level, if we finally
    ; have found a symbol
    ((symbol? content) (make-quote content))
    ; recursively treat lists
    ((pair? content)
     `(cons ,(preprocess-quote (car content))
            ,(preprocess-quote (cdr content))))
    (else
      (error "Illegal value in quote: " content))))

; TODO: unquote splicing (also in the parser)
(define (preprocess-quasiquote n content)
  (cond
    ((unquote? content)
     (if (equal? n 1)
       (preprocess (unquote-content content))
       (list 'cons
	     (make-quote 'unquote)
	     (list 'cons
	           (preprocess-quasiquote (sub1 n) (unquote-content content))
		   '()))))
    ((quasiquote? content)
     (list 'cons
	   (make-quote 'quasiquote)
	   (list 'cons
                 (preprocess-quasiquote (add1 n) (quasiquote-content content))
		 '())))
    ((pair? content)
     `(cons ,(preprocess-quasiquote n (car content))
	    ,(preprocess-quasiquote n (cdr content))))
    ; everything else can be handled by quote (immediate, string and symbol)
    (else (preprocess-quote content))))

