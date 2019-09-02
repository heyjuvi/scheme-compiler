(define strings-are-equal
  (equal? "strings are equal" "strings are equal"))

(display "String equality works?")
(display strings-are-equal)
(newline)

(define strings-are-not-equal
  (not (equal? "strings are not equal" "strings are equal")))

(display "String inequality works?")
(display strings-are-not-equal)
(newline)

(define appending-strings-works
  (equal? (string-append "appending strings" " works")
	  "appending strings works"))

(display (string-append "appending strings" " works"))
(display "String are correctly appended?")
(display appending-strings-works)
(newline)

(and (and strings-are-equal
	  strings-are-not-equal)
     appending-strings-works)

