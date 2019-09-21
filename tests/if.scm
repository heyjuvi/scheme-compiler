(add-test!
  "If consequence works?"
  (if (equal? 2 2) #t #f)
  #t)

(add-test!
  "If alternative works?"
  (if (equal? 2 3) #t #f)
  #f)

(add-test!
  "Nested ifs work?"
  (let ((x (cons 2 3)))
    (if (equal? 2 3)
      1
      (if (equal? x (cons 2 3))
        2
	3)))
  2)

(test-results)
