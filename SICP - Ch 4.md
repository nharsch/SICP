[[Chimera]] quote in intro

## Intro
_Metalinguistic abstraction:_ establishing new languages. Formulate new languages and implement them by constructing evaluators.

Most fundemental idea in programming: The evaulator, which determines the meaning of expressions in a programming language, is just another program.
Computer programming is only incedentally about getting computers to do something

*unification* - [[Unification Algorithm]] and the [[Resolution Principle]]

Applicative order vs _normal-order evaluation_

## 4.1 The Metacircular Evaluator
An evaluator that is written the the same language that it evaluates is said to be _metacircular_

### **Eval** 
**Eval** takes as arguments an expression and an environment. 

Each type of expression has a predicate that tests for it and an abstract means for selecting its parts. **Abstract Syntax**

#### Primitive expressions
- for self-evaluating expressions, such as numbers, eval returns the expression itself
- `Eval` looks up variables in the environment

#### Special Forms
- quoted expressions, assignments, conditionals, lambdas, `begin`

#### Combinations

### Apply
`Apply` takes a procedure and a list of args. Compound arguments are padded to `Eval`

### 4.1.2 Representing Expressions

### 4.1.3 Evaluator Data Structures

### 4.1.4 Running the Evaluator as a Program

### 4.1.5 Data as Programs
We can think of programs as data structures defining a machine

We can think of evaluators as machines that read in descriptions of machines and reconfigure themselves to become the machine the program describes. Thus an evaluator is a _universal machine_

### 4.1.6 Internal Definitions

## 4.2 Lazy Evaluation

### 4.2.1 Normal Order and Applicative Order
Applicative Order: all args to a procedure are evaluated when procedure is applied
Normal Order: delay evaluation of procedure arguments until the actual argument values are needed. AKA [[Lazy Evaluation]]

### 4.2.3 Streams as Lazy Lists
Re impliment streams as defined in [[SICP - Ch 3]] as _Lazy Lists_


## 4.4 [[Logic Programming]]
[Book](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-29.html#%_sec_4.4)
### Lecture
- [[SICP Lectures#Lecture 8A - Logic Programming]]

### Intro
The logic programming language we're implementing is also a _query language_ because it is very useful for retrieving information from databases

### 4.4.1 Deductive Information Retrieval
For a given language, always ask:
- what are the **primitives**
- what are the **means of combination**
- what are the **means of abstraction**

Our core **primitve** in this logic language is the *query*

`(job ?x (computer programmer))`  -> returns all employees that are computer programmers

`(job ?x (computer ?type)` -> returns all employees and titles of employees that work with computers

Scheme dot notation
```
(a b) ; a is first arg, b is second arg
(a . b) ; a is car of args, b is cdr of args
```

Our means of **combination**

we have `and`, `not` and `or` in queries. We can also use `lisp-value` to use predicates like `<` etc for queries.

Our means of **abstraction** are *Rules*

A Rule has 3 parts, declaration, conclusion, and body. Conclusion is a truth statement, body is the test: 
```scheme
(rule  								; rule declaration
  (bigshot ?x ?dept)                ; rule conclusion
  (and                              ; body of rule
    (job ?x (?dept . ?y)) ; dept matches job desc dept
	(not (and 
	          (supervisor ?x ?z) ; has no supervisor
	          (job? z (?dept . ?w)))))) where supervisor is in same dept
```

A rule with no body is always true:
```scheme
(rule (merge-to-form () ?y ?y))
(rule (merge-to-form ?y () ?y))
```

^ anything an empty list is equal to that anything, regardless of ordinality

```scheme
(rule
  (merge-to-form
    (?a . ?x) (?b . ?y) (?b . ?z))
  (and (merge-to-form (?a . ?x) ?y ?z)
  	   (lisp-value > ?a ?b)))
```

^ if a < b, merging a list with a and a list with b, b will be first

We can use queries a bit like procedures

```scheme
(merge-to-form (1 3) (2 7) ?x)
=> (merget-to-form (1 3) (2 7) (1 2 3 7))
(merge-to-form (2 ?a) ?x (1 2 3 4))
=> (merge-to-form (2 3) (1 4) (1 2 3 4))
=> (merge-to-form (2 3) (4 1) (1 2 3 4))
```

### 4.4.2 How the Query System Works
# TODO: left off here

Searching with streams

*pattern matching*  and *unification*

#### Pattern matching

```
(match pattern data dictionary)
```

match a pattern against a data object, subject to a dictionary of assignments

```scheme
(match (?x ?y ?y ?y ?x) (a b b a) {x:a}))
=> {x: a, y: b}
```

^^ `x` is already matched to `a`, so `y` is matched to `b` and return an extended dictionary of mappings
If `x` had been matched to `y`, than we would have received a failure



System takes as input Pattern, Datum, Frame. Frame specifies bindings for pattern variables.

#### Streams of frames


