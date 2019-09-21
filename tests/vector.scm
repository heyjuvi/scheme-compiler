(define v (vector-init 2))

(add-test!
  "Vector is zero-initialized?"
  (cons (vector-ref v 0)
        (vector-ref v 1))
  (cons 0 0))

(vector-set! v 0 2)
(vector-set! v 1 3)

(add-test!
  "Vector elements have been set correctly?"
  (cons (vector-ref v 0)
        (vector-ref v 1))
  (cons 2 3))

(define some-vector (vector 23 42 1337))

(add-test!
  "Creating a filled vector works?"
  (list (vector-ref some-vector 0)
        (vector-ref some-vector 1)
        (vector-ref some-vector 2))
  (list 23 42 1337))

(vector-set! some-vector 0 1337)
(vector-set! some-vector 2 23)

(add-test!
  "The filled vector can be changed?"
  (list (vector-ref some-vector 0)
        (vector-ref some-vector 1)
        (vector-ref some-vector 2))
  (list 1337 42 23))

(define single-vector (vector 42))

(add-test!
  "Single element vector works?"
  (vector-ref single-vector 0)
  42)

(vector-set! single-vector 0 23)

(add-test!
  "Single element vector can be changed?"
  (vector-ref single-vector 0)
  23)

(test-results)
