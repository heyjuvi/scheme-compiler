(define (add2 x) (add1 (add1 x)))
(define (pow b e)
  (if (equal? e 0)
    1
    (* b (pow b (sub1 e)))))
(define (highest-exponent x)
  (if (>= x 10)
    (add1 (highest-exponent (/ x 10)))
    0))

(define roman-letters (list "I" "V" "X" "L" "C" "D" "M"))

(define (repeat letter n)
  (if (equal? n 0)
    ""
    (string-append letter
		   (repeat letter (sub1 n)))))

(define (fixnum-position->roman x position)
  (let* ((digit (/ x (pow 10 position)))
         (index (* position 2)))
    (cond
      ((equal? digit 4)
       (string-append (list-ref roman-letters index)
                      (list-ref roman-letters (add1 index))))
      ((equal? digit 9)
       (string-append (list-ref roman-letters index)
                      (list-ref roman-letters (add2 index))))
      ((< digit 4)
       (repeat (list-ref roman-letters index) digit))
      ((> digit 4)
       (string-append (list-ref roman-letters (add1 index))
                      (repeat (list-ref roman-letters index)
			      (- digit 5)))))))

(define (fixnum->roman_ x n)
  (if (>= n 0)
    (let* ((digit (/ x (pow 10 n)))
	   (rest (- x (* digit (pow 10 n)))))
      (string-append (fixnum-position->roman x n)
                     (fixnum->roman_ rest (sub1 n))))
    ""))
(define (fixnum->roman x)
  (fixnum->roman_ x (highest-exponent x)))

(add-test!
  "The number 39 should be XXXIX"
  (fixnum->roman 39)
  "XXXIX")
(add-test!
  "The number 246 should be CCXLVI"
  (fixnum->roman 246)
  "CCXLVI")
(add-test!
  "The number 789 should be DCCLXXXIX"
  (fixnum->roman 789)
  "DCCLXXXIX")
(add-test!
  "The number 2421 should be MMCDXXI"
  (fixnum->roman 2421)
  "MMCDXXI")
(add-test!
  "The number 160 should be CLX"
  (fixnum->roman 160)
  "CLX")
(add-test!
  "The number 207 should be CCVII"
  (fixnum->roman 207)
  "CCVII")
(add-test!
  "The number 1009 should be MIX"
  (fixnum->roman 1009)
  "MIX")
(add-test!
  "The number 1066 should be MLXVI"
  (fixnum->roman 1066)
  "MLXVI")
(add-test!
  "Book held by the statue of liberty has MDCCLXXVI on it"
  (fixnum->roman 1776)
  "MDCCLXXVI")
(add-test!
  "MCMLIV is in the trailer of 'The Last Time I Saw Paris'"
  (fixnum->roman 1954)
  "MCMLIV")
(add-test!
  "Year of the the XXII Olympic Winter Games is MMXIV"
  (fixnum->roman 2014)
  "MMXIV")
(add-test!
  "The current year is MMXIX"
  (fixnum->roman 2019)
  "MMXIX")

(test-results)
