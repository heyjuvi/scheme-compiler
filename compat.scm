(import chicken.bitwise)
(import chicken.format)

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

(define (puts str) (print str))
