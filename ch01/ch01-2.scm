(define (ds expression)
  (display expression)
  (newline))

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

; recursive process != recusrive procedure



;------------------------------------
; ex 1.10
(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1)
                 (A x (- y 1))))))

(ds (A 1 10))
; --------------------------

; 1.2.2 Tree recursion
(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))

; this isnt great, it duplicates work as the tree grows


; LECTURE NOTES 1B
; fibonacci
; Amount of space taken by recursive algos is
; the proportional to the length of the longest path

; towers of Hanoi
(define (move n from to spare)
  (cond ((= n 0) 'done)
        (else
          (move (- n 1) from spare to)
          (move (- n 1) spare to from))))
(ds (move 4 'a 'b 'c))
