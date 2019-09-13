(define (shift-left x n) (arithmetic-shift x n))
(define (shift-right x n) (arithmetic-shift x (* (-1) n)))
(define (bit-or x y) (bitwise-ior x y))
(define (bit-and x y) (bitwise-and x y))

(define (fixnum? x) (integer? x))
(define (fixnum->string x) (number->string x))
(define (fixnum->char x) (integer->char x))

(define (char->fixnum x) (char->integer x))
(define (boolean->fixnum x) (if x 1 0))

(define (char->string x) (list->string (list x)))
(define (boolean->string x) (if x "#t" "#f"))

(define (any->string x)
  (cond
    ((string? x) x)
    ((fixnum? x) (fixnum->string x))
    ((char? x) (char->string x))
    ((boolean? x) (boolean->string x))
    ((null? x) "()")))

(define (caddddr x) (list-ref x 4))
