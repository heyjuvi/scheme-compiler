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

(define quoted-lists-are-equal
  (equal? '(a b c) (list 'a 'b 'c)))

(display "Quoted lists equality works?")
(display quoted-lists-are-equal)
(newline)

(define quoted-lists-are-not-equal
  (equal? '(a b c) '(a b c d)))

(display "Quoted lists inequality works?")
(display quoted-lists-are-not-equal)
(newline)

(define quasiquote-works
  (equal? `(2 ,(+ 2 2)) '(2 4)))

(display "Quasiquote works?")
(display quasiquote-works)
(newline)

(display (car (cdr `(2 ,(+ 2 2)))))
(display (car (cdr '(2 4))))

(define nested-quasiquote-works
  (equal? `(`(+ 2 2) ,`(2 ,(+ 2 2)))
	  '(`(+ 2 2) (2 4))))

(display "Nested quasiquote works?")
(display nested-quasiquote-works)
(newline)

(and (and symbols-are-equal
          symbols-are-not-equal)
     (and (and quoted-lists-are-equal
	       quoted-lists-are-not-equal)
	  (and quasiquote-works
	       nested-quasiquote-works)))

