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

(define has-correct-values
  (and (equal? (own-car own-pair) 23)
       (equal? (own-cdr own-pair) 42)))

(display "Nested lambdas work? (constructing own cons, car and cdr)")
(display has-correct-values)
(newline)

(define display-inside-lambda
  (lambda ()
    (display "Does it compile?")
    #f
    #t))
(define display-inside-lambda-works
  (display-inside-lambda))

(display "Display call inside a lambda works?")
(display display-inside-lambda-works)
(newline)

(define inline-lambda-works
  (equal? ((lambda (x) (+ x 2)) 2) 4))

(display "Inline lambda works?")
(display inline-lambda-works)
(newline)

(define (own-map f lst)
  (if (null? lst)
    '()
    (cons (f (car lst)) (own-map f (cdr lst)))))

(define mapped-values-are-correct
  (equal? (own-map (lambda (x) (* x 2)) '(1 2 3 4))
	  '(2 4 6 8)))

(display "Mapped values are correct? (constructing own map)")
(display mapped-values-are-correct)
(newline)

(and (and has-correct-values
          display-inside-lambda-works)
     (and inline-lambda-works
	  mapped-values-are-correct))
