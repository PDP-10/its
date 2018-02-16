
"(c) Copyright 1979, Massachusetts Institute of Technology.  All rights reserved."

<OR <TYPE? ,REP SUBR>
    <SETG SAVEREP ,REP>>

<DEFINE ZGO ()
    <SETG REP ,ZREP>
    <ON "BLOCKED"
	<FUNCTION (FOO)
		  <PRINC !\:>>
	5>
    <ERRET>>

<DEFINE ZREP ZTOP ("AUX" RD)
    #DECL ((ZTOP) <SPECIAL ACTIVATION> (RD) ANY)
    <REPEAT ()
	    <CRLF>
	    <SET RD <READ>>
	    <CRLF>
	    <SET RD <ZEVAL .RD>>
	    <ZPRINT .RD>
	    .RD>>

<DEFINE ZPRINT (ITEM)
    #DECL ((ITEM) ANY)
    <COND (<TYPE? .ITEM OBJECT>
	   <ZOBJ-PRINT .ITEM>)
	  (<TYPE? .ITEM ROOM>
	   <ZRM-PRINT .ITEM>)
	  (<TYPE? .ITEM VERB>
	   <PRINC "Verb = ">
	   <PRINC <STRINGP <1 .ITEM>>>)
	  (<TYPE? .ITEM CEVENT>
	   <ZEV-PRINT .ITEM>)
	  (<TYPE? .ITEM LIST>
	   <ZLST-PRINT .ITEM>)
	  (<==? .ITEM T>
	   <PRINC "True">)
	  (<==? .ITEM <>>
	   <PRINC "False">)
	  (<PRIN1 .ITEM>)>>

<DEFINE ZEV-PRINT (CEV)
    #DECL ((CEV) CEVENT)
    <PRINC "Running ">
    <PRINC <SPNAME <2 .CEV>>>
    <PRINC " in ">
    <PRIN1 <1 .CEV>>
    <PRINC " moves">
    <COND (<NOT <3 .CEV>>
	   <PRINC " (disabled)">)>>

<DEFINE ZLST-PRINT (LST)
    #DECL ((LST) LIST)
    <PRINC "List containing:">
    <ZPC .LST>>

<DEFINE ZOBJ-PRINT (OBJ)
    #DECL ((OBJ) OBJECT)
    <PRINC "Object = ">
    <PRINC <ODESC2 .OBJ>>
    <COND (<OCAN .OBJ>
	   <PRINC " (in ">
	   <PRINC <ODESC2 <OCAN .OBJ>>>
	   <PRINC ")">)>
    <COND (<NOT <EMPTY? <OCONTENTS .OBJ>>>
	   <PRINC " /Contains:">
	   <ZPC <OCONTENTS .OBJ>>)>>

<DEFINE ZPC (LST)
    #DECL ((LST) LIST)
    <PRINC !\ >
    <MAPR <>
	  <FUNCTION (LST2 "AUX" (ITEM <1 .LST2>))
		    #DECL ((LST2) LIST (ITEM) ANY)
		    <COND (<TYPE? .ITEM OBJECT>
			   <PRINC <ODESC2 .ITEM>>)
			  (<PRIN1 .ITEM>)>
		    <OR <LENGTH? .LST2 1>
			<PRINC " & ">>>
	  .LST>>

<DEFINE ZRM-PRINT (RM "AUX" (OBJS <ROBJS .RM>))
    #DECL ((RM) ROOM (OBJS) <LIST [REST OBJECT]>)
    <PRINC "Room = ">
    <PRINC <RDESC2 .RM>>
    <COND (<NOT <EMPTY? .OBJS>>
	   <PRINC "
       Contains:">
	   <ZPC .OBJS>)>
    <PRINC "
       Exits to: ">
    <MAPF <>
	  <FUNCTION (ITM)
		    #DECL ((ITM) ANY)
		    <COND (<TYPE? .ITM DIRECTION>
			   <PRINC <STRINGP .ITM>>
			   <PRINC !\ >)>>
	  <REXITS .RM>>>

<SET ZFLUSH
 <ON "CHAR"
    <FUNCTION (CHR CHN)
	      #DECL ((CHR) CHARACTER (CHN) CHANNEL)
	      <COND (<==? .CHR <ASCII 7>>
		     <INT-LEVEL 0>
		     <AND <GET BLOCKED!-INTERRUPTS INTERRUPT>
			  <OFF "BLOCKED">>
		     <SETG REP ,SAVEREP>
		     <LISTEN>)>>
    8 0 ,INCHAN>>

<DEFINE ZEVAL (ITEM "OPTIONAL" (FLAG <>) "AUX" OPER TEMP)
    #DECL ((ITEM TEMP) ANY (OPER) STRING (FLAG) <OR ATOM FALSE>)
    <COND (<TYPE? .ITEM FIX FLOAT STRING> .ITEM)
	  (<TYPE? .ITEM FORM> <EVAL .ITEM>)
	  (<TYPE? .ITEM ATOM>
	   <SET OPER <SPNAME .ITEM>>
	   <COND (<SET TEMP <ZLOOKUP .OPER ,ZERO-POBL>>
		  <APPLY .TEMP>)
		 (<ZLOOKUP .OPER ,ZVARS-POBL>)
		 (<PLOOKUP .OPER ,OBJECT-POBL>)
		 (<PLOOKUP .OPER ,ROOM-POBL>)
		 (<PLOOKUP .OPER ,WORDS-POBL>)
		 (<ZLOOKUP .OPER ,ZOBITS-POBL>)
		 (<ZLOOKUP .OPER ,ZRBITS-POBL>)
		 (.FLAG #LOSE 0)
		 (ELSE <ILLEGAL "Unknown word: " .OPER>)>)
          (<TYPE? .ITEM LIST>
	   <REPEAT (R I S)
		   #DECL ((R I) ANY (S) STRING)
		   <COND (<EMPTY? .ITEM> <RETURN <AND <ASSIGNED? R> .R>>)>
		   <SET I <1 .ITEM>>
		   <COND (<TYPE? .I ATOM>
			  <SET S <SPNAME .I>>
			  <COND (<SET TEMP <ZLOOKUP .S ,ZERO-POBL>>
				 <SET R <APPLY .TEMP>>)
				(<SET TEMP <ZLOOKUP .S ,ONE-POBL>>
				 <COND (<EMPTY? <SET ITEM <REST .ITEM>>>
					<TOOFEW .S>)
				       (ELSE
					<SET R
					     <APPLY .TEMP
						    <ZEVAL <1 .ITEM>>>>)>)
				(<SET TEMP <ZLOOKUP .S ,TWO-POBL>>
				 <COND (<EMPTY? <SET ITEM <REST .ITEM>>>
					<TOOFEW .S>)
				       (<ASSIGNED? R>
					<SET R
					     <APPLY .TEMP
						    .R
						    <ZEVAL <1 .ITEM>>>>)
				       (ELSE
					<TOOFEW .S>)>)
				(<SET TEMP <ZLOOKUP .S ,ANY-POBL>>
				 <COND (<EMPTY? <SET ITEM <REST .ITEM>>>
					<TOOFEW .S>)
				       (ELSE
					<SET R
					     <APPLY .TEMP
						    <OR <NOT <ASSIGNED? R>>
							.R>
						    .ITEM>>
					<RETURN .R>)>)
				(ELSE <SET R <ZEVAL .I>>)>)
			 (ELSE <SET R <ZEVAL .I>>)>
		   <SET ITEM <REST .ITEM>>>)
	  (<ILLEGAL "ZEVAL of non list, form or atom.">)>>

<DEFINE ZIN (ITM1 ITM2)
    #DECL ((ITM1 ITM2) ANY)
    <COND (<TYPE? .ITM2 LIST>
	   <AND <MEMQ .ITM1 .ITM2> T>)
	  (<TYPE? .ITM1 OBJECT>
	   <COND (<TYPE? .ITM2 OBJECT>
		  <==? <OCAN .ITM1> .ITM2>)
		 (<TYPE? .ITM2 ROOM>
		  <AND <MEMQ .ITM1 <ROBJS .ITM2>> T>)
		 (<TYPE? .ITM2 ADV>
		  <AND <MEMQ .ITM1 <AOBJS ,WINNER>> T>)
		 (<ILLEGAL "Illegal container - " .OBJ2>)>)
	  (<ILLEGAL "Illegal object?">)>>

<DEFINE ZEQUALS (ITM1 ITM2)
    #DECL ((ITM1 ITM2) ANY)
    <COND (<==? <TYPE .ITM1> <TYPE .ITM2>>
	   <==? .ITM1 .ITM2>)
	  (<TYPE? .ITM2 FIX>
	   <COND (<TYPE? .ITM1 OBJECT> <TRNN .ITM1 .ITM2>)
		 (<TYPE? .ITM1 ROOM> <RTRNN .ITM1 .ITM2>)
		 (<ILLEGAL "Unknown type?">)>)>>

"ZIF -- fsubr"

<DEFINE ZIF (DUMMY LST "AUX" P (TOKEN then) (R <>))
	<COND (<SET P <ZEVAL <1 .LST>>>)
	      (ELSE <SET TOKEN else>)>
	<COND (<SET LST <MEMQ .TOKEN .LST>>
	       <MAPF <>
		     <FUNCTION (I)
			  <AND <==? .I else> <MAPLEAVE .R>>
			  <SET R <ZEVAL .I>>>
		     <REST .LST>>)
	      (ELSE <ILLEGAL "If lacks then/else">)>>

"ZCASE -- fsubr"

<SETG EXPR <ILIST 3>>

<DEFINE ZCASE (DUMMY LST "AUX" OBJ (E ,EXPR))
	<SET OBJ <1 .LST>>
	<COND (<TYPE? .OBJ ATOM>)(ELSE <SET OBJ <ZEVAL .OBJ>>)>
	<SET LST <REST .LST>>
	<COND (<EMPTY? .LST> <TOOFEW "case">)
	      (<TYPE? <SET OPR <1 .LST>> ATOM>
	       <SET LST <REST .LST>>)>
	<MAPF <>
	      <FUNCTION (I)
		   <PUT .E 1 .OBJ>
		   <PUT .E 2 .OPR>
		   <PUT .E 3 <1 .I>>
		   <COND (<OR <==? <1 .I> else> <ZEVAL .E>>
			  <MAPLEAVE <ZEVAL <REST .I>>>)>>
	      .LST>>

"ZFOR-EACH -- fsubr"

<DEFINE ZFOR-EACH (DUMMY ARGL)
    #DECL ((ARGL) LIST)
    <COND (<LENGTH? .ARGL 1>
	   <TOOFEW>)
	  (<TYPE? <SET LST <ZEVAL <1 .ARGL>>> LIST>
	   <MAPF <>
		 <FUNCTION (ZITS)
			   #DECL ((ZITS) <SPECIAL ANY>)
			   <ZEVAL <REST .ARGL>>>
		 .LST>)
	  (<ILLEGAL "Argument-not-list/FOR-EACH">)>>

"ZPLUS -- two args"

<DEFINE ZPLUS (A B)
	<COND (<ASSIGNED? B> <+ .A .B>)
	      (ELSE .A)>>

"ZMINUS -- two args"

<DEFINE ZMINUS (A B)
	<COND (<ASSIGNED? B> <- .A .B>)
	      (ELSE .A)>>

"ZTIMES -- two args"

<DEFINE ZTIMES (A B)
	<COND (<ASSIGNED? B> <* .A .B>)
	      (ELSE .A)>>

"ZDIVIDED -- two args"

<DEFINE ZDIVIDED (A B)
	<COND (<ASSIGNED? B> </ .A .B>)
	      (ELSE .A)>>

"ZLESS -- two args"

<DEFINE ZLESS (A B)
	<COND (<ASSIGNED? B> <L? .A .B>)
	      (ELSE .A)>>

"ZGREATER -- two args"

<DEFINE ZGREATER (A B)
	<COND (<ASSIGNED? B> <G? .A .B>)
	      (ELSE .A)>>

"ZEQUAL -- two args"

<DEFINE ZEQUAL (A B)
	<COND (<ASSIGNED? B> <==? .A .B>)
	      (ELSE .A)>>

"ZAND -- two args"
	   
<DEFINE ZAND (A B)
	<COND (<ASSIGNED? B> <AND .A .B>)
	      (ELSE .A)>>

"ZOR -- two args"

<DEFINE ZOR (A B)
	<COND (<ASSIGNED? B> <OR .A .B>)
	      (ELSE .A)>>

"ZIS -- fsubr"

<DEFINE ZIS (OBJ LIST)
	<ZPRED .OBJ .LIST>>

"ZISNT -- fsubr"

<DEFINE ZISNT (OBJ LIST)
	<NOT <ZPRED .OBJ .LIST>>>

"ZPRED -- general predicates"

<DEFINE ZPRED (OBJ EXPR "OPTIONAL" (TTYPE <>)
	      "AUX" (NTTYPE <>) (VAL <>) (NOT? <>) (BOOL? <>))
	#DECL ((OBJ) ANY (EXPR) <OR ATOM LIST>)
	<COND (<TYPE? .EXPR ATOM>
	       <COND (<NOT .TTYPE>
		      <ZEQUALS .OBJ <ZEVAL .EXPR>>)
		     (<=? .TTYPE in>
		      <ZIN .OBJ <ZEVAL .EXPR>>)
		     (ELSE <ERROR UNKNOWN-TTYPE .TTYPE>)>)
	      (ELSE
	       <MAPF <>
		     <FUNCTION (E)
			 #DECL ((E) <OR ATOM LIST>)
			 <COND (<AND <TYPE? .E ATOM> <MEMQ .E ,BUZZ>>)
			       (<==? .E or> <SET BOOL? <>>)
			       (<==? .E and> <SET BOOL? T>)
			       (<==? .E not> <SET NOT? <NOT .NOT?>>)
			       (<MEMQ .E ,TEST-TYPES> <SET NTTYPE .E>)
			       (ELSE
				<SET NVAL <ZPRED .OBJ .E <OR .NTTYPE .TTYPE>>>
				<SET NTTYPE <>>
				<COND (.NOT?
				       <SET NVAL <NOT .NVAL>>
				       <SET NOT? <>>)>
				<COND (.BOOL?
				       <SET VAL <AND .VAL .NVAL>>)
				      (ELSE
				       <SET VAL <OR .VAL .NVAL>>)>)>>
		     .EXPR>
	       .VAL)>>

"ZLOOKUP -- fsubr"

<DEFINE ZLKUP (DUMMY ARGL "AUX" M LST)
    #DECL ((ARGL) LIST (M) <OR FALSE LIST> (LST) ANY)
    <COND (<LENGTH? .ARGL 1> <TOOFEW>)
	  (<TYPE? <SET LST <ZEVAL <2 .ARGL>>> LIST>
	   <AND <SET M <MEMQ <ZEVAL <1 .ARGL>> .LST>>
	        <NOT <LENGTH? .M 1>>>
	   <2 .M>)
	  (<ILLEGAL "Lookup in non-list?">)>>

"ZCONTENTS -- fsubr"

<DEFINE ZCONTENTS (DUMMY ARGL "AUX" (ARG .ARGL) ITEM)
    #DECL ((ARGL ARG) LIST (ITEM) ANY)
    <COND (<OR <EMPTY? .ARGL>
	       <AND <==? <1 .ARGL> of>
		    <SET ARG <REST .ARG>>
		    <LENGTH? .ARGL 1>>>
	   <TOOFEW>)>
    <COND (<TYPE? <SET ITEM <ZEVAL <1 .ARG>>> OBJECT>
	   <OCONTENTS .ITEM>)
	  (<TYPE? .ITEM ROOM>
	   <ROBJS .ITEM>)
	  (<TYPE? .ITEM ADV>
	   <AOBJS .ITEM>)
	  (<ILLEGAL "Unknown/CONTENTS">)>>

"ZSET -- fsubr"

<DEFINE ZSET (DUMMY ARGL)
    #DECL ((ARGL) LIST)
    <COND (<LENGTH? .ARGL 1>
	   <TOOFEW>)
	  (<TYPE? <1 .ARGL> ATOM>
	   <ZINSERT <SPNAME <1 .ARGL>> ,ZVARS-POBL <ZEVAL <2 .ARGL>>>)
	  (<ILLEGAL "Non-atomic set?">)>>

"ZDEFINE -- fsubr"

<DEFINE ZDEFINE (DUMMY ARGL "AUX" STR)
    #DECL ((ARGL) LIST (STR) STRING)
    <COND (<N==? <LENGTH .ARGL> 2>
	   <WNA>)
	  (<ZINSERT <SET STR <SPNAME <1 .ARGL>>>
		    ,ZVARS-POBL
		    <2 .ARGL>>
	   <ZFUNCTION .STR> 
	   <1 .ARGL>)>>

<DEFINE ZFUNCTION (STR)
    #DECL ((STR) STRING)
    <ZINSERT .STR
	     <GET INITIAL OBLIST>
	     <CHTYPE <LIST () <FORM ZEVAL <FORM ZLOOKUP .STR ,ZVARS-POBL>>> FUNCTION>>>

"ZLOAD -- one arg"

<DEFINE ZLOAD (ARG "AUX" STR)
    #DECL ((ARG) ANY (STR) ANY)
    <COND (<AND <TYPE? .ARG STRING> <SET STR .ARG>>
	   <COND (<SET C <OPEN "READ" .STR>>
		  <SET <ZATOM <7 .C>>
		       <MAPF ,LIST
			     <FUNCTION ()
				  #DECL ((ITM) ANY)
				  <SET ITM <READ .C '<MAPSTOP>>>
				  <COND (<TYPE? .ITM LIST>
					 <ZEVAL .ITM>)>
				  .ITM>>>
		  <CLOSE .C>
		  "Done")
		 (<ILLEGAL "File not found.">)>)
	  (<ILLEGAL "Non-string file name?">)>>

"ZATOM -- ??"

<DEFINE ZATOM (STR)
    #DECL ((STR) STRING)
    <OR <LOOKUP .STR <GET INITIAL OBLIST>>
	<INSERT .STR <GET INITIAL OBLIST>>>>

"ZDUMP -- one arg"

<DEFINE ZDUMP (ARG "AUX" STR ATM LST)
    #DECL ((ARG) ANY (STR LST) ANY (ATM) ATOM)
    <COND (<AND <TYPE? .ARG STRING> <SET STR .ARG>>
	   <COND (<SET C <OPEN "PRINT" .STR>>
		  <COND (<AND <ASSIGNED? <SET ATM <ZATOM <7 .C>>>>
			      <TYPE? <SET LST ..ATM> LIST>>
			 <MAPF <>
			       <FUNCTION (ITM)
					 #DECL ((ITM) ANY)
					 <COND (<AND <TYPE? .ITM LIST>
						     <==? <1 .ITM> define>>
						<PPRINT (define
							 <2 .ITM>
							 <ZLOOKUP <SPNAME <2 .ITM>>
								  ,ZVARS-POBL>)
							.C>)
					       (<PPRINT .ITM .C>)>>
			       .LST>
			 <CLOSE .C>
			 <TELL "Done" 0>)
			(<ILLEGAL "Not a group?">)>)
		 (<ILLEGAL "Can't open channel?">)>)
	  (<ILLEGAL "Non-string file name?">)>>

"ZPPRINT -- one arg"

<DEFINE ZPPRINT (DUMMY ARG)
    #DECL ((ARG) ANY)
    <ZEDIT <> .ARG T>>

"ZRUN -- fsubr"

<DEFINE ZRUN (DUMMY ARGL "AUX" STR ARG VAL (CEV <>))
    #DECL ((ARGL) LIST (STR) STRING (VAL ARG) ANY (CEV) <OR FALSE CEVENT>)
    <COND (<EMPTY? .ARGL> <TOOFEW>)
	  (<AND <TYPE? <SET ARG <1 .ARGL>> ATOM>
		<TYPE? <SET VAL <ZLOOKUP <SET STR <SPNAME .ARG>> ,ZVARS-POBL>> LIST>>
	   <MAPF <>
		 <FUNCTION (ITEM)
			   <COND (<MEMQ .ITEM '[in moves]>)
				 (<TYPE? .ITEM FIX>
				  <SET CEV
				       <COND (<ZLOOKUP .STR ,ZINT-POBL>)
					     (<ZINSERT .STR
						       ,ZINT-POBL
						       <CEVENT 0
							       <ZATOM .STR>
							       <>
							       "**::**">>)>>
				  <COND (<MEMQ .CEV ,ZINTS>)
					(<SETG ZINTS (<LOOKUP .STR ,ZINT-POBL>
						      .CEV
						      !,ZINTS)>)>
				  <MAPLEAVE <CLOCK-ENABLE <CLOCK-INT .CEV .ITEM>>>)
				 (<ILLEGAL "Bad argument/RUN">)>>
		 <REST .ARGL>>
	   <OR .CEV <ZEVAL .VAL>>)
	  (<ILLEGAL "Not applicable?">)>> 
				  
"ZENABLE -- one arg"

<DEFINE ZENABLE (ARG "AUX")
    #DECL ((ARG) ANY)
    <CLOCK-ENABLE <ZINT-FIND .ARG>>>

"ZDISABLE -- one arg"

<DEFINE ZDISABLE (ARG "AUX")
    #DECL ((ARG) ANY)
    <CLOCK-DISABLE <ZINT-FIND .ARG>>>

<DEFINE ZINT-FIND (ITEM "AUX" (VARS ,ZVARS-POBL))
    #DECL ((ITEM) ANY (VARS) OBLIST)
    <COND (<AND <TYPE? .ITEM LIST>
		<REPEAT ((L ,ZINTS))
			#DECL ((L) <LIST [REST ATOM CEVENT]>)
			<COND (<EMPTY? .L> <RETURN <>>)
			      (<==? <ZLOOKUP <SPNAME <1 .L>> .VARS> .ITEM>
			       <RETURN <2 .L>>)
			      (<SET L <REST .L 2>>)>>>)
	  (<ILLEGAL "Not an interrupt">)>>

"ZEDIT -- fsubr"

<DEFINE ZEDIT (DUMMY ARGL "OPTIONAL" (PRINT? <>) "AUX" L ARG STR)
    #DECL ((ARGL) LIST (ARG) ANY (L) ANY (PRINT?) <OR FALSE ATOM> (STR) STRING)
    <COND (<EMPTY? .ARGL> <TOOFEW>)
	  (<TYPE? <SET ARG <1 .ARGL>> ATOM>
	   <COND (<TYPE? <SET L <ZLOOKUP <SET STR <SPNAME .ARG>> ,ZVARS-POBL>> LIST>
		  <ZINSERT <SPNAME .ARG> ,ZVARS-POBL <ZEP .L .PRINT?>>
		  .ARG)
		 (<TYPE? .L ROOM OBJECT>
		  <SET VAL <ZEP <ZLOOKUP <SPNAME .ARG> ,ZDEFS-POBL> .PRINT?>>
		  <ZINSERT .STR ,ZDEFS-POBL .VAL>
		  <COND (<TYPE? .L ROOM>
			 <RM/OBJ-CREATE .VAL <>>)
			(<RM/OBJ-CREATE .VAL>)>)
		 (<ILLEGAL "Value of atom not a list?">)>)
	  (<ILLEGAL "Must edit an atom.">)>>
	   
<DEFINE ZEP (OBJ PRINT?)
    #DECL ((OBJ) LIST (PRINT?) <OR ATOM FALSE>)
    <COND (.PRINT?
	   <PPRINT .OBJ>
	   .OBJ)
	  (<TELL " Starting edit." 0>
	   <EDIT OBJ>
	   <TELL "
Return from edit.">
	   .OBJ)>>

"zero-arg goodies"

<DEFINE ZWINNER () ,WINNER>

<DEFINE ZTRUE () T>

<DEFINE ZFALSE () <>>

<DEFINE ZSCORE () <ASCORE ,WINNER>>

<DEFINE ZPRSO () <PRSO>>

<DEFINE ZROOM () ,HERE>

<DEFINE ZPRSI () <PRSI>>

<DEFINE ZVERB () <PRSA>>
				
<DEFINE ZIT () .ZITS>

<DEFINE ZZORK () <OFF "BLOCKED"> <DC>>

"ZTAKE -- one arg"

<DEFINE ZTAKE (ARG "AUX" OBJ)
    #DECL ((ARG) ANY (OBJ) ANY)
    <COND (<TYPE? .ARG OBJECT>
	   <REMOVE-OBJECT .OBJ>
	   <TAKE-OBJECT .OBJ>)>>
		
"ZREMOVE -- fsubr"

<DEFINE ZREMOVE (DUMMY LST "AUX" OBJ)
    #DECL ((LST) LIST (OBJ) ANY)
    <COND (<EMPTY? .LST>
	   <TOOFEW>)
	  (<MAPF <>
		 <FUNCTION (ITM)
			   #DECL ((ITM) ANY)
			   <COND (<==? .ITM and>)
				 (<TYPE? <SET OBJ <ZEVAL .ITM>> OBJECT>
				  <REMOVE-OBJECT .OBJ>)
				 (<ILLEGAL "Not an object/REMOVE">)>>
		 .LST>)
	  (<ILLEGAL "Not an object/REMOVE">)>>

"ZPUTIN -- fsubr"

<DEFINE ZPUTIN (DUMMY LST "AUX" OBJ)
    #DECL ((LST) LIST (OBJ) ANY)
    <COND (<LENGTH? .LST 1>
	   <TOOFEW>)
	  (ELSE
	   <SET OBJ2 <COND (<MEMQ <2 .LST> ![in into to]>
			    <COND (<LENGTH? .LST 2>
				   <TOOFEW>)
				  (<ZEVAL <3 .LST>>)>)
			   (<ZEVAL <2 .LST>>)>>
	   <COND (<TYPE? .OBJ2 LIST>
		  <CONS <ZEVAL <1 .LST>> .OBJ2>)
		 (<TYPE? <SET OBJ <ZEVAL <1 .LST>>> OBJECT>
		  <REMOVE-OBJECT .OBJ>
		  <COND (<TYPE? .OBJ2 ROOM>
			 <INSERT-OBJECT .OBJ .OBJ2>)
			(<TYPE? .OBJ2 OBJECT>
			 <INSERT-INTO .OBJ2 .OBJ>)
			(<TYPE? .OBJ2 ADV>
			 <TAKE-OBJECT .OBJ>)
			(<ILLEGAL "Illegal operator/INSERT">)>)
		 (<ILLEGAL "Not an object/INSERT">)>)>>

"ZTELL -- fsubr"

<DEFINE ZTELL (DUMMY LST)
    <MAPF <>
	  <FUNCTION (ITEM)
		    <COND (<TYPE? .ITEM STRING>
			   <TELL .ITEM 0>)
			  (<==? .ITEM crlf>
			   <TELL "">)
			  (<TYPE? <SET VAL <ZEVAL .ITEM>> OBJECT>
			   <TELL <ODESC2 .VAL> 0>)
			  (<ILLEGAL "Unknown print operator.">)>>
	  .LST>> 

"ZGOTO -- one arg"

<DEFINE ZGOTO (ARG)
    #DECL ((ARG) ANY)
    <COND (<TYPE? .ARG ROOM> <GOTO .ARG>)
	  (<ILLEGAL "Not a room/GOTO">)>>

"ZMAKE -- fsubr"

<DEFINE ZMAKE (DUMMY LST "AUX" OBJ (NOT? <MEMQ not .LST>))
    #DECL ((LST) LIST (OBJ) ANY (NOT?) <OR FALSE LIST>)
    <COND (<OR <AND .NOT? <LENGTH? .LST 2>>
	       <LENGTH? .LST 1>>
	   <TOOFEW>)
	  (<TYPE? <SET OBJ <ZEVAL <1 .LST>>> OBJECT>
	   <COND (<SET M <ZLOOKUP <SPNAME <COND (.NOT? <3 .LST>) (<2 .LST>)>>
				  ,ZOBITS-POBL>>
		  <COND (.NOT?
			 <TRZ .OBJ .M>)
			(<TRO .OBJ .M>)>)
		 (<ILLEGAL "Not an object flag/MAKE">)>)
	  (<TYPE? .OBJ ROOM>
	   <COND (<SET M <ZLOOKUP <SPNAME <COND (.NOT? <3 .LST>) (<2 .LST>)>>
				  ,ZRBITS-POBL>>
		  <COND (.NOT?
			 <RTRZ .OBJ .M>)
			(<RTRO .OBJ .M>)>)
		 (<ILLEGAL "Not a room flag/MAKE">)>)
	  (<ILLEGAL "Not a room or object/MAKE">)>>
    
<DEFINE ZTOPLEVEL () <ERRET>>

<DEFINE ZSTACK& () <ZSTACK T>>

<DEFINE ZSTACK ("OPTIONAL" (FLG <>) "AUX" (F <FRAME>) (LEVEL -1) ARG) 
	#DECL ((FLG) <OR ATOM FALSE> (F) FRAME (LEVEL) FIX (ARG) ANY)
	<REPEAT ()
		<COND (<==? <FUNCT .F> TOPLEVEL>
		       <PRINC "toplevel">
		       <RETURN>)
		      (<AND <==? <FUNCT .F> EVAL>
			    <TYPE? <SET ARG <1 <ARGS .F>>> FORM>
			    <OR <==? <1 .ARG> ZEVAL>
				<==? <1 .ARG> ZPRED>
				<==? <1 .ARG> ILLEGAL>>>
		       <PRIN1 <SET LEVEL <+ .LEVEL 1>>>
		       <PRINC !\ >
		       <PRIN1 <1 .ARG>>
		       <INDENT-TO 10>
		       <COND (.FLG
			      <&1 <EVAL <2 .ARG> .F>>
			      <AND <==? <1 .ARG> ZPRED>
				   <CRLF>
				   <INDENT-TO 10>
				   <&1 <EVAL <3 .ARG> .F>>>)
			     (<EPRIN1 <EVAL <2 .ARG> .F>>
			      <AND <==? <1 .ARG> ZPRED>
				   <CRLF>
				   <INDENT-TO 10>
				   <EPRIN1 <EVAL <3 .ARG> .F>>>)>
		       <CRLF>)>
		<SET F <FRAME .F>>>
	,NULL>

<DEFINE ZRETURN (DUMMY ARGL)
    #DECL ((ARGL) LIST)
    <ZRETRY <ZEVAL <2 .ARGL>> <ZEVAL <1 .ARGL>>>>

<DEFINE ZRETRY (TARGET "OPTIONAL" (VAL #LOSE 0) "AUX" (LEVEL -1) (F <FRAME>) ARG)
    #DECL ((TARGET LEVEL) FIX (ARG VAL) ANY (F) FRAME)
    <COND (<TYPE? .TARGET FIX>
	   <REPEAT ()
		   <COND (<==? <FUNCT .F> TOPLEVEL>
			  <PRINC "Beyond toplevel?">
			  <RETURN>)
			 (<AND <==? <FUNCT .F> EVAL>
			       <TYPE? <SET ARG <1 <ARGS .F>>> FORM>
			       <OR <==? <1 .ARG> ZEVAL>
				   <==? <1 .ARG> ZPRED>
				   <==? <1 .ARG> ILLEGAL>>
			       <==? <SET LEVEL <+ .LEVEL 1>> .TARGET>>
			  <COND (<TYPE? .VAL LOSE>
				 <RETRY .F>)
				(<ERRET .VAL .F>)>)>
		   <SET F <FRAME .F>>>)
	  (<ILLEGAL "Bad argument to RETRY/RETURN">)>>

<DEFINE ZCREATE (DUMMY ARGL "AUX" TYP)
    #DECL ((ARGL) LIST (TYP) ANY)
    <COND (<==? <SET TYP <1 .ARGL>> room>
	   <RM/OBJ-CREATE <REST .ARGL> <>>)
	  (<==? .TYP object>
	   <RM/OBJ-CREATE <REST .ARGL>>)
	  (<==? .TYP syntax>
	   <SYNTAX-CREATE <REST .ARGL>>)
	  (<==? .TYP list>
	   <MAPF ,LIST ,ZEVAL <REST .ARGL>>)
	  (<ILLEGAL "Unknown type/CREATE">)>>

<SETG HI-RM/OBJ 0>

<DEFINE NEXT-RM/OBJ ()
    <STRING "Z" <UNPARSE <SETG HI-RM/OBJ <+ ,HI-RM/OBJ 1>>>>>

<DEFINE RM/OBJ-CREATE (ARGL "OPTIONAL" (OBJ? T)
		            "AUX" NAME (OBJS ()) RM OBJ SYN ADJ)
    #DECL ((ARGL) LIST (NAME) ATOM (OBJS) <LIST [REST OBJECT]>
	   (RM) ROOM (OBJECT) OBJECT (OBJ?) <OR ATOM FALSE>
	   (SYN) <UVECTOR [REST PSTRING]> (ADJ) <UVECTOR [REST ADJECTIVE]>)
    <MAPF <>
	  <FUNCTION (ITEM "AUX" OPER VAL VAL2)
	      #DECL ((ITEM OPER VAL VAL2) ANY)
	      <COND (<TYPE? .ITEM ATOM>
		     <SET NAME .ITEM>
		     <SET VAL <ZLOOKUP <SPNAME .NAME> ,ZVARS-POBL>>
		     <COND (.OBJ?
			    <SET OBJ
				 <COND (<TYPE? .VAL OBJECT> .VAL)
				       (<GET-OBJ <NEXT-RM/OBJ>>)>>)
			   (<SET RM
				 <COND (<TYPE? .VAL ROOM> .VAL)
				       (<GET-ROOM <NEXT-RM/OBJ>>)>>)>)
		     (<TYPE? .ITEM LIST>
		      <COND (<LENGTH? .ITEM 1>
			     <ILLEGAL "Bad format/CREATE">)
			    (<==? <SET OPER <1 .ITEM>> property>
			     <COND (.OBJ?
				    <PUT .OBJ
					 ,OFLAGS
					 <BITS-GET ,ZOBITS-POBL <REST .ITEM>>>)
				   (<PUT .RM
					 ,RBITS
					 <BITS-GET ,ZRBITS-POBL <REST .ITEM>>>
				    <RTRO .RM ,RLANDBIT>)>)
			    (<AND <SET VAL <2 .ITEM>> <>>)
			    (<==? .OPER name>
			     <COND (.OBJ?
				    <PUT .OBJ ,ODESC2 .VAL>)
				   (<PUT .RM ,RDESC2 .VAL>)>)
			    (<==? .OPER description>
			     <COND (.OBJ?
				    <OPUT .OBJ ODESC1 .VAL T>)
				   (<PUT .RM ,RDESC1 .VAL>)>)
			    (<==? .OPER run>
			     <COND (<TYPE? .VAL ATOM>
				    <COND (<GASSIGNED? .VAL>)
					  (<SETG .VAL ,ZFALSE>)>
				    <COND (.OBJ?
					   <PUT .OBJ ,OACTION .VAL>)
					  (<PUT .RM ,RACTION .VAL>)>)
				   (<ILLEGAL "Bad routine/CREATE">)>)
			    (<==? .OPER contents>
			     <MAPF <>
				   <FUNCTION (FOO)
					     #DECL ((FOO) ANY)
					     <COND (<TYPE? <SET VAL2 <ZEVAL .FOO T>>
							   OBJECT>
						    <REMOVE-OBJECT .VAL2>)
						   (<TYPE? .VAL2 LOSE>
						    <SET VAL2
							 <RM/OBJ-CREATE (.FOO)>>)
						   (<ILLEGAL "Bad object/CREATE">)>
					     <SET OBJS (.VAL2 !.OBJS)>>
				   <REST .ITEM>>)
			    (<AND <NOT .OBJ?> <==? .OPER exit>>
			     <ZEXIT .RM <REST .ITEM>>)
			    (<AND .OBJ? <==? .OPER synonym>>
			     <SET SYN
				  <MAPF ,UVECTOR
				   <FUNCTION (NAM)
					#DECL ((NAM) ANY)
					<COND (<TYPE? .NAM ATOM>
					       <ZSYN .NAM .OBJ>)
					      (<ILLEGAL "Bad synonym/CREATE">)>>
				   <REST .ITEM>>>)
			    (<AND .OBJ? <==? .OPER adjective>>
			     <SET ADJ
				  <MAPF ,UVECTOR
				   <FUNCTION (NAM)
					#DECL ((NAM) ANY)
					<COND (<TYPE? .NAM ATOM>
					       <ADD-ZORK ADJECTIVE <SPNAME .NAM>>)
					      (<ILLEGAL "Bad adjective/CREATE">)>>
				   <REST .ITEM>>>)
			    (<ILLEGAL "Bad identifier/CREATE">)>)>>
	  .ARGL>
    <ZINSERT <SPNAME .NAME> ,ZDEFS-POBL .ARGL>
    <COND (.OBJ?
	   <PUT .OBJ ,OCONTENTS ()>
	   <MAPF <>
		 <FUNCTION (NOBJ) #DECL ((NOBJ) OBJECT)
			   <INSERT-INTO .OBJ .NOBJ>>
		 .OBJS>
	   <AND <ASSIGNED? SYN> <PUT .OBJ ,ONAMES .SYN>>
	   <AND <ASSIGNED? ADJ> <PUT .OBJ ,OADJS .ADJ>>
	   <ZINSERT <SPNAME .NAME> ,ZVARS-POBL .OBJ>
	   .OBJ)
	  (<PUT .RM ,ROBJS ()>
	   <MAPF <>
		 <FUNCTION (NOBJ) #DECL ((NOBJ) OBJECT)
			   <INSERT-OBJECT .NOBJ .RM>>
		 .OBJS>
	   <ZINSERT <SPNAME .NAME> ,ZVARS-POBL .RM>
	   .RM)>>

<DEFINE ZSYN (NAM OBJ "AUX" (S <SPNAME .NAM>) STR)
    #DECL ((NAM) ATOM (S STR) STRING (OBJ) OBJECT)
    <SET STR <UPPERCASE <SUBSTRUC .S 0 <MIN <LENGTH .S> 5>>>>
    <PINSERT .STR ,OBJECT-POBL .OBJ>
    <PSTRING .STR>>

<DEFINE ZEXIT (THIS LST "AUX" DIR RM RM? (NEXIT <>) (CEXIT <>) (CFCN <>) M EXIT)
    #DECL ((LST) LIST (DIR) <OR DIRECTION FALSE> (RM?) ANY (RM THIS) ROOM
	   (NEXIT) <OR STRING FALSE> (CEXIT CFCN) <OR FALSE ATOM> (EXIT) ANY
	   (M) <OR FALSE <VECTOR [REST DIRECTION ANY]>>) 
    <COND (<LENGTH? .LST 2>
	   <TOOFEW>)
	  (<SET DIR <PLOOKUP <UPPERCASE <PNAME <1 .LST>>> ,DIRECTIONS-POBL>>
	   <COND (<==? <2 .LST> to>
		  <COND (<TYPE? <SET RM? <ZEVAL <3 .LST> T>> ROOM>)
			(<TYPE? .RM? LOSE>
			 <SET RM? <RM/OBJ-CREATE (<3 .LST>) <>>>)
			(<TYPE? .RM? STRING>
			 <SET NEXIT .RM?>)
			(<ILLEGAL "Not-a-room/EXIT">)>
		  <SET RM .RM?>
		  <SET LST <REST .LST 3>>
		  <COND (<EMPTY? .LST>)
			(<AND <==? <1 .LST> if>
			      <NOT <LENGTH? .LST 1>>>
			 <COND (<==? <2 .LST> run>
				<COND (<LENGTH? .LST 2>
				       <SET CFCN <3 .LST>>)
				      (<ILLEGAL "Bad format/EXIT">)>)
			       (<SET CEXIT <2 .LST>>)>)
			(<ILLEGAL "Bad format/EXIT">)>
		  <SET EXIT
		       <COND (.NEXIT <CHTYPE .NEXIT STRING>)
			     (.CEXIT <CEXIT <SPNAME .CEXIT> <RID .RM> "" <> <>>)
			     (.CFCN <CEXIT "FROBOZZ" <RID .RM> "" <> .CFCN>)
			     (.RM)>>
		  <COND (<SET M <MEMQ .DIR <REXITS .THIS>>>
			 <PUT .M 2 .EXIT>)
			(<PUT .THIS ,REXITS <VECTOR .DIR .EXIT !<REXITS .THIS>>>)>)
		 (<ILLEGAL "Bad format/EXIT">)>)
	  (<ILLEGAL "Unknown-direction: " <1 .LST>>)>>

<DEFINE BITS-GET (POBL ARGL "AUX" FX)
    #DECL ((ARGL) LIST (POBL) OBLIST (FX) <OR FIX FALSE>)
    <MAPF ,+
	  <FUNCTION (ITEM)
		    <COND (<AND <TYPE? .ITEM ATOM>
				<SET FX <ZLOOKUP <SPNAME .ITEM> .POBL>>>)
			  (<ILLEGAL "Illegal property.">)>>
	  .ARGL>>

<DEFINE ZOBLIST (ATM NUM)
    <SETG .ATM <MOBLIST .ATM .NUM>>>

<DEFINE ZLOOKUP (STR OBL "AUX" ATM)
    #DECL ((STR) STRING (OBL) OBLIST (ATM) <OR FALSE ATOM>)
    <AND <SET ATM <LOOKUP .STR .OBL>> ,.ATM>>

<DEFINE ZINSERT (STR OBL VAL)
    #DECL ((STR) STRING (OBL) OBLIST (VAL) ANY)
    <SETG <OR <LOOKUP .STR .OBL> <INSERT .STR .OBL>> .VAL>>

<DEFINE PINS (POBL VEC)
    #DECL ((POBL) OBLIST (VEC) <VECTOR [REST <OR STRING ATOM> ANY]>)
    <REPEAT ((V .VEC) ELEM)
	#DECL ((V) <VECTOR [REST <OR STRING ATOM> ANY]> (ELEM) <OR STRING ATOM>)
	<ZINSERT <COND (<TYPE? <SET ELEM <1 .V>> ATOM>
			<PNAME .ELEM>)
		       (.ELEM)>
		 .POBL
		 <2 .V>>
	<COND (<EMPTY? <SET V <REST .V 2>>>
	       <RETURN>)>>>

<ZOBLIST ZOBITS-POBL 17>
<ZOBLIST ZRBITS-POBL 17>
<ZOBLIST ZVARS-POBL 17>
<ZOBLIST ZDEFS-POBL 17>
<ZOBLIST ZINT-POBL 17>

<ZOBLIST ZERO-POBL 17>
<ZOBLIST ONE-POBL 17>
<ZOBLIST TWO-POBL 17>
<ZOBLIST ANY-POBL 17>

<SETG ZINTS ()>

<GDECL (ZINTS) <LIST [REST ATOM CEVENT]>>

<PINS ,ANY-POBL
      ["edit" ,ZEDIT "pprint" ,ZPPRINT
       "if" ,ZIF "case" ,ZCASE "for-each" ,ZFOR-EACH "contents" ,ZCONTENTS
       "is" ,ZIS "isnt" ,ZISNT  
       "define" ,ZDEFINE "set" ,ZSET "run" ,ZRUN "lookup" ,ZLKUP
       "remove" ,ZREMOVE "insert" ,ZPUTIN "return" ,ZRETURN "put" ,ZPUTIN
       "print" ,ZTELL "make" ,ZMAKE "create" ,ZCREATE]>

<PINS ,TWO-POBL
      ["and" ,ZAND "or" ,ZOR "plus" ,ZPLUS "minus" ,ZMINUS
       "times" ,ZTIMES "divided-by" ,ZDIVIDED "is-greater-than" ,ZGREATER
       "is-less-than" ,ZLESS "gt" ,ZGREATER "lt" ,ZLESS "eq" ,ZEQUAL
       "equals" ,ZEQUAL]>

<PINS ,ONE-POBL
      ["retry" ,ZRETRY "goto" ,ZGOTO "take" ,ZTAKE
       "load" ,ZLOAD "dump" ,ZDUMP "enable" ,ZENABLE "disable" ,ZDISABLE
       ]>

<PINS ,ZERO-POBL
      ["stack" ,ZSTACK "stack&" ,ZSTACK& "toplevel" ,ZTOPLEVEL
       "me" ,ZWINNER "hand" ,ZWINNER "player" ,ZWINNER
       "handled" ,ZTRUE
       "not-handled" ,ZFALSE
       "room" ,ZROOM "here" ,ZROOM
       "verb" ,ZVERB "zork" ,ZZORK
       "objo" ,ZPRSO "direct-object" ,ZPRSO "object" ,ZPRSO
       "indirect-object" ,ZPRSI "obji" ,ZPRSI "it" ,ZIT
       "score" ,ZSCORE]>

<PINS ,ZOBITS-POBL 
      ["visible" ,OVISON "readable" ,READBIT "burnable" ,BURNBIT
       "weapon" ,WEAPONBIT "takeable" ,TAKEBIT "villain" ,VILLAIN
       "container" ,CONTBIT "edible" ,FOODBIT "transparent" ,TRANSBIT
       "indescribable" ,NDESCBIT "drinkable" ,DRINKBIT "potable" ,DRINKBIT
       "light" ,LIGHTBIT "victim" ,VICBIT "flaming" ,FLAMEBIT "tool" ,TOOLBIT
       "turnable" ,TURNBIT "vehicle" ,VEHBIT "sacred" ,SACREDBIT "tieable"
       ,TIEBIT "climbable" ,CLIMBBIT "open" ,OPENBIT "touched" ,TOUCHBIT
       "on" ,ONBIT]>

<PINS ,ZRBITS-POBL
       ["land" ,RLANDBIT "seen" ,RSEENBIT "illuminated" ,RLIGHTBIT 
	"sacred" ,RSACREDBIT "reservoir" ,RFILLBIT
	"inaccessible" ,RMUNGBIT "wallless" ,RNWALLBIT]>

<SETG BUZZ ![a the is]>

<SETG NOTS [not isnt]>

<SETG TEST-TYPES [in]>

<DEFINE ILLEGAL ("OPTIONAL" (STR "Illegal operation.") (STR2 ""))
    #DECL ((STR) STRING)
    <TELL .STR 0 .STR2>
    <LISTEN>>

<DEFINE TOOFEW ("OPTIONAL" WHAT)
    <TELL "Too few arguments" 0>
    <AND <ASSIGNED? WHAT> <TELL " to " 0 .WHAT>>
    <LISTEN>>

<DEFINE WNA ()
    <TELL "Wrong number of arguments." 0>
    <LISTEN>>


