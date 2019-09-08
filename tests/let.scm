(define body-correctly-evaluated
  (let ((a #t))
    #f
    (equal? 2 2)
    (equal? 2 3)
    (equal? a #t)))

(display "Let evaluates body correctly?")
(display body-correctly-evaluated)
(newline)

(define let-star-correctly-evaluated
  (let* ((a 2)
	 (b (+ a 2))
	 (c (+ b 2)))
    (and (equal? b 4) (equal? c 6))))

(display "Let* is evaluated correctly?")
(display body-correctly-evaluated)
(newline)

(and body-correctly-evaluated
     let-star-correctly-evaluated)
