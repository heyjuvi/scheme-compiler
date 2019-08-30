(import chicken.format)

(define label-counter 0)
(define (unique-label str)
  (set! label-counter (add1 label-counter))
  (format "~A_l~A" str label-counter))

(define var-counter 0)
(define (unique-var)
  (set! var-counter (add1 var-counter))
  (format "%tmp~A" var-counter))

(define (emit-return str)
  (puts (format "  ret i64 ~A" str)))

(define (emit-alloca var)
  (puts (format "  ~A = alloca i64, align 8" var)))

(define (emit-copy to from)
  (puts (format "  ~A = add i64 ~A, 0" to from)))

(define (emit-store from in)
  (puts (format "  store i64 ~A, i64* ~A" from in)))

(define (emit-load to from)
  (puts (format "  ~A = load i64, i64* ~A" to from)))

(define (emit-cmp cond x y var)
  (puts (format "  ~A = icmp ~A i64 ~A, ~A" var cond x y)))

(define (emit-label label)
  (puts (format "~A:" label)))

(define (emit-br1 x)
  (puts (format "  br label %~A" x)))

(define (emit-br2 test conseq altern)
  (puts (format "  br i1 ~A, label %~A, label %~A" test conseq altern)))

(define (emit-call0 callee var)
  (puts (format "  ~A = call i64 @~A()" var callee)))

(define (emit-call1 callee x var)
  (puts (format "  ~A = call i64 @~A(i64 ~A)" var callee x)))

(define (emit-call2 callee x y var)
  (puts (format "  ~A = call i64 @~A(i64 ~A, i64 ~A)" var callee x y)))

(define (emit-call3 callee x y z var)
  (puts (format "  ~A = call i64 @~A(i64 ~A, i64 ~A, i64 ~A)" var callee x y z)))
