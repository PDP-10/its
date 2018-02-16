"(c) Copyright 1978, Massachusetts Institute of Technology.  All rights reserved."
"UTILITY FUNCTIONS ONLY!"

;"Functions for hacking objects, rooms, winner, etc.
  REMOVE-OBJECT <obj>
	Remove an object from any room or ,WINNER or its container.
  INSERT-OBJECT <obj> <room>
	Put the object into the room.
  REMOVE-FROM <obj1> <obj2>
	Make obj1 no longer contain obj2.
  INSERT-INTO <obj1> <obj2>
	Make obj1 contain obj2.
  TAKE-OBJECT <obj> {OPTIONAL} <adv>
	Make <obj> one of <adv>'s possessions.
  DROP-OBJECT <obj> {OPTIONAL} <adv>
	Remove <obj> from <adv>'s possessions.
  DROP-IF <obj> {OPTIONAL} <adv>
	Do a DROP-OBJECT if <adv> has <obj> as a possession.
  SNARF-OBJECT <obj1> <obj2>
 	Find <obj1>, REMOVE-OBJECT it, and <INSERT-INTO <obj2> <obj1>.

  IN-ROOM? <obj> {OPTIONAL} <room>
	Is <obj> anywhere inside the room (but not with ,WINNER)?
 	IN-ROOM? does not check OVISON!

  HACKABLE?
	Is <obj> either in ,HERE or in current vehicle.
	Uses SEARCH-LIST so completely groks visibility, containers, etc.

"

\

<DEFINE REMOVE-OBJECT (OBJ "OPTIONAL" (WINNER ,WINNER) "AUX" OCAN OROOM)
	#DECL ((OBJ) OBJECT (OCAN) <OR OBJECT FALSE> (OROOM) <OR FALSE ROOM>
	       (WINNER) ADV)
	<COND (<SET OCAN <OCAN .OBJ>>
	       <PUT .OCAN ,OCONTENTS <SPLICE-OUT .OBJ <OCONTENTS .OCAN>>>)
	      (<SET OROOM <OROOM .OBJ>>
	       <PUT .OROOM ,ROBJS <SPLICE-OUT .OBJ <ROBJS .OROOM>>>)
	      (<MEMQ .OBJ <AOBJS .WINNER>>
	       <PUT .WINNER ,AOBJS <SPLICE-OUT .OBJ <AOBJS .WINNER>>>)>
	<PUT .OBJ ,OROOM <>>
	<PUT .OBJ ,OCAN <>>>

<DEFINE INSERT-OBJECT (OBJ ROOM)
	#DECL ((OBJ) OBJECT (ROOM) ROOM)
	<PUT .ROOM ,ROBJS (<PUT .OBJ ,OROOM .ROOM> !<ROBJS .ROOM>)>>

<DEFINE INSERT-INTO (CNT OBJ)
	#DECL ((OBJ CNT) OBJECT)
	<PUT .CNT ,OCONTENTS (.OBJ !<OCONTENTS .CNT>)>
	<PUT .OBJ ,OCAN .CNT>
	<PUT .OBJ ,OROOM <>>>

<DEFINE REMOVE-FROM (CNT OBJ)
	#DECL ((OBJ CNT) OBJECT)
	<PUT .CNT ,OCONTENTS <SPLICE-OUT .OBJ <OCONTENTS .CNT>>>
	<PUT .OBJ ,OCAN <>>>

<DEFINE TAKE-OBJECT (OBJ "OPTIONAL" (WINNER ,WINNER))
	#DECL ((OBJ) OBJECT (WINNER) ADV)
	<TRO .OBJ ,TOUCHBIT>
	<PUT .WINNER ,AOBJS (<PUT .OBJ ,OROOM <>> !<AOBJS .WINNER>)>>

<DEFINE DROP-OBJECT (OBJ "OPTIONAL" (WINNER ,WINNER))
	#DECL ((OBJ) OBJECT (WINNER) ADV)
	<PUT .WINNER ,AOBJS <SPLICE-OUT .OBJ <AOBJS .WINNER>>>>

<DEFINE DROP-IF (OBJ "OPTIONAL" (WINNER ,WINNER))
	#DECL ((OBJ) OBJECT (WINNER) ADV)
	<AND <MEMQ .OBJ <AOBJS .WINNER>>
	     <DROP-OBJECT .OBJ .WINNER>>>

<DEFINE SNARF-OBJECT (WHO WHAT)
	#DECL ((WHO WHAT) OBJECT)
	<COND (<AND <N==? <OCAN .WHAT> .WHO>
		    <OR <OROOM .WHAT>
			<OCAN .WHAT>>>
	       <REMOVE-OBJECT .WHAT>
	       <INSERT-INTO .WHO .WHAT>)
	      (.WHO)>>

<DEFINE IN-ROOM? (OBJ "OPTIONAL" (HERE ,HERE) "AUX" TOBJ)
  #DECL ((OBJ) OBJECT (HERE) ROOM (TOBJ) <OR OBJECT FALSE>)
  <COND (<SET TOBJ <OCAN .OBJ>>
	 <COND (<==? <OROOM .TOBJ> .HERE>)
	       (<TRNN .TOBJ ,SEARCHBIT>
		<IN-ROOM? .TOBJ .HERE>)>)
	(<==? <OROOM .OBJ> .HERE>)>>

<DEFINE HACKABLE? (OBJ RM "AUX" (AV <AVEHICLE ,WINNER>))
    #DECL ((OBJ) OBJECT (RM) ROOM (AV) <OR FALSE OBJECT>)
    <COND (.AV
	   <SEARCH-LIST <OID .OBJ> <OCONTENTS .AV> <>>)
	  (<SEARCH-LIST <OID .OBJ> <ROBJS .RM> <>>)>>

\

"Villains, thieves, and scoundrels"

"ROB-ADV:  TAKE ALL OF THE VALUABLES A HACKER IS CARRYING"

<DEFINE ROB-ADV (WIN NEWLIST)
  #DECL ((WIN) ADV (NEWLIST) <LIST [REST OBJECT]>)
  <MAPF <>
    <FUNCTION (X) #DECL ((X) OBJECT)
      <COND (<AND <G? <OTVAL .X> 0> <NOT <TRNN .X ,SACREDBIT>>>
	     <PUT .WIN ,AOBJS <SPLICE-OUT .X <AOBJS .WIN>>>
	     <SET NEWLIST (.X !.NEWLIST)>)>>
    <AOBJS .WIN>>
  .NEWLIST>

"ROB-ROOM:  TAKE VALUABLES FROM A ROOM, PROBABILISTICALLY"

<DEFINE ROB-ROOM (RM NEWLIST PROB)
  #DECL ((RM) ROOM (NEWLIST) <LIST [REST OBJECT]> (PROB) FIX)
  <MAPF <>
    <FUNCTION (X) #DECL ((X) OBJECT)
      <COND (<AND <G? <OTVAL .X> 0>
		  <NOT <TRNN .X ,SACREDBIT>>
		  <TRNN .X ,OVISON>
		  <PROB .PROB>>
	     <REMOVE-OBJECT .X>
	     <TRO .X ,TOUCHBIT>
	     <SET NEWLIST (.X !.NEWLIST)>)
	    (<OACTOR .X>
	     <SET NEWLIST <ROB-ADV <OACTOR .X> .NEWLIST>>)>>
    <ROBJS .RM>>
  .NEWLIST>

<DEFINE GET-DEMON (ID "AUX" (OBJ <FIND-OBJ .ID>) (DEMS ,DEMONS))
  #DECL ((ID) STRING (OBJ) OBJECT (DEMS) <LIST [REST HACK]>)
  <MAPF <>
    <FUNCTION (X) #DECL ((X) HACK)
      <COND (<==? <HOBJ .X> .OBJ> <MAPLEAVE .X>)>>
    .DEMS>>

\

; "The guiding light"

<DEFINE LIGHT-SOURCE (ME)
	#DECL ((ME) ADV)
	<MAPF <>
	      <FUNCTION (X)
	         #DECL ((X) OBJECT)
		 <COND (<NOT <TRNN .X ,LIGHTBIT>>
			<MAPLEAVE .X>)>>
	      <AOBJS .ME>>>

;"LIT? --
	IS THERE ANY LIGHT SOURCE IN THIS ROOM"

<SETG ALWAYS-LIT <>>

<DEFINE LIT? (RM "AUX" (WIN ,WINNER))
	#DECL ((RM) ROOM (WIN) ADV)
	<OR <RTRNN .RM ,RLIGHTBIT>
	    <LFCN <ROBJS .RM>>
	    <AND <==? ,HERE .RM> <LFCN <AOBJS .WIN>>>
	    <AND <N==? .WIN ,PLAYER>
		 <==? ,HERE <AROOM ,PLAYER>>
		 <LFCN <AOBJS ,PLAYER>>>
	    ,ALWAYS-LIT>>

<DEFINE LFCN LFCN (L "AUX" Y) 
	#DECL ((L) <LIST [REST OBJECT]> (Y) ADV (LFCN) ACTIVATION)
	<MAPF <>
	      <FUNCTION (X) 
		      #DECL ((X) OBJECT)
		      <AND <TRNN .X ,ONBIT> <MAPLEAVE T>>
		      <COND (<AND <TRNN .X ,OVISON>
				  <OR <TRNN .X ,OPENBIT>
				      <TRNN .X ,TRANSBIT>>>
			     <MAPF <>
			       <FUNCTION (X) #DECL ((X) OBJECT)
				 <COND (<TRNN .X ,ONBIT>
					<RETURN T .LFCN>)>>
			       <OCONTENTS .X>>)>
		      <COND (<AND <TRNN .X ,ACTORBIT>
				  <LFCN <AOBJS <SET Y <OACTOR .X>>>>>
			     <MAPLEAVE T>)>>
	      .L>>

\
; "Random Utilities"

<DEFINE PICK-ONE (VEC) 
	#DECL ((VEC) VECTOR)
	<NTH .VEC <+ 1 <MOD <RANDOM> <LENGTH .VEC>>>>>

<SETG LUCKY!-FLAG T>

<DEFINE PROB (GOODLUCK "OPTIONAL" (BADLUCK .GOODLUCK))
    #DECL ((GOODLUCK BADLUCK) FIX)
    <L=? <MOD <RANDOM> 100>
	 <COND (,LUCKY!-FLAG .GOODLUCK)
	       (.BADLUCK)>>>

<DEFINE YES/NO (NO-IS-BAD? "AUX" (INBUF ,INBUF) (INCHAN ,INCHAN)) 
	#DECL ((INBUF) STRING (NO-IS-BAD?) <OR ATOM FALSE> (INCHAN) CHANNEL)
	<RESET .INCHAN>
	<TTY-INIT <>>
	<READST .INBUF "" <>>
	<COND (.NO-IS-BAD?
	       <NOT <MEMQ <1 .INBUF> "NnfF">>)
	      (T
	       <MEMQ <1 .INBUF> "TtYy">)>>

<DEFINE SPLICE-OUT (OBJ AL) 
	#DECL ((AL) LIST (OBJ) ANY)
	<COND (<==? <1 .AL> .OBJ> <REST .AL>)
	      (T
	       <REPEAT ((NL <REST .AL>) (OL .AL))
		       #DECL ((NL) LIST (OL) <LIST ANY>)
		       <COND (<==? <1 .NL> .OBJ>
			      <PUTREST .OL <REST .NL>>
			      <RETURN .AL>)
			     (<SET OL .NL> <SET NL <REST .NL>>)>>)>>

\

; "These are for debugging only!"

<DEFINE FLUSH-OBJ ("TUPLE" OBJS "AUX" (WINNER ,WINNER))
  #DECL ((OBJS) <TUPLE [REST STRING]> (WINNER) ADV)
  <MAPF <>
	<FUNCTION (X "AUX" (Y <FIND-OBJ .X>))
	  #DECL ((X) STRING (Y) OBJECT)
	  <AND <MEMQ .Y <AOBJS .WINNER>>
	       <DROP-OBJECT <FIND-OBJ .X> .WINNER>>>
	.OBJS>>

<DEFINE CONS-OBJ ("TUPLE" OBJS "AUX" (WINNER ,WINNER))
  #DECL ((OBJS) <TUPLE [REST STRING]> (WINNER) ADV)
  <MAPF <>
	<FUNCTION (X "AUX" (Y <FIND-OBJ .X>))
	  #DECL ((Y) OBJECT (X) STRING)
	  <OR <MEMQ .Y <AOBJS .WINNER>>
	      <TAKE-OBJECT <FIND-OBJ .X> .WINNER>>>
	.OBJS>>


; "No applause, please."

<DEFINE PERFORM (FCN VB "OPTIONAL" (OBJ1 <>) (OBJ2 <>) 
		        "AUX" R (PV ,PRSVEC) (PRSA <PRSA>) (PRSO <PRSO>) (PRSI <PRSI>))
   #DECL ((VB PRSA) VERB (OBJ1 OBJ2 PRSO PRSI) <OR FALSE OBJECT>
	  (R) ANY (PV) VECTOR (FCN) <OR ATOM NOFFSET APPLICABLE>)
   <PUT <PUT <PUT .PV 3 .OBJ2> 2 .OBJ1> 1 .VB>
   <SET R <COND (<TYPE? .FCN ATOM NOFFSET> <APPLY-RANDOM .FCN>)
		(<APPLY .FCN>)>>
   <PUT <PUT <PUT .PV 3 .PRSI> 2 .PRSO> 1 .PRSA>
   .R>


