
<SETG SAVSTR <ISTRING 5>>

<SETG SAVE-VERSION -1>

<GDECL (SAVE-VERSION) FIX (SRUV) <UVECTOR [REST FIX]>>

;"CONSTANTS FOR SAVE-RESTORE UVECTOR"

<MSETG OBJSVLN 3600>

;"Length of ROOMS block"

<MSETG RMSVLN 2000>

;"Length of DEMONS block"

<MSETG DMNSVLN 225>

;"Length of <HOBJS <robber>> block"

<MSETG HOBJSVLN 17>

;"Starting offset of CLOCKER slots"

<MSETG CEVSVOFF 20>

;"Length of CEVENT slots (33 CEVENTS x 3 slots)"

<MSETG CEVSVLN 99>

;"Length of ACTORs block"

<SETG ACTSVLN 122>

;"Length of WINNER block"

<MSETG WSVLN 22>

;"Length of MONAD GVAL block"

<MSETG MGSVLN 125>

;"Length of ROOM GVAL block"

<MSETG RMGSVLN 15>

;"Length of OBJECT GVAL block"

<MSETG OBJGSVLN 10>

;"# of slots for OBJECTs"

<MSETG PUZSVLN 164>

<MSETG SAVLENGTH
       <+ 1 ,OBJSVLN ,RMSVLN ,DMNSVLN ,ACTSVLN ,MGSVLN ,RMGSVLN ,OBJGSVLN ,PUZSVLN>>

<MSETG ORECLN 12>

;"# of slots for ROOMs"

<MSETG RRECLN 8>

;"# of slots for CEVENT"

<MSETG CRECLN 3>

;"Names of slots to be saved from OBJECTS"

<PSETG OSNAMES
       '![OID OCAN OFLAGS OROOM ORAND OFVAL OSIZE OCAPAC OLINT OMATCH
	  OSTRENGTH!]>

;"Types of these slots (rested once)"

<PSETG OSTYPES '![OBJECT FIX ROOM FIX FIX FIX FIX FIX FIX FIX!]>

;"Names of slots to be saved from ROOMS"

<PSETG RSNAMES '![RID RVARS RBITS RRAND RVAL!]>

;"Types of these slots (rested once)"

<PSETG RSTYPES '![FIX WORD FIX FIX!]>

;"Names of slots to be saved from CEVENTS"

<PSETG CSNAMES '![CID CTICK CFLAG!]>

;"Types of these slots"

<PSETG CSTYPES '![FIX FIX!]>

<GDECL (OSNAMES RSNAMES CSNAMES OSTYPES RSTYPES CSTYPES) <UVECTOR [REST ATOM]>>

<DEFINE POS (OBJ LST "AUX" M)
    #DECL ((OBJ) ANY (LST) LIST (M) <OR FALSE LIST>)
    <AND <SET M <MEMQ .OBJ .LST>>
	 <+ 1 <- <LENGTH .LST> <LENGTH .M>>>>>

 ; "Get the FIX code for any item."
<GDECL (CLOCKER) HACK (CLOCK-CALLERS) LIST (ACTORS) <LIST [REST ADV]>>

<DEFINE SCODE (ITM "AUX" RI) 
	#DECL ((ITM) ANY (RI) <VECTOR FIX CEVENT>)
	<COND (<==? .ITM T> 10223616)
	      (<NOT .ITM> 2883584)
	      (<TYPE? .ITM ADV> 0)
	      (<TYPE? .ITM ATOM PSTRING> <ATMFIX .ITM>)
	      (<==? <PRIMTYPE .ITM> WORD> <CHTYPE .ITM FIX>)
	      (<TYPE? .ITM ROOM> <ATMFIX <RID .ITM>>)
	      (<TYPE? .ITM OBJECT> <ATMFIX <OID .ITM>>)
	      (<DECL? .ITM '<VECTOR FIX CEVENT>>
	       <SET RI .ITM>
	       <PUTBITS <PUTBITS 3145728
				 <BITS 18 0>
				 <POS <2 .RI> <HOBJS ,CLOCKER>>>
			<BITS 9 9>
			<1 .RI>>)
	      (5505024)>>

;"Get an object from any FIX code (inverse of SCODE)"

<DEFINE SDECODE (FX TYP "AUX" ATM)
    #DECL ((FX) FIX (TYP) ATOM (ATM) <OR ATOM FALSE>)
    <COND (<==? .FX *47000000*>)
	  (<==? .FX *13000000*> <>)
	  (<==? .FX *25000000*> #FALSE (1))
 	  (<==? <GETBITS .FX <BITS 18 18>> #WORD *14*>
	   <VECTOR <CHTYPE <GETBITS .FX <BITS 9 9>> FIX>
		   <NTH <HOBJS ,CLOCKER> <CHTYPE <GETBITS .FX <BITS 9 0>> FIX>>>)
	  (<==? .TYP OBJECT>
	   <COND (<0? .FX> <>)
		 (<FIND-OBJ <FIXSTR .FX>>)>)
	  (<==? .TYP ROOM>
	   <COND (<0? .FX> <>)
		 (<NOT <PLOOKUP <FIXSTR .FX> ,ROOM-POBL>>
		  <FIND-ROOM "FCHMP">)
		 (<FIND-ROOM <FIXSTR .FX>>)>)
	  (<==? .TYP CEVENT>
	   <COND (<0? .FX> <>)
		 (<SET ATM <LOOKUP <FIXSTR .FX> <GET INITIAL OBLIST>>>
		  ,.ATM)>)
	  (<CHTYPE .FX .TYP>)>>

; "Save elements from a list of items:
	Arg 1: The code UVECTOR
	Arg 2: The list of items (e.g. ,ROOMS ,OBJECTS)
	Arg 3: Number of elements to REST off Arg 1 when finished
	Arg 4: A UVECTOR of offsets for each item to be saved
	Arg 5: The number of slots to be used for each item in the UVECTOR"

<DEFINE UNSAVORY-CODE (SU L OFF NUVEC RECLEN "AUX" (NU .SU))
    #DECL ((L) LIST (OFF RECLEN) FIX (SU NU) <UVECTOR [REST FIX]>
	   (NUVEC) <UVECTOR [REST ATOM]>)
    <MAPF <>
	<FUNCTION (ITM "AUX" (U .NU))
	    #DECL ((ITM) <PRIMTYPE VECTOR> (U) <UVECTOR [REST FIX]>)
	    <MAPF <>
		<FUNCTION (SLT "AUX" VAL)
		    #DECL ((SLT) ATOM (VAL) ANY)
		    <SET VAL <SRGET .ITM .SLT>>
		    <PUT .U
			 1
			 <SCODE .VAL>>
		    <SET U <REST .U 1>>>
		.NUVEC>
	    <SET NU <REST .NU .RECLEN>>>
	.L>
    <REST .SU .OFF>>

; "Restore elements from an object
	Arg 1: The code UVECTOR
	Arg 2: The object
	Arg 3: A UVECTOR of offsets into the object
	Arg 4: A UVECTOR of types for these offsets (ATOMs)"

<DEFINE UNRESTFUL-CODE (U OBJ NUVEC TUVEC "AUX" M) 
	#DECL ((U) <UVECTOR [REST FIX]> (TUVEC NUVEC) <UVECTOR [REST ATOM]>
	       (OBJ) <PRIMTYPE VECTOR> (M) <OR FALSE <VECTOR OBJECT ATOM ATOM>>)
	<MAPF <>
	      <FUNCTION (SLT TYP "AUX" TMP) 
		      #DECL ((SLT TYP) ATOM)
		      <COND (<OR <SET TMP <SDECODE <1 .U> .TYP>> <EMPTY? .TMP>>
			     <SRPUT .OBJ .SLT .TMP>)>
		      <SET U <REST .U 1>>>
	      .NUVEC
	      .TUVEC>>

<DEFINE SRGET (OBJ SLT "AUX" HOW) 
	#DECL ((OBJ) <PRIMTYPE VECTOR> (SLT) ATOM (HOW) APPLICABLE)
	<COND (<AND <GASSIGNED? .SLT>
		    <TYPE? <SET HOW ,.SLT> FIX>>
	       <NTH .OBJ .HOW>)
	      (<==? .SLT OID>
	       <OID .OBJ>)
	      (<OGET .OBJ .SLT>)>>

<DEFINE SRPUT (OBJ SLT VAL "AUX" HOW M) 
	#DECL ((OBJ) <PRIMTYPE VECTOR> (SLT) ATOM (VAL) ANY (HOW) APPLICABLE
	       (M) <OR FALSE <VECTOR OBJECT ATOM ATOM>>)
	<COND (<SET M <MEMQ .OBJ ,OFIXUPS>>
	       <COND (<==? <2 .M> .SLT> <SET SLT <3 .M>>)>)>
	<COND (<AND <GASSIGNED? .SLT>
		    <TYPE? <SET HOW ,.SLT> FIX>>
	       <PUT .OBJ .HOW .VAL>)
	      (<OPUT .OBJ .SLT .VAL>)>>

;
"Save GVALs
	Arg 1: The code UVECTOR
	Arg 2: A UVECTOR of ATOMS (which must have GVALs!
	Arg 3: Number of times to rest UVECTOR when done"

<DEFINE SAVE-GVAL (V GV RST)
    #DECL ((V) <UVECTOR [REST FIX]> (GV) <UVECTOR [REST ATOM]> (RST) FIX)
    <MAPR <>
	<FUNCTION (ATMS VEC)
	    #DECL ((ATMS) <UVECTOR [REST ATOM]> (VEC) <UVECTOR [REST FIX]>)
	    <PUT .VEC 1 <SCODE <GVAL <1 .ATMS>>>>>
	.GV
	.V>
    <REST .V .RST>>

; "Restore GVALs
	Args 1-3: As above
	Arg 4: The type (ATOM) to restore"

<DEFINE REST-GVAL (V GV RST TYP)
    #DECL ((V) <UVECTOR [REST FIX]> (GV) <UVECTOR [REST ATOM]> (RST) FIX (TYP) ATOM)
    <MAPF <>
	<FUNCTION (ATM VAL)
	    #DECL ((ATM) ATOM (VAL) FIX)
	    <SETG .ATM <SDECODE .VAL .TYP>>>
	.GV
	.V>
    <REST .V .RST>>

; "Restore a LIST of OBJECTs
	Arg 1: The code UVECTOR 
	Stops when a 0 is encountered"

<DEFINE REST-LIST (V)
    #DECL ((V) <UVECTOR [REST FIX]>)
    <MAPF ,LIST
	<FUNCTION (X)
	    #DECL ((X) FIX)
	    <COND (<0? .X> <MAPSTOP>)
		  (<SDECODE .X OBJECT>)>>
	.V>>

; "Restore ROOMS/OBJECTS
	Arg 1: The code UVECTOR
	Arg 2: A UVECTOR of offsets into the objects (FIX)
	Arg 3: A UVECTOR of types of the offsets (ATOM)
	Arg 4: The length of each record
	Arg 5: OBJECT/ROOM flag
	Gets the item (ROOM or OBJECT) from the ID slot and then
	calls UNRESTFUL-CODE to fill the elements (note that this
	function is called with names = <REST ,xSNAMES>
  	This function also fixes up OCONTENTS and OROOM slots."

<DEFINE REST-ITEMS (V NAMES TYPES RECLEN TYPE "AUX" D C) 
   #DECL ((V) <UVECTOR [REST FIX]> (TYPES NAMES) <UVECTOR [REST ATOM]>
	  (RECLEN) FIX (TYPE) ATOM (C) <OR FALSE <PRIMTYPE VECTOR>>
	  (D) <OR FALSE DOOR>)
   <REPEAT (OBJ)
	   #DECL ((OBJ) <OR FALSE <PRIMTYPE VECTOR>>)
	   <COND
	    (<SET OBJ <SDECODE <1 .V> .TYPE>>
	     <UNRESTFUL-CODE <REST .V> .OBJ .NAMES .TYPES>
	     <COND (<==? .TYPE OBJECT>
		    <COND (<SET C <OCAN .OBJ>>
			   <PUT .C ,OCONTENTS (.OBJ !<OCONTENTS .C>)>)
			  (<SET C <OROOM .OBJ>>
			   <PUT .C ,ROBJS (.OBJ !<ROBJS .C>)>
			   <COND (<AND <TRNN .OBJ ,DOORBIT>
				       <SET D <FIND-DOOR .C .OBJ>>>
				  <SET C <GET-DOOR-ROOM .C .D>>
				  <PUT .C ,ROBJS (.OBJ !<ROBJS .C>)>)>)>)>
	     <SET V <REST .V .RECLEN>>)
	    (<RETURN>)>>>

<DEFINE GET-SRUV ()
    <COND (<GASSIGNED? SRUV>
	   <MAPR <>
		 <FUNCTION (X) #DECL ((X) <UVECTOR [REST FIX]>)
			   <PUT .X 1 0>>
		 ,SRUV>
	   ,SRUV)
	  (<BLOAT <+ ,SAVLENGTH 2>>
	   <SETG SRUV <IUVECTOR ,SAVLENGTH 0>>)>>

; "Save the game -- linear sequence of calls to above"

<DEFINE SAVE-GAME (CH "AUX" V VV (C ,CLOCKER) (H ,ROBBER-DEMON)) 
	#DECL ((V VV) <UVECTOR [REST FIX]> (C H) HACK (CH) CHANNEL)
	<SET V <GET-SRUV>>					 ;"Save objects"
	<PUT .V 1 ,SAVE-VERSION>
	<SET V <REST .V>>
	<SET V <UNSAVORY-CODE .V ,OBJECTS ,OBJSVLN ,OSNAMES ,ORECLN>>
								   ;"Save rooms"
	<SET V <UNSAVORY-CODE .V ,ROOMS ,RMSVLN ,RSNAMES ,RRECLN>>
							  ;"Save robber's booty"
	<SET VV <UNSAVORY-CODE .V <HOBJS .H> ,HOBJSVLN '![OID] 1>>
							    ;"Save robber stuff"
	<PUT .VV 1 <SCODE <1 <HROOMS .H>>>>
	<PUT .VV 2 <SCODE <HROOM .H>>>
	<PUT .VV 3 <SCODE <HFLAG .H>>>
	<PUT .VV 4 <COND (<HACTION .H> 1)
			 (0)>>
	<PUT .VV 5 <COND (<HACTION ,SWORD-DEMON> 1)
			 (0)>>
	;"Save clocker"
	<SET VV
	     <UNSAVORY-CODE <REST .VV 5> <HOBJS .C> ,CEVSVLN ,CSNAMES ,CRECLN>>
	<SET V <SET VV <REST .V ,DMNSVLN>>>			 ;"Save winners"
	<MAPF <> <FUNCTION (X) <SET VV <WINSAVE .VV .X>>> ,ACTORS>
	<SET V <REST .V ,ACTSVLN>>	     ;"Save GVALs (MONAD, ROOM, OBJECT)"
	<SET V <SAVE-GVAL .V ,MGVALS ,MGSVLN>>
	<SET V <SAVE-GVAL .V ,RMGVALS ,RMGSVLN>>
	<SET V <SAVE-GVAL .V ,OBJGVALS ,OBJGSVLN>>
	<SAVE-PUZZLE .V>
	<PRINTB <TOP .V> .CH>
	<CLOSE .CH>
	"DONE">

<DEFINE SAVE-PUZZLE (U "AUX" (BUCK 1))
	#DECL ((U) <UVECTOR [REST FIX]> (BUCK) FIX)
	<COND (<==? <LENGTH <TOP .U>> ,SAVLENGTH>
	       <PUT ,CPOBJS ,CPHERE <ROBJS <SFIND-ROOM "CP">>>
	       <SUBSTRUC ,CPUVEC 0 64 .U>
	       <SET U <REST .U 64>>
	       <MAPF <>
		     <FUNCTION (LST)
			       #DECL ((LST) LIST)
			       <MAPF <>
				     <FUNCTION (OBJ)
					       #DECL ((OBJ) OBJECT)
					       <PUT .U 1 <SCODE .OBJ>>
					       <PUT .U 2 .BUCK>
					       <SET U <REST .U 2>>>
				     .LST>
			       <SET BUCK <+ .BUCK 1>>>
		     ,CPOBJS>)>>

<DEFINE RESTORE-PUZZLE (U "AUX" (OBJS ,CPOBJS) WHR)
	#DECL ((U) <UVECTOR [REST FIX]> (OBJS) <UVECTOR [REST LIST]> (WHR) FIX)
	<COND (<==? <LENGTH <TOP .U>> ,SAVLENGTH>
	       <SUBSTRUC .U 0 64 ,CPUVEC>
	       <SET U <REST .U 64>>
	       <MAPR <>
		     <FUNCTION (UVC)
			       #DECL ((UVC) <UVECTOR [REST LIST]>)
			       <PUT .UVC 1 '()>>
		     .OBJS>
	       <REPEAT ()
		     <COND (<0? <1 .U>>
			    <RETURN>)
			   (<PUT .OBJS
				 <SET WHR <2 .U>>
				 (<SDECODE <1 .U> OBJECT> !<NTH .OBJS .WHR>)>)>
		     <SET U <REST .U 2>>>
	       <OR <0? ,CPHERE>
		   <PUT <SFIND-ROOM "CP"> ,ROBJS <NTH ,CPOBJS ,CPHERE>>>)>>

<DEFINE WINSAVE (V W) 
	#DECL ((V) <UVECTOR [REST FIX]> (W) ADV)
	<PUT .V 1 <SCODE <AROOM .W>>>
	<PUT .V 2 <SCODE <ASCORE .W>>>
	<PUT .V 3 <SCODE <AVEHICLE .W>>>
	<PUT .V 4 <SCODE <AOBJ .W>>>
	<PUT .V 5 <SCODE <ASTRENGTH .W>>>
	<UNSAVORY-CODE <REST .V 5> <AOBJS .W> ,WSVLN '![OID!] 1>>

<DEFINE RESTORE-GAME RG (CH "AUX" V VV (H ,ROBBER-DEMON) (C ,CLOCKER)
		      (CSNAMES ,CSNAMES) (CSTYPES ,CSTYPES) (CNT 2))
    #DECL ((CH) CHANNEL (V VV) <UVECTOR [REST FIX]> (C H) HACK
	   (CSNAMES CSTYPES) UVECTOR (CNT) FIX (RG) ACTIVATION)
    <SET V <GET-SRUV>>
    <COND (<READB .V .CH>
	   <COND (<N==? <1 .V> ,SAVE-VERSION>
		  <TELL
		   "ERROR--Save file is incompatible with this version of Dungeon.">
		  <CLOSE .CH>
		  <RETURN <> .RG>)>
	   <SET V <REST .V>>
	   <CLOSE .CH>
	   ; "Clear slots"
	   <MAPF <> <FUNCTION (X) #DECL ((X) OBJECT) <PUT .X ,OCONTENTS ()>> ,OBJECTS>
	   <MAPF <> <FUNCTION (X) #DECL ((X) ROOM) <PUT .X ,ROBJS ()>> ,ROOMS>
    	   ; "Retrieve clocker first!"
	   <PUT .C ,HOBJS
	     <MAPR ,LIST
	       <FUNCTION (UV "AUX" CV)
		 #DECL ((UV) UVECTOR (CV) <OR FALSE CEVENT>)
	         <COND (<0? <SET CNT <MOD <+ .CNT 1> 3>>>
			<COND (<SET CV <SDECODE <1 .UV> CEVENT>>
			       <UNRESTFUL-CODE <REST .UV> .CV
					       <REST .CSNAMES> .CSTYPES>
			       <MAPRET .CV>)
			      (<MAPSTOP>)>)
		       (<MAPRET>)>>
	       <REST .V <+ ,OBJSVLN ,RMSVLN ,HOBJSVLN 5>>>>
	   ; "Get objects"
	   <REST-ITEMS .V <REST ,OSNAMES> ,OSTYPES ,ORECLN OBJECT>
	   ; "Get rooms"
	   <REST-ITEMS <SET V <REST .V ,OBJSVLN>> <REST ,RSNAMES> ,RSTYPES ,RRECLN ROOM>
	   ; "Get robber"
	   <PUT .H ,HOBJS <REST-LIST <SET V <REST .V ,RMSVLN>>>>
	   <SET VV <REST .V ,HOBJSVLN>>
	   <PUT .H ,HROOMS <MEMQ <SDECODE <1 .VV> ROOM> ,ROOMS>>
	   <PUT .H ,HROOM <SDECODE <2 .VV> ROOM>>
	   <PUT .H ,HFLAG <SDECODE <3 .VV> FIX>>
	   <COND (<1? <4 .VV>>
		  <PUT .H ,HACTION <COND (<TYPE? ,ROBBER NOFFSET> ,ROBBER)
					 (ROBBER)>>)
		 (T <PUT .H ,HACTION <>>)>
	   <COND (<1? <5 .VV>>
		  <PUT ,SWORD-DEMON ,HACTION <COND (<TYPE? ,SWORD-GLOW NOFFSET>
						    ,SWORD-GLOW)
						   (SWORD-GLOW)>>)>
	   <SET V <SET VV <REST .V ,DMNSVLN>>>
	   ; "Get winner"
	   <MAPF <> <FUNCTION (X) #DECL ((X) ADV) <SET VV <WINREST .VV .X>>> ,ACTORS>
	   <SET V <REST .V ,ACTSVLN>>
	   ; "Get GVALS"
	   <SET V <REST-GVAL .V ,MGVALS ,MGSVLN FIX>>
	   <SET V <REST-GVAL .V ,RMGVALS ,RMGSVLN ROOM>>
	   <SET V <REST-GVAL .V  ,OBJGVALS ,OBJGSVLN OBJECT>>
	   <RESTORE-PUZZLE .V>
	   "DONE")>>
	  
<DEFINE WINREST (V W "AUX" T) 
	#DECL ((V) <UVECTOR [REST FIX]> (W) ADV (T) OBJECT)
	<PUT .W ,AROOM <SDECODE <1 .V> ROOM>>
	<PUT .W ,ASCORE <SDECODE <2 .V> FIX>>
	<PUT .W ,AVEHICLE <SDECODE <3 .V> OBJECT>>
	<PUT .W ,AOBJ <OPUT <SET T <SDECODE <4 .V> OBJECT>> OACTOR .W>>
	<PUT .W ,ASTRENGTH <SDECODE <5 .V> FIX>>
	<PUT .W ,AOBJS <REST-LIST <SET V <REST .V 5>>>>
	<REST .V ,WSVLN>>

<GDECL (OFIXUPS) <VECTOR [REST OBJECT ATOM ATOM]>>
