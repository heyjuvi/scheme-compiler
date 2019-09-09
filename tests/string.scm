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

(define string-is-string
  (string? "abcdefghijklmnopqrstuvxyz"))

(display "String is identified as such?")
(display string-is-string)
(newline)

(define no-string-is-no-string
  (not (string? '())))

(display "Empty list is not identified as string?")
(display no-string-is-no-string)
(newline)

(and (and strings-are-equal
	  strings-are-not-equal)
     (and (and appending-strings-works
	       appending-strings-still-works)
	  (and string-is-string
	       no-string-is-no-string)))

