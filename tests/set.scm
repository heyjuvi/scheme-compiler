(define f
  (lambda (c)
    (cons (lambda (v) (set! c v))
          (lambda () c))))

(define p (f 0))

((car p) 23)

(add-test!
  "Remembering set values inside a lambda works?"
  ((cdr p))
  23)

(add-test!
  "Set inside let works?"
  (let ((x #f))
    (set! x #t)
    x)
  #t)

(define some-global-var 0)

(add-test!
  "Setting a global variable works?"
  (begin
    (set! some-global-var 23)
    some-global-var)
  23)

(test-results)
