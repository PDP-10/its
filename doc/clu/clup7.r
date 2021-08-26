.nd chapter 7-1
.nd current_figure 5
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
.chapter "Discussion"
.para
Our intent in this paper has been to provide an
informal introduction to the abstraction mechanisms in CLU.
By means of programming examples, we have illustrated the
use of data, procedural, and control abstractions, and have
shown how CLU modules are used to implement these
abstractions.  We have not attempted to provide a complete
description of CLU, but, in the course of explaining
the examples, most features of the language have appeared.
One important omission is the CLU exception handling mechanism
(which does support abstractions); this mechanism
is described in [LCS75].
.para
In addition to describing constructs
that support abstraction, previous sections have
covered a number of other topics.  We have discussed the 
semantics of CLU.  We have described the organization of the
CLU library and discussed how it supports incremental
program development and separate
compilation and type-checking of modules.
Also, we have described our current
implementation and discussed its efficiency.
.para
In designing CLU, our goal was to simplify the task
of constructing reliable software that is reasonably easy
to understand, modify, and maintain.  It seems appropriate,
therefore, to conclude this paper with a discussion of how
CLU contributes to this goal.
.para
The quality of any program depends upon the skill of 
the designer.  In CLU programs,
this skill is reflected in the choice of abstractions.
In a good design, abstractions will be used
to simplify the connections between modules and to 
encapsulate decisions that are likely to change [Par71].
Data abstractions are particularly valuable for these purposes.
For example, through the use of a data abstraction,
modules that share a system data base
rely only on its abstract behavior as
defined by the data base operations.  The connections
among these modules are much simpler
than would be possible if they shared knowledge
of the format of the data base and the relationship
among its parts.  In addition, the data base abstraction
can be reimplemented without affecting the code of the modules
that use it.
CLU encourages the use of data abstractions,
and thus aids the programmer during program design.
.para
The benefits arising from the use of data
abstractions are based on the constraint, inherent in CLU
and enforced by the CLU compiler, that only the operations
of the abstraction may access the representations of the objects.
This constraint ensures that the distinction made in CLU
between abstractions and implementations
applies to data abstractions as well as to procedural
and control abstractions.
.para
The distinction between abstractions and implementations
eases program modification and maintenance.
Once it has been determined that an abstraction must be
reimplemented, CLU guarantees that the code of
all modules using that
abstraction will be unaffected by the change.
The modules need not be reprogrammed or even recompiled;
only the process of
selecting the implementation of the abstraction must be
redone.
The problem of determining what modules must be
changed is also simplified, because each module has a
well-defined purpose, to implement an abstraction,
and no other module can interfere with that purpose.
.para
Understanding and verification of CLU programs is
made easier
because the distinction between
abstractions and implementations permits this task
to be decomposed.
One module at a time is studied to determine that it
implements its abstraction.  This study requires
understanding the behavior of the abstractions
it uses, but it is not necessary to understand the
modules implementing those abstractions.  Those
modules can be studied separately.
.para
A promising way to establish the
correctness of a program is by means of a mathematical
proof.  For practical reasons, proofs should be
performed (or at least checked) by a verification
system, since the process of constructing
a proof is tedious and error-prone.
Decomposition of the proof is essential for
program proving, which is practical only for small
programs (like CLU modules).  Note that when the CLU
compiler does type-checking, it is, in addition
to enforcing the constraint that permits the proof
to be decomposed, also performing a small part of the
actual proof.
.para
We have included as declarations in CLU just
the information that the compiler can check with
reasonable efficiency.
We believe that the other
information required for proofs (specifications and
assertions) should be expressed in a separate
``specification'' language.
The properties of such a language are being
studied [Guttag, Lis75, Lis76, Spitzen].
We intend eventually to add formal specifications to the
CLU system; the library is already organized to
accommodate this addition.  At that time various
specification language processors could be added to 
the system.
.para
We believe that the constraints imposed by
CLU are essential for practical as well as theoretical
reasons.  It is true that data abstractions
can be used in any language by
establishing programming conventions to protect the
representations of objects.  However, conventions are no
substitute for enforced constraints.  It is inevitable
that the conventions will be violated -- and are likely
to be violated just when they are needed most, in
implementing, maintaining, and modifying large
programs.  It is precisely at this time, when the
.ne 3
programming task becomes very difficult, that a
language like CLU will be most valuable and
appreciated.
.chapter "Acknowledgements"
.para
The authors gratefully acknowledge the contributions
made by members of the CLU design group over the
last three years.  Several people have made
helpful comments about this paper, including
Toby Bloom, Dorothy Curtis, Mike Hammer,
Eliot Moss, Jerry Saltzer, Bob Scheifler,
and the referees.
