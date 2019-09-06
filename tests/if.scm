(define if-consequence-works
  (if (equal? 2 2) #t #f))

(display "If consequence works?")
(display if-consequence-works)
(newline)

(define if-alternative-works
  (if (equal? 2 3) #f #t))

(display "If alternative works?")
(display if-alternative-works)
(newline)

(define nested-ifs-work
  (let ((x (cons 2 3)))
    (equal?
      (if (equal? 2 3)
        1
        (if (equal? x (cons 2 3))
          2
	  3))
      2)))

(display "Nested ifs work?")
(display nested-ifs-work)
(newline)

(and (and if-consequence-works
	  if-alternative-works)
     nested-ifs-work)

