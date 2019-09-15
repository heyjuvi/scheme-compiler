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

(define string-ref-works
  (and (equal? (string-ref "hello" 0) #\h)
       (equal? (string-ref "hello" 4) #\o)))

(display "Getting string elements works?")
(display string-ref-works)
(newline)

(define (append lst1 lst2)
  (if (null? lst1)
    lst2
    (cons (car lst1) (append (cdr lst1) lst2))))

(define (length lst)
  (if (null? lst)
    0
    (add1 (length (cdr lst)))))

(define (reverse lst)
  (if (null? lst)
    '()
    (append (reverse (cdr lst)) (list (car lst)))))

(define (string->list_ str n)
  (if (eq? n 0)
    (cons (string-ref str n) '())
    (cons (string-ref str n) (string->list_ str (sub1 n)))))
(define (string->list str)
  (reverse (string->list_ str (sub1 (string-length str)))))

(define string-to-list-works
  (equal? (string->list "abc") (list #\a #\b #\c)))

(display "String to list works?")
(display string-to-list-works)
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
	  (and (and string-ref-works
		    string-to-list-works)
	       (and string-is-string
	            no-string-is-no-string))))

