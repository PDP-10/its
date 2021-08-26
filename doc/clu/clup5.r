.nd chapter 5-1
.nd current_figure 11
.nd wordbag 3
.so clu/clupap.header
.sr p 2p*
.sr q 2q*
.sr x 2x*
.sr y 2y*
.sr z 2z*
.sr a 2a*
.sr b 2b*
.sr insert 2insert*
.chapter "The CLU Library"
.para
So far, we have shown CLU modules as separate pieces of
text, without explaining how they are bound together to form a
program.  This section describes the CLU library, which plays a
central role in supporting inter-module references.
.para
The CLU library contains information about
abstractions.  The library supports incremental program
development, one abstraction at a time, and, in addition,
makes abstractions that are defined during the construction of
one program available as a basis for subsequent program development.
The information in the library permits the separate
compilation of single modules, with complete type-checking
of all external references (such as procedure
invocations).
.para
The structure of the library derives from the fundamental
distinction between abstractions and implementations.
For each abstraction, there is a 2description
unit* which contains all system-maintained information
about that abstraction.  Included in the description unit
are zero or more modules that implement the abstraction.
.foot
Other information that may be stored in the library
includes information about relationships among
abstractions, as might be expressed in a module
interconnection language [DK75,@Thomas].
.efoot
.para
The most important information contained in a description
unit is the abstraction's 2interface specification*, which
is that information needed to type-check uses of the abstraction.
For procedural and control abstractions,
this information consists of the number and types of
parameters, arguments, and output values, plus any constraints
on type parameters (i.e., required operations, as described in
Section 4).  For data abstractions,
it includes the number and types of parameters, constraints on
type parameters, and the
name and interface specification of each
operation.
.para
An abstraction is entered in the library by
submitting the interface specification;
no implementations are required.
In fact, a module can be compiled before any implementations
have been provided for the abstractions that it uses;
it is necessary only that interface specifications
have been given for those abstractions.
Ultimately, there can be many implementations
of an abstraction;
each implementation is required to satisfy the
interface specification of the abstraction.
Because all uses and implementations
of an abstraction are checked against the interface
specification, the actual selection
of an implementation can be delayed
until just before (or perhaps during) execution.
We imagine a process of binding together modules
into programs, prior to execution, at which time
this selection would be made.
.para
An important detail of the CLU system is
the method by which CLU modules refer to abstractions.
To avoid problems of name conflicts that can arise in
large systems, the names used by a module to refer to
abstractions can be chosen to suit the programmer's
convenience.
When a module is submitted for
compilation, its external references must be bound to
description units so that type-checking can be
performed.  The binding is accomplished by constructing
an 2association list*,
mapping names to description units, which
is passed to the compiler along with the source code when
compiling the module.
The mapping in the association list is stored by the compiler
in the library as part of the module.
A similar process is involved in entering interface
specifications of abstractions, as these will include
references to other (data) abstractions.
.para
When the compiler type-checks a module,
it uses the association list to map the external
names in the module to description units, and then uses
the interface specifications in those description
units to check that the abstractions are used correctly.
The type-correctness of the module thus
depends upon the binding of names to description units
and the interface specifications in those description
units, and could be invalidated if changes to the
binding or the interface specifications were subsequently
made.  For this reason, the process of compilation
permanently binds a module to the abstractions it
uses, and the interface description of an abstraction,
'ne 2
once defined, is not allowed to change.
(Of course, a new description unit can be created
to describe a modified abstraction.)
