
; "SUBTITLE THE ENDGAME"

<OR <GASSIGNED? END-GAME!-FLAG> <BLOAT 20000 0 0 500>>

"============ ZORK END-GAME FUNCTIONS ============="

<SETG END-GAME-EXISTS? T>

;"enable endgame"

<SETG END-GAME!-FLAG <>>

;"endgame has begun?"

<DEFMAC DOPEN ('OBJ) <FORM TRO .OBJ ,OPENBIT>>

<DEFMAC DCLOSE ('OBJ) <FORM TRZ .OBJ ,OPENBIT>>

<DEFINE DPR (OBJ)
	#DECL ((OBJ) OBJECT)
	<COND (<TRNN .OBJ ,OPENBIT> "open.")("closed.")>>

;"SUBTITLE Is There Life after Death?"

<DEFINE TOMB-FUNCTION ()
  <COND (<VERB? "LOOK">
	 <TELL ,TOMB-DESC1
	       ,LONG-TELL1 <DPR <SFIND-OBJ "TOMB">>
	       ,TOMB-DESC2>)>>

<DEFINE CRYPT-FUNCTION ("AUX" (EG? ,END-GAME!-FLAG))
  #DECL ((EG?) <OR ATOM FALSE>)
  <COND (<AND .EG? <VERB? "LOOK">>
	 <TELL ,CRYPT-DESC
	       ,LONG-TELL1
		<DPR <SFIND-OBJ "TOMB">>>)>>

<DEFINE CRYPT-OBJECT ("AUX" (EG? ,END-GAME!-FLAG)
		      (C <SFIND-OBJ "TOMB">))
  #DECL ((EG?) <OR ATOM FALSE> (C) OBJECT)
  <COND (<AND <NOT .EG?> <HEAD-FUNCTION>>)
	(<AND .EG? <VERB? "OPEN">>
	 <COND (<NOT <TRNN .C ,OPENBIT>>
		<DOPEN .C>
		<TELL
"The door of the crypt is extremely heavy, but it opens easily.">)
	       (ELSE
		<TELL "The crypt is already open.">)>
	 T)
	(<AND .EG? <VERB? "CLOSE">>
	 <COND (<TRNN .C ,OPENBIT>
		<DCLOSE .C>
		<TELL "The crypt is closed.">)
	       (ELSE <TELL "The crypt is already closed.">)>
	 <COND (<==? ,HERE <SFIND-ROOM "CRYPT">>
		<CLOCK-INT ,STRTE 3>)>)>>

<SETG INCANT-OK <>>

<DEFINE START-END ("AUX" (HERE ,HERE))
	#DECL ((HERE) ROOM)
	<COND (<==? .HERE <SFIND-ROOM "CRYPT">>
	       <COND (<LIT? .HERE>
		      <CLOCK-INT ,STRTE 3>)
		     (ELSE
		      <TELL ,PASS-WORD-INST ,LONG-TELL1>
		      <SETG INCANT-OK T>
		      <ENTER-END-GAME>)>)>>

<DEFINE ENTER-END-GAME ("AUX" (LAMP <SFIND-OBJ "LAMP">) (SWORD <SFIND-OBJ "SWORD">)
			C (W ,WINNER))
	#DECL ((LAMP SWORD) OBJECT (C) <VECTOR FIX CEVENT> (W) ADV)
	<CLOCK-DISABLE ,EGHER>
	<TRO .LAMP ,LIGHTBIT>
	<TRZ .LAMP ,ONBIT>
	<PUT <SET C <OLINT .LAMP>> 1 0>
	<PUT <2 .C> ,CTICK 350>
	<PUT <2 .C> ,CFLAG <>>
	<PUT ,SWORD-DEMON
	     ,HACTION
	     <COND (<TYPE? ,SWORD-GLOW NOFFSET> ,SWORD-GLOW)
		   (SWORD-GLOW)>>
	<PUT ,ROBBER-DEMON ,HACTION <>>
	<MAPF <>
	      <FUNCTION (O "AUX" L)
		   #DECL ((O) OBJECT (L) <OR FALSE <VECTOR FIX CEVENT>>)
		   <COND (<SET L <OLINT .O>> <CLOCK-DISABLE <2 .L>>)>>
	      <AOBJS .W>>
	<TRO .LAMP ,TOUCHBIT>
	<TRO .SWORD ,TOUCHBIT>
	<PUT <PUT .LAMP ,OROOM <>> ,OCAN <>>
	<PUT <PUT .SWORD ,OROOM <>> ,OCAN <>>
	<PUT .W ,AOBJS (.LAMP .SWORD)>
	<SETG END-GAME!-FLAG T>
	<SCORE-ROOM <SFIND-ROOM "CRYPT">>
	<GOTO <SFIND-ROOM "TSTRS">>
	<ROOM-DESC>>

\ 

;"SUBTITLE It's All Done with Mirrors"

<SETG MR1!-FLAG T>

<SETG MR2!-FLAG T>

<SETG MIRROR-OPEN!-FLAG <>>

<SETG WOOD-OPEN!-FLAG <>>

<SETG MRSWPUSH!-FLAG <>>

<DEFINE MRGO ("AUX" (DIR <2 ,PRSVEC>) (NRM <MEMQ .DIR <REXITS ,HERE>>) (CEX <2 .NRM>)
		    (TORM <CXROOM .CEX>) (MDIR ,MDIR))
	#DECL ((DIR) DIRECTION (NRM) <VECTOR DIRECTION CEXIT>
	       (CEX) CEXIT (TORM) ROOM (MDIR) FIX)
	<COND (<MEMQ .DIR [<FIND-DIR "NORTH"> <FIND-DIR "SOUTH">]>
	       <COND (<==? ,MLOC .TORM>
		      <COND (<N-S .MDIR>
			     <TELL "There is a wooden wall blocking your way.">)
			    (<MIRBLOCK .DIR .MDIR>)>
		      <>)
		     (.TORM)>)
	      (<==? ,MLOC .TORM>
	       <COND (<N-S .MDIR> <GO-E-W .TORM .DIR>)
		     (<MIRBLOCK .DIR .MDIR> <>)>)
	      (.TORM)>>

<DEFINE MIRBLOCK (DIR MDIR)
	#DECL ((DIR) DIRECTION (MDIR) FIX)
	<COND (<==? .DIR <FIND-DIR "SOUTH">>
	       <SET MDIR <MOD <+ .MDIR 180> 360>>)>
	<COND (<OR <AND <==? .MDIR 270> <NOT ,MR1!-FLAG>>
		   <AND <==? .MDIR 90> <NOT ,MR2!-FLAG>>>
	       <TELL "There is a large broken mirror blocking your way.">)
	      (ELSE
	       <TELL "There is a large mirror blocking your way.">)>>

<DEFINE GO-E-W (RM DIR
		"AUX" (SPR <STRINGP <RID .RM>>) (STR ,MRESTR))
	#DECL ((RM) ROOM (DIR) DIRECTION (SPR STR) STRING)
	<COND (<AND <NOT <==? .DIR <FIND-DIR "NE">>>
		    <NOT <==? .DIR <FIND-DIR "SE">>>>
	       <SET STR ,MRWSTR>)>
	<FIND-ROOM <SUBSTRUC .SPR 0 3 .STR>>>

<SETG MRESTR "   E">

<SETG MRWSTR "MRBW">

<DEFMAC N-S ('FX) <FORM 0? <FORM MOD .FX 180>>>

<DEFMAC E-W ('FX) <FORM OR <FORM ==? .FX 90> <FORM ==? .FX 270>>>

<DEFINE EWTELL (RM "AUX" (EAST? <==? <4 <STRINGP <RID .RM>>> !\E>) M1? MWIN) 
	#DECL ((RM) ROOM (EAST? MWIN M1?) <OR FALSE ATOM>)
	<SET MWIN
	     <COND (<SET M1? <==? 180 <+ ,MDIR <COND (.EAST? 0) (180)>>>>
		    ,MR1!-FLAG)
		   (,MR2!-FLAG)>>
	<TELL
"You are in a narrow room, whose "
	      0
	      <COND (.EAST? "west") ("east")>
	      			    " wall is a large ">
	<TELL <COND (.MWIN "mirror.") (		      "wooden panel
which once contained a mirror.")>>
	<AND .M1? ,MIRROR-OPEN!-FLAG <TELL <COND (.MWIN ,MIROPEN) (,PANOPEN)>>>
	<TELL "The opposite wall is solid rock.">>

<DEFINE MRCEW () 
	<COND (<VERB? "LOOK">
	       <EWTELL ,HERE>
	       <TELL "Somewhat to the north" ,LONG-TELL1 ,GUARDSTR>)>>

<DEFINE MRBEW ()
	<COND (<VERB? "LOOK">
	       <EWTELL ,HERE>
	       <TELL "To the north and south are large hallways.">)>>

<DEFINE MRAEW () 
	<COND (<VERB? "LOOK">
	       <EWTELL ,HERE>
	       <TELL "To the north is a large hallway.">)>>

;"LOOK-TO -- takes room to north, room to south (if any), and instructions
for describing what is north and south.  These are interpreted as:
STRING -- print it, T -- guardians are there, otherwise, nothing interesting.
If the mirror is found to north or south, the corresponding instruction is
set to T, and later innocuous messages are printed for the directions with
nothing interesting in them."

<DEFINE LOOK-TO (NSTR "OPTIONAL" (SSTR <>) (NTELL <>) (STELL <>) (HTELL T)
		 "AUX" (NRM <>) (SRM <>) NORTH? (MDIR ,MDIR) MIR? (M1? <>) DIR)
	#DECL ((DIR) STRING (NSTR SSTR) <OR STRING FALSE>
	       (NTELL STELL) <OR ATOM FALSE STRING>
	       (HTELL NORTH? MIR? M1?) <OR ATOM FALSE> (RM) ROOM
	       (NRM SRM) <OR ROOM FALSE> (MDIR) FIX)
	<AND <TYPE? .NSTR STRING> <SET NRM <FIND-ROOM .NSTR>>>
	<AND <TYPE? .SSTR STRING> <SET SRM <FIND-ROOM .SSTR>>>
	<AND .HTELL <TELL ,HALLWAY ,LONG-TELL1>>
	<COND (<TYPE? .NTELL ATOM>
	       <TELL "Somewhat to the north" ,LONG-TELL1 ,GUARDSTR>)
	      (<TYPE? .NTELL STRING> <TELL .NTELL>)>
	<COND (<TYPE? .STELL ATOM>
	       <TELL "Somewhat to the south" ,LONG-TELL1 ,GUARDSTR>)
	      (<TYPE? .STELL STRING> <TELL .STELL>)>
	<COND (<PROG ()
		     <COND (<==? ,MLOC .NRM>
			    <SET NORTH? <SET NTELL T>> <SET DIR "north">)
			   (<==? ,MLOC .SRM>
			    <SET NORTH? <>> <SET STELL T> <SET DIR "south">)>>
	       <SET MIR?
		    <COND (<OR <AND .NORTH? <G? .MDIR 180> <L? .MDIR 359>>
			       <AND <NOT .NORTH?> <G? .MDIR 0> <L? .MDIR 179>>>
			   <SET M1? T>
			   ,MR1!-FLAG)
			  (,MR2!-FLAG)>>
	       <COND (<N-S .MDIR>
		      <TELL "The "
			    0
			    .DIR
			    
" side of the room is divided by a wooden wall into small
hallways to the ">
		      <TELL .DIR 0 "east and ">
		      <TELL .DIR 1 "west.">)
		     (ELSE
		      <TELL <COND (.MIR? "A large mirror fills the ")
				  ("A large panel fills the ")>
			    1
			    .DIR
			    " side of the hallway.">
		      <AND .M1?
			   ,MIRROR-OPEN!-FLAG
			   <TELL <COND (.MIR? ,MIROPEN)(,PANOPEN)> ,LONG-TELL1>>
		      <OR .MIR?
			  <TELL "The shattered pieces of a mirror cover the floor.">>)>)>
	<AND .HTELL
	     <COND (<AND <NOT .NTELL> <NOT .STELL>>
		    <TELL "The corridor continues north and south.">)
		   (<NOT .NTELL> <TELL "The corridor continues north.">)
		   (<NOT .STELL> <TELL "The corridor continues south.">)>>
	T>

<DEFINE MRDF () 
	<COND (<VERB? "LOOK">
	       <LOOK-TO "FDOOR" "MRG" <> T>)>>

<DEFINE MRCF () 
	<COND (<VERB? "LOOK">
	       <LOOK-TO "MRG" "MRB" T>)>>

<DEFINE MRBF () 
	<COND (<VERB? "LOOK">
	       <LOOK-TO "MRC" "MRA">)>>

<DEFINE MRAF () 
	<COND (<VERB? "LOOK">
	       <LOOK-TO "MRB" <> <> "A passage enters from the south.">)>>

"Infestation function for Sword-glow demon, tailored for end game"

<DEFINE EG-INFESTED? (R "AUX" (M <SFIND-ROOM "MRG">))
	#DECL ((R M) ROOM)
	<OR <==? .R .M>
	    <AND <==? ,MLOC .M> <==? .R <SFIND-ROOM "INMIR">>>
	    <==? .R <SFIND-ROOM "MRGE">>
	    <==? .R <SFIND-ROOM "MRGW">>>>

<DEFINE GUARDIANS ()
   	<COND (<VERB? "GO-IN">
	       <TELL ,GUARDKILL ,LONG-TELL1>
	       <JIGS-UP "">)
	      (<VERB? "ATTAC">
	       <TELL ,GUARD-ATTACK ,LONG-TELL1>
	       <JIGS-UP "">)
	      (<VERB? "HELLO">
	       <TELL "The statues are impassive.">)>>

<DEFINE MIRROR-DIR? (DIR RM "AUX" M (MDIR ,MDIR))
    #DECL ((MDIR) FIX (DIR) DIRECTION (RM) ROOM
	   (M) <OR FALSE <VECTOR DIRECTION CEXIT>>)
    <AND <SET M <MEMQ <FIND-DIR "NORTH"> <REXITS .RM>>>
	 <==? ,MLOC <CXROOM <2 .M>>>
	 <COND (<OR <AND <==? .DIR <FIND-DIR "NORTH">>
			 <G? .MDIR 180>
			 <L? .MDIR 360>>
		    <AND <==? .DIR <FIND-DIR "SOUTH">>
			 <G? .MDIR 0>
			 <L? .MDIR 180>>>
		1)
	       (2)>>>

<DEFINE WALL-FUNCTION ("AUX" (HERE ,HERE) (NORTH? <>))
	#DECL ((HERE) ROOM (NORTH?) <OR FALSE FIX>)
	<COND (<AND ,END-GAME!-FLAG
		    <N-S ,MDIR>
		    <OR <SET NORTH? <MIRROR-DIR? <FIND-DIR "NORTH"> .HERE>>
			<MIRROR-DIR? <FIND-DIR "SOUTH"> .HERE>>>
	       <COND (<VERB? "PUSH">
		      <TELL "The structure won't budge.">)>)
	      (<RTRNN .HERE ,RNWALLBIT>
	       <TELL "I can't see any wall here.">)>>

<DEFINE MIRROR-HERE? (RM "AUX" (SP <STRINGP <RID .RM>>) (MDIR ,MDIR)) 
	#DECL ((RM) ROOM (SP) STRING (MDIR) FIX)
	<COND (<==? <LENGTH .SP> 4>
	       <COND (<==? 180 <+ .MDIR <COND (<==? <4 .SP> !\E> 0) (180)>>> 1)
		     (2)>)
	      (<N-S .MDIR> <>)
	      (<MIRROR-DIR? <FIND-DIR "NORTH"> .RM>)
	      (<MIRROR-DIR? <FIND-DIR "SOUTH"> .RM>)>>

<DEFINE MIRROR-FUNCTION ("AUX" MIRROR)
 	#DECL ((MIRROR) <OR FIX FALSE>)
	<COND (<NOT <SET MIRROR <MIRROR-HERE? ,HERE>>>
	       <TELL
"I see no mirror here.">)
	      (<VERB? "OPEN" "MOVE">
	       <TELL
"I don't see a way to open the mirror here.">)
	      (<VERB? "LKIN">
	       <COND (<OR <AND <1? .MIRROR> ,MR1!-FLAG> ,MR2!-FLAG>
		      <TELL "A disheveled adventurer stares back at you.">)
		     (<TELL "The mirror is broken into little pieces.">)>)
	      (<VERB? "POKE" "MUNG">
	       <COND (<1? .MIRROR>
		      <COND (,MR1!-FLAG
			     <SETG MR1!-FLAG <>>
			     <TELL ,MIRBREAK ,LONG-TELL1>)
			    (<TELL ,MIRBROKE ,LONG-TELL1>)>)
		     (,MR2!-FLAG
		      <SETG MR2!-FLAG <>>
		      <TELL ,MIRBREAK ,LONG-TELL1>)
		     (<TELL ,MIRBROKE ,LONG-TELL1>)>)
	      (<OR <AND <1? .MIRROR> <NOT ,MR1!-FLAG>> <NOT ,MR2!-FLAG>>
	       <TELL

"Shards of a broken mirror are dangerous to play with.">)
	      (<VERB? "PUSH">
	       <TELL <COND (<1? .MIRROR>

"The mirror is mounted on a wooden panel which moves slightly inward
as you push, and back out when you let go.  The mirror feels fragile.")
			   (T
"The mirror is unyielding, but seems rather fragile.")> ,LONG-TELL1>)>>

<DEFINE PANEL-FUNCTION ("AUX" MIRROR)
 	#DECL ((MIRROR) <OR FIX FALSE>)
	<COND (<NOT <SET MIRROR <MIRROR-HERE? ,HERE>>>
	       <TELL
"I can't see a panel here.">)
	      (<VERB? "OPEN" "MOVE">
	       <TELL
"I don't see a way to open the panel here.">)
	      (<VERB? "POKE" "MUNG">
	       <COND (<1? .MIRROR>
		      <COND (,MR1!-FLAG
			     <TELL ,PANELBREAK ,LONG-TELL1>)
			    (<TELL ,PANELBROKE ,LONG-TELL1>)>)
		     (,MR2!-FLAG
		      <TELL ,PANELBREAK ,LONG-TELL1>)
		     (<TELL ,PANELBROKE ,LONG-TELL1>)>)
	      (<VERB? "PUSH">
	       <TELL <COND (<1? .MIRROR>
"The wooden panel moves slightly inward as you push, and back out
when you let go.")
			   (T
"The panel is unyielding.")>>)>>

<GDECL (DIRVEC) <VECTOR [REST DIRECTION FIX]>>

<DEFINE MIROUT ("AUX" DIR (MDIR ,MDIR) RM)
	#DECL ((DIR) <OR ATOM DIRECTION FIX> (MDIR) FIX (RM) <OR FALSE ROOM>)
	<COND (<==? <2 ,PRSVEC> <FIND-DIR "EXIT">> <SET DIR T>)
	      (ELSE <SET DIR <2 <MEMQ <2 ,PRSVEC> ,DIRVEC>>>)>
	<COND (,MIRROR-OPEN!-FLAG
	       <COND (<OR <NOT <TYPE? .DIR FIX>> <==? <MOD <+ .MDIR 270> 360> .DIR>>
		      <COND (<N-S .MDIR>
			     <MIREW>)
			    (<MIRNS <L? .MDIR 180> T>)>)
		     (<>)>)
	      (,WOOD-OPEN!-FLAG
	       <COND (<OR <NOT <TYPE? .DIR FIX>> <==? <MOD <+ .MDIR 180> 360> .DIR>>
		      <COND (<SET RM <MIRNS <NOT <0? .MDIR>> T>>
		             <TELL "As you leave, the door swings shut.">
			     <SETG WOOD-OPEN!-FLAG <>>
			     .RM)
			    (<>)>)
		     (<>)>)
	      (<>)>>

"MIRNS -- returns room in a given direction from the mirror (north or
south as indicated by first argument).  If second arg is T, then we
are exiting, not moving the mirror, so don't worry about ends."

<DEFINE MIRNS ("OPTIONAL" (NORTH? <L? ,MDIR 180>) (EXIT? <>)
	       "AUX" (MLOC ,MLOC) (REX <REXITS .MLOC>) M EXIT)
	#DECL ((MLOC) ROOM (REX) EXIT (M) <OR FALSE <VECTOR DIRECTION>>
	       (EXIT?) <OR ATOM FALSE> (EXIT) <OR DOOR ROOM CEXIT NEXIT>
	       (NORTH?) <OR FALSE FIX ATOM>)
	<COND (<AND <NOT .EXIT?>
		    <OR <AND .NORTH? <==? .MLOC ,NORTHEND>>
			<AND <NOT .NORTH?> <==? .MLOC ,SOUTHEND>>>>
	       <>)
	      (<SET M
		    <MEMQ <COND (.NORTH? <FIND-DIR "NORTH">) (<FIND-DIR "SOUTH">)>
			  .REX>>
	       <SET EXIT <2 .M>>
	       <COND (<TYPE? .EXIT CEXIT> <CXROOM .EXIT>)
		     (<TYPE? .EXIT ROOM> .EXIT)>)>>

<GDECL (NORTHEND SOUTHEND) ROOM>

<DEFINE MIREW ()
    <FIND-ROOM <SUBSTRUC <STRINGP <RID ,MLOC>>
			 0
			 3
			 <COND (<0? ,MDIR> ,MRWSTR)
			       (,MRESTR)>>>>

<DEFINE MIRIN ()
    <COND (<==? <MIRROR-HERE? ,HERE> 1>
	   <COND (,MIRROR-OPEN!-FLAG <SFIND-ROOM "INMIR">)
		 (<TELL "The panel is closed."> <>)>)
	  (<TELL "The structure blocks your way."> T)>>

<DEFINE MREYE-ROOM ("AUX" O)
    #DECL ((O) <OR FALSE OBJECT>)
    <COND (<VERB? "LOOK">
	   <TELL
"You are in a small room, with narrow passages exiting to the north
and south.  A narrow red beam of light crosses the room at the north
end, inches above the floor." ,LONG-TELL>
	   <COND (<SET O <BEAM-STOPPED?>>
		  <TELL    "  The beam is stopped halfway across the
room by a " 1 <ODESC2 .O> " lying on the floor.">)
		 (<TELL "" 1>)>
	   <LOOK-TO "MRA" <> <> <> <>>)>>

<DEFINE BEAM-STOPPED? ("AUX" (BEAM <SFIND-OBJ "RBEAM">))
	#DECL ((BEAM) OBJECT)
	<MAPF <>
	      <FUNCTION (O)
			#DECL ((O) OBJECT)
			<COND (<N==? .O .BEAM> <MAPLEAVE .O>)>>
	      <ROBJS <SFIND-ROOM "MREYE">>>>

; "This function cannot have its .PRSI and .PRSO's changed to <PRSI> etc!!"

<DEFINE BEAM-FUNCTION ("AUX" (PRSO <PRSO>) (PRSI <PRSI>)
			     (HERE ,HERE) (BEAM <SFIND-OBJ "RBEAM">))
	#DECL ((PRSO PRSI) OBJECT (HERE) ROOM (BEAM) OBJECT)
	<COND (<VERB? "PUT" "POKE" "MUNG">
	       <COND (<VERB? "PUT">
		      <SET PRSI .PRSO>
		      <SET PRSO <PRSI>>)>
	       <COND (<OR <NOT .PRSI> <N==? .PRSO .BEAM>> <>)
		     (<DROP-IF .PRSI>
		      <INSERT-OBJECT .PRSI .HERE>
		      <TELL
"The beam is now interrupted by a " 1 <ODESC2 .PRSI> " lying on the floor.">)
		     (<MEMQ .PRSI <ROBJS .HERE>>
		      <TELL
"The " 1 <ODESC2 .PRSI> " already breaks the beam.">)
		     (<TELL
"You can't break the beam with a " 1 <ODESC2 .PRSI> ".">)>)
	      (<AND <VERB? "TAKE"> <==? <PRSO> .BEAM>>
	       <TELL
"No doubt you have a bottle of moonbeams as well.">)>>

<DEFINE MRSWITCH ("AUX" (HERE ,HERE)) 
	#DECL ((HERE) ROOM)
	<COND (<VERB? "PUSH">
	       <COND (,MRSWPUSH!-FLAG <TELL "The button is already depressed.">)
		     (<TELL "The button becomes depressed.">
		      <COND (<BEAM-STOPPED?>
			     <CLOCK-ENABLE <CLOCK-INT ,MRINT 7>>
			     <SETG MRSWPUSH!-FLAG T>
			     <SETG MIRROR-OPEN!-FLAG T>)
			    (<TELL "The button pops back out.">)>)>)
	      (<VERB? "C-INT">
	       <SETG MRSWPUSH!-FLAG <>>
	       <SETG MIRROR-OPEN!-FLAG <>>
	       <COND (<OR <==? <MIRROR-HERE? .HERE> 1>
			  <==? .HERE <SFIND-ROOM "INMIR">>>
		      <TELL "The mirror quietly swings shut.">)
		     (<==? .HERE <SFIND-ROOM "MRANT">>
		      <TELL "The button pops back to its original position.">)>)>>

<SETG MDIR 270>
<GDECL (MDIR) FIX (MLOC) ROOM>

;"mirror points... 0 = north"

<SETG POLEUP!-FLAG 0>
<GDECL (POLEUP!-FLAG) FIX>

;"pole raised?: 0 -- in hole or channel, 1 -- foor level, 2 -- in air"

<DEFINE MAGIC-MIRROR ("AUX" (MDIR ,MDIR) (MLOC ,MLOC) (STARTER <>))
	#DECL ((MDIR) FIX (MLOC) ROOM (STARTER) <OR ATOM FALSE>)
	<COND (<VERB? "LOOK">
	       <SET STARTER <==? .MLOC ,STARTROOM>>
	       <TELL ,INSIDE-MIRROR-1 ,LONG-TELL>
	       <COND (<AND .STARTER <==? .MDIR 270>>
		      <COND (<NOT <0? ,POLEUP!-FLAG>>
			     <TELL
"has been lifted out
of a hole carved in the stone floor.  There is evidently enough
friction to keep the pole from dropping back down." ,LONG-TELL1>)
			    (ELSE
			     <TELL "has been dropped
into a hole carved in the stone floor.">)>)
		     (<OR <0? .MDIR> <==? .MDIR 180>> 
		      <COND (<NOT <0? ,POLEUP!-FLAG>>
			     <TELL "is positioned above
the stone channel in the floor.">)
			    (ELSE
			     <TELL "has been dropped
into the stone channel incised in the floor.">)>)
		     (ELSE
		      <TELL "is resting on the
stone floor.">)>
	       <TELL ,MIRROR-POLE-DESC
		     ,LONG-TELL1
		     <NTH ,LONGDIRS <+ </ .MDIR 45> 1>>
		     ".">)>>

<GDECL (LONGDIRS) <VECTOR [REST STRING]>>

;"MOVEMENT"

<DEFINE MPANELS ("AUX" (MDIR ,MDIR))
    #DECL ((MDIR) FIX)
    <COND (<VERB? "PUSH">
	   <COND (<NOT <0? ,POLEUP!-FLAG>>
		  <AND <==? ,MLOC <SFIND-ROOM "MRG">>
		       <TELL "The movement of the structure alerts the Guardians.">
		       <JIGS-UP ,GUARDKILL>>
		  <COND (<OR <==? <PRSO> <SFIND-OBJ "RDWAL">>
			     <==? <PRSO> <SFIND-OBJ "YLWAL">>>
			 <SET MDIR <MOD <+ .MDIR 45> 360>>
			 <TELL "The structure rotates clockwise.">)
			(<SET MDIR <MOD <+ .MDIR 315> 360>>
			 <TELL "The structure rotates counterclockwise.">)>
		  <TELL "The arrow on the compass rose now indicates " 
			1
			<NTH ,LONGDIRS <+ 1 </ .MDIR 45>>>
			".">
		  <COND (,WOOD-OPEN!-FLAG
			 <SETG WOOD-OPEN!-FLAG <>>
			 <TELL ,WOOD-CLOSES>)>
		  <SETG MDIR .MDIR>)
		 (<N-S .MDIR>
		  <TELL "The short pole prevents the structure from rotating.">)
		 (<TELL "The structure shakes slightly but doesn't move.">)>)>>

<PSETG WOOD-CLOSES "The pine wall closes quietly.">

<DEFINE MENDS ("AUX" (MDIR ,MDIR) RM (MRG <SFIND-ROOM "MRG">) (MLOC ,MLOC))
	#DECL ((MDIR) FIX
	       (RM) <OR FALSE ROOM> (MRG MLOC) ROOM)
	<COND (<VERB? "PUSH">
	       <COND (<NOT <N-S .MDIR>>
		      <TELL 
"The structure rocks back and forth slightly but doesn't move.">)
		     (<==? <PRSO> <SFIND-OBJ "OAKND">>
		      <COND (<SET RM <MIRNS>> <MIRMOVE <0? .MDIR> .RM>)
			    (<TELL
"The structure has reached the end of the stone channel and won't
budge.">)>)
		     (<TELL "The pine wall swings open.">
		      <AND <OR <==? .MLOC .MRG>
			       <AND <==? .MLOC <SFIND-ROOM "MRD">>
				    <==? .MDIR 0>>
			       <AND <==? .MLOC <SFIND-ROOM "MRC">>
				    <==? .MDIR 180>>>
			   <TELL 
"The pine door opens into the field of view of the Guardians.">
			   <JIGS-UP ,GUARDKILL>>
		      <SETG WOOD-OPEN!-FLAG T>
		      <CLOCK-ENABLE <CLOCK-INT ,PININ 5>>)>)
	      (<VERB? "C-INT">
	       <COND (,WOOD-OPEN!-FLAG
		      <SETG WOOD-OPEN!-FLAG <>>
		      <TELL ,WOOD-CLOSES>)>
	       T)>>

<DEFINE MIRMOVE (NORTH? RM
		 "AUX" (MRG <SFIND-ROOM "MRG">) (PU? <NOT <0? ,POLEUP!-FLAG>>)) 
	#DECL ((NORTH?) <OR FIX ATOM FALSE> (RM MRG) ROOM (PU?) <OR ATOM FALSE>)
	<TELL <COND (.PU? "The structure wobbles ")
		    ("The structure slides ")>
	      1
	      <COND (.NORTH? "north") ("south")>
	      " and stops over another compass rose.">
	<SETG MLOC .RM>
	<AND <==? .RM .MRG>
	     <==? ,HERE <SFIND-ROOM "INMIR">>
	     <COND (.PU?
		    <TELL
"The structure wobbles as it moves, alerting the Guardians.">)
		   (<OR <NOT ,MR1!-FLAG> <NOT ,MR2!-FLAG>>
		    <TELL

"A Guardian notices a wooden structure creeping by, and his
suspicions are aroused.">)
		   (<OR ,MIRROR-OPEN!-FLAG ,WOOD-OPEN!-FLAG>
		    <TELL
"A Guardian notices the open side of the structure, and his suspicions
are aroused.">)>
	     <JIGS-UP ,GUARDKILL1>>
	T>

<DEFINE SHORT-POLE ("AUX" (MDIR ,MDIR) (PU ,POLEUP!-FLAG))
    #DECL ((MDIR PU) FIX)
    <COND (<VERB? "RAISE">
	   <COND (<==? .PU 2>
		  <TELL "The pole cannot be raised further.">)
		 (<SETG POLEUP!-FLAG 2>
		  <TELL "The pole is now slightly above the floor.">)>)
	  (<VERB? "PUSH" "LOWER">
	   <COND (<0? .PU> <TELL "The pole cannot be lowered further.">)
		 (<N-S .MDIR>
		  <TELL "The pole is lowered into the channel.">
		  <SETG POLEUP!-FLAG 0>
		  T)
		 (<AND <==? .MDIR 270> <==? ,MLOC <SFIND-ROOM "MRB">>>
		  <SETG POLEUP!-FLAG 0>
		  <TELL "The pole is lowered into the stone hole.">)
		 (<1? .PU>
		  <TELL "The pole is already resting on the floor.">)
		 (<SETG POLEUP!-FLAG 1>
		  <TELL "The pole now rests on the stone floor.">)>)>>

\ 

; "SUBTITLE The Spanish Inquisition"

<SETG QVEC <REST <IVECTOR 15 '<>> 15>>

<SETG NQVEC <IVECTOR 3 '<>>>

<GDECL (NQVEC QVEC) <VECTOR [REST <OR QUESTION FALSE>]>>

<SETG NQATT 0>

;"tries recorded for this question"

<SETG INQOBJS ()>

<GDECL (NUMS) <VECTOR [REST STRING]>
       (NQATT) FIX
       (INQOBJS) <LIST [REST OBJECT]>
       (NUMOBJS) <VECTOR [REST OBJECT FIX]>>

<DEFINE CORRECT? (ANS CORRECT "AUX" (WORDS ,WORDS-POBL) (ACTIONS ,ACTIONS-POBL)
		  (1CORR <1 .CORRECT>) (OBJECT-OBL ,OBJECT-POBL)) 
	#DECL ((ANS) <VECTOR [REST STRING STRING FIX]> (CORRECT) VECTOR
	       (1CORR) <OR OBJECT ACTION FALSE STRING>
	       (WORDS ACTIONS OBJECT-OBL) POBLIST)
	<REPEAT (W A)
		#DECL ((W) ANY (A) STRING)
		<COND (<EMPTY? .ANS> <RETURN>)
		      (<AND <NOT <EMPTY? <SET A <1 .ANS>>>>
			    <SET W <PLOOKUP .A .WORDS>>
			    <TYPE? .W BUZZ>>
		       <SET ANS <REST .ANS 3>>)
		      (ELSE <RETURN>)>>
	<COND (<TYPE? .1CORR STRING> <MEMBER <1 .ANS> .CORRECT>)
	      (<REPEAT ((LV .ANS) STR ATM OBJ (ADJ <>) VAL)
		       #DECL ((LV) <VECTOR [REST STRING STRING FIX]> (STR) STRING
			      (VAL ATM) ANY
			      (ADJ) <OR FALSE ADJECTIVE>
			      (OBJ) <OR FALSE OBJECT>)
		       <AND <EMPTY? <SET STR <1 .LV>>> <RETURN <>>>
		       <COND (<SET ATM <PLOOKUP .STR .ACTIONS>>
			      <RETURN <==? .ATM .1CORR>>)
			     (<SET ATM <PLOOKUP .STR .WORDS>>
			      <COND (<TYPE? <SET VAL .ATM> ADJECTIVE>
				     <SET ADJ .VAL>)>)
			     (<SET ATM <PLOOKUP .STR .OBJECT-OBL>>
			      <COND (<SET OBJ <SEARCH-LIST <PSTRING .STR>
							   ,INQOBJS .ADJ>>
				     <RETURN <==? .OBJ .1CORR>>)>)>
		       <SET LV <REST .LV 3>>>)>>

<DEFINE INQUISITOR ("OPTIONAL" (ANS <>)
		    "AUX" (NQV ,NQVEC) (QUES <1 .NQV>) (NQATT ,NQATT))
	#DECL ((ANS) <OR FALSE <VECTOR [REST STRING STRING FIX]>>
	       (NQV) <VECTOR [REST QUESTION]> (QUES) QUESTION (NQATT) FIX)
	<COND (<VERB? "C-INT">
	       <TELL "The booming voice asks:
'" 1 <QSTR .QUES> "'">
	       <CLOCK-INT ,INQIN 2>)
	      (<AND .ANS ,INQSTART? <L? .NQATT 5>>
	       <COND (<CORRECT? .ANS <QANS .QUES>>
		      <TELL "The dungeon master says 'Excellent'.">
		      <COND (<EMPTY? <SET NQV <REST .NQV>>>
			     <TELL ,QUIZ-WIN ,LONG-TELL1>
			     <DOPEN <SFIND-OBJ "QDOOR">>
			     <CLOCK-DISABLE ,INQIN>)
			    (<SETG NQATT 0>
			     <SETG NQVEC .NQV>
			     <TELL "The booming voice asks:
'"
				   1
				   <QSTR <1 .NQV>>
				   "'">
			     <CLOCK-INT ,INQIN 2>)>)
		     (<SET NQATT <SETG NQATT <+ 1 .NQATT>>>
		      <TELL "The dungeon master says 'You are wrong." 0>
		      <COND (<==? .NQATT 5>
			     <TELL ,INQ-LOSE ,LONG-TELL1>
			     <CLOCK-DISABLE ,INQIN>)
			    (<TELL " You have "
				   0
				   <NTH ,NUMS <- 5 .NQATT>>
				   " more chance">
			     <TELL
			      <COND (<==? .NQATT 4>
				     ".'")
				    ("s.'")>>)>)>)
	      (<TELL "There is no reply.">)>>

<SETG INQSTART? <>>

;"if D.M. has stated the rules."

<DEFINE INQSTART ("AUX" (QV ,QVEC) (NQV <SETG NQVEC <TOP ,NQVEC>>))
    #DECL ((QV NQV) <VECTOR [REST QUESTION]>)
    <COND (<NOT ,INQSTART?>
	   <CLOCK-ENABLE <CLOCK-INT ,INQIN 2>>
	   <TELL ,QUIZ-RULES ,LONG-TELL1>
	   <SETG INQSTART? T>
	   <SELECT .QV .NQV>
	   <TELL "The booming voice asks:
'" 1 <QSTR <1 .NQV>> "'">)
	  (<TELL
"The Dungeonmaster gazes at you impatiently, and says, 'My conditions
have been stated, abide by them or depart!'">)>>

<DEFINE ANSWER ("AUX" (LV ,LEXV) M NV (HERE ,HERE))
    #DECL ((LV M) <VECTOR [REST STRING STRING FIX]> (HERE) ROOM
	   (NV) <OR FALSE <VECTOR [REST STRING STRING FIX]>>)
    <SET M <MEMBER "" .LV>>
    <COND (<AND .M <==? .HERE <SFIND-ROOM "RIDDL">> <NOT ,RIDDLE-FLAG!-FLAG>>
	   <COND (<SET NV <MEMBER "" <REST .M>>>
		  <COND (<AND <G=? <LENGTH .NV> 4>
		              <NOT <EMPTY? <4 .NV>>>>
		         <SETG PARSE-CONT <REST .NV 3>>)>)>
	   <COND (<CORRECT? <REST .M 3> '["WELL"]>
		  <SETG RIDDLE-FLAG!-FLAG T>
		  <TELL
"There is a clap of thunder and the east door opens.">
		  )>)
	  (<AND .M ,END-GAME!-FLAG <==? .HERE <SFIND-ROOM "FDOOR">>>
	   <INQUISITOR <REST .M 3>>)
	  (<TELL "No one seems to be listening.">)>>

<DEFINE MASTER-ACTOR ("AUX" (HERE ,HERE) (PRSO <2 ,PRSVEC>))  
	#DECL ((HERE) ROOM (PRSO) <OR FALSE OBJECT DIRECTION>)
	<COND (<NOT <TRNN <SFIND-OBJ "QDOOR"> ,OPENBIT>> <TELL "There is no reply.">)
	      (<VERB? "WALK">
	       <COND (<OR <AND <OR <==? .PRSO <FIND-DIR "SOUTH">>
				   <==? .PRSO <FIND-DIR "ENTER">>>
			       <==? .HERE <SFIND-ROOM "NCORR">>>
			  <AND <OR <==? .PRSO <FIND-DIR "NORTH">>
				   <==? .PRSO <FIND-DIR "ENTER">>>
			       <==? .HERE <SFIND-ROOM "SCORR">>>>
		      <TELL
"'I am not permitted to enter the prison cell.'">)
		     (<TELL
"'I prefer to stay where I am, thank you.'">)>)
	      (<MEMQ <PRSA> ,MASTER-ACTIONS>
	       <COND (<VERB? "STAY" "FOLLO">)
		     (<TELL "'If you wish,' he replies.">)>
	       <>)
	      (<TELL "'I cannot perform that action for you.'">)>>

<DEFINE MASTER-FUNCTION ("AUX" (HERE ,HERE))  
	#DECL ((HERE) ROOM)
	<COND (<OR <==? .HERE <SFIND-ROOM "PCELL">>
		   <==? .HERE <SFIND-ROOM "NCELL">>>
	       <COND (<VERB? "TELL">
		      <TELL "He can't hear you.">)
		     (<TELL "He is not here.">)>)
	      (<VERB? "ATTAC">
	       <JIGS-UP ,MASTER-ATTACK>)
	      (<VERB? "TAKE">
	       <TELL
"'I'm willing to accompany you, but not ride in your pocket!'">)>>

<GDECL (MASTER-ACTIONS) UVECTOR>

<DEFINE BDOOR-FUNCTION ()
    <COND (<VERB? "GO-IN">
	   <CLOCK-ENABLE <CLOCK-INT ,FOLIN -1>>)
	  (<VERB? "LOOK">
	   <TELL 
"You are in a narrow north-south corridor.  At the south end is a door
and at the north end is an east-west corridor.  The door is " ,LONG-TELL1
		 <DPR <SFIND-OBJ "QDOOR">>>)>>

<DEFINE FDOOR-FUNCTION ()
    <COND (<VERB? "GO-IN">
	   <CLOCK-INT ,FOLIN 0>)
	  (<VERB? "LOOK">
	   <LOOK-TO <> "MRD"
"You are in a north-south hallway which ends in a large wooden door." <> <>>
	   <TELL 
"The wooden door has a barred panel in it at about head height.  The
panel is " ,LONG-TELL
	   <COND (<AND <CFLAG ,INQIN> <NOT <0? <CTICK ,INQIN>>>> "open")("closed")>>
	   <TELL " and the door is " 1 <DPR <SFIND-OBJ "QDOOR">>>
	   T)>>

<DEFINE WOOD-DOOR ()
    <COND (<VERB? "OPEN" "CLOSE">
	   <TELL "The door won't budge.">)
	  (<VERB? "KNOCK">
	   <COND (,INQSTART?
		  <TELL "There is no answer.">)
		 (<INQSTART>)>)>>

<SETG FOLFLAG T>	;"Following?"

<DEFINE FOLLOW ("AUX" (WIN ,WINNER) (MAST <OACTOR <SFIND-OBJ "MASTE">>)
		      (HERE ,HERE) (MROOM <AROOM .MAST>))
	#DECL ((WIN MAST) ADV (HERE MROOM) ROOM)
	<COND (<VERB? "C-INT">
	       <COND (<==? .HERE .MROOM>)
		     (<AND <N==? .HERE <SFIND-ROOM "CELL">>
			   <N==? .HERE <SFIND-ROOM "PCELL">>>
		      <AND <MEMQ <AOBJ .MAST> <ROBJS .MROOM>>
			   <PUT .MROOM
				,ROBJS
				<SPLICE-OUT <AOBJ .MAST> <ROBJS .MROOM>>>>
		      <PUT .MAST ,AROOM .HERE>
		      <SETG FOLFLAG T>
		      <INSERT-OBJECT <AOBJ .MAST> .HERE>
		      <TELL <COND (<MEMQ .HERE <REXITS .MROOM>>
				   "The dungeon master follows you.")
				  ("The dungeon master catches up to you.")>>)
		     (,FOLFLAG
		      <TELL 
"You notice that the dungeon master does not follow.">
		      <SETG FOLFLAG <>>
		      T)>)
	      (<==? .WIN .MAST>
	       <CLOCK-INT ,FOLIN -1>
	       <TELL "The dungeon master answers, 'I will follow.'">)
	      (<2 ,PRSVEC>
	       <COND (<TRNN <PRSO> ,VILLAIN>
		      <TELL "The " 1 <ODESC2 <PRSO>> " eludes you.">)
		     (<TELL "I don't enjoy leading crazies through the dungeon.">)>)
	      (<TELL "Ok.">)>>

<DEFINE STAY ()
    <COND (<==? ,WINNER <OACTOR <SFIND-OBJ "MASTE">>>
	   <CLOCK-INT ,FOLIN 0>
	   <TELL "The dungeon master says, 'I will stay.'">)
	  (<==? ,WINNER ,PLAYER>
	   <TELL "You will be lost without me.">)>>

\ 

;"SUBTITLE 'The end had come, and this was it; he dropped her in the Flaming Pit.'"

<SETG LCELL 1> ;"cell in slot"

<SETG PNUMB 1> ;"cell pointed at"

<SETG ACELL <>> ;"cell player is in"

<SETG DCELL <>> ;"cell d.m. is in"

<GDECL (LCELL PNUMB ACELL DCELL) <OR FIX FALSE>>

<DEFINE MOVIES (R "AUX" (CO ,COBJS))
	#DECL ((R) ROOM (CO VALUE) <LIST [REST OBJECT]>)
	<MAPF ,LIST
	      <FUNCTION (O)
		#DECL ((O) OBJECT)
		<COND (<NOT <MEMQ .O .CO>> <MAPRET .O>)
		      (ELSE <MAPRET>)>>
	      <ROBJS .R>>>

<DEFINE STUFF (R L1 L2)
	#DECL ((L1 L2) LIST (R) ROOM)
	<COND (<EMPTY? .L1> <SET L1 .L2>)
	      (<EMPTY? .L2>)
	      (ELSE
	       <SET L1 <LIST !.L1 !.L2>> ;"on purpose, no sharing wanted -- pdl")>
	<MAPF <>
	      <FUNCTION (O) #DECL ((O) OBJECT) <PUT .O ,OROOM .R>>
	      .L1>
	<PUT .R ,ROBJS .L1>>

<DEFINE CELL-MOVE ("AUX" (NEW ,PNUMB) (OLD ,LCELL) (CELL <SFIND-ROOM "CELL">)
			 (NCELL <SFIND-ROOM "NCELL">) (PCELL <SFIND-ROOM "PCELL">)
			 (D <SFIND-OBJ "ODOOR">) (CELLS ,CELLS) PO (ME ,PLAYER))
	#DECL ((NEW OLD) FIX (CELL) ROOM (CELLS) <UVECTOR [REST LIST]>
	       (D) OBJECT (NCELL PCELL) ROOM (PO) LIST (ME DM) ADV)
	<DCLOSE <SFIND-OBJ "CDOOR">>
	<DCLOSE .D>
	<COND (<N==? .NEW .OLD>
	       <PUT .CELLS .OLD <SET PO <MOVIES .CELL>>>
	       <STUFF .CELL <NTH .CELLS .NEW> ,COBJS>
	       <PUT .CELLS .NEW ()>
	       <COND (<==? .OLD 4> <STUFF .NCELL .PO ,NOBJS>)
		     (ELSE <STUFF .PCELL .PO ,POBJS>)>
	       <COND (<==? .NEW 4> <TRO .D ,OVISON>)
		     (ELSE <TRZ .D ,OVISON>)>
	       <COND (<==? <AROOM .ME> .CELL>
		      <SETG ACELL .OLD>
		      <GOTO <COND (<==? .OLD 4> <TRO .D ,OVISON> .NCELL)
				  (ELSE .PCELL)>
			    .ME>)>
	       <COND (<==? ,DCELL .NEW>
		      <SETG DCELL <>>)>
	       <SETG LCELL .NEW>)>>

<DEFINE PARAPET () 
	<COND (<VERB? "LOOK">
	       <TELL ,PARAPET-DESC
		     ,LONG-TELL1
		     <NTH ,NUMS ,PNUMB>
		     "'.">)>>

<DEFINE DIAL ("AUX" N)
	#DECL ((N) <OR FALSE <VECTOR [REST OBJECT FIX]>>)
	<COND (<VERB? "SET" "PUT" "MOVE" "TRNTO">
	       <COND (<NOT <EMPTY? <PRSI>>>
		      <COND (<SET N <MEMQ <PRSI> ,NUMOBJS>>
			     <SETG PNUMB <2 .N>>
			     <TELL "The dial now points to '" 1
				   <NTH ,NUMS <2 .N>> "'.">)
			    (<TELL "The dial face only contains numbers.">)>)
		     (<TELL "You must specify what to set the dial to.">)>)
	      (<VERB? "SPIN">
	       <SETG PNUMB <+ 1 <MOD <RANDOM> 8>>>
	       <TELL
"The dial spins and comes to a stop pointing at '" 1 <NTH ,NUMS ,PNUMB> "'.">)>>

<DEFINE DIALBUTTON ("AUX" (CDOOR <TRNN <SFIND-OBJ "CDOOR"> ,OPENBIT>))
	#DECL ((CDOOR) <OR ATOM FALSE>)
	<COND (<VERB? "PUSH">
	       <CELL-MOVE>
	       <TELL
"The button depresses with a slight click, and pops back.">
	       <AND .CDOOR <TELL "The cell door is now closed.">>
	       T)>>

<DEFINE TAKE-FIVE ()
	<COND (<VERB? "TAKE">
	       <PERFORM WAIT <FIND-VERB "WAIT">>)>>

<DEFINE CELL-ROOM ()
    <COND (<VERB? "LOOK">
	   <TELL 

"You are in a featureless prison cell.  You can see "
		1
		<COND (<TRNN <SFIND-OBJ "CDOOR"> ,OPENBIT>
		       "the east-west
corridor outside the open wooden door in front of you.")
		      ("only the flames
and smoke of the pit out the small window in a closed door in front
of you.")>>
	   <COND (<==? ,LCELL 4>
		  <TELL
"Behind you is a bronze door which seems to be "
			1
			<COND (<TRNN <SFIND-OBJ "ODOOR"> ,OPENBIT>
			       "open.")
			      ("closed.")>>)>)>>
		 
<DEFINE PCELL-ROOM ()
    <COND (<VERB? "LOOK">
	   <TELL 
"You are in a featureless prison cell.  Its wooden door is securely
fastened, and you can see only the flames and smoke of the pit out
the small window." ,LONG-TELL1>)>>

<DEFINE NCELL-ROOM ()
    <COND (<VERB? "LOOK">
	   <TELL 
"You are in a featureless prison cell.  Its wooden door is securely
fastened, and you can see only the flames and smoke of the pit out
its small window." ,LONG-TELL1>
	   <TELL
"On the other side of the cell is a bronze door which seems to be
" 1 <DPR <SFIND-OBJ "ODOOR">>>)>>

<DEFINE NCORR-ROOM ()
	<COND (<VERB? "LOOK">
	       <TELL ,EWC-DESC ,LONG-TELL1
			  <DPR <SFIND-OBJ "CDOOR">>>)>>

<DEFINE SCORR-ROOM ()
	<COND (<VERB? "LOOK">
	       <TELL
"You are in an east-west corridor which turns north at its eastern
and western ends.  The walls of the corridor are marble.  An
additional passage leads south at the center of the corridor." ,LONG-TELL1>
	       <COND (<==? ,LCELL 4>
		      <TELL
"In the center of the north wall of the passage is a bronze door
which is " 1 <DPR <SFIND-OBJ "ODOOR">>>)>)>>

<DEFINE CELL-DOOR ()
	<COND (<VERB? "OPEN" "CLOSE">
	       <OPEN-CLOSE <SFIND-OBJ "CDOOR">
			   "The wooden door opens."
			   "The wooden door closes.">)>>

<DEFINE BRONZE-DOOR ("AUX" (HERE ,HERE)
		     (NCELL? <==? .HERE <SFIND-ROOM "NCELL">>))
	#DECL ((NCELL?) <OR ATOM FALSE> (HERE) ROOM)
	<COND (<VERB? "OPEN" "CLOSE">
	       <COND (<OR .NCELL?
			  <AND <==? ,LCELL 4>
			       <OR <==? .HERE <SFIND-ROOM "CELL">>
				   <==? .HERE <SFIND-ROOM "SCORR">>>>>
	       	      <OPEN-CLOSE <SFIND-OBJ "ODOOR">
			   "The bronze door opens."
			   "The bronze door closes.">
		      <COND (<AND .NCELL? <VERB? "OPEN">>
			     <TELL
"On the other side of the door is a narrow passage which opens out
into a larger area.">)
			    (T)>)
		     (<TELL
"I see no bronze door here.">)>)>>

<DEFINE MAYBE-DOOR ()
	<COND (<NOT <TRNN <SFIND-OBJ "ODOOR"> ,OPENBIT>>
	       <COND (<==? ,LCELL 4>
		      <TELL "The bronze door is closed.">)
		     (<TELL "You can't go that way.">)>)>>
				 
<DEFINE LOCKED-DOOR ()
	<COND (<VERB? "OPEN">
	       <TELL "The door is securely fastened.">)>>

\ 

"=========== The Ultimate Winnage =========="

<DEFINE NIRVANA ()
	<COND (<VERB? "GO-IN">
	       <DCLOSE <SFIND-OBJ "ODOOR">>
	       <TELL ,WIN-TOTALLY>
	       <FINISH (". Won Totally!")>)>>

\ 

"=========== Doing it the Lazy Way ========="

<DEFINE INCANT ("AUX" M)
    #DECL ((M) <VECTOR [REST STRING STRING FIX]>)
    <COND (<SET M <MEMBER "" ,LEXV>>
	   <INCANTATION <REST .M 3>>)>>

<SETG SPELL!-FLAG <>>

<GDECL (XUNM) STRING (WINNERS) <VECTOR [REST STRING]>>

<DEFINE INCANTATION (LV "AUX" W1 W2 (UNM ,XUNM))  
	#DECL ((LV) <VECTOR [REST STRING STRING FIX]> (UNM W1 W2) STRING)
	<COND (<OR ,SPELL!-FLAG <RTRNN <SFIND-ROOM "MRANT"> ,RSEENBIT>>
	       <TELL
"Incantations are useless once you have gotten this far.">)
	      (<OR <LENGTH? .LV 4> <EMPTY? <SET W1 <1 .LV>>>>
	       <TELL "That incantation seems to have been a failure.">)
	      (<EMPTY? <SET W2 <4 .LV>>>
	       <COND (<AND ,SPELL!-FLAG <N=? .W1 ,SPELL!-FLAG>>
		      <TELL "Sorry, only one incantation to a customer.">)
		     (<OR <AND ,INCANT-OK ,END-GAME!-FLAG> <MEMBER .UNM ,WINNERS>>
		      <SET W2 <PW .UNM .W1>>
		      <TELL "A hollow voice replies: \"" 0 .W1 " ">
		      <TELL .W2 1 "\".">
		      <SETG SPELL!-FLAG <STRING .W1>>)
		     (<TELL "That spell has no obvious effect.">)>)
	      (<OR <=? .W1 <PW .UNM .W2>>
		   <=? .W2 <PW .UNM .W1>>>
	       <TELL
"As the last syllable of your spell fades into silence, darkness
envelops you, and the earth shakes briefly.  Then all is quiet.">
	       <SETG SPELL!-FLAG <STRING .W1>>
	       <ENTER-END-GAME>)
	      (<TELL "That spell doesn't appear to have done anything useful.">)>>

<SETG SWU <IUVECTOR 5 0>>

<SETG KWU <IUVECTOR 5 0>>

<SETG STR <ISTRING 5>>

<DEFINE PW (UNM KEY "AUX" (SU ,SWU) (KU ,KWU) (STR ,STR) USUM) 
	#DECL ((UNM KEY STR VALUE) STRING (SU KU) <UVECTOR [REST FIX]> (USUM) FIX)
	<REPEAT ((S .UNM) (SU .SU) (K .KEY) (KU .KU)) 
		#DECL ((S K) STRING (SU KU) <UVECTOR [REST FIX]>)
		<COND (<EMPTY? .SU> <RETURN T>)>
		<AND <EMPTY? .K> <SET K .KEY>>
		<AND <EMPTY? .S> <SET S .UNM>>
		<PUT .SU 1 <- <ASCII <1 .S>> 64>>
		<PUT .KU 1 <- <ASCII <1 .K>> 64>>
		<SET K <REST .K>>
		<SET S <REST .S>>
		<SET SU <REST .SU>>
		<SET KU <REST .KU>>>
	<SET USUM <+ <MOD <+ !.SU> 8> <* 8 <MOD <+ !.KU> 8>>>>
	<MAPR <>
	      <FUNCTION (S) #DECL ((S) STRING) <PUT .S 1 <ASCII 0>>>
	      .STR>
	<MAPR <>
	      <FUNCTION (SU KU STR "AUX" (S <1 .SU>) (K <1 .KU>)) 
		      #DECL ((SU KU) UVECTOR (STR) STRING (S K) FIX)
		      <SET S <CHTYPE <ANDB <XORB <XORB .S .K> .USUM> 31> FIX>>
		      <SET USUM <MOD <+ .USUM 1> 32>>
		      <COND (<G? .S 26> <SET S <MOD .S 26>>)>
		      <AND <0? .S> <SET S 1>>
		      <PUT .STR 1 <ASCII <+ .S 64>>>>
	      .SU
	      .KU
	      .STR>
	.STR>

\

<DEFINE TURNTO ()
    <COND (<OBJECT-ACTION>)
	  (<TELL "That cannot be turned.">)>>

"=========== CEVENTs and such ============="

<OR <LOOKUP "COMPILE" <ROOT>>
    <LOOKUP "GROUP-GLUE" <GET INITIAL OBLIST>>
    <PROG ()
	  <CEVENT 0 MRSWITCH <> "MRINT">
	  <CEVENT 0 START-END T "STRTE">
	  <CEVENT 0 MENDS <> "PININ">
	  <CEVENT 0 INQUISITOR <> "INQIN">
	  <CEVENT 0 FOLLOW <> "FOLIN">>>

<GDECL (MRINT STRTE PININ INQIN FOLIN) CEVENT>
