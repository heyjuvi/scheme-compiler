(define (preprocess x)
  (cond
    ((let? x)
     (make-let (let-bindings x)
	       (preprocess (make-begin (let-body x)))))
    ((begin? x)
     (make-begin (map preprocess (begin-body x))))
    ; TODO: to be changed, such that all expression types
    ; are handled
    (else x)))

