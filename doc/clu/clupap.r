 CLU paper
.
 set csg_memo to 0 for paper version
 set it to csg memo number for csg memo version
.
 set narrow to 1 for map version
 and insert ;SIZE 14 at the beginning of the XGP file
.
.nr narrow 0
.nr csg_memo 0
.
.so clu/clupap.header
.so clu/clup0.r
.so clu/clup1.r
.so clu/clup2.r
.so clu/clup3.r
.so clu/clup4.r
.so clu/clup5.r
.so clu/clup6.r
.so clu/clup7.r
.if narrow
.ns p
.en
.insert_refs
