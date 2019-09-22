(define width 64)

(define passed-text " passed")
(define failed-text " failed")

(define (display-n-times str n)
  (if (eq? n 0)
    #t
    (begin
      (display str)
      (display-n-times str (sub1 n)))))

(define (show-description description)
  (let ((padding (- width
		    (+ (string-length description)
		       (string-length passed-text)))))
    (display description)
    (display-n-times " " padding)))

(define (show-result result expected)
  (if (equal? result expected)
    (display passed-text)
    (display failed-text)))

(define tests '())
(define overall-result #t)

(define (add-test! description result expected)
  (set! tests
    (cons (list description result expected) tests))
  (set! overall-result
    (and (equal? result expected) overall-result)))

(define (show-test-results tests-lst)
  (if (eq? tests-lst '())
    #t
    (let* ((test (car tests-lst))
	   (description (list-ref test 0))
	   (result (list-ref test 1))
	   (expected (list-ref test 2)))
      (show-test-results (cdr tests-lst))
      (show-description description)
      (show-result result expected)
      (newline))))

(define (test-results)
  (show-test-results tests)
  (newline)
  overall-result)

