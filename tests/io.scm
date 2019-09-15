(define my-source
  (open-input-file "../tests/io.scm"))

(define content-is-correct
  (and (eq? (read-char my-source) #\()
       (and (eq? (read-char my-source) #\d)
            (and (eq? (read-char my-source) #\e)
                 (and (eq? (read-char my-source) #\f)
		      (eq? (read-char my-source) #\i))))))

(display "Reading my source, is the read content correct?")
(display content-is-correct)
(newline)

(define (find-eof-object n)
  (let ((char (read-char my-source)))
    (if (eof-object? char)
      #t
      (if (equal? n 0)
        #f
        (find-eof-object (sub1 n))))))
(define found-eof-object
  (find-eof-object 2000))

(display "Found the eof object?")
(display found-eof-object)
(newline)

(and content-is-correct
     found-eof-object)
