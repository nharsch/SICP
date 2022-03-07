## 3.1
[code report video](https://www.youtube.com/watch?v=9cOsXQ-7SwE&t=411s)

### 3.1.1

`set!` - sets value to name

`(set! <_name_> <_new-value_>)`

`begin` special form to evaluate code, then return a final value

```
(begin exp1 exp2 exp3)
``` 

evaluates exp1 and exp2 and returns exp3

comibining set with local variables allows us to construct computational objects

```scheme
(define new-withdraw
  (let ((balance 100))
    (lambda (amount)
      (if (>= balance amount)
          (begin (set! balance (- balance amount))
                 balance)
          "Insufficient funds"))))

(new-withdraw 40)
; => 60
(new-withdraw 40)
; => 20
```

`new-withdraw` is _encapsulated_

```scheme
(define (make-withdraw balance)
  (lambda (amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
                balance)
               "Insufficient funds")))
(define W1 (make-withdraw 100))
(define W2 (make-withdraw 100))
(W1 50)
; 50
(W2 70)
; 30
```

Objects "have state" in real world

```
(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request -- MAKE-ACCOUNT"
                       m))))
  dispatch)
```

Each call to `make-account` sets up an environment with a local state variable `balance`

`dispatch` fn handles _[[message passing]]_



### 3.1.2 The Benefits of Introducing Assignment

- Simplifies designs where state data is closely tied to functions
  - Implementing a [[Monte Carlo Method]] experiment is simpler

### 3.1.3 The Costs of Introducing Assignment
- can no longer use substitution model of evaluation


## 3.2 The Environment Model of Evaluation
[online chapter](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-21.html)

An environment is a sequence of _frames_. Each frame is a table of _bindings_ which associate variable names with their corresponding values.

Each frame points to its surrounding environment, unless it's global

![[Pasted image 20220216202404.png]]

_values_ for _variables_ found by looking for _bindings_ in each frame, or is _unbound_

### 3.2.1 The Rules for Evaluation
[source](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-22.html)

To evaluate a combination:
1. Evaluate the subexpression of the combination
2. Apply the value of the operator subexpression to the values of the operand subexpressions

`define` creates definitions by adding bindings to frames

A procedure object is applies to a set of args by constructing a frame, binding the formal params of the procedure to the args of the call, and then avluating the body of the procedure in the context of the ne environment constructed.

A procedure is created by evaluating a `lambda` expression relative to a given environment. The resulting procedure object is a pair consisting of the text of the `lambda` expression and a pointer to the environment in which the procedure was created.

### 3.2.2 Applying Simple Procedures

### 3.2.3 Frames as the Repository of Local State

## 3.3 Modeling with Mutable Data
[code_report lectures](https://www.youtube.com/watch?v=jAd4svdYgxY&list=PLVFrD1dmDdvdvWFK8brOVNL7bKHpE-9w0&index=13)

Mutable data objects need _mutators_

### 3.3.2 Representing Queues

Queue is FIFO

Exercise 3.22

```scheme

(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item) (set-car! queue item))
(define (set-rear-ptr! queue item) (set-cdr! queue item))
(define (empty-queue? queue) (null? (front-ptr queue)))

(define (make-queue) (cons '() '()))

(define (front-queue queue)
  (if (empty-queue? queue)
      (error "FRONT called with an empty queue" queue)
      (car (front-ptr queue))))

(define (insert-queue! queue item)
  (let ((new-pair (cons item '())))  ; create a new end item
    (cond ((empty-queue? queue)
           (set-front-ptr! queue new-pair)  ; put at beginning of empty queue
           (set-rear-ptr! queue new-pair)  ; put at end of empty queue
           queue)
          (else
           (set-cdr! (rear-ptr queue) new-pair)  ; put at end of non empty queue
           (set-rear-ptr! queue new-pair)  ; update rear pointer
           queue))))

(define (delete-queue! queue)
  (cond ((empty-queue? queue)
         (error "DELETE! called with an empty queue" queue))
        (else
         (set-front-ptr! queue (cdr (front-ptr queue)))  ; remove first item
         queue)))

(define test-queue (make-queue))
(empty-queue? test-queue)
(insert-queue! test-queue 'a)
(insert-queue! test-queue 'b)
(insert-queue! test-queue 'c)
(insert-queue! test-queue 'd)
(front-ptr test-queue)
(rear-ptr test-queue)
(delete-queue! test-queue)
(print-queue test-queue)

(define (print-queue queue)
  (display (front-ptr queue)))

(print-queue test-queue)

; make queue with internal methods

(define (make-queue)
  (let ((front-ptr '())
        (rear-ptr '()))
    (define (empty-queue?) (null? front-ptr))
    (define (set-front-ptr! item) (set! front-ptr item))
    (define (set-rear-ptr! item) (set! rear-ptr item))
    (define (front-queue)
      (if (empty-queue?)
          (error "FRONT called with an empty queue")
          (car front-ptr)))
    (define (insert-queue! item)
      (let ((new-pair (cons item '())))  ; create a new end item
        (cond ((empty-queue?)
               (set-front-ptr! new-pair)  ; put at beginning of empty queue
               (set-rear-ptr! new-pair))  ; put at end of empty queue
              (else
               (set-cdr! rear-ptr new-pair)  ; put at end of non empty queue
               (set-rear-ptr! new-pair)))))  ; update rear pointer
    (define (delete-queue!)
      (cond ((empty-queue?)
             (error "DELETE called on empty queue"))
            (else
             (set-front-ptr! (cdr front-ptr)))))
    (define (print-queue) front-ptr)
    (define (dispatch m)
      (cond ((eq? m 'front) front-ptr)
            ((eq? m 'rear) rear-ptr)
            ((eq? m 'insert!) insert-queue!)
            ((eq? m 'delete!) delete-queue!)
            ((eq? m 'print) print-queue)
            ((eq? m 'empty?) empty-queue?)
            (else (error "undefined operation -- Queue" m))
            )
      )
    dispatch))
(define q (make-queue))
(q 'front)
(q 'rear)
((q 'insert!) 'a)
((q 'print))
((q 'insert!) 'b)
((q 'insert!) 'c)
```

### 3.3.3 Representing Tables
[source](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-22.html#%_sec_3.3.3)

![[SICP figure 3-22.png.png]]

1D table represented as a headed list

```scheme
(define (lookup key table)
  (let ((record (assoc key (cdr table))))
    (if record
        (cdr record)
        false)))
(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))))
(define (insert! key value table)
  (let ((record (assoc key (cdr table))))
    (if record
        (set-cdr! record value)
        (set-cdr! table
                  (cons (cons key value) (cdr table)))))
  'ok)
(define (make-table)
  (list '*table*))

(define t1 (make-table))
(insert! 'a 'test t1)
(lookup 'a t1)
```

2D tables

```scheme
(define (lookup key-1 key-2 table)
  (let ((subtable (assoc key-1 (cdr table))))
    (if subtable
        (let ((record (assoc key-2 (cdr subtable))))
          (if record-accessor
              (cdr record)
              false))
        false)))

(define (insert! key-1 key-2 value table)
  (let ((subtable (assoc key-1 (cdr table))))
    (if subtable
        (let ((record (assoc key-2 (cdr subtable))))
          (if record
              (set-cdr! record value)
              (set-cdr! subtable
                        (cons (cons key-2 value)
                              (cdr subtable)))))
        (set-cdr! table
                  (cons (list key-1
                              (cons key-2 value))
                        (cdr table)))))
  'ok)
```

**memoization**
We can store the results of function calls to a table, reducing the compute time on the second execution

### 3.3.4 A Simulator for Digital Circuits
Event-driven simulation

`wire` is stateful component, `signal` can be `set!`

The signal is propograted with certain delays, which are tracked by a schedule

### 3.3.5 Propogration of Constraints
[book link](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-22.html#%_sec_3.3.5)


## Lectures
- ![[SICP Lectures#Lecture 5A - Assignment State and Side-Effects]]
- ![[SICP Lectures#Lecture 5B - Computational Objects]]
