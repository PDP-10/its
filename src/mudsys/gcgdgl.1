
<PACKAGE "GC-GRLOAD">

<ENTRY GC-GROUP-LOAD GC-GROUP-DUMP>

<USE "EDIT">

<COND (<G? ,MUDDLE 100> <SETG TNM1 "ETMP"> <SETG TNM2 "MUDT">)
      (ELSE <SETG TNM1 "_ETMP_"> <SETG TNM2 ">">)>

<SETG VCOMP
      <FORM COND
	    (<FORM N==? ,MUDDLE <FORM GVAL MUDDLE>>
	     <FORM ERROR RSUBR-CANT-RUN-IN-THIS-VERSION-OF-MUDDLE!-ERRORS>)>>

<DEFINE GC-GROUP-LOAD (STR
		       "OPTIONAL" NAM
		       "AUX" (CHN <OPEN "READB" .STR>) FSP (REDEFINE T))
	#DECL ((REDEFINE) <SPECIAL ANY>)
	<PROG ()
	      <COND (<NOT <TYPE? .CHN CHANNEL>> <RETURN .CHN>)>
	      <COND (<NOT <ASSIGNED? NAM>>
		     <SET NAM
			  <PARSE <MAPF ,STRING
				       <FUNCTION (C) <MAPRET !"\\ .C>>
				       <7 .CHN>>>>)>
				      ;"To hack ugly file names. (TT, 75/10/07)"
	      <PUT .NAM
		   CHANNEL
		   <SET FSP <LIST <7 .CHN> <8 .CHN> <9 .CHN> <10 .CHN>>>>
	      <EVAL <GC-READ .CHN>>
	      <CLOSE .CHN>
	      .NAM>>

<DEFINE GC-GROUP-DUMP (STR
		       "OPTIONAL" NM (BKILLER T)
		       "AUX" (CHN <CHANNEL "PRINTB" .STR>)
			     (NAM
			      <COND (<ASSIGNED? NM> .NM)
				    (ELSE <PARSE <7 .CHN>>)>)
			     (OC
			      <OPEN "PRINTB" ,TNM1 ,TNM2 <9 .CHN> <10 .CHN>>)
			     (FIXERS ()) FUNC BKS TEM TT HOLDANY GRP FIXES)
   #DECL ((CHN) CHANNEL (NAM) ATOM (OC) <OR CHANNEL FALSE> (FIXERS) LIST)
   <PROG ()
     <COND (<NOT .OC> <RETURN .OC>)>
     <COND (<OR <NOT <ASSIGNED? .NAM>> <NOT <TYPE? ..NAM LIST>>>
	    <CLOSE .OC>
	    <RETURN #FALSE ("Not a valid group name")>)>
     <SET GRP ..NAM>
     <SET FIXERS
	  (<FORM PUT .NAM BLOCK <FORM UNGET <UNGET <GET .NAM BLOCK '.OBLIST>>>>
	   !.FIXERS)>
     <MAPR <>
      <FUNCTION (OBP "AUX" (OB <1 .OBP>)) 
	 <COND (<SET TEM <GET <FORM QUOTE .OBP> COMMENT>>
		<SET FIXERS
		     (<FORM PUT <FORM QUOTE .OBP> COMMENT .TEM> !.FIXERS)>)>
	 <COND (<SET TEM <GET .OBP BLOCK>>
		<SET FIXERS
		     (<FORM PUT
			    <FORM QUOTE .OBP>
			    BLOCK
			    <FORM UNGET <UNGET .TEM>>>
		      !.FIXERS)>)>
	 <COND
	  (<AND <TYPE? .OB FORM> <NOT <EMPTY? .OB>>>
	   <COND
	    (<OR <==? <SET TEM <1 .OB>> DEFINE> <==? .TEM DEFMAC>>
	     <COND
	      (<AND
		.BKILLER				   ;"Breakpoint killer"
		<G? <LENGTH .OB> 1>
		<SET BKS
		     <GETPROP
		      <AND <GASSIGNED? <SET FUNC <GET <2 .OB> VALUE '<2
								      .OB>>>>
			   <GLOC .FUNC>>
		      BREAKS>>>
	       <PUTPROP <GLOC .FUNC> BREAKS>
	       <REPEAT ()
		       <COND (<EMPTY? .BKS> <RETURN>)>
		       <COND (<TYPE? <SET HOLDANY <IN <1 .BKS>>> BREAK>
			      <SETLOC <1 .BKS> <2 .HOLDANY>>)>
		       <SET BKS <REST .BKS>>>)>
	     <SET TEM <COMMENT-ON .OB>>
	     <COND (<NOT <EMPTY? .TEM>>
		    <PUTREST <REST .TEM <- <LENGTH .TEM> 1>> .FIXERS>
		    <SET FIXERS .TEM>)>)
	    (<AND <==? .TEM SETG>
		  <==? <LENGTH .OB> 3>
		  <TYPE? <SET NM <GET <2 .OB> VALUE '<2 .OB>>> ATOM>
		  <OR <TYPE? <SET TEM <3 .OB>> RSUBR>
		      <AND <GASSIGNED? .NM> <TYPE? <SET TEM ,.NM> RSUBR>>>
		  <==? .NM <2 .TEM>>>
	     <COND (<AND <TYPE? <1 .TEM> CODE> <SET FIXES <GET .TEM RSUBR>>>
		    <SET FIXERS
			 (<FORM FIXIT <FORM QUOTE .TEM> .FIXES> !.FIXERS)>)
		   (<TYPE? <1 .TEM> CODE>
		    <PRINC 
"Warning:  RSUBR lacks fixups, only use in same MUDDLE version.  ">
		    <PRIN1 .NM>
		    <CRLF>
		    <SET FIXERS (,VCOMP !.FIXERS)>)>
	     <COND (<NOT <EMPTY? <SET TT <ANON-SRCH .TEM>>>>
		    <PUTREST <REST .TT <- <LENGTH .TT> 1>> .FIXERS>
		    <SET FIXERS .TT>)>
	     <COND (<TYPE? <SET TT <1 .TEM>> PCODE>
		    <SET FIXERS
			 (<FORM PUT
				<FORM QUOTE .TEM>
				1
				<PARSE <REST <UNPARSE .TT>>>>
			  !.FIXERS)>)>)>)>>
      .GRP>
     <GC-DUMP (<FORM MAPF
		     <>
		     <FORM GVAL EVAL>
		     <FORM SET .NAM <FORM QUOTE .GRP>>>
	       .FIXERS)
	      .OC>
     <RENAME .OC .STR>
     <CLOSE .OC>
     .NAM>>

<DEFINE COMMENT-ON (OB "AUX" (L ()) TEM TT) 
   <COND
    (<NOT <MONAD? .OB>>
     <MAPR <>
	   <FUNCTION (OBP) 
		   <COND (<SET TEM <GET .OBP COMMENT>>
			  <SET L
			       (<FORM PUT <FORM QUOTE .OBP> COMMENT .TEM>
				!.L)>)>
		   <COND (<NOT <EMPTY? <SET TEM <COMMENT-ON <1 .OBP>>>>>
			  <PUTREST <REST .TEM <- <LENGTH .TEM> 1>> .L>
			  <SET L .TEM>)>>
	   <REST .OB>>
     <COND (<SET TEM <GET <1 .OB> COMMENT>>
	    <SET L (<FORM PUT <FORM QUOTE <1 .OB>> COMMENT .TEM> !.L)>)>
     <COND (<OR <SET TEM <GET <SET TT .OB> COMMENT>>
		<SET TEM <GET <SET TT <REST .OB 0>> COMMENT>>>
	    <SET L (<FORM PUT <FORM QUOTE .TT> COMMENT .TEM> !.L)>)>)
    (<SET TEM <GET .OB COMMENT>> <SET L (.TEM)>)>
   .L>

<DEFINE ANON-SRCH (R "AUX" (L ()) TEM) 
   #DECL ((R) <PRIMTYPE VECTOR> (L) LIST)
   <MAPR <>
    <FUNCTION (THP "AUX" (THING <1 .THP>)) 
	    <COND (<AND <TYPE? .THING RSUBR>
			<G? <LENGTH .THING> 1>
			<TYPE? <SET TEM <2 .THING>> ATOM>
			<OR <NOT <GASSIGNED? .TEM>> <N==? ,.TEM .THING>>>
		   <COND (<AND <TYPE? <1 .THING> CODE>
			       <SET TEM <GET .THING RSUBR>>>
			  <SET L (<FORM FIXIT <FORM QUOTE .THING> .TEM> !.L)>)
			 (<TYPE? <1 .THING> CODE>
			  <PRINC 
"Warning:  RSUBR lacks fixups, only use in same MUDDLE version.  ">
			  <PRIN1 <2 .THING>>
			  <CRLF>)>)>
	    <COND (<AND <TYPE? .THING RSUBR> <TYPE? <1 .THING> PCODE>>
		   <SET L
			(<FORM PUT
			       <FORM QUOTE .THING>
			       1
			       <PARSE <REST <UNPARSE <1 .THING>>>>>
			 !.L)>)>
	    <COND (<TYPE? .THING LOCD LOCR TYPE-W TYPE-C>
		   <SET L
			(<FORM PUT
			       <FORM QUOTE .THP>
			       1
			       <PARSE <REST <UNPARSE .THING>>>>
			 !.L)>
		   <COND (<TYPE? .THING LOCD>
			  <PUT .THP 1 LOCD>)>)>>
    .R>
   .L>

<DEFINE UNGET (O)
	<MAPF ,LIST <FUNCTION (X) <GET .X OBLIST>> .O>>

<ENDPACKAGE>
