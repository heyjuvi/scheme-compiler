(define (preprocess x)
  (cond
    ((let? x)
     (make-let (let-bindings x)
	       (preprocess (make-begin (let-body x)))))
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
			 (preprocess (define-body x))))
       (else
	 (error "define could not be preprocessed: " x))))
    ; TODO: to be changed, such that all expression types
    ; are handled
    (else x)))

(if tests-enabled
  (begin
    (display " -- testing preprocess") (newline)
    (display "    definition of functions") (newline) (newline)
    (let* ((test-define-function '(define (add1 x) (+ x 1)))
           (result-define-function (preprocess test-define-function))
           (expected-define-function '(define add1 (lambda (x) (+ x 1)))))
      (display "    test: ") (display test-define-function) (newline)
      (display "    result: ") (display result-define-function) (newline)
      (display "    expected: ") (display expected-define-function) (newline)
      (display "    matches: ") (display (equal? result-define-function expected-define-function)) (newline))
    (newline)
    (let* ((test-define-function '(define (add1 x) (- 2 1) (+ x 1)))
           (result-define-function (preprocess test-define-function))
           (expected-define-function '(define add1 (lambda (x) (begin (- 2 1) (+ x 1))))))
      (display "    test: ") (display test-define-function) (newline)
      (display "    result: ") (display result-define-function) (newline)
      (display "    expected: ") (display expected-define-function) (newline)
      (display "    matches: ") (display (equal? result-define-function expected-define-function)) (newline))
    'end-test)
  'no-test)

