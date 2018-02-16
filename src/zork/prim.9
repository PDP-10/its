"(c) Copyright 1978, Massachusetts Institute of Technology.  All rights reserved."
<DEFINE MSETG (FOO BAR)
	#DECL ((FOO) ATOM (BAR) ANY)
	<COND (<AND <GASSIGNED? .FOO> <N=? .BAR ,.FOO>>
	       <ERROR MSETG .FOO ALREADY-GASSIGNED ,.FOO>)
	      (ELSE
	       <SETG .FOO .BAR>
	       <MANIFEST .FOO>)>>

<DEFINE PSETG (FOO BAR "AUX" PL)
	#DECL ((FOO) ATOM (PL) <LIST [REST ATOM]>)
	<SETG .FOO .BAR>
	<COND (<GASSIGNED? PURE-LIST> <SET PL ,PURE-LIST>)
	      (ELSE <SET PL <SETG PURE-LIST ()>>)>
	<COND (<NOT <MEMQ .FOO .PL>>
	       <SETG PURE-LIST <SET PL (.FOO !.PL)>>)
	      (<AND <GASSIGNED? PURE-CAREFUL> ,PURE-CAREFUL>
	       <ERROR PSETG-DUPLICATE .FOO>)>
	.BAR>

<DEFINE FLAGWORD ("TUPLE" FS "AUX" (TOT 1) (CNT 1))
	#DECL ((FS) <TUPLE [REST <OR ATOM FALSE>]> (TOT CNT) FIX)
	<MAPF <>
	      <FUNCTION (F)
		   #DECL ((F) <OR ATOM FALSE>)
		   <COND (<TYPE? .F ATOM> 
			  <COND (<NOT <LOOKUP "GROUP-GLUE" <GET INITIAL OBLIST>>>
				 <MSETG .F .TOT>)>)>
		   <SET TOT <* 2 .TOT>>
		   <COND (<G? <SET CNT <+ .CNT 1>> 36>
			  <ERROR FLAGWORD .CNT>)>>
	      .FS>
	.CNT>

<DEFINE NEWSTRUC (NAM PRIM
		  "ARGS" ELEM
		  "AUX" (LL <FORM <FORM PRIMTYPE .PRIM>>) (L .LL)
			R RR (CNT 1) OFFS DEC)
	#DECL ((NAM) <OR ATOM <LIST [REST ATOM]>> (PRIM) ATOM
	       (LL L RR R) <PRIMTYPE LIST>
	       (CNT) FIX (OFFS DEC) ANY (ELEM) LIST)
	<REPEAT ()
		<COND (<EMPTY? .ELEM>
		       <COND (<ASSIGNED? RR> <PUTREST .R (<VECTOR !.RR>)>)>
		       <COND (<TYPE? .NAM ATOM>
			      <COND (<LOOKUP "COMPILE" <ROOT>>
				     <NEWTYPE .NAM .PRIM .LL>)
				    (<NEWTYPE .NAM .PRIM>)>)
			     (ELSE
			      <PUT .LL 1 .PRIM>
			      <EVAL <FORM GDECL .NAM .LL>>
			      <SET NAM <1 .NAM>>)>
		       <RETURN .NAM>)
		      (<LENGTH? .ELEM 1> <ERROR NEWSTRUC>)>
		<SET OFFS <1 .ELEM>>
		<SET DEC <2 .ELEM>>
		<COND (<OR <NOT .OFFS> <TYPE? .OFFS FORM>>
		       <SET CNT <+ .CNT 1>>
		       <SET ELEM <REST .ELEM>>
		       <AGAIN>)>
		<COND (<AND <TYPE? .OFFS STRING> <=? .OFFS "REST">>
		       <AND <ASSIGNED? RR> <ERROR NEWSTRUC TWO-RESTS>>
		       <SET R .L>
		       <SET RR <SET L <LIST REST>>>
		       <SET ELEM <REST .ELEM>>
		       <AGAIN>)
		      (<LOOKUP "GROUP-GLUE" <GET INITIAL OBLIST>>)
		      (<TYPE? .OFFS ATOM>
		       <MSETG .OFFS .CNT>)
		      (<TYPE? .OFFS LIST>
		       <MAPF <> <FUNCTION (A) <MSETG .A .CNT>> .OFFS>)
		      (ELSE <ERROR NEWSTRUC>)>
		<SET CNT <+ .CNT 1>>
		<PUTREST .L <SET L (.DEC)>>
		<SET ELEM <REST .ELEM 2>>>>

"MAKE-SLOT -- define a funny slot in an object"

<SETG SLOTS ()>

<DEFINE MAKE-SLOT (NAME 'TYP 'DEF) 
	#DECL ((NAME) ATOM (TYP) <OR ATOM FORM> (DEF) ANY)
	<COND
	 (<OR <NOT <GASSIGNED? .NAME>>
	      <AND <ASSIGNED? REDEFINE> .REDEFINE>
	      <ERROR SLOT-NAME-ALREADY-USED!-ERRORS .NAME>>
	  <SETG SLOTS
		(<EVAL <FORM DEFMAC
			     .NAME
			     '('OBJ "OPTIONAL" 'VAL)
			     <FORM COND
				   ('<ASSIGNED? VAL>
				    <FORM FORM OPUT '.OBJ .NAME '.VAL>)
				   (<FORM FORM
					  PROG
					  '()
					  <CHTYPE ('(VALUE) .TYP) DECL>
					  <FORM FORM
						COND
						(<FORM FORM OGET '.OBJ .NAME>)
						(ELSE <FORM QUOTE .DEF>)>>)>>>
		 !,SLOTS)>)>>
