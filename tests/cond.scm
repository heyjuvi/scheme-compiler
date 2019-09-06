(define (evaluate-cond x)
  (cond
    ((equal? x 1) 0)
    ((equal? x 'whoop-whoop) 1)
    ((equal? x (cons 23 42)) 2)
    ((equal? x "hello, fellow kidz") 3)
    (else 4)))

(define cond-cases-trigger-correctly
  (and (and (equal? (evaluate-cond 1) 0)
            (equal? (evaluate-cond 'whoop-whoop) 1))
       (and (equal? (evaluate-cond (cons 23 42)) 2)
	    (and (equal? (evaluate-cond "hello, fellow kidz") 3)
	         (equal? (evaluate-cond 1234567890) 4)))))
     

(display "All cond cases trigger correctly?")
(display cond-cases-trigger-correctly)
(newline)

cond-cases-trigger-correctly

