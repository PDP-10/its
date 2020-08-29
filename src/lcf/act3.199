; "SUBTITLE TOMB OF THE UNKNOWN IMPLEMENTER"

<DEFINE COKE-BOTTLES ()
  <COND (<VERB? "THROW" "MUNG">
	 <TELL 
"Congratulations!  You've managed to break all those bottles.
Fortunately for your feet, they were made of magic glass and disappear
immediately." ,LONG-TELL1>
	 <COND (<==? <PRSI> <SFIND-OBJ "COKES">>
		<REMOVE-OBJECT <PRSI>>
		<TELL "Somehow, the "  ,POST-CRLF <ODESC2 <PRSO>>
		      " managed to disappear as well.">)>
	 <REMOVE-OBJECT <PRSO>>)>>

<DEFINE HEAD-FUNCTION ("AUX" (NL ()) (LCASE <SFIND-OBJ "LCASE">))
  #DECL ((NL) <LIST [REST OBJECT]> (LCASE) OBJECT)
  <COND (<VERB? "HELLO">
	 <TELL "The implementers are dead; therefore they do not respond.">)
	(<VERB? "DESTR" "KICK" "POKE" "ATTAC" "KILL" "RUB" "OPEN" "TAKE" "BURN">
	 <TELL ,HEADSTR1 ,LONG-TELL1>
	 <SET NL <ROB-ADV ,WINNER .NL>>
	 <SET NL <ROB-ROOM ,HERE .NL 100>>
	 <COND (<NOT <EMPTY? .NL>>
		<OR <OROOM .LCASE> <INSERT-OBJECT .LCASE <SFIND-ROOM "LROOM">>>
		<PUT .LCASE ,OCONTENTS (!<OCONTENTS .LCASE> !.NL)>)>
	 <JIGS-UP ,HEADSTR2>
	 T)>>

<SETG THEN 0>

\ 

;"SUBTITLE A DROP IN THE BUCKET"

<SETG BUCKET-TOP!-FLAG <>>

<DEFINE BUCKET ("OPTIONAL" (ARG <>)
		"AUX" (W <SFIND-OBJ "WATER">) (BUCK <SFIND-OBJ "BUCKE">))
	#DECL ((ARG) <OR FALSE ATOM> (W BUCK) OBJECT)
	<COND (<==? .ARG READ-IN> <>)
	      (<AND <VERB? "C-INT">
		    <COND (<MEMQ .W <OCONTENTS .BUCK>>
			   <REMOVE-OBJECT .W>
			   <>)
			  (T)>>)
	      (<AND <VERB? "BURN">
		    <==? <PRSO> .BUCK>>
	       <TELL
"The bucket is fireproof, and won't burn.">)
	      (<VERB? "KICK">
	       <JIGS-UP "If you insist.">
	       T)
	      (<==? .ARG READ-OUT>
	       <COND (<AND <==? <OCAN .W> .BUCK> <NOT ,BUCKET-TOP!-FLAG>>
		      <TELL "The bucket rises and comes to a stop.">
		      <SETG BUCKET-TOP!-FLAG T>
		      <PASS-THE-BUCKET <SFIND-ROOM "TWELL"> .BUCK>
		      <CLOCK-INT ,BCKIN 100>
		      <>)
		     (<AND ,BUCKET-TOP!-FLAG <N==? <OCAN .W> .BUCK>>
		      <TELL "The bucket descends and comes to a stop.">
		      <SETG BUCKET-TOP!-FLAG <>>
		      <PASS-THE-BUCKET <SFIND-ROOM "BWELL"> .BUCK>)>)>>

<DEFINE PASS-THE-BUCKET (R B "AUX" (PRSO <PRSO>) (PRSVEC ,PRSVEC))
    #DECL ((R) ROOM (B) OBJECT (PRSVEC) VECTOR (PRSO) OBJECT)
    <PUT .PRSVEC 2 <>>
    <REMOVE-OBJECT .B>
    <INSERT-OBJECT .B .R>
    <COND (<==? <AVEHICLE ,WINNER> .B>
	   <GOTO .R>
    	   <ROOM-INFO>)>
    <PUT .PRSVEC 2 .PRSO>>

\ 

;"SUBTITLE CHOMPERS IN WONDERLAND"

<DEFINE EATME-FUNCTION ("AUX" R C (HERE ,HERE))
    #DECL ((C) OBJECT (HERE R) ROOM)
    <COND (<AND <VERB? "EAT">
		<==? <PRSO> <SET C <SFIND-OBJ "ECAKE">>>
		<==? .HERE <SFIND-ROOM "ALICE">>>
	   <TELL 
"Suddenly, the room appears to have become very large.">
	   <REMOVE-OBJECT .C>
	   <SET R <SFIND-ROOM "ALISM">>
	   <TRZ <SFIND-OBJ "ROBOT"> ,OVISON>
	   <PUT .R ,ROBJS <ROBJS .HERE>>
	   <MAPF <>
		 <FUNCTION (X) #DECL ((X) OBJECT)
			    <OSIZE .X <* 64 <OSIZE .X>>>
			    <PUT .X ,OROOM .R>>
		 <ROBJS .HERE>>
	   <GOTO .R>)>>

<DEFINE CAKE-FUNCTION ("AUX" (RICE <SFIND-OBJ "RDICE">) (OICE <SFIND-OBJ "ORICE">)
			     (BICE <SFIND-OBJ "BLICE">) (HERE ,HERE) R)
	#DECL ((RICE OICE BICE) OBJECT (HERE R) ROOM)
	<COND (<VERB? "READ">
	       <COND (<NOT <EMPTY? <PRSI>>>
		      <COND (<==? <PRSI> <SFIND-OBJ "BOTTL">>
			     <TELL 
"The letters appear larger, but still are too small to be read.">)
			    (<==? <PRSI> <SFIND-OBJ "FLASK">>
			     <TELL "The icing, now visible, says '"
				   1
				   <COND (<==? <PRSO> .RICE> "Evaporate")
					 (<==? <PRSO> .OICE> "Explode")
					 ("Enlarge")>
				   "'.">)
			    (<TELL "You can't see through that!">)>)
		     (<TELL 
"The only writing legible is a capital E.  The rest is too small to
be clearly visible.">)>)
	      (<AND <VERB? "EAT"> <MEMBER "ALI" <STRINGP <RID .HERE>>>>
	       <COND (<==? <PRSO> .OICE>
		      <REMOVE-OBJECT <PRSO>>
		      <ICEBOOM>)
		     (<==? <PRSO> .BICE>
		      <REMOVE-OBJECT <PRSO>>
		      <TELL "The room around you seems to be getting smaller.">
		      <COND (<==? .HERE <SFIND-ROOM "ALISM">>
			     <SET R <SFIND-ROOM "ALICE">>
			     <TRO <SFIND-OBJ "ROBOT"> ,OVISON>
			     <PUT .R ,ROBJS <ROBJS .HERE>>
			     <TRZ <SFIND-OBJ "POSTS"> ,OVISON>
			     <MAPF <>
				   <FUNCTION (X) #DECL ((X) OBJECT)
					     <PUT .X ,OROOM .R>
					     <OSIZE .X </ <OSIZE .X> 64>>>
				   <ROBJS .HERE>>
			     <GOTO .R>)
			    (<JIGS-UP ,CRUSHED>)>)>)
	      (<AND <VERB? "THROW">
		    <==? <PRSO> .OICE>
		    <MEMBER "ALI" <STRINGP <RID .HERE>>>>
	       <REMOVE-OBJECT <PRSO>>
	       <ICEBOOM>)
	      (<AND <VERB? "THROW">
		    <==? <PRSO> .RICE>
		    <==? <PRSI> <SFIND-OBJ "POOL">>>
	       <REMOVE-OBJECT <PRSI>>
	       <TELL 
"The pool of water evaporates, revealing a tin of rare spices.">
	       <TRO <SFIND-OBJ "SAFFR"> ,OVISON>)>>

<DEFINE FLASK-FUNCTION ()
    <COND (<VERB? "OPEN">
	   <MUNG-ROOM ,HERE "Noxious vapors prevent your entry.">
	   <JIGS-UP ,VAPORS>)
	  (<VERB? "MUNG" "THROW">
	   <TELL "The flask breaks into pieces.">
	   <TRZ <PRSO> ,OVISON>
	   <JIGS-UP ,VAPORS T>)>>

<DEFINE PLEAK ()
    <COND (<VERB? "TAKE">
	   <TELL <PICK-ONE ,YUKS>>)
	  (<VERB? "PLUG">
	   <TELL "The leak is too high above you to reach.">)>>

<DEFINE ICEBOOM () 
    <MUNG-ROOM ,HERE ,ICEMUNG>
    <JIGS-UP ,ICEBLAST>>

<DEFINE MAGNET-ROOM ()
	<COND (<VERB? "LOOK">
	       <TELL 
"You are in a room with a low ceiling which is circular in shape. 
There are exits to the east and the southeast.">)
	      (<AND <VERB? "GO-IN"> ,CAROUSEL-FLIP!-FLAG>
	       <COND (,CAROUSEL-ZOOM!-FLAG
		      <JIGS-UP <COND (<==? ,PLAYER ,WINNER> ,SPINDIZZY)
				     (ELSE ,SPINROBOT)>>)
		     (<TELL 
"As you enter, your compass starts spinning wildly.">
		      <>)>)>>

<DEFINE MAGNET-ROOM-EXIT ("AUX" (PV ,PRSVEC) (DIR <2 .PV>))
	#DECL ((DIR) DIRECTION (PV) <VECTOR [3 ANY]>)
	<COND (,CAROUSEL-FLIP!-FLAG
	       <TELL "You cannot get your bearings...">
	       <COND (<PROB 50>
		      <SFIND-ROOM "CMACH">)
		     (<SFIND-ROOM "ALICE">)>)
	      (<==? .DIR <FIND-DIR "E">>
	       <SFIND-ROOM "CMACH">)
	      (<OR <==? .DIR <FIND-DIR "SE">>
		   <==? .DIR <FIND-DIR "OUT">>>
	       <SFIND-ROOM "ALICE">)>> 

<DEFINE CMACH-ROOM ()
    <COND (<VERB? "LOOK">
	   <TELL ,CMACH-DESC ,LONG-TELL1>)>>
	  
<SETG CAROUSEL-ZOOM!-FLAG <>>

<SETG CAROUSEL-FLIP!-FLAG <>>

<DEFINE BUTTONS ("AUX" I) 
	#DECL ((I) OBJECT)
	<COND (<VERB? "PUSH">
	       <COND (<==? ,WINNER ,PLAYER>
		      <JIGS-UP 
"There is a giant spark and you are fried to a crisp.">)
		     (<==? <PRSO> <SFIND-OBJ "SQBUT">>
		      <COND (,CAROUSEL-ZOOM!-FLAG
			     <TELL "Nothing seems to happen.">)
			    (<SETG CAROUSEL-ZOOM!-FLAG T>
		      	     <TELL "The whirring increases in intensity slightly.">)>)
		     (<==? <PRSO> <SFIND-OBJ "RNBUT">>
		      <COND (,CAROUSEL-ZOOM!-FLAG
			     <SETG CAROUSEL-ZOOM!-FLAG <>>
		      	     <TELL "The whirring decreases in intensity slightly.">)
			    (<TELL "Nothing seems to happen.">)>)
		     (<==? <PRSO> <SFIND-OBJ "TRBUT">>
		      <SETG CAROUSEL-FLIP!-FLAG <NOT ,CAROUSEL-FLIP!-FLAG>>
		      <COND (<==? <OROOM <SET I <SFIND-OBJ "IRBOX">>>
				  <SFIND-ROOM "CAROU">>
			     <TELL
"A dull thump is heard in the distance.">
			     <TRC .I ,OVISON>
			     <COND (<TRNN .I ,OVISON>
				    <RTRZ <SFIND-ROOM "CAROU"> ,RSEENBIT>)>
			     T)
			    (<TELL "Click.">)>)>)>>

<SETG CAGE-SOLVE!-FLAG <>>

<DEFINE SPHERE-FUNCTION ("AUX" (R <SFIND-OBJ "ROBOT">) C FL RACT)
	#DECL ((C) ROOM (R) OBJECT (FL) <OR ATOM FALSE> (RACT) ADV)
	<SET FL <AND <NOT ,CAGE-SOLVE!-FLAG> <VERB? "TAKE">>>
	<COND (<AND .FL <==? ,PLAYER ,WINNER>>
	       <TELL ,CAGESTR ,LONG-TELL1>
	       <COND (<==? <OROOM .R> ,HERE>
		      <GOTO <SET C <SFIND-ROOM "CAGED">>>
		      <REMOVE-OBJECT .R>
		      <INSERT-OBJECT .R .C>
		      <PUT <SET RACT <OACTOR .R>> ,AROOM .C>
		      <TRO .R ,NDESCBIT>
		      <SETG SPHERE-CLOCK <CLOCK-INT ,SPHIN 10>>
		      T)
		     (ELSE
		      <TRZ <SFIND-OBJ "SPHER"> ,OVISON>
		      <MUNG-ROOM <SFIND-ROOM "CAGER">
				 "You are stopped by a cloud of poisonous gas.">
		      <JIGS-UP ,POISON T>)>)
	      (.FL
	       <TRZ <SFIND-OBJ "SPHER"> ,OVISON>
	       <JIGS-UP ,ROBOT-CRUSH>
	       <REMOVE-OBJECT .R>
	       <TRZ <PRSO> ,OVISON>
	       <INSERT-OBJECT <SFIND-OBJ "RCAGE"> ,HERE>
	       T)
	      (<VERB? "C-INT">
	       <MUNG-ROOM <SFIND-ROOM "CAGER">
			  "You are stopped by a cloud of poisonous gas.">
	       <JIGS-UP ,POISON T>)
	      (<VERB? "LKIN">
	       <PALANTIR>)>>

<DEFINE CAGED-ROOM ()
    <COND (,CAGE-SOLVE!-FLAG <SETG HERE <SFIND-ROOM "CAGER">>)>>

<GDECL (SPHERE-CLOCK) CEVENT (ROBOT-ACTIONS) <UVECTOR [REST VERB]>>

<DEFINE ROBOT-ACTOR ("AUX" C CAGE (R <SFIND-OBJ "ROBOT">) RACT) 
	#DECL ((C) ROOM (CAGE) OBJECT (R) OBJECT (RACT) ADV)
	<COND (<AND <VERB? "RAISE"> <==? <PRSO> <SFIND-OBJ "CAGE">>>
	       <TELL "The cage shakes and is hurled across the room.">
	       <CLOCK-DISABLE ,SPHERE-CLOCK>
	       <SETG WINNER ,PLAYER>
	       <GOTO <SET C <SFIND-ROOM "CAGER">>>
	       <INSERT-OBJECT <SET CAGE <SFIND-OBJ "CAGE">> .C>
	       <TRO .CAGE ,TAKEBIT>
	       <TRZ .CAGE ,NDESCBIT>
	       <TRZ .R ,NDESCBIT>
	       <TRO <SFIND-OBJ "SPHER"> ,TAKEBIT>
	       <REMOVE-OBJECT .R>
	       <INSERT-OBJECT .R .C>
	       <PUT <SET RACT <OACTOR .R>> ,AROOM .C>
	       <SETG WINNER .RACT>
	       <SETG CAGE-SOLVE!-FLAG T>)
	      (<VERB? "EAT" "DRINK">
	       <TELL
"\"I am sorry but that action is difficult for a being with no mouth.\"">)
	      (<VERB? "READ">
	       <TELL
"\"My vision is not sufficiently acute to read such small type.\"">)
	      (<MEMQ <PRSA> ,ROBOT-ACTIONS> <TELL "\"Whirr, buzz, click!\""> <>)
	      (<TELL 
"\"I am only a stupid robot and cannot perform that command.\"">)>>

<DEFINE CRETIN ("AUX" (ME ,PLAYER))
    #DECL ((ME) ADV)
    <COND (<AND <VERB? "GIVE"> <NOT <TRNN <PRSO> ,NO-CHECK-BIT>>>
	   <REMOVE-OBJECT <PRSO>>
	   <PUT .ME ,AOBJS (<PRSO> !<AOBJS .ME>)>
	   <TELL "Done.">)
	  (<VERB? "KILL" "MUNG">
	   <JIGS-UP 
"If you insist.... Poof, you're dead!">)
	  (<VERB? "TAKE">
	   <TELL "How romantic!">)>>

<DEFINE ROBOT-FUNCTION ("AUX" AA RR)
	#DECL ((AA) ADV (RR) OBJECT)
	<COND (<VERB? "GIVE">
	       <SET AA <OACTOR <PRSI>>>
	       <REMOVE-OBJECT <PRSO>>
	       <PUT .AA ,AOBJS (<PRSO> !<AOBJS .AA>)>
	       <TELL "The robot gladly takes the "
		     1
		     <ODESC2 <PRSO>>
		     "
and nods his head-like appendage in thanks.">)
	      (<AND <VERB? "THROW" "MUNG">
		    <OR <==? <PRSI> <SET RR <FIND-OBJ "ROBOT">>>
			<==? <PRSO> .RR>>>
	       <TELL ,ROBOTDIE ,LONG-TELL1>
	       <REMOVE-OBJECT <COND (<VERB? "THROW"> <PRSI>) (<PRSO>)>>)>> 

\ 

;"SUBTITLE MORE RANDOM VERBS"

<DEFINE KNOCK ()
    <COND (<OBJECT-ACTION>)
	  (<MEMQ <PSTRING "DOOR"> <ONAMES <PRSO>>>
	   <TELL "I don't think that anybody's home.">)
	  (<TELL "Why knock on a " 1 <ODESC2 <PRSO>> "?">)>>

<DEFINE CHOMP ()
    <TELL "I don't know how to do that.  I win in all cases!">>

<DEFINE FROBOZZ ()
    <TELL "The FROBOZZ Corporation created, owns, and operates this dungeon.">>

<DEFINE WIN ()
    <TELL "Naturally!">>

<DEFINE YELL ()
    <TELL "Aaaarrrrrrrrgggggggggggggghhhhhhhhhhhhhh!">>

\ 

;"SUBTITLE BANK OF ZORK"

<GDECL (SCOL-ROOM SCOL-ACTIVE)
       <OR FALSE ROOM>
       (SCOL-ROOMS)
       <VECTOR [REST DIRECTION ROOM]>
       (SCOL-WALLS)
       <VECTOR [REST ROOM OBJECT ROOM]>>

<SETG BANK-SOLVE!-FLAG <>>

<DEFINE BILLS-OBJECT ()
	<SETG BANK-SOLVE!-FLAG T>
	<COND (<VERB? "BURN">
	       <TELL "Nothing like having money to burn!">
	       <>)
	      (<VERB? "EAT">
	       <TELL "Talk about eating rich foods!">)>>
	      
<DEFINE BKLEAVEE ("OPTIONAL" (RM <SFIND-ROOM "BKTE">))
    #DECL ((RM) ROOM)
    <COND (<OR <HELD? <SFIND-OBJ "BILLS">>
	       <HELD? <SFIND-OBJ "PORTR">>>
	   <>)
	  (.RM)>>

<DEFINE BKLEAVEW ()
    <BKLEAVEE <SFIND-ROOM "BKTW">>>

<DEFINE BKBOX-ROOM ("AUX" M) 
	#DECL ((M) <VECTOR [REST DIRECTION ROOM]>)
	<COND (<VERB? "GO-IN">
	       <SETG SCOL-ROOM <2 <SET M <MEMQ ,FROMDIR ,SCOL-ROOMS>>>>)>>

<DEFINE TELLER-ROOM ()
    <COND (<VERB? "LOOK">
	   <TELL ,TELLER-DESC
		 1
		 <COND (<==? ,HERE <SFIND-ROOM "BKTW">>
		  	"west")
		       ("east")>
	         " side of room, above an open door, is a sign reading 

		BANK PERSONNEL ONLY
">)>>

<DEFINE SCOL-OBJECT ("OPTIONAL" (OBJ <>))
    #DECL ((OBJ) <OR FALSE OBJECT>)
    <COND (<VERB? "PUSH" "MOVE" "TAKE" "RUB">
	   <TELL "As you try, your hand seems to go through it.">)
	  (<VERB? "POKE" "ATTAC" "KILL">
	   <TELL "The " 1 <ODESC2 <PRSI>> " goes through it.">)
	  (<AND <VERB? "THROW">
		<OR <==? <SFIND-OBJ "SCOL"> <PRSI>>
		    <==? .OBJ <PRSI>>>>
	   <THROUGH <PRSO>>)>>

<DEFINE GET-WALL (RM)
    #DECL ((RM) ROOM)
    <REPEAT ((W ,SCOL-WALLS))
	#DECL ((W) <VECTOR [REST ROOM OBJECT ROOM]>)
	<COND (<==? <1 .W> .RM>
	       <RETURN .W>)
	      (<SET W <REST .W 3>>)>>>

<DEFINE SCOLWALL ("AUX" (HERE ,HERE) M)
    #DECL ((HERE) ROOM (M) <VECTOR [REST ROOM OBJECT ROOM]>)
    <COND (<AND <==? .HERE ,SCOL-ACTIVE>
		<==? <PRSO> <2 <SET M <GET-WALL .HERE>>>>>
	   <SCOL-OBJECT <PRSO>>)>>

<DEFINE ENTER ("AUX" (PV ,PRSVEC))
    #DECL ((PV) VECTOR)
    <PUT .PV 2 <FIND-DIR "ENTER">>
    <PUT .PV 1 <FIND-VERB "WALK">>
    <WALK>>

<DEFINE THROUGH ("OPTIONAL" (OBJ <>)
		 "AUX" (HERE ,HERE) (BOX <SFIND-ROOM "BKBOX">) (SCRM ,SCOL-ROOM)
		       M (PRSVEC ,PRSVEC))
	#DECL ((HERE BOX) ROOM (SCRM) <OR FALSE ROOM>
	       (M) <VECTOR [REST ROOM OBJECT ROOM]> (OBJ) <OR OBJECT FALSE>)
	<COND (<AND <NOT .OBJ>
		    <OBJECT-ACTION>>)
	      (<AND <NOT .OBJ>
		    <TRNN <PRSO> ,VEHBIT>>
	       <PERFORM BOARD <FIND-VERB "BOARD"> <PRSO>>)
	      (<OR <AND <OR .OBJ <==? <PRSO> <SFIND-OBJ "SCOL">>> .SCRM>
		   <AND <==? .HERE .BOX> <==? <PRSO> <SFIND-OBJ "WNORT">> .SCRM>>
	       <SETG SCOL-ACTIVE .SCRM>
	       <PUT .PRSVEC 2 <>>
	       <COND (.OBJ <SCOL-OBJ .OBJ 0 .SCRM>) (<SCOL-THROUGH 6 .SCRM>)>)
	      (<AND <==? .HERE ,SCOL-ACTIVE>
		    <==? <PRSO> <2 <SET M <GET-WALL .HERE>>>>>
	       <SETG SCOL-ROOM <3 .M>>
	       <PUT .PRSVEC 2 <CHTYPE <1 <OADJS <PRSO>>> DIRECTION>>
	       <COND (.OBJ <SCOL-OBJ .OBJ 0 .BOX>) (<SCOL-THROUGH 0 .BOX>)>)
	      (<AND <NOT .OBJ> <NOT <TRNN <PRSO> ,TAKEBIT>>>
	       <COND (<==? <PRSO> <SFIND-OBJ "SCOL">>
		      <TELL 
"You can't go more than part way through the curtain.">)
		     (<OBJECT-ACTION>)
		     (<TELL "You hit your head against the "
			    1
			    <ODESC2 <PRSO>>
			    " as you attempt this feat.">)>)
	      (.OBJ <TELL "You can't do that!">)
	      (<NOT <OROOM <PRSO>>>
	       <TELL "That would involve quite a contortion!">)
	      (<TELL <PICK-ONE ,YUKS>>)>>

<DEFINE SCOL-OBJ (OBJ CINT RM)
    #DECL ((OBJ) OBJECT (CINT) FIX (RM) ROOM)
    <CLOCK-INT ,SCLIN .CINT>
    <REMOVE-OBJECT .OBJ>
    <INSERT-OBJECT .OBJ .RM>
    <COND (<==? .RM <SFIND-ROOM "BKBOX">>
	   <TELL "The " 1 <ODESC2 .OBJ> " passes through the wall and vanishes.">)
	  (<TELL "The curtain dims slightly as the "
		 1
		 <ODESC2 .OBJ>
		 " passes through.">
	   <SETG SCOL-ROOM <>>
	   T)>>

<DEFINE SCOL-THROUGH (CINT RM)
    #DECL ((CINT) FIX (RM) ROOM)
    <CLOCK-INT ,SCLIN .CINT>
    <GOTO .RM>
    <TELL ,THROUGH-DESC>
    <ROOM-INFO>>

<PSETG THROUGH-DESC "You feel somewhat disoriented as you pass through...">

<DEFINE SCOL-CLOCK ("AUX" (HERE ,HERE))
    #DECL ((HERE) ROOM)
    <SETG SCOL-ACTIVE <SFIND-ROOM "FCHMP">>
    <COND (<==? .HERE <SFIND-ROOM "BKVAU">>
	   <JIGS-UP ,ALARM-VOICE>)
	  (<==? .HERE <SFIND-ROOM "BKTWI">>
	   <COND (,ZGNOME-FLAG!-FLAG)
		 (ELSE
		  <CLOCK-INT ,ZGNIN 5>
		  <SETG ZGNOME-FLAG!-FLAG T>)>)>>

<SETG ZGNOME-FLAG!-FLAG <>>

<DEFINE ZGNOME-INIT ()
    <COND (<VERB? "C-INT">
	   <COND (<==? ,HERE <SFIND-ROOM "BKTWI">>
		  <CLOCK-INT ,ZGLIN 12>
		  <TELL ,ZGNOME-DESC ,LONG-TELL1>
		  <INSERT-OBJECT <SFIND-OBJ "ZGNOM"> ,HERE>)>)>>

<DEFINE ZGNOME-FUNCTION ("AUX" (GNOME <SFIND-OBJ "ZGNOM">) BRICK)
    #DECL ((GNOME BRICK) OBJECT)
    <COND (<VERB? "GIVE" "THROW">
	   <COND (<N==? <OTVAL <PRSO>> 0>
		  <TELL 
"The gnome carefully places the " ,LONG-TELL1 <ODESC2 <PRSO>>  " in the
deposit box.  'Let me show you the way out,' he says, making it clear
he will be pleased to see the last of you.  Then, you are momentarily
disoriented, and when you recover you are back at the Bank Entrance.">
		  <REMOVE-OBJECT .GNOME>
		  <REMOVE-OBJECT <PRSO>>
		  <CLOCK-DISABLE ,ZGLIN>
		  <GOTO <SFIND-ROOM "BKENT">>)
		 (<BOMB? <PRSO>>
		  <REMOVE-OBJECT .GNOME>
		  <OR <OROOM <SET BRICK <SFIND-OBJ "BRICK">>>
		      <INSERT-OBJECT .BRICK ,HERE>>
		  <CLOCK-DISABLE ,ZGLIN>
		  <CLOCK-DISABLE ,ZGNIN>
		  <TELL ,ZGNOME-POP-1>)
		 (<TELL ,ZGNOME-POP>
		  <REMOVE-OBJECT <PRSO>>)>)
	  (<VERB? "C-INT">
	   <COND (<==? ,HERE <SFIND-ROOM "BKTWI">>
		  <TELL ,ZGNOME-BYE ,LONG-TELL1>)>
	   <REMOVE-OBJECT .GNOME>)
	  (<VERB? "KILL" "ATTAC" "POKE">
	   <TELL
"The gnome says 'Well, I never...' and disappears with a snap of his
fingers, leaving you alone.">
	   <REMOVE-OBJECT .GNOME>
	   <CLOCK-DISABLE ,ZGLIN>)
	  (<TELL 
"The gnome appears increasingly impatient.">)>>

<DEFINE HELD? (OBJ "AUX" (CAN <OCAN .OBJ>))
    #DECL ((OBJ) OBJECT (CAN) <OR FALSE OBJECT>)
    <OR <MEMQ .OBJ <AOBJS ,WINNER>>
	<AND .CAN <HELD? .CAN>>>>

\ 

;"SUBTITLE TOITY POIPLE BOIDS A CHOIPIN' AN' A BOIPIN' ... "

<DEFINE TREE-ROOM ("AUX" (HERE ,HERE) ROBJS EGG TTREE NEST
			 (FORE3 <SFIND-ROOM "FORE3">) (OUTCHAN ,OUTCHAN))
	#DECL ((HERE) ROOM (ROBJS) <LIST [REST OBJECT]> (TTREE NEST EGG) OBJECT
	       (OUTCHAN) CHANNEL)
	<COND (<VERB? "LOOK">
	       <TELL ,TREE-DESC>
	       <COND (<G? <LENGTH <ROBJS .FORE3>> 1>
		      <TELL "On the ground below you can see:  " 0>
		      <REMOVE-OBJECT <SFIND-OBJ "FTREE">>
		      <MAPR <>
			    <FUNCTION (Y) 
				    #DECL ((Y) <LIST [REST OBJECT]>)
				    <PRINC "a ">
				    <PRINC <ODESC2 <1 .Y>>>
				    <COND (<G? <LENGTH .Y> 2> <PRINC ", ">)
					  (<==? <LENGTH .Y> 2>
					   <PRINC ", and ">)>>
			    <ROBJS .FORE3>>
		      <TELL ".">
		      <INSERT-OBJECT <SFIND-OBJ "FTREE"> .FORE3>)>)
	      (<VERB? "GO-IN"> <CLOCK-ENABLE <CLOCK-INT ,FORIN -1>>)
	      (<AND <NOT <EMPTY? <SET ROBJS <ROBJS .HERE>>>> <VERB? "DROP">>
	       <SET TTREE <SFIND-OBJ "TTREE">>
	       <SET NEST <SFIND-OBJ "NEST">>
	       <SET EGG <SFIND-OBJ "EGG">>
	       <SET FORE3 <SFIND-ROOM "FORE3">>
	       <MAPF <>
		     <FUNCTION (X) 
			     #DECL ((X) OBJECT)
			     <COND (<==? .X .EGG>
				    <REMOVE-OBJECT .EGG>
				    <SET EGG <SFIND-OBJ "BEGG">>
				    <TELL 
"The egg falls to the ground, and is seriously damaged.">
				    <OTVAL <SFIND-OBJ "BCANA"> 1>
				    <OTVAL .EGG 2>
				    <INSERT-OBJECT .EGG .FORE3>)
				   (<OR <==? .X .TTREE> <==? .X .NEST>>)
				   (<REMOVE-OBJECT .X>
				    <INSERT-OBJECT .X .FORE3>
				    <TELL "The "
					  1
					  <ODESC2 .X>
					  " falls to the ground.">)>>
		     .ROBJS>)>>

<DEFINE EGG-OBJECT ("AUX" (BEGG <SFIND-OBJ "BEGG">) (EGG <SFIND-OBJ "EGG">)) 
	#DECL ((BEGG) OBJECT)
	<COND (<AND <VERB? "OPEN">
		    <==? <PRSO> .EGG>>
	       <COND (<TRNN <PRSO> ,OPENBIT> <TELL "The egg is already open.">)
		     (<EMPTY? <PRSI>>
		      <TELL "There is no obvious way to open the egg.">)
		     (<==? <PRSI> <SFIND-OBJ "HANDS">>
		      <TELL "I doubt you could do that without damaging it.">)
		     (<TRNN <PRSI> <+ ,WEAPONBIT ,TOOLBIT>>
		      <TELL 
"The egg is now open, but the clumsiness of your attempt has seriously
compromised its esthetic appeal.">
		      <BAD-EGG .BEGG>)
		     (<TRNN <PRSO> ,FIGHTBIT>
		      <TELL "Not to say that using the "
			    1
			    <ODESC2 <PRSI>>
			    " isn't original too...">)
		     (<TELL "The concept of using a "
			    1
			    <ODESC2 <PRSI>>
			    " is certainly original.">
		      <TRO <PRSO> ,FIGHTBIT>)>)
	      (<VERB? "OPEN" "POKE" "MUNG">
	       <TELL
"Your rather indelicate handling of the egg has caused it some damage.
The egg is now open.">
	       <BAD-EGG .BEGG>)>>

<DEFINE BAD-EGG (BEGG "AUX" CAN (EGG <SFIND-OBJ "EGG">))
    #DECL ((EGG BEGG) OBJECT (CAN) <OR FALSE OBJECT>)
    <COND (<==? <OCAN <SFIND-OBJ "CANAR">> .EGG>
	   <TELL <ODESCO <SFIND-OBJ "BCANA">>>
	   <OTVAL <SFIND-OBJ "BCANA"> 1>)
	  (<REMOVE-OBJECT <SFIND-OBJ "BCANA">>)>
    <OTVAL .BEGG 2>
    <COND (<OROOM .EGG> <INSERT-OBJECT .BEGG ,HERE>)
	  (<SET CAN <OCAN .EGG>> <INSERT-INTO .CAN .BEGG>)
	  (<TAKE-OBJECT .BEGG>)>
    <REMOVE-OBJECT .EGG>
    T>

<DEFINE WIND ()
	<COND (<OBJECT-ACTION>)
	      (<TELL "You cannot wind up a " 1 <ODESC2 <PRSO>> ".">)>>

<SETG SING-SONG!-FLAG <>>

<DEFINE CANARY-OBJECT ("AUX" (HERE ,HERE) (TREE <SFIND-ROOM "TREE">))
	#DECL ((HERE TREE) ROOM)
	<COND (<VERB? "WIND">
	       <COND (<==? <PRSO> <SFIND-OBJ "CANAR">>
		      <COND (<AND <NOT ,SING-SONG!-FLAG>
				  <OR <MEMBER "FORE" <STRINGP <RID .HERE>>>
				      <==? .HERE .TREE>>>
			     <TELL ,OPERA>
			     <SETG SING-SONG!-FLAG T>
			     <INSERT-OBJECT <SFIND-OBJ "BAUBL">
					    <COND (<==? .HERE .TREE>
						   <SFIND-ROOM "FORE3">)
						  (.HERE)>>)
			    (<TELL
"The canary chirps blithely, if somewhat tinnily, for a short time.">)>)
		     (<TELL
"There is an unpleasant grinding noise from inside the canary.">)>)>>

<DEFINE FOREST-ROOM ("AUX" (HERE ,HERE)) 
	#DECL ((HERE) ROOM)
	<COND (<VERB? "C-INT">
	       <COND (<NOT <OR <MEMBER "FORE" <STRINGP <RID .HERE>>>
			       <==? .HERE <SFIND-ROOM "TREE">>>>
		      <CLOCK-DISABLE ,FORIN>)
		     (<PROB 10>
		      <TELL 
"You hear in the distance the chirping of a song bird.">)>)
	      (<VERB? "GO-IN"> <CLOCK-ENABLE <CLOCK-INT ,FORIN -1>>)>>

<DEFINE BIRD-OBJECT ()
	<COND (<VERB? "EXAMI">
	       <TELL "I can't see any songbird here.">)
	      (<VERB? "FIND">
	       <TELL "The songbird is not here, but is probably nearby.">)>>

<DEFINE CLIMB-FOO ()
	<CLIMB-UP <FIND-DIR "UP"> T>>

<DEFINE CLIMB-UP ("OPTIONAL" (DIR <FIND-DIR "UP">) (NOOBJ <>)
		  "AUX" (FLG <OR .NOOBJ <TRNN <PRSO> ,CLIMBBIT>>)
		         (PV ,PRSVEC) (HERE ,HERE))
	#DECL ((PV) VECTOR (DIR) DIRECTION (HERE) ROOM (NOOBJ FLG) <OR FALSE ATOM>)
	<COND (<OBJECT-ACTION>)
	      (<AND .FLG <MEMQ .DIR <REXITS .HERE>>>
	       <PUT .PV 2 .DIR>
	       <PUT .PV 1 <FIND-VERB "WALK">>
	       <WALK>)
	      (.FLG <TELL "You can't go that way.">)
	      (<MEMQ <PSTRING "WALL"> <ONAMES <PRSO>>>
	       <TELL "Climbing the walls is of no avail.">)
	      (<TELL "Bizarre!">)>>

<DEFINE CLIMB-DOWN () <CLIMB-UP <FIND-DIR "DOWN">>>

<DEFINE WCLIF-OBJECT ()
    <COND (<VERB? "CLUP" "CLDN" "CLUDG">
	   <TELL "The cliff is too steep for climbing.">)>>

\
; "SUBTITLE CHINESE PUZZLE SECTION (COURTESY OF WILL WENG)"

<GDECL (CPHERE)
       FIX
       (CPOBJS)
       <UVECTOR [REST LIST]>
       (CPUVEC)
       <UVECTOR [REST FIX]>
       (CPWALLS)
       <VECTOR [REST OBJECT FIX]>
       (CPEXITS)
       <VECTOR [REST DIRECTION FIX]>>

<DEFINE CPEXIT ("AUX" (DIR <2 ,PRSVEC>) (RM ,CPHERE) (UVEC ,CPUVEC) FX M) 
	#DECL ((DIR) DIRECTION (M) <VECTOR DIRECTION FIX> (FX RM) FIX
	       (UVEC) <UVECTOR [REST FIX]>)
	<COND (<==? .DIR <FIND-DIR "UP">>
	       <COND (<==? .RM 10>
		      <COND (<==? <11 ,CPUVEC> -2>
			     <TELL "With the help of the ladder, you exit the puzzle.">
			     <GOTO <FIND-ROOM "CPANT">>)
			    (<TELL "The exit is too far above your head.">)>)
		     (<TELL "There is no way up.">)>)
	      (<AND <==? .RM 52>
		    <==? .DIR <FIND-DIR "WEST">>
		    ,CPOUT!-FLAG>
	       <GOTO <FIND-ROOM "CPOUT">>
	       <RTRZ <FIND-ROOM "CP"> ,RSEENBIT>
	       <ROOM-INFO>)
	      (<AND <==? .RM 52>
		    <==? .DIR <FIND-DIR "WEST">>>
	       <TELL "The metal door bars the way.">)
	      (<AND <SET M <MEMQ .DIR ,CPEXITS>> <SET FX <2 .M>> <>>)
	      (<OR <MEMQ <ABS .FX> '![1 8!]>
		   <AND <G? .FX 0> ; "SW AND SE"
			<OR <0? <NTH .UVEC <+ .RM 8>>>
			    <0? <NTH .UVEC <+ .RM <- .FX 8>>>>>>
		   <AND <L? .FX 0>
			<OR <0? <NTH .UVEC <- .RM 8>>>
			    <0? <NTH .UVEC <+ .RM 8 .FX>>>>>>
	       <COND (<0? <NTH .UVEC <SET FX <+ .RM .FX>>>> <CPGOTO .FX>)
		     (<TELL "There is a wall there.">)>)
	      (<TELL "There is a wall there.">)>>

<DEFINE CPENTER () 
	<COND (,CPBLOCK!-FLAG
	       <TELL "The way is blocked by sandstone.">
	       <>)
	      (<SETG CPHERE 10>
	       <GOTO <FIND-ROOM "CP">>
	       <ROOM-INFO>)>> 

<DEFINE CPANT-ROOM ()
    <COND (<VERB? "LOOK">
	   <TELL 
"This is a small square room, in the middle of which is a recently
created hole " 0>
	   <TELL
	      <COND (,CPBLOCK!-FLAG
		     " which is blocked by smooth sandstone.")
		    (" through which you can barely discern the floor some ten
feet below.  It doesn't seem likely you could climb back up.")>
	      0>
	   <TELL "  There
are exits to the west and south.">)>>

<SETG CPPUSH!-FLAG <>>   

<SETG CPSOLVE!-FLAG <>>

<DEFINE CPLADDER-OBJECT ("AUX" (FLG <>) (HERE ,CPHERE)) 
	#DECL ((FLG) <OR FALSE ATOM> (HERE) FIX)
	<COND (<OR <AND <==? <NTH ,CPUVEC <+ .HERE 1>> -2> <SET FLG T>>
		   <==? <NTH ,CPUVEC <- .HERE 1>> -3>>
	       <COND (<VERB? "CLUP" "CLUDG">
		      <COND (<AND .FLG <==? .HERE 10>>
		      	     <SETG CPSOLVE!-FLAG T>
			     <GO&LOOK <FIND-ROOM "CPANT">>)
			    (<TELL
"You hit your head on the ceiling and fall off the ladder.">)>)
		     (<TELL "Come, come!">)>)
	      (<TELL "I can't see any ladder here.">)>>  

<DEFINE CPWALL-OBJECT ("AUX" (HERE ,CPHERE) (UVEC ,CPUVEC) WL NWL NXT NNXT) 
	#DECL ((HERE NXT WL NNXT NWL) FIX (UVEC) <UVECTOR [REST FIX]>)
	<COND (<VERB? "PUSH">
	       <SET NXT <CPNEXT .HERE <PRSO>>>
	       <SET WL <NTH .UVEC .NXT>>
	       <COND (<0? .WL>
		      <TELL "There is only a passage in that direction.">)
		     (<OR <1? .WL>
			  <AND <SET NNXT <CPNEXT .NXT <PRSO>>>
			       <NOT <0? <SET NWL <NTH .UVEC .NNXT>>>>>>
		      <TELL "The wall does not budge.">)
		     (<TELL 
"The wall slides forward and you follow it">
	   	      <TELL <COND (,CPPUSH!-FLAG
			           " to this position:")
				  (,COMPLEX-DESC)>>
		      <SETG CPPUSH!-FLAG T>
		      <PUT .UVEC .NXT 0>
		      <PUT .UVEC .NNXT .WL>
		      <AND <==? .NNXT 10> <SETG CPBLOCK!-FLAG T>>
		      <CPGOTO .NXT>)>)>> 
 
; "Flag for blocking of main entrance"

<SETG CPBLOCK!-FLAG <>>

<DEFINE CPGOTO (FX "AUX" (HERE ,HERE)) 
	#DECL ((FX) FIX (HERE) ROOM)
	<RTRZ .HERE ,RSEENBIT>
	<PUT ,CPOBJS ,CPHERE <ROBJS .HERE>>
	<SETG CPHERE .FX>
	<PUT .HERE ,ROBJS <NTH ,CPOBJS .FX>>
	<PERFORM ROOM-DESC <FIND-VERB "LOOK">>>  
 
<DEFINE CPNEXT (RM OBJ "AUX" M) 
	#DECL ((RM) FIX (OBJ) OBJECT (M) <VECTOR OBJECT FIX>)
	<AND <SET M <MEMQ .OBJ ,CPWALLS>> <+ .RM <2 .M>>>>    
 
<DEFINE CP-ROOM () 
	<COND (<VERB? "GO-IN">
	       <SETG CPHERE
		     <COND (<==? ,FROMDIR <FIND-DIR "DOWN">> 10)
		     	   (52)>>)
	      (<VERB? "LOOK">
	       <COND (,CPPUSH!-FLAG <CPWHERE>)
		     (<TELL 
"You are in a small square room bounded to the north and west with
marble walls and to the east and south with sandstone walls."
			    1
			    <COND (<TRNN <FIND-OBJ "WARNI"> ,TOUCHBIT>
				   " It
appears the thief was correct.")
				  ("")>>)>)>>    

<DEFINE CPWHERE ("EXTRA" (HERE ,CPHERE) (UVEC ,CPUVEC)
			 (N <NTH .UVEC <+ .HERE -8>>)
			 (S <NTH .UVEC <+ .HERE 8>>) (E <NTH .UVEC <+ .HERE 1>>)
			 (W <NTH .UVEC <+ .HERE -1>>))
	#DECL ((HERE N S E W) FIX (UVEC) <UVECTOR [REST FIX]>)
	<TELL "      |" ,NO-CRLF>				      ;"Top Row"
	<CP-CORNER <+ .HERE -9> .N .W>
	<TELL " " ,NO-CRLF>
	<CP-ORTHO .N>
	<TELL " " ,NO-CRLF>
	<CP-CORNER <+ .HERE -7> .N .E>
	<TELL "|">
	<TELL "West  |" ,NO-CRLF>				   ;"Middle Row"
	<CP-ORTHO .W>
	<TELL " .. " ,NO-CRLF>
	<CP-ORTHO .E>
	<TELL "|  East
      |" ,NO-CRLF>						   ;"Bottom Row"
	<CP-CORNER <+ .HERE 7> .S .W>
	<TELL " " ,NO-CRLF>
	<CP-ORTHO .S>
	<TELL " " ,NO-CRLF>
	<CP-CORNER <+ .HERE 9> .S .E>
	<TELL "|">
	<COND (<==? .HERE 10>
	       <TELL "In the ceiling above you is a large circular opening.">)
	      (<==? .HERE 37>
	       <TELL "The center of the floor here is noticeably depressed.">)
	      (<==? .HERE 52>
	       <TELL 
"The west wall here has a large " 1 <COND (,CPOUT!-FLAG "opening")
					  ("steel door")> " at its center.  On one
side of the door is a small slit.">)>
	<COND (<==? .E -2>
	       <TELL "There is a ladder here, firmly attached to the east wall.">)>
	<COND (<==? .W -3>
	       <TELL "There is a ladder here, firmly attached to the west wall.">)>>

;"Show where the eight nearest neighbors are located"  
 
<DEFINE CP-ORTHO (CONTENTS) 
	#DECL ((CONTENTS) FIX)
	<TELL <COND (<0? .CONTENTS> "  ") (<1? .CONTENTS> "MM") (ELSE "SS")>
	      ,NO-CRLF>>

;"Show an orthogonal neighbor"
 
<DEFINE CP-CORNER (LOCN COL ROW) 
	#DECL ((LOCN COL ROW) FIX)
	<TELL <COND (<AND <N==? .COL 0> <N==? .ROW 0>> "??")
		    (<0? <SET COL <NTH ,CPUVEC .LOCN>>> "  ")
		    (<1? .COL> "MM")
		    (ELSE "SS")>
	      ,NO-CRLF>>

<SETG CPOUT!-FLAG <>>
 
<DEFINE CPSLT-OBJECT ()
	<COND (<VERB? "PUT">
	       <REMOVE-OBJECT <PRSO>>
	       <COND (<==? <PRSO> <SFIND-OBJ "GCARD">>
	       	      <SETG CPOUT!-FLAG T>
	              <TELL ,CONFISCATE>)
		     (<TRNN <PRSO> <+ ,VICBIT ,VILLAIN>>
		      <TELL <PICK-ONE ,YUKS>>)
		     (<TELL ,GIGO 
		    	1
		        <ODESC2 <PRSO>>
			" (now atomized) through the slot.">)>)>>
	      
 <DEFINE CPOUT-ROOM ()
	<COND (<VERB? "LOOK">
	       <TELL "You are in a room with an exit to the north and a "
	 	     1
		     <COND (,CPOUT!-FLAG
			    "passage")
			   ("metal door")>
		     " to the east.">)>>

; "RANDOM"

<DEFINE SMELLER ()
	<TELL "It smells like a " 1 <ODESC2 <PRSO>> ".">>

; "PALANTIRS, ETC."

<DEFINE PRM-ROOM ("AUX" RES)
    #DECL ((RES) <OR ATOM FALSE>)
    <SET RES
	 <COND (<VERB? "LOOK">
		<TELL
		 "This is a tiny room, which has an exit to the east.">
		<PDOOR "north" <SFIND-OBJ "PLID1"> <SFIND-OBJ "PKH1">>)>>
    <PCHECK>
    .RES>

<SETG PALAN-SOLVE!-FLAG <>>
<SETG SLIDE-SOLVE!-FLAG <>>

<DEFINE PALANTIR-ROOM ("AUX" RES)
    #DECL ((RES) <OR ATOM FALSE>)
    <SET RES
	 <COND (<VERB? "LOOK">
		<TELL ,PAL-ROOM>
		<PDOOR "south" <SFIND-OBJ "PLID2"> <SFIND-OBJ "PKH2">>)
	       (<VERB? "GO-IN">
		<SETG PALAN-SOLVE!-FLAG T>)>>
    <PCHECK>
    .RES>

<DEFINE PCHECK ("AUX" (LID <PLID>) (MAT <SFIND-OBJ "MAT">) (OBJS ,PALOBJS))
	#DECL ((LID MAT) OBJECT (OBJS) <UVECTOR [REST OBJECT]>)
	<PROG ()
	      <OR <2 ,PRSVEC> <RETURN>>
	      <SETG PLOOK!-FLAG <>>
	      <COND (<AND <VERB? "TAKE">
			  <MEMQ <PRSO> .OBJS>
			  <TRNN .LID ,OPENBIT>>    
		     <COND (,PTOUCH!-FLAG
			    <TELL "The lid falls to cover the keyhole.">
			    <TRZ .LID ,OPENBIT>)
			   (<SETG PTOUCH!-FLAG T>)>)>
	      <MAPF <>
		    <FUNCTION (OBJ)
    			#DECL ((OBJ) OBJECT)
    		        <COND (<OR <MEMQ .OBJ <OCONTENTS <SFIND-OBJ "PKH1">>>
	       		           <MEMQ .OBJ <OCONTENTS <SFIND-OBJ "PKH2">>>>
	   		       <TRO .OBJ ,NDESCBIT>)
	  		      (<TRZ .OBJ ,NDESCBIT>)>>
		    .OBJS>
	      <COND (<OR <NOT <OROOM .MAT>>
			 <OCAN .MAT>>
		     <SETG MUD!-FLAG <>>)>
	      <COND (,MUD!-FLAG
		     <REMOVE-OBJECT .MAT>
		     <INSERT-OBJECT .MAT ,HERE>
		     <TRO .MAT ,NDESCBIT>)
		    (<TRZ .MAT ,NDESCBIT>)>>>

<DEFINE PDOOR PACT (STR LID KEYHOLE "AUX" (MATOBJ ,MATOBJ)) 
	#DECL ((STR) STRING (LID KEYHOLE) OBJECT (PACT) ACTIVATION
	       (MATOBJ) <OR FALSE OBJECT>)
	<AND ,PLOOK!-FLAG <RETURN <SETG PLOOK!-FLAG <>> .PACT>>
	<TELL "On the "
	      1
	      .STR
	      ,PAL-DOOR>
	<COND (<NOT <TRNN .LID ,OPENBIT>>
	       <TELL "covered by a thin metal lid " 0>)>
	<TELL "lies within the lock.">
	<COND (<NOT <EMPTY? <OCONTENTS .KEYHOLE>>>
	       <TELL "A "
		     1
		     <ODESC2 <1 <OCONTENTS .KEYHOLE>>>
		     " is in place within the keyhole.">)>
	<COND (,MUD!-FLAG
	       <TELL "The edge of a welcome mat is visible under the door.">
	       <COND (.MATOBJ
		      <TELL "Lying on the mat is a " 1 <ODESC2 .MATOBJ> ".">)>)>>

<DEFINE PLID ("OPTIONAL" (OBJ1 <SFIND-OBJ "PLID1">) (OBJ2 <SFIND-OBJ "PLID2">))
    #DECL ((OBJ1 OBJ2) OBJECT)
    <COND (<MEMQ .OBJ1 <ROBJS ,HERE>>
	   .OBJ1)
	  (.OBJ2)>>

<DEFINE PKH (KEYHOLE "OPTIONAL" (THIS <>) "AUX" OBJ)
    #DECL ((KEYHOLE OBJ) OBJECT (THIS) <OR ATOM FALSE>)
    <COND (<OR <AND <==? .KEYHOLE <SET OBJ <SFIND-OBJ "PKH1">>> <NOT .THIS>>
	       <AND <N==? .KEYHOLE .OBJ> .THIS>>
	   <SFIND-OBJ "PKH2">)
	  (.OBJ)>>

<DEFINE PKH-FUNCTION ("AUX" KH OBJ RM)
    #DECL ((KH OBJ) OBJECT (RM) ROOM)
    <COND (<VERB? "LKIN">
	   <COND (<AND <TRNN <SFIND-OBJ "PLID1"> ,OPENBIT>
		       <TRNN <SFIND-OBJ "PLID2"> ,OPENBIT>
		       <EMPTY? <OCONTENTS <SFIND-OBJ "PKH1">>>
		       <EMPTY? <OCONTENTS <SFIND-OBJ "PKH2">>>
		       <LIT? <COND (<==? ,HERE <SET RM <SFIND-ROOM "PALAN">>>
				    <SFIND-ROOM "PRM">)
				   (.RM)>>>
		  <TELL "You can barely make out a lighted room at the other end.">)
		 (<TELL "No light can be seen through the keyhole.">)>)
	  (<VERB? "PUT">
	   <COND (<TRNN <PLID> ,OPENBIT>
		  <COND (<NOT <EMPTY? <OCONTENTS <PKH <PRSI> T>>>>
			 <TELL "The keyhole is blocked.">)
			(<MEMQ <PRSO> ,PALOBJS>
			 <COND (<NOT <EMPTY? <OCONTENTS <SET KH <PKH <PRSI>>>>>>
				<TELL 
"There is a faint noise from behind the door and a small cloud of
dust rises from beneath it.">
				<REMOVE-FROM .KH <SET OBJ <1 <OCONTENTS .KH>>>>
				<AND ,MUD!-FLAG <SETG MATOBJ .OBJ>>
				<>)>) 
			(<TELL "The " 1 <ODESC2 <PRSO>> " doesn't fit.">)>)
		 (<TELL "The lid is in the way.">)>)>>

<DEFINE PLID-FUNCTION ()
    <COND (<VERB? "OPEN" "RAISE">
	   <TELL "The lid is open.">
	   <TRO <PRSO> ,OPENBIT>)
	  (<VERB? "CLOSE" "LOWER">
	   <COND (<NOT <EMPTY? <OCONTENTS <COND (<==? ,HERE <SFIND-ROOM "PALAN">>
				      	         <SFIND-OBJ "PKH2">)
				                (<SFIND-OBJ "PKH1">)>>>>
		  <TELL "The keyhole is occupied.">)
		 (<TELL "The lid covers the keyhole.">
		  <TRZ <PRSO> ,OPENBIT>)>)>>
	   
<SETG MUD!-FLAG <>>

<SETG MATOBJ <>>

<SETG PUNLOCK!-FLAG <>>

<SETG PLOOK!-FLAG <>>

<SETG PTOUCH!-FLAG <>>

<GDECL (MUD!-FLAG PUNLOCK!-FLAG PLOOK!-FLAG PTOUCH!-FLAG) <OR ATOM FALSE>
       (MATOBJ) <OR FALSE OBJECT> (PALOBJS SMALL-PAPERS) <UVECTOR [REST OBJECT]>>

<DEFINE PALANTIR ("AUX" OBJ RM (HERE ,HERE) THIEF)
    #DECL ((OBJ) OBJECT (HERE) ROOM (RM) <OR FALSE ROOM> (THIEF) HACK)
    <COND (<VERB? "LKIN">
	   <SET OBJ <COND (<==? <PRSO> <SET OBJ <SFIND-OBJ "PALAN">>>
			   <SFIND-OBJ "PAL3">)
			  (<==? <PRSO> <SFIND-OBJ "PAL3">>
			   <SFIND-OBJ "SPHER">)
			  (.OBJ)>>
	   <SET RM <COND (<OCAN .OBJ> <OROOM <OCAN .OBJ>>)
			 (<OROOM .OBJ>)
			 (.HERE)>>
	   <COND (<OR <NOT .RM>
		      <NOT <LIT? .RM>>
		      <MEMQ .OBJ <HOBJS <SET THIEF <GET-DEMON "ROBBE">>>>
		      <AND <OCAN .OBJ> <NOT <SEE-INSIDE? <OCAN .OBJ>>>>>
		  <TELL "You see only darkness.">)
		 (<TELL
"As you peer into the sphere, a strange vision takes shape of
a distant room, which can be described clearly....">
		  <UNWIND 
		   <PROG ()
			 <TRZ .OBJ ,OVISON>
			 <PUT ,WINNER ,AROOM <SETG HERE .RM>>
			 <PERFORM ROOM-DESC <FIND-VERB "LOOK">>
			 <AND <==? .HERE .RM>
			      <TELL
"An astonished adventurer is staring into a crystal sphere.">>
			 <TRO .OBJ ,OVISON>
			 <GOTO .HERE>>
		   <PROG ()
			 <TRO .OBJ ,OVISON>
			 <GOTO .HERE>>>
		  <TELL
"The vision fades, revealing only an ordinary crystal sphere.">)>)>>
		     
<DEFINE PLOOKAT (RM "AUX" (HERE ,HERE))
    #DECL ((RM HERE) ROOM)
    <UNWIND <PROG ()
		  <GO&LOOK .RM>
		  <GOTO .HERE>>
	    <GOTO .HERE>>>

<DEFINE PWIND-FUNCTION ()
    <COND (<VERB? "LKIN">
	   <SETG PLOOK!-FLAG T>
	   <COND (<TRNN <SFIND-OBJ "PDOOR"> ,OPENBIT>
		  <TELL "The door is open, dummy.">)
		 (<==? ,HERE <SFIND-ROOM "PALAN">>
		  <PLOOKAT <SFIND-ROOM "PRM">>)
		 (<PLOOKAT <SFIND-ROOM "PALAN">>)>)
	  (<VERB? "GTHRO">
	   <TELL "Perhaps if you were diced....">)>>

<DEFINE PDOOR-FUNCTION ("AUX" (PKEY <SFIND-OBJ "PKEY">) RM)
    #DECL ((PKEY) OBJECT (RM) ROOM)
    <COND (<AND <VERB? "LKUND"> ,MUD!-FLAG>
	   <TELL "The welcome mat is under the door.">)
	  (<VERB? "UNLOC">
	   <COND (<==? <PRSI> .PKEY>
		  <COND (<NOT <EMPTY? <OCONTENTS <PLID <SFIND-OBJ "PKH1">
						       <SFIND-OBJ "PKH2">>>>>
			 <TELL "The keyhole is blocked.">)
			(<TELL "The door is now unlocked.">
			 <SETG PUNLOCK!-FLAG T>)>)
		 (<==? <PRSI> <SFIND-OBJ "KEYS">>
		  <TELL "These are apparently the wrong keys.">)
		 (<TELL "It can't be unlocked with that.">)>)
	  (<VERB? "LOCK">
	   <COND (<==? <PRSI> .PKEY>
		  <TELL "The door is locked.">
		  <SETG PUNLOCK!-FLAG <>>
		  T)
		 (<TELL "It can't be locked with that.">)>)
	  (<AND <VERB? "PTUND"> <MEMQ <PRSO> ,SMALL-PAPERS>>
	   <TELL "The paper is very small and vanishes under the door.">
	   <REMOVE-OBJECT <PRSO>>
	   <INSERT-OBJECT <PRSO>
			  <COND (<==? ,HERE <SET RM <SFIND-ROOM "PRM">>>
				 <SFIND-ROOM "PALAN">)
				(.RM)>>)
	  (<VERB? "OPEN" "CLOSE">
	   <COND (,PUNLOCK!-FLAG
		  <OPEN-CLOSE <PRSO>
		       "The door is now open."
		       "The door is now closed.">)
		 (<TELL "The door is locked.">)>)>>
	 
<DEFINE PKEY-FUNCTION ()
    <COND (<VERB? "TURN">
	   <COND (,PUNLOCK!-FLAG
		  <PERFORM LOCKER <FIND-VERB "LOCK"> <SFIND-OBJ "PDOOR"> <PRSO>>)
		 (<PERFORM UNLOCKER <FIND-VERB "UNLOC"> <SFIND-OBJ "PDOOR"> <PRSO>>)>)>>
		  
<DEFINE PUT-UNDER ()
    <COND (<OBJECT-ACTION>)
	  (<MEMQ <PSTRING "DOOR"> <ONAMES <PRSI>>>
	   <TELL "There's not enough room under this door.">)
	  (<TELL "You can't do that.">)>>

<DEFINE MAT-FUNCTION ("AUX" (OBJ ,MATOBJ))
    #DECL ((OBJ) <OR FALSE OBJECT>)
    <COND (<AND <VERB? "PTUND">
		<==? <PRSI> <SFIND-OBJ "PDOOR">>>
	   <TELL "The mat fits easily under the door.">
	   <REMOVE-OBJECT <PRSO>>
	   <INSERT-OBJECT <PRSO> ,HERE>
	   <SETG MUD!-FLAG T>)
	  (<AND <VERB? "TAKE" "MOVE" "PULL"> .OBJ>
 	   <SETG MATOBJ <>>
	   <REMOVE-OBJECT .OBJ>
	   <INSERT-OBJECT .OBJ ,HERE>
	   <TELL "As the mat is moved, a "
		 1
		 <ODESC2 .OBJ>
		 " falls from it and onto the floor.">
	   <>)>>

<DEFINE SLIDE-EXIT ("AUX" (W <WEIGHT <AOBJS ,WINNER>>))
    #DECL ((W) FIX)
    <COND (,TIMBER-TIE!-FLAG
	   <TELL ,SLIPPERY>
	   <CLOCK-ENABLE <CLOCK-INT ,SLDIN <MAX </ 100 .W> 2>>>
	   <SFIND-ROOM "SLID1">)
	  (<SFIND-ROOM "CELLA">)>>

<DEFINE SLIDE-CINT ("AUX" (HERE ,HERE))
    #DECL ((HERE) ROOM)
    <COND (<OR <==? .HERE <SFIND-ROOM "SLIDE">>
	       <NOT <MEMBER "SLID" <STRINGP <RID .HERE>>>>>)
	  (<TELL "The rope slips from your grasp and you tumble to the cellar.">
	   <GO&LOOK <SFIND-ROOM "CELLA">>)>>

<SETG TIMBER-TIE!-FLAG <>>
<GDECL (TIMBER-TIE!-FLAG) <OR FALSE OBJECT>>

<DEFINE ROPE-FUNCTION ("AUX" (DROOM <SFIND-ROOM "DOME">) (SROOM <SFIND-ROOM "SLIDE">)
		       (HERE ,HERE) (ROPE <SFIND-OBJ "ROPE">) (TTIE ,TIMBER-TIE!-FLAG)
		       (COFFIN <SFIND-OBJ "COFFI">) (TIMBER <SFIND-OBJ "TIMBE">))
  #DECL ((ROPE TIMBER COFFIN) OBJECT (DROOM SROOM HERE) ROOM (TTIE) <OR OBJECT FALSE>)
  <COND (<AND <N==? .HERE .DROOM>
	      <AND <AND <NOT <EMPTY? <PRSI>>>
			<N==? <PRSI> .TIMBER>
			<N==? <PRSI> .COFFIN>>
		    <N==? .HERE .SROOM>>>
	 <SETG DOME-FLAG!-FLAG <>>
	 <SETG TIMBER-TIE!-FLAG <>>
	 <TRZ .TIMBER ,NDESCBIT>
	 <TRZ .COFFIN ,NDESCBIT>
	 <COND (<VERB? "TIE">
		<TELL "There is nothing it can be tied to.">)>)
	(<AND <VERB? "CLDN"> <==? .HERE <SFIND-ROOM "CPANT">>>
	 <COND (.TTIE
		<TELL 
"The " 1 <ODESC2 .TTIE> " was not well braced and falls through the
hole after you, nearly cracking your skull.">
		<REMOVE-OBJECT .TTIE>
		<REMOVE-OBJECT <PRSO>>
		<INSERT-OBJECT .TTIE <SET SROOM <SFIND-ROOM "CP">>>
		<INSERT-OBJECT <PRSO> .SROOM>)
	       (<TELL "It's not really tied, but....">)>
	 <>)
	(<VERB? "TIE">
	 <COND (<==? <PRSI> <SFIND-OBJ "RAILI">>
		<COND (,DOME-FLAG!-FLAG
		       <TELL
"The rope is already attached.">)
		      (<TELL 
"The rope drops over the side and comes within ten feet of the floor.">
		       <SETG DOME-FLAG!-FLAG T>
		       <ROPE-AWAY .ROPE .DROOM>
		       T)>)
	       (<OR <==? <PRSI> .TIMBER> <==? <PRSI> .COFFIN>>
		<COND (.TTIE
		       <TELL
"The rope is already attached.">)
		      (<IN-ROOM? <PRSI>>
		       <TELL
"The rope is fastened to a " 1 <ODESC2 <PRSI>> ".">
		       <ROPE-AWAY .ROPE .HERE>
		       <SETG TIMBER-TIE!-FLAG <PRSI>>
		       <COND (<==? <PRSI> .COFFIN>
			      <ODESC1 .COFFIN ,COFFIN-TIED>)
			     (<ODESC1 .TIMBER ,TIMBER-TIED>)>
		       <COND (<==? .HERE .SROOM>
			      <TELL "The rope dangles down the slide.">)
			     (<==? .HERE <SFIND-ROOM "CPANT">>
			      <TELL
			       "The rope dangles down into the darkness.">)>
		       <COND (<==? .HERE .SROOM>
			      <TRO <PRSI> ,NDESCBIT>)>
		       T)
		      (<TELL "It is too clumsy when you are carrying it.">)>)>)
	(<VERB? "UNTIE">
	 <COND (<OR .TTIE ,DOME-FLAG!-FLAG>
		<COND (.TTIE
		       <TRZ .TTIE ,NDESCBIT>
		       <COND (<==? .TTIE .COFFIN>
			      <ODESC1 .COFFIN ,COFFIN-UNTIED>)
			     (<ODESC1 .TIMBER ,TIMBER-UNTIED>)>)>
		<SETG DOME-FLAG!-FLAG <>>
		<SETG TIMBER-TIE!-FLAG <>>
		<TRZ .ROPE <+ ,CLIMBBIT ,NDESCBIT>>
		<TELL 
"The rope is now untied.">)
	       (<TELL "It is not tied to anything.">)>)
	(<AND <VERB? "DROP">
	      <==? .HERE .DROOM>
	      <NOT ,DOME-FLAG!-FLAG>>
	 <REMOVE-OBJECT .ROPE>
	 <INSERT-OBJECT .ROPE <SFIND-ROOM "MTORC">>
	 <TELL "The rope drops gently to the floor below.">)
	(<VERB? "TAKE">
	 <COND (,DOME-FLAG!-FLAG
	        <TELL "The rope is tied to the railing.">)
	       (.TTIE
		<TELL "The rope is tied to a " 1 <ODESC2 ,TIMBER-TIE!-FLAG> ".">)>)>>

<DEFINE UNTIE-FROM ()
    <COND (<OR <AND <==? <PRSO> <SFIND-OBJ "ROPE">>
	   	    <OR <AND ,DOME-FLAG!-FLAG <==? <PRSI> <SFIND-OBJ "RAILI">>>
			<==? <PRSI> ,TIMBER-TIE!-FLAG>>>
	       <AND <==? <PRSO> <SFIND-OBJ "BROPE">> ,BTIE!-FLAG>>
	   <PERFORM UNTIE <FIND-VERB "UNTIE"> <PRSO>>)
	  (<TELL "It's not attached to that!">)>>

<DEFINE ROPE-AWAY (ROPE RM)
    #DECL ((ROPE) OBJECT (RM) ROOM)
    <TRO .ROPE <+ ,CLIMBBIT ,NDESCBIT>>
    <COND (<NOT <OROOM .ROPE>>
	   <DROP-OBJECT .ROPE>
	   <INSERT-OBJECT .ROPE .RM>)>>
    
<DEFINE SLIDE-ROPE ()
    <COND (<VERB? "TAKE">
	   <TELL "What do you think is suspending you in midair?">)
	  (<VERB? "DROP">
	   <TELL "You tumble down the chute to the cellar.">
	   <GO&LOOK <SFIND-ROOM "CELLA">>)
	  (<VERB? "CLDN" "CLUP" "CLUDG">
	   <>)
	  (<TELL "It's not easy to play with the rope in your position.">)>>

<DEFINE TIMBERS ()
    <COND (<VERB? "TAKE">
	   <COND (<==? <PRSO> ,TIMBER-TIE!-FLAG>
		  <TELL "The rope comes loose as you take the " 1 <ODESC2 <PRSO>> ".">
		  <PERFORM UNTIE <FIND-VERB "UNTIE"> <SFIND-OBJ "ROPE">>
		  <>)>)>>
		 
<DEFINE SLIDE-ROOM ("AUX" (TIE ,TIMBER-TIE!-FLAG))
    #DECL ((TIE) <OR FALSE OBJECT>)
    <COND (<VERB? "LOOK">
	   <TELL ,SLIDE-DESC>
	   <COND (.TIE
		  <TELL 
"A " 1 <ODESC2 .TIE> " is lying on the ground here.  Tied to it is a piece
of rope, which is dangling down the slide.">)>)>>

<DEFINE SLIDE-FUNCTION ()
    <COND (<OR <VERB? "GTHRO">
	       <AND <VERB? "PUT"> <==? <PRSO> <AOBJ ,PLAYER>>>>
    	   <TELL "You tumble down the slide....">
	   <GO&LOOK <SFIND-ROOM "CELLA">>)
	  (<VERB? "PUT">
	   <COND (<==? <PRSO> ,TIMBER-TIE!-FLAG>
		  <SETG TIMBER-TIE!-FLAG <>>)>
	   <SLIDER <PRSO>>)>>

<DEFINE GO&LOOK (RM "AUX" (SEEN? <RTRNN .RM ,RSEENBIT>))
    #DECL ((RM) ROOM (SEEN?) <OR ATOM FALSE>)
    <GOTO .RM>
    <PERFORM ROOM-DESC <FIND-VERB "LOOK">>
    <OR .SEEN? <RTRZ .RM ,RSEENBIT>>>

<DEFINE SLIDER (OBJ)
    #DECL ((OBJ) OBJECT)
    <COND (<TRNN .OBJ ,TAKEBIT>
	   <COND (<OR <==? .OBJ <SFIND-OBJ "VALUA">>
		      <==? .OBJ <SFIND-OBJ "EVERY">>>
		  <VALUABLES&C>)
		 (<TELL "The " 1 <ODESC2 .OBJ>
			" falls through the slide and is gone.">
		  <REMOVE-OBJECT .OBJ>
		  <OR <==? .OBJ <SFIND-OBJ "WATER">>
		      <INSERT-OBJECT .OBJ <SFIND-ROOM "CELLA">>>)>)
	  (<TELL <PICK-ONE ,YUKS>>)>>

<DEFINE INSLIDE ()
    <MAPF <> ,SLIDER <ROBJS ,HERE>>>

<DEFINE SLEDG-ROOM ()
    <COND (<VERB? "GO-IN">
	   <SETG SLIDE-SOLVE!-FLAG T>
	   <CLOCK-DISABLE ,SLDIN>)>>

<DEFINE STOVE-FUNCTION ()
    <COND (<VERB? "TAKE" "FEEL" "DESTR" "ATTAC">
	   <TELL "The intense heat of the stove keeps you away.">)
	  (<AND <VERB? "THROW"> <TRNN <PRSO> ,BURNBIT>>
	   <PERFORM BURNER <FIND-VERB "BURN"> <PRSO> <PRSI>>)>>

<DEFINE OOPS ()
    <TELL "You haven't made any spelling mistakes....lately.">>

; "MORE RANDOMNESS"

<GDECL (MUDDLE) FIX (LEXV) <VECTOR [REST STRING STRING FIX]>>

<DEFINE SRNAME ("AUX" (STR <7 ,LEXV>))
    #DECL ((STR) STRING)
    <COND (<L? ,MUDDLE 100>
	   <TELL "Not available on ITS.">)
	  (<NOT <EMPTY? .STR>>
	   <SETG SAVNM <STRING .STR>>
	   <TELL "Ok.">)
	  (<TELL ,SAVNM>)>>

<DEFINE PLAY ()
    <COND (<==? <PRSO> <FIND-OBJ "STRAD">>
	   <COND (<TRNN <PRSI> ,WEAPONBIT>
		  <TELL "Very good. The violin is now worthless.">
		  <OTVAL <PRSO> 0>)
		 (<TELL "An amazingly offensive noise issues from the violin.">)>)
	  (<TRNN <PRSO> ,VILLAIN>
	   <JIGS-UP 
"You are so engrossed in the role of the " 1 <ODESC2 <PRSO>> "that
you kill yourself, just as he would have done!">)>>

<DEFINE MAKER ("AUX" (HERE ,HERE) (COINS <SFIND-OBJ "BAGCO">))
    #DECL ((HERE) ROOM (COINS) OBJECT)
    <COND (<==? <PRSO> <SFIND-OBJ "WISH">>
	   <COND (<AND <==? .HERE <SFIND-ROOM "BWELL">>
		       <OR <MEMQ .COINS <ROBJS .HERE>>
			   <MEMQ <SET COINS <SFIND-OBJ "COIN">> <ROBJS .HERE>>>>
		  <TELL
"A whispering voice replies: 'Water makes the bucket go'.
Unfortunately, wishing makes the coins go....">
		  <REMOVE-OBJECT .COINS>)
		 (<TELL "No one is listening.">)>)>>

<DEFINE WELL-FUNCTION ()
    <COND (<AND <TRNN <PRSO> ,TAKEBIT> <VERB? "THROW" "PUT" "DROP">>
	   <TELL "The " 1 <ODESC2 <PRSO>> " is now sitting at the bottom of the well.">
	   <REMOVE-OBJECT <PRSO>>
	   <INSERT-OBJECT <PRSO> <SFIND-ROOM "BWELL">>)>>

<DEFINE WISHER ()
    <PERFORM MAKER <FIND-VERB "MAKE"> <SFIND-OBJ "WISH">>>

; "Oh, is this ever gross!"

<SETG BRFLAG1!-FLAG <>>

<SETG BRFLAG2!-FLAG <>>

<DEFINE SENDER ()
    <COND (<OBJECT-ACTION>)
	  (<TRNN <PRSO> ,VILLAIN>
	   <TELL "Why would you send for the " 1 <ODESC2 <PRSO>> "?">)
	  (<TELL "That doesn't make sends.">)>>

<DEFINE BROCHURE ("AUX" (STAMP <SFIND-OBJ "DSTMP">)) 
	#DECL ((STAMP) OBJECT)
	<COND (<==? <PRSO> .STAMP>
	       <COND (<VERB? "TAKE">
		      <TRZ <SFIND-OBJ "BROCH"> ,CONTBIT>
		      <>)>)
	      (<AND <VERB? "EXAMI" "LKAT" "READ">
		    <==? <PRSO> <SFIND-OBJ "BROCH">>>
	       <TELL ,BRO1 1 ,USER-NAME ,BRO2>
	       <AND <OCAN .STAMP>
		    <TELL "Affixed loosely to the brochure is a small stamp.">>)
	      (<AND <VERB? "FIND"> ,BR1!-FLAG>
	       <TELL "It's probably on the way.">)
	      (<VERB? "SEND">
	       <COND (,BRFLAG2!-FLAG <TELL "Why? Do you need another one?">)
		     (,BRFLAG1!-FLAG <TELL "It's probably on the way.">)
		     (<SETG BRFLAG1!-FLAG T>
		      <TELL "Ok, but you know the postal service...">)>)
	      (<VERB? "C-INT">
	       <TELL "There is a knocking sound from the front of the house.">
	       <INSERT-INTO <SFIND-OBJ "MAILB"> <SFIND-OBJ "BROCH">>
	       <SETG BRFLAG2!-FLAG T>)
	      (<==? <PRSO> <SFIND-OBJ "GBROC">>
	       <TELL "I don't see any brochure here.">)>>

<DEFINE DEAD-FUNCTION ("AUX" M)
	#DECL ((M) <OR FALSE <VECTOR [REST DIRECTION ANY]>>)
	<COND (<VERB? "WALK">
	       <COND (<AND <SET M <MEMQ <2 ,PRSVEC> <REXITS ,HERE>>>
			   <==? <2 .M> ,DARK-ROOM>>
		      <TELL "You cannot enter in your condition.">)>)
	      (<VERB? "QUIT" "RESTA"> <>)
	      (<VERB? "ATTAC" "BLOW" "DESTR" "KILL" "POKE" "STRIK" "SWING" "TAUNT">
	       <TELL "All such attacks are vain in your condition.">)
	      (<VERB? "OPEN" "CLOSE" "EAT" "DRINK" "INFLA" "DEFLA" "TURN" "BURN"
		      "TIE" "UNTIE" "RUB">
	       <TELL "Even such a simple action is beyond your capabilities.">)
	      (<VERB? "TRNON">
	       <TELL "You need no light to guide you.">)
	      (<VERB? "SCORE">
	       <TELL "How can you think of your score in your condition?">)
	      (<VERB? "TELL">
	       <TELL "No one can hear you.">)
	      (<VERB? "TAKE">
	       <TELL "Your hand passes through its object.">)
	      (<VERB? "DROP" "THROW" "INVEN">
	       <TELL "You have no possessions.">)
	      (<VERB? "DIAGN">
	       <TELL "You are dead.">)
	      (<VERB? "LOOK">
	       <TELL "The room looks strange and unearthly"
		     1
		     <COND (<EMPTY? <ROBJS ,HERE>>
			    ".")
			   (" and objects appear indistinct.")>>
	       <OR <RTRNN ,HERE ,RLIGHTBIT>
		   <TELL 
"Although there is no light, the room seems dimly illuminated.">>
	       <>)
	      (<VERB? "BUG">
	       <BUGGER>)
	      (<VERB? "FEATU">
	       <FEECH>)
	      (<VERB? "PRAY">
	       <COND (<==? ,HERE <FIND-ROOM "TEMP2">>
		      <TRO <FIND-OBJ "LAMP"> ,OVISON>
		      <GOTO <FIND-ROOM "FORE1">>
		      <PUT ,PLAYER ,AACTION <>>
		      <SETG GWIM-DISABLE <>>
		      <SETG ALWAYS-LIT <>>
		      <SETG DEAD!-FLAG <>>
		      <PUT ,PLAYER ,AACTION <>>
		      <TELL ,LIFE>)
		     (<TELL "Your prayers are not heard.">)>)
	      (<TELL "You can't do even that.">)>>

<DEFINE COUNT ("AUX" (OBJS <AOBJS ,WINNER>) CNT)
    #DECL ((OBJS) <LIST [REST OBJECT]> (CNT) FIX)
    <COND (<==? <PRSO> <SFIND-OBJ "BLESS">>
	   <TELL "Well, for one, you are playing Zork....">)
	  (<==? <PRSO> <SFIND-OBJ "LEAVE">>
	   <TELL "There are 69,105 leaves here.">)
	  (<==? <PRSO> <SFIND-OBJ "BILLS">>
	   <TELL "Don't you trust me?  There are 200 bills.">)
	  (<==? <PRSO> <SFIND-OBJ "CANDL">>
	   <TELL
"Let's see, how many objects in a pair?  Don't tell me, I'll get it.">)
	  (T
	   <TELL "You have " 0>
	   <COND (<==? <PRSO> <SFIND-OBJ "MATCH">>
		  <SET CNT <- <OMATCH <PRSO>> 1>>
		  <PRINC .CNT>
		  <TELL " match" 1 <COND (<NOT <1? .CNT>> "es.") (".")>>)
		 (<==? <PRSO> <SFIND-OBJ "VALUA">>
		  <NUMTELL <SET CNT
				<MAPF ,+
				      <FUNCTION (OBJ)
						#DECL ((OBJ) OBJECT)
						<COND (<NOT <0? <OTVAL .OBJ>>> 1)
						      (0)>>
				      .OBJS>>
			   "valuable">
		  <AND <==? ,HERE <SFIND-ROOM "LROOM">>
		       <TELL "Your adventure has netted " 0>
		       <NUMTELL <LENGTH <OCONTENTS <SFIND-OBJ "TCASE">>> "treasure">>)
		 (<==? <PRSO> <SFIND-OBJ "POSSE">>
		  <NUMTELL <SET CNT <LENGTH .OBJS>> "possession">)
		 (<TELL "lost your mind.">)>)>>
	  
<DEFINE NUMTELL (NUM STR)
	#DECL ((NUM) FIX (STR) STRING)
	<COND (<0? .NUM> <PRINC "no">)
	      (<PRINC .NUM>)>
	<TELL " " 0 .STR>
	<OR <1? .NUM> <TELL "s" 0>>
	<TELL ".">>
