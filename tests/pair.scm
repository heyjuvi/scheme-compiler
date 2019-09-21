(add-test!
  "Pair equality works?"
  (equal? (cons 2 3) (cons 2 3))
  #t)

(add-test!
  "List equality works?"
  (equal? (list 2 3) (list 2 3))
  #t)

(add-test!
  "Pair is identified as such?"
  (pair? (cons 23 42))
  #t)

(add-test!
  "Fixnum is not identified as pair?"
  (pair? 23)
  #f)

(add-test!
  "List is identified as pair?"
  (pair? (list 23 42))
  #t)

(add-test!
  "List is identified as such?"
  (list? (list 23 42))
  #t)

(add-test!
  "String is not identified as list?"
  (list? "yet another string")
  #f)

(add-test!
  "Pair is not identified as list?"
  (list? (cons 23 42))
  #f)

(add-test!
  "Empty list is identified as such?"
  (null? '())
  #t)

(define (own-reverse_ lst rev)
  (if (null? lst)
    rev
    (own-reverse_ (cdr lst) (cons (car lst) rev))))
(define (own-reverse lst)
  (own-reverse_ lst '()))

(add-test!
  "Reversing a list works? (constructing own reverse)"
  (own-reverse '(1 2 3 4))
  '(4 3 2 1))

(test-results)
