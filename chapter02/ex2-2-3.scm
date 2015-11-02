;TODO: make wrap in parens seperate with comma function 
(define (print-wrap x y)
  (display "(")
  (display x)
  (display ",")
  (display y)
  (display ")"))

(print-wrap 'testing 'testing)
(newline)

; define point
(define (make_point x y) (cons x y))
(define (x-point p) (car p))
(define (y-point p) (cdr p))
(define (print-point p)
  (display 'point)
  (print-wrap (x-point p) (y-point p)))

(define my_point (make_point 1 2))
(display "This is what a point looks like: ")
(print-point my_point)
(newline)

(define (segment p1 p2) (cons p1 p2))
(define my_seg
  (segment
    (make_point 0 0)
    (make_point 0 5)))

(define (print_seg s)
  (display "seg")
  (print-wrap
    (car s)
    (cdr s)))

(display "my_seg: ")
(print_seg my_seg)
(newline)

(define (start-segment s) (car s))
(define (end-segment s) (cdr s))
(define (average x y) (/ (+ x y) 2.0))
(define (seg-mid s)
  (make_point
    (average
        (x-point (end-segment s))
        (x-point (start-segment s)))
    (average
        (y-point (end-segment s))
        (y-point (start-segment s)))))

(display (seg-mid my_seg))
(newline)
; make a rectangle
; such that (top left point, bottom left point)

(define (make_rectangle p1 p2)
  (cons p1 p2))

(define (rect_p1 r) (car r))
(define (rect_p2 r) (cdr r))
(define (print-rectangle r)
  (display "rect")
  (print-wrap
    (rect_p1 r)
    (rect_p2 r)))

(define (rect-area r)
  (* 
    ; width
    (-
       (x-point (rect_p2 r))
       (x-point (rect_p1 r)))

    ; length
    (- 
      (y-point (rect_p2 r))
      (y-point (rect_p1 r)))))

(define r1 (make_rectangle
  (make_point 0 0)
  (make_point 5 5)))

(print-rectangle r1)

(define (rect-perim r)
  (abs
    (* 
      (+
        ; width
        (- (x-point (rect_p2 r))
           (x-point (rect_p1 r)))
        ; length
        (- (y-point (rect_p2 r))
           (y-point (rect_p1 r))))
    2)))

(newline)
(display (rect-perim r1))
(newline)
(display (rect-area r1))





