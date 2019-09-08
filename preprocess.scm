(define id-counter 0)
(define (unique-id)
  (set! id-counter (add1 id-counter))
  (string->symbol (format "id~A" id-counter)))

(define (preprocess x)
  (cond
    ((let? x)
     (make-let (let-bindings x)
	       (make-body
		 (make-begin
		   (make-body
		     (preprocess-vars->refs
		       (preprocess (let-body x))
		       (let-bindings-vars x)))))))
    ((lambda? x)
     (make-lambda (lambda-args x)
		  (make-body
		    (make-begin
		      (make-body
			(preprocess-vars->refs
			  (preprocess (lambda-body x))
			  (lambda-args x)))))))
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
          (make-define-var (define-function-name x)
			   (make-body
			     (make-lambda
			       (define-function-args x)
			       (make-body
				 (make-begin
				   (define-body x))))))))
       ((define-var? x)
	(make-define-var (define-id x)
			 (make-body
			   (preprocess
			     (car (define-body x))))))
       (else
	 (error "define could not be preprocessed: " x))))
    ((cond? x)
     ;(display (preprocess-cond->if (cond-clauses x))) (newline) (newline)
     (preprocess (preprocess-cond->if (cond-clauses x))))
    ((immediate? x) x)
    ((string? x) x)
    ((primcall? x)
     (cons (car x) (map preprocess (cdr x))))
    ((list-primcall? x)
     (preprocess-list->cons (map preprocess (cdr x))))
    ((quote? x)
     (preprocess-quote (quote-content x)))
    ((quasiquote? x)
     (map preprocess (preprocess-quasiquote 1 (quasiquote-content x))))
    ((list? x)
     (map preprocess x))
    ((var? x) x)
    (else
      (error "Not preprocessable: " x))))

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
       (list 'list
	     (make-quote 'unquote)
	     (preprocess-quasiquote (sub1 n) (unquote-content content)))))
    ((quasiquote? content)
     (list 'list
	   (make-quote 'quasiquote)
	   (preprocess-quasiquote (add1 n) (quasiquote-content content))))
    ((pair? content)
     `(cons ,(preprocess-quasiquote n (car content))
	    ,(preprocess-quasiquote n (cdr content))))
    ; everything else can be handled by quote (immediate, string and symbol)
    (else (preprocess-quote content))))

