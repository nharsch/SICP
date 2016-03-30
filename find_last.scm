; find last element in a list
(define (find_last l)
  (if (= (cdr l) (car l))
    (else (find_last (cdr l)))))

(display (find_last (1 2 3)))
