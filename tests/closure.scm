(define own-true (lambda (consequence alternative) (consequence)))
(define own-false (lambda (consequence alternative) (alternative)))

(define (own-if boolean consequence alternative)
  (boolean consequence alternative))

(define (own-cons x y)
  (lambda (m)
    (own-if m
      (lambda () x)
      (lambda () y))))
(define (own-car z) (z own-true))
(define (own-cdr z) (z own-false))

(define own-pair (own-cons 23 42))

(add-test!
  "Nested lambdas work?"
  (and (equal? (own-car own-pair) 23)
       (equal? (own-cdr own-pair) 42))
  #t)

(define display-inside-lambda
  (lambda ()
    (display "Does it compile?") (newline)
    #f
    #t))
(add-test!
  "Display call inside a lambda works?"
  (display-inside-lambda)
  #t)

(add-test!
  "Inline lambda works?"
  ((lambda (x) (+ x 2)) 2)
  4)

(define (own-map f lst)
  (if (null? lst)
    '()
    (cons (f (car lst)) (own-map f (cdr lst)))))

(add-test!
  "Mapped values are correct? (constructing own map)"
  (own-map (lambda (x) (* x 2)) '(1 2 3 4))
  '(2 4 6 8))

(test-results)
