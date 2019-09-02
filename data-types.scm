; immediate types

(define fixnum-shift 2)
(define fixnum-tag 0) ; 00b

(define char-shift 8)
(define char-tag 15) ; 00001111b

(define bool-shift 7)
(define bool-tag 31) ; 0011111b

(define empty-list 47) ; 00101111b

(define (immediate-rep x)
  (cond
    ((fixnum? x)
     (bit-or (shift-left x fixnum-shift) fixnum-tag))
    ((char? x)
     (bit-or (shift-left x char-shift) char-tag))
    ((boolean? x)
     (bit-or (shift-left (bool->fixnum x) bool-shift) bool-tag))
    ((null? x)
     empty-list)
    (else (error "no immediate representation"))))

; heap allocated types

(define heap-shift 3)

(define pair-tag 1) ; 001b
(define vector-tag 2) ; 010b
(define string-tag 3) ; 011b
(define symbol-tag 5) ; 101b
(define closure-tag 6) ; 110b
