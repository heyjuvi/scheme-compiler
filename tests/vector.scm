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

(and is-zero-initialized
     has-been-set-correctly)
