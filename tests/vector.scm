(define v (vector-init 2))

(define is-zero-initialized
  (and (equal? (vector-ref v 0) 0)
       (equal? (vector-ref v 1) 0)))

(display "Vector is zero-initialized?")
(display is-zero-initialized)
(newline)

(vector-set! v 0 2)
(vector-set! v 1 3)

(define has-been-set-correctly
  (and (equal? (vector-ref v 0) 2)
       (equal? (vector-ref v 1) 3)))

(display "Vector elements have been set correctly?")
(display has-been-set-correctly)
(newline)

(define some-vector (vector 23 42 1337))
(define creating-filled-vector-works
  (and (equal? (vector-ref some-vector 0) 23)
       (equal? (vector-ref some-vector 2) 1337)))

(display "Creating a filled vector works?")
(display creating-filled-vector-works)
(newline)

(vector-set! some-vector 0 1337)
(vector-set! some-vector 2 23)

(define filled-vector-can-be-changed
  (and (equal? (vector-ref some-vector 0) 1337)
       (equal? (vector-ref some-vector 2) 23)))

(display "The filled vector can be changed?")
(display filled-vector-can-be-changed)
(newline)

(define single-vector (vector 42))
(define single-element-vector-works
  (equal? (vector-ref single-vector 0) 42))

(display "Single element vector works?")
(display single-element-vector-works)
(newline)

(vector-set! single-vector 0 23)

(define single-element-vector-can-be-changed
  (equal? (vector-ref single-vector 0) 23))

(display "Single element vector can be changed?")
(display single-element-vector-can-be-changed)
(newline)

(and (and is-zero-initialized
          has-been-set-correctly)
     (and (and creating-filled-vector-works
	       filled-vector-can-be-changed)
	  (and single-element-vector-works
	       single-element-vector-can-be-changed)))
