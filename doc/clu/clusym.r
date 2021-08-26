 meta-symbols		(large boldface characters)


 string register		what it contains
   lbkt				[
   rbkt				]
   lcurly				{
   rcurly				}
   lparen				(
   rparen				)
   vbar				|
   etc				...
   def				::=
.
.
.fs A
.nr meta_offset fheight
.fs 0
.nr meta_offset (fheight-meta_offset)/2
.sr lbkt (meta_offset!m)A[*A^*
.sr rbkt (meta_offset!m)A]*A^*
.sr lcurly (meta_offset!m)A{*A^*
.sr rcurly (meta_offset!m)A}*A^*
.sr lparen (meta_offset!m)A(*A^*
.sr rparen (meta_offset!m)A)*A^*
.sr vbar (meta_offset!m)A|*A^*
.fs 5
.nr meta_offset fheight
.fs 0
.nr meta_offset (fheight-meta_offset)/2
.sr orbar (meta_offset!m)5|*5^*
.sr etc A...*
.sr def A=*
