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

content-is-correct
