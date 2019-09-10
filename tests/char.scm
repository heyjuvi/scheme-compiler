(define char-is-char
  (and (char? #\a) (char? #\b)))

(display "Char is identified as such?")
(display char-is-char)
(newline)

(define no-char-is-no-char
  (not (char? 32)))

(display "Fixnum is not identified as char?")
(display no-char-is-no-char)
(newline)

(define char-equality-works
  (equal? #\a #\a))

(display "Char equality works?")
(display char-equality-works)
(newline)

(define char-inequality-works
  (not (equal? #\a #\b)))

(display "Char inequality works?")
(display char-inequality-works)
(newline)

(and char-is-char
     no-char-is-no-char)

