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
  (equal? `(2 ,(+ 2 2)) '(2 2)))

(display "Quasiquote works?")
(display quasiquote-works)
(newline)

(and (and symbols-are-equal
          symbols-are-not-equal)
     (and quoted-lists-are-equal
	  quoted-lists-are-not-equal))

