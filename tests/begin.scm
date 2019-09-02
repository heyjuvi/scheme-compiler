(define single-body-correctly-evaluated
  (begin
    (equal? 2 2)))

(display "Single expression begin evaluates body correctly?")
(display single-body-correctly-evaluated)
(newline)

(define multiple-body-correctly-evaluated
  (begin
    #f
    (equal? 2 2)
    (equal? 2 3)
    (equal? 2 2)))

(display "Multiple expression begin evaluates body correctly?")
(display multiple-body-correctly-evaluated)
(newline)

(and single-body-correctly-evaluated
     multiple-body-correctly-evaluated)
