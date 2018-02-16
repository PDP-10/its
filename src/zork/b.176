
"BIBLE -- print catalog of object, rooms, and verbs"

<SETG NO-SORT T>

<DEFINE BIBLE ("OPTIONAL" (F "NUL:") "AUX" (C <OPEN "PRINT" .F>) (O ,OUTCHAN)) 
	#DECL ((F) STRING (C) <OR CHANNEL FALSE> (O) CHANNEL)
	<SETG NO-SORT <>>
	<AND .C
	     <PROG ((OUTCHAN .C))
		   #DECL ((OUTCHAN) <SPECIAL CHANNEL>)
		   <SETG OUTCHAN .C>
		   <APPLY-RANDOM DO-SCRIPT>
		   <ATLAS>
		   <PRINC <ASCII 12> .C>
		   <CATALOG>
		   <PRINC <ASCII 12> .C>
		   <GET-ACTIONS>
		   <PRINC <ASCII 12> .C>
		   <APPLY-RANDOM DO-UNSCRIPT>
		   <SETG OUTCHAN .O>
		   <CLOSE .C>>>
	"DONE">

<DEFINE ATLAS ("TUPLE" RMTUP
	       "AUX" (CNT 0) (RMS '![]) (OUTCHAN .OUTCHAN) (TEST? <>) (SHORT? <>)
	       (PVAL? <>)) 
	#DECL ((RMTUP) TUPLE (RMS) <UVECTOR [REST ROOM]> (OUTCHAN) CHANNEL
	       (CNT) FIX (TEST? SHORT?) <OR FALSE ATOM>)
	<COND (<EMPTY? .RMTUP>)
	      (ELSE
	       <COND (<==? <1 .RMTUP> T>
		      <SET RMTUP <REST .RMTUP>>
		      <SET SHORT? T>
		      <COND (<==? <1 .RMTUP> T>
			     <SET RMTUP <REST .RMTUP>>
			     <SET PVAL? T>)>)>
	       <COND (<AND <NOT <EMPTY? .RMTUP>> <TYPE? <1 .RMTUP> ROOM>>
		      <SET RMS
			   <MAPF
			     ,UVECTOR
			     <FUNCTION (N "AUX" R)
				  #DECL ((N) STRING (R) ROOM)
				  <COND (<NOT <EMPTY? <RDESC2 <SET R <FIND-ROOM .N>>>>>
					 <MAPRET .R>)
					(<PRINC "****** "> <PRINC .N>
					 <PRINC " is NOT a room ******">
					 <CRLF> <MAPRET>)>>
			     .RMTUP>>)
		     (<AND <NOT <EMPTY? .RMTUP>> <TYPE? <1 .RMTUP> FORM ATOM FIX>>
		      <SET TEST? T>)>)>
	<MAPF <>
	      <FUNCTION (R "AUX" X)
		   #DECL ((R) <SPECIAL ROOM> (X) ANY)
		   <COND (<OR <NOT .TEST?>
			      <MAPF <>
				    <FUNCTION (TEST)
					 #DECL ((TEST) ANY)
					 <OR <COND (<TYPE? .TEST FIX>
						    <RTRNN .R .TEST>)
						   (<TYPE? .TEST ATOM>
						    <COND (<NOT <GASSIGNED? .TEST>> <>)
							  (<TYPE? ,.TEST FIX>
							   <SET X <NTH .R ,.TEST>>)
							  (<SET X <OGET .R .TEST>>)>)
						   (<EVAL .TEST>)>
					     <MAPLEAVE <>>>>
				    .RMTUP>>
			  <SET CNT <+ .CNT 1>>
			  <COND (.SHORT?
				 <ROOM-NAME .R>
				 <COND (.PVAL? <COLUMN 30> <PRINC "==> "> <SPRINT .X>)>
				 <CRLF>)
				(ELSE <RINFO .R .RMS>)>)>>
	      <COND (<OR .TEST? ,NO-SORT> <UVECTOR !,ROOMS>)
		    (<OORDER <UVECTOR !,ROOMS> ,RDESC2>)>>
	.CNT>

"CATALOG -- print catalog of all objects"

<DEFINE CATALOG ("TUPLE" OBJTUP
		 "AUX" (CNT 0) OBJS (OUTCHAN .OUTCHAN) (TEST? <>) (SHORT? <>)
		 (PVAL? <>))
	#DECL ((OBJTUP) TUPLE (OBJS) UVECTOR (OUTCHAN) CHANNEL
	       (CNT) FIX (TEST? SHORT?) <OR ATOM FALSE>)
	<COND (<EMPTY? .OBJTUP> <SET OBJS <UVECTOR !,OBJECTS>>)
	      (ELSE
	       <COND (<==? <1 .OBJTUP> T>
		      <SET OBJTUP <REST .OBJTUP>>
		      <SET SHORT? T>
		      <COND (<==? <1 .OBJTUP> T>
			     <SET OBJTUP <REST .OBJTUP>>
			     <SET PVAL? T>)>)>
	       <COND (<AND <NOT <EMPTY? .OBJTUP>> <TYPE? <1 .OBJTUP> FORM ATOM FIX>>
		      <SET TEST? T>
		      <SET OBJS <UVECTOR !,OBJECTS>>)
		     (<NOT <EMPTY? .OBJTUP>>
		      <SET OBJS
			   <MAPF
			     ,UVECTOR
			     <FUNCTION (N "AUX" O)
				  #DECL ((N) STRING (O) OBJECT)
				  <COND (<NOT <EMPTY? <ODESC2 <SET O <FIND-OBJ .N>>>>>
					 <MAPRET .O>)
					(ELSE
					 <PRINC "****** ">
					 <PRINC .N>
					 <PRINC " is NOT an object ******">
					 <CRLF>
					 <MAPRET>)>>
			     .OBJTUP>>)
		     (ELSE <SET OBJS <UVECTOR !,OBJECTS>>)>)>
	<MAPF <>
	      <FUNCTION (O "AUX" X)
		   #DECL ((O) <SPECIAL OBJECT> (X) ANY)
		   <COND (<OR <NOT .TEST?>
			      <MAPF <>
				    <FUNCTION (TEST)
					 #DECL ((TEST) ANY)
					 <OR <COND (<TYPE? .TEST FIX>
						    <TRNN .O .TEST>)
						   (<TYPE? .TEST ATOM>
						    <COND (<NOT <GASSIGNED? .TEST>> <>)
							  (<TYPE? ,.TEST FIX>
							   <SET X <NTH .O ,.TEST>>)
							  (<SET X <OGET .O .TEST>>)>)
						   (<EVAL .TEST>)>
					     <MAPLEAVE <>>>>
				    .OBJTUP>>
			  <SET CNT <+ .CNT 1>>
			  <COND (.SHORT?
				 <OBJECT-NAME .O>
				 <COND (.PVAL? <COLUMN 30> <PRINC "==> "> <SPRINT .X>)>
				 <CRLF>)
				(ELSE <OINFO .O>)>)>>
	      <COND (<OR .TEST? ,NO-SORT> .OBJS)
		    (<OORDER .OBJS ,ODESC2>)>>
	.CNT>

<DEFINE COLUMN (N "AUX" (OUTCHAN .OUTCHAN) (X <- .N <14 .OUTCHAN>>))
	#DECL ((N X) FIX (OUTCHAN) CHANNEL)
	<COND (<L=? .X 0> <PRINC !\ >)
	      (ELSE
	       <PRINTSTRING "                                             "
			    .OUTCHAN
			    .X>)>>

<DEFINE SPRINT (A "AUX" (OUTCHAN .OUTCHAN) AR AL)
	#DECL ((A) ANY (OUTCHAN) CHANNEL (AR) <OR STRING FALSE> (AL) FIX)
	<COND (<TYPE? .A OBJECT> <OBJECT-NAME .A>)
	      (<TYPE? .A ROOM> <ROOM-NAME .A>)
	      (<MONAD? .A> <PRIN1 .A>)
	      (<TYPE? .A STRING>
	       <REPEAT ()
	       	       <COND (<EMPTY? .A>
			      <SET AL 0>
			      <SET A "">
			      <RETURN>)
			     (<MEMQ <1 .A> " 	
\"">
			      <SET A <REST .A>>)
			     (ELSE
			      <COND (<SET AR <MEMQ <ASCII 13> .A>>
				     <SET AL <- <LENGTH .A> <LENGTH .AR>>>)
				    (<SET AL <LENGTH .A>>)>
			      <SET AL <MIN .AL <- <13 .OUTCHAN> <+ 6 <14 .OUTCHAN>>>>>
			      <RETURN>)>>
	       <PRINC !\">
	       <PRINTSTRING .A .OUTCHAN .AL>
	       <PRINC "... \"">)>
	T>

\ 

<DEFINE RINFO (A "OPTIONAL" (RMS '![])
	       "AUX" R (OUTCHAN .OUTCHAN) (HERO ,PLAYER) (LAMP <FIND-OBJ "LAMP">)) 
	#DECL ((A) <OR ROOM STRING> (R) ROOM (RMS) UVECTOR (OUTCHAN) CHANNEL
	       (HERO) ADV (LAMP) OBJECT)
	<AND <TYPE? .A STRING> <SET A <FIND-ROOM .A>>>
	<SET R .A>
	<OR <MEMQ <FIND-OBJ "LAMP"> <AOBJS ,WINNER>> <CONS-OBJ "LAMP">>
	<TRO .LAMP ,ONBIT>
	<PROG ()
	      <COND (<==? <RID .R> <PSTRING "!">> <RETURN>)>
	      <COND (<AND <NOT <EMPTY? .RMS>>
			  <NOT <MEMQ .R .RMS>>
			  <NOT <EXIT-TO <REXITS .R> .RMS>>>
		     <RETURN>)>
	      <SETG HERE .R>
	      <PUT .HERO ,AROOM .R>
	      <RTRO .R ,RSEENBIT>
	      <PRINC "
====== ">
	      <ROOM-NAME .R T>
	      <PRINC " ======
">
	      <CRLF>
	      <BIT-INFO .R>
	      <DIR-INFO .R>
	      <PRINC "`">
	      <COND (<TYPE? ,ROOM-DESC RSUBR RSUBR-ENTRY>
		     <ROOM-DESC>)
		    (<APPLY-RANDOM ,ROOM-DESC>)>
	      <PRINC "'">
	      <CRLF>
	      <COND (<RACTION .R>
		     <PRINC "Special action function: ">
		     <COND (<TYPE? <RACTION .R> NOFFSET>
			    <PRIN1 <GET-ATOM <RACTION .R>>>)
			   (<FUNCTION-PRINT <RACTION .R>>)>
		     <CRLF>)>>>

<SETG BITTYS
      [,RLIGHTBIT
       ,RAIRBIT
       ,RWATERBIT
       ,RSACREDBIT
       ,RFILLBIT
       ,RMUNGBIT
       ,RBUCKBIT
       ,RHOUSEBIT
       ,RENDGAME]>

<SETG DESCS
      '["Lighted"
	"Mid-air"
	"Watery"
	"Robber-proof"
	"Water-source"
	"Destroyed"
	"Bucket"
	"part of the House"
	"part of the End Game"]>

<GDECL (BITTYS) <VECTOR [REST FIX]> (DESCS) <VECTOR [REST STRING]>>

"BIT-INFO -- print info about a room's bits"

<DEFINE BIT-INFO (R "AUX" (BB <>) (OUTCHAN .OUTCHAN))
	#DECL ((R) ROOM (BB) <OR ATOM FALSE> (OUTCHAN) CHANNEL)
	<COND (<NOT <0? <RVAL .R>>>
	       <PRINC "Room is valued at ">
	       <PRINC <RVAL .R>>
	       <SET BB T>)>
	<MAPF <>
	      <FUNCTION (B D)
		 #DECL ((B) FIX (D) STRING)
		 <COND (<RTRNN .R .B>
			<COND (.BB <PRINC ", ">)
			      (ELSE
			       <PRINC "Room is ">)>
			<SET BB T>
			<PRINC .D>)>>
	      ,BITTYS
	      ,DESCS>
	<AND .BB <PRINC ".

">>>

<COND (<NOT <LOOKUP "COMPILE" <ROOT>>>
       <SETG DIRS
	     [<CHTYPE <PSTRING "OUT"> DIRECTION>
	      "Out"
	      <CHTYPE <PSTRING "NE"> DIRECTION>
	      "Northeast"
	      <CHTYPE <PSTRING "NW"> DIRECTION>
	      "Northwest"
	      <CHTYPE <PSTRING "SE"> DIRECTION>
	      "Southeast"
	      <CHTYPE <PSTRING "SW"> DIRECTION>
	      "Southwest"
	      <CHTYPE <PSTRING "NORTH"> DIRECTION>
	      "North"
	      <CHTYPE <PSTRING "SOUTH"> DIRECTION>
	      "South"
	      <CHTYPE <PSTRING "EAST"> DIRECTION>
	      "East"
	      <CHTYPE <PSTRING "WEST"> DIRECTION>
	      "West"
	      <CHTYPE <PSTRING "UP"> DIRECTION>
	      "Up"
	      <CHTYPE <PSTRING "DOWN"> DIRECTION>
	      "Down"
	      <CHTYPE <PSTRING "LAUNC"> DIRECTION>
	      "Launch"
	      <CHTYPE <PSTRING "CROSS"> DIRECTION>
	      "Cross"
	      <CHTYPE <PSTRING "CLIMB"> DIRECTION>
	      "Climb"
	      <CHTYPE <PSTRING "EXIT"> DIRECTION>
	      "Exit"
	      <CHTYPE <PSTRING "ENTER"> DIRECTION>
	      "Enter"
	      <CHTYPE <PSTRING "LAND"> DIRECTION>
	      "Land"]>)>

<GDECL (DIRS) <VECTOR [REST DIRECTION STRING]>>

<DEFINE EXIT-TO (EXITS RMS)
	#DECL ((EXITS) EXIT (RMS) <UVECTOR [REST ROOM]>)
	<MAPF <>
	      <FUNCTION (E)
		 #DECL ((E) <OR DIRECTION ROOM CEXIT NEXIT DOOR>)
		 <COND (<TYPE? .E DIRECTION>)
		       (<AND <TYPE? .E ROOM> <MEMQ .E .RMS>>
			<MAPLEAVE T>)
		       (<AND <TYPE? .E CEXIT> <MEMQ <2 .E> .RMS>>
			<MAPLEAVE T>)
		       (<AND <TYPE? .E DOOR>
			     <OR <MEMQ <DROOM1 .E> .RMS>
				 <MEMQ <DROOM2 .E> .RMS>>>
			<MAPLEAVE T>)>>
	      .EXITS>>

<DEFINE DIR-INFO (ROOM "AUX" (L <REXITS .ROOM>) (DL ,DIRS) D R (OUTCHAN .OUTCHAN) X) 
	#DECL ((L) <OR EXIT VECTOR> (DL) VECTOR (OUTCHAN) CHANNEL (D) STRING
	       (ROOM) ROOM (X) <OR FALSE VECTOR> (R) ANY)
	<REPEAT ()
		<COND (<EMPTY? .L> <CRLF> <RETURN>)
		      (<NOT <TYPE? <1 .L> DIRECTION>>
		       <PRINC "  BADLY designed room!">)
		      (<==? <1 .L> <CHTYPE <PSTRING "#!#!#"> DIRECTION>>
		       <PRINC "No exits from this room.">
		       <COND (<LENGTH? .L 2> <CRLF> <CRLF> <RETURN>)
			     (ELSE <PRINC "  BADLY designed room!">)>)
		      (<SET X <MEMQ <1 .L> .DL>> <PRINC <2 .X>>)
		      (ELSE <PRINC <1 .L>>)>
		<COND (<TYPE? <SET R <2 .L>> ROOM>
		       <PRINC " to ">
		       <ROOM-NAME .R>
		       <PRINC !\.>)
		      (<TYPE? .R CEXIT>
		       <PRINC " to ">
		       <ROOM-NAME <2 .R>>
		       <PRINC " (if ">
		       <PRINC <1 .R>>
		       <PRINC ").">)
		      (<TYPE? .R DOOR>
		       <PRINC " to ">
		       <ROOM-NAME <COND (<==? <DROOM1 .R> .ROOM> <DROOM2 .R>)
					(<==? <DROOM2 .R> .ROOM> <DROOM1 .R>)>>
		       <PRINC " (if ">
		       <OBJECT-NAME <DOBJ .R>>
		       <PRINC " is open).">)
		      (<TYPE? .R NEXIT>
		       <PRINC " is closed: ">
		       <COND (<EMPTY? <SET D <REST .R 0>>>
			      <PRINC "[No reason]">)
			     (<PRINC .D>)>)
		      (ELSE <PRINC "???">)>
		<CRLF>
		<SET L <REST .L 2>>>>

"ROOM-NAME -- print name of a room in less than 40 characters"

<DEFINE ROOM-NAME (R "OPTIONAL" (BIG <>) "AUX" (D <RDESC2 .R>) (OUTCHAN .OUTCHAN))
	#DECL ((R) ROOM (D) STRING (BIG) <OR ATOM FALSE> (OUTCHAN) CHANNEL)
	<COND (<EMPTY? .D>
	       <PRINC "[NIL Room]">)
	      (ELSE
	       <COND (<OR .BIG <LENGTH? .D 40>> <PRINC .D>)
		     (ELSE <PRINTSTRING .D .OUTCHAN 35> <PRINC "...">)>
	       <PRINC " {">
	       <PRINC <STRINGP <RID .R>>>
	       <PRINC !\}>)>>

\ 

<DEFINE OBJECT-NAME (O "OPTIONAL" (A? <>) "AUX" (OUTCHAN .OUTCHAN))
	#DECL ((O) OBJECT (A?) <OR ATOM FALSE> (OUTCHAN) CHANNEL)
	<COND (<EMPTY? <ODESC2 .O>>)
	      (T
	       <AND .A? <PRINC "A ">>
	       <PRINC <ODESC2 .O>>)>
	<PRINC " {">
	<PRINC <STRINGP <OID .O>>>
	<PRINC !\}>>

"OINFO -- print info for a given object"

<DEFINE OINFO (SOBJ "OPTIONAL" (REC? <>) "AUX" O BB (OUTCHAN .OUTCHAN) OSYN)
	#DECL ((SOBJ) <OR STRING OBJECT> (O) OBJECT (OUTCHAN) CHANNEL
	       (OSYN) UVECTOR (BB REC?) <OR ATOM FALSE>)
	<COND (<TYPE? .SOBJ STRING> <SET O <FIND-OBJ .SOBJ>>)
	      (<SET O .SOBJ>)>
	<PRINC "
====== ">
	<OBJECT-NAME .O T>
	<PRINC " ======">
	<CRLF>
	<SET OSYN
	     <COND (<NOT <EMPTY? <ONAMES .O>>> <REST <ONAMES .O>>)
		   (ELSE <ONAMES .O>)>>
	<COND (<NOT <EMPTY? .OSYN>>
	       <CRLF>
	       <PRINC "Synonyms: ">
	       <SET BB <>>
	       <MAPF <>
		     <FUNCTION (A)
			       #DECL ((A) PSTRING)
			       <COND (.BB <PRINC ", ">)>
			       <SET BB T>
			       <PRINC <STRINGP .A>>>
		     <REST <ONAMES .O>>>
	       <PRINC !\.>
	       <CRLF>)>
	<COND (<NOT <EMPTY? <OADJS .O>>>
	       <AND <EMPTY? .OSYN> <CRLF>>
	       <PRINC "Adjectives: ">
	       <SET BB <>>
	       <MAPF <>
		     <FUNCTION (A)
			       #DECL ((A) ADJECTIVE)
			       <COND (.BB <PRINC ", ">)>
			       <SET BB T>
			       <PRINC <STRINGP .A>>>
		     <OADJS .O>>
	       <PRINC !\.>
	       <CRLF>)>
	<CRLF>
	<COND (<TRNN .O ,NDESCBIT>
	       <PRINC "[No description]">
	       <CRLF>)
	      (ELSE
	       <COND (<AND <ODESCO .O> <NOT <EMPTY? <ODESCO .O>>>>
		      <PRINC "`">
		      <PRINC <ODESCO .O>>
		      <PRINC "'">
		      <CRLF>)>
	       <COND (<NOT <EMPTY? <ODESC1 .O>>>
		      <PRINC "`">
		      <PRINC <ODESC1 .O>>
		      <PRINC "'">
		      <CRLF>)>)>
	<CRLF>
	<COND (<NOT <0? <OGLOBAL .O>>>
	       <PRINC "The ">
	       <OBJECT-NAME .O>
	       <PRINC " is a global object.">
	       <CRLF>)>
	<REPEAT ((O .O) (FIRST? T))
		#DECL ((O) OBJECT (FIRST?) <OR ATOM FALSE>)
		<COND (<OCAN .O>
		       <SET O <OCAN .O>>
		       <COND (<OR <TRNN .O ,VILLAIN> <OACTOR .O>>
			      <COND (.FIRST? <PRINC "Carried by a ">)
				    (ELSE <PRINC ", carried by a ">)>)
			     (.FIRST? <PRINC "In a ">)
			     (ELSE <PRINC ", in a ">)>
		       <OBJECT-NAME .O>
		       <SET FIRST? <>>)
		      (<OROOM .O>
		       <COND (.FIRST? <PRINC "In the ">)
			     (ELSE <PRINC ", in the ">)>
		       <ROOM-NAME <OROOM .O>>
		       <PRINC !\.>
		       <RETURN>)
		      (ELSE
		       <COND (.FIRST? <PRINC "No initial location.">)
			     (ELSE <PRINC ", nowhere.">)>
		       <RETURN>)>>
       <CRLF>
       <COND (<OR <NOT <0? <OFVAL .O>>>
		  <NOT <0? <OTVAL .O>>>>
	       <PRINC "Value: ">
	       <COND (<NOT <0? <OFVAL .O>>>
		      <PRINC <OFVAL .O>>
		      <PRINC " if found">
		      <COND (<NOT <0? <OTVAL .O>>>
			     <PRINC ", ">
			     <PRINC <OTVAL .O>>
			     <PRINC " more if in trophy case">)>)
		     (<NOT <0? <OTVAL .O>>>
		      <PRINC <OTVAL .O>>
		      <PRINC " if in trophy case">)>
	       <PRINC ".">
	       <CRLF>)>
	<COND (<G? <OSIZE .O> 0>
	       <PRINC "Weighs ">
	       <COND (<==? <OSIZE .O> ,BIGFIX> <PRINC "a ton">)
		     (<PRINC <OSIZE .O>>)>
	       <PRINC ".">
	       <CRLF>)>
	<COND (<TRNN .O ,LIGHTBIT>
	       <PRINC "Can produce light ">
	       <COND (<OLINT .O>
		      <PRINC "for ">
		      <PRINC <1 <2 <OLINT .O>>>>
		      <PRINC " moves.">)
		     (ELSE <PRINC "indefinitely.">)>
	       <CRLF>)>
	<COND (<G? <OCAPAC .O> 0>
	       <PRINC "Capacity of ">
	       <PRINC <OCAPAC .O>> <PRINC "."> <CRLF>
	       <COND (<NOT <EMPTY? <OCONTENTS .O>>>
		      <SET BB <>>
		      <MAPF <>
			    <FUNCTION (C)
				#DECL ((C) OBJECT)
				<COND (.BB <PRINC ", ">)
				      (ELSE
				       <PRINC "The ">
				       <OBJECT-NAME .O>
				       <PRINC " contains ">)>
				<SET BB T>
				<PRINC "a ">
				<OBJECT-NAME .C>>
			    <OCONTENTS .O>>
		      <PRINC ".">
		      <CRLF>)>)>
	<COND (<G? <OSTRENGTH .O> 0>
	       <PRINC "Fighting strength of ">
	       <PRINC <OSTRENGTH .O>> <PRINC "."> <CRLF>
	       <COND (<NOT <EMPTY? <OCONTENTS .O>>>
		      <SET BB <>>
		      <MAPF <>
			    <FUNCTION (C)
				#DECL ((C) OBJECT)
				<COND (.BB <PRINC ", ">)
				      (ELSE
				       <PRINC "The ">
				       <OBJECT-NAME .O>
				       <PRINC " is armed with ">)>
				<SET BB T>
				<PRINC "a ">
				<OBJECT-NAME .C>>
			    <OCONTENTS .O>>
		      <PRINC ".">
		      <CRLF>)>)>
	<COND (<NOT <0? <CHTYPE <OFLAGS .O> FIX>>>
	       <SET BB <>>
	       <MAPF <>
		     <FUNCTION (B D)
			       #DECL ((B) FIX (D) STRING)
			       <COND (<TRNN .O .B>
				      <COND (.BB <PRINC ", ">)
					    (ELSE
					     <PRINC "The ">
					     <OBJECT-NAME .O>
					     <PRINC " is ">)>
				      <SET BB T>
				      <PRINC .D>)>>
		     ,OBITTYS
		     ,ODESCS>
	       <PRINC ".">
	       <CRLF>)>
	<COND (<OACTION .O>
	       <PRINC "Special action function: ">
	       <FUNCTION-PRINT <OACTION .O>>
	       <CRLF>)>
	<COND (.REC?
	       <MAPF <>
		     <FUNCTION (O) #DECL ((O) OBJECT) <OINFO .O T>>
		     <OCONTENTS .O>>)>
	"DONE">

<SETG OBITTYS
      ![,OVISON
	,READBIT
	,TAKEBIT
	,DOORBIT
	,TRANSBIT
	,FOODBIT
	,NDESCBIT
	,DRINKBIT
	,CONTBIT
	,LIGHTBIT
	,VICBIT
	,BURNBIT
	,FLAMEBIT
	,TOOLBIT
	,TURNBIT
	,VEHBIT
	,FINDMEBIT
	,SLEEPBIT
	,SEARCHBIT
	,SACREDBIT
	,TIEBIT
	,CLIMBBIT
	,ACTORBIT
	,WEAPONBIT
	,FIGHTBIT
	,VILLAIN
	,STAGGERED
	,TRYTAKEBIT
	,NO-CHECK-BIT
	,OPENBIT
	,TOUCHBIT
	,ONBIT!]>

<SETG ODESCS
      '["visible"
	"readable"
	"takeable"
	"a door"
	"transparent"
	"edible"
	"indescribable"
	"drinkable"
	"a container"
	"a light"
	"a victim"
	"flammable"
	"burning"
	"a tool"
	"turnable"
	"a vehicle"
	"reachable from a vehicle"
	"asleep"
	"searchable"
	"sacred"
	"tieable"
	"climbable"
	"an actor"
	"a weapon"
	"fighting"
	"a villain"
	"staggered"
	"dangerous to touch"
	"collective noun"
	"open"
	"touched"
	"turned on"
	"diggable"
	"a bunch"]>

<GDECL (OBITTYS) <UVECTOR [REST FIX]> (ODESCS) <VECTOR [REST STRING]>>

\ 

<GDECL (ACTIONS WORDS) OBLIST>

"GET-ACTIONS -- print action-info for all verbs"

<DEFINE GET-ACTIONS ("OPTIONAL" (V <>) "AUX" V1)
	#DECL ((V) <OR FALSE <UVECTOR [REST PSTRING]>>)
	<OR .V <SET V <ORDER ,ACTIONS-POBL>>>
	<SET V1 <IVECTOR <* 3 <LENGTH .V>>>>
	<MAPF <>
	      <FUNCTION (X "AUX" (A <PLOOKUP .X ,ACTIONS-POBL>) M)
		     #DECL ((X) PSTRING (A) ACTION (M) <OR FALSE VECTOR>)
		     <COND (<SET M <MEMQ .A <TOP .V1>>>
			    <PUT <SET M <BACK .M>>
				 1
				 (.X !<1 .M>)>)
			   (<PUT .V1 1 (.X)>
			    <PUT .V1 2 .A>
			    <PUT .V1 3 0>
			    <SET V1 <REST .V1 3>>)>>
	      .V>
	<MAPR <>
	      <FUNCTION (VV "AUX" (ITM <1 .VV>))
		      #DECL ((VV) VECTOR (ITM) ANY)
		      <COND (<TYPE? .ITM LIST>
			     <PUT .VV 3 <TOPACT .ITM <2 .VV>>>)>>
	      <SET V1 <TOP .V1>>>
	<SET V1 <MAPF ,VECTOR
		      <FUNCTION (X)
				<COND (<TYPE? .X LOSE> <MAPSTOP>)
				      (.X)>>
		      .V1>>
	<SORT <> .V1 3 2>
	<MAPR <>
	      <FUNCTION (VV "AUX" (ITM <1 .VV>) NM (1ST? T))
			#DECL ((VV) VECTOR (ITM) ANY (NM) PSTRING
			       (1ST?) <OR FALSE ATOM>)
			<COND (<TYPE? <SET ITM <1 .VV>> LIST>
			       <CRLF>
			       <PRINC <STRINGP <SET NM <CHTYPE <3 .VV> PSTRING>>>>
			       <PRINC " (">
			       <MAPF <>
				     <FUNCTION (X)
					       #DECL ((X) PSTRING)
					       <COND (<N==? .X .NM>
						      <OR .1ST? <PRINC " ">>
						      <SET 1ST? <>>
						      <PRINC <STRINGP .X>>)>>
				     .ITM>
			       <PRINC !\)>
			       <GET-ACTION <2 .VV>>)
			      (<TYPE? .ITM LOSE> <MAPLEAVE T>)>>
	      .V1>
	<LENGTH .V1>>
			       
<DEFINE TOPACT (LST ACT "AUX" (ASTR <3 .ACT>))
    #DECL ((LST) <LIST [REST PSTRING]> (ACT) ACTION (ASTR) STRING)
    <COND (<EMPTY? .ASTR>
	   <SET ASTR <STRING <STRINGP <1 .LST>>>>)>
    <COND (<MAPF <>
		 <FUNCTION (PSTR)
			   #DECL ((PSTR) PSTRING)
			   <COND (<COMPS <STRINGP .PSTR> .ASTR>
				  <MAPLEAVE <CHTYPE .PSTR FIX>>)>>
		 .LST>)
	  (<CHTYPE <NTH .LST <LENGTH .LST>> FIX>)>>

<DEFINE COMPS (STR1 STR2)
    #DECL ((STR1 STR2) STRING)
    <MAPF <>
	  <FUNCTION (CHR1 CHR2)
		    #DECL ((CHR1 CHR2) CHARACTER)
		    <COND (<AND <G=? <ASCII .CHR2> <ASCII !\a>>
				<L=? <ASCII .CHR2> <ASCII !\z>>>
			   <SET CHR2 <CHTYPE <- <ASCII .CHR2> 32> CHARACTER>>)>
		    <COND (<==? .CHR1 .CHR2>)
			  (<MAPLEAVE <>>)>>
	  .STR1
	  .STR2>>

"GET-ACTION -- print info for a single verb"

<DEFINE GET-ACTION (A "AUX" (OUTCHAN .OUTCHAN))
	#DECL ((A) ACTION (OUTCHAN) CHANNEL)
	<MAPF <>
	      <FUNCTION (S)
			#DECL ((S) SYNTAX)
			<CRLF>
			<COND (<STRNN .S ,SDRIVER> <COLUMN 4> <PRINC "* ">)
			      (ELSE <COLUMN 6>)>
			<PRINC <VSTR .A>>
			<PARG <SYN1 .S>>
			<PARG <SYN2 .S>>>
	      <VDECL .A>>
	<CRLF>>

"PARG -- print info for one argument of a verb"

<DEFINE PARG (VARG "AUX" (B <VBIT .VARG>) (W <VWORD .VARG>) (OUTCHAN .OUTCHAN))
	#DECL ((VARG) VARG (B W) FIX (OUTCHAN) CHANNEL)
	<COND (<AND <0? .B> <0? .W>>)
	      (ELSE
	       <COND (<VPREP .VARG>
		      <PRINC !\ >
		      <PLC <STRINGP <VPREP .VARG>>>)>
	       <PRINC " <">
	       <PVBIT .B>
	       <AND <N==? .B <VFWIM .VARG>> <PRINC !\/> <PVBIT <VFWIM .VARG>>>
	       <PVWORD .W>
	       <PRINC !\>>)>>

"PVBIT -- print info for object spec for a verb argument"

<DEFINE PVBIT (B "AUX" (OUTCHAN .OUTCHAN))
	#DECL ((B) FIX (OUTCHAN) CHANNEL)
	<COND (<==? .B -1> <PRINC "any">)
	      (<0? .B> <PRINC "?none?">)
	      (ELSE
	       <PBITS .B ,ODESCS>)>>

"PVWORD -- print verb info for a verb argument"

<DEFINE PVWORD (W "AUX" (OUTCHAN .OUTCHAN) TC (COM <>))
	#DECL ((W) FIX (OUTCHAN) CHANNEL (TC) FIX (COM) <OR FALSE ATOM>)
	<COND (<==? .W 3>)
	      (<0? .W> <PRINC ":none">)
	      (ELSE
	       <PRINC !\:>
	       <SET TC </ <CHTYPE <ANDB .W <+ ,VTBIT ,VCBIT>> FIX> 4>>
	       <SET COM T>
	       <COND (<0? .TC> <SET COM <>>)
		     (<1? .TC> <PRINC "try">)
		     (<==? .TC 2> <PRINC "have">)
		     (<==? .TC 3> <PRINC "take">)>
	       <PBITS .W ,VBDESCS .COM>)>>

<SETG VBDESCS '["adv" "room" "" "" ""]>

<GDECL (VBDESCS) <VECTOR [REST STRING]>>

"PBITS -- print bits that are on in a flagword"

<DEFINE PBITS (B BNAMES "OPTIONAL" (COM? <>) "AUX" (N 1) (C 1) (OUTCHAN .OUTCHAN) S)
       #DECL ((B C N) FIX (BNAMES) <VECTOR [REST STRING]> (COM?) <OR ATOM FALSE>
	      (OUTCHAN) CHANNEL (S) STRING)
       <REPEAT ()
	  <COND (<NOT <0? <CHTYPE <ANDB .B .N> FIX>>>
		 <COND (<NOT <EMPTY? <SET S <NTH .BNAMES .C>>>>
			<AND .COM? <PRINC ",">>
			<SET COM? T>
			<PRINC .S>)>)>
	  <COND (<==? .N *200000000000*> <RETURN>)
		(ELSE <SET N <* .N 2>> <SET C <+ .C 1>>)>>>

"PLC -- print a string in lower case"

<DEFINE PLC (STR "AUX" (OUTCHAN .OUTCHAN))
	#DECL ((STR) STRING (OUTCHAN) CHANNEL)
	<MAPF <>
	      <FUNCTION (C "AUX" (A <ASCII .C>))
		   #DECL ((C) CHARACTER (A) FIX)
		   <COND (<AND <G=? .A <ASCII !\A>>
			       <L=? .A <ASCII !\Z>>>
			  <SET A <+ .A 32>>)>
		   <PRINC <ASCII .A>>>
	      .STR>
	.STR>

\ 

"GET-VERBS -- print various verb garbage -- probably doesn't work?"

<DEFINE GET-VERBS ("OPTIONAL" (TOPL <>) "AUX" (WORDS ,WORDS-POBL) V (OUTCHAN .OUTCHAN)) 
	#DECL ((V) <UVECTOR [REST PSTRING]> (TOPL) <OR ATOM FALSE> (OUTCHAN) CHANNEL)
	<SET V <ORDER .WORDS>>
	<MAPF <>
	      <FUNCTION (X "AUX" (A <PLOOKUP .X .WORDS>)) 
		      #DECL ((X) PSTRING (A) ANY)
		      <COND (<AND <TYPE? .A VERB>
				  <OR <NOT .TOPL> <==? .X <1 .A>>>>
			     <PRINC <STRINGP .X>>
			     <COLUMN 10>
			     <COND (<==? <1 .A> .X> <PRINC "Top Level">)
				   (<PRINC "= "> <PRINC <STRINGP <1 .A>>>)>
			     <CRLF>)>>
	      .V>
	<LENGTH .V>>

\ 

"GET-WORDS -- print various garbage about WORDS"

<DEFINE GET-WORDS ("AUX" (WORDS ,WORDS-POBL) V (LSTNAME <>) (OUTCHAN .OUTCHAN)) 
   #DECL ((V) UVECTOR (LSTNAME) <OR PSTRING FALSE> (OUTCHAN) CHANNEL)
   <SET V <ORDER .WORDS>>
   <MAPR <>
    <FUNCTION (Y "AUX" Z (X <1 .Y>)) 
	    #DECL ((X) PSTRING (Y) UVECTOR)
	    <COND
	     (<N==? .X .LSTNAME>
	      <PRINC <STRINGP .X>>
	      <SET LSTNAME .X>
	      <COLUMN 10>
	      <COND (<SET Z <PLOOKUP .X .WORDS>>
		     <COND (<TYPE? .Z VERB>
			    <PRINC "ACTION">
			    <COLUMN 24>
			    <COND (<==? <1 .Z> .X> <PRINC "Top Level">)
				  (<PRINC "= "> <PRINC <STRINGP <1 .Z>>>)>)
			   (<TYPE? .Z BUZZ> <PRINC "BUZZ WORD">)
			   (<PRIN1 <TYPE .Z>>)>)>
	      <CRLF>)>>
    .V>
   </ <LENGTH .V> 2>>

\ 

"ORDER -- sorter for uvectors of atoms"

<DEFINE ORDER (O "AUX" (L ()) O1 S S1 S2 V1 V2 SP1 SP2) 
   #DECL ((O) <OR <UVECTOR [REST PSTRING]> POBLIST> (S S1 S2) UVECTOR
	  (SP1 SP2) STRING (V1 V2) PSTRING (O1) <<PRIMTYPE UVECTOR>
						 [REST LIST]>
	  (L) <LIST [REST PSTRING ANY]>)
   <COND (<TYPE? .O POBLIST>
	  <SET O1 .O>
	  <SET S
	       <MAPF ,UVECTOR
		     <FUNCTION ("AUX" Y) 
			     <COND (<EMPTY? .L>
				    <COND (<EMPTY? .O1> <MAPSTOP>)
					  (T
					   <SET L <1 .O1>>
					   <SET O1 <REST .O1>>)>
				    <MAPRET>)
				   (<SET Y <1 .L>>
				    <SET L <REST .L 2>>
				    <MAPRET .Y>)>>>>)
	 (<SET S .O>)>
   <SET S1 <SET S2 .S>>
   <COND (<LENGTH? .S 1> .S)
	 (ELSE
	  <REPEAT ()
		  <COND (<EMPTY? .S2>
			 <COND (<EMPTY? <SET S1 <REST .S1>>> <RETURN .S>)
			       (<SET S2 <REST .S1>> <AGAIN>)>)>
		  <SET V1 <1 .S1>>
		  <SET V2 <1 .S2>>
		  <COND (<G? <CHTYPE .V1 FIX> <CHTYPE .V2 FIX>>
			 <PUT .S1 1 .V2>
			 <PUT .S2 1 .V1>)>
		  <SET S2 <REST .S2>>>)>>

"OORDER -- order a list by an offset in each element"

<DEFINE OORDER (S OFFS "AUX" S1 S2 V1 V2 SP1 SP2)
	#DECL ((S S1 S2) <UVECTOR [REST <PRIMTYPE VECTOR>]> (V1 V2) <PRIMTYPE VECTOR>
	       (OFFS) FIX (SP1 SP2) STRING)
	<SET S1 <SET S2 .S>>
	<COND (<LENGTH? .S 1> .S)
	      (ELSE
	       <REPEAT ()
		       <COND (<EMPTY? .S2>
			      <COND (<EMPTY? <SET S1 <REST .S1>>> <RETURN .S>)
				    (<SET S2 <REST .S1>> <AGAIN>)>)>
		       <SET V1 <1 .S1>>
		       <SET V2 <1 .S2>>
		       <SET SP1 <NTH .V1 .OFFS>>
		       <SET SP2 <NTH .V2 .OFFS>>
		       <COND (<ALPH .SP1 .SP2>
			      <PUT .S1 1 .V2>
			      <PUT .S2 1 .V1>)>
		       <SET S2 <REST .S2>>>)>>

<DEFINE ALPH (S1 S2 "AUX" (L1 <LENGTH .S1>) (L2 <LENGTH .S2>))
	#DECL ((S1 S2) STRING (L1 L2) FIX)
	<COND (<AND <0? .L1> <NOT <0? .L2>>> <>)
	      (<AND <0? .L2> <NOT <0? .L1>>> T)
	      (ELSE
	<MAPR <>
	      <FUNCTION (S1 S2 "AUX" (C1 <ASCII <1 .S1>>) (C2 <ASCII <1 .S2>>)
			 (L1 <LENGTH .S1>) (L2 <LENGTH .S2>))
		   #DECL ((S1 S2) STRING (C1 C2 L1 L2) FIX)
		   <COND (<AND <G=? .C1 <ASCII !\a>> <L=? .C1 <ASCII !\z>>>
			  <SET C1 <- .C1 32>>)>
		   <COND (<AND <G=? .C2 <ASCII !\a>> <L=? .C2 <ASCII !\z>>>
			  <SET C2 <- .C2 32>>)>
		   <COND (<==? .C1 .C2>
			  <COND (<AND <0? .L1> <NOT <0? .L2>>> <MAPLEAVE <>>)
				(<AND <0? .L2> <NOT <0? .L1>>> <MAPLEAVE T>)>)
			 (<G? .C1 .C2>
			  <MAPLEAVE T>)
			 (<L? .C1 .C2>
			  <MAPLEAVE <>>)>>
	      .S1 .S2>)>>