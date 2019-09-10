(define (shift-left x n) (arithmetic-shift x n))
(define (shift-right x n) (arithmetic-shift x (* (-1) n)))
(define (bit-or x y) (bitwise-ior x y))
(define (bit-and x y) (bitwise-and x y))

(define (fixnum? x) (integer? x))
(define (fixnum->string x) (number->string x))
(define (fixnum->char x) (integer->char x))

(define (char->fixnum x) (char->integer x))
(define (boolean->fixnum x) (if x 1 0))

(define (caddddr x) (list-ref x 4))
