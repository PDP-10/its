
"(c) Copyright 1978, Massachusetts Institute of Technology.  All rights reserved."

<AND <L? ,MUDDLE 100>
     <NOT <OR <LOOKUP "COMPILE" <ROOT>>
	      <LOOKUP "GROUP-GLUE" <GET INITIAL OBLIST>>>>
     <USE "LSRTNS">>

;"newtypes for oblist hack"
<NEWTYPE PSTRING WORD>
<NEWTYPE POBLIST UVECTOR '<<PRIMTYPE UVECTOR> [REST LIST]>>

;"applicables"

<NEWTYPE NOFFSET WORD>

<PUT RAPPLIC DECL '<OR ATOM FALSE NOFFSET>>

;"newtypes for parser"

<NEWTYPE BUZZ WORD>

<NEWTYPE DIRECTION WORD>

<NEWTYPE ADJECTIVE WORD>

<NEWTYPE PREP WORD>

\ 

;"generalized oflags tester"

<DEFMAC TRNN ('OBJ 'BIT)
  <FORM N==? <FORM CHTYPE <FORM ANDB .BIT <FORM OFLAGS .OBJ>> FIX> 0>>
<DEFMAC RTRNN ('RM 'BIT)
  <FORM N==? <FORM CHTYPE <FORM ANDB .BIT <FORM RBITS .RM>> FIX> 0>>
<DEFMAC GTRNN ('RM 'BIT)
  <FORM N==? <FORM CHTYPE <FORM ANDB .BIT <FORM RGLOBAL .RM>> FIX> 0>>
<DEFMAC RTRZ ('RM BIT)
  <FORM PUT .RM ,RBITS <FORM CHTYPE <FORM ANDB <FORM RBITS .RM> <XORB .BIT -1>> FIX>>>
<DEFMAC TRC ('OBJ 'BIT)
  <FORM PUT .OBJ ,OFLAGS <FORM CHTYPE <FORM XORB <FORM OFLAGS .OBJ> .BIT> FIX>>>
<DEFMAC TRZ ('OBJ BIT)
  <FORM PUT .OBJ ,OFLAGS <FORM CHTYPE <FORM ANDB <FORM OFLAGS .OBJ> <XORB .BIT -1>> FIX>>>
<DEFMAC TRO ('OBJ 'BIT)
  <FORM PUT .OBJ ,OFLAGS <FORM CHTYPE <FORM ORB <FORM OFLAGS .OBJ> .BIT> FIX>>>
<DEFMAC RTRO ('RM 'BIT)
  <FORM PUT .RM ,RBITS <FORM CHTYPE <FORM ORB <FORM RBITS .RM> .BIT> FIX>>>
<DEFMAC RTRC ('RM 'BIT)
  <FORM PUT .RM ,RBITS <FORM CHTYPE <FORM XORB <FORM RBITS .RM> .BIT> FIX>>>
<DEFMAC ATRNN ('ADV 'BIT)
  <FORM N==? <FORM CHTYPE <FORM ANDB .BIT <FORM AFLAGS .ADV>> FIX> 0>>
<DEFMAC ATRZ ('ADV BIT)
  <FORM PUT .ADV ,AFLAGS <FORM CHTYPE <FORM ANDB <FORM AFLAGS .ADV> <XORB .BIT -1>>
				      FIX>>>
<DEFMAC ATRO ('ADV 'BIT)
  <FORM PUT .ADV ,AFLAGS <FORM CHTYPE <FORM ORB <FORM AFLAGS .ADV> .BIT> FIX>>>

\ 

;"room definition"

<NEWSTRUC ROOM
	  VECTOR
	  RID
	  PSTRING						      ;"room id"
	  RDESC1
	  STRING					     ;"long description"
	  RDESC2
	  STRING					    ;"short description"
	  REXITS
	  EXIT						        ;"list of exits"
	  ROBJS
	  <LIST [REST OBJECT]>				      ;"objects in room"
	  RACTION
	  RAPPLIC						  ;"room-action"
	  RBITS
	  FIX							 ;"random flags"
	  RPROPS
	  <LIST [REST ATOM ANY]>>

;"Slots for room"

<MAKE-SLOT RVAL FIX 0>

;"value for entering"

<MAKE-SLOT RGLOBAL FIX ,STAR-BITS>

;"globals for room"

<FLAGWORD RSEENBIT						     ;"visited?"
	  RLIGHTBIT				     ;"endogenous light source?"
	  RLANDBIT						      ;"on land"
	  RWATERBIT						   ;"water room"
	  RAIRBIT						 ;"mid-air room"
	  RSACREDBIT					    ;"thief not allowed"
	  RFILLBIT					 ;"can fill bottle here"
	  RMUNGBIT					 ;"room has been munged"
	  RBUCKBIT				        ;"this room is a bucket"
	  RHOUSEBIT			       ;"This room is part of the house"
	  RENDGAME			        ;"This room is in the end game"
	  RNWALLBIT				;"This room doesn't have walls">

;"exit"

<NEWTYPE EXIT
	 VECTOR
	 '<<PRIMTYPE VECTOR> [REST DIRECTION <OR ROOM CEXIT DOOR NEXIT>]>>

;"conditional exit"

<NEWSTRUC CEXIT
	  VECTOR
	  CXFLAG
	  ATOM						       ;"condition flag"
	  CXROOM
	  ROOM						     ;"room it protects"
	  CXSTR
	  <OR FALSE STRING>					  ;"description"
	  CXACTION
	  RAPPLIC					       ;"exit function">

<NEWSTRUC DOOR
	  VECTOR
	  DOBJ
	  OBJECT						     ;"the door"
	  DROOM1
	  ROOM						     ;"one of the rooms"
	  DROOM2
	  ROOM						        ;"the other one"
	  DSTR
	  <OR FALSE STRING>			      ;"what to print if closed"
	  DACTION
	  RAPPLIC				      ;"what to call to decide">

<NEWTYPE NEXIT STRING>

;"unusable exit description"

\ 

;"PARSER related types"

<NEWSTRUC ACTION VECTOR VNAME PSTRING	     ;"atom associated with this action"
	  VDECL VSPEC			  ;"syntaxes for this verb (any number)"
	  VSTR STRING	        ;"string to print when talking about this verb">

;"VSPEC -- uvector of syntaxes for a verb"

<NEWTYPE VSPEC UVECTOR '<<PRIMTYPE UVECTOR> [REST SYNTAX]>>

;"SYNTAX -- a legal syntax for a sentence involving this verb"

<NEWSTRUC SYNTAX VECTOR SYN1 VARG		  ;"direct object, more or less"
	  SYN2 VARG			        ;"indirect object, more or less"
	  SFCN VERB			       ;"function to handle this action"
	  SFLAGS FIX				     ;"flag bits for this verb">

;"SFLAGS of a SYNTAX"

<FLAGWORD SFLIP				 ;"T -- flip args (for verbs like PICK)"
	  SDRIVER	      ;"T -- default syntax for gwimming and orphanery">

;"STRNN -- test a bit in the SFLAGS slot of a SYNTAX"

<DEFMAC STRNN ('S 'BIT)
	<FORM N==? <FORM CHTYPE <FORM ANDB .BIT <FORM SFLAGS .S>> FIX> 0>>

; "VARG -- types and locations of objects acceptable as args to verbs,
   these go in the SYN1 and SYN2 slots of a SYNTAX."

<NEWSTRUC VARG VECTOR VBIT FIX
			      ;"acceptable object characteristics (default any)"
	  VFWIM FIX					    ;"spec for fwimming"
	  VPREP <OR PREP FALSE>	      ;"preposition that must precede(?) object"
	  VWORD FIX		       ;"locations object may be looked for in">

;"flagbit definitions for VWORD of a VARG"

<FLAGWORD VABIT					       ;"AOBJS -- look in AOBJS"
	  VRBIT					       ;"ROBJS -- look in ROBJS"
	  VTBIT					  ;"1 => try to take the object"
	  VCBIT				       ;"1 => care if can't take object"
	  VFBIT				     ;"1 => care if can't reach object">

;"VTRNN -- test a bit in the VWORD slot of a VARG"

<DEFMAC VTRNN ('V 'BIT) 
	<FORM N==? <FORM CHTYPE <FORM ANDB .BIT <FORM VWORD .V>> FIX> 0>>

"VTBIT & VCBIT interact as follows:
    vtbit
      vcbit

    1 1 = TAKE -- try to take, care if can't ('TURN WITH x')
    1 0 = TRY -- try to take, don't care if can't ('READ x')
    0 1 = MUST -- must already have object ('ATTACK TROLL WITH x') 
    0 0 = NO-TAKE (default) -- don't try, don't care ('TAKE x')
"

;"VERB -- name and function to apply to handle verb"

<NEWSTRUC VERB VECTOR VNAME PSTRING VFCN RAPPLIC>

;"ORPHANS -- mysterious vector of orphan data"

<NEWSTRUC (ORPHANS)
	  VECTOR
	  OFLAG
	  <OR FALSE ATOM>
	  OVERB
	  <OR FALSE VERB>
	  OSLOT1
	  <OR FALSE OBJECT>
	  OPREP
	  <OR FALSE PREP>
	  ONAME
	  <OR FALSE STRING>>

;"prepositional phrases"

<NEWSTRUC PHRASE VECTOR PPREP PREP POBJ OBJECT>

\ 

;"BITS FOR 2ND ARG OF CALL TO TELL (DEFAULT IS 1)"

<MSETG LONG-TELL *400000000000*>

<MSETG PRE-CRLF 2>

<MSETG POST-CRLF 1>

<MSETG NO-CRLF 0>

<MSETG LONG-TELL1 <+ ,LONG-TELL ,POST-CRLF>>

<PSETG NULL-DESC "">

<PSETG NULL-EXIT <CHTYPE [] EXIT>>

<PSETG NULL-SYN ![!]>

;"adventurer"

<NEWSTRUC ADV
	  VECTOR
	  AROOM
	  ROOM							  ;"where he is"
	  AOBJS
	  <LIST [REST OBJECT]>				   ;"what he's carrying"
	  ASCORE
	  FIX							        ;"score"
	  AVEHICLE
	  <OR FALSE OBJECT>				  ;"what he's riding in"
	  AOBJ
	  OBJECT						   ;"what he is"
	  AACTION
	  RAPPLIC			       ;"special action for robot, etc."
	  ASTRENGTH
	  FIX						    ;"fighting strength"
	  AFLAGS
	  FIX			   ;"flags THIS MUST BE SAME OFFSET AS OFLAGS!">

"bits in <AFLAGS adv>:
	  bit-name"

<FLAGWORD ASTAGGERED						  ;"staggered?">

;"object"

<NEWSTRUC OBJECT
	  VECTOR
	  ONAMES
	  <UVECTOR [REST PSTRING]>				     ;"synonyms"
	  OADJS
	  <UVECTOR [REST ADJECTIVE]>			  ;"adjectives for this"
	  ODESC2
	  STRING					    ;"short description"
	  OFLAGS
	  FIX			    ;"flags THIS MUST BE SAME OFFSET AS AFLAGS!"
	  OACTION
	  RAPPLIC					        ;"object-action"
	  OCONTENTS
	  <LIST [REST OBJECT]>				     ;"list of contents"
	  OCAN
	  <OR FALSE OBJECT>				   ;"what contains this"
	  OROOM
	  <OR FALSE ROOM>				     ;"what room its in"
	  OPROPS
	  <LIST [REST ATOM ANY]>			       ;"property list">

;"For funny slots in objects"

<MAKE-SLOT OTVAL FIX 0>

;"value when placed in trophy case"

<MAKE-SLOT OFVAL FIX 0>

;"value when found"

<MAKE-SLOT OSIZE FIX 5>

;"size"

<MAKE-SLOT OCAPAC FIX 0>

;"capacity"

<MAKE-SLOT ODESCO <OR STRING FALSE> <>>

;"first description"

<MAKE-SLOT ODESC1 STRING "">

;"long description"

<MAKE-SLOT OREAD <OR STRING FALSE> <>>

;"reading material"

<MAKE-SLOT OGLOBAL FIX 0>

;"global bit for this object"

<MAKE-SLOT OVTYPE FIX 0>

;"vehicle's type spec"

<MAKE-SLOT OACTOR ADV <>>

;"adventurer for actors"

<MAKE-SLOT OLINT <OR FALSE <VECTOR FIX CEVENT>> <>>

;"light interrupts"

<MAKE-SLOT OMATCH FIX 0>

;"# of matches"

<MAKE-SLOT OFMSGS <OR UVECTOR FALSE> <>>

;"melee messages"

<MAKE-SLOT OBVERB <OR FALSE VERB> <>>

;"bunch verb"

<MAKE-SLOT OSTRENGTH FIX 0>

;"strength for melee"

<DEFINE OID (OBJ) #DECL ((OBJ) OBJECT (VALUE) PSTRING) <1 <ONAMES .OBJ>>>

;"bits in <OFLAGS object>:
	  bit-name  bit-tester"

<FLAGWORD OVISON						     ;"visible?"
	  READBIT						    ;"readable?"
	  TAKEBIT						    ;"takeable?"
	  DOORBIT					       ;"object is door"
	  TRANSBIT				        ;"object is transparent"
	  FOODBIT					       ;"object is food"
	  NDESCBIT				       ;"object not describable"
	  DRINKBIT					  ;"object is drinkable"
	  CONTBIT				  ;"object can be opened/closed"
	  LIGHTBIT				     ;"object can provide light"
	  VICBIT					     ;"object is victim"
	  BURNBIT					  ;"object is flammable"
	  FLAMEBIT					    ;"object is on fire"
	  TOOLBIT					     ;"object is a tool"
	  TURNBIT					 ;"object can be turned"
	  VEHBIT					  ;"object is a vehicle"
	  FINDMEBIT			        ;"can be reached from a vehicle"
	  SLEEPBIT					     ;"object is asleep"
	  SEARCHBIT			   ;"allow multi-level access into this"
	  SACREDBIT				        ;"thief can't take this"
	  TIEBIT					   ;"object can be tied"
	  CLIMBBIT			 ;"can be climbed (former ECHO-ROOM-BIT)"
	  ACTORBIT					   ;"object is an actor"
	  WEAPONBIT					   ;"object is a weapon"
	  FIGHTBIT					   ;"object is in melee"
	  VILLAIN					  ;"object is a bad guy"
	  STAGGERED				 ;"object can't fight this turn"
	  TRYTAKEBIT		       ;"object wants to handle not being taken"
	  NO-CHECK-BIT		 ;"no checks (put & drop):  for EVERY and VALUA"
	  OPENBIT					       ;"object is open"
	  TOUCHBIT				       ;"has this been touched?"
	  ONBIT							   ;"light on?"
	  DIGBIT					      ;"I can dig this"
	  BUNCHBIT					    ;"*BUN*, all, etc.">

"extra stuff for flagword for objects"

"can i be opened?"

<DEFMAC OPENABLE? ('OBJ) <FORM TRNN .OBJ <FORM + ,DOORBIT ,CONTBIT>>>

"complement of the bit state"

<DEFMAC DESCRIBABLE? ('OBJ) <FORM NOT <FORM TRNN .OBJ ,NDESCBIT>>>

"if object is a light or aflame, then flaming"

<DEFMAC FLAMING? ('OBJ "AUX" (CONST <+ ,FLAMEBIT ,LIGHTBIT ,ONBIT>))
    <FORM ==? <FORM CHTYPE <FORM ANDB <FORM OFLAGS .OBJ> .CONST> FIX> .CONST>>

"if object visible and open or transparent, can see inside it"

<DEFMAC SEE-INSIDE? ('OBJ)
    <FORM AND <FORM TRNN .OBJ ,OVISON>
	  <FORM OR <FORM TRNN .OBJ ,TRANSBIT> <FORM TRNN .OBJ ,OPENBIT>>>>

<DEFMAC GLOBAL? ('OBJ)
  <FORM NOT <FORM 0? <FORM CHTYPE <FORM ANDB ',STAR-BITS <FORM OGLOBAL .OBJ>> FIX>>>>

\ 

;"demons"

<NEWSTRUC HACK
	  VECTOR
	  HACTION
	  RAPPLIC
	  HOBJS
	  <LIST [REST ANY]>
	  "REST"
	  HROOMS
	  <LIST [REST ROOM]>
	  HROOM
	  ROOM
	  HOBJ
	  OBJECT
	  HFLAG
	  ANY>

;"Clock interrupts"

<NEWSTRUC CEVENT
	  VECTOR
	  CTICK
	  FIX
	  CACTION
	  <OR ATOM NOFFSET>
	  CFLAG
	  <OR ATOM FALSE>
	  CID
	  ATOM
	  CDEATH
	  <OR ATOM FALSE>>

;"Questions for end game"

<NEWSTRUC QUESTION VECTOR QSTR STRING			      ;"question to ask"
	  QANS VECTOR			        ;"answers (as returned by LEX)">

\ 

<SETG LOAD-MAX 100>

<SETG SCORE-MAX 0>

<SETG EG-SCORE-MAX 0>

<SETG EG-SCORE 0>

"SET WHEN IN LONG TELL"

<SETG IN-TELL 0>

"SET BY CTRL-S HANDLER TO CAUSE TELL TO FLUSH"

<SETG NO-TELL 0>

<GDECL (RAW-SCORE LOAD-MAX SCORE-MAX EG-SCORE-MAX EG-SCORE IN-TELL NO-TELL)
       FIX
       (RANDOM-LIST ROOMS SACRED-PLACES)
       <LIST [REST ROOM]>
       (STARS OBJECTS WEAPONS NASTIES)
       <LIST [REST OBJECT]>
       (PRSVEC)
       <VECTOR VERB <OR FALSE OBJECT DIRECTION> <OR FALSE OBJECT>>
       (WINNER PLAYER)
       ADV
       (HERE)
       ROOM
       (INCHAN OUTCHAN)
       CHANNEL
       (DEMONS)
       LIST
       (MOVES DEATHS)
       FIX
       (DUMMY YUKS)
       <VECTOR [REST STRING]>
       (SWORD-DEMON)
       HACK
       (CPOBJS) UVECTOR
       (CPHERE) FIX>

\ 
; "SUBTITLE POBLIST HACKS"
<SETG PPSTRING <ISTRING 5>>

<DEFINE PLOOKUP (NAME OBL "AUX" BUCK TL)
	#DECL ((NAME) <OR STRING <PRIMTYPE WORD>> (OBL) POBLIST (BUCK) FIX)
	<COND (<TYPE? .NAME STRING>
	       <SET NAME <PSTRING .NAME>>)
	      (<NOT <TYPE? .NAME PSTRING>>
	       <SET NAME <CHTYPE .NAME PSTRING>>)>
	<COND (<SET TL <MEMQ .NAME <NTH .OBL <HASH .NAME .OBL>>>>
	       <2 .TL>)>>

<DEFINE HASH (NAME OBL)
  #DECL ((NAME) <PRIMTYPE WORD> (OBL) POBLIST)
  <+ 1 <MOD <CHTYPE .NAME FIX> <LENGTH .OBL>>>>
\

"UTILITY MACROS"

"TO CHECK VERBS"

<DEFMAC VERB? ("ARGS" AL)
	<COND (<1? <LENGTH .AL>>
	       <FORM ==? <FORM VNAME '<PRSA>> <PSTRING <1 .AL>>>)
	      (ELSE
	       <FORM PROG ((VA <FORM VNAME '<PRSA>>))
		     #DECL ((VA) PSTRING)
		     <FORM OR
			   !<MAPF ,LIST
				  <FUNCTION (A)
				      <FORM ==? <FORM LVAL VA> <PSTRING .A>>>
				  .AL>>>)>>

<DEFMAC GET-DOOR-ROOM ('RM 'LEAVINGS)
	<FORM PROG <LIST <LIST EL <FORM DROOM1 .LEAVINGS>>>
	      #DECL ((EL) ROOM)
	      <FORM COND
		    (<FORM ==? .RM <FORM LVAL EL>>
			  <FORM DROOM2 .LEAVINGS>)
		    (<FORM LVAL EL>)>>>

"APPLY AN OBJECT FUNCTION"

<DEFMAC APPLY-OBJECT ('OBJ)
    <FORM PROG ((FOO <FORM OACTION .OBJ>))
	  #DECL ((FOO) RAPPLIC)
 	  <FORM COND (<FORM NOT <FORM LVAL FOO>> <>)
		(<FORM TYPE? <FORM LVAL FOO> ATOM>
		 <FORM APPLY <FORM GVAL <FORM LVAL FOO>>>)
		(<FORM DISPATCH <FORM LVAL FOO>>)>>>

<DEFMAC CLOCK-DISABLE ('EV)
    <FORM PUT .EV ,CFLAG <>>>

<DEFMAC CLOCK-ENABLE ('EV)
    <FORM PUT .EV ,CFLAG T>>

<DEFMAC APPLY-RANDOM ('FROB "OPTIONAL" ('MUMBLE <>))
	<COND (<TYPE? .FROB ATOM>
	       <COND (.MUMBLE
		      <FORM APPLY <FORM GVAL .FROB> .MUMBLE>)
		     (<FORM APPLY <FORM GVAL .FROB>>)>)
	      (T
	       <FORM COND
		     (<FORM TYPE? .FROB ATOM>
		      <COND (.MUMBLE
			     <FORM APPLY <FORM GVAL .FROB> .MUMBLE>)
			    (<FORM APPLY <FORM GVAL .FROB>>)>)
		     (T <FORM DISPATCH .FROB .MUMBLE>)>)>>

<DEFINE OGET (O P "AUX" V)
	#DECL ((O) <OR OBJECT ROOM> (P) ATOM (V) <LIST [REST ATOM ANY]>)
	<COND (<TYPE? .O OBJECT> <SET V <OPROPS .O>>)
	      (ELSE <SET V <RPROPS .O>>)>
	<REPEAT ()
		<COND (<EMPTY? .V> <RETURN <>>)
		      (<==? <1 .V> .P> <RETURN <2 .V>>)
		      (ELSE <SET V <REST .V 2>>)>>>

<DEFINE OPUT (O P X "OPTIONAL" (ADD? <>) "AUX" V)
	#DECL ((O) <OR OBJECT ROOM> (P) ATOM (V) <LIST [REST ATOM ANY]> (X) ANY
	       (ADD?) <OR ATOM FALSE>)
	<COND (<TYPE? .O OBJECT> <SET V <OPROPS .O>>)
	      (ELSE <SET V <RPROPS .O>>)>
	<REPEAT ((VV .V))
		<COND (<EMPTY? .VV>
		       <COND (.ADD?
			      <COND (<TYPE? .O OBJECT>
				     <PUT .O ,OPROPS (.P .X !.V)>)
				    (<PUT .O ,RPROPS (.P .X !.V)>)>)>
		       <RETURN .O>)
		      (<==? <1 .VV> .P> <PUT .VV 2 .X> <RETURN .O>)
		      (ELSE <SET VV <REST .VV 2>>)>>>

<DEFINE FIND-VERB (STR "AUX" (WORDS ,WORDS-POBL))
    #DECL ((STR) STRING (WORDS) POBLIST)
    <COND (<PLOOKUP .STR .WORDS>)
	  (<PINSERT .STR .WORDS <CHTYPE [<PSTRING .STR> T] VERB>>)>>

<DEFINE FIND-DIR (STR)
    #DECL ((STR) STRING (VALUE) DIRECTION)
    <COND (<PLOOKUP .STR ,DIRECTIONS-POBL>)
	  (<ERROR NOT-FOUND!-ERRORS FIND-DIR .STR>)>>

<DEFINE FIND-ACTION (STR)
    #DECL ((STR) STRING (VALUE) ACTION)
    <COND (<PLOOKUP .STR ,ACTIONS-POBL>)
	  (<ERROR NOT-FOUND!-ERRORS FIND-ACTION .STR>)>>

<DEFINE FIND-ROOM (STR)
    #DECL ((STR) <OR STRING <PRIMTYPE WORD>> (VALUE) ROOM)
    <COND (<PLOOKUP .STR ,ROOM-POBL>)
	  (<ERROR NOT-FOUND!-ERRORS FIND-ROOM .STR>)>>

<DEFMAC SFIND-ROOM ('STR)
  <COND (<TYPE? .STR STRING>
	 <FORM FIND-ROOM <PSTRING .STR>>)
	(<FORM FIND-ROOM .STR>)>>

<DEFMAC SFIND-OBJ ('STR)
  <COND (<TYPE? .STR STRING>
	 <FORM FIND-OBJ <PSTRING .STR>>)
	(<FORM FIND-OBJ .STR>)>>

<DEFINE FIND-OBJ (STR)
    #DECL ((STR) <OR STRING <PRIMTYPE WORD>> (VALUE) OBJECT)
    <COND (<PLOOKUP .STR ,OBJECT-POBL>)
	  (<ERROR NOT-FOUND!-ERRORS FIND-OBJ .STR>)>>

<DEFINE FIND-DOOR (RM OBJ)
	#DECL ((RM) ROOM (OBJ) OBJECT)
	<REPEAT ((L <REXITS .RM>) TD)
	  #DECL ((L) <<PRIMTYPE VECTOR> [REST DIRECTION <OR DOOR ROOM CEXIT NEXIT>]>)
	  <COND (<EMPTY? .L>
		 <RETURN <>>)
		(<AND <TYPE? <SET TD <2 .L>> DOOR>
		      <==? <DOBJ .TD> .OBJ>>
		 <RETURN .TD>)>
	  <SET L <REST .L 2>>>>

<SETG ROOMS ()>

<SETG OBJECTS ()>

<SETG ACTORS ()>

<SETG BIGFIX </ <CHTYPE <MIN> FIX> 2>>
