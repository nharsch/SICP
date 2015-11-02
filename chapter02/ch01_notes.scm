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



