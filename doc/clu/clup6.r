.nd chapter 6-1
.nd current_figure 1
.nd wordbag 3
.so clu/clupap.header
.sr insert 2insert*
.
.chapter "Implementation"
.para
This section briefly describes the current implementation of CLU
and discusses its efficiency.
.para
The implementation is based on a decision to represent
all CLU objects by 2object descriptors*,
which are fixed-size values containing a type code and some
type-dependent information.
.foot
Object descriptors are similar to capabilities [Lam71].
.efoot
In the case of mutable types, the type-dependent information
is a pointer to a separately-allocated
area containing the state information.  For constant
types, the information either directly contains
the value (if the value can be encoded in the
information field, such as for integers, characters,
and booleans) or contains a pointer to separately-allocated
space (as for strings).
The type codes are used by the garbage collector
to determine the physical representation of objects
so that the accessible objects can be traced;
they are also useful for supporting program debugging.
.para
The use of fixed-size object descriptors
allows variables to be fixed-size cells.  Assignment
is efficient: the object descriptor resulting
from the evaluation of the expression is simply
copied into the variable.  In addition, a single
size for variables facilitates the separate compilation
of modules and allows most of the code of a
parameterized module to be shared among all instantiations
of the module.  The actual parameters are made available
to this code by means of a small parameter-dependent
section, which is initialized prior to execution.
.para
Procedure invocation is relatively efficient.
A single program stack is used,
and argument passing is as efficient as assignment.
Iterators are a form of coroutine;
however, their use is sufficiently constrained
that they are implemented using just the program stack.
Using an iterator is therefore only slightly more expensive
than using a procedure.
.para
The data abstraction mechanism is not inherently
expensive.  No execution time type-checking is necessary.
Furthermore, the type conversion implied by 1cvt*
is merely a change in the view taken of an object's type,
and does not require any computation.
.para
A number of optimization techniques can be
applied to a collection of modules, if one is
willing to give up the flexibility of separate
compilation.  The most effective such optimization is
the inline substitution of procedure (and iterator) bodies
for invocations [Sch76].
The use of data abstractions tends to introduce
extra levels of procedure invocations that perform little or no
computation.  As an example, consider the 2wordbag$insert*
operation (Figure wordbag), which merely invokes the
2wordtree$insert* operation and increments a counter.
If data abstractions had not been used, these actions would most
likely have been performed directly by the 2count_words*
procedure.  The 2wordbag$insert* operation is thus
a good candidate for being compiled inline.
Once inline substitution has been performed, the increase
in context will enhance the effectiveness of
conventional optimization techniques
[All71,@All75,@Atk76].
