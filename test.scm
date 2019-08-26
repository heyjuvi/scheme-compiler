(let ((bool1 (equal? (car (cons 2 3)) 3))
      (bool2 #f))
  (if bool1 1
    (if bool2 2 3))
  10)
20
(car (cdr (cons 1 (cons 2 (cons 3 '())))))
(list-ref (cons 1 (cons 2 (cons 3 '()))) 2)

;((lambda (x) (+ x 1)) 2)
(lambda (y) (lambda (x) (+ x y)))
