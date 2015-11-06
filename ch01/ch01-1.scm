

(define (ds ex)
  (display ex)
  (newline))
; 1.1.2 Naming and the environment

(define size 2)
; (display size)
; (newline)
; (display (* 5 size))
; (newline)

; the memory of name -> value mappings is called the _global environment_

;1.1.4 Compount Procedures
(define (square x) (* x x))
; (define (<name> <formal paramaters>) <body>)
; (display (square 21))
; (newline)
; (display (square (+ 2 5)))
; (newline)
; (display (square (square 3)))
; (newline)
;
(define (sum-of-squares x y)
  (+ (square x) (square y)))
; (ds (sum-of-squares 3 4))
(define (f a)
  (sum-of-squares (+ a 1) (* a 2)))
; (ds (f 5))
;-------------------

; 1.1.6 Conditional Expressions and Predicates
(define (abs x)
  (cond ((> x 0) x)
        ((= x0) 0)
        ((< x 0) (- x))))
; (cond (<predicate clause> <consequent expression>))
; better?
(define (abs x)
  (cond ((< x 0) (- x))
        (else x)))
; even better?
(define (abs x)
  (if (< x 0) ; predicate
      (- x) ; consequent
      x)) ; alternative

; logical composition operations
; These are special forms, nor procedures
; because sub expressions are not necessaily all evaluated
; (and e1 ... en)
; (or e1 ... en)
; Not is a procedure
; (not e)
; (ds 
;   ((lambda (x) 
;     (and (> x 5) (< x 10)))
;    6))
(define (>= x y)
  (or (> x y) (= x y)))
; (ds (>= 5 5))
; better?
(define (>= x y)
  (not (< x y)))
; (ds (>= 5 5))



; -------------------------------------
; EXERCISE 1.1
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
;----------------------------------------------



;1.1.7 Newtons method
(define (sqrt-iter guess x)
  (if (good-enough? guess x) ;wishful
    guess
    (sqrt-iter (improve guess x) ;thinking
               x)))

(define (average x y)
  (/ (+ x y) 2.0))

(define (improve guess x)
  (average guess (/ x guess)))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001)) ; set our equivalence tolerant

(define (sqrt x)
  (sqrt-iter 1.0 x)) ; start the program with 1 as guess
;; not perfect
; (ds (square (sqrt 1000)))

; ----------------------------------------------------------
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






