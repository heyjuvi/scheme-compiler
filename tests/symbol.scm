(add-test!
  "Symbol equality works?"
  (equal? 'some-symbol 'some-symbol)
  #t)

(add-test!
  "Symbol inequality works?"
  (equal? 'some-symbol 'some-other-symbol)
  #f)

(add-test!
  "Symbol equality still works?"
  (equal? 'some-other-symbol 'some-other-symbol)
  #t)

(add-test!
  "Identical quoted lists equality works?"
  (equal? '(a b c) '(a b c))
  #t)

(add-test!
  "Empty lists equality works?"
  (equal? '() '())
  #t)

(add-test!
  "Quoted list and list of symbols is the same?"
  '(a b c)
  (list 'a 'b 'c))

(add-test!
  "Quoted lists inequality works?"
  (equal? '(a b c) '(a b c d))
  #f)

(add-test!
  "Quasiquote works?"
  `(2 ,(+ 2 2))
  '(2 4))

(add-test!
  "Nested quasiquote works?"
  `(`(+ 2 2) ,`(2 ,(+ 2 2)))
  '(`(+ 2 2) (2 4)))

(add-test!
  "Symbol is identified as such?"
  (symbol? 'hi-im-a-symbol)
  #t)

(add-test!
  "Bool is not identified as symbol?"
  (symbol? #t)
  #f)

(test-results)
