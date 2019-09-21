(add-test!
  "Fixnum is identified as such?"
  (fixnum? 23)
  #t)

(add-test!
  "String is not identified as fixnum?"
  (fixnum? "this is a string")
  #f)

(add-test!
  "Fixnum equality works?"
  (equal? 42 42)
  #t)

(add-test!
  "Fixnum inequality works?"
  (equal? 23 42)
  #f)

(add-test!
  "Char to fixnum conversion works?"
  (char->fixnum #\A)
  65)

;(define unicode-char-to-fixnum-conversion-works
;  (equal? (char->fixnum #\λ) 955))
;
;(display "Unicode char to fixnum conversion works?")
;(display unicode-char-to-fixnum-conversion-works)
;(newline)

(add-test!
  "Bool to fixnum conversion works?"
  (cons (boolean->fixnum #f)
        (boolean->fixnum #t))
  (cons 0 1))

(test-results)
