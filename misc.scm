(define dbg-enabled #f)

(define (debug x) (if dbg-enabled (display x) 'no-debugging))
(define (debug-newline) (if dbg-enabled (newline) 'no-debugging))

(define (puts str) (if (not dbg-enabled) (print str) 'debugging))

(define (take lst n)
  (cond
    ((equal? n 0) '())
    ((null? lst) '())
    (else (cons (car lst) (take (cdr lst) (sub1 n))))))
(define (drop lst n)
  (cond
    ((equal? n 0) lst)
    ((null? lst) '())
    (else (drop (cdr lst) (sub1 n)))))

(define (indexed-map_ f l i)
  (if (null? l)
    '()
    (cons (f i (car l))
          (indexed-map_ f (cdr l) (add1 i)))))
(define (indexed-map f l)
  (indexed-map_ f l 0))

(define (element? e x)
  (cond
    ((null? x) #f)
    ((eq? e (car x)) #t)
    (else (element? e (cdr x)))))
(define (set-union x y)
  (cond
    ((and (null? x) (null? y)) '())
    ((null? x) y)
    ((null? y) x)
    ((element? (car x) y) (set-union (cdr x) y))
    (else (set-union (cdr x) (cons (car x) y)))))
(define (set-union-many x)
  (cond
    ((null? x) '())
    ((equal? (length x) 1) (car x))
    (else (set-union (car x) (set-union-many (cdr x))))))
(define (set-substract x y)
  (filter (lambda (z) (not (element? z y))) x))

(define (extend-env var val env)
  (debug "EXTEND-ENV var = ") (debug var) (debug-newline)
  (debug "EXTEND-ENV val = ") (debug val) (debug-newline)
  (cons (cons var val) env))
(define (extend-env-many vars vals env)
  (if (null? vars)
    env
    (extend-env-many
      (cdr vars)
      (cdr vals)
      (extend-env (car vars) (car vals) env))))

