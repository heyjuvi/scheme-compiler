(define (evaluate-cond x)
  (cond
    ((equal? x 1) 0)
    ((equal? x 'whoop-whoop) 1)
    ((equal? x (cons 23 42)) 2)
    ((equal? x "hello, fellow kidz") 3)
    (else 4)))

(define cond-cases-trigger-correctly
  (and (equal? (evaluate-cond 1) 0)
       (equal? (evaluate-cond 'whoop-whoop) 1)
       (equal? (evaluate-cond (cons 23 42)) 2)
       (equal? (evaluate-cond "hello, fellow kidz") 3)
       (equal? (evaluate-cond 1234567890) 4)))
     
(display "All cond cases trigger correctly?")
(display cond-cases-trigger-correctly)
(newline)

(define elseless-cond-which-evaluates-false-because-of-missing-else-works
  (not
    (cond
      ((equal? 2 'some-symbol) #t)
      ((equal? (list 2) '(a b c)) #t))))

(display "Elseless cond, which evaluates to false because of the missing else works?")
(display elseless-cond-which-evaluates-false-because-of-missing-else-works)
(newline)

(define elseless-cond-which-evaluates-true-works
  (cond
    ((equal? 2 'some-other-symbol) #f)
    ((equal? `(,'a-symbol) '(a-symbol)) #t)))

(display "Elseless cond, which evaluates to true works?")
(display elseless-cond-which-evaluates-true-works)
(newline)

(and cond-cases-trigger-correctly
     elseless-cond-which-evaluates-false-because-of-missing-else-works
     elseless-cond-which-evaluates-true-works)

