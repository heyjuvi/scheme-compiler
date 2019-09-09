(define fixnum-is-fixnum
  (fixnum? 23))

(display "Fixnum is identified as such?")
(display fixnum-is-fixnum)
(newline)

(define no-fixnum-is-no-fixnum
  (not (fixnum? "this is a string")))

(display "String is not identified as fixnum?")
(display no-fixnum-is-no-fixnum)
(newline)

(and fixnum-is-fixnum
     no-fixnum-is-no-fixnum)
