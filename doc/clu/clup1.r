.so clu/clupap.header
.chapter "Introduction"
.para
The motivation for the design of the CLU programming
language was to provide programmers with a tool that would
enhance their effectiveness in constructing programs of
high quality -- programs that are reliable and reasonably
easy to understand, modify, and maintain.
CLU aids programmers
by providing constructs that support
the use of abstractions in program design and implementation.
.para
The quality of software depends primarily on
the programming methodology in use.
The choice of programming language, however, can have a major impact on
the effectiveness of a methodology.
A methodology can be easy
or difficult to apply in a given language, depending on
how well the language constructs match the 
structures that the methodology deems desirable.
The presence of constructs that give a concrete form
for the desired structures makes the methodology more understandable.
In addition, a programming language influences the way that
its users think about programming;
matching a language to a methodology increases the likelihood that
the methodology will be used.
.para
CLU has been designed to support a methodology
(similar to
[Dij72,@Wir71a])
in which programs are developed by
means of problem decomposition based on the recognition 
of abstractions.
A program is constructed in many
stages.
At each stage, the problem to be solved is
how to implement some abstraction (the initial problem
is to implement the abstract behavior required of the
entire program).
The implementation is developed by envisioning a number
of subsidiary abstractions (abstract objects and
operations) that are useful in the problem domain.
Once the behavior of the abstract objects and operations
has been defined, a program can be written to solve the
original problem; in this program, the abstract objects
and operations are used as primitives.
Now the original
problem has been solved, but new problems have arisen,
namely, how to implement the subsidiary abstractions.
Each of these abstractions is
considered in turn as a new problem; its implementation
may introduce further abstractions.
This process 
terminates when all the abstractions introduced at various
stages have been implemented or are present in the
programming language in use.
.para
In this methodology, programs are developed
incrementally, one abstraction at a time.
Further, a distinction is made between an abstraction,
which is a kind of behavior, and a program,
or 2module*, which implements that behavior.
An abstraction isolates
use from implementation:  an abstraction can be used
without knowledge of its implementation and implemented
without knowledge of its use.
These aspects of the methodology are supported by the
CLU 2library*, which maintains
information about abstractions
and the CLU modules that implement them.
The library permits separate compilation of
modules with complete type-checking at
compile-time.
.para
To make effective use of the
methodology, it is necessary to understand the kinds
of abstractions that are useful in constructing programs.
In studying this question,
we identified an important kind of abstraction,
the data abstraction, that
had been largely neglected in discussions of programming methodology.
.para
A data abstraction [Hoare72,@Lis74,@Standish]
is used to introduce a new
type of data object that is deemed useful
in the domain of the problem being solved.
At the level of use, the programmer is
concerned with the 2behavior* of these data objects,
what kinds of information can be stored in them and
obtained from them.
The programmer is 2not* concerned
with how the data objects are represented in storage,
nor with the algorithms used to store and access
information in them.
In fact, a data abstraction is
often introduced to delay such implementation
decisions until a later stage of design.
.para
The behavior of the data objects is expressed most
naturally in terms of a set of operations that are meaningful
for those objects.
This set will include operations
to create objects, to obtain information from them,
and possibly to modify them.
For example,
push and pop are among the meaningful operations for stacks,
while meaningful operations for integers include the usual
arithmetic operations.
Thus, a data abstraction consists of a
set of objects and a set of operations
characterizing the behavior of the
objects.
.para
If a data abstraction is to be
understandable at an abstract level,
the behavior of the data objects must be
2completely* characterized by the set of operations.
This property is ensured by making the operations the
2only direct means* of creating and manipulating the objects.
One effect of this restriction
is that, when defining an abstraction,
the programmer must be careful to include a
sufficient set of operations, since every action
he wishes to perform on the objects must be
realized in terms of this set.
.para
We have identified the following requirements that must be
satisfied by a language supporting data abstractions:
.ilist 3
1.	A linguistic construct is needed that permits
a data abstraction to be implemented as a unit.
The implementation involves selecting a representation
for the data objects and defining an algorithm for each
operation in terms of that representation.
.next
2.	The language must limit access to the
representation to just the operations.  This limitation
is necessary to ensure that the operations completely
characterize the behavior of the objects.
.end_list
CLU satisfies these requirements by providing a linguistic construct
called a 2cluster* for implementing data abstractions.
Data abstractions are integrated into the language
through the data type mechanism.
Access to the representation is
controlled by type-checking, which is done at 
compile time.
.para
In addition to data abstractions, CLU
supports two other kinds of abstractions:
procedural abstractions and control abstractions.
A procedural abstraction performs a computation on a
set of input objects and produces a set of output objects;
examples of procedural abstractions are sorting an
array and computing a square root.
CLU supports procedural abstractions by means of procedures,
which are similar to procedures in other programming languages.
.para
A control abstraction defines a method
for sequencing arbitrary actions.
All languages provide built-in control abstractions;
examples are the if statement and the while statement.
In addition, however,
CLU allows user definitions of a simple kind of control abstraction.
The method provided is a generalization of the
repetition methods available in many programming
languages.
Frequently the programmer desires to
perform the same action for all the objects in a
collection, such as all
characters in a string or all items in a set.
CLU
provides a linguistic construct called an 2iterator*
for defining how the objects in the
collection are obtained.
The iterator is used in
conjunction with the for statement; the body
of the for statement describes the action to be
taken.
.para
The purpose of this paper is to illustrate
the utility of the three kinds of abstractions
in program construction,
and to provide an informal introduction to CLU.
We do not attempt a complete description of the language;
rather, we concentrate on the constructs that
support abstractions.
The presence of these
constructs constitutes the most important way in
which CLU differs from other languages.
The language closest to CLU is Alphard [Wul84],
which represents a concurrent design effort with goals similar to
our own.
The design of CLU has been influenced by
SIMULA 67 [Dah70], and to a lesser extent by
Pascal [Wir71b] and LISP [McC62].
.para
In the next section we introduce CLU and,
by means of a programming example,
illustrate the use and implementation
of data abstractions.
Section semantics describes the basic semantics of CLU.
In Section more_abstraction, we discuss
control abstractions and more powerful kinds of
data abstractions.
We present the CLU library in Section library.
Section implementation briefly describes
the current implementation of CLU
and discusses efficiency considerations.
.ne 2
Finally, we conclude by discussing
the quality of CLU programs.
