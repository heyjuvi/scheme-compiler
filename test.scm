(define (calc f n)
  (if (equal? n 1)
    1
    (f n (calc f (- n 1)))))

(define (add x y) (+ x y))
(define (mul x y) (* x y))

(calc add 100000)
