(define bool-is-bool
  (and (boolean? #t) (boolean? #f)))

(display "Bool is identified as such?")
(display bool-is-bool)
(newline)

(define no-bool-is-no-bool
  (not (boolean? 'some-symbol)))

(display "Symbol is not identified as boolean?")
(display no-bool-is-no-bool)
(newline)

(and bool-is-bool
     no-bool-is-no-bool)

