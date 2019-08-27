(import chicken.bitwise)
(import chicken.format)
(import srfi-1)

(define dbg-enabled #f)
(define tests-enabled #f)

(define (debug x) (if dbg-enabled (display x) 'no-debugging))
(define (debug-newline) (if dbg-enabled (newline) 'no-debugging))

(define (puts str) (if (not dbg-enabled) (print str) 'debugging))

(define (shift-left x n) (arithmetic-shift x n))
(define (shift-right x n) (arithmetic-shift x (* (-1) n)))
(define (bit-or x y) (bitwise-ior x y))
(define (bit-and x y) (bitwise-and x y))

(define (fixnum? x)
  (cond
    ((integer? x) #t)
    (else #f)))
(define (fixnum->string x) (number->string x))
(define (fixnum->char x) (integer->char x))

(define (bool->fixnum x) (if x 1 0))

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
