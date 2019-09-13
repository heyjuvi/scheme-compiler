(define (map f lst)
  (if (null? lst)
    '()
    (cons (f (car lst)) (map f (cdr lst)))))

(define (for-each f lst)
  (map f lst)
  'for-each-completed)

(define (append lst1 lst2)
  (if (null? lst1)
    lst2
    (cons (car lst1) (append (cdr lst1) lst2))))

(define (reverse lst)
  (if (null? lst)
    '()
    (append (reverse (cdr lst)) (list (car lst)))))

(define (iota_ n)
  (if (equal? n 0)
    '()
    (cons (sub1 n) (iota_ (sub1 n)))))
(define (iota n)
  (reverse (iota_ n)))

(define (format_ str-lst lst)
  (if (< (length str-lst) 2)
    str-lst
    (let ((first-char (car str-lst))
	  (second-char (cadr str-lst))
	  (rest-str-lst (cddr str-lst)))
      (if (and (equal? first-char #\~)
	       (or (equal? second-char #\A)
		   (equal? second-char #\a)))
        (append (any->string (car lst)) rest-str-lst))
      )))

(define (format str lst)

(define (error str x)
  (display (string-append (string-append str ": ")
	   (format "~A" x)))
  (exit -1))

