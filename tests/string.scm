(add-test!
  "String equality works?"
  (equal? "strings are equal" "strings are equal")
  #t)

(add-test!
  "String inequality works?"
  (equal? "strings are not equal" "strings are equal")
  #f)

(add-test!
  "Strings are correctly appended?"
  (string-append "appending strings" " works")
  "appending strings works")

(add-test!
  "Strings are still correctly appended? (intact heap)"
  (string-append "appending strings" " still works")
  "appending strings still works")

(add-test!
  "Getting string elements works?"
  (cons (string-ref "hello" 0)
        (string-ref "hello" 4))
  (cons #\h #\o))

(define (own-append lst1 lst2)
  (if (null? lst1)
    lst2
    (cons (car lst1) (own-append (cdr lst1) lst2))))

(define (own-length lst)
  (if (null? lst)
    0
    (add1 (own-length (cdr lst)))))

(define (own-reverse lst)
  (if (null? lst)
    '()
    (own-append (own-reverse (cdr lst)) (list (car lst)))))

(define (own-string->list_ str n)
  (if (eq? n 0)
    (cons (string-ref str n) '())
    (cons (string-ref str n) (own-string->list_ str (sub1 n)))))
(define (own-string->list str)
  (own-reverse (own-string->list_ str (sub1 (string-length str)))))

(add-test!
  "String to list works?"
  (own-string->list "abc")
  (list #\a #\b #\c))

(add-test!
  "String is identified as such?"
  (string? "abcdefghijklmnopqrstuvxyz")
  #t)

(add-test!
  "Empty list is not identified as string?"
  (string? '())
  #f)

(test-results)
