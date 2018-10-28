.comment -*- Mode:TEXT; -*-
.comment this file documents the DO construct.
.document DO - How to use the Maclisp iteration primitive.
.tag DO
Lesson DO, Version 2			   Kent M. Pitman, 5/30/79
				revised by Victoria Pigman,9/1/82

The MacLISP iteration construct is called DO. It has two syntaxes, one of
which is obsolete and you should not use. That syntax is

(DO <variable> <initial-value> <incremental-value> <exit-test> <body>)

We will not deal with this syntax. It is documented by (DESCRIBE DO),
however, if you are interested in looking it up.

The 'new' syntax is

(DO <bindings> (<exit-test> <exit-body>) <main-body>)

It may seem to be a pretty cumbersome thing at first, but it's very
versatile. Let's examine each of the pieces of the DO before we
put it all together.

First the <bindings>...

In a sort of BNF format (if you're not familiar with this format, don't
worry, but its meaning shouldn't be hard to guess) ...

  <bindings> ::= ( <binding> <binding> ... )
  <binding>  ::= <variable> !
		 (<variable>) !
		 (<variable> <initial-value>) !
		 (<variable> <initial-value> <incremental-value>)

In other words, <bindings> is a list of elements. Each element represents
a binding (creation of a local variable).

If the <binding> is a symbol or a list containing just a symbol,
that atom is bound locally to NIL and its value does not change
unless explicitly changed by a SETQ.

If <binding> is a list of 2 elements, the first is a variable name and
the second is a form to be evaluated and assigned to that variable. This
form is evaluated before the local variable is created, so saying
(X X) will bind a local X to the value of X outside the loop. This may
be useful since it means you can begin with a value of X and re-assign
X locally later without hurting the global value of X.

If <binding> is a list of 3 elements, the first is a variable, the
second is its initial binding (see description of 2-element lists) and
the third is a form which is evaluated newly each succeeding pass through
the loop after the first, and to which the variable will be re-assigned.
For example, (X 1 (+ X 1)) will set X initially to 1 and then add 1 to X
each time (reassigning that back to X) afterward through the loop.
.pause
Now the (<exit-test> <exit-body>) stuff.

<exit-test> is any lisp form which will be evaluated after the bindings
have been done for a given pass through the loop ... if it returns a
non-null value, the statements in <exit-body> (if any) will be executed
in sequence and the last value returned by one of the statements in 
exit-body will be returned as the value of the DO statement. If <exit-test>
returns NIL, the <main-body> of the loop is entered.

Finally <main-body> is a sequence of 0 or more lisp statements to be
executed. Like PROG, atoms at the top level of the loop are taken as 
GO tags. The function GO may be used to transfer control to one of these
tags. The function RETURN may be used to prematurely return a value 
from the DO before it would have exited with <exit-test>. Doing RETURN
does NOT cause <exit-body> to be run.
.pause
Now let's put it all together and write a few programs...

Here's one that prints the numbers from 1 to 10.

(DO ((I 1 (+ I 1)))  ; Variable I initially 1, and add 1 to it each time
    ((> I 10))       ; Exit if I is greater than 10
    (PRINT I))       ; Print I's value.

See if you can modify it to print all even numbers from 1 to 10.
.try
Here's one that CONS's up a list of all the numbers from 1 to 10. Note
that it doesn't need a body! Everything is done from the first two 
clauses...

(DO ((I 1 (+ I 1))      ; Count using I again
     (L () (CONS I L))) ; L grows getting new I's CONS'd onto it.
    ((> I 10) L))

returns (10 9 8 7 6 5 4 3 2 1) ... You might have expected it to return
(11 10 9 8 7 6 5 4 3 2) instead. The reason that it doesn't is that 
the incremental values are all evaluated in parallel and THEN the binding
is done. So the second pass through the loop, I is 1 and L is () as it
enters the bindings ... (+ I 1) returns 2 and (CONS I L) returns (1) ...
THEN I is set to the 2 and L is set to the (1).

Note that this is not the same as what you might expect if the bindings
were done in series. In such a case, I would be set to 2 before the (CONS I L)
and you'd get (11 ... 2) as a result ... this is NOT what Lisp does.

Try this example:

(DO ((I 0 (+ I 1))
     (J 0 I))
    ((> I 10) 'DONE)
    (PRINT (LIST I J)))

and see if you can understand what we mean by parallel binding.
.try
Compare the result of your previous experiment with this loop:

(DO ((I 0 (+ I 1))
     (J))
    ((> I 10) 'DONE)
    (SETQ J I)
    (PRINT (LIST I J)))
.try
Now let's try something more substantial - the FACTORIAL program...

Recursive solution:

.eval-print
(DEFUN FACT (X)
  (COND ((ZEROP X) 1)
	(T (TIMES X (FACT (SUB1 X))))))
    

Iterative solution:

.pp
(DEFUN FACT (X)
  (DO ((I 1 (ADD1 I))
       (F 1 (TIMES F I)))
      ((GREATERP I X) F)))

Recursive solutions are pretty, but they often run out of what is
called 'stack' - Lisp has to remember all the recursive calls and 
it keeps them stacked up to come back to later. Try 

  (FACT 200) and (FACT 1000)

now and see the error message that happens if you recurse too deep.
(FACT has been defined for you via the recursive method.)
.try
.eval
(DEFUN FACT (X)
  (DO ((I 1 (ADD1 I))
       (F 1 (TIMES F I)))
      ((GREATERP I X) F)))
Now and try it with the iterative solution. (We've swapped definitions
to the iterative method for you)...
Do (FACT 200) and (FACT 1000)
(Note that the second one may take a short time ... give it a chance to
finish.)
.try
Try to rewrite the FIB definition so that it uses iteration. Remember we
defined it for you as

.eval-print
(DEFUN FIB (X)
  (COND ((ZEROP X) 1)
	((EQUAL X 1) 1)
	(T (PLUS (FIB (SUB1 X))
		 (FIB (DIFFERENCE X 2))))))

Now try rewriting this function using iteration. Keep in mind that the
way to calculate fibonacci numbers is to start computing from the first one,
adding succeeding values to previous values. You may need more than one
loop variable.
.try
Did you come up with something like this?

.eval-print
(DEFUN FIB (X)
  (DO ((COUNT 1 (ADD1 COUNT))
       (OLD   1 (PLUS OLD OLDER))
       (OLDER 0 OLD))
      ((GREATERP COUNT X) OLD)))

If not, see if you can at least understand why this one works.
.try
.next TRACE
