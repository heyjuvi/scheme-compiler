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

(define pair-is-pair
  (pair? (cons 23 42)))

(display "Pair is identified as such?")
(display pair-is-pair)
(newline)

(define no-pair-is-no-pair
  (not (pair? 23)))

(display "Fixnum is not identified as pair?")
(display no-pair-is-no-pair)
(newline)

(define list-is-pair
  (pair? (list 23 42)))

(display "List is identified as pair?")
(display list-is-pair)
(newline)

(define list-is-list
  (list? (list 23 42)))

(display "List is identified as such?")
(display list-is-list)
(newline)

(define no-list-is-no-list
  (not (list? "yet another string")))

(display "String is not identified as list?")
(display no-list-is-no-list)
(newline)

(define pair-is-no-list
  (not (list? (cons 23 42))))

(display "Pair is not identified as list?")
(display pair-is-no-list)
(newline)

(define empty-list-is-null
  (null? '()))

(display "Empty list is identified as such?")
(display empty-list-is-null)
(newline)

(and (and pairs-are-equal
          lists-are-equal)
     (and (and (and pair-is-pair
	            no-pair-is-no-pair)
	       list-is-pair)
	  (and (and list-is-list
	            no-list-is-no-list)
               (and pair-is-no-list
		    empty-list-is-null))))

