; Ex 1.1
(define (ds x)
  (display x)
  (newline))
(ds 
  (or
    (= 10 10)
    (= (+ 5 3 4) 12)
    (= (- 9 1) 8)
    (= (/ 6 2) 3)
    (= (+ (* 2 4) (- 4 6)
       6))
    ))
(define a 3) ; a->3
(define b (+ a 1)) ;b->4
(ds (or
      (= a 3)
      (= b 4)
      (= (+ a b (* a b)) 19)
      (= (= a b) #f)
      (= (if (and (> b a) (< b (* a b)))
           b
           a)
         4)
      (= (cond ((= a 4) 6) ;false
               ((= b 4) (+ 6 7 a)) ;true 16
               (else 25))
         16)
      (= (+ 2 (if (< b a) b a))
         6)
      (= (* (cond ((> b a) a)
                  ((< a b) b)
                  (else -1))
            (+ a 1))
         12)
      ))
;ex 1.2
(ds
  (/
    (+ 5 4 (- 2 
              (- 3 
                 (+ 6 (/ 4 5)))))
    (* 3 (- 6 2) (- 2 7))
    ))
; ex 1.3
(define (square x) (* x x))
(define (sum-squares x y)
  (+ (square x) (square y)))
(define (two-largest-of-three a b c)
  (cond ((and (> a c) (> b c)) (cons a b))
        ((and (> a b) (> c b)) (cons a c))
        (else (cons b c))))
(define (sum-square-two-largest-of-three a b c)
  (let ((two-largest (two-largest-of-three a b c)))
    (+ (square (car two-largest))
       (square (cdr two-largest)))))
(ds (or
      (= (sum-square-two-largest-of-three 0 2 3)
         13)))
; ex 1.4 TODO
; we can use conditionals to determine operators
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))
(ds (=
      (a-plus-abs-b 1 1) 
      (a-plus-abs-b 1 -1)))

; ex 1.5
; because this procesure is evaluted with applicative-order,
; --that is each operand is evalutated first, then the operator
; the evaluation never terminates
; as (p) keeps expanding to (p)
; (define (p) (p))
; (define (test x y)
;   (if (= x 0)
;     0
;     y))
; (ds ((test 0 (p) 2)))

;; ex 1.6
; let's define a new if
(define (new-if predicate then-clause else-clause)
  (display "predicate: ")
  (ds predicate)
  (cond (predicate then-clause)
        (else else-clause)))

(define (average x y)
  (/ (+ x y) 2.0))

(define (improve guess x)
  (average guess (/ x guess)))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001)) ; set our equivalence tolerant

; because of applicative order, both arguments are evaluated
; (define (sqrt-iter guess x)
;   (new-if (good-enough? guess x)
;           guess
;           (sqrt-iter (improve guess x)
;           x)))
; (ds (new-if (= 1 0) 't 'f))
; (ds (sqrt-iter 1 9))

