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

(display "Strings are correctly appended?")
(display appending-strings-works)
(newline)

(define appending-strings-still-works
  (equal? (string-append "appending strings" " still works")
	  "appending strings still works"))

(display "Strings are still correctly appended? (the heap is intact)")
(display appending-strings-still-works)
(newline)

(and (and strings-are-equal
	  strings-are-not-equal)
     (and appending-strings-works
	  appending-strings-still-works))

