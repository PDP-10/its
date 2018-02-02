
"(c) Copyright 1978, Massachusetts Institute of Technology.  All rights reserved."

"GUTS OF FROB:  BASIC VERBS, COMMAND READER, PARSER, VOCABULARY HACKERS."

<SETG ALT-FLAG T>

<GDECL (MUDDLE) FIX (TENEX?) <OR ATOM FALSE> (VERS DEV SNM SCRATCH-STR) STRING>

<DEFINE SAVE-IT ("OPTIONAL" (FN <COND (<L? ,MUDDLE 100> "CFS;MADADV SAVE")
				      (T "<MDL>MADADV.SAVE")>)
		 (START? T)
		 "AUX" (MUDDLE ,MUDDLE) STV (ST <REMARKABLY-DISGUSTING-CODE>))
	#DECL ((START?) <OR ATOM FALSE> (FN) STRING (MUDDLE) FIX (STV) <OR STRING FIX>) 
	<ODESC1 <SFIND-OBJ "PAPER"> <UNSPEAKABLE-CODE>>
	<SETG DEAD-PLAYER <AACTION ,PLAYER>>
	<PUT ,PLAYER ,AACTION <>>
	<SETG VERS .ST>
	<SETG SCRIPT-CHANNEL <>>
	<SETG DBG <>>
	<SETG RAW-SCORE 0>
	<SET IH <ON "IPC" ,ILO 1>>
	<HANDLER ,DIVERT-INT ,DIVERT-HAND>
	<COND (<G? .MUDDLE 100>
	       <SETG SCRATCH-STR <ISTRING 32>>
	       <SETG DEV "DSK">
	       <SETG SNM "MDL">)
	      (<SNAME "">
	       <SETG DEV "DSK">
	       <SETG SNM "CFS">)>
	<INT-LEVEL 100000>
	<SETG DEATHS 0>
	<SETG MOVES 0>
	<SETG WINNER ,PLAYER>
	<RESET ,INCHAN>
	<OFF "CHAR" ,INCHAN>
	<AND <GASSIGNED? MUD-HAND> <OFF ,MUD-HAND>>
	<SETG SAVEREP ,REP>
	<SETG REP ,RDCOM>
	<COND (<AND <=? <SAVE .FN> "SAVED">
		    <NOT .START?>>
	       <HANDLER <EVENT "CHAR" 8 ,INCHAN> ,ZORK-HAND>
	       <SETG REP ,SAVEREP>
	       <INT-LEVEL 0>
	       T)
	      (T
	       ; "STARTER on 10x sets up tty correctly, setg's DEV to \"MDL\"
		  if that device exists; if not, (sort of) returns directory save file
		  came from.  On its it returns # zorkers currently in existence."
	       <RANDOM <CHTYPE <DSKDATE> FIX>>
	       <SETG XUNM <XUNAME>>
	       <COND (<AND <L? .MUDDLE 100>
			   <OR <=? ,XUNM "USERS1">
			       <=? ,XUNM "USERS2">>>
		      <TELL ,FLUSHSTR1>
		      <QUIT>)>
	       <COND (<AND <TYPE? <SET STV <STARTER>> FIX>
			   <G=? .STV 3>>
		      <OR <MEMBER ,XUNM ,WINNERS>
			  <=? ,XUNM "SEC">
			  <=? ,XUNM "ELBOW">
			  <AND <TELL ,FLUSHSTR1>
			       <QUIT>>>)
		     (<TYPE? .STV STRING>
		      <SETG SNM <SUBSTRUC ,SCRATCH-STR
					  0
					  <- <LENGTH ,SCRATCH-STR>
					     <LENGTH <MEMQ <ASCII 0> .STV>>>>>)>
	       <COND (<G? ,MUDDLE 100> <SETG TENEX? <GETSYS>>)
		     (<APPLY ,IPC-OFF>
		      <APPLY ,IPC-ON <UNAME> "ZORK">)>
	       <SET BH <ON "BLOCKED" ,BLO 100>>
	       <INT-LEVEL 0>
	       <START "WHOUS" .ST>)>>



"Stuff for diverting gc's"

<SETG DIVERT-CNT 0>

<SETG DIVERT-MAX 99>

<SETG DIVERT-INC 4000>

<SETG DIVERT-AMT 0>

<SETG DIVERT-LMT 100000>

<GDECL (DIVERT-CNT DIVERT-MAX DIVERT-INC DIVERT-AMT DIVERT-LMT) FIX>

<DEFINE DIVERT-FCN  (AMT DUMMY)
	#DECL ((AMT) FIX (DUMMY) ATOM)
	<SETG DIVERT-CNT <+ ,DIVERT-CNT 1>>
	<SETG DIVERT-AMT <+ ,DIVERT-AMT ,DIVERT-INC .AMT>>
	<COND (<OR <G? ,DIVERT-CNT ,DIVERT-MAX>
		   <G? ,DIVERT-AMT ,DIVERT-LMT>>	;"Too much diversion ?"
		<SETG DIVERT-AMT <SETG DIVERT-CNT 0>>
		<GC-FCN>
		<GC>)
	      (ELSE	;"Divert this request for storage"
		<COND (<1? ,DIVERT-CNT>		;"First diversion ?"
		       <HANDLER ,GC-INT ,GC-HAND>)>
		<BLOAT <+ .AMT ,DIVERT-INC>>
				;"Get storage desired plus extra increment")>>

<SETG DIVERT-HAND
      <HANDLER <SETG DIVERT-INT <EVENT "DIVERT-AGC" 1000>> ,DIVERT-FCN>>

<OFF ,DIVERT-HAND>

<DEFINE GC-FCN  ("TUPLE" T)
	#DECL ((T) TUPLE)
	<OFF ,GC-HAND>
	<SETG DIVERT-AMT <SETG DIVERT-CNT 0>>>

<SETG GC-HAND <HANDLER <SETG GC-INT <EVENT "GC" 11>> ,GC-FCN>>

<OFF ,GC-HAND>

<DEFINE XUNAME ()
  #DECL ((VALUE) STRING)
  <MAPF ,STRING
	<FUNCTION (X)
	   #DECL ((X) CHARACTER)
	   <COND (<OR <0? <ASCII .X>>
		      <==? <ASCII .X> 32>>
		  <MAPSTOP>)
		 (T .X)>>
	<GXUNAME>>>

<DEFINE ITS-GET-NAME (UNAME "AUX" (NM <LSR-ENTRY .UNAME>) CMA JR LFST LLST
		      TLEN TSTR STR)
	#DECL ((STR TSTR UNAME) STRING (NM CMA JR) <OR STRING FALSE>
	       (TLEN LLST LFST) FIX)
	<COND (.NM
	       <SETG AFFILIATION <STRING <LSR-EXTRACT .NM ,$GRP>>>
	       <SET NM <STRING <LSR-EXTRACT .NM ,$NAME>>>
	       <REPEAT (NN MM)
	         #DECL ((NN MM) <OR FALSE STRING>)
	         <COND (<SET NN <MEMQ !\" .NM>>
			<COND (<SET MM <MEMQ !\" <REST .NN>>>
			       <SET NM <STRING <SUBSTRUC .NM 0
							 <- <LENGTH .NM> <LENGTH .NN>>>
					       <REST .MM>>>)
			      (<SET NM <SUBSTRUC .NM 0
						 <- <LENGTH .NM> <LENGTH .NN>>>>)>)
		       (<RETURN>)>>
	       <COND (<SET CMA <MEMQ !\, .NM>>
		      <SET LLST <- <LENGTH .NM> <LENGTH .CMA>>>
		      <SET CMA <REST .CMA>>
		      <SET LFST <LENGTH .CMA>>
		      <COND (<SET JR <MEMQ !\, .CMA>>
			     <SET LFST <- .LFST <LENGTH .JR>>>)>
		      <REPEAT ()
			      <COND (<EMPTY? .CMA> <RETURN>)
				    (<MEMQ <1 .CMA> %<STRING <ASCII 32> <ASCII 9>>>
				     <SET CMA <REST .CMA>>
				     <SET LFST <- .LFST 1>>)
				    (ELSE <RETURN>)>>
		      <SET TLEN <+ .LFST 1 .LLST <LENGTH .JR>>>
		      <SET STR <ISTRING .TLEN !\ >>
		      <SET TSTR .STR>
		      <SUBSTRUC .CMA 0 .LFST .TSTR>
		      <SET TSTR <REST .TSTR <+ .LFST 1>>>
		      <SUBSTRUC .NM 0 .LLST .TSTR>
		      <AND .JR <SUBSTRUC .JR 0 <LENGTH .JR> <REST .TSTR .LLST>>>
		      <SETG USER-NAME .STR>)
		     (ELSE <SETG USER-NAME .NM>)>)
	      (<SETG AFFILIATION <>>)>>

<DEFINE UNSPEAKABLE-CODE ("AUX" STR NSTR (LEN-I 0) (O <SFIND-OBJ "PAPER">))
    #DECL ((O) OBJECT (NSTR STR) STRING (LEN-I) FIX)
    <SET STR <MEMQ !\/ <OREAD .O>>>
    <COND (<==? <1 <BACK .STR 2>> !\1>
	   <SET STR <BACK .STR 2>>
	   <SET LEN-I 1>)
	  (<SET STR <BACK .STR 1>>)>
    <SET NSTR <REST <MEMQ !\/ <REST <MEMQ !\/ .STR>>> 3>>
    <STRING "There is an issue of US NEWS & DUNGEON REPORT dated "
	    <SUBSTRUC .STR 0 <- <LENGTH .STR> <LENGTH .NSTR>>>
	    " here.">>

<DEFINE REMARKABLY-DISGUSTING-CODE ("AUX" (N <DSKDATE>))
	#DECL ((N) WORD)
	<STRING
	 "This Zork created "
	 <NTH ,MONTHS <CHTYPE <GETBITS .N <BITS 4 23>> FIX>>
	 !\ 
	 <UNPARSE <CHTYPE <GETBITS .N <BITS 5 18>> FIX>>
	 !\,
	 " 19" <UNPARSE <CHTYPE <GETBITS .N <BITS 7 27>> FIX>>
	 !\.>>

<SETG PLAYED-TIME 0>

<GDECL (PLAYED-TIME) FIX>

<DEFINE GET-TIME ("AUX" (NOW <DSKDATE>) (THEN ,INTIME))
	#DECL ((NOW) WORD (THEN) <PRIMTYPE WORD>)
	<+ <COND (<N==? <CHTYPE <GETBITS .NOW <BITS 18 18>> FIX>
			<CHTYPE <GETBITS .THEN <BITS 18 18>> FIX>>
		  </ <- <+ <CHTYPE <GETBITS .NOW <BITS 18 0>> FIX>
			   <* 24 7200>>
			<CHTYPE <GETBITS .THEN <BITS 18 0>> FIX>>
		     2>)
		 (</ <- <CHTYPE <GETBITS .NOW <BITS 18 0>> FIX>
			<CHTYPE <GETBITS .THEN <BITS 18 0>> FIX>>
		     2>)>
	   ,PLAYED-TIME>>

<DEFINE PLAY-TIME ("OPTIONAL" (LOSER? T)
		   "AUX" (OUTCHAN .OUTCHAN) TIME MINS)
	#DECL ((MINS TIME) FIX (LOSER?) <OR ATOM FALSE> (OUTCHAN) CHANNEL)
	<SET TIME <GET-TIME>>
	<SETG TELL-FLAG T>
	<COND (.LOSER? <PRINC "You have been playing ZORK for ">)
	      (T
	       <PRINC "Played for ">)>
	<AND <G? <SET MINS </ .TIME 3600>> 0>
	     <PRIN1 .MINS>
	     <PRINC " hour">
	     <OR <1? .MINS> <PRINC "s">>
	     <PRINC ", ">>
	<COND (<G? <SET MINS <MOD </ .TIME 60> 60>> 0>
	       <PRIN1 .MINS>
	       <PRINC " minute">
	       <COND (<NOT <1? .MINS>> <PRINC "s">)>
	       <PRINC ", and ">)>
	<PRIN1 <SET MINS <MOD .TIME 60>>>
	<PRINC " second">
	<OR <1? .MINS> <PRINC "s">>
	<COND (.LOSER? <PRINC ".
">)
	      (<PRINC ".">)>
	.TIME> 

<DEFINE HANDLE (FRM "TUPLE" ZORK "AUX" ZF CH) 
	#DECL ((ZF) ANY (FRM) <OR FALSE FRAME>
	       (ZORK) <SPECIAL TUPLE> (CH) <OR CHANNEL FALSE>)
	<PUT ,OUTCHAN 13 80>
	<COND (<AND <OR <NOT <GASSIGNED? XUNM>>
			<MEMBER ,XUNM ,WINNERS>
			,DBG>
		    T>
	       <TTY-UNINIT>
	       <AND <GASSIGNED? SAVEREP> <SETG REP ,SAVEREP>>
	       <AND <ASSIGNED? BH> <OFF .BH>>
	       <AND <GASSIGNED? ZORK-HAND> <OFF ,ZORK-HAND>>
	       <AND <GASSIGNED? MUD-HAND> <HANDLER <GET ,INCHAN INTERRUPT> ,MUD-HAND>>
	       <INT-LEVEL 0>
	       <SETG DBG T>
	       <OR .FRM <LISTEN>>)
	      (,ERRFLG
	       <QUIT>)
	      (T
	       <COND (<AND <NOT <EMPTY? .ZORK>>
			   <==? <1 .ZORK> CONTROL-G?!-ERRORS>>
		      <INT-LEVEL 0>
		      <FINISH>
		      <AND .FRM <ERRET T .FRM>>)
		     (<AND <==? <LENGTH .ZORK> 3>
			   <==? <1 .ZORK> FILE-SYSTEM-ERROR!-ERRORS>
			   <NOT <SET ZF <3 .ZORK>>>
			   <==? <LENGTH .ZF> 3>
			   <=? <1 .ZF>
			       "ILLEGAL CHR AFTER CNTRL P ON TTY DISPLAY">>
		      ; "HACK FOR ILLEGAL CHR AFTER CTRL-P"
		      <INT-LEVEL 0>
		      <ERRET T .FRM>)
		     (<SETG ERRFLG T>
		      <UNWIND
		       <PROG ()
		         <INT-LEVEL 0>
		         <TELL
"I'm sorry, you seem to have encountered an error in the program.">
			 <COND (<SET CH <RECOPEN "BUG">>
				<TELL "Please describe what happened:">
				<BUGGER .CH>)
			       (<TELL 
"Send mail to ZORK@MIT-DMS describing what it was you tried to do.">
				<TELL ,VERS>
				<MAPF <>
				      <FUNCTION (X)
						#DECL ((X) ANY)
						<PRINT .X>>
				      .ZORK>)>
			 <FINISH #FALSE (". Error.")>>
		       <FINISH #FALSE (". Error.")>>)>)>>

<PSETG WINNERS '["HESS" "BKD" "TAA" "MARC" "PDL" "MDL"]>

<SETG ERRFLG <>>

<GDECL (WINNERS) <VECTOR [REST STRING]> (ERRFLG) <OR ATOM FALSE>>

<OR <LOOKUP "COMPILE" <ROOT>>
    <AND <GET PACKAGE OBLIST> <LOOKUP "GLUE" <GET PACKAGE OBLIST>>>
    <LOOKUP "GROUP-GLUE" <GET INITIAL OBLIST>>
    <AND <SETG ERRH
	       <HANDLER <OR <GET ERROR!-INTERRUPTS INTERRUPT> <EVENT "ERROR" 8>>
			,HANDLE>>
	 <OFF ,ERRH>>>

<GDECL (MOVES) FIX (SCRIPT-CHANNEL) <OR CHANNEL FALSE>>

<DEFINE START (RM "OPTIONAL" (ST "") "AUX" FN (MUDDLE ,MUDDLE) (XUNM <XUNAME>)) 
	#DECL ((ST RM) STRING (MUDDLE) FIX (XUNM) STRING (FN) <OR FALSE STRING>)
	<SETG XUNM .XUNM>
	<SETG INTIME <DSKDATE>>
	<COND (<L? .MUDDLE 100>
	       <AND <G? <LENGTH .XUNM> 2> <=? <SUBSTRUC .XUNM 0 3> "___"> <QUIT>>
	       <SET FN <ITS-GET-NAME .XUNM>>)
	      (<SET FN <GET-NAME>>
	       <COND (<NOT ,TENEX?>
		      <AND <0? <13 ,OUTCHAN>>
			   <PUT ,OUTCHAN 13 80>>)>)>
	<COND (.FN
	       <SETG USER-NAME .FN>)
	      (<SETG USER-NAME .XUNM>)>
		<PUT ,WINNER ,AROOM <SETG HERE <FIND-ROOM .RM>>>
	<TELL .ST>
	<COND (<GASSIGNED? MSG-STRING>
	       <TELL ,MSG-STRING>)>
	<CONTIN T>>

<DEFINE CONTIN ("OPTIONAL" (FOO <>))
	<EXCRUCIATINGLY-UNTASTEFUL-CODE>
	<COND (.FOO
	       <ON "CHAR" ,CTRL-S 8 0 ,INCHAN>)
	      (<SETG REP ,RDCOM>)>
	<TTY-INIT .FOO>
	<SETG WINNER ,PLAYER>
	<PUT ,PRSVEC 2 <>>
	<ROOM-INFO 3>
	,NULL>

<DEFINE DC ("OPTIONAL" (RM ,HERE) "TUPLE" OBJS)
	<COND (<TYPE? .RM STRING>
	       <SET RM <FIND-ROOM .RM>>)>
	<COND (<OR <==? .RM ,HERE> <GOTO .RM>>
	       <CONS-OBJ !.OBJS>
	       <RESET ,INCHAN>
	       <CONTIN <>>
	       <AND <GASSIGNED? MUD-HAND> <OFF ,MUD-HAND>>
	       <AND <GASSIGNED? ZORK-HAND> <HANDLER <GET ,INCHAN INTERRUPT> ,ZORK-HAND>>
	       <ERRET>)>>

<SETG MY-SCRIPT <>>

<GDECL (MY-SCRIPT) <OR ATOM FALSE>>

<DEFINE MAKE-SCRIPT ("AUX" CH)
  #DECL ((CH) <OR CHANNEL FALSE>)
  <COND (,SCRIPT-CHANNEL
	 <>)
	(<SET CH <OPEN "PRINT" <STRING "MARC;%Z" ,XUNM " >">>>
	 <PUT <TOP ,INCHAN> 1 (.CH)>
	 <PUT <TOP ,OUTCHAN> 1 (.CH)>
	 <SETG SCRIPT-CHANNEL .CH>
	 <SETG MY-SCRIPT T>)>>

<DEFINE FLUSH-ME ()
  <UNWIND
   <PROG ()
	 <TELL ,FLUSHSTR2 ,LONG-TELL>
	 <FINISH <>>>
   <FINISH <>>>>

<DEFINE DO-SCRIPT ("AUX" (CH <>) (UNM ,XUNM) (MUDDLE ,MUDDLE))
  #DECL ((CH) <OR CHANNEL FALSE> (UNM) STRING (MUDDLE) FIX)
  <COND (,MY-SCRIPT
	 <DO-UNSCRIPT <>>)>
  <COND (,SCRIPT-CHANNEL
	 <TELL "You are already scripting.">)
	(<AND
	  <OR <G? .MUDDLE 100>
	      <AND <SET CH <OPEN "READ" ".FILE." "(DIR)" "DSK" .UNM>>
		   <=? <10 .CH> .UNM>
		   <CLOSE .CH>>>
	  <SET CH <OPEN "PRINT" "ZORK" "SCRIPT" "DSK" .UNM>>>
	 <PUT <TOP ,INCHAN> 1 (.CH)>
	 <PUT <TOP ,OUTCHAN> 1 (.CH)>
	 <SETG SCRIPT-CHANNEL .CH>
	 <COND (<L? ,MUDDLE 100>
		<TELL "Scripting to " ,POST-CRLF ,XUNM ";ZORK SCRIPT">)
	       (T
		<TELL "Scripting to <" ,POST-CRLF ,XUNM ">ZORK.SCRIPT">)>)
	(T
	 <COND (.CH <CLOSE .CH>)>
	 <TELL "I can't open the script channel.">)>>

<DEFINE DO-UNSCRIPT ("OPTIONAL" (VERBOSE T))
  #DECL ((VERBOSE) <OR ATOM FALSE>)
  <COND (,SCRIPT-CHANNEL
	 <PUT <TOP ,INCHAN> 1 ()>
	 <PUT <TOP ,OUTCHAN> 1 ()>
	 <CLOSE ,SCRIPT-CHANNEL>
	 <SETG SCRIPT-CHANNEL <>>
	 <AND .VERBOSE <TELL "Scripting off.">>)
	(<AND .VERBOSE <TELL "Scripting wasn't on.">>)>>

<GDECL (THEN) FIX>

<DEFINE DO-SAVE ("OPTIONAL" (UNM ,XUNM) "AUX" FNM (MUDDLE ,MUDDLE) (CH <>))
  #DECL ((FNM) STRING (CH) <OR CHANNEL FALSE> (MUDDLE) FIX (UNM) STRING)
  <COND (<RTRNN <SFIND-ROOM "TSTRS"> ,RSEENBIT>
	 <TELL "Saves not permitted from end game.">)
	(T
	 <COND (,SCRIPT-CHANNEL <DO-UNSCRIPT>)>
	 <TELL "Saving.">
	 <COND (<MEMBER .UNM ,WINNERS>)
	       (ELSE
		<INT-LEVEL 100000>
		<OFF ,ZORK-HAND>
		<OFF "CHAR" ,INCHAN>)>
	 <SETG THEN <CHTYPE <DSKDATE> FIX>>
	 <SETG PLAYED-TIME <GET-TIME>>
	 <COND (<AND <SET CH <OPEN "PRINTB"
			      <COND (<L? .MUDDLE 100>
				     <STRING <GET-DEV>
					     !\: .UNM
					     ";ZORK SAVE">)
				    (T
				     <STRING "DSK:<" .UNM ">ZORK." ,SAVNM>)>>>
		     <OR <G? .MUDDLE 100>
			 <=? <10 .CH> .UNM>>>
		<SETG SRUNM .UNM>
		<SAVE-GAME .CH>
		<FINISH <CHTYPE '(". Saved.") FALSE>>)
	       (T
		<COND (.CH
		       <CLOSE .CH>
		       <RENAME <STRING <9 .CH> !\: <10 .CH> !\;
				       <7 .CH> !\  <8 .CH>>>)>
		<TELL "Save failed.">
		<COND (<NOT .CH> <TELL <1 .CH> ,POST-CRLF " " <2 .CH>>)
		      (T
		       <TELL " " ,POST-CRLF>)>)>
	 <COND (<NOT <MEMBER .UNM ,WINNERS>>
		<HANDLER <EVENT "CHAR" 8 ,INCHAN> ,ZORK-HAND>)>
	 <INT-LEVEL 0>)>>

<SETG SAVNM "SAVE">

<GDECL (SAVNM) STRING>

<DEFINE DO-RESTORE DR ("OPTIONAL" (XUNM ,XUNM) "AUX" CH STR (MUDDLE ,MUDDLE) NOW)
  #DECL ((CH) <OR CHANNEL FALSE> (STR) STRING (NOW MUDDLE) FIX
	 (DR) ACTIVATION (XUNM) STRING)
   <COND (<RTRNN <SFIND-ROOM "TSTRS"> ,RSEENBIT>
	  <TELL "Restores not permitted into end game.">
	  <RETURN T .DR>)
	 (<L? .MUDDLE 100>
	  <SET STR <STRING <GET-DEV> !\: .XUNM ";ZORK SAVE">>)
	 (T
	  <SET STR <STRING "DSK:<" .XUNM ">ZORK." ,SAVNM>>)>
   <PROG ((FOO T) (SNM <SNAME>))
	 #DECL ((FOO) <OR ATOM FALSE> (SNM) <SPECIAL STRING>)
	 <COND (<SET CH <OPEN "READB" .STR>>
		<SETG SRUNM .XUNM>
		<COND (<RESTORE-GAME .CH>
		       <SETG INTIME <CHTYPE <DSKDATE> FIX>>
		       <SCORE-BLESS>
		       <SETG RESTORE-HAPPENED T>
		       <TELL "Restored.">)
		      (<TELL "Restore failed.">)>
		<ROOM-DESC>)
	       (<AND .FOO <G? .MUDDLE 100>>
		<SET STR <STRING "DSK:<" <SNAME> ">ZORK.SAVE">>
		<SET FOO <>>
		<AGAIN>)
	       (<TELL <2 .CH> ,POST-CRLF " " <1 .CH>>)>>>

<DEFINE GET-DEV ("AUX" T (TAB ,DEVICE-TABLE))
  #DECL ((TAB) <VECTOR [REST STRING]> (T) <OR FALSE VECTOR>)
  <COND (<SET T <MEMBER ,AFFILIATION .TAB>>
	 <2 .T>)
	("DSK")>>

"GET-ATOM TAKES A VALUE AND SEARCHES INITIAL FOR FIRST ATOM
SETG'ED TO THAT."

<DEFINE GET-ATOM ACT (VAL "AUX" (O <GET INITIAL OBLIST>))
  #DECL ((O) OBLIST (ACT) ACTIVATION (VAL) ANY)
  <MAPF <>
    <FUNCTION (X) #DECL ((X) <LIST [REST ATOM]>)
      <MAPF <>
        <FUNCTION (X) #DECL ((X) ATOM)
	  <COND (<AND <GASSIGNED? .X>
		      <==? ,.X .VAL>>
		 <RETURN .X .ACT>)>>
	.X>>
    .O>>

;
"ROOM-INFO --
	PRINT SOMETHING ABOUT THIS PLACE
	1. CHECK FOR LIGHT --> ELSE WARN LOSER
	2. GIVE A DESCRIPTION OF THE ROOM
	3. TELL WHAT'S ON THE FLOOR IN THE WAY OF OBJECTS
	4. SIGNAL ENTRY INTO THE ROOM
"
<SETG BRIEF!-FLAG <>>

<SETG SUPER-BRIEF!-FLAG <>>

<SETG NO-OBJ-PRINT!-FLAG <>>

<GDECL (SUPER-BRIEF!-FLAG BRIEF!-FLAG NO-OBJ-PRINT!-FLAG) <OR ATOM FALSE>>

<DEFINE VERBOSE ()
	<SETG BRIEF!-FLAG <>>
	<SETG SUPER-BRIEF!-FLAG <>>
	<TELL "Maximum verbosity.">>

<DEFINE BRIEF ()
	<SETG BRIEF!-FLAG T>
	<SETG SUPER-BRIEF!-FLAG <>>
	<TELL "Brief descriptions.">>

<DEFINE SUPER-BRIEF ()
	<SETG SUPER-BRIEF!-FLAG T>
	<TELL "No long descriptions.">>

<DEFINE NO-OBJ-HACK ()
	<COND (<SETG NO-OBJ-PRINT!-FLAG <NOT ,NO-OBJ-PRINT!-FLAG>>
	       <TELL "Don't print objects.">)
	      (<TELL "Print objects.">)>>

<DEFINE ROOM-NAME () <TELL <RDESC2 ,HERE>>>

<DEFINE ROOM-DESC () <ROOM-INFO 3>>

<DEFINE ROOM-OBJ ()
	<ROOM-INFO 1>
	<COND (<NOT ,TELL-FLAG>
	       <TELL "I see no objects here.">)>>

<DEFINE ROOM-ROOM () <ROOM-INFO 2>>

<DEFINE ROOM-INFO ("OPTIONAL" (FULL <>)
		   "AUX" (AV <AVEHICLE ,WINNER>) (RM ,HERE) (PRSO <2 ,PRSVEC>)
			 (WINOBJ <SFIND-OBJ "#####">) (OUTCHAN ,OUTCHAN) RA
			 (FULLQ <>) (FIRST? T))
   #DECL ((RM) ROOM (WINOBJ) OBJECT (AV) <OR FALSE OBJECT> (OUTCHAN) CHANNEL
	  (PRSO) <OR DIRECTION FALSE OBJECT> (FULL) <OR FIX FALSE>
	  (FULLQ FIRST?) <OR ATOM FALSE>)
   <COND (<TYPE? .PRSO DIRECTION>
	  <SETG FROMDIR .PRSO>
	  <SET PRSO <>>
	  <PUT ,PRSVEC 2 <>>)>
   <COND (<NOT <RTRNN .RM ,RSEENBIT>> <SET FULLQ T>)>
   <PROG ()
     <COND (<OR <NOT .FULL> <NOT <0? <CHTYPE <ANDB .FULL 2> FIX>>>>
	    <COND (<N==? ,HERE <AROOM ,PLAYER>>
		   <PUT ,PRSVEC 1 <FIND-VERB "GO-IN">>
		   <TELL "Done.">
		   <RETURN>)
		  (.PRSO
		   <COND (<OBJECT-ACTION>)
			 (<OREAD .PRSO> <TELL <OREAD .PRSO> ,LONG-TELL1>)
			 (<TELL "I see nothing special about the "
				,POST-CRLF
				<ODESC2 .PRSO>
				".">)>
		   <RETURN>)
		  (<NOT <LIT? .RM>>
		   <TELL 
"It is pitch black.  You are likely to be eaten by a grue.">
		   <RETURN <>>)>
	    <TELL <RDESC2 .RM>>
	    <COND (<OR <AND <NOT .FULL> ,SUPER-BRIEF!-FLAG>
		       <AND <RTRNN .RM ,RSEENBIT>
			    <OR ,BRIEF!-FLAG <PROB 80>>
			    <NOT .FULL>>>)
		  (<AND <EMPTY? <RDESC1 .RM>> <SET RA <RACTION .RM>>>
		   <PERFORM .RA <FIND-VERB "LOOK">>
		   <PUT ,PRSVEC 1 <FIND-VERB "FOO">>
		   <PUT ,PRSVEC 2 <>>)
		  (<TELL <RDESC1 .RM> ,LONG-TELL1>)>
	    <RTRO .RM ,RSEENBIT>
	    <AND .AV <TELL "You are in the " ,POST-CRLF <ODESC2 .AV> ".">>)>
     <COND
      (<NOT <LIT? .RM>> <TELL "I can't see anything.">)
      (<OR <AND <NOT .FULL> <NOT ,NO-OBJ-PRINT!-FLAG>>
	   <NOT <0? <CHTYPE <ANDB .FULL 1> FIX>>>>
       <MAPF <>
	<FUNCTION (X) 
		#DECL ((X) OBJECT)
		<COND (<AND <TRNN .X ,OVISON>
			    <OR <AND .FULL <1? .FULL>> <DESCRIBABLE? .X>>>
		       <COND (<==? .X .AV>)
			     (T
			      <COND (<LONG-DESC-OBJ .X .FULL .FULLQ .FIRST?>
				     <SET FIRST? <>>
				     <AND .AV <TELL " [in the room]" 0>>
				     <TELL "" 1>)>)>
		       <COND (<TRNN .X ,ACTORBIT> <INVENT <OACTOR .X>>)
			     (<SEE-INSIDE? .X>
			      <PRINT-CONT
			       .X
			       .AV
			       .WINOBJ
			       ,INDENTSTR
			       <COND (.FULL)
				     (,SUPER-BRIEF!-FLAG <>)
				     (,BRIEF!-FLAG <>)
				     (T)>>)>)>>
	<ROBJS .RM>>)>
     <COND (<AND <SET RA <RACTION .RM>> <NOT .FULL>>
	    <PERFORM .RA <FIND-VERB "GO-IN">>
	    <PUT ,PRSVEC 1 <FIND-VERB "FOO">>)>
     T>>

"Give a description of an object.
Do short descriptions for the 'object' command.
Otherwise, try odesco (if never touched), odesc1, or odesc2, based
on the state of briefness."

<DEFINE LONG-DESC-OBJ (OBJ "OPTIONAL" (FULL 1) (FULLQ <>) (FIRST? <>) "AUX" STR)
 
	#DECL ((FULLQ FIRST?) <OR ATOM FALSE> (OBJ) OBJECT
	       (STR) <OR FALSE STRING> (FULL) <OR FIX FALSE>)
	<COND (<AND <NOT .FULL>
		    <OR ,SUPER-BRIEF!-FLAG <AND <NOT .FULLQ> ,BRIEF!-FLAG>>>
	       <COND (.FIRST? <TELL "You can see:">)>
	       <TELL "a " 0 <ODESC2 .OBJ>>)
	      (<AND .FULL <1? .FULL>>
	       <COND (<AND <NOT <EMPTY? <SET STR <ODESCO .OBJ>>>>
			   <NOT <TRNN .OBJ ,TOUCHBIT>>>
		      <TELL .STR ,LONG-TELL>)
		     (<NOT <EMPTY? <SET STR <ODESC1 .OBJ>>>>
		      <TELL .STR ,LONG-TELL>)
		     (<TELL "There is a " ,LONG-TELL <ODESC2 .OBJ> " here.">)>)
	      (T
	       <COND (<OR <TRNN .OBJ ,TOUCHBIT> <NOT <ODESCO .OBJ>>>
		      <SET STR <ODESC1 .OBJ>>)
		     (<SET STR <ODESCO .OBJ>>)>
	       <COND (<EMPTY? .STR> <>) (<TELL .STR ,LONG-TELL>)>)>>

<PSETG INDENTSTR <REST <ISTRING 8> 8>>

<DEFINE PRINT-CONT PRINT-C (OBJ AV WINOBJ INDENT "OPTIONAL" (CASE? T)
			    "AUX" (CONT <OCONTENTS .OBJ>) (ALSO <>) (TOBJ <>))
    #DECL ((AV) <OR FALSE OBJECT> (OBJ WINOBJ) OBJECT (INDENT) STRING
	   (CONT) <LIST [REST OBJECT]> (ALSO TOBJ) <OR ATOM FALSE>
	   (PRINT-C) ACTIVATION (CASE?) <OR ATOM FIX FALSE>)
    <COND (<NOT <EMPTY? .CONT>>
	   <COND (<OR ,SUPER-BRIEF!-FLAG <==? .OBJ <SFIND-OBJ "TCASE">>>
		  <SET TOBJ T>)
		 (ELSE
		  <MAPF <>
			<FUNCTION (Y "AUX" STR) 
			     #DECL ((Y) OBJECT (STR) <OR FALSE STRING>)
			     <COND (<AND .AV <==? .Y .WINOBJ>>)
				   (<AND <TRNN .Y ,OVISON>
					 <NOT <TRNN .Y ,TOUCHBIT>>
					 <SET STR <ODESCO .Y>>>
				    <SET ALSO T>
				    <TELL .STR>
				    <COND (<SEE-INSIDE? .Y>
					   <PRINT-CONT .Y .AV .WINOBJ <BACK .INDENT>>)>)
				   (<SET TOBJ T>)>>
	     	        <OCONTENTS .OBJ>>)>
	   <COND (<==? .OBJ <SFIND-OBJ "TCASE">>
		  <COND (<NOT .CASE?> <RETURN T .PRINT-C>)>
		  <AND .TOBJ <TELL "Your collection of treasures consists of:">>)
		 (<AND .TOBJ
		       <NOT <AND <==? <LENGTH .CONT> 1>
				 <==? <1 .CONT> <SFIND-OBJ "#####">>>>>
		  <TELL .INDENT 0>
		  <TELL "The "
			,POST-CRLF
			<ODESC2 .OBJ>
			<COND (.ALSO " also contains:")
			      (" contains:")>>)
		 (<RETURN T .PRINT-C>)>
	   <COND (.TOBJ
		  <MAPF <>
			<FUNCTION (Y) 
				  #DECL ((Y) OBJECT)
				  <COND (<AND .AV <==? .Y .WINOBJ>>)
					(<AND <TRNN .Y ,OVISON>
					      <DESCRIBABLE? .Y>
					      <NOT <EMPTY? <ODESC2 .Y>>>>
					 <TELL .INDENT ,POST-CRLF " A " <ODESC2 .Y>>)>
				  <COND (<SEE-INSIDE? .Y>
					 <PRINT-CONT .Y .AV .WINOBJ <BACK .INDENT>>)>>
			<OCONTENTS .OBJ>>)>)>>

"TRUE IF PARSER WON:  OTHERWISE INHIBITS OBJECT ACTIONS, CLOCKS (BUT NOT THIEF)."

<GDECL (PARSE-WON)
       <OR ATOM FALSE>
       (PARSE-CONT)
       <OR FALSE <VECTOR [REST STRING STRING FIX]>>>

<SETG PARSE-CONT <>>

<DEFINE RDCOM ("OPTIONAL" (IVEC <>)
	       "AUX" VC RVEC (INPLEN 1) (INBUF ,INBUF)
		     (WINNER ,WINNER) AV (OUTCHAN ,OUTCHAN) RANDOM-ACTION PC RV)
   #DECL ((RVEC PC) <OR FALSE VECTOR> (INPLEN) FIX (INBUF) STRING
	  (WINNER) ADV (AV) <OR FALSE OBJECT> (OUTCHAN) CHANNEL
	  (IVEC) <OR FALSE VECTOR> (VC) <OR FALSE VECTOR> (RV) <OR FALSE VECTOR>)
   <COND (<NOT .IVEC>
	  <COND (<0? <13 .OUTCHAN>>
		 <PUT .OUTCHAN 13 80>)>
	  <TTY-INIT <>>
	  <OR ,TELL-FLAG <ROOM-INFO <>>>)>
   <REPEAT (VVAL CV LIT? HERE)
	   #DECL ((CV) <OR FALSE VERB> (LIT?) <OR ATOM FALSE> (HERE) ROOM)
	   <SET VVAL T>
	   <SET PC <>>
	   <SET HERE ,HERE>
	   <SET INBUF ,INBUF>
	   <SET LIT? <LIT? .HERE>>
	   <COND (<SET PC ,PARSE-CONT>)
		 (<NOT .IVEC>
		  <SETG TELL-FLAG <>>
		  <SET INPLEN <READST .INBUF ">" <>>>
		  <COND (<AND <G? .INPLEN 0> <==? <1 .INBUF> !\;>>
			 <AGAIN>)>
		  <SET VC <LEX .INBUF <REST .INBUF .INPLEN>>>)>
	   <COND (<G? .INPLEN 0>
		  <SETG MOVES <+ ,MOVES 1>>
		  <COND (<SETG PARSE-WON
			       <AND <SET RV <OR .IVEC .PC .VC>>
				    <EPARSE .RV <>>
				    <TYPE? <SET CV <1 <SET RVEC ,PRSVEC>>> VERB>>>
			 <SETG NO-TELL 0>
			 <COND (<NOT <SET RANDOM-ACTION <AACTION .WINNER>>>)
			       (<APPLY-RANDOM .RANDOM-ACTION>
				<RETURN>)>
			 <AND <SET AV <AVEHICLE .WINNER>>
			      <SET RANDOM-ACTION <OACTION .AV>>
			      <SET VVAL <NOT <APPLY-RANDOM .RANDOM-ACTION READ-IN>>>>
			 <SETG NO-TELL 0>
			 <COND (<AND .VVAL <SET RANDOM-ACTION <VFCN .CV>>
				     <APPLY-RANDOM .RANDOM-ACTION>>
				<SETG NO-TELL 0>
				<COND (<AND <NOT .LIT?>
					    <==? .HERE <SET HERE ,HERE>>
					    <LIT? .HERE>>
				       <PERFORM ,ROOM-INFO <FIND-VERB "LOOK">>)>
				<COND (<AND <SET RANDOM-ACTION <RACTION ,HERE>>
					    <APPLY-RANDOM .RANDOM-ACTION>>)>)>)
			(.IVEC
			 <COND (,TELL-FLAG
				<TELL "Please input entire command again.">)
			       (<TELL "Nothing happens.">)>
			 <RETURN>)>
		  <OR ,TELL-FLAG <TELL "Nothing happens.">>)
		 (T
		  <SETG PARSE-WON <>>)>
	   <COND (,BUGFLAG <SETG BUGFLAG <>>)
		 (<MAPF <>
			<FUNCTION (X) 
				  #DECL ((X) HACK)
				  <COND (<SET RANDOM-ACTION <HACTION .X>>
					 <SETG NO-TELL 0>
					 <APPLY-RANDOM .RANDOM-ACTION .X>)>>
			,DEMONS>)>
	   <SETG NO-TELL 0>
	   <AND ,PARSE-WON
		<SET AV <AVEHICLE .WINNER>>
		<SET RANDOM-ACTION <OACTION .AV>>
		<APPLY-RANDOM .RANDOM-ACTION READ-OUT>>
	   <AND .IVEC <RETURN>>
	   <COND (<NOT <LIT? ,HERE>>
		  <SETG PARSE-CONT <>>)>>>

<DEFINE SCORE-OBJ (OBJ "AUX" TEMP)
	#DECL ((OBJ) OBJECT (TEMP) FIX)
	<COND (<G? <SET TEMP <OFVAL .OBJ>> 0>
	       <SCORE-UPD .TEMP>
	       <OFVAL .OBJ 0>)>>

<DEFINE SCORE-ROOM (RM "AUX" TEMP)
	#DECL ((RM) ROOM (TEMP) FIX)
	<COND (<G? <SET TEMP <RVAL .RM>> 0>
	       <SCORE-UPD .TEMP>
	       <RVAL .RM 0>)>>

<DEFINE SCORE-UPD (NUM "AUX" (WINNER ,WINNER))
	#DECL ((NUM) FIX (WINNER) ADV)
	<COND (,END-GAME!-FLAG
	       <SETG EG-SCORE <+ ,EG-SCORE .NUM>>)
	      (<SETG RAW-SCORE <+ ,RAW-SCORE .NUM>>
	       <PUT .WINNER ,ASCORE <+ <ASCORE .WINNER> .NUM>>
	       <SCORE-BLESS>)>>

<DEFINE SCORE-BLESS ("AUX" (NUM <ASCORE ,WINNER>) (MS ,SCORE-MAX))
	#DECL ((NUM MS) FIX)
	<COND (<OR <G=? .NUM .MS>
		   <AND <1? ,DEATHS> <G=? .NUM <- .MS 10>>>>
	       <CLOCK-ENABLE <CLOCK-INT ,EGHER 15>>)>>

<DEFINE END-GAME-HERALD ()
	<SETG END-GAME!-FLAG T>
	<TELL ,END-HERALD-1 ,LONG-TELL1>>

<DEFINE SCORE ("OPTIONAL" (ASK? T) "AUX" (EG ,END-GAME!-FLAG)
	       SCOR SMAX (OUTCHAN .OUTCHAN) PCT) 
	#DECL ((ASK?) <OR ATOM FALSE> (SCOR SMAX) FIX (OUTCHAN) CHANNEL (PCT) FLOAT
	       (EG) <OR ATOM FALSE>)
	<SETG TELL-FLAG T>
	<CRLF>
	<PRINC "Your score ">
	<COND (.EG
	       <PRINC "in the end game ">)>
	<COND (.ASK? <PRINC "would be ">)
	      (<PRINC "is ">)>
	<COND (.EG
	       <PRIN1 <SET SCOR ,EG-SCORE>>)
	      (<PRIN1 <SET SCOR <ASCORE ,WINNER>>>)>
	<PRINC " [total of ">
	<PRIN1 <SET SMAX <COND (.EG ,EG-SCORE-MAX) (,SCORE-MAX)>>>
	<PRINC " points], in ">
	<PRIN1 ,MOVES>
	<COND (<1? ,MOVES> <PRINC " move.">)
	      (<PRINC " moves.">)>
	<CRLF>
	<PRINC "This score gives you the rank of ">
	<SET PCT </ <FLOAT .SCOR> <FLOAT .SMAX>>>
	<PRINC <COND (.EG
		      <COND (<1? .PCT> "Dungeon Master")
			    (<G? .PCT .75> "Super Cheater")
			    (<G? .PCT .50> "Master Cheater")
			    (<G? .PCT .25> "Advanced Cheater")
			    ("Cheater")>)
		     (<COND (<1? .PCT> "Cheater")
			    (<G? .PCT 0.95000000> "Wizard")
			    (<G? .PCT 0.89999999> "Master")
			    (<G? .PCT 0.79999999> "Winner")
			    (<G? .PCT 0.60000000> "Hacker")
			    (<G? .PCT 0.39999999> "Adventurer")
			    (<G? .PCT 0.19999999> "Junior Adventurer")
			    (<G? .PCT 0.09999999> "Novice Adventurer")
			    (<G? .PCT 0.04999999> "Amateur Adventurer")
			    (<G=? .PCT 0.0> "Beginner")
			    ("Incompetent")>)>>
	<PRINC ".">
	<CRLF>
	.SCOR>

<DEFINE FINISH ("OPTIONAL" (ASK? T) "AUX" SCOR) 
	#DECL ((ASK?) <OR ATOM <PRIMTYPE LIST>> (SCOR) FIX)
	<COND (<==? <PRIMTYPE .ASK?> LIST>
	       <SET ASK? <CHTYPE .ASK? FALSE>>)>
	<SETG NO-TELL 0>
	<UNWIND
	 <PROG ()
	  <SET SCOR <SCORE .ASK?>>
	  <COND (<OR <AND .ASK?
			  <TELL 
"Do you wish to leave the game? (Y is affirmative): ">
			  <YES/NO <>>>
		     <NOT .ASK?>>
	         <RECORD .SCOR ,MOVES ,DEATHS .ASK? ,HERE>
	         <QUIT>)
		(<TELL "OK.">)>>
	 <QUIT>>>

<DEFINE VERSION () <TELL ,VERS>>

"PRINT OUT DESCRIPTION OF LOSSAGE:  WHEN PLAYED, SCORE, # MOVES, ETC.
IF CALLED WITH CHANNEL, MUST BE FROM ERROR HANDLER--ERROR OCCURRED, GAME
WILL GO AWAY WHEN FINISHES."

<SETG RECORD-STRING <ISTRING 5>>

<SETG BUGFLAG <>>

<GDECL (RECORD-STRING) STRING (BUGFLAG) <OR ATOM FALSE>>

<PSETG RECORDER-STRING <STRING <ASCII 26> <ASCII 3> <ASCII 0>>>

<DEFINE FEECH ()
	<BUGGER T>>

<DEFINE BUGGER ("OPTIONAL" (FEECH? <>) "AUX" (DEATH? <TYPE? .FEECH? CHANNEL>)
		CT STR (CH <>))
    #DECL ((STR) STRING (CH) <OR FALSE <CHANNEL FIX>> (FEECH?) <OR CHANNEL ATOM FALSE>
	   (CT) FIX (DEATH?) <OR ATOM FALSE>)
    <COND (<GASSIGNED? BUGSTR>
	   <SET STR ,BUGSTR>)
	  (<SETG BUGSTR <SET STR <ISTRING 3000>>>)>
    <RESET ,INCHAN>
    <TTY-INIT <>>
    <SETG BUGFLAG T>
    <UNWIND
	<PROG BUGGER ((MUDDLE ,MUDDLE))
	      #DECL ((MUDDLE) FIX (BUGGER) ACTIVATION (ZORK) TUPLE)
	      <COND (.DEATH?
		     <SET CH .FEECH?>
		     <SET FEECH? <>>)
		    (T <TELL "Hold on...">)>
	      <COND (<AND <G? .MUDDLE 100> <NOT .CH> <NOT <SET CH <RECOPEN "BUG">>>>
		     <TELL "Bug report not possible?">)
		    (T
		     <COND (<G? .MUDDLE 100> <CLOSE .CH>)>
		     <PROG ()
			   <TELL <COND (.FEECH? "Feature") ("Bug")>
				 ,POST-CRLF
				 " (terminate with altmode): ">
			   <SET CT <READST .STR "" T>>
			   <COND (<==? .CT <LENGTH .STR>>
				  <TELL "Bug too long?">)
				 (<0? .CT>
				  <COND (.DEATH?
					 <TELL "You can do better than that!">
					 <AGAIN>)
					(<RETURN T .BUGGER>)>)>>
		     <COND (<L? .MUDDLE 100>
			    <SET CH <OPEN "PRINT" "COMSYS;_ZTMP_ >">>
			    <PRINT "SENDER" .CH>
			    <PRINT ,XUNM .CH>
			    <PRINT "FROM" .CH>
			    <PRINT ,XUNM .CH>
			    <PRINC "\"TO\"
(\"ZORK\")
\"ACTION-TO\"
(\"ZORK\")
\"SCHEDULE\"
(\"SENDING\" #FALSE ())
\"SUBJECT\" \"ZORK " .CH>
			    <COND (.FEECH? <PRINC "feature\"" .CH>)
				  (<PRINC "bug\"" .CH>)>
			    <PRINC "
\"TEXT\" \"" .CH>)
			   (<NOT <SET CH <RECOPEN "BUG">>>
			    <TELL "Bug channel can't be opened??">
			    <RETURN T .BUGGER>)
			   (<CRLF .CH>
			    <PRINC "
********		" .CH>
			    <COND (.FEECH? <PRINC "FEATURE    REQUEST" .CH>)
				  (<PRINC "BUG     REPORT" .CH>)>
			    <PRINC "	         **********" .CH>
			    <CRLF .CH>)>
		     <PRINC ,VERS .CH>
		     <RECOUT .CH <ASCORE ,WINNER> ,MOVES ,DEATHS #FALSE (". Griping.")
			     ,HERE>
		     <PRINC "
Text:
" .CH>
		     <COND (<L? .MUDDLE 100>
			    <PUT .CH 13 <CHTYPE <MIN> FIX>>
			    <PRINC !\\\ .CH>
			    <SET STR <SUBSTRUC .STR 0
					       .CT
					       <BACK <REST .STR
							   <LENGTH .STR>>
						     .CT>>>
			    <REPEAT ((SS .STR))
			      #DECL ((SS) <OR FALSE STRING>)
			      <COND (<SET SS <MEMQ !\" .SS>>
				     <PUT .SS 1 !\`>)
				    (<RETURN>)>>
			    <PRINC .STR .CH>)
			   (<PRINTSTRING .STR .CH .CT>)>
		     <COND (.DEATH?
			    <CRLF .CH>
			    <PRINC "Winner:" .CH>
			    <PRINT ,WINNER .CH>
			    <CRLF .CH>
			    <PRINC "Trophy case:" .CH>
			    <PRINT <SFIND-OBJ "TCASE"> .CH>
			    <CRLF .CH>
			    <PRINC "Robber:" .CH>
			    <PRINT ,ROBBER-DEMON .CH>
			    <CRLF .CH>
			    <PRINC "Clocker:" .CH>
			    <PRINT ,CLOCKER .CH>
			    <COND (<AND .DEATH?
					<ASSIGNED? ZORK>>
				   <CRLF .CH>
				   <PRINC "Error:" .CH>
				   <MAPF <>
					 <FUNCTION (X)
						   #DECL ((X) ANY)
						   <PRINT .X .CH>>
					 .ZORK>
				   <CRLF .CH>
				   <PRINC "LEXV:" .CH>
				   <CRLF .CH>
				   <PRINC ,LEXV .CH>
				   <CRLF .CH>
				   <PRINC "PRSVEC:" .CH>
				   <PRINT ,PRSVEC .CH>
				   <CRLF .CH>
				   <PRINC "ORPHANS:" .CH>
				   <CRLF .CH>
				   <PRINC ,ORPHANS .CH>)>
			    <COND (<AND <GASSIGNED? RESTORE-HAPPENED>
					,RESTORE-HAPPENED>
				   <CRLF .CH>
				   <PRINC "Restore happened." .CH>)>)>
		     <CRLF .CH>
		     <COND (<L? .MUDDLE 100>
			    <PRINC !\" .CH>
			    <RENAME .CH "COMSYS;M >">)>
		     <CLOSE .CH>
		     <COND (.FEECH? <TELL "Feature recorded.  Feel free.">)
			   (<TELL "Bug recorded.  Thank you.">)>)>>
	<AND .CH <NOT <0? <1 .CH>>> <CLOSE .CH>>>>

<PSETG 10XERRS ![196687 196693 196696 196691 196675 196697 197210 197408!]>

<GDECL (10XERRS) <UVECTOR [REST FIX]>>

<DEFINE RECOPEN (NAM "AUX" CH (CT 0) FL (STR ,RECORD-STRING)
		(DEV <VALUE DEV>) (SNM <VALUE SNM>) (MUDDLE ,MUDDLE))
    #DECL ((CH) <OR FALSE <CHANNEL FIX>> (MUDDLE FL CT) FIX (NAM STR DEV SNM) STRING)
    <PROG ()
	  <COND (<SET CH <OPEN "READB" "ZORK" .NAM .DEV .SNM>>
		 <COND (<G=? <SET FL <FILE-LENGTH .CH>> 1>
			<ACCESS .CH <- .FL 1>>
			<SET CT <READSTRING .STR .CH ,RECORDER-STRING>>)>
		 <CLOSE .CH>
		 <COND (<SET CH <OPEN "PRINTO" "ZORK" .NAM .DEV .SNM>>)
		       (<AND <G? .MUDDLE 100> <MEMQ <3 .CH> ,10XERRS>>
			; "Can't win--no write access"
			  <RETURN .CH>)
		       (T <SLEEP 1> <AGAIN>)>
		 <ACCESS .CH <MAX 0 <- .FL 1>>>
		 <PRINTSTRING .STR .CH .CT>
		 .CH)
		(<OR <AND <L? .MUDDLE 100> <N==? <3 .CH> *4000000*>>
		     <AND <G? .MUDDLE 100> <==? <3 .CH> *600130*>>>
		 ;"on 10x, must get FILE BUSY to try again"
		 <SLEEP 1>
		 <AGAIN>)
		(<SET CH <OPEN "PRINT" "ZORK" .NAM .DEV .SNM>>)
		(<AND <G? .MUDDLE 100> <MEMQ <3 .CH> ,10XERRS>>
		 ; "No write access"
		   .CH)
		(.CH)>>>

<DEFINE RECORD (SCORE MOVES DEATHS QUIT? LOC "AUX" (CH <>))
	#DECL ((SCORE MOVES DEATHS) FIX (QUIT?) <OR ATOM FALSE> (LOC) ROOM
	       (CH) <OR <CHANNEL FIX> FALSE>)
	<UNWIND
	 <PROG RECORD ()
	  #DECL ((RECORD) ACTIVATION)
	  <AND <NOT <SET CH <RECOPEN "LOG">>> <RETURN T .RECORD>> 
	  <RECOUT .CH .SCORE .MOVES .DEATHS .QUIT? .LOC>
	  <CRLF .CH>
	  <CLOSE .CH>>
	 <AND <TYPE? .CH CHANNEL> <NOT <0? <1 .CH>>> <CLOSE .CH>>>>

<DEFINE RECOUT (CH SCORE MOVES DEATHS QUIT? LOC "AUX" (OUTCHAN .CH))
	#DECL ((CH) CHANNEL (SCORE MOVES DEATHS) FIX (QUIT?) <OR ATOM FALSE>
	       (LOC) ROOM (OUTCHAN) <SPECIAL CHANNEL>)
	<CRLF .CH>
	<PRINC "	" .CH>
	<PRINC ,USER-NAME .CH>
	<COND (<N=? ,USER-NAME ,XUNM>
	       <PRINC "  (" .CH>
	       <PRINC ,XUNM .CH>
	       <PRINC !\) .CH>)>
	<PRINC "	" .CH>
	<PDSKDATE <DSKDATE> .CH>
	<CRLF .CH>
	<PLAY-TIME <>>
	<CRLF .CH>
	<COND (<NOT ,END-GAME!-FLAG>
	       <PRIN1 .SCORE .CH>)
	      (<PRIN1 ,EG-SCORE .CH>
	       <PRINC " end game" .CH>)>
	<PRINC " points, " .CH>
	<PRIN1 .MOVES .CH>
	<PRINC " move" .CH>
	<COND (<1? .MOVES> <PRINC ", " .CH>)
	      (T <PRINC "s, " .CH>)>
	<PRIN1 .DEATHS .CH>
	<PRINC " death" .CH>
	<COND (<1? .DEATHS> <PRINC ". " .CH>)
	      (T <PRINC "s. " .CH>)>
	<PRINC " In " .CH>
	<PRINC <RDESC2 .LOC> .CH>
	<COND (.QUIT? <PRINC ". Quit." .CH>)
	      (<EMPTY? .QUIT?> <PRINC ". Died." .CH>)
	      (<PRINC <1 .QUIT?> .CH>)>
	<CRLF .CH>
	<PRINT-FLAG ,FLAG-NAMES .CH>
	<PRINT-FLAG ,VAL-NAMES .CH>>

<GDECL (FLAG-NAMES VAL-NAMES) <UVECTOR [REST ATOM]>>

<DEFINE PRINT-FLAG (LST CH)
    #DECL ((LST) <UVECTOR [REST ATOM]> (CH) CHANNEL)
    <MAPF <>
	  <FUNCTION (X "AUX" (Y <SPNAME .X>) (VAL ,.X))
		    #DECL ((X) ATOM (Y) STRING)
		    <COND (<OR <AND <TYPE? .VAL FIX>
				    <0? .VAL>>
			       <AND <NOT <TYPE? .VAL FIX>>
				    .VAL>>
			   <PRINC "/" .CH>
			   <PRINC <1 .Y> .CH>
			   <PRINC <2 .Y> .CH>)>>
	  .LST>>

<DEFINE PDSKDATE (WD CH
		  "AUX" (TIM <CHTYPE <GETBITS .WD <BITS 18 0>> FIX>) (A/P " AM")
			HR)
	#DECL ((WD) <PRIMTYPE WORD> (TIM HR) FIX (A/P) STRING (CH) CHANNEL)
	<PRINC " " .CH>
	<COND (<0? <CHTYPE .WD FIX>> <PRINC "unknown " .CH>)
	      (T
	       <PRINC <NTH ,MONTHS <CHTYPE <GETBITS .WD <BITS 4 23>> FIX>> .CH>
	       <PRINC " " .CH>
	       <PRIN1 <CHTYPE <GETBITS .WD <BITS 5 18>> FIX> .CH>
	       <PRINC " at " .CH>
	       <SET HR </ .TIM 7200>>
	       <COND (<G=? .HR 12> <SET HR <- .HR 12>> <SET A/P " PM">)>
	       <COND (<0? .HR> <SET HR 12>)>
	       <PRIN1 .HR .CH>
	       <PRINC ":" .CH>
	       <SET HR </ <MOD .TIM 7200> 120>>
	       <COND (<L? .HR 10> <PRINC "0" .CH>)>
	       <PRIN1 .HR .CH>
	       <PRINC .A/P .CH>)>>

<GDECL (MONTHS) <VECTOR [12 STRING]>>

<SETG DEAD!-FLAG <>>

<DEFINE JIGS-UP (DESC "OPTIONAL" (PLAYER? <>)
		 "AUX" (WINNER ,WINNER) (DEATHS ,DEATHS) (AOBJS <AOBJS .WINNER>)
		       (RANDOM-LIST ,RANDOM-LIST) (LAMP <SFIND-OBJ "LAMP">)
		       LAMP-LOCATION (VAL-LIST ()) LC C RO)
	#DECL ((DESC) STRING (DEATHS) FIX (AOBJS) <LIST [REST OBJECT]>
	       (VAL-LIST RO) <LIST [REST OBJECT]> (LAMP-LOCATION) <OR FALSE ROOM>
	       (WINNER) ADV (RANDOM-LIST) <LIST [REST ROOM]> (C LAMP) OBJECT
	       (LC) <OR FALSE OBJECT> (PLAYER?) <OR ATOM FALSE>)
  <SETG NO-TELL 0>
  <TELL .DESC>
  <COND
   (,DBG)
   (<UNWIND
     <PROG ()
        <COND (<AND <N==? .WINNER ,PLAYER>
		    <NOT .PLAYER?>>
	       <TELL "The " ,POST-CRLF <ODESC2 <AOBJ .WINNER>> " has died.">
	       <REMOVE-OBJECT <AOBJ .WINNER>>
	       <PUT .WINNER ,AROOM <SFIND-ROOM "FCHMP">>
	       <RETURN>)>
	<RESET ,INCHAN>
	<TTY-INIT <>>
	<SCORE-UPD -10>
	<PUT .WINNER ,AVEHICLE <>>
	<REMOVE-OBJECT <SFIND-OBJ "#####">>
	<COND (,END-GAME!-FLAG
	       <TELL

"Normally I could attempt to rectify your condition, but I'm ashamed
to say my abilities are not equal to dealing with your present state
of disrepair.  Permit me to express my profoundest regrets.">
	       <FINISH <>>
	       <REPEAT () <QUIT>>)
	      (<G=? .DEATHS 2>
	       <TELL ,SUICIDAL ,LONG-TELL1>
	       <FINISH <>>)
	      (<SETG DEATHS <+ .DEATHS 1>>
	       <TELL ,DEATH 3>
	       <SETG DEAD!-FLAG T>
	       <SETG GWIM-DISABLE T>
	       <SETG ALWAYS-LIT T>
	       <PUT ,PLAYER ,AACTION ,DEAD-PLAYER>
	       <MAPF <>
		     <FUNCTION (X) #DECL ((X) OBJECT)
			       <TRZ .X ,FIGHTBIT>>
		     <ROBJS ,HERE>>
	       <TRO <SFIND-OBJ "ROBOT"> ,OVISON>
	       <COND (<SET LAMP-LOCATION <OROOM .LAMP>>
		      <COND (<SET LC <OCAN .LAMP>>
			     <PUT .LC
				  ,OCONTENTS
				  <SPLICE-OUT .LAMP <OCONTENTS .LC>>>
			     <PUT .LAMP ,OROOM <>>
			     <PUT .LAMP ,OCAN <>>)
			    (<==? .LAMP-LOCATION <SFIND-ROOM "CP">>
			     <COND (<MEMQ .LAMP <SET RO <ROBJS .LAMP-LOCATION>>>
				    <PUT .LAMP-LOCATION ,ROBJS
					 <SET RO <SPLICE-OUT .LAMP .RO>>>
				    <PUT ,CPOBJS ,CPHERE .RO>)
				   (T
				    <MAPR <>
					  <FUNCTION (Y "AUX" (X <1 .Y>))
						    #DECL ((Y) UVECTOR
							   (X) <LIST [REST OBJECT]>)
						    <COND (<MEMQ .LAMP .X>
							   <PUT .Y 1
								<SPLICE-OUT .LAMP .X>>
							   <MAPLEAVE>)>>
					  ,CPOBJS>)>)
			    (<MEMQ .LAMP <ROBJS .LAMP-LOCATION>>
			     <REMOVE-OBJECT .LAMP>)>
		      <PUT .WINNER ,AOBJS (.LAMP !.AOBJS)>)
		     (<MEMQ .LAMP .AOBJS>
		      <PUT .WINNER ,AOBJS (.LAMP !<SPLICE-OUT .LAMP .AOBJS>)>)>
	       <TRZ <SFIND-OBJ "DOOR"> ,TOUCHBIT>
	       <GOTO <SFIND-ROOM "LLD1">>
	       <SETG PARSE-CONT <>>
	       <SETG EGYPT-FLAG!-FLAG T>
	       <SET VAL-LIST <ROB-ADV .WINNER .VAL-LIST>>
	       <COND (<MEMQ <SET C <SFIND-OBJ "COFFI">> <AOBJS .WINNER>>
		      <PUT .WINNER ,AOBJS <SPLICE-OUT .C <AOBJS .WINNER>>>
		      <INSERT-OBJECT .C <SFIND-ROOM "EGYPT">>)>
	       <MAPF <>
		     <FUNCTION (X Y) 
			       #DECL ((X) OBJECT (Y) ROOM)
			       <INSERT-OBJECT .X .Y>>
		     <SET AOBJS <AOBJS .WINNER>>
		     .RANDOM-LIST>
	       <COND (<G=? <LENGTH .RANDOM-LIST> <LENGTH .AOBJS>>
		      <SET AOBJS .VAL-LIST>)
		     (<EMPTY? .VAL-LIST>
		      <SET AOBJS <REST .AOBJS <LENGTH .RANDOM-LIST>>>)
		     (T
		      <PUTREST <REST .VAL-LIST <- <LENGTH .VAL-LIST> 1>>
			       <REST .AOBJS <LENGTH .RANDOM-LIST>>>
		      <SET AOBJS .VAL-LIST>)>
	       <REPEAT ((ROOMS ,ROOMS) RM (AOBJS .AOBJS))
		       #DECL ((ROOMS) <LIST [REST ROOM]> (AOBJS) <LIST [REST OBJECT]>)
		       <COND (<EMPTY? .AOBJS> <RETURN>)>
		       <COND (<NOT <RTRNN <SET RM <1 .ROOMS>> <+ ,RENDGAME ,RAIRBIT
								 ,RWATERBIT>>>
			      <INSERT-OBJECT <1 .AOBJS> .RM>
			      <SET AOBJS <REST .AOBJS>>)>
		       <SET ROOMS <REST .ROOMS>>>
	       <PUT .WINNER ,AOBJS ()>
	       <KILL-CINTS>
	       T)>>
   <PROG ()
	 <RECORD <SCORE <>> ,MOVES ,DEATHS <> ,HERE>
	 <QUIT>>>)>>

<DEFINE KILL-CINTS ("AUX" (CINTS <HOBJS ,CLOCKER>))
    #DECL ((CINTS) <LIST [REST CEVENT]>)
    <MAPF <>
	  <FUNCTION (CINT)
		    #DECL ((CINT) CEVENT)
		    <COND (<CDEATH .CINT>
			   <CLOCK-INT .CINT 0>
			   <OR <CFLAG .CINT> <CLOCK-DISABLE .CINT>>)>>
	  .CINTS>>

<DEFINE RESTART ("AUX" (DEV <VALUE DEV>) (SNM <VALUE SNM>) (FILE1 "MADADV")
		 (FILE2 "SAVE") SCOR STR C)
	#DECL ((DEV SNM FILE1 FILE2 STR) STRING (SCOR) FIX (C) <OR CHANNEL FALSE>)
	<SET SCOR <SCORE T>>
	<SETG NO-TELL 0>
	<TELL "Do you wish to restart? (Y is affirmative): ">
	<COND (<YES/NO <>>
	       <RECORD .SCOR ,MOVES ,DEATHS #FALSE (". Restart.") ,HERE>
	       <TELL "Restarting.">
	       <SET STR <COND (<G? ,MUDDLE 100>
			       <STRING !\< .SNM !\> .FILE1 !\. .FILE2>)
			      (<STRING .DEV !\: .SNM !\; .FILE1 !\  .FILE2>)>>
	       <COND (<SET C <OPEN "READ" .STR>>
		      <CLOSE .C>
		      <RESTORE .STR>)
		     (<TELL
"Sorry, the dungeon isn't where I thought it was.  You'll have to get
the program again.">
		      <QUIT>)>)>>

<DEFINE INFO () <FILE-TO-TTY "MADADV" "INFO">>

<DEFINE DOC () <FILE-TO-TTY "MADADV" "DOC">>

<DEFINE HELP () <FILE-TO-TTY "MADADV" "HELP">>

<PSETG BREAKS <STRING <ASCII 3> <ASCII 0>>>

<DEFINE FILE-TO-TTY (FILE1 FILE2 "OPTIONAL" (DEV <VALUE DEV>) (SNM <VALUE SNM>)
		     "AUX" (CH <OPEN "READ" .FILE1 .FILE2 .DEV .SNM>)
		     	   LEN
			   (BUF ,INBUF) (BUFLEN <LENGTH .BUF>)
			   ITER)
	#DECL ((BUF FILE1 FILE2 DEV SNM) STRING (CH) <OR CHANNEL FALSE> 
	       (ITER LEN BUFLEN) FIX)
	<COND (.CH
	       <UNWIND
		<PROG ()
		      <SET LEN <FILE-LENGTH .CH>>
		      <SET ITER </ .LEN .BUFLEN>>
		      <OR <0? <MOD .LEN .BUFLEN>> <SET ITER <+ .ITER 1>>>
		      <CRLF ,OUTCHAN>
		      <SETG TELL-FLAG T>
		      <REPEAT (SLEN)
			      #DECL ((SLEN) FIX)
			      <COND (<1? .ITER>
				     <SET SLEN <READSTRING .BUF .CH ,BREAKS>>)
				    (<SET SLEN <READSTRING .BUF .CH .BUFLEN>>)>
			      <COND (<NOT <0? ,NO-TELL>>
				     <OR <0? <1 .CH>> <CLOSE .CH>>
				     <RETURN>)>
			      <PRINTSTRING .BUF ,OUTCHAN .SLEN>
			      <COND (<0? <SET ITER <- .ITER 1>>>
				     <CRLF ,OUTCHAN>
				     <RETURN <CLOSE .CH>>)>>>
		<COND (<NOT <0? <1 .CH>>> <CLOSE .CH>)>>)
	      (<TELL "File not found.">)>>

<DEFINE INVENT ("OPTIONAL" (WIN ,WINNER) "AUX" (ANY <>) (OUTCHAN ,OUTCHAN)) 
   #DECL ((ANY) <OR ATOM FALSE> (OUTCHAN) CHANNEL (WIN) ADV)
   <MAPF <>
    <FUNCTION (X) 
	    #DECL ((X) OBJECT)
	    <COND (<TRNN .X ,OVISON>
		   <OR .ANY <PROG ()
				  <COND (<==? .WIN ,PLAYER>
					 <TELL "You are carrying:">)
					(<TELL "The "
					       ,POST-CRLF
					       <ODESC2 <AOBJ .WIN>>
					       " is carrying:">)>
				  <SET ANY T>>>
		   <TELL "A " 0 <ODESC2 .X>>
		   <COND (<OR <EMPTY? <OCONTENTS .X>> <NOT <SEE-INSIDE? .X>>>)
			 (<TELL " with " 0>
			  <PRINT-CONTENTS <OCONTENTS .X>>)>
		   <CRLF>)>>
    <AOBJS .WIN>>
   <OR .ANY <N==? .WIN ,PLAYER> <TELL "You are empty handed.">>>

<DEFINE PRINT-CONTENTS (OLST "AUX" (OUTCHAN ,OUTCHAN))
    #DECL ((OLST) <LIST [REST OBJECT]> (OUTCHAN) CHANNEL)
    <MAPR <>
	<FUNCTION (Y) 
		#DECL ((Y) <LIST [REST OBJECT]>)
		<PRINC "a ">
		<PRINC <ODESC2 <1 .Y>>>
		<COND (<G? <LENGTH .Y> 2>
		       <PRINC ", ">)
		      (<==? <LENGTH .Y> 2>
		       <PRINC ", and ">)>>
	.OLST>>


;"WALK --
	GIVEN A DIRECTION, WILL ATTEMPT TO WALK THERE"

<DEFINE WALK ("AUX" LEAVINGS NRM (WHERE <2 ,PRSVEC>) (ME ,WINNER)
		    RANDOM-ACTION (RM <1 .ME>) (NL <>) (LOSSTR <>) (DARK <>))
	#DECL ((WHERE) DIRECTION (ME) ADV (RM) ROOM (LOSSTR) <OR FALSE STRING>
	       (RANDOM-ACTION) <OR ATOM FALSE NOFFSET>
	       (LEAVINGS) <OR FALSE ATOM ROOM CEXIT DOOR NEXIT>
	       (NRM) <OR FALSE
			 <<PRIMTYPE VECTOR> [REST DIRECTION
					          <OR ROOM NEXIT CEXIT DOOR>]>>
	       (NL) <OR ATOM ROOM FALSE> (DARK) <OR ATOM FALSE>)
	<COND (<SET NRM <MEMQ .WHERE <REXITS .RM>>>
	       <SET LEAVINGS <2 .NRM>>
	       <COND (<TYPE? .LEAVINGS ROOM>)
		     (<TYPE? .LEAVINGS CEXIT>
		      <SET NL
			   <COND (<AND <SET RANDOM-ACTION
					    <CXACTION .LEAVINGS>>
				       <APPLY-RANDOM .RANDOM-ACTION>>)
				 (,<CXFLAG .LEAVINGS>
				  <CXROOM .LEAVINGS>)>>
		      <COND (<TYPE? .NL ROOM>
			     <SET LEAVINGS .NL>)
			    (ELSE
			     <SET LOSSTR <CXSTR .LEAVINGS>>
			     <SET LEAVINGS <>>)>)
		     (<TYPE? .LEAVINGS DOOR>
		      <SET NL
			   <COND (<AND <SET RANDOM-ACTION
					    <DACTION .LEAVINGS>>
				       <APPLY-RANDOM .RANDOM-ACTION>>)
				 (<TRNN <DOBJ .LEAVINGS> ,OPENBIT>
				  <GET-DOOR-ROOM .RM .LEAVINGS>)>>
		      <COND (<TYPE? .NL ROOM>
			     <SET LEAVINGS .NL>)
			    (ELSE
			     <SET LOSSTR <DSTR .LEAVINGS>>
			     <SET LEAVINGS <>>)>)
		     (ELSE
		      <SET LOSSTR <CHTYPE .LEAVINGS STRING>>
		      <SET LEAVINGS <>>)>)>
	<COND (<AND .NRM
		    .LEAVINGS
		    <OR <LIT? .RM>
			<LIT? .LEAVINGS>>>
	       <AND <GOTO .LEAVINGS> <ROOM-INFO <>>>)
	      (<AND <==? .ME ,PLAYER> <SET DARK <NOT <LIT? .RM>>> <PROB 25 50>>
	       <COND (<NOT .NL>
		      <COND (.NRM <NOGO .LOSSTR .WHERE>)
			    (T
			     <SETG PARSE-CONT <>>
			     <TELL "You can't go that way.">)>)>)
	      (<NOT .NRM>
	       <COND (.DARK <JIGS-UP
"Oh, no!  You walked into the slavering fangs of a lurking grue.">)
		     (<NOT .NL>
		      <NOGO <> .WHERE>)>)
	      (T
	       <COND (.DARK <JIGS-UP
"Oh, no!  A fearsome grue slithered into the room and devoured you.">)
		     (.NL
		      <SETG PARSE-CONT <>>
		      T)
		     (<NOGO .LOSSTR .WHERE>)>)>>

<DEFINE NOGO (STR DIR) #DECL ((STR) <OR STRING FALSE> (DIR) DIRECTION)
	<SETG PARSE-CONT <>>
	<TELL <COND (<AND .STR <NOT <EMPTY? .STR>>>
	             .STR)
	            (<NOT <RTRNN ,HERE ,RNWALLBIT>>
	             <COND (<==? .DIR <FIND-DIR "UP">>
		            "There is no way up.")
		           (<==? .DIR <FIND-DIR "DOWN">>
		            "There is no way down.")
		     	   ("There is a wall there.")>)
	      	    ("You can't go that way.")>>>

<DEFINE TAKE ("OPTIONAL" (TAKE? T)
	      "AUX" (WIN ,WINNER) (RM <AROOM .WIN>) NOBJ (GETTER? <>) (FROM <3 ,PRSVEC>)
		    (ROBJS <ROBJS .RM>) (AOBJS <AOBJS .WIN>) (LOAD-MAX ,LOAD-MAX))
   #DECL ((WIN) ADV (NOBJ) OBJECT (RM) ROOM (GETTER? TAKE?) <OR ATOM FALSE>
	  (LOAD-MAX) FIX (ROBJS AOBJS) <LIST [REST OBJECT]> (FROM) <OR FALSE OBJECT>)
   <PROG ()
	 <COND (<TRNN <PRSO> ,NO-CHECK-BIT>
		<RETURN <OBJECT-ACTION>>)>
	 <COND (<NOT <0? <OGLOBAL <PRSO>>>>
		<RETURN <OBJECT-ACTION>>)>
	 <COND (<OCAN <PRSO>>
		<SET NOBJ <OCAN <PRSO>>>
		<SET GETTER? T>)>
	 <COND
	  (<AND .FROM <N==? .FROM <OCAN <PRSO>>>>
	   <TELL "It's not in that!">)
	  (<==? <PRSO> <AVEHICLE .WIN>>
	   <TELL "You are in it, loser!">
	   <RETURN <>>)
	  (<NOT <TRNN <PRSO> ,TAKEBIT>>
	   <OR <APPLY-OBJECT <PRSO>> <TELL <PICK-ONE ,YUKS>>>
	   <RETURN <>>)
	  (<OR .GETTER? <MEMQ <PRSO> .ROBJS>>
	   <SET LOAD-MAX <+ .LOAD-MAX <FIX <* </ 1.0 .LOAD-MAX> <ASTRENGTH .WIN>>>>>
	   <COND (<AND .GETTER? <MEMQ .NOBJ .AOBJS>>)
		 (<G? <+ <WEIGHT .AOBJS> <WEIGHT <OCONTENTS <PRSO>>> <OSIZE <PRSO>>>
		      .LOAD-MAX>
		  <TELL 
"Your load is too heavy.  You will have to leave something behind.">
		  <RETURN <SETG PARSE-CONT <>>>)>
	   <COND (<NOT <APPLY-OBJECT <PRSO>>>
		  <REMOVE-OBJECT <PRSO>>
		  <TAKE-OBJECT <PRSO>>
		  <SCORE-OBJ <PRSO>>
		  <COND (.TAKE? <TELL "Taken.">) (T)>)
		 (T)>)
	  (<MEMQ <PRSO> .AOBJS> <TELL "You already have it.">)>>>

<DEFINE PUTTER ("OPTIONAL" (OBJACT T) 
		"AUX" (PV ,PRSVEC) CROCK CAN (ROBJS <ROBJS ,HERE>) (OCAN <>))
	#DECL ((ROBJS) <LIST [REST OBJECT]> (CROCK CAN) OBJECT
	       (OCAN) <OR FALSE OBJECT> (OBJACT) <OR ATOM FALSE> (PV) VECTOR)
	<PROG ()
	      <COND (<TRNN <PRSO> ,NO-CHECK-BIT>
		     <RETURN <OBJECT-ACTION>>)>
	      <COND (<NOT
		      <AND <0? <OGLOBAL <PRSO>>>
			   <0? <OGLOBAL <PRSI>>>>>
		     <RETURN <OR <OBJECT-ACTION>
				 <TELL "Nice try.">>>)>
	      <COND (<OR <TRNN <PRSI> ,OPENBIT>
			 <OPENABLE? <PRSI>>
			 <TRNN <PRSI> ,VEHBIT>>
		     <SET CAN <PRSI>>
		     <SET CROCK <PRSO>>)
		    (<TELL "I can't do that."> <RETURN <>>)>
	      <COND (<NOT <TRNN .CAN ,OPENBIT>>
		     <TELL "I can't reach inside.">
		     <RETURN <>>)
		    (<==? .CAN .CROCK>
		     <TELL "How can you do that?">
		     <RETURN <>>)
		    (<==? <OCAN .CROCK> .CAN>
		     <TELL "The " 0 <ODESC2 .CROCK> " is already in the ">
		     <TELL <ODESC2 .CAN>>
		     <RETURN T>)>
	      <COND (<AND <OCAN .CAN>
			  <==? <OCAN .CAN> .CROCK>>
		     <COND (<NOT <PERFORM ,TAKE <FIND-VERB "TAKE"> .CAN>>
			    <RETURN <>>)>)>
	      <COND (<G? <+ <WEIGHT <OCONTENTS .CAN>>
			    <WEIGHT <OCONTENTS .CROCK>>
			    <OSIZE .CROCK>>
			 <OCAPAC .CAN>>
		     <COND (<==? .CAN <AVEHICLE ,WINNER>>
			    <TELL "There isn't enough room in the " 1 <ODESC2 .CAN> ".">)
			   (<TELL "It won't fit.">)>
		     <RETURN <>>)>
	      <COND (<OR <MEMQ .CROCK .ROBJS>
			 <AND <SET OCAN <OCAN .CROCK>>
			      <MEMQ .OCAN .ROBJS>>
			 <AND .OCAN
			      <SET OCAN <OCAN .OCAN>>
			      <MEMQ .OCAN .ROBJS>>>
		     <PUT .PV 1 <FIND-VERB "TAKE">>
		     <PUT .PV 2 .CROCK>
		     <PUT .PV 3 <>>
		     <COND (<NOT <TAKE <>>>
			    <PUT .PV 1 <FIND-VERB "PUT">>
			    <PUT .PV 2 .CROCK>
			    <PUT .PV 3 .CAN>
			    <RETURN <>>)
			   (T)>)
		    (<SET OCAN <OCAN .CROCK>>
		     <SCORE-OBJ .CROCK>
		     <TAKE-OBJECT .CROCK>
		     <REMOVE-FROM .OCAN .CROCK>)>
	      <PUT .PV 1 <FIND-VERB "PUT">>
	      <PUT .PV 2 .CROCK>
	      <PUT .PV 3 .CAN>
	      <COND (<AND .OBJACT <OBJECT-ACTION>> <RETURN>)
		    (<DROP-OBJECT .CROCK>
		     <INSERT-INTO .CAN .CROCK>
		     <PUT .CROCK ,OROOM ,HERE>
		     <TELL "Done.">)>>>
 
<DEFINE DROPPER ("AUX" (WINNER ,WINNER) (AV <AVEHICLE .WINNER>)
		    (AOBJS <AOBJS .WINNER>) (GETTER? <>) (VEC ,PRSVEC)
		    (RM <AROOM .WINNER>) NOBJ (VB <PRSA>))
	#DECL ((VEC) <VECTOR VERB OBJECT <OR FALSE OBJECT>> (WINNER) ADV
	       (NOBJ) OBJECT (AV) <OR FALSE OBJECT> (AOBJS) <LIST [REST OBJECT]>
	       (RM) ROOM (GETTER?) <OR ATOM FALSE> (VB) VERB)
	<PROG ()
	      <COND (<==? <PRSO> .AV>
	      	     <RETURN <PERFORM UNBOARD <FIND-VERB "DISEM"> <PRSO>>>)
	            (<TRNN <PRSO> ,NO-CHECK-BIT>
		     <RETURN <OBJECT-ACTION>>)>
	      <COND (<AND <OCAN <PRSO>> <SET NOBJ <OCAN <PRSO>>> <MEMQ .NOBJ .AOBJS>>
		     <SET GETTER? T>)>
	      <COND (<OR .GETTER? <MEMQ <PRSO> .AOBJS>>
		     <COND (.AV)
			   (.GETTER?
			    <COND (<TRNN .NOBJ ,OPENBIT>
				   <REMOVE-FROM .NOBJ <PRSO>>)
				  (<TELL "The " 1 <ODESC2 .NOBJ> " is closed.">
				   <RETURN>)>)
			   (<DROP-OBJECT <PRSO>>)>
		     <COND (.AV
			    <PUT .VEC 2 <PRSO>>
			    <PUT .VEC 3 .AV>
			    <PUTTER <>>
			    <PUT .VEC 3 <>>
			    <PUT .VEC 1 .VB>)
			   (<INSERT-OBJECT <PRSO> .RM>)>
		     <COND (<OBJECT-ACTION>)
			   (.AV)
			   (<VERB? "DROP">
			    <TELL "Dropped.">)
			   (<VERB? "THROW">
			    <TELL "Thrown.">)>)
		    (<TELL "You are not carrying that.">)>>>


"STUFF FOR 'EVERYTHING' AND 'VALUABLES'"

<SETG OBJ-UV <CHUTYPE <REST <IUVECTOR 20> 20> OBJECT>>

<GDECL (OBJ-UV) <UVECTOR [REST OBJECT]>>

<DEFINE FROB-LOTS FL (UV "AUX" (PRSVEC ,PRSVEC) (RA <VFCN <PRSA>>)
		   (WINNER ,WINNER) (HERE ,HERE) (NONE? <>))
  #DECL ((UV) <UVECTOR [REST OBJECT]> (PRSVEC) <VECTOR VERB [2 ANY]>
	 (RA) RAPPLIC (WINNER) ADV (HERE) ROOM (NONE?) <OR FALSE ATOM>)
  <COND (<VERB? "TAKE">
	 <COND (<NOT <LIT? .HERE>>
		<TELL "It is too dark in here to see.">
		<RETURN T .FL>)>
	 <MAPF <>
	   <FUNCTION (X) #DECL ((X) OBJECT)
	     <COND (<OR <TRNN .X ,TAKEBIT>
			<TRNN .X ,TRYTAKEBIT>>
		    <PUT .PRSVEC 2 .X>
		    <TELL <ODESC2 .X> 0 ":
  ">
		    <SET NONE? T>
		    <APPLY-RANDOM .RA>
		    <COND (<N==? .HERE <AROOM .WINNER>>
			   <MAPLEAVE>)>)>>
	   .UV>
	 <OR .NONE? <TELL "I can't find anything.">>)
	(<VERB? "DROP" "PUT">
	 <COND (<AND <VERB? "PUT">
		     <==? <PRSI> <PRSO>>>
		<TELL "I should recurse infinitely to teach you a lesson, but...">
		<RETURN T .FL>)
	       (<AND <VERB? "PUT">
		     <NOT <EMPTY? <PRSI>>>
		     <NOT <LIT? .HERE>>>
		<TELL "It is too dark in here to see.">
		<RETURN T .FL>)>
	 <MAPF <>
	   <FUNCTION (X) #DECL ((X) OBJECT)
	     <PUT .PRSVEC 2 .X>
	     <TELL <ODESC2 .X> 0 ":
  ">
	     <APPLY-RANDOM .RA>
	     <COND (<N==? .HERE <AROOM .WINNER>>
		    <MAPLEAVE>)>>
	   .UV>)>
  T>

<DEFINE VALUABLES&C ("OPTIONAL" (EVERYTHING? <MEMQ <SFIND-OBJ "EVERY"> ,PRSVEC>)
				(ALLBUT <>) 
		     "AUX" (PRSVEC ,PRSVEC) (SUV ,OBJ-UV) (TUV <TOP .SUV>)
			   (LU <LENGTH .TUV>) (HERE ,HERE) (WINNER ,WINNER)
			   (WRONG-VERB? <>)
			   (ROOM-LIST <COND (<AVEHICLE .WINNER>
					     <OCONTENTS <AVEHICLE .WINNER>>)
					    (<ROBJS .HERE>)>))
   #DECL ((SUV TUV) <UVECTOR [REST OBJECT]> (LU) FIX (HERE) ROOM (WINNER) ADV
	  (EVERYTHING?) <OR <VECTOR [REST ANY]> FALSE FIX ATOM>
	  (WRONG-VERB?) <OR ATOM FALSE> (ROOM-LIST) <LIST [REST OBJECT]>
	  (ALLBUT) <OR FALSE <UVECTOR [REST OBJECT]>>)
   <COND (<MEMQ <SFIND-OBJ "POSSE"> ,PRSVEC>
	  <SET EVERYTHING? 1>)>
   <COND (<VERB? "TAKE">
	  <MAPF <>
		<FUNCTION (X) 
			#DECL ((X) OBJECT)
			<COND (<AND <TRNN .X ,OVISON>
				    <NOT <TRNN .X ,ACTORBIT>>
				    <VALCHK .EVERYTHING? .X .ALLBUT>>
			       <COND (<==? .SUV .TUV>
				      <TELL ,LOSSTR>
				      <MAPLEAVE>)>
			       <SET SUV <BACK .SUV>>
			       <PUT .SUV 1 .X>)>>
		.ROOM-LIST>)
	 (<VERB? "DROP">
	  <MAPF <>
		<FUNCTION (X) 
			#DECL ((X) OBJECT)
			<COND (<VALCHK .EVERYTHING? .X .ALLBUT>
			       <SET SUV <BACK .SUV>>
			       <PUT .SUV 1 .X>)>>
		<AOBJS .WINNER>>)
	 (<VERB? "PUT">
	  <PROG RP ()
		<MAPF <>
		      <FUNCTION (X) 
			      #DECL ((X) OBJECT)
			      <COND (<AND <==? .SUV .TUV>
					  <N==? .X <PRSI>>>
				     <TELL ,LOSSTR>
				     <RETURN T .RP>)>
			      <COND (<AND <TRNN .X ,OVISON>
					  <VALCHK .EVERYTHING? .X .ALLBUT>>
				     <SET SUV <BACK .SUV>>
				     <PUT .SUV 1 .X>)>>
		      .ROOM-LIST>
		<MAPF <>
		      <FUNCTION (X) 
			      #DECL ((X) OBJECT)
			      <COND (<AND <==? .SUV .TUV>
					  <N==? .X <PRSI>>>
				     <TELL ,LOSSTR>
				     <RETURN T .RP>)>
			      <COND (<VALCHK .EVERYTHING? .X .ALLBUT>
				     <SET SUV <BACK .SUV>>
				     <PUT .SUV 1 .X>)>>
		      <AOBJS .WINNER>>>)
	 (<SET WRONG-VERB? T>)>
   <COND (.WRONG-VERB? <TELL "I can't do that with everything at once.">)
	 (<EMPTY? .SUV>
	  <TELL "I couldn't find any"
		1
		<COND (.EVERYTHING? "thing.") (T " valuables.")>>)
	 (<FROB-LOTS .SUV>)>>

; "If FLG is T or a VECTOR, this is EVERYTHING;
   If FLG is a FIX, this is POSSESSIONS;
   If FLG is a FALSE, this is VALUABLES;
   In any event, this is KLUDGY."

<DEFINE VALCHK (FLG OBJ BUT) 
	#DECL ((FLG) <OR VECTOR ATOM FIX FALSE> (OBJ) OBJECT
	       (BUT) <OR FALSE <UVECTOR [REST OBJECT]>>)
	<AND <OR <TYPE? .FLG VECTOR ATOM>
		 <AND <TYPE? .FLG FIX> <MEMQ .OBJ <AOBJS ,WINNER>>>
		 <AND <NOT .FLG> <NOT <0? <OTVAL .OBJ>>>>>
	     <OR <NOT .BUT> <NOT <MEMQ .OBJ .BUT>>>>>



<DEFINE OPENER OPEN-ACT ("AUX" (OUTCHAN ,OUTCHAN)) 
	#DECL ((OUTCHAN) CHANNEL (OPEN-ACT) ACTIVATION)
	<COND (<OBJECT-ACTION>)
	      (<NOT <TRNN <PRSO> ,CONTBIT>>
	       <TELL "You must tell me how to do that to a " ,POST-CRLF
		     <ODESC2 <PRSO>> ".">)
	      (<N==? <OCAPAC <PRSO>> 0>
	       <COND (<TRNN <PRSO> ,OPENBIT> <TELL "It is already open.">)
		     (T
		      <TRO <PRSO> ,OPENBIT>
		      <COND (<OR <EMPTY? <OCONTENTS <PRSO>>>
				 <TRNN <PRSO> ,TRANSBIT>>
			     <TELL "Opened.">)
			    (<SETG TELL-FLAG T>
			     <TELL "Opening the " 0 <ODESC2 <PRSO>> " reveals ">
			     <PRINT-CONTENTS <OCONTENTS <PRSO>>>
			     <PRINC !\.>
			     <CRLF>)>)>)
	      (<TELL "The " ,POST-CRLF <ODESC2 <PRSO>> " cannot be opened.">)>>

<DEFINE CLOSER CLOSE-ACT () 
	#DECL ((CLOSE-ACT) ACTIVATION)
	<COND (<OBJECT-ACTION>)
	      (<NOT <TRNN <PRSO> ,CONTBIT>>
	       <TELL "You must tell me how to do that to a "
		     ,POST-CRLF <ODESC2 <PRSO>> ".">)
	      (<N==? <OCAPAC <PRSO>> 0>
	       <COND (<TRNN <PRSO> ,OPENBIT> <TRZ <PRSO> ,OPENBIT> <TELL "Closed.">)
		     (T <TELL "It is already closed.">)>)
	      (<TELL "You cannot close that.">)>>

<DEFINE FIND ()
  <COND (<OBJECT-ACTION>)
	(<NOT <EMPTY? <PRSO>>>
	 <FIND-FROB <ROBJS ,HERE>
		    ", which is in the room."
		    "There is a "
		    " here.">
	 <FIND-FROB <AOBJS ,WINNER>
		    ", which you are carrying."
		    "You are carrying a "
		    ".">)>>

<DEFINE FIND-FROB (OBJL STR1 STR2 STR3)
  #DECL ((OBJL) <LIST [REST OBJECT]> (STR1 STR2 STR3) STRING)
  <MAPF <>
	<FUNCTION (X) #DECL ((X) OBJECT)
		  <COND (<==? .X <PRSO>>
			 <TELL .STR2 ,POST-CRLF <ODESC2 .X> .STR3>)
			(<OR <TRNN .X ,TRANSBIT>
			     <AND <OPENABLE? .X> <TRNN .X ,OPENBIT>>>
			 <MAPF <>
			       <FUNCTION (Y) #DECL ((Y) OBJECT)
					 <COND (<==? .Y <PRSO>>
						<TELL .STR2 ,POST-CRLF
						      <ODESC2 .Y> .STR3>
						<TELL "It is in the "
						      ,POST-CRLF
						      <ODESC2 .X>
						      .STR1>)>>
			       <OCONTENTS .X>>)>>
	 .OBJL>>

;"OBJECT-ACTION --
	CALL OBJECT FUNCTIONS FOR DIRECT AND INDIRECT OBJECTS"

<DEFINE OBJECT-ACTION () 
	<PROG ()
	      <COND (<NOT <EMPTY? <PRSI>>> <AND <APPLY-OBJECT <PRSI>> <RETURN T>>)>
	      <COND (<NOT <EMPTY? <PRSO>>> <APPLY-OBJECT <PRSO>>)>>>

"WEIGHT:  Get sum of OSIZEs of supplied list, recursing to the nth level."

<DEFINE WEIGHT (OBJL) 
	#DECL ((OBJL) <LIST [REST OBJECT]> (VALUE) FIX)
	<MAPF ,+
	      <FUNCTION (OBJ) 
		      #DECL ((OBJ) OBJECT)
		      <+ <COND (<==? <OSIZE .OBJ> ,BIGFIX> 0)
			       (<OSIZE .OBJ>)>
			 <WEIGHT <OCONTENTS .OBJ>>>>
	      .OBJL>>

<DEFINE MOVE ("AUX" (RM <AROOM ,WINNER>)) 
	#DECL ((RM) ROOM)
	<COND (<MEMQ <PRSO> <ROBJS .RM>>
	       <COND (<OBJECT-ACTION>)
		     (<TRNN <PRSO> ,TAKEBIT>
		      <TELL "Moving the "
			    ,POST-CRLF <ODESC2 <PRSO>> " reveals nothing.">)
		     (<TELL "You can't move the " ,POST-CRLF <ODESC2 <PRSO>> ".">)>)
	      (<NOT <EMPTY? <PRSO>>>
	       <TELL "I can't get to that to move it.">)>>

<DEFINE LAMP-ON LAMPO ("AUX" (ME ,WINNER) (LIT? <LIT? ,HERE>)) 
	#DECL ((ME) ADV (LAMPO) ACTIVATION (LIT?) <OR ATOM FALSE>)
	<COND (<OBJECT-ACTION>)
	      (<COND (<AND <TRNN <PRSO> ,LIGHTBIT>
			   <MEMQ <PRSO> <AOBJS .ME>>>)
		     (T <TELL "You can't turn that on."> <RETURN T .LAMPO>)>
	       <COND (<TRNN <PRSO> ,ONBIT> <TELL "It is already on.">)
		     (<TRO <PRSO> ,ONBIT>
		      <TELL "The " ,POST-CRLF <ODESC2 <PRSO>> " is now on.">)>)>>

<DEFINE LAMP-OFF LAMPO ("AUX" (ME ,WINNER)) 
	#DECL ((ME) ADV (LAMPO) ACTIVATION)
	<COND (<OBJECT-ACTION>)
	      (<COND (<AND <TRNN <PRSO> ,LIGHTBIT>
			   <MEMQ <PRSO> <AOBJS .ME>>>)
		     (<TELL "You can't turn that off."> <RETURN T .LAMPO>)>
	       <COND (<NOT <TRNN <PRSO> ,ONBIT>> <TELL "It is already off.">)
		     (<TRZ <PRSO> ,ONBIT>
		      <TELL "The " ,POST-CRLF <ODESC2 <PRSO>> " is now off.">
		      <OR <LIT? ,HERE> <TELL "It is now pitch black.">>)>)>>

<DEFINE WAIT ("OPTIONAL" (NUM 3))
    #DECL ((NUM) FIX)
    <TELL "Time passes...">
    <REPEAT ((N .NUM))
	#DECL ((N) FIX)
	<COND (<OR <L? <SET N <- .N 1>> 0>
		   <CLOCK-DEMON ,CLOCKER>
		   <FIGHTING ,FIGHT-DEMON>>
	       <RETURN>)>>>

"RUNS ONLY IF PARSE WON, TO PREVENT SCREWS FROM TYPOS."

<DEFINE CLOCK-DEMON (HACK "AUX" CA (FLG <>) (CINT <FIND-VERB "C-INT">))
    #DECL ((HACK) HACK (FLG) <OR ATOM FALSE> (CA) ANY (CINT) VERB)
    <COND (,PARSE-WON
	   <MAPF <>
		 <FUNCTION (EV "AUX" (TICK <CTICK .EV>))
			   #DECL ((EV) CEVENT (TICK) FIX)
			   <COND (<NOT <CFLAG .EV>>)
				 (<0? .TICK>)
				 (<L? .TICK 0>
				  <SET FLG T>
				  <PERFORM <CACTION .EV> .CINT>)
				 (<PUT .EV ,CTICK <SET TICK <- .TICK 1>>>
				  <COND (<0? .TICK>
				         <SET FLG T>
				         <PERFORM <CACTION .EV> .CINT>)>)>>
					 
		 <HOBJS .HACK>>)>
    .FLG>

<GDECL (CLOCKER) HACK>

<DEFINE CLOCK-INT (CEV "OPTIONAL" (NUM <>) (FLAG? <>) "AUX" (CLOCKER ,CLOCKER))
    #DECL ((CEV) CEVENT (NUM) <OR FIX FALSE> (CLOCKER) HACK (FLAG?) <OR ATOM FALSE>)
    <COND (<NOT <MEMQ .CEV <HOBJS .CLOCKER>>>
	   <PUT .CLOCKER ,HOBJS (.CEV !<HOBJS .CLOCKER>)>)>
    <COND (.FLAG?
	   <PUT .CEV ,CFLAG T>)>
    <COND (.NUM <PUT .CEV ,CTICK .NUM>)>>

<SETG DEMONS ()>

<OR <LOOKUP "COMPILE" <ROOT>>
    <LOOKUP "GROUP-GLUE" <GET INITIAL OBLIST>>
    <ADD-DEMON <SETG CLOCKER <CHTYPE [CLOCK-DEMON ()] HACK>>>>

<DEFINE BOARD B ("AUX" (WIN ,WINNER) (AV <AVEHICLE .WIN>)) 
	#DECL ((B) ACTIVATION (WIN) ADV (AV) <OR FALSE OBJECT>)
	<COND (<TRNN <PRSO> ,VEHBIT>
	       <COND (<NOT <MEMQ <PRSO> <ROBJS ,HERE>>>
		      <TELL "The " ,POST-CRLF <ODESC2 <PRSO>>
			    " must be on the ground to be boarded.">)
		     (.AV
		      <TELL "You are already in the "
			    ,POST-CRLF
			    <ODESC2 <PRSO>>
			    ", cretin!">)
		     (T
		      <COND (<OBJECT-ACTION>)
			    (<TELL "You are now in the " ,POST-CRLF <ODESC2 <PRSO>> ".">
			     <PUT .WIN ,AVEHICLE <PRSO>>
			     <INSERT-INTO <PRSO> <SFIND-OBJ "#####">>
			     <RETURN T .B>)>)>)
	      (<TELL "I suppose you have a theory on boarding a "
		     ,POST-CRLF
		     <ODESC2 <PRSO>>
		     ".">)>
	<SETG PARSE-CONT <>>
	T>

<DEFINE UNBOARD ("AUX" (WIN ,WINNER) (AV <AVEHICLE .WIN>))
  	#DECL ((WIN) ADV (AV) <OR FALSE OBJECT>)
	<COND (<==? .AV <PRSO>>
	       <COND (<OBJECT-ACTION>)
		     (<RTRNN ,HERE ,RLANDBIT>
		      <TELL
"You are on your own feet again.">
		      <PUT .WIN ,AVEHICLE <>>
		      <REMOVE-FROM <PRSO> <SFIND-OBJ "#####">>)
		     (<TELL
"You realize, just in time, that disembarking here would probably be
fatal.">
		      <SETG PARSE-CONT <>>
		      T)>)
	      (<TELL
"You aren't in that!">
	       <SETG PARSE-CONT <>>
	       T)>>

<DEFINE GOTO (RM "OPTIONAL" (WIN ,WINNER)
	      "AUX" (AV <AVEHICLE ,WINNER>) (HERE ,HERE)
		    (LB <RTRNN .RM ,RLANDBIT>))
	#DECL ((HERE RM) ROOM (WIN) ADV (AV) <OR FALSE OBJECT>
	       (LB) <OR ATOM FALSE>)
	<COND (<OR <AND <NOT .LB> <OR <NOT .AV> <NOT <RTRNN .RM <OVTYPE .AV>>>>>
		   <AND <RTRNN .HERE ,RLANDBIT>
			.LB
			.AV
			<N==? <OVTYPE .AV> ,RLANDBIT>
			<NOT <RTRNN .RM <OVTYPE .AV>>>>>
	       <COND (.AV <TELL "You can't go there in a " ,POST-CRLF <ODESC2 .AV> ".">)
		     (<0? <CHTYPE <RBITS .RM> FIX>>
		      <TELL
 "		Halt! Excavation in Progress!
	    Frobozz Magic Implementation Company">)
		     (<TELL "You can't go there without a vehicle.">)>
	       <>)
	      (<RTRNN .RM ,RMUNGBIT> <TELL <RDESC1 .RM> ,LONG-TELL1>)
	      (T
	       <COND (<N==? .WIN ,PLAYER>
		      <REMOVE-OBJECT <AOBJ .WIN>>
		      <INSERT-OBJECT <AOBJ .WIN> .RM>)>
	       <COND (.AV <REMOVE-OBJECT .AV> <INSERT-OBJECT .AV .RM>)>
	       <PUT .WIN ,AROOM <SETG HERE .RM>>
	       <SCORE-ROOM .RM>
	       T)>>

<DEFINE BACKER ()
	<TELL ,BACKSTR>>

<DEFINE MUNG-ROOM (RM STR)
    #DECL ((RM) ROOM (STR) STRING)
    <RTRO .RM ,RMUNGBIT>
    <PUT .RM ,RDESC1 .STR>>

<DEFINE COMMAND ("AUX" NV (WIN ,WINNER) (PLAY ,PLAYER) (LV ,LEXV) V)
    #DECL ((NV LV) <VECTOR [REST STRING STRING FIX]> (V) VECTOR (WIN PLAY) ADV)
    <SET V <REST <MEMBER "" .LV> 3>>
    <SET NV <REST <MEMBER "" .V> 3>>
    <COND (<N==? .WIN .PLAY>
	   <TELL "You cannot talk through another person!">)
	  (<OBJECT-ACTION>)
	  (<TRNN <PRSO> ,ACTORBIT>
	   <SETG WINNER <OACTOR <PRSO>>>
	   <SETG HERE <AROOM ,WINNER>>
	   <REPEAT ()
		   <RDCOM <OR ,PARSE-CONT .V>>
		   <COND (<NOT ,PARSE-CONT> <RETURN>)>>
	   <OR <EMPTY? <1 .NV>> <SETG PARSE-CONT .NV>>
	   <SETG WINNER .PLAY>
	   <SETG HERE <AROOM .PLAY>>)
	  (<TRNN <PRSO> ,VICBIT>
	   <TELL "The " 1 <ODESC2 <PRSO>> " pays no attention.">)
	  (<TELL "You cannot talk to that!">)>>

"SELECT -- Fill TO with random elements from FROM"

<DEFINE SELECT (FROM TO "AUX" (K1 ,XUNM) (K2 <OR ,SPELL!-FLAG "ZORK!">)) 
	#DECL ((FROM TO) VECTOR (K1 K2) STRING)
	<SELECT-SOME .FROM .TO <S+ .K1> <S+ .K2>>>

<DEFINE SELECT-SOME (FROM TO F1 F2 "AUX" Q) 
   #DECL ((FROM TO) VECTOR (F1 F2 Q) FIX)
   <COND (<G? .F2 .F1> <RANDOM .F1 .F2>)(<RANDOM .F2 .F1>)>
   <MAPR <> <FUNCTION (TT) #DECL ((TT) VECTOR) <PUT .TT 1 <>>> .TO>
   <REPEAT ()
	   <SET Q <NTH .FROM <+ 1 <MOD <RANDOM> <LENGTH .FROM>>>>>
	   <COND (<MAPR <>
			<FUNCTION (V "AUX" (V1 <1 .V>)) 
				#DECL ((V) VECTOR (V1) <OR FALSE FIX>)
				<COND (<==? .V1 .Q> <MAPLEAVE <>>)
				      (<NOT .V1>
				       <PUT .V 1 .Q>
				       <COND (<EMPTY? <REST .V>> <MAPLEAVE T>)
					     (<MAPLEAVE <>>)>)>>
			.TO>
		  <RETURN .TO>)>>>

<DEFINE S+ (STR "AUX" (C 0))
	#DECL ((STR) STRING (C VALUE) FIX)
	<MAPF <>
	      <FUNCTION (A)
		   #DECL ((A) CHARACTER)
		   <SET C <+ .C <ASCII .A>>>>
	      .STR>
	.C>