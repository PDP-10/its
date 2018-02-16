
"(c) Copyright 1978, Massachusetts Institute of Technology.  All rights reserved."

<OR <LOOKUP "COMPILE" <ROOT>>
    <PROG ()
	  <DEFINE PRSA () <1 ,PRSVEC>>
	  <DEFINE PRSO () <2 ,PRSVEC>>
	  <DEFINE PRSI () <3 ,PRSVEC>>>>

"Create the structure in which prepositional phrases are stored at parse
time.  Don't bother when COMPILEing or GLUEing."

<GDECL (PRSVEC)
       <VECTOR <OR ACTION VERB> <OR FALSE OBJECT DIRECTION> <OR FALSE OBJECT>>
       (LAST-IT)
       OBJECT
       (PREPVEC)
       <UVECTOR [REST PHRASE]>>

"Randomness"

<SETG NEFALS #FALSE (1)>

;"funny falses for SEARCH-LIST and FWIM"

<SETG NEFALS2 #FALSE (2)>

;"VERBs which take BUNCHes"

<OR <GASSIGNED? BUNCHERS> <SETG BUNCHERS ()>>

<GDECL (BUNUVEC BUNCH) <UVECTOR [REST OBJECT]> (BUNCHERS) <LIST [REST VERB]>>

\ 

"EPARSE -- top level entry to parser.  calls SPARSE to set up the
parse-vector, then, calls SYN-MATCH to see if the sentence matches any
syntax of the verb given.  If a syntax matches, the orphan vector is
cleared out.  If no syntax matches, the appropriate message is printed
in SYN-MATCH (or below).  Only the T/Fness of the value is interesting."

<SETG UNKNOWN <>>

<GDECL (UNKNOWN) <OR FALSE <VECTOR [REST STRING STRING FIX]>>>

<DEFINE SWAP-EM ("AUX" (PV ,LEXV) (INBUF ,INBUF)) 
	#DECL ((INBUF) STRING (PV) <VECTOR [REST STRING STRING FIX]>)
	<SETG LEXV ,LEXV1>
	<SETG LEXV1 .PV>
	<SETG INBUF ,INBUF1>
	<SETG INBUF1 .INBUF>>

<DEFINE EPARSE (PV VB
		"AUX" VAL OBJ VERB ACT (BOBJ ,BUNCH-OBJ) STR LEN (UNK ,UNKNOWN)
		      (LV ,LEXV))
   #DECL ((VAL) <OR FALSE ATOM VECTOR> (PV LV) <VECTOR [REST
							STRING
							STRING
							FIX]> (VERB) VERB
	  (ACT) <OR VERB ACTION> (VB) <OR ATOM FALSE> (STR) STRING
	  (OBJ) <OR OBJECT DIRECTION FALSE> (BOBJ) OBJECT (LEN) FIX
	  (UNK) <OR FALSE <VECTOR [REST STRING STRING FIX]>>)
   <TRZ .BOBJ <+ ,CLIMBBIT ,TIEBIT ,STAGGERED>>
   <COND (<=? <SET STR <1 .PV>> "AGAIN"> <SWAP-EM> <SET PV ,LEXV>)
	 (<AND <OR <=? .STR "OOPS"> <=? .STR "O">> .UNK>
	  <PUT .UNK
	       1
	       <SUBSTRUC <SET STR <4 .LV>>
			 0
			 <SET LEN <LENGTH .STR>>
			 <BACK <REST <SET STR <1 .UNK>> <LENGTH .STR>> .LEN>>>
	  <PUT .UNK 2 <5 .LV>>
	  <PUT .UNK 3 <6 .LV>>
	  <SWAP-EM>
	  <SET PV ,UNKNOWN-LEXV>)>
   <SETG UNKNOWN <>>
   <SETG PARSE-CONT <>>
   <COND
    (<EMPTY? <1 .PV>> <OR .VB <TELL "Beg pardon?">> <>)
    (<SET VAL <SPARSE .PV .VB>>
     <COND
      (.VB
       <AND <TYPE? <SET ACT <1 .VAL>> ACTION>
	    <PUT .VAL 1 <SFCN <1 <VDECL .ACT>>>>>
       <ORPHAN <>>)
      (<==? .VAL WIN> <ORPHAN <>>)
      (<SYN-MATCH .VAL>
       <ORPHAN <>>
       <COND (<TYPE? <SET OBJ <2 .VAL>> OBJECT>
	      <COND (<==? .OBJ .BOBJ> <SETG LAST-IT <1 ,BUNCH>>)
		    (<SETG LAST-IT <2 .VAL>>)>)>
       <COND (<AND .OBJ <TRNN .OBJ ,BUNCHBIT>>
	      <COND (<MEMQ <1 .VAL> ,BUNCHERS>
		     <COND (<==? .OBJ .BOBJ>
			    <OBVERB .OBJ <1 .VAL>>
			    <PUT .VAL 1 ,BUNCHER>)
			   (T)>)
		    (<OR .VB
			 <TELL "Multiple inputs cannot be used with '"
			       1
			       <STRINGP <VNAME <SET VERB <1 .VAL>>>>
			       "'.">>
		     <>)>)
	     (T)>)>)>>

"SPARSE -- set up parse vector.  This is done in two steps.
	In the first, each word of the input is looked up in the various
interesting oblists. If a DIRECTION is seen before an ACTION, the parse
wins.  Also, if any word is not found, the parse fails.  As various parts
of speech are found, variables are set up saying so
	In the second, the vector and variables resulting are checked.  Any
missing are (attempted to be) set up from the orphans of the last parse.
If they can't be new orphans are generated.
	There are three possible results of all this:  WIN, which means the
parse is done and no syntax checking is needed; the Parse-Vector, meaning
the parse needs to have syntax checking done; and a FALSE, meaning the parse
has failed."

<DEFINE SPARSE SPAROUT (SV VB
			"AUX" (WORDS ,WORDS-POBL) (OBJOB ,OBJECT-POBL)
			      (PV ,PRSVEC) (EXCEPT <SFIND-OBJ "EXCEP">)
			      (PVR <PUT <PUT <REST .PV> 1 <>> 2 <>>)
			      (ACTIONS ,ACTIONS-POBL) (DIRS ,DIRECTIONS-POBL) FX
			      ROBJ (ORPH ,ORPHANS) (ORFL <OFLAG .ORPH>)
			      (ANDFLG <>) (HERE ,HERE) (ACTION <>) (PREP <>)
			      (ADJ <>) (BOBJS ,BUNUVEC) (BUNCHFLG <>) NPREP
			      PPREP OBJ POBJ LOBJ NOBJ VAL AVAL (ANDLOC <>)
			      (PREPVEC ,PREPVEC) OS)
   #DECL ((SV) <VECTOR [REST STRING STRING FIX]>
	  (VB ORFL BUNCHFLG CONTIN) <OR ATOM FALSE>
	  (ACTIONS WORDS OBJOB DIRS) POBLIST (PV ORPH PVR) VECTOR (FX) FIX
	  (ROBJ EXCEPT) OBJECT (VAL ANDFLG) <OR ATOM FALSE> (HERE) ROOM
	  (ACTION) <OR FALSE ACTION> (NPREP PREP) <OR FALSE PREP>
	  (ADJ) <OR FALSE ADJECTIVE> (AVAL POBJ) ANY
	  (PREPVEC) <UVECTOR [REST PHRASE]> (LOBJ NOBJ OBJ) <OR FALSE OBJECT>
	  (PPREP) PHRASE (SPAROUT) ACTIVATION (BOBJS) <UVECTOR [REST OBJECT]>
	  (ANDLOC) <OR FALSE VECTOR>
	  (OS) <OR FALSE <VECTOR <UVECTOR [REST PHRASE]> VECTOR>>)
   <PUT .PV 1 <>>
   <SET VAL
    <REPEAT PACT ((VV .SV) X Y)
      #DECL ((PACT) ACTIVATION (VV) <VECTOR [REST STRING STRING FIX]>
	     (X) PSTRING (Y) STRING)
      <SET Y <1 .VV>>
      <COND (<EMPTY? .Y> <RETURN T>)
	    (<=? .Y "THEN">
	     <COND (<EMPTY? <SET VV <REST .VV 3>>> <RETURN T>)>
	     <SETG PARSE-CONT .VV>
	     <RETURN T>)
	    (<=? .Y "AND">
	     <COND (<EMPTY? <SET VV <REST .VV 3>>> <RETURN T>)>
	     <SET ANDFLG T>
	     <AGAIN>)>
      <SET X <PSTRING .Y>>
      <COND
       (<AND <NOT .ACTION> <SET AVAL <PLOOKUP .X .ACTIONS>>>
	<PUT .ORPH ,OVERB <>>
	<SET ACTION .AVAL>)
       (<AND <OR <NOT .ACTION>
		 <AND <==? .ACTION <PLOOKUP "WALK" .ACTIONS>> <NOT .PREP>>>
	     <SET AVAL <PLOOKUP .X .DIRS>>
	     <NOT <AND .ORFL <ONAME .ORPH> <PLOOKUP .X .WORDS>>>>
	<SET ACTION <FIND-ACTION "WALK">>
	<PUT .PV 1 <FIND-VERB "WALK">>
	<PUT .PV 2 .AVAL>)
       (<AND <SET AVAL <PLOOKUP .X .WORDS>>	    ;"preposition or adjective?"
	     <COND (<TYPE? .AVAL VERB> <>)		        ;"flush if verb"
		   (<TYPE? .AVAL PREP>				 ;"preposition?"
		    <COND (<AND .ADJ
				<SET OBJ <GET-OBJECT <CHTYPE .ADJ PSTRING> <>>>>
			   <COND (<SET OS
				       <STUFF-OBJ .OBJ .PREP .PREPVEC .PVR .VB>>
				  <SET PREPVEC <1 .OS>>
				  <SET PVR <2 .OS>>
				  <SET ADJ <>>
				  <SET PREP .AVAL>)
				 (<RETURN <> .PACT>)>)
			  (.PREP)
			  (<SET PREP .AVAL>
			   <SET BUNCHFLG <>>
			   <SET ANDFLG <>>
			   <SET ADJ <>>
			   T)>)
		   (<TYPE? .AVAL ADJECTIVE>			   ;"adjective?"
		    <SET ADJ .AVAL>
		    <NOT <AND .ORFL		 ;"if had ambig. noun, snarf it"
			      <SET AVAL <ONAME .ORPH>>
			      <SET X <PSTRING <SET Y .AVAL>>>>>)
		   (T)>>)
       (<SET AVAL <PLOOKUP .X .OBJOB>>				      ;"object?"
	<COND
	 (<SET OBJ
	       <COND (<==? .AVAL ,IT-OBJECT>
		      <COND (<LIT? .HERE> <SET LOBJ <GET-IT-OBJ>>)
			    (<TELL "I can't find 'it' in the dark.">
			     <RETURN <> .PACT>)>)
		     (ELSE <SET LOBJ <>> <GET-OBJECT .X .ADJ>)>>
						        ;"is object accessible?"
	  <COND (<==? .OBJ .EXCEPT>
		 <COND (<AND <N==? <LENGTH .PVR> 2>
			     <OR <AND <==? <SET OBJ <1 <BACK .PVR>>>
					   <SFIND-OBJ "EVERY">>
				      <SET FX ,CLIMBBIT>>
				 <AND <==? .OBJ <SFIND-OBJ "VALUA">>
				      <SET FX ,TIEBIT>>
				 <AND <==? .OBJ <SFIND-OBJ "POSSE">>
				      <SET FX ,STAGGERED>>>>
			<PUT <SET ANDLOC <BACK .PVR>>
			     1
			     <TRO <SFIND-OBJ "*BUN*"> .FX>>
			<SET ANDFLG T>
			<SET BUNCHFLG T>)
		       (<OR .VB <TELL "That doesn't make sense!">>
			<RETURN <> .PACT>)>)
		(.ANDFLG
		 <OR .BUNCHFLG
		     <PUT <SET BOBJS <BACK .BOBJS>>
			  1
			  <1 <SET ANDLOC <BACK .PVR>>>>>
		 <PUT <SET BOBJS <BACK .BOBJS>> 1 .OBJ>
		 <SET ADJ <>>
		 <SET BUNCHFLG T>)
		(<==? .PREP <PLOOKUP "OF" .WORDS>>
		 <SET PREP <>>
		 <COND (<==? <2 .PV> .OBJ>)
		       (<OR .VB <TELL "That doesn't make sense!">>
			<RETURN <> .PACT>)>)
		(<SET OS <STUFF-OBJ .OBJ .PREP .PREPVEC .PVR .VB>>
		 <SET PREPVEC <1 .OS>>
		 <SET PVR <2 .OS>>
		 <SET PREP <>>)
		(<RETURN <> .PACT>)>   ;"lose, mentioned more than two objects")
	 (<AND <ONAME .ORPH>
	       <TYPE? <SET NOBJ <1 <BACK .PVR>>> OBJECT>
	       <THIS-IT? .X .NOBJ <> <>>>)
	 (ELSE		 ;"interpret why can't find/see/access object for loser"
	  <COND
	   (<EMPTY? .OBJ>
	    <OR
	     .VB
	     <COND
	      (<LIT? .HERE>
	       <COND
		(.LOBJ <TELL "I can't see any " 0 <ODESC2 .LOBJ>>)
		(<==? .VV <TOP .VV>> <TELL "I can't see that" 0>)
		(ELSE
		 <TELL "I can't see any " 0>
		 <COND (.ADJ
			<TELL <LCIFY <1 <BACK .VV 2>> <1 <BACK .VV 1>>>
			      <CHTYPE <PUTBITS #WORD *000000000000*
					       <BITS 18 18>
					       <1 <BACK .VV 1>>>
				      FIX>>
			<TELL " " 0>)>
		 <TELL <LCIFY <2 .VV> <3 .VV>>
		       <CHTYPE <PUTBITS #WORD *000000000000*
					<BITS 18 18>
					<3 .VV>>
			       FIX>>)>
	       <TELL " here.">
	       <ORPHAN <>>)
	      (<TELL "It is too dark in here to see.">)>>)
	   (<==? .OBJ ,NEFALS2>
	    <OR .VB
		<TELL "I can't reach that from inside the "
		      1
		      <ODESC2 <SET ROBJ <AVEHICLE ,WINNER>>>
		      ".">>
	    <ORPHAN <>>
	    T)
	   (T
	    <ORPHAN T	    ;"ambiguous, set up orphan (ONAME slot is giveaway)"
		    <SET AVAL <OR .ACTION <AND .ORFL <OVERB .ORPH>>>>
		    <2 .PV>
		    .PREP
		    <SUBSTRUC .Y 0 <LENGTH .Y> <BACK ,OSTRING <LENGTH .Y>>>>
	    <COND (<NOT .VB>
		   <TELL "Which " 0>
		   <TELL <LCIFY <2 .VV> <3 .VV>>
			 <CHTYPE <PUTBITS #WORD *000000000000*
					  <BITS 18 18>
					  <3 .VV>>
				 FIX>>
		   <COND (.AVAL
			  <TELL " should I " 1 <PRLCSTR <VSTR .AVAL>> "?">)
			 (<TELL "?">)>)>)>
	  <RETURN <> .PACT>)>
	<SET ADJ <>>
	T)
       (ELSE					       ;"inform of unknown word"
	<OR .VB
	    <COND (<AND .ACTION <PLOOKUP .X .ACTIONS>>
		   <TELL "Two verbs in command?">)
		  (<SETG UNKNOWN .VV>
		   <SETG UNKNOWN-LEXV .SV>
		   <TELL "I don't know the word '" 0>
		   <TELL <LCIFY <2 .VV> <3 .VV>>
			 <CHTYPE <PUTBITS #WORD *000000000001*
					  <BITS 18 18>
					  <3 .VV>>
				 FIX>
			 "'.">)>>
	<RETURN <> .PACT>)>
      <COND (<EMPTY? <SET VV <REST .VV 3>>> <RETURN T>)>>>
   <AND .ANDLOC <PUT .ANDLOC 1 ,BUNCH-OBJ> <SETG BUNCH .BOBJS>>
   <AND <==? <1 .PV> <FIND-VERB "WALK">> <RETURN WIN .SPAROUT>>
   <COND
    (.VAL				     ;"second phase starts if first won"
     <COND (<AND .ADJ
		 <COND (<AND <SET OBJ <GET-OBJECT <CHTYPE .ADJ PSTRING> <>>>
			     <SET OS <STUFF-OBJ .OBJ .PREP .PREPVEC .PVR .VB>>>
			<SET PREPVEC <1 .OS>>
			<SET PVR <2 .OS>>
			<SET PREP <SET ADJ <>>>)
		       (<OR .OBJ
			    <OR .VB
				<TELL "I can't see any "
				      1
				      <LCIFY <STRINGP .ADJ>>
				      " here.">>>
			<RETURN <> .SPAROUT>)>>)
	   (<AND <NOT .ACTION> <NOT <SET ACTION <AND .ORFL <OVERB .ORPH>>>>>
	    <OR .VB					    ;"tsk, tsk, no verb"
		<COND (<TYPE? <2 .PV> OBJECT>	      ;"ask about orphan object"
		       <TELL "What should I do with the "
			     1
			     <ODESC2 <2 .PV>>
			     "?">)
		      (<TELL "Huh?">)>>
	    <ORPHAN T <> <2 .PV>>
	    <>)
	   (<AND <PUT .PV 1 .ACTION> <2 .PV> .ADJ> <OR .VB <TELL "Huh?">> <>)
	   (<AND .ORFL
		 <SET NPREP <OPREP .ORPH>>		        ;"orphan prep.?"
		 <NOT <3 .PV>>
		 <NOT .PREP>
		 <==? <1 .PV> <OVERB .ORPH>>
		 <SET OBJ
		      <COND (<TYPE? <SET AVAL <2 .PV>> OBJECT> .AVAL)
			    (.AVAL <2 .AVAL>)>>
		 <PUT <SET PPREP <1 .PREPVEC>> 1 .NPREP>
		 <PUT .PPREP 2 .OBJ>
		 <SETG PREPVEC
		       <SET PREPVEC
			    <COND (<1? <LENGTH .PREPVEC>> <TOP .PREPVEC>)
				  (<REST .PREPVEC>)>>>
		 <COND (<SET AVAL <OSLOT1 .ORPH>>	        ;"orphan object"
			<PUT .PV 2 .AVAL>
			<PUT .PV 3 .PPREP>)
		       (<PUT .PV 2 .PPREP>)>
		 <>>)
	   (.PREP       ;"handle case of 'pick frob up': make it 'pick up frob'"
	    <COND (<TYPE? <SET POBJ <1 <BACK .PVR>>> OBJECT>
				        ;"if hanging prep., make a prep. phrase"
		   <SET PPREP <1 .PREPVEC>>
		   <SETG PREPVEC
			 <SET PREPVEC
			      <COND (<1? <LENGTH .PREPVEC>> <TOP .PREPVEC>)
				    (<REST .PREPVEC>)>>>
		   <PUT .PPREP 1 .PREP>				  ;<SET PREP <>>
		   <PUT .PPREP 2 .OBJ>
		   <PUT <BACK .PVR> 1 .PPREP>
		   .PV)
		  (<ORPHAN T .ACTION <> .PREP> .PV)>)
	   (.PV)>)>>

<DEFINE STUFF-OBJ STUFFACT (OBJ PREP PREPVEC PVR VB
			    "AUX" PPREP (STUFF ,STUFFVEC))
	#DECL ((OBJ) OBJECT (PREP) <OR FALSE PREP>
	       (PREPVEC) <UVECTOR [REST PHRASE]> (PVR) VECTOR
	       (VB) <OR FALSE ATOM> (PPREP) PHRASE (STUFFACT) ACTIVATION
	       (STUFF) <VECTOR UVECTOR VECTOR>)
	<COND (<==? .PREP <PLOOKUP "OF" ,WORDS-POBL>>
	       <COND (<==? <1 <BACK .PVR>> .OBJ>
		      <PUT .STUFF 1 .PREPVEC>
		      <RETURN <PUT .STUFF 2 .PVR> .STUFFACT>)
		     (<OR .VB <TELL "That doesn't make sense!">>
		      <RETURN <> .STUFFACT>)>)>
	<COND (<EMPTY? .PVR> <OR .VB <TELL "Too many objects specified?">> <>)
	      (<PUT .PVR
		    1
		    <COND (.PREP
			   <SET PPREP <1 .PREPVEC>>
			   <SETG PREPVEC
				 <SET PREPVEC
				      <COND (<1? <LENGTH .PREPVEC>>
					     <TOP .PREPVEC>)
					    (<REST .PREPVEC>)>>>
			   <PUT .PPREP 1 .PREP>
			   <PUT .PPREP 2 .OBJ>)
			  (.OBJ)>>
	       <PUT .STUFF 1 .PREPVEC>
	       <PUT .STUFF 2 <REST .PVR>>)>>

<SETG STUFFVEC [![!] []]>

\ 

"GET-IT-OBJ -- decide what 'IT' is referring to.  Algorithm is
highly random and subject to change without notice."

<DEFINE GET-IT-OBJ ("AUX" (LI ,LAST-IT) (HERE ,HERE) (PLAYER ,PLAYER) OBJ)
  #DECL ((LI) OBJECT (HERE) ROOM (PLAYER) ADV (OBJ) <OR FALSE OBJECT>)
  <COND (<AND <TYPE? <SET OBJ <OSLOT1 ,ORPHANS>> OBJECT>
	      <OR <IN-ROOM? .OBJ .HERE>
		  <MEMQ .OBJ <AOBJS .PLAYER>>>>
	 .OBJ)
	(<OR <IN-ROOM? .LI .HERE>
	     <MEMQ .LI <AOBJS .PLAYER>>>
	 .LI)
	(<GET-LAST <ROBJS .HERE>>)
	(<GET-LAST <AOBJS .PLAYER>>)
	(<GET-OBJECT <OID ,LAST-IT> <>>)>>

<DEFINE GET-LAST (L "AUX" (OBJ <>))
	#DECL ((L) <LIST [REST OBJECT]> (OBJ) <OR FALSE OBJECT>)
	<MAPF <>
	  <FUNCTION (X) #DECL ((X) OBJECT)
	    <COND (<TRNN .X ,OVISON>
		   <SET OBJ .X>)>>
	  .L>
	.OBJ>

\ 

"SYN-MATCH -- checks to see if the objects supplied match any of the
syntaxes of the sentence's verb.  if none do, and there are several
possibilities, the one marked 'DRIVER' is used to try to snarf orphans
or if all else fails, to make new orphans for next time."

<DEFINE SYN-MATCH SYN-ACT (PV
			   "AUX" (ACTION <1 .PV>) (OBJS <REST .PV>)
				 (O1 <1 .OBJS>) (O2 <2 .OBJS>) (DFORCE <>)
				 (DRIVE <>) (GWIM <>) (ORPH ,ORPHANS) SYNN
				 (PREP? <AND <OFLAG .ORPH> <OPREP .ORPH>>))
   #DECL ((ACTION) ACTION (PV OBJS) VECTOR (DRIVE DFORCE) <OR FALSE SYNTAX>
	  (O1 O2) <OR FALSE OBJECT PHRASE> (SYNN) VARG (GWIM) <OR FALSE OBJECT>
	  (SYN-ACT) ACTIVATION (ORPH) VECTOR (PREP?) <OR FALSE PREP>)
   <MAPF <>
    <FUNCTION (SYN) 
       #DECL ((SYN) SYNTAX)
       <COND
	(<SYN-EQUAL <SYN1 .SYN> .O1>			    ;"direct object ok?"
	 <COND (<SYN-EQUAL <SYN2 .SYN> .O2>		  ;"indirect object ok?"
		<AND <STRNN .SYN ,SFLIP> <PUT .OBJS 1 .O2> <PUT .OBJS 2 .O1>>
		<RETURN			  ;"syntax a winner, try taking objects"
		        <TAKE-IT-OR-LEAVE-IT .SYN <PUT .PV 1 <SFCN .SYN>>>
			.SYN-ACT>)
	       (<NOT .O2>	      ;"no indirect object? might still be okay"
		<COND (<STRNN .SYN ,SDRIVER> <SET DFORCE .SYN>)
		      (<OR <NOT .PREP?> <==? .PREP? <VPREP <SYN2 .SYN>>>>
		       <SET DRIVE .SYN>
				      ;"last tried is default if no driver")>)>)
	(<OR <COND (<AND <NOT .O2> <SYN-EQUAL <SYN2 .SYN> .O1>>
		    <PUT .OBJS 2 .O1>	    ;"make 'kill with knife' work, etc."
		    <SET O2 .O1>        ;"**coming soon to a parser near you!**"
		    <SET O1 <>>	  ;"new winning OSLOT2 in orphans for total win"
		    T	    ;"i.e. turn with wrench => turn what with wrench?")>
	     <NOT .O1>>
	 <COND (<STRNN .SYN ,SDRIVER> <SET DFORCE .SYN>)
	       (<OR <NOT .PREP?> <==? .PREP? <VPREP <SYN1 .SYN>>>>
		<SET DRIVE .SYN>)>)>>
    <VDECL .ACTION>>
   <COND (<SET DRIVE <OR .DFORCE .DRIVE>>		  ;"lost for bad syntax"
	  <COND (<AND <SET SYNN <SYN1 .DRIVE>>
					  ;"here try to fill direct object slot"
		      <NOT .O1>
		      <NOT <0? <VBIT .SYNN>>>
		      <NOT <ORFEO 1 .SYNN .OBJS>>
						 ;"try to fill slot from orphan"
		      <NOT <SET O1 <SET GWIM <GWIM-SLOT 1 .SYNN .OBJS>>>>>
		 <ORPHAN T .ACTION <> <VPREP .SYNN> <> <2 .OBJS>>
				        ;"all failed, orphan the verb and prep."
		 <ORTELL .SYNN .ACTION .GWIM <2 .OBJS>>)
		(<AND <SET SYNN <SYN2 .DRIVE>>
				        ;"here try to fill indirect object slot"
		      <NOT .O2>
		      <NOT <0? <VBIT .SYNN>>>
		      <NOT <ORFEO 2 .SYNN .OBJS>>
		      <NOT <GWIM-SLOT 2 .SYNN .OBJS>>>
		 <ORPHAN T
			 .ACTION
			 <OR .O1 <AND <OFLAG .ORPH> <OSLOT1 .ORPH>>>
			 <VPREP .SYNN>>		 ;"all failed, orphan the world"
		 <ORTELL .SYNN .ACTION .GWIM>)
		(ELSE <TAKE-IT-OR-LEAVE-IT .DRIVE <PUT .PV 1 <SFCN .DRIVE>>>)>)
	 (ELSE <TELL "I can't make sense out of that."> <>)>>

"SYN-EQUAL -- takes a VARG and an object or phrase.  is the object
acceptable? That is, is the prep. (if any) a match, and is the object ok
(meaning do the OFLAGS slot of the object and the VBIT slot of the verb
agree.  Example: the object you  ATTACK must be a 'victim').  The VFWIM
slot is used to determine what objects to try to take."

<DEFINE SYN-EQUAL (VARG POBJ "AUX" (VBIT <VBIT .VARG>)) 
	#DECL ((VARG) VARG (POBJ) <OR FALSE PHRASE OBJECT> (VBIT) FIX)
	<COND (<TYPE? .POBJ PHRASE>
	       <AND <==? <VPREP .VARG> <1 .POBJ>> <TRNN <2 .POBJ> .VBIT>>)
	      (<TYPE? .POBJ OBJECT>
	       <AND <NOT <VPREP .VARG>> <TRNN .POBJ .VBIT>>)
	      (<AND <NOT .POBJ> <0? .VBIT>>)>>

\ 

"TAKE-IT-OR-LEAVE-IT -- finish setup of parse-vector.  take objects from room if
allowed, flush prepositions from prepositional phrases.  Its value is more or less
ignored by everyone."

<DEFINE TAKE-IT-OR-LEAVE-IT (SYN PV "AUX" (PV1 <2 .PV>) (PV2 <3 .PV>) OBJ) 
	#DECL ((SYN) SYNTAX (PV) VECTOR (PV1 PV2) <OR FALSE OBJECT PHRASE>
	       (OBJ) <OR FALSE OBJECT>)
	<PROG ()
	      <PUT .PV
		   2
		   <SET OBJ
			<COND (<TYPE? .PV1 OBJECT> .PV1)
			      (<TYPE? .PV1 PHRASE> <2 .PV1>)>>>
	      <COND (<==? .OBJ ,BUNCH-OBJ> <SETG BUNCH-SYN .SYN>)
		    (.OBJ <OR <TAKE-IT .OBJ <SYN1 .SYN>> <RETURN <>>>)>
	      <PUT .PV
		   3
		   <SET OBJ
			<COND (<TYPE? .PV2 OBJECT> .PV2)
			      (<TYPE? .PV2 PHRASE> <2 .PV2>)>>>
	      <AND .OBJ <RETURN <TAKE-IT .OBJ <SYN2 .SYN>>>>
	      T>>

"TAKE-IT -- takes object, parse-vector, and syntax bits, tries to perform a TAKE of
the object from the room.  Its value is more or less ignored."

<DEFINE TAKE-IT (OBJ VARG "AUX" TO) 
	#DECL ((OBJ) OBJECT (VARG) VARG (TO) <OR FALSE OBJECT>)
	<COND (<NOT <0? <CHTYPE <ANDB <OGLOBAL .OBJ> ,STAR-BITS> FIX>>>)
	      (<AND <VTRNN .VARG ,VFBIT>
		    <SET TO <OCAN .OBJ>>
		    <NOT <TRNN .TO ,OPENBIT>>>
	       <TELL "I can't reach the " 1 <ODESC2 .OBJ> ".">
	       <>)
	      (<NOT <VTRNN .VARG ,VRBIT>>
	       <COND (<NOT <IN-ROOM? .OBJ>>)
		     (<TELL "You don't have the " 1 <ODESC2 .OBJ> ".">
		      <>)>)
	      (<NOT <VTRNN .VARG ,VTBIT>>
	       <COND (<NOT <VTRNN .VARG ,VCBIT>>)
		     (<NOT <IN-ROOM? .OBJ>>)
		     (<TELL "You don't have the " 1 <ODESC2 .OBJ> ".">
		      <>)>)
	      (<NOT <IN-ROOM? .OBJ>>)
	      (<AND <TRNN .OBJ ,TAKEBIT>
		    <SEARCH-LIST <OID .OBJ> <ROBJS ,HERE> <>>>
	       <COND (<LIT? ,HERE>
		      <DO-TAKE .OBJ>)
		     (<TELL "It is too dark in here to see.">
		      <>)>)
	      (<NOT <VTRNN .VARG ,VCBIT>>)
	      (<TELL "You can't take the " 1 <ODESC2 .OBJ> "."> <>)>>

"DO-TAKE -- perform a take, returning whether you won"

<DEFINE DO-TAKE (OBJ "AUX" RES (PV ,PRSVEC) (SAV1 <1 .PV>) 
				 (SAV2 <2 .PV>) (SAV3 <3 .PV>)) 
	#DECL ((OBJ) OBJECT (PV) VECTOR (SAV1) <OR ACTION VERB> 
	       (SAV2) <OR DIRECTION FALSE OBJECT> (SAV3) <OR OBJECT FALSE> (RES) ANY)
	<PUT .PV 1 <FIND-VERB "TAKE">>
	<PUT .PV 2 .OBJ>
	<PUT .PV 3 <>>
	<SET RES <COND (,GWIM-DISABLE <>)
		       (<TAKE T>)>>
	<PUT .PV 1 .SAV1>
	<PUT .PV 2 .SAV2>
	<PUT .PV 3 .SAV3>
	.RES>

\ 

"---------------------------------------------------------------------
GWIM & FWIM -- all this idiocy is used when the loser didn't specify
part of the command because it was 'obvious' what he meant.  GWIM is
used to try to fill it in by searching for the right object in the
adventurer's possessions and the contents of the room.
---------------------------------------------------------------------"

"GWIM-SLOT -- 'get what i mean' for one slot of the parse-vector.  takes
a slot number, a syntax spec, an action, and the parse-vector.  returns
the object, if it won.  seems a lot of pain for so little, eh?"

<SETG GWIM-DISABLE <>>

<DEFINE GWIM-SLOT (FX VARG OBJS "AUX" OBJ) 
	#DECL ((FX) FIX (VARG) VARG (OBJS) VECTOR
	       (OBJ) <OR FALSE OBJECT>)
	<COND (,GWIM-DISABLE <>)
	      (<SET OBJ <GWIM <VFWIM .VARG> .VARG>>
	       <PUT .OBJS .FX .OBJ>
	       .OBJ)>>

"GWIM -- 'get what i mean'.  takes attribute to check, what to check in
(adventurer and/or room), and verb.  does a 'TAKE' of it if found,
returns the object."

<DEFINE GWIM (BIT FWORD 
	      "AUX" (AOBJ? <VTRNN .FWORD ,VABIT>)
		    (ROBJ? <VTRNN .FWORD ,VRBIT>)
		    (DONT-CARE? <NOT <VTRNN .FWORD ,VCBIT>>)
		    (AOBJ <>) ROBJ (AV <AVEHICLE ,WINNER>))
	#DECL ((BIT) FIX (FWORD) VARG (DONT-CARE? AOBJ? ROBJ? CARE?) <OR ATOM FALSE>
	       (AOBJ ROBJ AV) <OR OBJECT FALSE>)
	<COND (.AOBJ? <SET AOBJ <FWIM .BIT <AOBJS ,WINNER> .DONT-CARE?>>)>
	<COND (<AND <OR .AOBJ
			<EMPTY? .AOBJ>>
		    .ROBJ?
		    <LIT? ,HERE>>
	       <COND (<AND <SET ROBJ <FWIM .BIT <ROBJS ,HERE> .DONT-CARE?>>
			   <OR <NOT .AV>
			       <==? .AV .ROBJ>
			       <MEMQ .ROBJ <OCONTENTS .AV>>
			       <TRNN .ROBJ ,FINDMEBIT>>>
		      <COND (<AND <NOT .AOBJ>
				  <TAKE-IT .ROBJ .FWORD>
				  .ROBJ>)>)
		     (<OR .ROBJ <NOT <EMPTY? .ROBJ>>> ,NEFALS)
		     (.AOBJ)>)
	      (.AOBJ)>>

"FWIM -- takes object specs, list of objects to look in, and whether or
not we care if can take object.  find one that can be manipulated (visible
and takeable, or visible and in something that's visible and open)"

<DEFINE FWIM DWIM (BIT OBJS NO-CARE "AUX" (NOBJ <>)) 
   #DECL ((NO-CARE) <OR ATOM FALSE> (BIT) FIX (OBJS) <LIST [REST OBJECT]>
	  (NOBJ) <OR FALSE OBJECT> (DWIM) ACTIVATION)
   <MAPF <>
    <FUNCTION (X) 
	    #DECL ((X) OBJECT)
	    <COND (<AND <TRNN .X ,OVISON>
			<OR .NO-CARE <TRNN .X ,TAKEBIT>>
			<TRNN .X .BIT>>
		   <COND (.NOBJ <RETURN ,NEFALS .DWIM>)>
		   <SET NOBJ .X>)>
	    <COND
	     (<AND <TRNN .X ,OVISON> <TRNN .X ,OPENBIT>>
	      <MAPF <>
		    <FUNCTION (X) 
			    #DECL ((X) OBJECT)
			    <COND (<AND <TRNN .X ,OVISON> <TRNN .X .BIT>>
				   <COND (.NOBJ <RETURN ,NEFALS .DWIM>)
					 (<SET NOBJ .X>)>)>>
		    <OCONTENTS .X>>)>>
    .OBJS>
   .NOBJ>

\ 

"GET-OBJECT -- used to see if an object is accessible.  it looks for
an object that can be described by an adjective-noun pair.
	Takes atom (from objects oblist), adjective, and verbosity flag. 
grovels over: ,STARS; ,HERE; ,WINNER looking for object (looks down to
one level of containment).
	returns:
               #FALSE () -- if fails because can't find it or it's dark in room
     NEFALS  = #FALSE (1) -- ambiguous object
     NEFALS2 = #FALSE (2) -- can't reach from in vehicle
	or
     object -- if found it.
"

<DEFINE GET-OBJECT GET-OBJ (OBJNAM ADJ
			    "AUX" OBJ (OOBJ <>) (HERE ,HERE)
				  (AV <AVEHICLE ,WINNER>) (CHOMP <>)
				  (LIT <LIT? .HERE>) (NEFALS ,NEFALS))
	#DECL ((OOBJ OBJ AV) <OR OBJECT FALSE> (OBJNAM) PSTRING (HERE) ROOM
	       (ADJ) <OR ADJECTIVE FALSE> (CHOMP) <OR ATOM FALSE> (NEFALS) FALSE
	       (OBJL) <OR FALSE <LIST [REST OBJECT]>> (LIT) <OR ATOM FALSE>
	       (GET-OBJ) ACTIVATION)
	<COND (<AND .LIT <SET OBJ <SEARCH-LIST .OBJNAM <ROBJS ,HERE> .ADJ>>>
	       <COND (<AND .AV
			   <N==? .OBJ .AV>
			   <NOT <MEMQ .OBJ <OCONTENTS .AV>>>
			   <NOT <TRNN .OBJ ,FINDMEBIT>>>
		      <SET CHOMP T>)
		     (<SET OOBJ .OBJ>)>)
	      (<AND .LIT <NOT .OBJ> <NOT <EMPTY? .OBJ>>> <RETURN .NEFALS .GET-OBJ>)>
	<COND (.AV
	       <COND (<SET OBJ <SEARCH-LIST .OBJNAM <OCONTENTS .AV> .ADJ>>
		      <SET CHOMP <>>
		      <SET OOBJ .OBJ>)
		     (<NOT <EMPTY? .OBJ>> <RETURN .NEFALS .GET-OBJ>)>)>
	<COND (<SET OBJ <SEARCH-LIST .OBJNAM <AOBJS ,WINNER> .ADJ>>
	       <COND (.OOBJ
		      <COND (<NOT .ADJ>
			     <COND (<==? <EMPTY? <OADJS .OBJ>>
					 <EMPTY? <OADJS .OOBJ>>>
				    .NEFALS)
				   (<EMPTY? <OADJS .OBJ>>
				    .OBJ)
				   (T .OOBJ)>)
			    (T .NEFALS)>)
		     (.OBJ)>)
	      (<NOT <EMPTY? .OBJ>> .NEFALS)
	      (.CHOMP ,NEFALS2)
	      (.OOBJ)
	      (<SEARCH-LIST .OBJNAM ,GLOBAL-OBJECTS .ADJ T <RGLOBAL .HERE>>)
	      (.ADJ
	       <COND (<AND <SET OBJ <PLOOKUP .OBJNAM ,OBJECT-POBL>>
			   <GTRNN .HERE <OGLOBAL .OBJ>>>
		      .OBJ)>)>>

"SEARCH-LIST -- search room, or adventurer, or stars, or whatever.
	takes object name, list of objects, and verbosity. if finds one
frob under that name on list, returns it.  search is to one level of
containment.
"

<DEFINE SEARCH-LIST SL (OBJNAM SLIST ADJ
			"OPTIONAL" (FIRST? T) (GLOBAL? <>)
			"AUX" (OOBJ <>) (NEFALS ,NEFALS) NOBJ (AMBIG-EMPTY <>))
   #DECL ((OBJNAM) PSTRING (SLIST) <LIST [REST OBJECT]>
	  (OOBJ NOBJ) <OR FALSE OBJECT> (ADJ) <OR FALSE ADJECTIVE>
	  (FIRST? AMBIG-EMPTY) <OR ATOM FALSE> (NEFALS) FALSE (SL) ACTIVATION
	  (GLOBAL?) <OR FALSE <PRIMTYPE WORD>>)
   <MAPF <>
	 <FUNCTION (OBJ) 
		 #DECL ((OBJ) OBJECT)
		 <COND (<THIS-IT? .OBJNAM .OBJ .ADJ .GLOBAL?>
			<COND (.OOBJ
			       <COND (<NOT .ADJ>
				      <COND (<AND <EMPTY? <OADJS .OOBJ>>
						  <EMPTY? <OADJS .OBJ>>>
					     <RETURN .NEFALS .SL>)
					    (<EMPTY? <OADJS .OBJ>> <SET OOBJ .OBJ>)
					    (<SET AMBIG-EMPTY T>)>)
				     (<RETURN .NEFALS .SL>)>)
			      (<SET OOBJ .OBJ>)>)>
		 <COND (<AND <TRNN .OBJ ,OVISON>
			     <OR <TRNN .OBJ ,OPENBIT> <TRNN .OBJ ,TRANSBIT>>
			     <OR .FIRST? <TRNN .OBJ ,SEARCHBIT>>>
			<COND (<SET NOBJ
				    <SEARCH-LIST .OBJNAM
						 <OCONTENTS .OBJ>
						 .ADJ
						 <>>>
			       <COND (.OOBJ <RETURN .NEFALS .SL>)
				     (<SET OOBJ .NOBJ>)>)
			      (<==? .NOBJ .NEFALS> <RETURN .NEFALS .SL>)>)>>
	 .SLIST>
   <COND (<AND .AMBIG-EMPTY .OOBJ <NOT <EMPTY? <OADJS .OOBJ>>>>
	  .NEFALS)
	 (.OOBJ)>>

\ 

<SETG ORPHANS [<> <> <> <> <> <>]>

<MSETG OSLOT2 6>

<DEFINE ORPHAN ("OPTIONAL" (FLAG <>) (ACTION <>) (SLOT1 <>) (PREP <>)
			   (NAME <>) (SLOT2 <>)) 
	#DECL ((FLAG) <OR ATOM FALSE> (NAME) <OR STRING FALSE>
	       (ACTION) <OR FALSE ACTION> (SLOT1 SLOT2) <OR FALSE OBJECT PHRASE>
	       (PREP) <OR FALSE PREP>)
	<COND (.FLAG
	       <PUT <PUT <PUT <PUT <PUT <PUT ,ORPHANS
					     ,OSLOT2
					     .SLOT2>
					,ONAME
					.NAME>
				   ,OPREP
				   .PREP>
			      ,OSLOT1
			      .SLOT1>
			 ,OVERB
			 .ACTION>
		    ,OFLAG
		    .FLAG>)
	      (<SETG PREPVEC <TOP ,PREPVEC>> <PUT ,ORPHANS ,OFLAG <>>)>>

<DEFINE ORFEO (SLOT SYN OBJS "AUX" (ORPH ,ORPHANS) (ORFL <OFLAG .ORPH>) ORPHAN) 
	#DECL ((SYN) VARG (OBJS ORPH) VECTOR (ORFL) <OR ATOM FALSE>
	       (ORPHAN) <OR FALSE PHRASE OBJECT> (SLOT) FIX)
	<COND (<NOT .ORFL> <>)
	      (<SET ORPHAN <COND (<1? .SLOT> <OSLOT1 .ORPH>)
				 (<OSLOT2 .ORPH>)>>
	       <AND <SYN-EQUAL .SYN .ORPHAN> <PUT .OBJS .SLOT .ORPHAN>>)>>

<DEFINE ORTELL (VARG ACTION GWIM
		"OPTIONAL" (SLOT2 <>)
		"AUX" (PREP <VPREP .VARG>))
	#DECL ((VARG) VARG (ACTION) ACTION (PREP) <OR FALSE PREP>
	       (GWIM) <OR FALSE OBJECT> (SLOT2) <OR FALSE OBJECT PHRASE>)
	<COND (.PREP
	       <AND .GWIM
		    <TELL <VSTR .ACTION> 0 " ">
		    <TELL <ODESC2 .GWIM> 0 " ">>
	       <TELL <PRFUNNY .PREP> 1 " what?">)
	      (<TYPE? .SLOT2 PHRASE>
	       <TELL <VSTR .ACTION> 0 " what ">
	       <TELL <PRFUNNY <PPREP .SLOT2>> 0 " the " <ODESC2 <POBJ .SLOT2>>>
	       <TELL "?">)
	      (<TELL <VSTR .ACTION> 1 " what?">)>
	<>>

\ 

"PRSTR -- printing routine to print uc/lc atom pname"

<DEFINE PRSTR (SP) 
	#DECL ((SP) STRING)
	<FOOSTR .SP <BACK ,SCRSTR <LENGTH .SP>> <>>>

<DEFINE PRFUNNY (FTYPE)
	#DECL ((FTYPE) <PRIMTYPE WORD>)
	<PRSTR <STRINGP .FTYPE>>>

<DEFINE PRLCSTR (STR) 
	#DECL ((STR) STRING)
	<FOOSTR .STR <BACK ,LSCRSTR <LENGTH .STR>> T T>>

<SETG SCRSTR <REST <ISTRING 5> 5>>

<SETG LSCRSTR <REST <ISTRING 15> 15>>

<SETG OSTRING <REST <ISTRING 5> 5>>

<DEFINE LCIFY (STR "OPTIONAL" (LEN <LENGTH .STR>)) 
	#DECL ((STR) STRING (LEN) FIX)
	<MAPR <>
	      <FUNCTION (S "AUX" (C <ASCII <1 .S>>)) 
		      #DECL ((S) STRING (C) FIX)
		      <COND (<AND <L=? .C <ASCII !\Z>> <G=? .C <ASCII !\A>>>
			     <PUT .S 1 <ASCII <+ .C 32>>>)>
		      <COND (<0? <SET LEN <- .LEN 1>>> <MAPLEAVE .STR>)>>
	      .STR>>

<DEFINE FOOSTR (NAM STR "OPTIONAL" (1ST T) (LC <>)) 
	#DECL ((STR NAM) STRING (1ST LC) <OR ATOM FALSE>)
	<MAPR <>
	      <FUNCTION (X Y "AUX" (A <ASCII <1 .X>>)) 
		      #DECL ((X Y) STRING (A) FIX)
		      <COND (<AND <NOT .LC> .1ST <==? .X .NAM>>
			     <PUT .Y 1 <1 .X>>)
			    (<OR <L? .A <ASCII !\A>> <G? .A <ASCII !\Z>>>
			     <PUT .Y 1 <1 .X>>)
			    (<PUT .Y 1 <ASCII <+ .A 32>>>)>>
	      .NAM
	      .STR>
	.STR>

\ 

;"Here is some code for handling BUNCHes."

<GDECL (BUNCHER) VERB>

;
"Action function for BUNCHing.
   ,BUNCH = UVECTOR of OBJECTS in the bunch
   ,BUNCH-SYN = SYNTAX for this call (for TAKE-IT-OR-LEAVE-IT)
   BUNCHEM sets up PRSVEC for each object in the bunch, tries to
do the TAKE, etc. if necessary and calls the VERB function.
"

<DEFINE BUNCHEM ("AUX" (VERB <OBVERB ,BUNCH-OBJ>) (VFCN <VFCN .VERB>)
		       (PV ,PRSVEC) (OBJS ,BUNCH) (SYN ,BUNCH-SYN) (HERE ,HERE)
		       (BUN <SFIND-OBJ "*BUN*">) (EV <TRNN .BUN ,CLIMBBIT>))
	#DECL ((VERB) VERB (VFCN) RAPPLIC (PV) VECTOR (HERE) ROOM (EV) <OR ATOM FALSE>
	       (OBJS) <UVECTOR [REST OBJECT]> (SYN) SYNTAX (BUN) OBJECT)
	<PUT .PV 1 .VERB>
	<COND (<TRNN .BUN <+ ,CLIMBBIT ,TIEBIT ,STAGGERED>>
	       <TRZ .BUN <+ ,CLIMBBIT ,TIEBIT ,STAGGERED>>
	       <VALUABLES&C .EV .OBJS>)
	      (<REPEAT ((BUN <REST .OBJS <LENGTH .OBJS>>) OBJ)
		       #DECL ((BUN) <UVECTOR [REST OBJECT]> (OBJ) OBJECT)
		       <SET OBJ <1 <SET BUN <BACK .BUN>>>>
		       <TELL <ODESC2 .OBJ> 0 ":
">
		       <PUT .PV 2 .OBJ>
		       <COND (<TAKE-IT-OR-LEAVE-IT .SYN .PV>
			      <APPLY-RANDOM .VFCN>)>
		       <OR <==? ,HERE .HERE> <RETURN>>
		       <AND <==? .OBJS .BUN> <RETURN>>>)>>

"PARSER AUXILIARIES"

;"SET UP INPUT ERROR HANDLER TO CAUSE EPARSE TO FALSE OUT"

<DEFINE THIS-IT? (OBJNAM OBJ ADJ GLOBAL) 
	#DECL ((GLOBAL) <OR FALSE <PRIMTYPE WORD>>
	       (OBJNAM) PSTRING (OBJ) OBJECT (ADJ) <OR FALSE ADJECTIVE>)
	<COND (<AND <OR <NOT .GLOBAL>
			<N==? <CHTYPE <ANDB .GLOBAL <OGLOBAL .OBJ>> FIX> 0>>
		    <TRNN .OBJ ,OVISON>
		    <MEMQ .OBJNAM <ONAMES .OBJ>>>
	       <COND (<NOT .ADJ>) (<MEMQ .ADJ <OADJS .OBJ>>)>)>>

<SETG LEXSIZE 30>

<MANIFEST LEXSIZE>

<GDECL (LEXV LEXV1 UNKNOWN-LEXV)
       <VECTOR [REST STRING STRING FIX]>
       (BRKS)
       STRING>

<DEFINE LEX (S
	     "OPTIONAL" (SX <REST .S <LENGTH .S>>) 
	     "AUX" (BRKS ,BRKS) (V ,LEXV1) (TV .V) (S1 .S) (QUOT <>) (BRK !\ )  CNT T
		   (THEN-STR <>) (THEN-VEC <>) (INPLEN <- <LENGTH .S> <LENGTH .SX>>))
   #DECL ((S S1 SX BRKS T) STRING (SILENT? QUOT) <OR ATOM FALSE>
	  (VALUE) <OR FALSE VECTOR> (TV V) <VECTOR [REST STRING STRING FIX]>
	  (INPLEN CNT) FIX (BRK) CHARACTER (THEN-STR) <OR FALSE STRING>
	  (THEN-VEC) <OR FALSE VECTOR>)
   <SWAP-EM>
   <REPEAT ((VV .V))
	   #DECL ((VV) <VECTOR [REST STRING STRING FIX]>)
	   <PUT .VV 1 <REST <1 .VV> <LENGTH <1 .VV>>>>
	   <SET VV <REST .VV 3>>
	   <AND <EMPTY? .VV> <RETURN>>>
   <COND
    (<==? <1 .S> !\?> <PUT .V 1 <SUBSTRUC "HELP" 0 4 <BACK <1 .V> 4>>>
     .TV)
    (<REPEAT (SLEN QEND? CHAR)
       #DECL ((CHAR) CHARACTER (SLEN) FIX (QEND?) <OR ATOM FALSE>)
       <COND
	(<OR <AND <==? <LENGTH .S1> <LENGTH .SX>> <SET CHAR <SET BRK !\ >>>
	     <AND <OR <==? <SET CHAR <1 .S1>> !\;>
		      <MEMQ .CHAR .BRKS>>
		  <SET BRK .CHAR>>>
	 <SET QEND? <>>
	 <COND (<AND <G? <LENGTH .S1> <LENGTH .SX>>
		     <OR <==? .CHAR !\'> <==? <1 .S1> !\">>>
		<COND (<NOT .QUOT>
		       <SET QUOT T>
		       <SET V <REST .V 3>>)
		      (<SET QEND? T>)>)>
	 <COND
	  (<AND <==? .S .S1>
		<OR <==? .BRK !\.> <==? .BRK !\,>>
		<L? <LENGTH .V> <- ,LEXSIZE 1>>
		<OR <N=? <1 <BACK .V 3>> "AND">
		    <N=? <1 <BACK .V 3>> "THEN">>>
	   <COND (<==? .BRK !\,> <PUT .V 1 <SUBSTRUC "AND" 0 3 <BACK <1 .V> 3>>>)
		 (<PUT .V 1 <SUBSTRUC "THEN" 0 4 <BACK <1 .V> 4>>>
		  <SET THEN-STR .S>
		  <SET THEN-VEC .V>)>
	   <SET V <REST .V 3>>)
	  (<N==? .S .S1>
	   <COND
	    (<EMPTY? .V>
	     <RETURN <LEX-TRUNCATE .THEN-STR .THEN-VEC .INPLEN>>)
	    (<PUT .V
		  1
		  <UPPERCASE <SUBSTRUC .S
				       0
				       <SET SLEN
					    <MIN <SET CNT <- <LENGTH .S> <LENGTH .S1>>>
						 5>>
				       <BACK <1 .V> .SLEN>>>>
	     
	     <PUT .V 2 .S>
	     <PUT .V 3 .CNT>
	     <COND (<EMPTY? <SET V <REST .V 3>>>
		    <RETURN <LEX-TRUNCATE .THEN-STR .THEN-VEC .INPLEN>>)>
	     <COND (.QEND?
		    <COND (<EMPTY? <SET V <REST .V 3>>>
			   <RETURN <LEX-TRUNCATE .THEN-STR .THEN-VEC .INPLEN>>)>)>
	     <COND (<==? .BRK !\,>
		    <PUT .V 1 <SUBSTRUC "AND" 0 3 <BACK <1 .V> 3>>>
		    <SET V <REST .V 3>>)
		   (<==? .BRK !\.>
		    <PUT .V 1 <SUBSTRUC "THEN" 0 4 <BACK <1 .V> 4>>>
		    <SET THEN-STR <REST .S1>>
		    <SET THEN-VEC .V>
		    <SET V <REST .V 3>>)>
	     <AND <L? <LENGTH .V> <- ,LEXSIZE 1>>
		  <OR <=? <SET T <1 <BACK .V 3>>> "AND"> <=? .T "THEN">>
		  <OR <=? <SET T <1 <BACK .V 6>>> "AND"> <=? .T "THEN">>
		  <PUT <SET V <BACK .V 3>> 1 <REST <1 .V> <LENGTH <1 .V>>>>>)>)>
	 <COND (<OR <==? <LENGTH .S1> <LENGTH .SX>>
		    <==? .BRK !\;>>
		<COND (<AND <N==? .V .TV>
			    <OR <=? <SET T <1 <SET V <BACK .V 3>>>> "AND">
				<=? .T "THEN">>>
		       <PUT .V 1 <REST <1 .V> <LENGTH <1 .V>>>>)>
		<RETURN .TV>)>
	 <SET S <REST .S1>>)>
       <SET S1 <REST .S1>>>)>>

<DEFINE LEX-TRUNCATE (STR VEC INPLEN "AUX" (INBUF ,INBUF) FOO) 
	#DECL ((STR) <OR FALSE STRING> (INPLEN FOO) FIX (INBUF) STRING
	       (VEC) <OR FALSE <VECTOR [REST STRING STRING FIX]>>)
	<COND (<NOT .STR> <TELL "This sentence is obscene.">)
	      (<SUBSTRUC .STR
			 0
			 <SET FOO <- <LENGTH .STR> <- <LENGTH .INBUF> .INPLEN>>>
			 <SET STR <REST .INBUF <- <LENGTH .INBUF> .FOO>>>>
	       <TELL "Input ignored: '" 1 .STR "'.">
	       <REPEAT ((NVEC .VEC))
		       #DECL ((NVEC) <VECTOR [REST STRING STRING FIX]>)
		       <PUT .NVEC 1 <REST <1 .NVEC> <LENGTH <1 .NVEC>>>>
		       <SET NVEC <REST .NVEC 3>>
		       <AND <EMPTY? .NVEC> <RETURN>>>
	       <TOP .VEC>)>>

<PSETG BRKS "\"' 	:.,?!
">

<DEFINE UPPERCASE (STR) 
	#DECL ((STR) STRING)
	<MAPR <>
	      <FUNCTION (S "AUX" (C <ASCII <1 .S>>)) 
		      #DECL ((S) STRING (C) FIX)
		      <COND (<AND <G? .C 96> <L=? .C 122>>
			     <PUT .S 1 <ASCII <- .C 32>>>)>>
	      .STR>
	.STR>
    
 

 

 
