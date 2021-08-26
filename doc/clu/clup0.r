.nd started 0
.nr do_refs 0
.if ~started
.nr do_refs 1
.en
.so clu/clupap.header
.so r/ref3.rmac
.if csg_memo==0
.ls 1
.if narrow
.new_font 1
.ef
.new_font 3
.en
.nf c
.vp 2i
Abstraction Mechanisms in CLU
.if narrow
.new_font 0
.ef
.new_font 1
.en
.sp .5i
Barbara Liskov
Alan Snyder
Russell Atkinson
Craig Schaffert
.sp .3i
Laboratory for Computer Science
Massachusetts Institute of Technology
545 Technology Square
Cambridge, MA 02139
.sp 2
.if ~narrow
.vp 8.5i
.en
.nf l
.fi
.new_font 0
This research was supported in part by the Advanced Research
Projects Agency of the Department of Defense, monitored by the
Office of Naval Research under contract N00014-75-C-0661, and
in part by the National Science Foundation under grant DCR74-21892.
.ls
.end
.if csg_memo>0
.ls 1
.nf c
.new_font 3
Massachusetts Institute of Technology
Laboratory for Computer Science
.new_font 0
(formerly Project MAC)
.sp 1.25i
Computation Structures Group Memo csg_memo-1
.sp 1.25i
.new_font 4
Abstraction Mechanisms in CLU
.new_font 1
.sp
by
.sp
Barbara Liskov
Alan Snyder
Russell Atkinson
Craig Schaffert
.new_font 0
.nf l
.vp 8.25i
.fi
.new_font 0
This research was supported in part by the Advanced Research
Projects Agency of the Department of Defense, monitored by the
Office of Naval Research under contract N00014-75-C-0661, and
in part by the National Science Foundation under grant DCR74-21892.
.nf c
.sp .5i
January 1977
.nf l
.fi
.ls
.end
.
.
.if narrow
.sp 2
.new_font 1
.ll 7i
.ef
.bp
.rs
.vp 3i
.new_font 3
.en
ABSTRACT
.new_font 0
.sp
.ns
.para
CLU is a new programming language designed to support
the use of abstractions in program construction.
Work in programming methodology has led to the realization
that three kinds of abstractions,
procedural, control, and especially data abstractions,
are useful in the programming process.
Of these, only the procedural abstraction
is supported well by conventional languages,
through the procedure or subroutine.
CLU provides, in addition to procedures,
novel linguistic mechanisms that
support the use of data and control abstractions.
.para
This paper provides an introduction to the abstraction mechanisms
in CLU.
By means of programming examples, we illustrate the utility of
the three kinds of abstractions in program construction
and show how CLU programs may be written to use
and implement abstractions.
We also discuss the CLU library, which permits
incremental program development with complete
type-checking performed at compile-time.
.sp
.fi l
Key words and phrases: programming languages, data types,
data abstractions, control abstractions, programming
methodology, separate compilation.
.sp
CR categories:  4.0, 4.12, 4.20, 4.22.
.br
.fi b
.if narrow
.ll
.en
.
.ref All71
Allen, F. E. and Cocke, J.
A catalogue of optimizing transformations.
Rep. RC 3548,
IBM Thomas J. Watson Research Center,
Yorktown Heights, N.@Y., 1971.
.em
.ref All75
Allen, F. E.
A program data flow analysis procedure.
Rep. RC 5278,
IBM Thomas J. Watson Research Center,
Yorktown Heights, N.@Y., 1975.
.em
.ref Atk76
Atkinson, R. R.
Optimization techniques for a structured programming language.
S.M. Thesis,
Dept. of Electrical Engineering and Computer Science,
M.@I.@T., Cambridge, Mass., June 1976.
.em
.ref Dah70
Dahl, O. J., Myhrhaug, B., and Nygaard, K.
The SIMULA 67 common base language.
Publication S-22, Norwegian Computing Center, Oslo, 1970.
.em
.ref DK75
DeRemer, F. and Kron, H.
Programming-in-the-large versus programming-in-the-small.
2Proceedings of International Conference on Reliable Software*,
2SIGPLAN Notices 10*, 6 (June 1975), 114-121.
.em
.ref Dij72
Dijkstra, E. W.  
Notes on structured programming.
2Structured Programming,
A.P.I.C. Studies in Data Processing No. 8*,
Academic Press, New York 1972, 1-81.
.em
.ref Guttag
Guttag, J. V., Horowitz, E., and Musser, D. R.
Abstract data types and software validation.
Rep. ISI/RR-76-48, Information Sciences Institute,
University of Southern California, Marina del Rey,
Calif., August 1976.
.em
.ref Hoare72
Hoare, C. A. R.
Proof of correctness of data representations.
2Acta Informatica*, 4 (1972), 271-281.
.em
.ref Knu73
Knuth, D.
2The Art of Computer Programming*, vol. 3.
Addison Wesley, Reading, Mass., 1973.
.em
.ref LCS75
2Laboratory for Computer Science Progress Report 1974-1975*,
Computation Structures Group.
Rep. PR-XII,
Laboratory for Computer Science, M.@I.@T.,
to be published.
.em
.ref Lam71
Lampson, B. W.
Protection.
Proc. Fifth Annual Princeton Conference on Information
Sciences and Systems, Princeton University, 1971, 437-443.
.em
.ref Lis74
Liskov, B. H. and Zilles, S. N.
Programming with abstract data types.
Proc. ACM SIGPLAN Conference on Very High Level Languages,
2SIGPLAN Notices 9*, 4 (April 1974), 50-59.
.em
.ref Lis75
Liskov, B. H. and Zilles, S. N.
Specification techniques for data abstractions.
2IEEE Trans. on Software Engineering*, 2SE-1*,
(1975), 7-19.
.em
.ref Lis76
Liskov, B. H. and Berzins, V.
An appraisal of program specifications.
Computation Structures Group Memo 141,
Laboratory for Computer Science,
M.@I.@T., Cambridge, Mass., July 1976.
.em
.ref McC62
McCarthy, J., et al.
2LISP 1.5 Programmer's Manual*, MIT Press, 1962.
.em
.ref Mor73
Morris, J. H.
Protection in programming languages.
2Comm. ACM 16*, 1 (Jan 1973), 15-21.
.em
 .ref Mor74
 Morris, J. H.
 Toward more flexible type systems.
 Proceedings of the Programming Symposium, Paris, April 9-11, 1974,
 2Lecture Notes in Computer Science 19*, Springer-Verlag, New York, 
 377-384.
 ..
.ref Par71
Parnas, D. L.
Information distribution aspects of design methodology.
Proc. IFIP 1971.
.em
.ref Sch76
Scheifler, R. W.
An analysis of inline substitution for the CLU programming language.
Computation Structures Group Memo 139,
Laboratory for Computer Science,
M.@I.@T., Cambridge, Mass., June 1976.
.em
.ref Spitzen
Spitzen, J. and Wegbreit, B.
The verification and synthesis of data structures.
2Acta Informatica*, 4 (1975), 127-144.
.em
.ref Standish
Standish, T. A.
2Data structures:  an axiomatic approach*.
Rep. 2639, Bolt Beranek and Newman, Cambridge,
Mass., 1973.
.em
.ref Thomas
Thomas, J. W.
Module interconnection in programming systems supporting
abstraction.
Rep. CS-16, Computer Science Program, Brown University,
Providence, R.@I., 1976.
.em
.ref Wir71a
Wirth, N.
Program development by stepwise refinement.
2Comm. ACM 14*, 4 (1971), 221-227.
.em
.ref Wir71b
Wirth, N.
The programming language PASCAL.
2Acta Informatica*, 1 (1971), 35-63.
.em
.ref Wul84
Wulf, W. A., London, R., and Shaw, M.
An introduction to the construction and verification
of Alphard programs.
2IEEE Transactions on Software Engineering SE-2*,
(1976), 253-264.
.em
.bp
.if do_refs
.insert_refs
.en
.if narrow
.rs
.sp 3i
.en
