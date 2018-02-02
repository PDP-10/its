; "SUBTITLE TAKING THE BACK OFF..."

<DEFINE BLO (DUMMY)
	#DECL ((DUMMY) PROCESS)
	<COND (<TYPE? ,REP SUBR FSUBR>
	       <SET READ-TABLE <PUT <IVECTOR 256 0> <CHTYPE <ASCII !\<> FIX> !\>>
	       <EVALTYPE FORM SEGMENT>
	       <APPLYTYPE SUBR FIX>
	       <PUT <ALLTYPES> 6 <7 <ALLTYPES>>>
	       <SUBSTITUTE 2 1>
	       <OFF .BH>)>>

<GDECL (FF) STRING>
<DEFINE ILO (BODY TYPE NM1 NM2 "OPTIONAL" M1 M2)
	#DECL ((BODY NM1 NM2 M1 M2) STRING (TYPE) FIX)
	<COND (<==? .TYPE *400000000000*>
	       <COND (<OR <AND <MEMBER "<FLUSH-ME!-INITIAL!- >" .BODY>
			       <NOT <MEMBER ,XUNM ,WINNERS>>>
			  <AND <MEMBER .NM1 ,WINNERS>
			       <MEMBER ,FF .BODY>>>
		      <EVAL <PARSE .BODY>>)>)>
	<DISMISS T>>

\
; "SUBTITLE THE WHITE HOUSE"

<DEFINE EAST-HOUSE ()
    <COND (<VERB? "LOOK">
	   <TELL 
"You are behind the white house.  In one corner of the house there
is a small window which is " ,LONG-TELL1 <COND (<TRNN <SFIND-OBJ "WINDO"> ,OPENBIT>
		  		      "open.")
		 		     ("slightly ajar.")>>)>>
	   
<DEFINE WINDOW-FUNCTION ()
    <OPEN-CLOSE <SFIND-OBJ "WINDO">
"With great effort, you open the window far enough to allow entry."
"The window closes (more easily than it opened).">>

<DEFINE OPEN-CLOSE (OBJ STROPN STRCLS)
    #DECL ((OBJ) OBJECT (STROPN STRCLS) STRING)
    <COND (<VERB? "OPEN">
	   <COND (<TRNN .OBJ ,OPENBIT>
		  <TELL <PICK-ONE ,DUMMY>>)
		 (<TELL .STROPN>
		  <TRO .OBJ ,OPENBIT>)>)
	  (<VERB? "CLOSE">
	   <COND (<TRNN .OBJ ,OPENBIT>
		  <TELL .STRCLS>
		  <TRZ .OBJ ,OPENBIT>
		  T)
		 (<TELL <PICK-ONE ,DUMMY>>)>)>>

<DEFINE KITCHEN () 
	<COND (<VERB? "LOOK">
	       <TELL ,KITCH-DESC ,LONG-TELL>
	       <COND (<TRNN <SFIND-OBJ "WINDO"> ,OPENBIT>
		      <TELL "open." ,POST-CRLF>)
		     (<TELL "slightly ajar." ,POST-CRLF>)>)
	      (<AND <VERB? "GO-IN"> ,BRFLAG1!-FLAG <NOT ,BRFLAG2!-FLAG>>
	       <CLOCK-INT ,BROIN 3>)>>

<DEFINE TROPHY-CASE ()
    <COND (<VERB? "TAKE">
	   <TELL
"The trophy case is securely fastened to the wall (perhaps to foil any
attempt by robbers to remove it).">)>>
	  
<SETG RUG-MOVED!-FLAG <>>

<DEFINE LIVING-ROOM ("AUX" RUG? TC (DOOR <SFIND-OBJ "DOOR">))
	#DECL ((RUG?) <OR ATOM FALSE> (TC DOOR) OBJECT)
	<COND (<VERB? "LOOK">
	       <COND (,MAGIC-FLAG!-FLAG
		      <TELL ,LROOM-DESC1 ,LONG-TELL>)
		     (<TELL ,LROOM-DESC2 ,LONG-TELL>)>
	       <SET RUG? ,RUG-MOVED!-FLAG>
	       <COND (<AND .RUG? <TRNN .DOOR ,OPENBIT>>
		      <TELL 
"and a rug lying beside an open trap-door." ,POST-CRLF>)
		     (.RUG?
		      <TELL 
"and a closed trap-door at your feet." ,POST-CRLF>)
		     (<TRNN .DOOR ,OPENBIT>
		      <TELL "and an open trap-door at your feet." ,POST-CRLF>)
		     (<TELL 
"and a large oriental rug in the center of the room." ,POST-CRLF>)>
	       T)
	      (<AND <SET TC <SFIND-OBJ "TCASE">>
		    <OR <VERB? "TAKE">
			<AND <VERB? "PUT">
			     <==? <PRSI> .TC>>>>
	       <PUT ,WINNER
		    ,ASCORE
		    <+ ,RAW-SCORE
		       <OTVAL-FROB <OCONTENTS .TC>>>>
	       <SCORE-BLESS>)>>

<DEFINE OTVAL-FROB (L) #DECL ((L) <LIST [REST OBJECT]> (VALUE) FIX)
  <MAPF ,+
	<FUNCTION (X "AUX" TEMP) #DECL ((X) OBJECT (TEMP) FIX)
	  <+ <OTVAL .X>
	     <COND (<EMPTY? <OCONTENTS .X>> 0)
		   (<OTVAL-FROB <OCONTENTS .X>>)>>>
	.L>>

<DEFINE TRAP-DOOR ("AUX" (RM ,HERE))
    #DECL ((PRSA) VERB (RM) ROOM (DOOR) OBJECT)
    <COND (<AND <VERB? "OPEN" "CLOSE">
		<==? .RM <SFIND-ROOM "LROOM">>>
	   <OPEN-CLOSE <PRSO>
"The door reluctantly opens to reveal a rickety staircase descending
into darkness."
"The door swings shut and closes.">)
	  (<==? .RM <SFIND-ROOM "CELLA">>
	   <COND (<VERB? "OPEN">
		  <TELL
"The door is locked from above.">)
		 (<TELL <PICK-ONE ,DUMMY>>)>)>>

<DEFINE CELLAR ("AUX" (DOOR <SFIND-OBJ "DOOR">))
  #DECL ((DOOR) OBJECT)
  <COND (<VERB? "LOOK">
	 <TELL ,CELLA-DESC ,LONG-TELL1>)
	(<AND <VERB? "GO-IN">
	      <TRNN .DOOR ,OPENBIT>
	      <NOT <TRNN .DOOR ,TOUCHBIT>>>
	 <TRZ .DOOR ,OPENBIT>
	 <TRO .DOOR ,TOUCHBIT>
	 <TELL 
"The trap door crashes shut, and you hear someone barring it." 1>)>>

<DEFINE CHIMNEY-FUNCTION ("AUX" DOOR (WINNER ,WINNER) (AOBJS <AOBJS .WINNER>))
  #DECL ((WINNER) ADV (AOBJS) <LIST [REST OBJECT]> (DOOR) OBJECT)
  <COND (<AND <L=? <LENGTH .AOBJS> 2>
	      <MEMQ <SFIND-OBJ "LAMP"> .AOBJS>>
	 <SETG LIGHT-LOAD!-FLAG T>
	 ;"Door will slam shut next time, too, since this way up don't count."
	 <COND (<NOT <TRNN <SET DOOR <SFIND-OBJ "DOOR">> ,OPENBIT>>
		<TRZ .DOOR ,TOUCHBIT>)>
	 <>)
	(<EMPTY? .AOBJS>
	 <TELL "Going up empty-handed is a bad idead.">
	 T)
	(T
	 <SETG LIGHT-LOAD!-FLAG <>>)>>



<DEFINE RUG ()
   <COND (<VERB? "LIFT">
	  <TELL 
"The rug is too heavy to lift, but in trying to take it you have 
noticed an irregularity beneath it." ,LONG-TELL1>)
	 (<VERB? "MOVE">
	  <COND (,RUG-MOVED!-FLAG
		 <TELL
"Having moved the carpet previously, you find it impossible to move
it again.">)
		(<TELL
"With a great effort, the rug is moved to one side of the room.
With the rug moved, the dusty cover of a closed trap-door appears." ,LONG-TELL1>
		 <TRO <SFIND-OBJ "DOOR"> ,OVISON>
		 <SETG RUG-MOVED!-FLAG T>)>)
	 (<VERB? "TAKE">
	  <TELL
"The rug is extremely heavy and cannot be carried.">)
	 (<AND <VERB? "LKUND">
	       <NOT ,RUG-MOVED!-FLAG>
	       <NOT <TRNN <SFIND-OBJ "DOOR"> ,OPENBIT>>>
	  <TELL "Underneath the rug is a closed trap door.">)>>

\
; "SUBTITLE TROLL"

<DEFINE AXE-FUNCTION ()
	<COND (<VERB? "TAKE">
	       <TELL
"The troll's axe seems white-hot.  You can't hold on to it.">
	       T)>>

<DEFINE TROLL ("AUX" (HERE ,HERE) (T <SFIND-OBJ "TROLL">) (A <SFIND-OBJ "AXE">))
	#DECL ((WIN) ADV (HERE) ROOM (T A) OBJECT)
	<COND (<VERB? "FGHT?">
	       <COND (<==? <OCAN .A> .T> <>)
		     (<AND <MEMQ .A <ROBJS ,HERE>> <PROB 75 90>>
		      <SNARF-OBJECT .T .A>
		      <AND <==? .HERE <OROOM .T>>
			   <TELL
"The troll, now worried about this encounter, recovers his bloody
axe.">>
		      T)
		     (<==? .HERE <OROOM .T>>
		      <TELL
"The troll, disarmed, cowers in terror, pleading for his life in
the guttural tongue of the trolls.">
		      T)>)
	      (<VERB? "DEAD!"> <SETG TROLL-FLAG!-FLAG T>)
	      (<VERB? "OUT!">
	       <TRZ .A ,OVISON>
	       <ODESC1 .T ,TROLLOUT>
	       <SETG TROLL-FLAG!-FLAG T>)
	      (<VERB? "IN!">
	       <TRO .A ,OVISON>
	       <COND (<==? <OROOM .T> .HERE>
		      <TELL
"The troll stirs, quickly resuming a fighting stance.">)>
	       <ODESC1 .T ,TROLLDESC>
	       <SETG TROLL-FLAG!-FLAG <>>)
	      (<VERB? "1ST?"> <PROB 33 66>)
	      (<OR <AND <VERB? "THROW" "GIVE"> <NOT <EMPTY? <PRSO>>>>
		   <VERB? "TAKE" "MOVE" "MUNG">>
	       <COND (<L? <OSTRENGTH .T> 0>
		      <OSTRENGTH .T <- <OSTRENGTH .T>>>
		      <PERFORM TROLL <FIND-VERB "IN!">>)>
	       <COND (<VERB? "THROW" "GIVE">
		      <COND (<VERB? "THROW">
			     <TELL 
"The troll, who is remarkably coordinated, catches the " 1 <ODESC2 <PRSO>>>)
			    (<TELL
"The troll, who is not overly proud, graciously accepts the gift">)>
		      <COND (<==? <PRSO> <SFIND-OBJ "KNIFE">>
			     <TELL
"and being for the moment sated, throws it back.  Fortunately, the
troll has poor control, and the knife falls to the floor.  He does
not look pleased." ,LONG-TELL1>
			     <TRO .T ,FIGHTBIT>)
			    (<TELL 
"and not having the most discriminating tastes, gleefully eats it.">
		      <REMOVE-OBJECT <PRSO>>)>)
		     (<VERB? "TAKE" "MOVE">
		      <TELL 
"The troll spits in your face, saying \"Better luck next time.\"">)
		     (<VERB? "MUNG">
		      <TELL
"The troll laughs at your puny gesture.">)>)
	      (<AND ,TROLL-FLAG!-FLAG
		    <VERB? "HELLO">>
	       <TELL "Unfortunately, the troll can't hear you.">)>>

\
; "SUBTITLE GRATING/MAZE"

<SETG LEAVES-GONE!-FLAG <>>
<SETG GRATE-REVEALED!-FLAG <>>
<SETG GRUNLOCK!-FLAG <>>

<DEFINE LEAVES-APPEAR ("AUX" (GRATE <SFIND-OBJ "GRATE">))
	#DECL ((GRATE) OBJECT)
	<COND (<AND <NOT <TRNN .GRATE ,OPENBIT>>
	            <NOT ,GRATE-REVEALED!-FLAG>>
	       <TELL "A grating appears on the ground.">
	       <TRO .GRATE ,OVISON>
	       <SETG GRATE-REVEALED!-FLAG T>)>
	<>>

<DEFINE LEAF-PILE ()
	<COND (<VERB? "BURN">
	       <LEAVES-APPEAR>
	       <COND (<OROOM <PRSO>>
		      <TELL "The leaves burn and the neighbors start to complain.">
		      <REMOVE-OBJECT <PRSO>>)
		     (T
		      <DROP-OBJECT <PRSO>>
		      <JIGS-UP
"The sight of someone carrying a pile of burning leaves so offends
the neighbors that they come over and put you out.">)>)
	      
	      (<VERB? "MOVE" "TAKE">
	       <COND (<VERB? "MOVE"> <TELL "Done."> <LEAVES-APPEAR> T)
		     (<LEAVES-APPEAR>)>)
	      (<AND <VERB? "LKUND">
		    <NOT ,GRATE-REVEALED!-FLAG>>
	       <TELL "Underneath the pile of leaves is a grating.">)>>

<DEFINE HOUSE-FUNCTION ("AUX" (HERE ,HERE))
    #DECL ((HERE) ROOM)
    <COND (<N=? <REST <STRINGP <RID .HERE>>> "HOUS">
	   <COND (<VERB? "FIND">
		  <COND (<==? .HERE <SFIND-ROOM "CLEAR">>
			 <TELL "It seems to be to the southwest.">)
			(<TELL "It was just here a minute ago....">)>)
		 (<TELL "You're not at the house.">)>)
	  (<VERB? "FIND">
	   <TELL "It's right in front of you.  Are you blind or something?">)
	  (<VERB? "LKAT">
	   <TELL
"The house is a beautiful colonial house which is painted white.
It is clear that the owners must have been extremely wealthy.">)
	  (<VERB? "GTHRO">
	   <COND (<==? .HERE <SFIND-ROOM "EHOUS">>
		  <COND (<TRNN <SFIND-OBJ "WINDO"> ,OPENBIT>
			 <GOTO <FIND-ROOM "KITCH">>
			 <PERFORM ROOM-DESC <FIND-VERB "LOOK">>)
			(<TELL "The window is closed.">)>)
		 (<TELL "I can't see how to get in from here.">)>)
	  (<VERB? "BURN">
	   <TELL "You must be joking.">)>>
    
<DEFINE CLEARING ("AUX" (GRATE <SFIND-OBJ "GRATE">) (LEAVES <SFIND-OBJ "LEAVE">))
  #DECL ((LEAVES GRATE) OBJECT)
  <COND (<VERB? "LOOK">
	 <TELL 
"You are in a clearing, with a forest surrounding you on the west
and south.">
	 <COND (<TRNN .GRATE ,OPENBIT>
		<TELL "There is an open grating, descending into darkness." 1>)
	       (,GRATE-REVEALED!-FLAG
		<TELL "There is a grating securely fastened into the ground." 1>)>)>>

<DEFINE MAZE-11 ()
  <COND (<VERB? "LOOK">
	 <TELL 
 "You are in a small room near the maze. There are twisty passages
in the immediate vicinity.">
	 <COND (<TRNN <SFIND-OBJ "GRATE"> ,OPENBIT>
		<TELL
 "Above you is an open grating with sunlight pouring in.">)
	       (,GRUNLOCK!-FLAG
		<TELL "Above you is a grating.">)
	       (<TELL
 "Above you is a grating locked with a skull-and-crossbones lock.">)>)>>

<DEFINE GRATE-FUNCTION ("AUX" OBJ GROOM)
    #DECL ((OBJ) OBJECT (GROOM) ROOM)
    <COND (<VERB? "OPEN" "CLOSE">
	   <COND (,GRUNLOCK!-FLAG
	     	  <OPEN-CLOSE <SET OBJ <SFIND-OBJ "GRATE">>
			      <COND (<==? ,HERE <SFIND-ROOM "CLEAR">>
				     "The grating opens.")
			            ("The grating opens to reveal trees above you.")>
			      "The grating is closed.">
		  <SET GROOM <SFIND-ROOM "MGRAT">>
		  <COND (<TRNN .OBJ ,OPENBIT>
			 <RTRO .GROOM ,RLIGHTBIT>)
			(ELSE <RTRZ .GROOM ,RLIGHTBIT>)>)
	    	 (<TELL "The grating is locked.">)>)>>

<DEFINE RUSTY-KNIFE ("AUX" R)
	<COND (<VERB? "TAKE">
	       <AND <MEMQ <SFIND-OBJ "SWORD"> <AOBJS ,WINNER>>
		    <TELL
"As you pick up the rusty knife, your sword gives a single pulse
of blinding blue light.">>
	       <>)
	      (<OR <AND <==? <PRSI> <SET R <SFIND-OBJ "RKNIF">>>
			<VERB? "ATTAC" "KILL">>
		   <AND <VERB? "SWING" "THROW">
			<==? <PRSO> .R>
			<NOT <EMPTY? <PRSI>>>>>
	       <REMOVE-OBJECT .R>
	       <JIGS-UP ,RUSTY-KNIFE-STR>)>>

<DEFINE SKELETON ("AUX" (RM <1 ,WINNER>) (LLD <SFIND-ROOM "LLD2">) L)
   #DECL ((RM LLD) ROOM (L) <LIST [REST OBJECT]>)
   <TELL ,CURSESTR ,LONG-TELL1>
   <SET L <ROB-ROOM .RM () 100>>
   <SET L <ROB-ADV ,PLAYER .L>>
   <MAPF <>
	 <FUNCTION (X) #DECL ((X) OBJECT)
		   <PUT .X ,OROOM .LLD>>
	 .L>
   <COND (<NOT <EMPTY? .L>>
	  <PUTREST <REST .L <- <LENGTH .L> 1>> <ROBJS .LLD>>
	  <PUT .LLD ,ROBJS .L>)>
   T>

\
; "SUBTITLE THE GLACIER"

<SETG GLACIER-MELT!-FLAG <>>

<DEFINE GLACIER ("AUX" (ICE <SFIND-OBJ "ICE">) T)
    #DECL ((T ICE) OBJECT)
    <COND (<VERB? "THROW">
	   <COND (<==? <PRSO> <SET T <SFIND-OBJ "TORCH">>>
		  <TELL ,GLACIER-WIN ,LONG-TELL1>
		  <REMOVE-OBJECT .ICE>
		  <REMOVE-OBJECT .T>
		  <INSERT-OBJECT .T <SFIND-ROOM "STREA">>
		  <TORCH-OFF .T>
		  <OR <LIT? ,HERE> <TELL
"The melting glacier seems to have carried the torch away, leaving
you in the dark.">>
		  <SETG GLACIER-FLAG!-FLAG T>)
		 (<TELL
"The glacier is unmoved by your ridiculous attempt.">
		  <>)>)
	  (<AND <VERB? "MELT">
		<==? <PRSO> .ICE>>
	   <COND (<FLAMING? <PRSI>>
		  <SETG GLACIER-MELT!-FLAG T>
		  <AND <==? <PRSI> .T>
		       <TORCH-OFF .T>>
		  <JIGS-UP 
"Part of the glacier melts, drowning you under a torrent of water.">)
		 (<TELL
"You certainly won't melt it with a " ,POST-CRLF <ODESC2 <PRSI>> ".">)>)>>

<DEFINE GLACIER-ROOM ()
    <COND (<VERB? "LOOK">
	   <COND (,GLACIER-FLAG!-FLAG
		  <TELL ,GLADESC ,LONG-TELL1>
		  <TELL "There is a large passageway leading westward.">)
		 (<TELL ,GLADESC ,LONG-TELL1>
		  <AND ,GLACIER-MELT!-FLAG 
		       <TELL "Part of the glacier has been melted.">>)>)>>

<DEFINE TORCH-OBJECT ()
    <COND (<AND <VERB? "TRNOF"> <TRNN <PRSO> ,ONBIT>>
	   <TELL "You burn your hand as you attempt to extinguish the flame.">)>>

<DEFINE TORCH-OFF (T)
    #DECL ((T) OBJECT)
    <PUT .T ,ODESC2 "burned out ivory torch">
    <ODESC1 .T "There is a burned out ivory torch here.">
    <TRZ .T <+ ,LIGHTBIT ,ONBIT ,FLAMEBIT>>>

\
; "SUBTITLE MIRROR, MIRROR, ON THE WALL"

<DEFINE MIRROR-ROOM ()
	<COND (<VERB? "LOOK">
	       <TELL ,MIRR-DESC ,LONG-TELL1>
	       <COND (,MIRROR-MUNG!-FLAG
		      <TELL
"Unfortunately, the mirror has been destroyed by your recklessness.">)>)>>

<SETG MIRROR-MUNG!-FLAG <>>

<DEFINE MIRROR-MIRROR ("AUX" RM1 RM2 L1)
	#DECL ((RM1 RM2) ROOM (L1) <LIST [REST OBJECT]>)
	<COND (<AND <NOT ,MIRROR-MUNG!-FLAG>
		    <VERB? "RUB">>
	       <SET RM1 ,HERE>
	       <SET RM2
		 <COND (<==? .RM1 <SET RM2 <SFIND-ROOM "MIRR1">>>
			<SFIND-ROOM "MIRR2">)
		       (.RM2)>>
	       <SET L1 <ROBJS .RM1>>
	       <PUT .RM1 ,ROBJS <ROBJS .RM2>>
	       <PUT .RM2 ,ROBJS .L1>
	       <MAPF <> <FUNCTION (X) #DECL ((X) OBJECT)
				  <PUT .X ,OROOM .RM1>>
		     <ROBJS .RM1>>
	       <MAPF <> <FUNCTION (X) #DECL ((X) OBJECT)
				  <PUT .X ,OROOM .RM2>>
		     <ROBJS .RM2>>
	       <GOTO .RM2>
	       <TELL 
"There is a rumble from deep within the earth and the room shakes.">)
	      (<VERB? "LKAT" "LKIN" "EXAMI">
	       <COND (,MIRROR-MUNG!-FLAG
		      <TELL "The mirror is broken into many pieces.">)
		     (<TELL "There is an ugly person staring back at you.">)>)
	      (<VERB? "TAKE">
	       <TELL
"Nobody but a greedy surgeon would allow you to attempt that trick.">)
	      (<VERB? "MUNG" "THROW" "POKE">
	       <COND (,MIRROR-MUNG!-FLAG
		      <TELL
"Haven't you done enough already?">)
		     (<SETG MIRROR-MUNG!-FLAG T>
		      <SETG LUCKY!-FLAG <>>
		      <TELL
"You have broken the mirror.  I hope you have a seven years supply of
good luck handy.">)>)>> 

\
; "SUBTITLE AROUND AND AROUND IT GOES..."

<DEFINE CAROUSEL-ROOM () 
	<COND (<AND <VERB? "GO-IN"> ,CAROUSEL-ZOOM!-FLAG>
	       <JIGS-UP ,SPINDIZZY>)
	      (<VERB? "LOOK">
	       <TELL
"You are in a circular room with passages off in eight directions.">
	       <COND (<NOT ,CAROUSEL-FLIP!-FLAG>
		      <TELL
"Your compass needle spins wildly, and you can't get your bearings.">)>)>>

<DEFINE CAROUSEL-EXIT ()
	<COND (,CAROUSEL-FLIP!-FLAG <>)
	      (<TELL "Unfortunately, it is impossible to tell directions in here.">
	       <CAROUSEL-OUT>)>>

<DEFINE CAROUSEL-OUT ("AUX" CX)
	#DECL ((CX) <OR CEXIT NEXIT ROOM>)
	<AND <TYPE? <SET CX <NTH <REXITS ,HERE> <* 2 <+ 1 <MOD <RANDOM> 8>>>>> CEXIT>
	     <CXROOM .CX>>>

\
; "SUBTITLE THE DOME"

<DEFINE TORCH-ROOM ()
 <COND (<VERB? "LOOK">
	<TELL ,TORCH-DESC ,LONG-TELL1>
	<COND (,DOME-FLAG!-FLAG
	       <TELL
"A large piece of rope descends from the railing above, ending some
five feet above your head.">)>)>>

<DEFINE DOME-ROOM ()
	<COND (<VERB? "LOOK">
	       <TELL ,DOME-DESC ,LONG-TELL1>
	       <COND (,DOME-FLAG!-FLAG
		      <TELL 
"Hanging down from the railing is a rope which ends about ten feet
from the floor below.">)>)
	      (<VERB? "JUMP">
	       <JIGS-UP 
"I'm afraid that the leap you attempted has done you in.">)>>

<DEFINE COFFIN-CURE () 
	<COND (<MEMQ <SFIND-OBJ "COFFI"> <AOBJS ,WINNER>>
	       <SETG EGYPT-FLAG!-FLAG <>>)
	      (ELSE <SETG EGYPT-FLAG!-FLAG T>)>
	<>>

\
; "SUBTITLE LAND OF THE DEAD"


<DEFINE LLD-ROOM ("AUX" (WIN ,WINNER) (WOBJ <AOBJS .WIN>)
			(CAND <SFIND-OBJ "CANDL">) (BELL <SFIND-OBJ "BELL">)
			(FLAG <NOT ,LLD-FLAG!-FLAG>) (HERE ,HERE))
	#DECL ((WIN) ADV (WOBJ) <LIST [REST OBJECT]> (CAND BELL) OBJECT
	       (FLAG) <OR ATOM FALSE> (HERE) ROOM)
	<COND (<VERB? "LOOK">
	       <TELL ,HELLGATE ,LONG-TELL1>
	       <COND (.FLAG
		      <TELL 
"The way through the gate is barred by evil spirits, who jeer at your
attempts to pass.">)>) 
	      (<AND .FLAG <VERB? "RING"> <==? <PRSO> .BELL>>
	       <SETG XB!-FLAG T>
	       <REMOVE-OBJECT .BELL>
	       <INSERT-OBJECT <SETG LAST-IT <SFIND-OBJ "HBELL">> .HERE>
	       <TELL ,EXOR1>
	       <AND <MEMQ .CAND .WOBJ>
		    <TELL 
"In your confusion, the candles drop to the ground (and they are out).">
		    <REMOVE-OBJECT .CAND>
		    <INSERT-OBJECT .CAND .HERE>
		    <TRZ .CAND ,ONBIT>>
	       <CLOCK-ENABLE <CLOCK-INT ,XBIN 6>>
	       <CLOCK-ENABLE <CLOCK-INT ,XBHIN 20>>)
	      (<AND ,XB!-FLAG <MEMQ .CAND .WOBJ> <TRNN .CAND ,ONBIT> <NOT ,XC!-FLAG>>
	       <SETG XC!-FLAG T>
	       <TELL ,EXOR2>
	       <CLOCK-DISABLE ,XBIN>
	       <CLOCK-ENABLE <CLOCK-INT ,XCIN 3>>)
	      (<AND ,XC!-FLAG <VERB? "READ"> <==? <PRSO> <SFIND-OBJ "BOOK">>>
	       <TELL ,EXOR3 ,LONG-TELL1>
	       <REMOVE-OBJECT <SFIND-OBJ "GHOST">>
	       <SETG LLD-FLAG!-FLAG T>
	       <CLOCK-DISABLE ,XCIN>)
	      (<VERB? "EXORC">
	       <COND (.FLAG
		      <COND (<AND <MEMQ .BELL .WOBJ>
				  <MEMQ <SFIND-OBJ "BOOK"> .WOBJ>
				  <MEMQ .CAND .WOBJ>>
			     <TELL "You must perform the ceremony.">)
			    (<TELL "You are not equipped for an exorcism.">)>)
		     (<JIGS-UP ,XORCST2>)>)>>

<SETG XB!-FLAG <>>

<SETG XC!-FLAG <>>

<DEFINE XB-CINT ()
    <OR ,XC!-FLAG
	<AND <==? ,HERE <SFIND-ROOM "LLD1">>
	     <TELL ,EXOR4>>>
    <SETG XB!-FLAG <>>>

<DEFINE XC-CINT ()
    <SETG XC!-FLAG <>>
    <XB-CINT>>

<DEFINE XBH-CINT ("AUX" (LLD <SFIND-ROOM "LLD1">))
    #DECL ((LLD) ROOM)
    <REMOVE-OBJECT <SFIND-OBJ "HBELL">>
    <INSERT-OBJECT <SFIND-OBJ "BELL"> .LLD>
    <AND <==? ,HERE .LLD>
	 <TELL "The bell appears to have cooled down.">>>

<DEFINE HBELL-FUNCTION ("AUX" (PRSI <3 ,PRSVEC>))
    #DECL ((PRSI) <OR FALSE OBJECT>)
    <COND (<VERB? "TAKE">
	   <TELL "The bell is very hot and cannot be taken.">)
	  (<AND <VERB? "RING"> .PRSI>
	   <COND (<TRNN <PRSI> ,BURNBIT>
		  <TELL "The " 1 <ODESC2 <PRSI>> " burns and is consumed.">
		  <REMOVE-OBJECT <PRSI>>)
		 (<==? <PRSI> <SFIND-OBJ "HANDS">>
		  <TELL "The bell is too hot to reach.">)
		 (<TELL "The heat from the bell is too intense.">)>)
	  (<VERB? "PORON">
	   <REMOVE-OBJECT <PRSO>>
	   <TELL "The water cools the bell and is evaporated.">
	   <CLOCK-INT ,XBHIN 0>
	   <XBH-CINT>)
	  (<VERB? "RING">
	   <TELL "The bell is too hot to reach.">)>>

<DEFINE POUR-ON ()
    <COND (<==? <PRSO> <SFIND-OBJ "WATER">>
	   <COND (<OBJECT-ACTION>)
		 (<==? <OCAN <PRSI>> <SFIND-OBJ "RECEP">>
		  <TELL 
"The water enters but cannot stop the " 1 <ODESC2 <PRSI>> "from burning.">)
		 (<FLAMING? <PRSI>>
		  <REMOVE-OBJECT <PRSO>>
		  <COND (<==? <PRSI> <SFIND-OBJ "TORCH">>
			 <TELL "The water evaporates before it gets close.">)
			(<TELL "The " 1 <ODESC2 <PRSI>> " is extinguished.">)>)
		 (<TELL "The water spills over the "
			1
			<ODESC2 <PRSI>>
			" and to the floor where it evaporates.">
		  <REMOVE-OBJECT <PRSO>>)>)
	  (<TELL "You can't pour that on anything.">)>>

<DEFINE LLD2-ROOM ()
    <COND (<VERB? "LOOK">
	   <TELL ,LLD-DESC
		 ,LONG-TELL1
		 <COND (,ON-POLE!-FLAG
		                ,LLD-DESC1) ("")>>)>>

<DEFINE GHOST-FUNCTION ("AUX" (G <SFIND-OBJ "GHOST">))
  #DECL ((G) OBJECT)
  <COND (<==? <PRSI> .G>
	 <TELL "How can you attack a spirit with material objects?">
	 <>)
	(<==? <PRSO> .G>
	 <TELL "You seem unable to affect these spirits.">)>>

"SUBTITLE FLOOD CONTROL DAM #3"

<SETG GATE-FLAG!-FLAG <>>

<DEFINE DAM-ROOM () 
   <COND
    (<VERB? "LOOK">
     <TELL ,DAM-DESC ,LONG-TELL1>
     <COND (,LOW-TIDE!-FLAG
	    <TELL ,LTIDE-DESC ,LONG-TELL1>)
	   (<TELL ,HTIDE-DESC ,LONG-TELL1>)>
     <TELL 
"There is a control panel here.  There is a large metal bolt on the 
panel. Above the bolt is a small green plastic bubble." ,LONG-TELL1>
     <COND (,GATE-FLAG!-FLAG <TELL "The green bubble is glowing." 1>)>)>>

<DEFINE SQUEEZER ()
    <COND (<OBJECT-ACTION>)
	  (<TRNN <PRSO> ,VILLAIN>
	   <TELL "The " 1 <ODESC2 <PRSO>> " does not understand this.">)
	  (<TELL "How singularly useless.">)>> 

<DEFINE OIL ()
    <COND (<==? <PRSI> <SFIND-OBJ "PUTTY">>
	   <COND (<OBJECT-ACTION>)
		 (<TELL "That's not very useful.">)>)
	  (<TELL "You probably put spinach in your gas tank, too.">)>>
		  
<DEFINE BOLT-FUNCTION ("AUX" (RESER <SFIND-ROOM "RESER">) (TRUNK <SFIND-OBJ "TRUNK">)) 
	#DECL ((TRUNK) OBJECT (RESER) ROOM)
	<COND (<VERB? "TURN">
	       <COND (<==? <PRSI> <SFIND-OBJ "WRENC">>
		      <COND (,GATE-FLAG!-FLAG
			     <COND (,LOW-TIDE!-FLAG
				    <SETG LOW-TIDE!-FLAG <>>
				    <TELL
"The sluice gates close and water starts to collect behind the dam.">
				    <RTRO .RESER ,RWATERBIT>
				    <RTRZ .RESER ,RLANDBIT>
				    <AND <MEMQ .TRUNK <ROBJS .RESER>>
					 <TRZ .TRUNK ,OVISON>>
				    T)
				   (<SETG LOW-TIDE!-FLAG T>
				    <TELL
"The sluice gates open and water pours through the dam.">
				    <TRZ <SFIND-OBJ "COFFI"> ,SACREDBIT>
				    <RTRO .RESER ,RLANDBIT>
				    <RTRZ .RESER <+ ,RWATERBIT ,RSEENBIT>>
				    <TRO .TRUNK ,OVISON>)>)
			    (<TELL
"The bolt won't turn with your best effort.">)>)
		     (<TELL
"The bolt won't turn using the " 1 <ODESC2 <PRSI>> ".">)>)
	      (<VERB? "OIL">
	       <TELL 
"Hmm.  It appears the tube contained glue, not oil.  Turning the bolt
won't get any easier....">)>>

<GDECL (DROWNINGS) <VECTOR [REST STRING]>>

<SETG WATER-LEVEL!-FLAG 0>
<GDECL (WATER-LEVEL!-FLAG) FIX>

<DEFINE DBUTTONS ("AUX" HACK (HERE ,HERE))
    #DECL ((HACK) FIX (HERE) ROOM)
    <COND (<VERB? "PUSH">
	   <COND (<==? <PRSO> <SFIND-OBJ "BLBUT">>
		  <COND (<0? ,WATER-LEVEL!-FLAG>
			 <TRO <SFIND-OBJ "LEAK"> ,OVISON>
			 <RGLOBAL .HERE <CHTYPE <ORB <RGLOBAL .HERE> ,RGWATER> FIX>>
			 <TELL 
"There is a rumbling sound and a stream of water appears to burst
from the east wall of the room (apparently, a leak has occurred in a
pipe.)" ,LONG-TELL1>
			 <SETG WATER-LEVEL!-FLAG 1>
			 <CLOCK-INT ,MNTIN -1>
			 T)
			(<TELL "The blue button appears to be jammed.">)>)
		 (<==? <PRSO> <SFIND-OBJ "RBUTT">>
		  <RTRC .HERE ,RLIGHTBIT>
		  <COND (<RTRNN .HERE ,RLIGHTBIT>
			 <TELL "The lights within the room come on.">)
			(<TELL "The lights within the room shut off.">)>)
		 (<==? <PRSO> <SFIND-OBJ "BRBUT">>
		  <SETG GATE-FLAG!-FLAG <>>
		  <TELL "Click.">)
		 (<==? <PRSO> <SFIND-OBJ "YBUTT">>
		  <SETG GATE-FLAG!-FLAG T>
		  <TELL "Click.">)>)>>

<DEFINE TOOL-CHEST ()
    <COND (<VERB? "EXAMI">
	   <TELL "The chests are all empty.">)
	  (<VERB? "TAKE">
	   <TELL "The chests are fastened to the walls.">)>>

<DEFINE MAINT-ROOM ("AUX" (MNT <SFIND-ROOM "MAINT">) (HERE? <==? ,HERE .MNT>) LEV)
	#DECL ((HERE?) <OR ATOM FALSE> (MNT) ROOM (LEV) FIX)
	<COND (<VERB? "C-INT">
	       <SETG WATER-LEVEL!-FLAG <SET LEV <+ 1 ,WATER-LEVEL!-FLAG>>>
	       <COND (<AND .HERE?
			   <TELL "The water level here is now "
				 1
				 <NTH ,DROWNINGS <+ 1 </ .LEV 2>>>>>)>
	       <COND (<G=? .LEV 16>
		      <MUNG-ROOM .MNT
"The room is full of water and cannot be entered.">
		      <CLOCK-INT ,MNTIN 0>
		      <AND .HERE?
			   <JIGS-UP "I'm afraid you have done drowned yourself.">>)>)>>

<DEFINE LEAK-FUNCTION ()
	<COND (<==? <PRSO> <SFIND-OBJ "LEAK">>
	       <COND (<AND <VERB? "PLUG">
			   <G? ,WATER-LEVEL!-FLAG 0>>
		      <COND (<==? <PRSI> <SFIND-OBJ "PUTTY">>
			     <SETG WATER-LEVEL!-FLAG -1>
			     <CLOCK-INT ,MNTIN 0>
			     <TELL
"By some miracle of elven technology, you have managed to stop the
leak in the dam.">)
			    (<WITH-TELL <PRSI>>)>)>)>>

<DEFINE TUBE-FUNCTION ("AUX" (PUTTY <SFIND-OBJ "PUTTY">))
	#DECL ((PUTTY) OBJECT)
	<COND (<AND <VERB? "PUT">
		    <==? <PRSI> <SFIND-OBJ "TUBE">>>
	       <TELL "The tube refuses to accept anything.">)
	      (<VERB? "SQUEE">
	       <COND (<AND <TRNN <PRSO> ,OPENBIT>
			   <==? <PRSO> <OCAN .PUTTY>>>
		      <REMOVE-FROM <PRSO> .PUTTY>
		      <TAKE-OBJECT .PUTTY>
		      <TELL "The viscous material oozes into your hand.">)
		     (<TRNN <PRSO> ,OPENBIT>
		      <TELL "The tube is apparently empty.">)
		     (<TELL "The tube is closed.">)>)>>

<DEFINE WITH-TELL (OBJ)
    #DECL ((OBJ) OBJECT)
    <TELL "With a " 1 <ODESC2 .OBJ> "?">>

<DEFINE RESERVOIR-SOUTH () 
	<COND (<VERB? "LOOK">
	       <COND (,LOW-TIDE!-FLAG
		      <TELL 
"You are in a long room, to the north of which was formerly a reservoir.">
		      <TELL ,RESDESC ,LONG-TELL1>)
		     (<TELL 
"You are in a long room on the south shore of a large reservoir.">)>
	       <TELL 
"There is a western exit, a passageway south, and a steep pathway
climbing up along the edge of a cliff." ,LONG-TELL1>)>>

<DEFINE RESERVOIR ()
   	<COND (<VERB? "LOOK">
	       <COND (,LOW-TIDE!-FLAG
		      <TELL
"You are on what used to be a large reservoir, but which is now a large
mud pile.  There are 'shores' to the north and south." ,LONG-TELL1>)
		     (<TELL ,RESER-DESC ,LONG-TELL1>)>)>>

<DEFINE RESERVOIR-NORTH () 
	<COND (<VERB? "LOOK">
	       <COND (,LOW-TIDE!-FLAG
		      <TELL 
"You are in a large cavernous room, the south of which was formerly
a reservoir.">
		      <TELL ,RESDESC ,LONG-TELL1>)
		     (<TELL
"You are in a large cavernous room, north of a large reservoir.">)>
	       <TELL "There is a tunnel leaving the room to the north.">)>>

\

; "SUBTITLE WATER, WATER EVERYWHERE..."

<DEFINE BOTTLE-FUNCTION ("AUX" WATER)
  #DECL ((WATER) OBJECT)
  <COND (<VERB? "THROW">
	 <TELL "The bottle hits the far wall and shatters.">
	 <REMOVE-OBJECT <PRSO>>)
	(<VERB? "MUNG">
	 <REMOVE-OBJECT <PRSO>>
	 <TELL "A brilliant maneuver destroys the bottle.">)
	(<VERB? "SHAKE">
	 <COND (<AND <TRNN <PRSO> ,OPENBIT>
		     <==? <OCAN <SFIND-OBJ "WATER">> <PRSO>>>
		<TELL "The water spills to the floor and evaporates.">
		<REMOVE-OBJECT .WATER>
		T)>)>>
	
<DEFINE FILL FILL ("AUX" (PRSVEC ,PRSVEC))
  #DECL ((FILL) ACTIVATION (PRSVEC) VECTOR)
  <COND (<EMPTY? <PRSI>>
	 <COND (<GTRNN ,HERE ,RGWATER>
		<PUT .PRSVEC 3 <SFIND-OBJ "GWATE">>)
	       (<TELL "With what?">
		<ORPHAN T
			<FIND-ACTION "FILL">
			<PRSO>
			<PLOOKUP "WITH" ,WORDS-POBL>>
		<SETG PARSE-WON <>>
		<RETURN <> .FILL>)>)>
  <COND (<OBJECT-ACTION>)
	(<N==? <PRSI> <SFIND-OBJ "WATER">>
	 <PERFORM PUTTER <FIND-VERB "PUT"> <PRSI> <PRSO>>)>>

<DEFINE WATER-FUNCTION WATER-FN ("AUX" (ME ,WINNER) (B <SFIND-OBJ "BOTTL">)
			      (PRSVEC ,PRSVEC) (AV <AVEHICLE .ME>) W
			      (GW <SFIND-OBJ "GWATE">) (RW <SFIND-OBJ "WATER">)
			      PI?)
	#DECL ((ME) ADV (GW RW B) OBJECT (WATER-FN) ACTIVATION
	       (PRSVEC) VECTOR (AV) <OR OBJECT FALSE> (W) OBJECT (PI?) <OR ATOM FALSE>)
	<COND (<VERB? "GTHRO">
	       <TELL <PICK-ONE ,SWIMYUKS>>
	       <RETURN T .WATER-FN>)
	      (<VERB? "FILL">
	       <SET W <PRSI>>
	       <PUT .PRSVEC 1 <FIND-VERB "PUT">>
	       <PUT .PRSVEC 3 <PRSO>>
	       <PUT .PRSVEC 2 .W>
	       <SET PI? <>>)
	      (<OR <==? <PRSO> .GW>
		   <==? <PRSO> .RW>>
	       <SET W <PRSO>>
	       <SET PI? <>>)
	      (<SET W <PRSI>>
	       <SET PI? T>)>		; "Turn FILL into PUT"
	<COND (<==? .W .GW>
	       <SET W .RW>
	       <COND (<VERB? "TAKE" "PUT">
		      <REMOVE-OBJECT .W>)>)>
	<COND (.PI? <PUT .PRSVEC 3 .W>)
	      (T <PUT .PRSVEC 2 .W>)>
	<COND (<AND <VERB? "TAKE" "PUT">
		    <NOT .PI?>>
	       <COND (<AND .AV <OR <==? .AV <PRSI>>
				   <AND <EMPTY? <PRSI>>
					<N==? <OCAN .W> .AV>>>>
		      <TELL "There is now a puddle in the bottom of the "
			    1
			    <ODESC2 .AV>
			    ".">
		      <REMOVE-OBJECT <PRSO>>
		      <COND (<==? <OCAN <PRSO>> .AV>)
			    (<INSERT-INTO .AV <PRSO>>)>)
		     (<AND <NOT <EMPTY? <PRSI>>> <N==? <PRSI> .B>>
		      <TELL "The water leaks out of the " 1 <ODESC2 <PRSI>>
			    " and evaporates immediately.">
		      <REMOVE-OBJECT .W>)
		     (<MEMQ .B <AOBJS .ME>>
		      <COND (<NOT <TRNN .B ,OPENBIT>>
			     <TELL "The bottle is closed.">)
			    (<NOT <EMPTY? <OCONTENTS .B>>>)
			    (T
			     <REMOVE-OBJECT .RW>
			     <INSERT-INTO .B .RW>
			     <TELL "The bottle is now full of water.">)>)
		     (<AND <==? <OCAN <PRSO>> .B>
			   <VERB? "TAKE">
			   <EMPTY? <PRSI>>>
		      <PUT .PRSVEC 2 .B>
		      <TAKE T>
		      <PUT .PRSVEC 2 .W>)
		     (<TELL "The water slips through your fingers.">)>)
	      (.PI?
	       <TELL "Nice try.">)
	      (<VERB? "DROP" "POUR" "GIVE">
	       <REMOVE-OBJECT .RW>
	       <COND (.AV
		      <TELL "There is now a puddle in the bottom of the "
			    1
			    <ODESC2 .AV>
			    ".">
		      <INSERT-INTO .AV .RW>)
		     (<TELL "The water spills to the floor and evaporates immediately.">
	       	      <REMOVE-OBJECT .RW>)>)
	      (<VERB? "THROW">
	       <TELL "The water splashes on the walls, and evaporates immediately.">
	       <REMOVE-OBJECT .RW>)>>

\
; "SUBTITLE CYCLOPS"

<SETG CYCLOWRATH!-FLAG 0>

<DEFINE CYCLOPS ("AUX" (RM ,HERE) (CYC <SFIND-OBJ "CYCLO">)
		       (FOOD <SFIND-OBJ "FOOD">) (DRINK <SFIND-OBJ "WATER">)
		       (COUNT ,CYCLOWRATH!-FLAG))
	#DECL ((RM) ROOM (FOOD DRINK CYC) OBJECT (COUNT) FIX)
	<COND (,CYCLOPS-FLAG!-FLAG
	       <COND (<VERB? "WAKE" "KICK" "ATTAC" "BURN" "DESTR">
		      <TELL 
"The cyclops yawns and stares at the thing that woke him up.">
		      <SETG CYCLOPS-FLAG!-FLAG <>>
		      <TRZ .CYC ,SLEEPBIT>
		      <TRO .CYC ,FIGHTBIT>
		      <SETG CYCLOWRATH!-FLAG <ABS .COUNT>>)>)
	      (<VERB? "GIVE">
	       <COND (<==? <PRSO> .FOOD>
		      <COND (<G=? .COUNT 0>
			     <REMOVE-OBJECT .FOOD>
			     <TELL ,CYCLOFOOD ,LONG-TELL1>
			     <SETG CYCLOWRATH!-FLAG <MIN -1 <- .COUNT>>>)>
		      <CLOCK-INT ,CYCIN -1>)
		     (<==? <PRSO> .DRINK>
		      <COND (<L? .COUNT 0>
			     <REMOVE-OBJECT .DRINK>
			     <TRO .CYC ,SLEEPBIT>
			     <TRZ .CYC ,FIGHTBIT>
			     <TELL 
"The cyclops looks tired and quickly falls fast asleep (what did you
put in that drink, anyway?)."
				   ,LONG-TELL1>
			     <SETG CYCLOPS-FLAG!-FLAG T>)
			    (<TELL 
"The cyclops apparently is not thirsty and refuses your generosity.">
			     <>)>)
		     (<==? <PRSO> <SFIND-OBJ "GARLI">>
		      <TELL "The cyclops may be hungry, but there is a limit.">)
		     (<TELL "The cyclops is not so stupid as to eat THAT!">)>)
	      (<VERB? "KILL" "THROW" "ATTAC" "DESTR" "POKE">
	       <CLOCK-INT ,CYCIN -1>
	       <COND (<VERB? "POKE">
		      <TELL
"'Do you think I'm as stupid as my father was?', he says, dodging.">)
		     (<TELL 
"The cyclops ignores all injury to his body with a shrug.">)>)
	      (<VERB? "TAKE">
	       <TELL "The cyclops doesn't take kindly to being grabbed.">)
	      (<VERB? "TIE">
	       <TELL "You cannot tie the cyclops, though he is fit to be tied.">)
	      (<VERB? "C-INT">
	       <COND (<==? ,HERE <SFIND-ROOM "CYCLO">>
		      <COND (<G? <ABS .COUNT> 5>
			     <CLOCK-DISABLE ,CYCIN>
			     <JIGS-UP ,CYCLOKILL>)
			    (<SETG CYCLOWRATH!-FLAG <AOS-SOS .COUNT>>)>)
		     (<CLOCK-DISABLE ,CYCIN>)>)>>

<DEFINE CYCLOPS-ROOM ("AUX" (WRATH ,CYCLOWRATH!-FLAG))
	#DECL ((WRATH) FIX)
	<COND (<VERB? "LOOK">
	       <TELL 
"This room has an exit on the west side, and a staircase leading up.">
	       <COND (,MAGIC-FLAG!-FLAG
		      <TELL 
"The north wall, previously solid, now has a cyclops-sized hole in it.">)
		     (<AND ,CYCLOPS-FLAG!-FLAG
			   <TRNN <SFIND-OBJ "CYCLO"> ,SLEEPBIT>>
		      <TELL 
"The cyclops is sleeping blissfully at the foot of the stairs.">)
		     (<0? .WRATH> <TELL ,CYCLOLOOK>)
		     (<G? .WRATH 0> <TELL ,CYCLOEYE>)
		     (<L? .WRATH 0>
		      <TELL 
"The cyclops, having eaten the hot peppers, appears to be gasping.
His enflamed tongue protrudes from his man-sized mouth.">)>)
	      (<VERB? "GO-IN">
	       <OR <0? ,CYCLOWRATH!-FLAG> <CLOCK-ENABLE ,CYCIN>>)>>

<GDECL (CYCLOMAD) <VECTOR [REST STRING]>>

<DEFINE AOS-SOS (FOO)
  #DECL ((FOO) FIX)
  <COND (<L? .FOO 0> <SET FOO <- .FOO 1>>)
	(<SET FOO <+ .FOO 1>>)>
  <COND (,CYCLOPS-FLAG!-FLAG)
	(<TELL <NTH ,CYCLOMAD <ABS .FOO>>>)>
  .FOO>

\
; "SUBTITLE ECHO ECHO ECHO"

<SETG ECHO-FLAG!-FLAG <>>

<DEFINE ECHO-ROOM ("AUX" 
		   (B ,INBUF) L (RM <SFIND-ROOM "ECHO">) (OUTCHAN ,OUTCHAN)
		   (WALK <FIND-VERB "WALK">) (PRSVEC ,PRSVEC) V
		   (BUG <FIND-VERB "BUG">) (FEATURE <FIND-VERB "FEATU">)) 
	#DECL ((OUTCHAN) CHANNEL (WALK) VERB (PRSVEC) <VECTOR VERB [2 ANY]>
	       (B) STRING (L) FIX (RM) ROOM (V) <OR VECTOR FALSE>
	       (BUG FEATURE) VERB)
	<COND (<OR ,ECHO-FLAG!-FLAG
		   ,DEAD!-FLAG>)
	      (<UNWIND
		<PROG ()
		 <REPEAT (RANDOM-ACTION)
		       #DECL ((RANDOM-ACTION) <OR ATOM FALSE NOFFSET>)
		       <SET L
			    <READST .B "" <>>>
		       <SETG MOVES <+ ,MOVES 1>>
		       <COND (<AND <SET V <LEX .B <REST .B .L>>>
				   <EPARSE .V T>
				   <==? <PRSA> .WALK>
				   <NOT <EMPTY? <PRSO>>>
				   <MEMQ <2 .PRSVEC> <REXITS .RM>>>
			      <SET RANDOM-ACTION <VFCN <PRSA>>>
			      <APPLY-RANDOM .RANDOM-ACTION>
			      <RETURN T>)
			     (<==? <PRSA> .BUG>
			      <TELL "Feature">)
			     (<==? <PRSA> .FEATURE>
			      <TELL "That's right.">)
			     (<PRINTSTRING .B .OUTCHAN .L>
			      <SETG TELL-FLAG T>
			      <CRLF>
			      <COND (<==? <MEMBER "ECHO" <UPPERCASE .B>> .B>
				     <TELL "The acoustics of the room change subtly.">
				     <TRZ <SFIND-OBJ "BAR"> ,SACREDBIT>
				     <SETG ECHO-FLAG!-FLAG T>
				     <RETURN T>)>)>>>
		<PROG ()
		      <GOTO <SFIND-ROOM "CHAS3">>
		      <SETG MOVES <+ ,MOVES 1>>>>)>>

<SETG EGG-SOLVE!-FLAG <>>

\
; "SUBTITLE A SEEDY LOOKING GENTLEMAN..."

<DEFINE ROBBER ROBBER (HACK
		       "AUX" (RM <HROOM .HACK>) ROBJ
			     (SEEN? <RTRNN .RM ,RSEENBIT>) (WIN ,PLAYER) (WROOM ,HERE)
			     (HOBJ <HOBJ .HACK>) (STILL <SFIND-OBJ "STILL">) 
			     HERE? (HH <HOBJS .HACK>) (TREAS <SFIND-ROOM "TREAS">)
			     EGG LIT? (DEAD? ,DEAD!-FLAG))
   #DECL ((HACK) HACK (RM WROOM) ROOM (ROBJ HH) <LIST [REST OBJECT]>
	  (DEAD? SEEN? LIT?) <OR ATOM FALSE> (WIN) ADV (EGG HOBJ) OBJECT
	  (ROBBER) ACTIVATION
	  (HERE?) <OR ROOM FALSE> (STILL) OBJECT (TREAS) ROOM)
   <PROG ((ONCE <>) OBJT)
     #DECL ((ONCE) <OR ATOM FALSE> (OBJT) <LIST [REST OBJECT]>)
     <COND (<SET HERE? <OROOM .HOBJ>>
	    <SET RM .HERE?>)>
     <SET ROBJ <ROBJS .RM>>
     <SET OBJT .HH>
     <COND
      (<AND <==? .RM .TREAS>
	    <N==? .RM .WROOM>>
       <COND (.HERE?
	      <COND (<==? <OROOM .STILL> .TREAS>
		     <SNARF-OBJECT .HOBJ .STILL>)>
	      <REMOVE-OBJECT .HOBJ>
	      <MAPF <>
	        <FUNCTION (X) #DECL ((X) OBJECT)
		  <TRO .X ,OVISON>>
		<ROBJS .RM>>
	      <SET HERE? <>>)>
       <SET EGG <SFIND-OBJ "EGG">>
       <MAPF <>
	     <FUNCTION (X) 
		     #DECL ((X) OBJECT)
		     <COND (<G? <OTVAL .X> 0>
			    <PUT .HACK ,HOBJS <SET HH <SPLICE-OUT .X .HH>>>
			    <INSERT-OBJECT .X .RM>
			    <COND (<==? .X .EGG>
				   <SETG EGG-SOLVE!-FLAG T>
				   <TRO .X ,OPENBIT>)>)>>
	     .HH>)
      (<AND <==? .RM .WROOM>
	    <NOT <RTRNN .RM ,RLIGHTBIT>>> ;"Adventurer is in room:  CHOMP, CHOMP"
       <SET LIT? <LIT? .RM>>	; "We want to see if we left the loser in the dark."
       <COND
	(<AND <NOT .DEAD?> <==? .RM .TREAS>>)	; "Don't move, Gertrude"
        (<NOT <HFLAG .HACK>>
         <COND (<AND <NOT .DEAD?> <NOT .HERE?> <PROB 30>>
	        <COND (<==? <OCAN .STILL> .HOBJ>
		       <INSERT-OBJECT .HOBJ .RM>
		       <TELL 
"Someone carrying a large bag is casually leaning against one of the
walls here.  He does not speak, but it is clear from his aspect that
the bag will be taken only over his dead body." ,LONG-TELL1>
		       <PUT .HACK ,HFLAG T>
		       <RETURN T .ROBBER>)>)
	       (<AND .HERE?
		     <TRNN .HOBJ ,FIGHTBIT>
		     <COND (<NOT <WINNING? .HOBJ .WIN>>
			    <TELL
"Your opponent, determining discretion to be the better part of
valor, decides to terminate this little contretemps.  With a rueful
nod of his head, he steps backward into the gloom and disappears." ,LONG-TELL1>
			    <REMOVE-OBJECT .HOBJ>
			    <TRZ .HOBJ ,FIGHTBIT>
			    <SNARF-OBJECT .HOBJ .STILL>
			    <RETURN T .ROBBER>)
			   (<PROB 90>)>>)
	       (<AND .HERE? <PROB 30>>
	        <TELL 
"The holder of the large bag just left, looking disgusted. 
Fortunately, he took nothing.">
		<REMOVE-OBJECT .HOBJ>
		<SNARF-OBJECT .HOBJ .STILL>
	        <RETURN T .ROBBER>)
	       (<PROB 70> <RETURN T .ROBBER>)
	       (<NOT .DEAD?>
		<COND (<MEMQ .STILL <HOBJS .HACK>>
		       <PUT .HACK ,HOBJS <SPLICE-OUT .STILL <HOBJS .HACK>>>
		       <PUT .HOBJ ,OCONTENTS (.STILL)>
		       <PUT .STILL ,OCAN .HOBJ>)>
		<PUT .HACK ,HOBJS <SET HH <ROB-ROOM .RM .HH 100>>>
	        <PUT .HACK ,HOBJS <SET HH <ROB-ADV .WIN .HH>>>
	        <PUT .HACK ,HFLAG T>
	        <COND (<AND <N==? .OBJT .HH> <NOT .HERE?>>
		       <TELL 
"A seedy-looking individual with a large bag just wandered through
the room.  On the way through, he quietly abstracted all valuables
from the room and from your possession, mumbling something about
\"Doing unto others before..\"" ,LONG-TELL1>)
		      (.HERE?
		       <SNARF-OBJECT .HOBJ .STILL>
		       <COND (<N==? .OBJT .HH>
			      <TELL 
"The other occupant just left, still carrying his large bag.  You may
not have noticed that he robbed you blind first.">)
			     (<TELL 
"The other occupant (he of the large bag), finding nothing of value,
left disgusted.">)>
		       <REMOVE-OBJECT .HOBJ>
		       <SET HERE? <>>)
		      (T
		       <TELL 

"A 'lean and hungry' gentleman just wandered through, carrying a
large bag.  Finding nothing of value, he left disgruntled.">)>)>)
	(T
	 <COND (.HERE?			;"Here, already announced."
		<COND (<PROB 30>
		       <PUT .HACK ,HOBJS <SET HH <ROB-ROOM .RM .HH 100>>>
		       <PUT .HACK ,HOBJS <SET HH <ROB-ADV .WIN .HH>>>
		       <COND (<MEMQ <SFIND-OBJ "ROPE"> .HH>
			      <SETG DOME-FLAG!-FLAG <>>)>
		       <COND (<==? .OBJT .HH>
			      <TELL
"The other occupant (he of the large bag), finding nothing of value,
left disgusted.">)
			     (T
			      <TELL
"The other occupant just left, still carrying his large bag.  You may
not have noticed that he robbed you blind first.">)>
		       <REMOVE-OBJECT .HOBJ>
		       <SET HERE? <>>
		       <SNARF-OBJECT .HOBJ .STILL>)
		      (<RETURN T .ROBBER>)>)>)>
       <COND (<AND <NOT <LIT? .RM>>
		   .LIT?
		   <==? <AROOM .WIN> .RM>>
	      <TELL "The thief seems to have left you in the dark.">)>)
      (<AND <MEMQ .HOBJ <ROBJS .RM>>	;"Leave if victim left"
	    <SNARF-OBJECT .HOBJ .STILL>
	    <REMOVE-OBJECT .HOBJ>
	    <SET HERE? <>>>)
      (<AND <==? <OROOM .STILL> .RM>
	    <SNARF-OBJECT .HOBJ .STILL>
	    <>>)
      (.SEEN?				     ;"Hack the adventurer's belongings"
       <PUT .HACK ,HOBJS <SET HH <ROB-ROOM .RM .HH 75>>>
       <COND
	(<AND <==? <RDESC2 .RM> ,MAZEDESC> <==? <RDESC2 .WROOM> ,MAZEDESC>>
	 <MAPF <>
	       <FUNCTION (X) 
		       #DECL ((X) OBJECT)
		       <COND (<AND <TRNN .X ,TAKEBIT> <TRNN .X ,OVISON> <PROB 40>>
			      <TELL 
"You hear, off in the distance, someone saying \"My, I wonder what
this fine "		      3 <ODESC2 .X> " is doing here.\"">
			      <TELL "" 1>
			      <COND (<PROB 60 80>
				     <REMOVE-OBJECT .X>
				     <TRO .X ,TOUCHBIT>
				     <PUT .HACK ,HOBJS <SET HH (.X !.HH)>>)>
			      <MAPLEAVE>)>>
	       <ROBJS .RM>>)
	(<MAPF <>
	       <FUNCTION (X) 
		       #DECL ((X) OBJECT)
		       <COND (<AND <0? <OTVAL .X>>
				   <TRNN .X ,TAKEBIT>
				   <TRNN .X ,OVISON>
				   <PROB 20 40>>
			      <REMOVE-OBJECT .X>
			      <TRO .X ,TOUCHBIT>
			      <PUT .HACK ,HOBJS <SET HH (.X !.HH)>>
			      <COND (<==? .RM .WROOM>
				     <TELL "You suddenly notice that the "
					   1
					   <ODESC2 .X>
					   " vanished.">)>
			      <MAPLEAVE>)>>
	       <ROBJS .RM>>
	 <COND (<MEMQ <SFIND-OBJ "ROPE"> .HH>
		<SETG DOME-FLAG!-FLAG <>>)>)>)>
     <COND (<SET ONCE <NOT .ONCE>>		 ;"Move to next room, and hack."
	    <PROG ((ROOMS <HROOMS .HACK>))
	      #DECL ((ROOMS) <LIST [REST ROOM]>)
	      <SET RM <1 .ROOMS>>
	      <COND (<EMPTY? <SET ROOMS <REST .ROOMS>>>
		     <SET ROOMS ,ROOMS>)>
	      <COND (<OR <RTRNN .RM ,RSACREDBIT>
			 <RTRNN .RM ,RENDGAME>
			 <NOT <RTRNN .RM ,RLANDBIT>>>	;"Can I work here?"
		     <AGAIN>)>
	      <PUT .HACK ,HROOM .RM>
	      <PUT .HACK ,HFLAG <>>
	      <PUT .HACK ,HROOMS .ROOMS>
	      <SET SEEN? <RTRNN .RM ,RSEENBIT>>>
	    <AGAIN>)>>			      ;"Drop worthless cruft, sometimes"
   <OR <==? .RM .TREAS>
       <MAPF <>
	     <FUNCTION (X) 
		     #DECL ((X) OBJECT)
		     <COND (<AND <0? <OTVAL .X>> <PROB 30 70>>
			    <PUT .HACK ,HOBJS <SET HH <SPLICE-OUT .X .HH>>>
			    <INSERT-OBJECT .X .RM>
			    <AND <==? .RM .WROOM>
				 <TELL 
"The robber, rummaging through his bag, dropped a few items he found
valueless." >>)>>
	      .HH>>>

<DEFINE ROBBER-FUNCTION ("AUX" (DEM <GET-DEMON "THIEF">) (HERE ,HERE) (FLG <>)
			 ST (T <HOBJ .DEM>) (CHALI <SFIND-OBJ "CHALI">))
  #DECL ((DEM) HACK (T HOBJ ST CHALI) OBJECT (HERE) ROOM (FLG) <OR ATOM FALSE>)
  <COND (<VERB? "FGHT?">
	 <COND (<==? <OCAN <SET ST <SFIND-OBJ "STILL">>> .T> <>)
	       (<==? <OROOM .ST> .HERE>
		<SNARF-OBJECT .T .ST>
		<TELL
"The robber, somewhat surprised at this turn of events, nimbly
retrieves his stilletto.">
		T)>)
	(<VERB? "DEAD!">
	 <COND (<NOT <EMPTY? <HOBJS .DEM>>>
		<TELL "  His booty remains.">
		<MAPF <> <FUNCTION (X) #DECL ((X) OBJECT)
				   <INSERT-OBJECT .X .HERE>>
		      <HOBJS .DEM>>
		<PUT .DEM ,HOBJS ()>)>
	 <COND (<==? .HERE <SFIND-ROOM "TREAS">>
		<MAPF <>
		  <FUNCTION (X) #DECL ((X) OBJECT)
		    <COND (<AND <N==? .X .CHALI>
				<N==? .X .T>>
			   <COND (<TRO .X ,OVISON>
				  <COND (<NOT .FLG>
					 <SET FLG T>
					 <TELL
"As the thief dies, the power of his magic decreases, and his
treasures reappear:" 2>)>
				  <TELL "  A " 2 <ODESC2 .X>>
				  <COND (<AND <NOT <EMPTY? <OCONTENTS .X>>>
					      <SEE-INSIDE? .X>>
					 <TELL ", with ">
					 <PRINT-CONTENTS <OCONTENTS .X>>)>)>)>>
		  <ROBJS .HERE>>)>
	 <PUT .DEM ,HACTION <>>)
	(<VERB? "1ST?"> <PROB 20 75>)
	(<VERB? "OUT!">
	 <PUT .DEM ,HACTION <>>
	 <TRZ <SFIND-OBJ "STILL"> ,OVISON>
	 <ODESC1 .T ,ROBBER-U-DESC>)
	(<AND <VERB? "HELLO">
	      <==? <ODESC1 .T> ,ROBBER-U-DESC>>
	 <TELL
"The thief, being temporarily incapacitated, is unable to acknowledge
your greeting with his usual graciousness.">)
	(<VERB? "IN!">
	 <COND (<==? <HROOM .DEM> .HERE>
		<TELL
"The robber revives, briefly feigning continued unconsciousness, and
when he sees his moment, scrambles away from you.">)>
	 <COND (<TYPE? ,ROBBER NOFFSET> <PUT .DEM ,HACTION ,ROBBER>)
	       (<PUT .DEM ,HACTION ROBBER>)>
	 <ODESC1 .T ,ROBBER-C-DESC>
	 <TRO <SFIND-OBJ "STILL"> ,OVISON>)
	(<AND <==? <PRSO> <SFIND-OBJ "KNIFE">>
	      <VERB? "THROW">
	      <NOT <TRNN .T ,FIGHTBIT>>>
	 <COND (<PROB 10 0>
		<TELL
"You evidently frightened the robber, though you didn't hit him.  He
flees"		 1
		 <COND (<EMPTY? <HOBJS .DEM>>
		        ".")
		       (T
		        <MAPF <> <FUNCTION (X) #DECL ((X) OBJECT)
					   <INSERT-OBJECT .X .HERE>> <HOBJS .DEM>>
			<PUT .DEM ,HOBJS ()>
		        ", but the contents of his bag fall on the floor.")>>
		<REMOVE-OBJECT .T>)
	       (T
		<TELL
"You missed.  The thief makes no attempt to take the knife, though it
would be a fine addition to the collection in his bag.  He does seem
angered by your attempt." ,LONG-TELL1>
		<TRO .T ,FIGHTBIT>)>)
	(<AND <VERB? "THROW" "GIVE">
	      <NOT <EMPTY? <PRSO>>>
	      <N==? <PRSO> <HOBJ .DEM>>>
	 <COND (<L? <OSTRENGTH .T> 0>
		<OSTRENGTH .T <- <OSTRENGTH .T>>>
		<PUT .DEM ,HACTION <COND (<TYPE? ,ROBBER NOFFSET> ,ROBBER)
					 (ROBBER)>>
		<TRO <SFIND-OBJ "STILL"> ,OVISON>
		<ODESC1 .T ,ROBBER-C-DESC>
		<TELL
"Your proposed victim suddenly recovers consciousness.">)>
	 <COND (<BOMB? <PRSO>>
		; "I.e., he's trying to give us the brick with a lighted fuse."
		<TELL 
"The thief seems rather offended by your offer.  Do you think he's as
stupid as you are?">)
	       (<REMOVE-OBJECT <PRSO>>
		<PUT .DEM ,HOBJS (<PRSO> !<HOBJS .DEM>)>
		<COND (<G? <OTVAL <PRSO>> 0>
		       <SETG THIEF-ENGROSSED!-FLAG T>
		       <TELL
"The thief is taken aback by your unexpected generosity, but accepts
the " 1 <ODESC2 <PRSO>> " and stops to admire its beauty.">)
		      (<TELL
"The thief places the " 1 <ODESC2 <PRSO>> " in his bag and thanks
you politely.">)>)>)
	(<VERB? "TAKE">
	 <TELL
"Once you got him, what would you do with him?">)>>

<DEFINE BOMB? (O "AUX" BRICK FUSE F)
	#DECL ((O BRICK FUSE) OBJECT (F) <VECTOR ANY CEVENT>)
	<AND <==? .O <SET BRICK <SFIND-OBJ "BRICK">>>
	     <==? <OCAN <SET FUSE <SFIND-OBJ "FUSE">>> .BRICK>
	     <SET F <OLINT .FUSE>>
	     <NOT <0? <CTICK <2 .F>>>>>>

<DEFINE CHALICE ("AUX" TR T)
	#DECL ((TR) ROOM (T) OBJECT)
	<COND (<VERB? "TAKE">
	       <COND (<AND <NOT <OCAN <PRSO>>>
			   <==? <OROOM <PRSO>> <SET TR <SFIND-ROOM "TREAS">>>
			   <==? <OROOM <SET T <SFIND-OBJ "THIEF">>> .TR>
			   <TRNN .T ,FIGHTBIT>
			   <HACTION ,ROBBER-DEMON>
			   <N==? <ODESC1 .T> ,ROBBER-U-DESC>>
		      <TELL
"Realizing just in time that you'd be stabbed in the back if you
attempted to take the chalice, you return to the fray.">)>)>>

<DEFINE TREASURE-ROOM ("AUX" (HACK ,ROBBER-DEMON) (HOBJ <HOBJ .HACK>)
		       (FLG <>) TL (HERE ,HERE) (ROOMS ,ROOMS))
  #DECL ((HACK) HACK (HOBJ) OBJECT (FLG) <OR ATOM FALSE>
	 (TL ROOMS) <LIST [REST ROOM]> (HERE) ROOM)
  <COND (<AND <HACTION .HACK>
	      <VERB? "GO-IN">>
	 <COND (<SET FLG <N==? <OROOM .HOBJ> .HERE>>
		<TELL
"You hear a scream of anguish as you violate the robber's hideaway. 
Using passages unknown to you, he rushes to its defense.">
		<COND (<OROOM .HOBJ>
		       <REMOVE-OBJECT .HOBJ>)>
		<TRO .HOBJ ,FIGHTBIT>
		<PUT .HACK ,HROOM .HERE>
		<PUT .HACK ,HROOMS <COND (<EMPTY? <SET TL <REST <MEMQ .HERE .ROOMS>>>>
					  .ROOMS)
					 (.TL)>>
		<INSERT-OBJECT .HOBJ .HERE>)
	       (T
		<TRO .HOBJ ,FIGHTBIT>)>
	 <THIEF-IN-TREASURE .HOBJ>)>>

<DEFINE THIEF-IN-TREASURE (HOBJ "AUX" (CHALI <SFIND-OBJ "CHALI">) (HERE ,HERE))
  #DECL ((CHALI) OBJECT (HERE) ROOM)
  <COND (<NOT <LENGTH? <ROBJS .HERE> 2>>
	 <TELL
"The thief gestures mysteriously, and the treasures in the room
suddenly vanish.">)>
  <MAPF <>
	<FUNCTION (X) #DECL ((X) OBJECT)
		  <COND (<AND <N==? .X .CHALI>
			      <N==? .X .HOBJ>>
			 <TRZ .X ,OVISON>)>>
	<ROBJS .HERE>>>

<DEFINE TREAS ("AUX" (HERE ,HERE)) 
	#DECL ((HERE) ROOM)
	<COND (<AND <VERB? "TREAS">
		    <==? .HERE <SFIND-ROOM "TEMP1">>>
	       <GOTO <SFIND-ROOM "TREAS">>
	       <ROOM-INFO>)
	      (<AND <VERB? "TEMPL">
		    <==? .HERE <SFIND-ROOM "TREAS">>>
	       <GOTO <SFIND-ROOM "TEMP1">>
	       <ROOM-INFO>)
	      (T <TELL "Nothing happens.">)>>

\

; "SUBTITLE RANDOM VERBS"

<DEFINE SINBAD ("AUX" (C <SFIND-OBJ "CYCLO">))
    #DECL ((C) OBJECT)
    <COND (<AND <==? ,HERE <SFIND-ROOM "CYCLO">>
		<MEMQ .C <ROBJS ,HERE>>>
	   <SETG CYCLOPS-FLAG!-FLAG T>
	   <TELL
"The cyclops, hearing the name of his father's deadly nemesis, flees the room
by knocking down the wall on the north of the room.">
	   <SETG MAGIC-FLAG!-FLAG T>
	   <TRZ .C ,FIGHTBIT>
	   <REMOVE-OBJECT .C>)
	  (<TELL 
"Wasn't he a sailor?">)>>

<DEFINE GRANITE ("AUX" (HERE ,HERE))
    #DECL ((HERE) ROOM)
    <COND (<VERB? "FIND">
	   <COND (<OR <==? .HERE <SFIND-ROOM "TEMP1">>
		      <==? .HERE <SFIND-ROOM "TREAS">>>
		  <TELL "The north wall is solid granite here.">)
		 (<TELL "There is no granite wall here.">)>)
	  (<TELL "I see no granite wall here.">)>>

<GDECL (DUMMY) <VECTOR [REST STRING]>>

<DEFINE BRUSH ("AUX")
    <COND (<==? <PRSO> <SFIND-OBJ "TEETH">>
	   <COND (<AND <==? <PRSI> <SFIND-OBJ "PUTTY">>
		       <MEMQ <PRSI> <AOBJS ,WINNER>>>
		  <JIGS-UP
"Well, you seem to have been brushing your teeth with some sort of
glue. As a result, your mouth gets glued together (with your nose)
and you die of respiratory failure.">)
		 (<EMPTY? <PRSI>>
		  <TELL
"Dental hygiene is highly recommended, but I'm not sure what you want
to brush them with.">)
		 (<TELL
"A nice idea, but with a " 1 <ODESC2 <PRSI>> "?">)>)
	  (<TELL
"If you wish, but I can't understand why??">)>>

<DEFINE LEAVE ("AUX" (PV ,PRSVEC))
    #DECL ((PV) VECTOR)
    <PUT .PV 2 <FIND-DIR "EXIT">>
    <PUT .PV 1 <FIND-VERB "WALK">>
    <WALK>>

<DEFINE ADVENT ()
    <TELL "A hollow voice says 'Cretin'">>

<DEFINE RING ()
    <COND (<OBJECT-ACTION>)
	  (<==? <PRSO> <SFIND-OBJ "BELL">>
	   <TELL
"Ding, dong.">)
	  (<TELL
"How, exactly, can I ring that?">)>>

<DEFINE EAT ("AUX" (EAT? <>) (DRINK? <>)
	     (NOBJ <>) (AOBJS <AOBJS ,WINNER>))
    #DECL ((NOBJ) <OR OBJECT FALSE> (AOBJS) <LIST [REST OBJECT]>
	   (EAT? DRINK?) <OR ATOM FALSE>)
    <COND (<OBJECT-ACTION>)
	  (<AND <SET EAT? <TRNN <PRSO> ,FOODBIT>> <MEMQ <PRSO> .AOBJS>>
	   <COND (<VERB? "DRINK">
		  <TELL "How can I drink that?">)
		 (<TELL
"Thank you very much.  It really hit the spot.">
		  <REMOVE-OBJECT <PRSO>>)>)
	  (<SET DRINK? <TRNN <PRSO> ,DRINKBIT>>
	   <COND (<OR <NOT <0? <OGLOBAL <PRSO>>>>
		      <AND <SET NOBJ <OCAN <PRSO>>>
			   <MEMQ .NOBJ .AOBJS>
			   <TRNN .NOBJ ,OPENBIT>>>
		  <TELL
"Thank you very much.  I was rather thirsty (from all this talking,
probably).">
		  <COND (.NOBJ <REMOVE-FROM .NOBJ <PRSO>>)>)
		 (<TELL
"I'd like to, but I can't get to it.">)>)
	  (<NOT <OR .EAT? .DRINK?>>
	   <TELL
"I don't think that the " 1 <ODESC2 <PRSO>> " would agree with you.">)
	  (<TELL
"I think you should get that first.">)>>

<DEFINE JARGON ()
    <TELL "Well, FOO, BAR, and BLETCH to you too!">>

<DEFINE CURSES ()
    <TELL <PICK-ONE ,OFFENDED>>>

<GDECL (OFFENDED) <VECTOR [REST STRING]>>

<DEFINE PRAYER () 
  <COND (<AND <==? ,HERE <SFIND-ROOM "TEMP2">>
	      <GOTO <SFIND-ROOM "FORE1">>>
	 <ROOM-DESC>)
	(<TELL
"If you pray enough, your prayers may be answered.">)>>

<DEFINE LEAPER ("AUX" (RM ,HERE) (EXITS <REXITS .RM>) M)
   #DECL ((RM) ROOM (EXITS) EXIT (M) <OR VECTOR FALSE>)
   <COND (<NOT <EMPTY? <PRSO>>>
	  <COND (<MEMQ <PRSO> <ROBJS .RM>>
		 <COND (<TRNN <PRSO> ,VILLAIN>
			<TELL "The " 1 <ODESC2 <PRSO>> " is too big to jump over.">)
		       (<TELL <PICK-ONE ,WHEEEEE>>)>)
		(<TELL "That would be a good trick.">)>)
	 (<SET M <MEMQ <FIND-DIR "DOWN"> .EXITS>>
	  <COND (<OR <TYPE? <2 .M> NEXIT>
		     <AND <TYPE? <2 .M> CEXIT>
			  <NOT <CXFLAG <2 .M>>>>>
		 <JIGS-UP <PICK-ONE ,JUMPLOSS>>)>)
	 (<TELL <PICK-ONE ,WHEEEEE>>)>>

<DEFINE SKIPPER ()
    <TELL <PICK-ONE ,WHEEEEE>>>

<SETG HS 0>
<GDECL (HS) FIX>

<DEFINE HELLO ("AUX" AMT)
    #DECL ((AMT) FIX)
    <COND (<NOT <EMPTY? <PRSO>>>
	   <COND (<==? <PRSO> <SFIND-OBJ "SAILO">>
		  <SET AMT <SETG HS <+ ,HS 1>>>
		  <COND (<0? <MOD .AMT 20>>
			 <TELL
"You seem to be repeating yourself.">)
			(<0? <MOD .AMT 10>>
			 <TELL
"I think that phrase is getting a bit worn out.">)
			(<TELL 
"Nothing happens here.">)>)
		 (<==? <PRSO> <SFIND-OBJ "AVIAT">>
		  <TELL "Here, nothing happens.">)
		 (<OBJECT-ACTION>)
		 (<TRNN <PRSO> ,VILLAIN>
		  <TELL "The " 1 <ODESC2 <PRSO>> " bows his head to you in greeting.">)
		 (<TELL
"I think that only schizophrenics say 'Hello' to a " 1 <ODESC2 <PRSO>> ".">)>)
	  (<TELL <PICK-ONE ,HELLOS>>)>>

<GDECL (HELLOS WHEEEEE JUMPLOSS) <VECTOR [REST STRING]>>

<DEFINE READER ()
    <COND (<NOT <LIT? ,HERE>>
	   <TELL "It is impossible to read in the dark.">)
	  (<AND <NOT <EMPTY? <PRSI>>> <NOT <TRNN <PRSI> ,TRANSBIT>>>
	   <TELL "How does one look through a " 1 <ODESC2 <PRSI>> "?">)
	  (<OBJECT-ACTION>)
	  (<NOT <TRNN <PRSO> ,READBIT>>
	   <TELL "How can I read a " 1 <ODESC2 <PRSO>> "?">)
	  (<TELL <OREAD <PRSO>> ,LONG-TELL1>)>>

<DEFINE LOOK-INSIDE ("AUX" (OD <ODESC2 <PRSO>>))
	#DECL ((OD) STRING)
	<COND (<OBJECT-ACTION>)
	      (<TRNN <PRSO> ,DOORBIT>
	       <COND (<TRNN <PRSO> ,OPENBIT>
		      <TELL
"The " 1 .OD " is open, but I can't tell what's beyond it.">)
		     (<TELL "The " 1 .OD " is closed.">)>)
	      (<TRNN <PRSO> ,CONTBIT>
	       <COND (<SEE-INSIDE? <PRSO>>
		      <COND (<NOT <EMPTY? <OCONTENTS <PRSO>>>>
			     <PRINT-CONT <PRSO>
					 <AVEHICLE ,WINNER>
					 <SFIND-OBJ "#####">
					 ,INDENTSTR>)
			    (<TELL "The " 1 .OD " is empty.">)>)
		     (<TELL "The " 1 .OD " is closed.">)>)
	      (<TELL "I don't know how to look inside a " 1 .OD ".">)>>

<DEFINE LOOK-UNDER ()
    <COND (<OBJECT-ACTION>)
	  (<TELL "There is nothing interesting there.">)>>

<DEFINE REPENT ()
    <TELL "It could very well be too late!">>

<DEFINE BURNER ()
     <COND (<FLAMING? <PRSI>>
	    <COND (<OBJECT-ACTION>)
		  (<==? <OCAN <PRSO>> <SFIND-OBJ "RECEP">>
		   <BALLOON-BURN>)
		  (<AND <TRNN <PRSO> ,BURNBIT>
			<COND (<MEMQ <PRSO> <AOBJS ,WINNER>>
			       <TELL
"The " 1 <ODESC2 <PRSO>> " catches fire.">
			       <REMOVE-OBJECT <PRSO>>
			       <JIGS-UP 
"Unfortunately, you were holding it at the time.">)
			      (<HACKABLE? <PRSO> ,HERE>
			       <TELL
"The " 1 <ODESC2 <PRSO>> " catches fire and is consumed.">
			       <REMOVE-OBJECT <PRSO>>)
			      (<TELL "You don't have that.">)>>)
		  (<TELL 
"I don't think you can burn a " 1 <ODESC2 <PRSO>> ".">)>)
	   (<TELL
"With a " 1 <ODESC2 <PRSI>> "??!?">)>>  

<DEFINE TURNER ()
    <COND (<TRNN <PRSO> ,TURNBIT>
	   <COND (<TRNN <PRSI> ,TOOLBIT>
		  <OBJECT-ACTION>)
		 (<TELL
"You certainly can't turn it with a " 1 <ODESC2 <PRSI>> ".">)>)
	  (<TELL
"You can't turn that!">)>>

<GDECL (DOORMUNGS) <VECTOR [REST STRING]>>

<DEFINE DDOOR-FUNCTION ()
    <COND (<VERB? "OPEN">
	   <TELL
"The door cannot be opened.">)
	  (<VERB? "BURN">
	   <TELL
"You cannot burn this door.">)
	  (<VERB? "MUNG">
	   <TELL <PICK-ONE ,DOORMUNGS>>)>>

<DEFINE PUMPER ("AUX" (P <SFIND-OBJ "PUMP">))
  <COND (<OR <IN-ROOM? .P>
	     <MEMQ .P <AOBJS ,WINNER>>>
	 <PUT ,PRSVEC 3 <SFIND-OBJ "PUMP">>
	 <PUT ,PRSVEC 1 <FIND-VERB "INFLA">>
	 <INFLATER>)
	(<TELL "I really don't see how.">)>>

 <DEFINE INFLATER ()
    <COND (<OBJECT-ACTION>)
	  (<TELL "How can you inflate that?">)>>

<DEFINE DEFLATER ()
    <COND (<OBJECT-ACTION>)
	  (<TELL "Come on, now!">)>>

<DEFINE LOCKER ()
    <COND (<OBJECT-ACTION>)
	  (<AND <==? <PRSO> <SFIND-OBJ "GRATE">>
		<==? ,HERE <SFIND-ROOM "MGRAT">>>
	   <SETG GRUNLOCK!-FLAG <>>
	   <TELL "The grate is locked.">
	   <DPUT "The grate is locked.">)
	  (<TELL "It doesn't seem to work.">)>>

<DEFINE DPUT (STR)
    #DECL ((STR) STRING)
    <MAPF <>
	  <FUNCTION (X)
		    #DECL ((X) <OR DIRECTION DOOR CEXIT NEXIT ROOM>)
		    <COND (<AND <TYPE? .X DOOR>
				<==? <DOBJ .X> <PRSO>>>
			   <PUT .X ,DSTR .STR>
			   <MAPLEAVE>)>>
	  <REXITS ,HERE>>>

<DEFINE UNLOCKER ("AUX" (R <SFIND-ROOM "MGRAT">))
    #DECL ((R) ROOM)
    <COND (<OBJECT-ACTION>)
	  (<AND <==? <PRSO> <SFIND-OBJ "GRATE">>
		<==? ,HERE <SFIND-ROOM "MGRAT">>>
	   <COND (<==? <PRSI> <SFIND-OBJ "KEYS">>
		  <SETG GRUNLOCK!-FLAG T>
		  <TELL "The grate is unlocked.">
		  <DPUT "The grate is closed.">)
		 (<TELL "Can you unlock a grating with a " 1 <ODESC2 <PRSI>> "?">)>)
	  (<TELL "It doesn't seem to work.">)>>

<DEFINE KILLER ("OPTIONAL" (STR "kill"))
	#DECL ((STR) STRING)
	<COND (<OBJECT-ACTION>)
	      (<EMPTY? <PRSO>>
	       <TELL "There is nothing here to " 1 .STR ".">)
	      (<NOT <TRNN <PRSO> ,VILLAIN>>
	       <COND (<TRNN <PRSO> ,VICBIT>)
		     (<TELL 
"I've known strange people, but fighting a " 1 <ODESC2 <PRSO>> "?">)>)
	      (<EMPTY? <PRSI>>
	       <TELL "Trying to " 0 .STR>
	       <TELL " a " 1 <ODESC2 <PRSO>> " with your bare hands is suicidal.">)
	      (<NOT <TRNN <PRSI> ,WEAPONBIT>>
	       <TELL "Trying to " 0 .STR>
	       <TELL " a " 0 <ODESC2 <PRSO>> " with a ">
	       <TELL <ODESC2 <PRSI>> 1 " is suicidal.">) 
	      (ELSE
	       <BLOW ,PLAYER <PRSO> <OFMSGS <PRSI>> T <>>)>>

<DEFINE ATTACKER () <KILLER "attack">>

<DEFINE SWINGER ()
	<PERFORM ATTACKER <FIND-VERB "ATTAC"> <PRSI> <PRSO>>>

<DEFINE HACK-HACK (OBJ STR "OPTIONAL" (OBJ2 <>))
    #DECL ((OBJ) OBJECT (STR) STRING (OBJ2) <OR FALSE STRING>)
    <COND (<OBJECT-ACTION>)
	  (.OBJ2
	   <TELL .STR 0 <ODESC2 .OBJ> " with a ">
	   <TELL .OBJ2 1 <PICK-ONE ,HO-HUM>>)
	  (ELSE
	   <TELL .STR 1 <ODESC2 .OBJ> <PICK-ONE ,HO-HUM>>)>>

<GDECL (HO-HUM) <VECTOR [REST STRING]>>

<DEFINE MUNGER ()
    <COND (<TRNN <PRSO> ,VILLAIN>
	   <COND (<NOT <EMPTY? <PRSI>>>
		  <COND (<OBJECT-ACTION>)
			(<TRNN <PRSI> ,WEAPONBIT>
			 <BLOW ,PLAYER <PRSO> <OFMSGS <PRSI>> T <>>)
			(T
			 <TELL "Trying to destroy a " 0 <ODESC2 <PRSO>> " with a ">
			 <TELL <ODESC2 <PRSI>> 1 " is quite self-destructive.">)>)
		 (T
		  <TELL "Trying to destroy a " 1 <ODESC2 <PRSO>> " with your bare hands is suicidal.">)>)
	  (<HACK-HACK <PRSO> "Trying to destroy a ">)>>

<DEFINE KICKER ()
    <HACK-HACK <PRSO> "Kicking a ">>

<DEFINE WAVER ()
    <HACK-HACK <PRSO> "Waving a ">>

<DEFINE R/L ()
    <HACK-HACK <PRSO> "Playing in this way with a ">>

<DEFINE RUBBER ()
    <HACK-HACK <PRSO> "Fiddling with a ">>

<DEFINE EXORCISE ()
    <COND (<OBJECT-ACTION>) (T)>>
	  
<DEFINE PLUGGER ()
    <COND (<OBJECT-ACTION>)
	  (<TELL "This has no effect.">)>>

<DEFINE UNTIE ()
    <COND (<OBJECT-ACTION>)
	  (<TRNN <PRSO> ,TIEBIT>
	   <TELL "I don't think so.">)
	  (<TELL "This cannot be tied, so it cannot be untied!">)>>

<DEFINE PUSHER ()
    <COND (<OBJECT-ACTION>)
	  (<HACK-HACK <PRSO> "Pushing the ">)>>

<DEFINE TIE ()
    <COND (<TRNN <PRSO> ,TIEBIT>
	   <COND (<OBJECT-ACTION>)
		 (<==? <PRSI> <SFIND-OBJ "#####">>
		  <TELL "You can't tie the rope to yourself.">)
		 (<TELL "You can't tie the " 1 <ODESC2 <PRSO>> " to that.">)>)
	  (<TELL "How can you tie that to anything.">)>>

<DEFINE TIE-UP ()
    <COND (<TRNN <PRSI> ,TIEBIT>
	   <COND (<TRNN <PRSO> ,VILLAIN>
		  <TELL "The "
			1
			<ODESC2 <PRSO>>
			" struggles and you cannot tie him up.">)
		 (<TELL "Why would you tie up a " 1 <ODESC2 <PRSO>> "?">)>)
	  (<TELL "You could certainly never tie it with that!">)>>

<DEFINE MELTER ()
    <COND (<OBJECT-ACTION>)
	  (<TELL "I'm not sure that a " 1 <ODESC2 <PRSO>> " can be melted.">)>>

<DEFINE MUMBLER ()
    <TELL "You'll have to speak up if you expect me to hear you!">>

<DEFINE ALARM ()
    <COND (<TRNN <PRSO> ,SLEEPBIT>
	   <OBJECT-ACTION>)
	  (<TELL "The " 1 <ODESC2 <PRSO>> " isn't sleeping.">)>>

<DEFINE DUNGEON ()
    <TELL "That word is replaced henceforth with ZORK.">>

<DEFINE ZORK ()
    <TELL "At your service!">>

\
; "SUBTITLE RANDOM FUNCTIONS"

<SETG ON-POLE!-FLAG <>>

<DEFINE BODY-FUNCTION ()
    <COND (<VERB? "TAKE">
	   <TELL "A force keeps you from taking the bodies.">)
	  (<VERB? "MUNG" "BURN">
	   <COND (,ON-POLE!-FLAG)
		 (<SETG ON-POLE!-FLAG T>
		  <INSERT-OBJECT <SFIND-OBJ "HPOLE"> <SFIND-ROOM "LLD2">>)>
	   <JIGS-UP 
"The voice of the guardian of the dungeon booms out from the darkness 
'Your disrespect costs you your life!' and places your head on a pole.">)>>

<DEFINE BLACK-BOOK ()
  <COND (<VERB? "OPEN">
	 <TELL
"The book is already open to page 569.">)
	(<VERB? "CLOSE">
	 <TELL
"As hard as you try, the book cannot be closed.">)
	(<VERB? "BURN">
	 <REMOVE-OBJECT <PRSO>>
	 <JIGS-UP
"A booming voice says 'Wrong, cretin!' and you notice that you have
turned into a pile of dust.">)>>

<DEFINE PAINTING ()
    <COND (<VERB? "MUNG">
	   <OTVAL <PRSO> 0>
	   <PUT <PRSO> ,ODESC2 "worthless piece of canvas">
	   <ODESC1 <PRSO> "There is a worthless piece of canvas here.">
	   <TELL
"Congratulations!  Unlike the other vandals, who merely stole the
artist's masterpieces, you have destroyed one.">)>>

\

; "SUBTITLE LET THERE BE LIGHT SOURCES"

<PSETG DIMMER "The lamp appears to be getting dimmer.">

<PSETG LAMP-TICKS [50 30 20 10 4 0]>

<PSETG LAMP-TELLS [,DIMMER ,DIMMER ,DIMMER ,DIMMER "The lamp is dying."]>

<DEFINE LANTERN ("AUX" (HERE ,HERE) (RLAMP <SFIND-OBJ "LAMP">) FOO)
	#DECL ((HERE) ROOM (RLAMP) OBJECT (FOO) <VECTOR ANY CEVENT>)
	<COND (<VERB? "THROW">
	       <TELL 
"The lamp has smashed into the floor and the light has gone out.">
	       <CLOCK-DISABLE <2 <SET FOO <OLINT .RLAMP>>>>
	       <REMOVE-OBJECT <SFIND-OBJ "LAMP">>
	       <INSERT-OBJECT <SFIND-OBJ "BLAMP"> .HERE>)
	      (<VERB? "C-INT">
	       <LIGHT-INT .RLAMP ,LNTIN ,LAMP-TICKS ,LAMP-TELLS>)
	      (<VERB? "TRNON" "LIGHT">
	       <CLOCK-ENABLE <2 <SET FOO <OLINT .RLAMP>>>>
	       <>)
	      (<VERB? "TRNOF">
	       <CLOCK-DISABLE <2 <SET FOO <OLINT .RLAMP>>>>
	       <>)>>

<PSETG CDIMMER "The candles grow shorter.">

<PSETG CANDLE-TICKS [20 10 5 0]>

<PSETG CANDLE-TELLS [,CDIMMER ,CDIMMER "The candles are very short."]>

<DEFINE MATCH-FUNCTION ("AUX" (MATCH <SFIND-OBJ "MATCH">) (MC <OMATCH .MATCH>))
    #DECL ((MATCH) OBJECT (MC) FIX)
    <COND (<AND <VERB? "LIGHT"> <==? <PRSO> .MATCH>>
	   <COND (<AND <OMATCH .MATCH <SET MC <- .MC 1>>>
		       <L? .MC 0>>
		  <TELL "I'm afraid that you have run out of matches.">)
		 (<TRO .MATCH <+ ,FLAMEBIT ,LIGHTBIT ,ONBIT>>
		  <CLOCK-INT ,MATIN 2>
		  <TELL "One of the matches starts to burn.">)>)
	  (<AND <VERB? "TRNOF"> <TRNN .MATCH ,LIGHTBIT>>
	   <TELL "The match is out.">
	   <TRZ .MATCH <+ ,FLAMEBIT ,LIGHTBIT ,ONBIT>>
	   <CLOCK-INT ,MATIN 0>
	   T)
	  (<VERB? "C-INT">
	   <TELL "The match has gone out.">
	   <TRZ .MATCH <+ ,FLAMEBIT ,LIGHTBIT ,ONBIT>>)>>

<DEFINE CANDLES ("AUX" (C <SFIND-OBJ "CANDL">) MATCH FOO)
	#DECL ((PRSA) VERB (MATCH C) OBJECT (W) <OR FALSE OBJECT>
	       (FOO) <VECTOR FIX CEVENT>)
	<COND
	 (<==? .C <PRSI>> <>)
	 (ELSE
	  <SET FOO <OLINT .C>>
	  <COND (<AND <VERB? "TAKE">
		      <TRNN .C ,ONBIT>>
		 <CLOCK-ENABLE <2 .FOO>>
		 <>)
		(<VERB? "TRNON" "BURN" "LIGHT">
		 <COND (<NOT <TRNN .C ,LIGHTBIT>>
			<TELL
"Alas, there's not much left of the candles.  Certainly not enough to
burn.">)
		       (<EMPTY? <PRSI>>
			<TELL "With what?">
			<ORPHAN T
				<FIND-ACTION "LIGHT">
				.C
				<PLOOKUP "WITH" ,WORDS-POBL>>
			<SETG PARSE-WON <>>
			T)
		       (<AND <==? <PRSI> <SET MATCH <SFIND-OBJ "MATCH">>>
			     <TRNN .MATCH ,ONBIT>>
			<COND (<TRNN .C ,ONBIT>
			       <TELL "The candles are already lighted.">)
			      (<TRO .C ,ONBIT>
			       <TELL "The candles are lighted.">
			       <CLOCK-ENABLE <2 .FOO>>)>)
		       (<==? <PRSI> <SFIND-OBJ "TORCH">>
			<COND (<TRNN .C ,ONBIT>
			       <TELL 
"You realize, just in time, that the candles are already lighted.">)
			      (<TELL 
"The heat from the torch is so intense that the candles are vaporised.">
			       <REMOVE-OBJECT .C>)>)
		       (<TELL
"You have to light them with something that's burning, you know.">)>)
		(<VERB? "TRNOF">
		 <CLOCK-DISABLE <2 .FOO>>
		 <COND (<TRNN .C ,ONBIT>
			<TELL "The flame is extinguished.">
			<TRZ .C ,ONBIT>)
		       (<TELL "The candles are not lighted.">)>)
		(<VERB? "C-INT">
		 <LIGHT-INT .C ,CNDIN ,CANDLE-TICKS ,CANDLE-TELLS>)>)>>

<DEFINE LIGHT-INT (OBJ CEV TICK TELL "AUX" CNT TIM (FOO <OLINT .OBJ>))
    #DECL ((OBJ) OBJECT (FCN) APPLICABLE (TICK) <VECTOR [REST FIX]> (CEV) CEVENT
	    (TELL) <VECTOR [REST STRING]> (TIM CNT) FIX (FOO) <VECTOR FIX CEVENT>)
    <PUT .FOO 1 <SET CNT <+ <1 .FOO> 1>>>
    <CLOCK-INT .CEV <SET TIM <NTH .TICK .CNT>>>
    <COND (<0? .TIM>
 	   <COND (<OR <NOT <OROOM .OBJ>> <==? <OROOM .OBJ> ,HERE>>
		  <TELL "I hope you have more light than from a " 1 <ODESC2 .OBJ> ".">)>
	   <TRZ .OBJ <+ ,LIGHTBIT ,ONBIT>>)
	  (<OR <NOT <OROOM .OBJ>>
	       <==? <OROOM .OBJ> ,HERE>>
	   <TELL <NTH .TELL .CNT>>)>>

<DEFINE CAVE2-ROOM ("AUX" FOO BAR C)
  #DECL ((FOO) <VECTOR FIX CEVENT> (BAR) CEVENT (C) OBJECT)
  <COND (<VERB? "GO-IN">
	 <COND (<AND <MEMQ <SET C <SFIND-OBJ "CANDL">> <AOBJS ,WINNER>>
		     <PROB 50 80>
		     <TRNN .C ,ONBIT>>
		<CLOCK-DISABLE <SET BAR <2 <SET FOO <OLINT .C>>>>>
		<TRZ .C ,ONBIT>
		<TELL 
"The cave is very windy at the moment and your candles have blown out.">
		<COND (<NOT <LIT? ,HERE>>
		       <TELL "It is now completely dark.">)>)>)>>

\

; "SUBTITLE ASSORTED WEAPONS"

<DEFINE SWORD-GLOW (DEM
		    "AUX" (SW <HOBJ .DEM>) (G <OTVAL .SW>) (HERE ,HERE) (NG 0))
   #DECL ((DEM) HACK (SW) OBJECT (NG G) FIX (HERE) ROOM)
   <COND (<AND <NOT <OROOM .SW>> <NOT <OCAN .SW>>
	       <MEMQ .SW <AOBJS ,PLAYER>>>
	  <COND (<INFESTED? .HERE> <SET NG 2>)
		(<MAPF <>
		       <FUNCTION (E) 
				 #DECL ((E) <OR ROOM CEXIT DOOR NEXIT ATOM>)
				 <COND (<TYPE? .E ROOM>
					<AND <INFESTED? .E> <MAPLEAVE T>>)
				       (<TYPE? .E CEXIT>
					<AND <INFESTED? <2 .E>> <MAPLEAVE T>>)
				       (<TYPE? .E DOOR>
					<AND <INFESTED? <GET-DOOR-ROOM .HERE .E>>
					     <MAPLEAVE T>>)>>
		       <REXITS .HERE>>
		 <SET NG 1>)>
	  <COND (<==? .NG .G>)
		(<==? .NG 2> <TELL "Your sword has begun to glow very brightly.">)
		(<1? .NG> <TELL "Your sword is glowing with a faint blue glow.">)
		(<0? .NG> <TELL "Your sword is no longer glowing.">)>
	  <OTVAL .SW .NG>)
	 (<PUT .DEM ,HACTION <>>)>>

<DEFINE SWORD ()
	<COND (<AND <VERB? "TAKE">
		    <==? ,WINNER ,PLAYER>>
	       <PUT ,SWORD-DEMON ,HACTION <COND (<TYPE? ,SWORD-GLOW NOFFSET>
						 ,SWORD-GLOW)
						(SWORD-GLOW)>>
	       <>)>>

<DEFINE INFESTED? (R "AUX" (VILLAINS ,VILLAINS) (DEM <GET-DEMON "THIEF">)) 
	#DECL ((R) ROOM (VILLAINS) <LIST [REST OBJECT]> (DEM) HACK)
	<OR <AND ,END-GAME!-FLAG <EG-INFESTED? .R>>
	    <AND <==? .R <HROOM .DEM>>
		 <HACTION .DEM>>
	    <MAPF <>
		  <FUNCTION (V) 
			  #DECL ((V) OBJECT)
			  <COND (<==? .R <OROOM .V>> <MAPLEAVE T>)>>
		  .VILLAINS>>>



 

