; # 1.1

;; 1.1.1
(+ 1 2 3 4)

;; 1.1.2
(def size 2)
(= size 2)

;; 1.1.3 Evaluating Combinations
(* (+ 2 (* 4 6))
   (+ 3 5 7))



;; 1.1.7
(defn average [x y]
  (/ (+ x y) 2))

; # 1.2

; # 1.3

;;  1.3.1
(defn sum-integers [a b]
  (if (> a b)
    0
    (+ a (sum-integers (+ a 1)))))

;;  1.3.2

;; 1.3.4
(defn average-damp [f]
  (fn [x] (average x (f x))))
