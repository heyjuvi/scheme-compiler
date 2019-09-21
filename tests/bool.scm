(add-test!
  "Bool is identified as such?"
  (and (boolean? #t) (boolean? #f))
  #t)

(add-test!
  "Symbol is not identified as boolean?"
  (boolean? 'some-symbol)
  #f)

(add-test!
  "Negating 'hi' yields false?"
  (not "hi")
  #f)

(test-results)
