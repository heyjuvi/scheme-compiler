(define bool-is-bool
  (and (bool? #t) (bool? #f)))

(display "Bool is identified as such?")
(display bool-is-bool)
(newline)

(define no-bool-is-no-bool
  (not (bool? 'some-symbol)))

(display "Symbol is not identified as bool?")
(display no-bool-is-no-bool)
(newline)

(and bool-is-bool
     no-bool-is-no-bool)

