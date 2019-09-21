(define my-source
  (open-input-file "../tests/io.scm"))

(add-test!
  "Reading my source, is the read content correct?"
  (and (eq? (read-char my-source) #\()
       (eq? (read-char my-source) #\d)
       (eq? (read-char my-source) #\e)
       (eq? (read-char my-source) #\f)
       (eq? (read-char my-source) #\i))
  #t)

(define (find-eof-object n)
  (let ((char (read-char my-source)))
    (if (eof-object? char)
      #t
      (if (equal? n 0)
        #f
        (find-eof-object (sub1 n))))))

(add-test!
  "Found the eof object?"
  (find-eof-object 2000)
  #t)

(test-results)
