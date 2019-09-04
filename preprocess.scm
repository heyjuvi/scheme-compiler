(define (preprocess x)
  (cond
    ((let? x)
     (make-let (let-bindings x)
	       (make-body (preprocess (make-begin (let-body x))))))
    ((lambda? x)
     (make-lambda (lambda-args x)
	          (make-body (preprocess (make-begin (lambda-body x))))))
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
			   (make-body (make-lambda (define-function-args x)
						   (make-body (make-begin (define-body x))))))))
       ((define-var? x)
	(make-define-var (define-id x)
			 (make-body (preprocess (car (define-body x))))))
       (else
	 (error "define could not be preprocessed: " x))))
    ((immediate? x) x)
    ((string? x) x)
    ((primcall? x)
     (cons (car x) (map preprocess (cdr x))))
    ((list-primcall? x)
     (preprocess-list->cons (map preprocess (cdr x))))
    ((quote? x)
     (preprocess-quote (quote-content x)))
    ((list? x)
     (map preprocess x))
    ((var? x) x)
    (else
      (error "Not preprocessable: " x))))

(define (preprocess-list->cons x)
  (cond
    ((null? x) x)
    ((pair? x)
     `(cons ,(car x) ,(preprocess-list->cons (cdr x))))
    (else x)))

(define (preprocess-quote content)
  (cond
    ; recursively treat lists
    ((pair? content)
     `(cons ,(preprocess-quote (car content))
            ,(preprocess-quote (cdr content))))
    ((immediate? content) content)
    ((string? content) content)
    ; make a quote from it again at leaf level, if we finally
    ; have found a symbol
    ((symbol? content) (make-quote content))
    (else
      (error "Illegal value in quote: " content))))
