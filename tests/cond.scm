(define (evaluate-cond x)
  (cond
    ((equal? x 1) 0)
    ((equal? x 'whoop-whoop) 1)
    ((equal? x (cons 23 42)) 2)
    ((equal? x "hello, fellow kidz") 3)
    (else 4)))

(add-test!
  "All cond cases trigger correctly?"
  (list (evaluate-cond 1)
        (evaluate-cond 'whoop-whoop)
        (evaluate-cond (cons 23 42))
        (evaluate-cond "hello, fellow kidz")
        (evaluate-cond 1234567890))
  (list 0 1 2 3 4))
     
(add-test!
  "Elseless cond works?"
  (cond
    ((equal? 2 'some-symbol) #t)
    ((equal? (list 2) '(a b c)) #t))
  #f)

(add-test!
  "Elseless cond, which evaluates to true works?"
  (cond
    ((equal? 2 'some-other-symbol) #f)
    ((equal? `(,'a-symbol) '(a-symbol)) #t))
  #t)

(test-results)
