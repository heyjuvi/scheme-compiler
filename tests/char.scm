(add-test!
  "Char is identified as such?"
  (and (char? #\a) (char? #\b))
  #t)

(add-test!
  "Fixnum is not identified as char?"
  (char? 32)
  #f)

(add-test!
  "Char equality works?"
  (equal? #\a #\a)
  #t)

(add-test!
  "Char inequality works?"
  (equal? #\a #\b)
  #f)

(test-results)
