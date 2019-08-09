(let ((bool1 (equal? (car (cons 2 3)) 3))
      (bool2 #f))
  (if bool1 1
    (if bool2 2 3))
  10)
20
