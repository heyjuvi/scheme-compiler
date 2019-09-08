(define f
  (lambda (c)
    (cons (lambda (v) (set! c v))
          (lambda () c))))

(define p (f 0))

((car p) 12)
(define first-val ((cdr p)))
((car p) 23)
(define second-val ((cdr p)))

(define remembering-set-values-inside-lambda-works
  (and (equal? first-val 12) (equal? second-val 23)))

(display "Remembering set values inside a lambda works?")
(display remembering-set-values-inside-lambda-works)
(newline)

(define set-inside-let-works
  (let ((x #f))
    (set! x #t)
    x))

(display "Set inside let works?")
(display set-inside-let-works)
(newline)

(define some-global-var 0)
(define (set-some-global-var x)
  (set! some-global-var x))

(set-some-global-var 23)

(define setting-global-var-works
  (equal? some-global-var 23))

(display "Setting a global variable works?")
(display setting-global-var-works)
(newline)

(and (and remembering-set-values-inside-lambda-works
          set-inside-let-works)
     setting-global-var-works)

