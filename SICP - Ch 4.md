## 4.4 [[Logic Programming]]
[Book](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-29.html#%_sec_4.4)

[Lecture Video](https://www.youtube.com/watch?v=rCqMiPk1BJE&list=PLE18841CABEA24090&index=15)

*unification* - [[Unification Algorithm]] and the [[Resolution Principle]]

Because we have a gneral purpose idea of `eval` and `apply`, we can create another kind of language.

Most of computer science is "how to" knowledge, where math is "declarative". 

What if we could write programs by "specifying facts".

Given these facts:

```
SON-OF adam abel
SON-OF adam cain
```

Can we answer "who is cain the son-of" or "who are the sons of cain" or "what is the relationship between cain and abel"

We could define `GRANDSON-OF` thus:
```
IF (SON-OF ?x ?y) AND (SON-OF ?y ?z)
THEN
GRANDSON-OF ?x ?z
```

Procedural programming has inputs and outputs. Rules talk about *relations*

We can define a `merge` function that takes two lists as arguments such that 

```scheme
(= (merge '(1 2 3) '(4 5)) '(1 2 3 4 5))
```

But in a logic program, we could assert:
```
'(1 2 3) AND '(4 5) MERGE-TO-FORM '(1 2 3 4 5)
```

We could also ask what lists can merge to form the answer:
```
?x and ?y MERGE-TO-FORM '(1 2 3 4 5 6)
```

Relations don't have directionality

Use logic to *express* what is true, use logic to *check* what is true, use logic to *find out* what is true

We'll build a logic system that is similar to [Prolog]

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
[Lecture Video](https://www.youtube.com/watch?v=GReBwkGFZcs&list=PLE18841CABEA24090&index=16)

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


