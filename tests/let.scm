(add-test!
  "Let evaluates body correctly?"
  (let ((a #t))
    #f
    (equal? 2 2)
    (equal? 2 3)
    (equal? a #t))
  #t)

(add-test!
  "Let* is evaluated correctly?"
  (let* ((a 2)
	 (b (+ a 2))
	 (c (+ b 2)))
    (+ b c ))
  10)

(test-results)
