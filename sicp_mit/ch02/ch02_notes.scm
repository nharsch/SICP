(define (cons x y)
  (define (dispatch m)
    (cond ((= m 0) x)
          ((= m 1) y)
          (else (error "arg not 0 or 1 -- CONS" m))))
  dispatch)

(define (car z) (z 0))
(define (cdr z) (z 1))

(display (car (cons 5 10)))
(newline)
(display (cdr (cons 5 10)))

; another way to do it
(define (cons x y)
  ; return a function that will take another function 
  ; and apply to x and y
  (lambda (m) (m x y)))

(define (car z)
  ; call function z
  (z 
    ; with a function that returns the first of 2 args
    (lambda (p q) p)))

(define (cdr z)
  (z (lambda (p q) q)))
(newline)
(display (car (cons 4 8)))
(newline)
(display (cdr (cons 4 8)))
; TODO: mind boogling ex 2.5

