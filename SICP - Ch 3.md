## 3.1
[code report video](https://www.youtube.com/watch?v=9cOsXQ-7SwE&t=411s)
[online SICP](https://sarabander.github.io/sicp/html/3_002e4.xhtml#g_t3_002e4)

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

**Mutation is just assignment**

```scheme
(define (fcons x y)
  (define (set-x! v) (set! x v))
  (define (set-y! v) (set! y v))
  (define (dispatch m)
	(cond ((eq? m 'car) x)
		  ((eq? m 'cdr) y)
          ((eq? m 'set-car!) set-x!)
          ((eq? m 'set-cdr!) set-y!)
          ;; (else (error "Undefined operation -- CONS" m))
          ))
  dispatch)
(test 'cdr)
((test 'set-cdr!) 'c)
(test 'cdr)

; from [[SICP Lectures#Lecture 5B - Computational Objects]]
(define (cons x y) ; cons is a procedure
  (lambda (m) ; that takes a procedure as an argument
	(m x ; and calls it of these 4 values
	   y
	   (lambda (n) (set! x n))
       (lambda (n) (set! y n)))))

(define (car x)
  (x (lambda (a d sa sd) a))) ; return x

(define (cdr x)
  (x (lambda (a d sa sd) d))) ; return y

(define (set-car x v)
 (x (lambda (a d sa sd) (sa v)))) ; call sa on y

(define (set-cdr x v)
 (x (lambda (a d sa sd) (sd v)))) ; call sd on y
```

### 3.2.3 Frames as the Repository of Local State

## 3.3 Modeling with Mutable Data
[code_report lectures](https://www.youtube.com/watch?v=jAd4svdYgxY&list=PLVFrD1dmDdvdvWFK8brOVNL7bKHpE-9w0&index=13)

Mutable data objects need _mutators_

### 3.3.1 Mutable List Structure

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

### 3.3.4 A Simulator for Digital Circuits
Event-driven simulation

`wire` is stateful component, `signal` can be `set!`

The signal is propograted with certain delays, which are tracked by a schedule

```scheme
(define (call-each procedures)
  (if (null? procedures)
      'done
      (begin
        ((car procedures))               ; call procedures
        (call-each (cdr procedures)))))  ; resursively

(define (make-wire)
  (let ((signal-value 0) (action-procedures '()))
    (define (set-my-signal! new-value)
      (if (not (= signal-value new-value)
               (begin (set! signal-value new-value)
                      (call-each action-procedures))
               'done)))

    (define (accept-action-procedure! proc)
      (set! action-procedures (cons proc action-procedures))
      (proc))
    (define (dispatch m)
      (cond ((eq? m 'get-signal) signal-value)
            ((eq? m 'set-signal!) set-my-signal!)
            ((eq? m 'add-action!) accept-action-procedure!)
            (else (error "Unknown operation -- WIRE" m))))
    dispatch))

(define (inverter input output)
  (define (invert-input)
    (let ((new-value (logcial-not (get-signal input))))
      (after-delay inverter-delay
                   (labmbda ()
                            (set-signal! output new-value)))))
  (add-action! input invert-input)
  'ok)
(define (logical-not s)
  (cond ((= s 0) 1)
        ((= s 1) 0)
        (else (error "Invalid signal" s))))

(define (and-gate a1 a2 output)
  (define (and-action-procedure)
    (let ((new-value
           (logical-and (get-signal a1) (get-signal a2))))
      (after-delay and-gate-delay
                   (lambda ()
                     (set-singal! output new-value)))))
  (add-action! a1 and-action-procedure)
  (add-action! a2 and-action-procedure)
  'ok)
(define (logical-and a b)
    (cond ((and (= a 0) (= b 0)) 0)
          ((and (= a 1) (= b 0)) 0)
          ((and (= a 0) (= b 1)) 0)
          ((and (= a 1) (= b 1)) 1)
          (else (error "Invalid signal" a b))))

; 3.29 or-gate
(define (or-gate a1 a2 output)
  (define (or-action-procedure)
    (let ((new-value
           (logical-or (get-signal a1) (get-signal a2))))
      (after-delay and-gate-delay
                   (lambda ()
                     (set-signal! output new-value)))))
  (add-action! a1 and-action-procedure)
  (add-action! a2 and-action-procedure)
  'ok)
(define (logical-or a b)
  (cond ((and (= a 0) (= b 0)) 0)
        ((and (= a 1) (= b 0)) 1)
        ((and (= a 0) (= b 1)) 1)
        ((and (= a 1) (= b 1)) 1)
        (else (error "Invalid signal" a b))))

; 3.29 or-gate using inverter & and gate
(define (or-gate a1 a2 output)
  (let ((c1 (make-wire))
        (c2 (make-wire))
        (c3 (make-wire)))
    (inverter a1 c1)
    (inverter a2 c2)
    (and-gate c1 c2 c3)
    (inverter c3 output)))

; making the delay agenda
(define (after-delay delay action)
  (add-to-agenda! (+ delay (current-time the-agenda))
                  action
                  the-agenda))

(define (propogate)
  (if (empty-agenda? the-agenda)
      'done
      (let ((first-item (first-agenda-item the-agenda)))
        (first-item) ; call first item
        (remove-first-agenda-item! the-agenda) ; remove it
        (propogate)))) ; continue propogation

(define (probe name wire)
  (add-action! wire
               (lambda ()
                 (newline)
                 (display name)
                 (display " ")
                 (display (current-time the-agenda))
                 (display " New-value = ")
                 (display (get-signal wire)))))
```

Keeping track of events with `agenda`

`agenda` schema
```scheme
("agenda"), ; type declaration
( ; agendas
 (<time>, queue) ; first agenda
 ((<time>, queue)...) ; rest agendas
 )

```

```scheme
(define (make-agenda) (list 0))
(define (curent-time agenda) (car agenda))
(define (set-current-tiem agenda time)
  (set-car! agenda time))
(define (segments agenda) (cdr agenda))
(define (set-segments! agenda segments)
  (set-cdr! agenda segments))
(define (first-segment agenda) (car (segments agenda)))
(define (rest-segment agenda) (cdr (segments agenda)))
(define (empty-agena? agenda)
  (null? (segments agenda)))

(define (add-to-agenda! time action agenda)
  (define (belongs-before? segments)
    (or (null? segments)
        (< time (segment-time (car segments)))))
  (define (make-new-time-segment time action)
    (let ((q (make-queue)))
      (insert-queue! q action)
      (make-time-segment time q)))
  (define (add-to-segments! segments)
    (if (= (segment-time (car segments)) time)
        (insert-queue! (segment-queue (car segments))
                       action)
        (let ((rest (cdr segments)))
          (if (belongs-before? rest)
              (set-cdr!
               segments
               (cons (make-new-time-segment time action)
                     (cdr segments)))
              (add-to-segments! rest)))))
  (let ((segments (segments agenda)))
    (if (belongs-before? segments)
        (set-segments!
         agenda
         (cons (make-new-teime-segment time action)
               segments))
        (add-to-segments! segments))))
(define (remove-first-agenda-item! agenda)
  (let ((q (segment-queue (first-segment agenda))))
    (delete-queue! q)
    (if (empty-queue! q)
        (set-segments! agenda (rest-segments agenda)))))
(define (first-agenda-item agenda)
  (if (empty-agenda? agenda)
      (error "Agenda is empty -- FIRST-AGENDA-ITEM")
      (let ((first-seg (first-segment agenda)))
        (set-current-time! agenda (segment-time first-seq))
        (front-queue (segment-queue first-seg)))))
```


**memoization**
We can store the results of function calls to a table, reducing the compute time on the second execution

### 3.3.5 Propogration of Constraints
[book link](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-22.html#%_sec_3.3.5)

similar concept as the digital logic work

```scheme
; utilities
(define (memq item x) ; from ch 2
  (cond ((null? x) false)
        ((eq? item (car x)) x)
        (else (memq item (cdr x)))))

(define (for-each-except exception procedure list)
  (define (loop items)
    (cond ((null? items) 'done)
          ((eq? (car items) exception) (loop (cdr items)))
          (else (procedure (car items))
                (loop (cdr items)))))
  (loop list))

(define (probe name connector)
  (define (print-probe value)
    (newline)
    (display "Probe: ")
    (display name)
    (display " = ")
    (display value))
  (define (process-new-value)
    (print-probe (get-value connector)))
  (define (process-forget-value)
    (print-probe "?"))
  (define (me request)
    (cond ((eq? request 'I-have-a-value)
           (process-new-value))
          ((eq? request 'I-lost-my-value)
           (process-forget-value))
          (else
           (error "Unknown request -- PROBE" request))))
  (connect connector me)
  me)

(define (constant value connector)
  (define (me request)
    (error "Unknown request -- CONSTANT" request))
  (connect connector me)
  (set-value! connector value me)
  me)



; aliases
(define (inform-about-value constraint)
  (constraint 'I-have-a-value))
(define (inform-about-no-value constraint)
  (constraint 'I-lost-my-value))
(define (has-value? connector)
  (connector 'has-value?))
(define (get-value connector)
  (connector 'value))
(define (set-value! connector new-value informant)
  ((connector 'set-value!) new-value informant))
(define (forget-value! connector retractor)
  ((connector 'forget) retractor))
(define (connect connector new-constraint)
  ((connector 'connect) new-constraint))

; components
(define (make-connector)
  (let ((value false) (informant false) (constraints '()))
    (define (set-my-value newval setter)
      (cond ((not (has-value? me))
             (set! value newval)
             (set! informant setter)
             (for-each-except setter
                              inform-about-value
                              constraints))
            ((not (= value newval))
             (error "Contradiction" (list value newval)))
            (else 'ignored)))
    (define (forget-my-value retractor)
      (if (eq? retractor informant)
          (begin (set! informant false)
                 (for-each-except retractor
                                  inform-about-no-value
                                  constraints))
          'ignored))
    (define (connect new-constraint)
      (if (not (memq new-constraint constraints))
          (set! constraints
                (cons new-constraint constraints)))
      (if (has-value? me)
          (inform-about-value new-constraint))
      'done)
    (define (me request)
      (cond ((eq? request 'has-value?)
             (if informant true false))
            ((eq? request 'value) value)
            ((eq? request 'set-value!) set-my-value)
            ((eq? request 'forget) forget-my-value)
            ((eq? request 'connect) connect)
            (else (error "Unknown operation -- CONNECTOR"
                         request))))
    me))
(define (adder a1 a2 sum)
  (define (process-new-value)
    (cond ((and (has-value? a1) (has-value? a2))
           (set-value! sum
                       (+ (get-value a1) (get-value a2))
                       me))
          ((and (has-value? a1) (has-value? sum))
           (set-value! a2
                       (- (get-value sum) (get-value a1))
                       me))
          ((and (has-value? a2) (has-value? sum))
           (set-value! a1
                       (- (get-value sum) (get-value a2))
                       me))))
  (define (process-forget-value)
    (forget-value! sum me)
    (forget-value! a1 me)
    (forget-value! a2 me)
    (process-new-value))
  (define (me request)
    (cond ((eq? request 'I-have-a-value)
           (process-new-value))
          ((eq? request 'I-lost-my-value)
           (process-forget-value))
          (else
           (error "Unknown request -- ADDER" request))))
  (connect a1 me)
  (connect a2 me)
  (connect sum me)
  me)

(define (multiplier m1 m2 product)
  (define (process-new-value)
    (cond ((or (and (has-value? m1) (= (get-value m1) 0))
               (and (has-value? m2) (= (get-value m2) 0)))
           (set-value! product 0 me))
          ((and (has-value? m1) (has-value? m2))
           (set-value! product
                       (* (get-value m1) (get-value m2))
                       me))
          ((and (has-value? product) (has-value? m1))
           (set-value! m2
                       (/ (get-value product) (get-value m1))
                       me))
          ((and (has-value? product) (has-value? m2))
           (set-value! m1
                       (/ (get-value product) (get-value m2))
                       me))))
  (define (process-forget-value)
    (forget-value! product me)
    (forget-value! m1 me)
    (forget-value! m2 me)
    (process-new-value))
  (define (me request)
    (cond ((eq? request 'I-have-a-value)
           (process-new-value))
          ((eq? request 'I-lost-my-value)
           (process-forget-value))
          (else
           (error "Unknown request -- MULTIPLIER" request))))
  (connect m1 me)
  (connect m2 me)
  (connect product me)
  me)

; device
(define (celsius-fahrenheit-converter c f)
  (let ((u (make-connector))
        (v (make-connector))
        (w (make-connector))
        (x (make-connector))
        (y (make-connector)))
    (multiplier c w u)
    (multiplier v x u)
    (adder v y f)
    (constant 9 w)
    (constant 5 x)
    (constant 32 y)
    'ok))
(define C (make-connector))
(define F (make-connector))
(probe "Celsius temp" C)
(probe "Fahrenheit temp" F)
(celsius-fahrenheit-converter C F)

(set-value! C 25 'user)  ;
(forget-value! C 'user)
```

## 3.4 Concurrency
[book link](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-23.html)

Assignments introduce time to our computational model

**Serializing access to shared state**

Serialized procedures will execute concurrently, but there will be certain collections of procedures that cannot be executed concurrently. Creates a set of procedures that can not be run concurrently, must be run in serial

```scheme
(parallel-execute <p1> <p2> ...)

(define x 10)

;; create serializer s
(define s (make-serializer))

;; call certain procedures in the serializer
(parallel-execute (s (lambda () (set! x (* x x))))
                  (s (lambda () (set! x (+ x 1)))))

(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               )
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((protected (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) (protected withdraw))
            ((eq? m 'deposti) (protected deposit))
            ((eq? m 'balance) balance)
            (else (error "unknown request -- MAKE-ACCOUNT"
                         m)))))
  dispatch)
```

### Implementing Serializers

Implemented with a _[[mutex]]_, an object that supports two operations, _acquire_ and _release_

```scheme
(define (make-serializer)
  (let ((mutex (make-mutex)))
    (lambda (p)
      (define (serialized-p . args)
        (mutex 'acquire)
        (let ((val (apply p args)))
          (mutext 'release)
          val))
      serialized-p)))
```

Implement _mutex_ with a single item list (a _cell_) that is either True of False. If True, it cannot be acquired, if False, it can be.

```scheme
(define (make-mutext)
  (let ((cell (list false)))
    (define (the-mutex m)
      (cond ((eq? m 'acquire)
             (if (test-and-set! cell)
                 (the-mutext 'acquire)))
            ((eq? m 'release) (celar! cell))))
    the-mutex))
(define (clear! cell) (set-car! cell false))

```

## Recap
This chapter took me forever and made me hate assignment. I can't say that I really understand the `make-serializer` bit. I'll need to return to this later, but want to move on for now.


## Lectures
- ![[SICP Lectures#Lecture 5A - Assignment State and Side-Effects]]
- ![[SICP Lectures#Lecture 5B - Computational Objects]]
