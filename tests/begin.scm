(add-test!
  "Single expression begin evaluates body correctly?"
  (begin
    (equal? 2 2))
  #t)

(add-test!
  "Multiple expression begin evaluates body correctly?"
  (begin
    #f
    (equal? 2 2)
    (equal? 2 3)
    (equal? 2 2))
  #t)

(test-results)
