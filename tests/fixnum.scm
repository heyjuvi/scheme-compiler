(define fixnum-is-fixnum
  (fixnum? 23))

(display "Fixnum is identified as such?")
(display fixnum-is-fixnum)
(newline)

(define no-fixnum-is-no-fixnum
  (not (fixnum? "this is a string")))

(display "String is not identified as fixnum?")
(display no-fixnum-is-no-fixnum)
(newline)

(define fixnum-equality-works
  (equal? 42 42))

(display "Fixnum equality works?")
(display fixnum-equality-works)
(newline)

(define fixnum-inequality-works
  (not (equal? 23 42)))

(display "Fixnum inequality works?")
(display fixnum-inequality-works)
(newline)

(define char-to-fixnum-conversion-works
  (equal? (char->fixnum #\A) 65))

(display "Char to fixnum conversion works?")
(display char-to-fixnum-conversion-works)
(newline)

(and (and (and fixnum-is-fixnum
              no-fixnum-is-no-fixnum)
          (and fixnum-equality-works
               fixnum-inequality-works))
     char-to-fixnum-conversion-works)

