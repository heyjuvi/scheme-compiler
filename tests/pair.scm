(define pairs-are-equal
  (equal? (cons 2 3) (cons 2 3)))

(display "Pair equality works?")
(display pairs-are-equal)
(newline)

(define lists-are-equal
  (equal? (list 2 3) (list 2 3)))

(display "List equality works?")
(display lists-are-equal)
(newline)

(and pairs-are-equal
     lists-are-equal)

