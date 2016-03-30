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



; 1.2 Procedures and the processes they generate

; a linear recursive process for computing 6!
(define (factorial n)
  (if (= 1 n)
    1
    (* n (factorial n-1))))

; here's the iterative version, even though it is recursively defined
(define (factorial n)
  (fact-iter 1 1 n))

; ah, now we can save a count
(define (fact-iter product counter max-count)
  (if (> counter max-count)
    product
    (fact-iter (* counter product)
               (+ counter 1)
               max-count)))

(ds (= (factorial 3) 6))

; in general, iterative process is one whose state can be 
; summarized by a fixed number of state variables

; tail recursion will allow us to make recursive iterations in constant space

; ITERATION vs RECURSION
; iteration a system that has all of its state in explicit variables

(define (-1+ x)
  (- x 1))
(define (1+ x)
  (+ x 1))

; iterative
(define (sumitr x y)
  (if (= x 0)
    y
    (sumitr (-1+ x) (1+ y))))
;; this has a time complexity O(x)
;; this has a space complexity O(1)

; linear recursion 
(define (sumrec x y)
  (if (= x 0)
    y
    (1+ (+ (-1+ x) y))))
; this has a time complexity of O(x)
; but has a space complexity of O(x)
; proportional to the input argument in time and space


