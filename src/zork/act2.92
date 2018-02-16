
; "SUBTITLE COAL MINE"

<DEFINE BOOM-ROOM ("AUX" (DUMMY? <>) (WIN ,WINNER) O (AOBJS <AOBJS .WIN>))
    #DECL ((DUMMY?) <OR ATOM FALSE> (WIN) ADV (O) OBJECT)
    <COND (<OR <VERB? "GO-IN">
	       <AND <VERB? "ON" "TRNON" "LIGHT" "BURN">
		    <SET DUMMY? T>>>
	   <COND (<OR <AND <MEMQ <SET O <SFIND-OBJ "CANDL">> .AOBJS>
			   <TRNN .O ,ONBIT>>
		      <AND <MEMQ <SET O <SFIND-OBJ "TORCH">> .AOBJS>
			   <TRNN .O ,ONBIT>>
		      <AND <MEMQ <SET O <SFIND-OBJ "MATCH">> .AOBJS>
			   <TRNN .O ,ONBIT>>>
		  <UNWIND
		   <PROG ()
		    <COND (.DUMMY?
			   <TELL
"I didn't realize that adventurers are stupid enough to light a 
" ,LONG-TELL1 <ODESC2 .O> " in a room which reeks of coal gas.
Fortunately, there is justice in the world.">)
			  (<TELL
"Oh dear.  It appears that the smell coming from this room was coal
gas.  I would have thought twice about carrying a " ,LONG-TELL1
						    <ODESC2 .O> "in here.">)>
		    <FWEEP 7>
		    <JIGS-UP "   BOOOOOOOOOOOM      ">>
		   <JIGS-UP "   BOOOOOOOOOOOM      ">>)>)>>    

<DEFINE BATS-ROOM ()
    <COND (<AND <VERB? "GO-IN">
		<NOT <MEMQ <SFIND-OBJ "GARLI"> <AOBJS ,WINNER>>>>
	   <FLY-ME>)
	  (<VERB? "LOOK">
	   <TELL 
 "You are in a small room which has only one door, to the east.">
	   <AND <MEMQ <SFIND-OBJ "GARLI"> <AOBJS ,WINNER>>
		<TELL 
"In the corner of the room on the ceiling is a large vampire bat who
is obviously deranged and holding his nose.">>)>>

<DEFINE FLY-ME ("AUX" (BAT-DROPS ,BAT-DROPS))
      #DECL ((BAT-DROPS) <VECTOR [REST STRING]>)
      <UNWIND
        <PROG ()
	      <FWEEP 4 1>
	      <TELL
  "A deranged giant vampire bat (a reject from WUMPUS) swoops down
from his belfry and lifts you away....">
	      <GOTO <FIND-ROOM <PICK-ONE .BAT-DROPS>>>>
	<GOTO <FIND-ROOM <PICK-ONE .BAT-DROPS>>>>
      <PUT ,PRSVEC 2 <>>
      <ROOM-INFO>
      T>

<DEFINE FWEEP (NUM "OPTIONAL" (SLP 0))
    #DECL ((NUM SLP) FIX)
    <REPEAT ((N .NUM))
	#DECL ((N) FIX)
	<AND <0? <SET N <- .N 1>>> <RETURN>>
	<IMAGE 7>
	<OR <0? .SLP> <SLEEP .SLP>>>
    <TTY-INIT <>>>

<GDECL (BAT-DROPS) <VECTOR [REST STRING]>>

<SETG CAGE-TOP!-FLAG T>

<DEFINE DUMBWAITER ("AUX" (TB <SFIND-OBJ "TBASK">)
			  (TOP <SFIND-ROOM "TSHAF">) (BOT <SFIND-ROOM "BSHAF">)
			  (FB <SFIND-OBJ "FBASK">) (CT ,CAGE-TOP!-FLAG)
			  (DUMMY ,DUMMY) (LIT? <LIT? ,HERE>))
    #DECL ((FB TB) OBJECT (TOP BOT) ROOM (LIT? CT) <OR ATOM FALSE>
	   (DUMMY) <VECTOR [REST STRING]>)
    <COND (<VERB? "RAISE">
	   <COND (.CT
		  <TELL <PICK-ONE ,DUMMY>>)
		 (<REMOVE-OBJECT .TB>
		  <REMOVE-OBJECT .FB>
		  <INSERT-OBJECT .TB .TOP>
		  <INSERT-OBJECT .FB .BOT>
		  <TELL "The basket is raised to the top of the shaft.">
		  <SETG CAGE-TOP!-FLAG T>)>)
	  (<VERB? "LOWER">
	   <COND (<NOT .CT>
		  <TELL <PICK-ONE .DUMMY>>)
		 (<REMOVE-OBJECT .TB>
		  <REMOVE-OBJECT .FB>
		  <INSERT-OBJECT .TB .BOT>
		  <INSERT-OBJECT .FB .TOP>
		  <TELL "The basket is lowered to the bottom of the shaft.">
		  <SETG CAGE-TOP!-FLAG <>>
		  <COND (<AND .LIT? <NOT <LIT? ,HERE>>>
	   		 <TELL "It is now pitch black.">)>
		  T)>)
	  (<OR <==? <PRSO> .FB>
	       <==? <PRSI> .FB>>
	   <TELL "The basket is at the other end of the chain.">)
	  (<VERB? "TAKE">
	   <TELL "The cage is securely fastened to the iron chain.">)>>

<DEFINE MACHINE-ROOM ()
    <COND (<VERB? "LOOK">
	   <TELL ,MACHINE-DESC
		 ,LONG-TELL1
		 <COND (<TRNN <SFIND-OBJ "MACHI"> ,OPENBIT>
			"open.")
		       ("closed.")>>)>>

<DEFINE MACHINE-FUNCTION ("AUX" (DUMMY ,DUMMY) (MACH <SFIND-OBJ "MACHI">))
   #DECL ((MACH) OBJECT (DUMMY) <VECTOR [REST STRING]>)
   <COND
    (<==? ,HERE <SFIND-ROOM "MACHI">>
     <COND
      (<VERB? "OPEN">
       <COND (<TRNN .MACH ,OPENBIT>
	      <TELL <PICK-ONE .DUMMY>>)
	     (<TELL "The lid opens.">
	      <TRO .MACH ,OPENBIT>)>)
      (<VERB? "CLOSE">
       <COND (<TRNN .MACH ,OPENBIT>
	      <TELL "The lid closes.">
	      <TRZ .MACH ,OPENBIT>
	      T)
	     (<TELL <PICK-ONE .DUMMY>>)>)>)>>

<DEFINE MSWITCH-FUNCTION ("AUX" (C <SFIND-OBJ "COAL">) D (MACH <SFIND-OBJ "MACHI">)
				(SCREW <SFIND-OBJ "SCREW">))
    #DECL ((MACH SCREW C D) OBJECT)
    <COND (<VERB? "TURN">
	   <COND (<==? <PRSI> .SCREW>
		  <COND (<TRNN .MACH ,OPENBIT>
			 <TELL
			  "The machine doesn't seem to want to do anything.">)
			(<TELL 
"The machine comes to life (figuratively) with a dazzling display of
colored lights and bizarre noises.  After a few moments, the
excitement abates." ,LONG-TELL1>
		         <COND (<==? <OCAN .C> .MACH>
				<REMOVE-OBJECT .C>
				<PUT .MACH
				     ,OCONTENTS
				     (<SET D <SFIND-OBJ "DIAMO">>
				      !<OCONTENTS .MACH>)>
				<PUT .D ,OCAN .MACH>)
			       (<NOT <EMPTY? <OCONTENTS .MACH>>>
				<PUT .MACH ,OCONTENTS (<SFIND-OBJ "GUNK">)>)
			       (T)>)>)
		 (<TELL "It seems that a " 1 <ODESC2 <PRSI>> " won't do.">)>)>>

<DEFINE GUNK-FUNCTION ("AUX" (G <SFIND-OBJ "GUNK">) (M <OCAN .G>))
  #DECL ((G) OBJECT (M) <OR OBJECT FALSE>)
  <COND (.M
	 <PUT .M ,OCONTENTS <SPLICE-OUT .G <OCONTENTS .M>>>
	 <PUT .G ,OCAN <>>
	 <TELL
"The slag turns out to be rather insubstantial, and crumbles into dust
at your touch.  It must not have been very valuable.">)>>

<SETG SCORE-MAX <+ ,SCORE-MAX <SETG LIGHT-SHAFT 10>>>

<DEFINE NO-OBJS ()
    <COND (<EMPTY? <AOBJS ,WINNER>>
	   <SETG EMPTY-HANDED!-FLAG T>)
	  (ELSE <SETG EMPTY-HANDED!-FLAG <>>)>
    <COND (<AND <==? ,HERE <SFIND-ROOM "BSHAF">>
	   <LIT? ,HERE>>
	   <SCORE-UPD ,LIGHT-SHAFT>
	   <SETG LIGHT-SHAFT 0>)>>

<GDECL (LIGHT-SHAFT) FIX>

\ 

;"SUBTITLE OLD MAN RIVER, THAT OLD MAN RIVER..."

<DEFINE CLIFF-FUNCTION ()
    <COND (<MEMQ <SFIND-OBJ "RBOAT"> <AOBJS ,WINNER>>
	   <SETG DEFLATE!-FLAG <>>)
	  (<SETG DEFLATE!-FLAG T>)>>

<DEFINE STICK-FUNCTION ("AUX" (HERE ,HERE))
    #DECL ((HERE) ROOM)
    <COND (<VERB? "WAVE">
	   <COND (<OR <==? .HERE <SFIND-ROOM "FALLS">>
		      <==? .HERE <SFIND-ROOM "POG">>>
		  <COND (<NOT ,RAINBOW!-FLAG>
			 <TRO <SFIND-OBJ "POT"> ,OVISON>
			 <TELL
"Suddenly, the rainbow appears to become solid and, I venture,
walkable (I think the giveaway was the stairs and bannister).">
			 <SETG RAINBOW!-FLAG T>)
			(<TELL
"The rainbow seems to have become somewhat run-of-the-mill.">
			 <SETG RAINBOW!-FLAG <>>)>)
		 (<==? .HERE <SFIND-ROOM "RAINB">>
		  <SETG RAINBOW!-FLAG <>>
		  <JIGS-UP
"The structural integrity of the rainbow seems to have left it,
leaving you about 450 feet in the air, supported by water vapor.">)
		 (<TELL "Very good.">)>)>>

<DEFINE FALLS-ROOM ()
    <COND (<VERB? "LOOK">
	   <TELL
"You are at the top of Aragain Falls, an enormous waterfall with a
drop of about 450 feet.  The only path here is on the north end." ,LONG-TELL1>
	   <COND (,RAINBOW!-FLAG
		  <TELL
"A solid rainbow spans the falls.">)
		 (<TELL
"A beautiful rainbow can be seen over the falls and to the east.">)>)>>

<DEFINE BARREL ("OPTIONAL" (ARG <>)) 
	#DECL ((ARG) <OR FALSE ATOM>)
	<AND <==? .ARG READ-IN>
	     <COND (<VERB? "WALK"> <TELL "You cannot move the barrel.">)
		   (<VERB? "LOOK">
		    <TELL 
"You are inside a barrel.  Congratulations.  Etched into the side of the
barrel is the word 'Geronimo!'.  From your position, you cannot see 
the falls.">)
		   (<VERB? "TAKE"> <PICK-ONE ,YUKS>)
		   (<VERB? "BURN">
		    <TELL "The barrel is damp and cannot be burned.">)>>>

<DEFINE DBOAT-FUNCTION ("AUX" (HERE ,HERE) (DBOAT <SFIND-OBJ "DBOAT">))
    #DECL ((DBOAT) OBJECT (HERE) ROOM)
    <COND (<VERB? "INFLA">
	   <TELL 
"This boat will not inflate since some moron put a hole in it.">)
	  (<VERB? "PLUG">
	   <COND (<==? <PRSI> <SFIND-OBJ "PUTTY">>
		  <TELL
"Well done.  The boat is repaired.">
		  <COND (<NOT <OROOM .DBOAT>>
			 <DROP-OBJECT .DBOAT>
			 <TAKE-OBJECT <SFIND-OBJ "IBOAT">>)
			(<REMOVE-OBJECT <SFIND-OBJ "DBOAT">>
			 <INSERT-OBJECT <SFIND-OBJ "IBOAT"> .HERE>)>)
		 (<WITH-TELL <PRSI>>)>)>>

<DEFINE RBOAT-FUNCTION ("OPTIONAL" (ARG <>)
			"AUX" (RBOAT <SFIND-OBJ "RBOAT">)
			      (IBOAT <SFIND-OBJ "IBOAT">) (HERE ,HERE))
    #DECL ((ARG) <OR FALSE ATOM> (IBOAT RBOAT) OBJECT (HERE) ROOM)
    <COND (.ARG <>)
	  (<VERB? "BOARD">
	   <COND (<MEMQ <SFIND-OBJ "STICK"> <AOBJS ,WINNER>>
		  <TELL
"There is a hissing sound and the boat deflates.">
		  <REMOVE-OBJECT .RBOAT>
		  <INSERT-OBJECT <SFIND-OBJ "DBOAT"> .HERE>
		  T)>)
	  (<VERB? "INFLA">
	   <TELL "Inflating it further would probably burst it.">)
	  (<VERB? "DEFLA">
	   <COND (<==? <AVEHICLE ,WINNER> .RBOAT>
		  <TELL
"You can't deflate the boat while you're in it.">)
		 (<NOT <MEMQ .RBOAT <ROBJS .HERE>>>
		  <TELL
"The boat must be on the ground to be deflated.">)
		 (<TELL
"The boat deflates.">
		  <SETG DEFLATE!-FLAG T>
		  <REMOVE-OBJECT .RBOAT>
		  <INSERT-OBJECT .IBOAT .HERE>)>)>>

<DEFINE BREATHE ()
    <PERFORM INFLATER <FIND-VERB "INFLA"> <PRSO> <SFIND-OBJ "LUNGS">>>

<DEFINE IBOAT-FUNCTION ("AUX" (IBOAT <SFIND-OBJ "IBOAT">) (RBOAT <SFIND-OBJ "RBOAT">)
			      (HERE ,HERE))
    #DECL ((IBOAT RBOAT) OBJECT (HERE) ROOM)
    <COND (<VERB? "INFLA">
	   <COND (<NOT <MEMQ .IBOAT <ROBJS .HERE>>>
		  <TELL
"The boat must be on the ground to be inflated.">)
		 (<==? <PRSI> <SFIND-OBJ "PUMP">>
		  <TELL
"The boat inflates and appears seaworthy.">
		  <SETG DEFLATE!-FLAG <>>
		  <REMOVE-OBJECT .IBOAT>
	    	  <INSERT-OBJECT .RBOAT .HERE>)
		 (<==? <PRSI> <SFIND-OBJ "LUNGS">>
		  <TELL
"You don't have enough lung power to inflate it.">)
		 (<TELL
"With a " 1 <ODESC2 <PRSI>> "?  Surely you jest!">)>)>>

<DEFINE OVER-FALLS ()
    <COND (<VERB? "LOOK"> T)
	  (<JIGS-UP ,OVER-FALLS-STR1>)>>

<SETG BUOY-FLAG!-FLAG T>

<DEFINE SHAKER ("AUX" (HERE ,HERE))
    #DECL ((HERE) ROOM)
    <COND (<OBJECT-ACTION>)
	  (<TRNN <PRSO> ,VILLAIN>
	   <TELL "This seems to have no effect.">)
	  (<NOT <TRNN <PRSO> ,TAKEBIT>>
	   <TELL "You can't take it; thus, you can't shake it!">)
	  (<AND <NOT <TRNN <PRSO> ,OPENBIT>>
		<NOT <EMPTY? <OCONTENTS <PRSO>>>>
		<TELL
"It sounds like there is something inside the " 1 <ODESC2 <PRSO>> ".">>)
	  (<AND <TRNN <PRSO> ,OPENBIT>
		<NOT <EMPTY? <OCONTENTS <PRSO>>>>>
	   <MAPF <>
		 <FUNCTION (X)
		       #DECL ((X) OBJECT)
		       <PUT .X ,OCAN <>>
		       <INSERT-OBJECT .X .HERE>>
		 <OCONTENTS <PRSO>>>
	   <PUT <PRSO> ,OCONTENTS ()>
	   <TELL
"All of the objects spill onto the floor.">)>>

<DEFINE RIVR4-ROOM ()
    <AND <MEMQ <SFIND-OBJ "BUOY"> <AOBJS ,WINNER>>
	 ,BUOY-FLAG!-FLAG
	 <TELL
	  "Something seems funny about the feel of the buoy.">
	 <SETG BUOY-FLAG!-FLAG <>>>> 

<SETG BEACH-DIG!-FLAG 0>

<SETG GUANO-DIG!-FLAG 0>

<GDECL (BEACH-DIG!-FLAG GUANO-DIG!-FLAG) FIX>

<DEFINE DIGGER ()
    <COND (<==? <PRSI> <SFIND-OBJ "SHOVE">>
	   <OBJECT-ACTION>)
	  (<TRNN <PRSI> ,TOOLBIT>
	   <TELL
"Digging with the " 1 <ODESC2 <PRSI>> " is slow and tedious.">)
	  (<TELL
"Digging with a " 1 <ODESC2 <PRSI>> " is silly.">)>>

<DEFINE GROUND-FUNCTION ()
    <COND (<==? ,HERE <SFIND-ROOM "BEACH">>
	   <SAND-FUNCTION>)
	  (<VERB? "DIG">
	   <TELL "The ground is too hard for digging here.">)>>

<DEFINE SAND-FUNCTION ("AUX" (S <SFIND-OBJ "STATU">) (HERE ,HERE) CNT)
    #DECL ((S) OBJECT (HERE) ROOM (CNT) FIX)
    <COND (<VERB? "DIG">
	   <SETG BEACH-DIG!-FLAG <SET CNT <+ 1 ,BEACH-DIG!-FLAG>>>
	   <COND (<G? .CNT 4>
		  <SETG BEACH-DIG!-FLAG 0>
		  <AND <MEMQ .S <ROBJS .HERE>>
		       <TRZ .S ,OVISON>>
		  <JIGS-UP "The hole collapses, smothering you.">)
		 (<==? .CNT 4>
		  <COND (<NOT <TRNN .S ,OVISON>>
			 <TELL "You can see a small statue here in the sand.">
			 <TRO .S ,OVISON>)>)
		 (<L? .CNT 0>)
		 (<TELL <NTH ,BDIGS .CNT>>)>)>>

<DEFINE GUANO-FUNCTION ("AUX" (HERE ,HERE) CNT)
    #DECL ((HERE) ROOM (CNT) FIX)
    <COND (<VERB? "DIG">
	   <SETG GUANO-DIG!-FLAG <SET CNT <+ 1 ,GUANO-DIG!-FLAG>>>
           <COND (<G? .CNT 3>
		  <TELL "This is getting you nowhere.">)
		 (<TELL <NTH ,CDIGS .CNT>>)>)>>
	   
<GDECL (BDIGS CDIGS) <VECTOR [REST STRING]>>

<DEFINE GERONIMO ()
    <COND (<==? <AVEHICLE ,WINNER> <SFIND-OBJ "BARRE">>
	   <JIGS-UP ,OVER-FALLS-STR>)
	  (<TELL
"Wasn't he an Indian?">)>>

<GDECL (SWIMYUKS) <VECTOR [REST STRING]>>

<DEFINE SWIMMER ("AUX" (SWIMYUKS ,SWIMYUKS))
    #DECL ((SWIMYUKS) <VECTOR [REST STRING]>)
    <COND (<RTRNN ,HERE ,RFILLBIT>
	   <TELL 
"Swimming is not allowed in this dungeon.">)
	  (<TELL <PICK-ONE .SWIMYUKS>>)>>

\ 

;"SUBTITLE LURKING GRUES"

<DEFINE GRUE-FUNCTION ()
    <COND (<VERB? "EXAMI">
	   <TELL ,GRUE-DESC1 ,LONG-TELL1>)
	  (<VERB? "FIND">
	   <TELL ,GRUE-DESC2 ,LONG-TELL1>)>>

\ 

;"THE VOLCANO"

<SETG BTIE!-FLAG <>>
<GDECL (BTIE!-FLAG) <OR FALSE OBJECT>>

<SETG BINF!-FLAG <>>

<DEFINE BALLOON BALLACT ("OPTIONAL" (ARG <>)
			 "AUX" (BALL <SFIND-OBJ "BALLO">) (CONT <SFIND-OBJ "RECEP">)
			       M (BINF ,BINF!-FLAG) R)
	#DECL ((ARG) <OR ATOM FALSE> (BALL CONT) OBJECT 
	       (BINF) <OR FALSE OBJECT> (M) <OR FALSE VECTOR>
	       (BALLACT) ACTIVATION (R) <OR NEXIT CEXIT DOOR ROOM>)
	<COND (<==? .ARG READ-OUT>
	       <COND (<VERB? "LOOK">
		      <COND (.BINF
		    	     <TELL 
				  "The cloth bag is inflated and there is a "
			   	   1
			  	   <ODESC2 .BINF>
			  	   " burning in the receptacle.">)
			    (<TELL "The cloth bag is draped over the the basket.">)>
		      <COND (,BTIE!-FLAG
			     <TELL "The balloon is tied to the hook.">)>)>    
	       <RETURN <> .BALLACT>)>
	<COND (<==? .ARG READ-IN>
	       <COND (<VERB? "WALK">
		      <COND (<SET M
				  <MEMQ <2 ,PRSVEC> <REXITS ,HERE>>>
			     <COND (,BTIE!-FLAG
				    <TELL "You are tied to the ledge.">
				    <RETURN T .BALLACT>)
				   (ELSE
				    <AND <TYPE? <SET R <2 .M>> ROOM>
					 <NOT <RTRNN .R ,RMUNGBIT>>
					 <SETG BLOC .R>>
				    <CLOCK-INT ,BINT 3>
				    <RETURN <> .BALLACT>)>)
			    (<TELL 
"I'm afraid you can't control the balloon in this way.">
			     <RETURN T .BALLACT>)>)
		     (<AND <VERB? "TAKE">
			   <==? ,BINF!-FLAG <PRSO>>>
	       	      <TELL "You don't really want to hold a burning "
		     	    1
		            <ODESC2 <PRSO>>
		            ".">
		      <RETURN T .BALLACT>)
		     (<AND <VERB? "PUT">
			   <==? <PRSI> .CONT>
			   <NOT <EMPTY? <OCONTENTS .CONT>>>>
		      <TELL "The receptacle is already occupied.">
		      <RETURN T .BALLACT>)
		     (<RETURN <> .BALLACT>)>)>
	<COND (<VERB? "C-INT">
	       <COND (<OR <AND <TRNN .CONT ,OPENBIT> ,BINF!-FLAG>
			  <MEMBER "LEDG" <STRINGP <RID ,HERE>>>>
		      <RISE-AND-SHINE .BALL>)
		     (<DECLINE-AND-FALL .BALL>)>)>>

<SETG BLAB!-FLAG <>>

<GDECL (BURNUP-INT BINT) CEVENT>

<DEFINE RISE-AND-SHINE (BALL
			"AUX" (S <TOP ,SCRSTR>) M
			      (IN? <==? <AVEHICLE ,WINNER> .BALL>) (BL ,BLOC))
	#DECL ((BALL) OBJECT (BL) ROOM (M) <OR FALSE STRING> (S) STRING
	       (IN?) <OR ATOM FALSE>)
	<CLOCK-INT ,BINT 3>
	<COND (<SET M <MEMBER "VAIR" <STRINGP <RID .BL>>>>
	       <COND (<=? <REST .M 4> "4">
		      <CLOCK-DISABLE ,BURNUP-INT>
		      <CLOCK-DISABLE ,BINT>
		      <REMOVE-OBJECT .BALL>
		      <INSERT-OBJECT <SFIND-OBJ "DBALL"> <SFIND-ROOM "VLBOT">>
		      <COND (.IN?
			     <JIGS-UP 

"Your balloon has hit the rim of the volcano, ripping the cloth and
causing you a 500 foot drop.  Did you get your flight insurance?">)
			    (<==? ,HERE <SFIND-ROOM "VLBOT">>
			     <TELL
"You watch the balloon explode after hitting the rim; its tattered
remains land on the ground by your feet.">)
			    (<TELL 
"You hear a boom and notice that the balloon is falling to the ground.">)>
		      <SETG BLOC <SFIND-ROOM "VLBOT">>)
		     (<SUBSTRUC <STRINGP <RID .BL>> 0 4 .S>
		      <PUT .S 5 <CHTYPE <+ <CHTYPE <5 .M> FIX> 1> CHARACTER>>
		      <COND (.IN?
			     <GOTO <SETG BLOC <FIND-ROOM .S>>>
			     <TELL "The balloon ascends.">
			     <ROOM-INFO>)
			    (<PUT-BALLOON .BALL .S "ascends.">)>)>)
	      (<SET M <MEMBER "LEDG" <STRINGP <RID .BL>>>>
	       <SUBSTRUC "VAIR" 0 4 .S>
	       <PUT .S 5 <5 .M>>
	       <COND (.IN?
		      <GOTO <SETG BLOC <FIND-ROOM .S>>>
		      <TELL "The balloon leaves the ledge.">
		      <ROOM-INFO>)
		     (<CLOCK-INT ,VLGIN 10>
		      <PUT-BALLOON .BALL .S "floats away.  It seems to be ascending,
due to its light load.">)>)
	      (.IN?
	       <GOTO <SETG BLOC <SFIND-ROOM "VAIR1">>>
	       <TELL "The balloon rises slowly from the ground.">
	       <ROOM-INFO>)
	      (<PUT-BALLOON .BALL "VAIR1" "lifts off.">)>>

<DEFINE BALLOON-BURN ("AUX" BLABE (BALL <SFIND-OBJ "BALLO">))
 	#DECL ((BALL BLABE) OBJECT)
	<TELL "The "
	      1
	      <ODESC2 <PRSO>>
	      " burns inside the receptacle.">
	<SETG BURNUP-INT <CLOCK-INT ,BRNIN <* <OSIZE <PRSO>> 20>>>
	<TRO <PRSO> <+ ,FLAMEBIT ,LIGHTBIT ,ONBIT>>
	<TRZ <PRSO> <+ ,TAKEBIT ,READBIT>>
	<COND (,BINF!-FLAG)
	      (<TELL 
		"The cloth bag inflates as it fills with hot air.">
	       <COND (<NOT ,BLAB!-FLAG>
		      <PUT .BALL
			   ,OCONTENTS
			   (<SET BLABE <SFIND-OBJ "BLABE">>
			    !<OCONTENTS .BALL>)>
		      <PUT .BLABE ,OCAN .BALL>)>
	       <SETG BLAB!-FLAG T>
	       <SETG BINF!-FLAG <PRSO>>
	       <CLOCK-INT ,BINT 3>)>>

<DEFINE PUT-BALLOON (BALL THERE STR "AUX" (HERE ,HERE)) 
	#DECL ((BALL) OBJECT (HERE) ROOM (THERE STR) STRING)
	<COND (<OR <MEMBER "LEDG" <STRINGP <RID .HERE>>>
		   <==? .HERE <FIND-ROOM "VLBOT">>>
	       <TELL "You watch as the balloon slowly " 1 .STR>)>
	<REMOVE-OBJECT .BALL>
	<INSERT-OBJECT .BALL <SETG BLOC <FIND-ROOM .THERE>>>>

<GDECL (BLOC) ROOM>

<DEFINE DECLINE-AND-FALL (BALL "AUX" (S <TOP ,SCRSTR>) M (BL ,BLOC)
			    (IN? <==? <AVEHICLE ,WINNER> .BALL>) FOO)
    #DECL ((BALL) OBJECT (BL) ROOM (M) <OR FALSE STRING> (S) STRING
	   (IN?) <OR ATOM FALSE> (FOO) CEVENT)
    <CLOCK-INT ,BINT 3>
    <COND (<SET M <MEMBER "VAIR" <STRINGP <RID .BL>>>>
	   <COND (<=? <REST .M 4> "1">
		  <COND (.IN?
			 <GOTO <SETG BLOC <SFIND-ROOM "VLBOT">>>
			 <COND (,BINF!-FLAG
				<TELL "The balloon has landed.">
				<CLOCK-INT ,BINT 0>
				<ROOM-INFO>)
			       (T
				<REMOVE-OBJECT .BALL>
				<INSERT-OBJECT <SFIND-OBJ "DBALL"> ,BLOC>
				<PUT ,WINNER ,AVEHICLE <>>
				<CLOCK-DISABLE <SET FOO <CLOCK-INT ,BINT 0>>>
				<TELL 
"You have landed, but the balloon did not survive.">)>)
			(<PUT-BALLOON .BALL "VLBOT" "lands.">)>)
		 (<SUBSTRUC <STRINGP <RID .BL>> 0 4 .S>
		  <PUT .S 5 <CHTYPE <- <CHTYPE <5 .M> FIX> 1> CHARACTER>>
		  <COND (.IN?
			 <GOTO <SETG BLOC <FIND-ROOM .S>>>
			 <TELL "The balloon descends.">
			 <ROOM-INFO>)
			(<PUT-BALLOON .BALL .S "descends.">)>)>)>>

<DEFINE BCONTENTS ()
    <COND (<VERB? "TAKE">
	   <TELL 
"The " 0 <ODESC2 <PRSO>> " is an integral part of the basket and cannot
be removed.">
	   <COND (<==? <PRSO> <SFIND-OBJ "BROPE">>
		  <TELL " The wire might possibly be tied, though.">)
		 (<TELL "">)>)
	  (<VERB? "FIND" "EXAMI">
	   <TELL 
"The " 1 <ODESC2 <PRSO>> " is part of the basket.  It may be manipulated
within the basket but cannot be removed.">)>>

<DEFINE WIRE-FUNCTION ("AUX" (BINT ,BINT))
        #DECL ((BINT) CEVENT)
        <COND (<VERB? "TAKE" "FIND" "EXAMI">
	       <BCONTENTS>)
	      (<VERB? "TIE">
	       <COND (<AND <==? <PRSO> <SFIND-OBJ "BROPE">>
			   <OR <==? <PRSI> <SFIND-OBJ "HOOK1">>
			       <==? <PRSI> <SFIND-OBJ "HOOK2">>>>
		      <SETG BTIE!-FLAG <PRSI>>
		      <ODESC1 <PRSI>
			  "The basket is anchored to a small hook by the braided wire.">
		      <CLOCK-DISABLE .BINT>
		      <TELL "The balloon is fastened to the hook.">)>)
	      (<AND <VERB? "UNTIE">
	            <==? <PRSO> <SFIND-OBJ "BROPE">>>
	       <COND (,BTIE!-FLAG
		      <CLOCK-ENABLE <SET BINT <CLOCK-INT ,BINT 3>>>
	       	      <ODESC1 ,BTIE!-FLAG ,HOOK-DESC>
		      <SETG BTIE!-FLAG <>>
	              <TELL "The wire falls off of the hook.">)
		     (<TELL "The wire is not tied to anything.">)>)>>

<DEFINE BURNUP ("AUX" (R <SFIND-OBJ "RECEP">) (OBJ <1 <OCONTENTS .R>>))
    #DECL ((R OBJ) OBJECT)
    <COND (<==? ,HERE ,BLOC>
	   <TELL 
"You notice that the " 1 <ODESC2 .OBJ> " has burned out, and that
the cloth bag starts to deflate.">)>
    <PUT .R ,OCONTENTS <SPLICE-OUT .OBJ <OCONTENTS .R>>>
    <SETG BINF!-FLAG <>>
    T>

<SETG SAFE-FLAG!-FLAG <>>

<DEFINE SAFE-ROOM ()
    <COND (<VERB? "LOOK">
	   <TELL 
"You are in a dusty old room which is virtually featureless, except
for an exit on the north side."
	         ,LONG-TELL1
		 <COND (<NOT ,SAFE-FLAG!-FLAG>
			"
Imbedded in the far wall, there is a rusty old box.  It appears that
the box is somewhat damaged, since an oblong hole has been chipped
out of the front of it.")
		       ("
On the far wall is a rusty box, whose door has been blown off.")>>)>>

<DEFINE SAFE-FUNCTION () 
	<COND (<VERB? "TAKE">
	       <TELL "The box is imbedded in the wall.">)
	      (<VERB? "OPEN">
	       <COND (,SAFE-FLAG!-FLAG <TELL "The box has no door!">)
		     (<TELL "The box is rusted and will not open.">)>)
	      (<VERB? "CLOSE">
	       <COND (,SAFE-FLAG!-FLAG <TELL "The box has no door!">)
		     (<TELL "The box is not open, chomper!">)>)>>

<DEFINE BRICK-FUNCTION ()
    <COND (<VERB? "BURN">
	   <REMOVE-OBJECT <FIND-OBJ "BRICK">>
	   <JIGS-UP ,BRICK-BOOM>)>>

<DEFINE FUSE-FUNCTION ("AUX" (FUSE <SFIND-OBJ "FUSE">)
			     (BRICK <SFIND-OBJ "BRICK">) BRICK-ROOM OC)
	#DECL ((FUSE BRICK) OBJECT (BRICK-ROOM) <OR ROOM FALSE>
	       (OC) <OR OBJECT FALSE>)
	<COND (<VERB? "BURN">
	       <TELL "The wire starts to burn.">
	       <CLOCK-ENABLE <CLOCK-INT ,FUSIN 2>>)
	      (<VERB? "C-INT">
	       <COND (<==? <OCAN .FUSE> .BRICK>
		      <COND (<SET OC <OCAN .BRICK>>
			     <SET BRICK-ROOM <OROOM .OC>>)
			    (<SET BRICK-ROOM <OROOM .BRICK>>)>
		      <OR .BRICK-ROOM <SET BRICK-ROOM ,HERE>>
		      <COND (<==? .BRICK-ROOM ,HERE>
			     <MUNG-ROOM .BRICK-ROOM
				"The way is blocked by debris from an explosion.">
			     <JIGS-UP ,BRICK-BOOM>)
			    (<==? .BRICK-ROOM <SFIND-ROOM "SAFE">>
			     <CLOCK-INT ,SAFIN 5>
			     <SETG MUNGED-ROOM <OROOM .BRICK>>
			     <TELL "There is an explosion nearby.">
			     <COND (<MEMQ .BRICK <OCONTENTS <SFIND-OBJ "SSLOT">>>
				    <TRZ <SFIND-OBJ "SSLOT"> ,OVISON>
				    <TRO <SFIND-OBJ "SAFE"> ,OPENBIT>
				    <SETG SAFE-FLAG!-FLAG T>)>)
			    (<TELL "There is an explosion nearby.">
			     <CLOCK-INT ,SAFIN 5>
			     <SETG MUNGED-ROOM .BRICK-ROOM>
			     <MAPF <>
				   <FUNCTION (X)
				     #DECL ((X) OBJECT)
				     <COND (<TRNN .X ,TAKEBIT>
					    <TRZ .X ,OVISON>)>>
				   <ROBJS .BRICK-ROOM>>
			     <COND (<==? .BRICK-ROOM <SFIND-ROOM "LROOM">>
				    <MAPF <>
					  <FUNCTION (X) #DECL ((X) OBJECT)
					    <PUT .X ,OCAN <>>>
					  <OCONTENTS <SFIND-OBJ "TCASE">>>
				    <PUT <SFIND-OBJ "TCASE"> ,OCONTENTS ()>)>)>
		      <REMOVE-OBJECT .BRICK>)
		     (<OR <NOT <OROOM .FUSE>> <==? ,HERE <OROOM .FUSE>>>
		      <TELL "The wire rapidly burns into nothingness.">)>
	       <REMOVE-OBJECT .FUSE>)>>

<DEFINE SAFE-MUNG ("AUX" (RM ,MUNGED-ROOM)) 
	#DECL ((RM) ROOM)
	<COND (<==? ,HERE .RM>
	       <JIGS-UP
		<COND (<RTRNN .RM ,RHOUSEBIT>
"The house shakes, and the ceiling of the room you're in collapses,
turning you into a pancake.") 
("The room trembles and 50,000 pounds of rock fall on you, turning you
into a pancake.")>>)
	      (<TELL
"You may recall that recent explosion.  Well, probably as a result of
that, you hear an ominous rumbling, as if one of the rooms in the
dungeon had collapsed." ,LONG-TELL1>
	       <AND <==? .RM <SFIND-ROOM "SAFE">>
		    <CLOCK-INT ,LEDIN 8>>)>
	<MUNG-ROOM .RM "The way is blocked by debris from an explosion.">>

<DEFINE LEDGE-MUNG ("AUX" (RM <SFIND-ROOM "LEDG4">))
    #DECL ((RM) ROOM)
    <COND (<==? ,HERE .RM>
	   <COND (<AVEHICLE ,WINNER>
		  <COND (,BTIE!-FLAG
			 <SET RM <SFIND-ROOM "VLBOT">>
			 <SETG BLOC .RM>
			 <REMOVE-OBJECT <SFIND-OBJ "BALLO">>
			 <INSERT-OBJECT <SFIND-OBJ "DBALL"> .RM>
			 <SETG BTIE!-FLAG <>>
			 <SETG BINF!-FLAG <>>
			 <CLOCK-DISABLE ,BINT>
			 <CLOCK-DISABLE ,BRNIN>
			 <JIGS-UP
"The ledge collapses, probably as a result of the explosion.  A large
chunk of it, which is attached to the hook, drags you down to the
ground.  Fatally.">)
			(<TELL "The ledge collapses, leaving you with no place to land.">)>)
		 (T
		  <JIGS-UP
"The force of the explosion has caused the ledge to collapse
belatedly.">)>)
	  (<TELL "The ledge collapses, giving you a narrow escape.">)>
    <MUNG-ROOM .RM "The ledge has collapsed and cannot be landed on.">>

<DEFINE LEDGE-FUNCTION ()
    <COND (<VERB? "LOOK">
	   <TELL 
"You are on a wide ledge high into the volcano.  The rim of the
volcano is about 200 feet above and there is a precipitous drop below
to the bottom." ,LONG-TELL1
		<COND (<RTRNN <SFIND-ROOM "SAFE"> ,RMUNGBIT>
		       " The way to the south is blocked by rubble.")
		      (" There is a small door to the south.")>>)>>

<DEFINE BLAST ()
    <COND (<==? ,HERE <SFIND-ROOM "SAFE">>)
	  (<TELL "I don't really know how to do that.">)>>

<DEFINE VOLGNOME ()
    <COND (<MEMBER "LEDG" <STRINGP <RID ,HERE>>>
	   <TELL ,GNOME-DESC ,LONG-TELL1>
	   <INSERT-OBJECT <SFIND-OBJ "GNOME"> ,HERE>)
	  (<CLOCK-INT ,VLGIN 1>)>>

<SETG GNOME-DOOR!-FLAG <SETG GNOME-FLAG!-FLAG <>>>

<DEFINE GNOME-FUNCTION ("AUX" (GNOME <SFIND-OBJ "GNOME">) BRICK)
    #DECL ((GNOME) OBJECT (BRICK) OBJECT)
    <COND (<AND <VERB? "GIVE" "THROW">
		<COND (<N==? <OTVAL <PRSO>> 0>
		       <TELL 
"Thank you very much for the " ,LONG-TELL1 <ODESC2 <PRSO>> ".  I don't believe 
I've ever seen one as beautiful. 'Follow me', he says, and a door 
appears on the west end of the ledge.  Through the door, you can see
a narrow chimney sloping steeply downward.  The gnome moves quickly,
and he disappears from sight.">
		       <REMOVE-OBJECT <PRSO>>
		       <REMOVE-OBJECT .GNOME>
		       <SETG GNOME-DOOR!-FLAG T>)
		      (<BOMB? <PRSO>>
		       <OR <OROOM <SET BRICK <SFIND-OBJ "BRICK">>>
			   <INSERT-OBJECT .BRICK ,HERE>>
		       <REMOVE-OBJECT .GNOME>
		       <CLOCK-DISABLE ,GNOIN>
		       <CLOCK-DISABLE ,VLGIN>
		       <TELL
"'That certainly wasn't what I had in mind', he says, and disappears.">)
		      (<TELL
"'That wasn't quite what I had in mind', he says, crunching the
" 1 <ODESC2 <PRSO>> " in his rock-hard hands.">
		       <REMOVE-OBJECT <PRSO>>)>>)
	  (<VERB? "C-INT">
	   <COND (<==? ,HERE <OROOM .GNOME>>
		  <TELL
"The gnome glances at his watch.  'Oops.  I'm late for an
appointment!' He disappears, leaving you alone on the ledge." ,LONG-TELL1>)>
	   <REMOVE-OBJECT .GNOME>)
	  (<TELL 
"The gnome appears increasingly nervous.">
	   <OR ,GNOME-FLAG!-FLAG <CLOCK-INT ,GNOIN 5>>
	   <SETG GNOME-FLAG!-FLAG T>)>>