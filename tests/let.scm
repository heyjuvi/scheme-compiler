(define body-correctly-evaluated
  (let ((a #t))
    #f
    (equal? 2 2)
    (equal? 2 3)
    (equal? a #t)))

(display "Let evaluates body correctly?")
(display body-correctly-evaluated)
(newline)

body-correctly-evaluated
