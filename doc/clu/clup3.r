.nd chapter 3-1
.nd current_figure 5
.nd wordbag 3
.so clu/clupap.header
.sr m 2m*
.sr p 2p*
.sr q 2q*
.sr x 2x*
.sr y 2y*
.sr z 2z*
.sr a 2a*
.sr b 2b*
.sr insert 2insert*
.sr increment 2increment*
.chapter "Semantics"
.para
All languages present their users with some model of computation.
This section describes those aspects of CLU semantics that differ
from the common ALGOL-like model.
In particular, we discuss
CLU's notions of objects and variables,
and the definitions of assignment and argument passing that
follow from these notions.
We also discuss type correctness.
.section "Objects and Variables"
.para
The basic elements of CLU semantics are
2objects* and 2variables*.
Objects are the data entities that are created and manipulated
by CLU programs.
Variables are just the names used in a
program to refer to objects.
.para
In CLU, each object has a particular 2type*,
which characterizes its behavior.
A type defines a set of operations
that create and manipulate objects of that type.
An object
may be created and manipulated only via the operations of its type.
.para
An object may 2refer* to objects.
For example,
a record object refers to the objects that are the components
of the record.
This notion is one of logical, not physical, containment.
In particular, it is possible for two distinct record objects to
refer to (or 2share*) the same component object.
In the case of a cyclic structure, it is even possible for an object
to ``contain'' itself.
Thus, it is possible to have recursive data
structure definitions and shared data objects without explicit
reference types.
The 2wordtree* type described in the previous
section is an example of a recursively-defined data structure.
(This notion of object is similar to that in LISP.)
.para
CLU objects exist independently of procedure activations.
Space for objects is allocated from a dynamic storage area
as the result of invoking
constructor operations of certain primitive CLU types.
For example,
the record constructor is used in the implementation of 2wordbag*
(Figure wordbag) to acquire space for new 2wordbag* objects.
In theory, all objects continue to exist forever.
In practice,
the space used by an object may be reclaimed when that object is
no longer accessible to any CLU program.
.foot
An object is accessible if it is denoted by a variable of an active
procedure or is a component of an accessible object.
.efoot
.para
An object may exhibit time-varying behavior.
Such an object, called a 2mutable* object,
has a state which may be modified by certain operations
without changing the identity of the object.
Records are examples of mutable objects.
The record update operations (2put_s (r,@v)*,
written as 2r*.2s*@:=@2v*
in the examples) change the state of record objects and
therefore affect the behavior of subsequent applications of
the select operations (2get_s (r)*, written as 2r*.2s*).
The 2wordbag* and 2wordtree* types are additional examples
of types with mutable objects.
.para
If a mutable object m is shared by two other objects x and y,
then a modification to m made via x will be visible when m is
examined via y.
Communication through
shared mutable objects is most beneficial in the context
of procedure invocation, described below.
.para
Objects that do not exhibit time-varying behavior are called
2immutable* objects, or 2constants*.
Examples of constants are integers, booleans,
characters, and strings.
The value of a constant object can not be modified.
For example,
new strings may be computed from old ones,
but existing strings do not change.
Similarly,
none of the integer operations
modify the integers passed to them as arguments.
.para
Variables are names used in CLU programs to 2denote*
particular objects at execution time.
Unlike variables in many common programming languages,
which 2are* objects that 2contain* values,
CLU variables are simply names
that the programmer uses to refer to objects.
As such, it is possible for two variables to denote
(or 2share*) the same object.
CLU variables are much like those in LISP,
and are similar to pointer variables in other languages.
However, CLU variables are 2not* objects;
they cannot be denoted by other variables or referred to by objects.
Thus, variables are completely private to the procedure
in which they are declared,
and cannot be accessed or modified by any other procedure.
.section "Assignment and Procedure Invocation"
.para
The basic actions in CLU are 2assignment* and
2procedure invocation*.
The assignment primitive 2x*@:=@2E*, where x is a variable
and 2E* is an expression, causes x to denote
the object resulting from the evaluation of 2E*.
For example,
if 2E* is a simple variable y, then the assignment x@:=@y
causes x to denote the object denoted by y.
The object
is 2not* copied; after the assignment is performed, it will be
2shared* by x and y.
Assignment does not affect
the state of any object.
(Recall that 2r*.2s*@:=@2v* is not a true assignment,
but an abbreviation for 2put_s@(r,@v)*.)
.para
Procedure invocation involves passing argument objects
from the caller to the called procedure and returning result
objects from the procedure to the caller.
The formal arguments
of a procedure are considered to be local variables of the procedure,
and are initialized, by assignment, to the objects resulting from the
evaluation of the argument expressions.  Thus, argument
objects are shared between the caller and the called procedure.
A procedure may modify mutable argument objects (e.g., records),
but of course it cannot modify immutable ones (e.g., integers).
A procedure has no access to the variables of its caller.
.para
Procedure invocations may be
used directly as statements; those
that return objects may also be used as expressions.
Arbitrary recursive procedures are permitted.
.ne 5
.section "Type Correctness"
.para
Every variable in a CLU module must be declared;
the declaration specifies the type of object
that the variable may denote.
All assignments to a variable must satisfy
the variable's declaration.
Because argument passing is defined
in terms of assignment, the types of actual
argument objects must be consistent with the declarations of the
corresponding formal arguments.
.para
These restrictions, plus the restriction that only the code
in a cluster may use cvt to convert between the abstract
and representation types, ensure that the behavior of an object
is indeed characterized completely by the operations of its type.
For example, the type restrictions ensure that
the only modification possible to a record object that represents
a 2wordbag* (Figure wordbag) is the modification performed by
the insert operation.
.para
Type-checking is performed on a module-by-module basis
at compile-time (it could also be done at run-time).
This checking can catch all type errors -- even those involving
inter-module references -- because the CLU library maintains the
necessary type information for all modules
(see Section 5.)
