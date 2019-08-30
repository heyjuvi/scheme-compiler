(define mad-true (lambda (consequence alternative) (consequence)))(define mad-false (lambda (consequence alternative) (alternative)))

(define (mad-if boolean consequence alternative)
  (boolean consequence alternative))

(define (mad-cons x y)
  (lambda (m)
    (mad-if m
      (lambda () x)
      (lambda () y))))
(define (mad-car z) (z mad-true))
(define (mad-cdr z) (z mad-false))

(define mad-pair (mad-cons 23 42))

(mad-cdr mad-pair)

(display "12345678910111213141516")

