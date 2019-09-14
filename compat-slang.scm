(define (map f lst)
  (if (null? lst)
    '()
    (cons (f (car lst)) (map f (cdr lst)))))

(define (filter f lst)
  (if (null? lst)
    '()
    (if (f (car lst))
      (cons (car lst) (filter f (cdr lst)))
      (filter f (cdr lst)))))

(define (assoc x lst)
  (let ((filtered-lst (filter (lambda (p) (equal? x (car p))) lst)))
    (if (eq? filtered-lst '())
      #f
      (car filtered-lst))))

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
  (cond
    ((< (length str-lst) 2) str-lst)
    ((null? lst) str-lst)
    (else
      (let ((first-char (car str-lst))
	    (second-char (cadr str-lst))
	    (rest-str-lst (cddr str-lst)))
        (if (and (equal? first-char #\~)
	         (or (equal? second-char #\A)
		     (equal? second-char #\a)))
          (append (string->list (any->string (car lst)))
	          (format_ rest-str-lst (cdr lst)))
	  (cons (car str-lst)
	        (format_ (cdr str-lst) lst)))))))
(define (format str lst)
  (list->string (format_ (string->list str) lst)))

(define (error str x)
  (display (string-append (string-append str ": ")
	   (format "~A" x)))
  (exit -1))

