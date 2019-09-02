(define (preprocess x)
  (cond
    ((let? x)
     (make-let (let-bindings x)
	       (make-body (preprocess (make-begin (let-body x))))))
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
    ; TODO: to be changed, such that all expression types
    ; are handled
    (else x)))

