((lambda (y) ((lambda (x) (+ x y)) 2)) 2)
(((lambda (y) (lambda (x) (+ x y))) 2) 2)

((lambda (x y) (+ x y)) 2 2)

(cdr ((lambda (x) (cons x 42)) 23))

(((lambda () (lambda (consequence alternative) ((lambda () 1337))))) 1 2)
