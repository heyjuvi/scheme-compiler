(define (tagged-list? x tag)
  (if (and (list? x) (not (null? x)))
    (eq? (car x) tag)
    #f))

(define (immediate? x)
  (cond
    ((fixnum? x) #t)
    ((char? x) #t)
    ((boolean? x) #t)
    ((null? x) #t)
    (else #f)))

(define (primcall-operator x) (car x))
(define (primcall-operand1 x) (cadr x))
(define (primcall-operand2 x) (caddr x))
(define (primcall? x)
  (if (list? x)
    (let ((op (primcall-operator x)))
      (or
        (eq? op 'add1)
        (eq? op 'sub1)
        (eq? op '+)
        (eq? op '-)
        (eq? op 'equal?)
        (eq? op 'cons)
        (eq? op 'car)
        (eq? op 'cdr)
        (eq? op 'list-ref)))
    #f))

(define (if? x) (tagged-list? x 'if))
(define (if-test x) (cadr x))
(define (if-conseq x) (caddr x))
(define (if-altern x) (cadddr x))

(define (let? x) (tagged-list? x 'let))
(define (let-bindings x) (cadr x))
(define (let-binding-var x) (car x))
(define (let-binding-val x) (cadr x))
(define (let-bindings-vars x)
  (map let-binding-var (let-bindings x)))
(define (let-bindings-vals x)
  (map let-binding-val (let-bindings x)))
(define (let-body x) (cddr x))
(define (make-let bindings body)
  (cons 'let (cons bindings body)))

(define (begin? x) (tagged-list? x 'begin))
(define (begin-body x) (cdr x))
(define (make-begin body)
  (cond
    ((null? body) (error "begin body must not be empty"))
    ((null? (cdr body)) (car body))
    (else (cons 'begin body))))

(define (cond? x) (tagged-list? x 'cond))
(define (cond-clauses x) (cdr x))
(define (cond-clause-test x) (car x))
(define (cond-clause-body x) (cdr x))

(define (function? x) (tagged-list? x 'function))
(define (function-name x) (cadr x))
(define (function-args x) (caddr x))
(define (function-body x) (cdddr x))
(define (function name args body)
  (cons 'function (cons name (cons args body))))

(define (function-name->ll-name x)
  (string-append "function_" x))

(define (lambda? x) (tagged-list? x 'lambda))
(define (lambda-args x) (cadr x))
(define (lambda-body x) (cddr x))

(define (closure? x) (tagged-list? x 'closure))
(define (closure-function x) (cadr x))
(define (closure-arity x) (caddr x))
(define (closure-free-vars x) (cadddr x))
(define (closure name arity free-vars)
  (list 'closure name arity free-vars))

(define (args-signature n)
  (cond
    ((eq? n 0) "")
    ((eq? n 1) "i64")
    (else (string-append "i64, "
			 (args-signature (- n 1))))))

(define (var? x) (symbol? x))
(define (local-var? x) (eq? (string-ref x 0) #\%))
(define (global-var? x) (eq? (string-ref x 0) #\%))
(define (make-local-var str) (string-append "%" str))
(define (make-global-var str) (string-append "@" str))

(define (quote? x) (tagged-list? x 'quote))

(define (quasiquote? x) (tagged-list? x 'quasiquote))
(define (unquote? x) (tagged-list? x 'unquote))

