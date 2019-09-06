(define symbols-are-equal
  (equal? 'some-symbol 'some-symbol))

(display "Symbol equality works?")
(display symbols-are-equal)
(newline)

(define symbols-are-not-equal
  (not (equal? 'some-symbol 'some-other-symbol)))

(display "Symbol inequality works?")
(display symbols-are-not-equal)
(newline)

(define symbols-are-still-equal
  (equal? 'some-other-symbol 'some-other-symbol))

(display "Symbol equality still works?")
(display symbols-are-still-equal)
(newline)

(define identical-quoted-lists-are-equal
  (equal? '(a b c) '(a b c)))

(display "Identical quoted lists equality works?")
(display identical-quoted-lists-are-equal)
(newline)

(define empty-lists-are-equal
  (equal? '() '()))

(display "Empty lists equality works?")
(display empty-lists-are-equal)
(newline)

(define quoted-lists-are-equal
  (equal? '(a b c) (list 'a 'b 'c)))

(display "Quoted lists equality works?")
(display quoted-lists-are-equal)
(newline)

(define quoted-lists-are-not-equal
  (not (equal? '(a b c) '(a b c d))))

(display "Quoted lists inequality works?")
(display quoted-lists-are-not-equal)
(newline)

(define quasiquote-works
  (equal? `(2 ,(+ 2 2)) '(2 4)))

(display "Quasiquote works?")
(display quasiquote-works)
(newline)

(define nested-quasiquote-works
  (equal? `(`(+ 2 2) ,`(2 ,(+ 2 2)))
	  '(`(+ 2 2) (2 4))))

(display "Nested quasiquote works?")
(display nested-quasiquote-works)
(newline)

(and (and symbols-are-equal
          (and symbols-are-not-equal
	       symbols-are-still-equal))
     (and (and (and identical-quoted-lists-are-equal
		    empty-lists-are-equal)
               (and quoted-lists-are-equal
	            quoted-lists-are-not-equal))
	  (and quasiquote-works
	       nested-quasiquote-works)))

