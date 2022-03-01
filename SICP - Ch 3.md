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

### 3.3.3 Representing Tables

### 3.3.4 A Simulator for Digital Circuits
Event-driven simulation

`wire` is stateful component, `signal` can be `set!`

The signal is propograted with certain delays, which are tracked by a schedule

### 3.3.5 Propogration of Constraints
[book link](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-22.html#%_sec_3.3.5)


## Lectures
- ![[SICP Lectures#Lecture 5A - Assignment State and Side-Effects]]
- ![[SICP Lectures#Lecture 5B - Computational Objects]]
