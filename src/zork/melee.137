
"
0 -- attacker misses
1 -- defender unconscious
2 -- defender dead
3 -- defender lightly wounded
4 -- defender seriously wounded
5 -- staggered
6 -- loses weapon
7 -- hesitate (miss on free swing)
8 -- sitting duck (crunch!)
"

<MSETG MISSED 0>

<MSETG UNCONSCIOUS 1>

<MSETG KILLED 2>

<MSETG LIGHT-WOUND 3>

<MSETG SERIOUS-WOUND 4>

<MSETG STAGGER 5>

<MSETG LOSE-WEAPON 6>

<MSETG HESITATE 7>

<MSETG SITTING-DUCK 8>

<SETG STRENGTH-MAX 7>

<SETG STRENGTH-MIN 2>

<SETG CURE-WAIT 30>

<GDECL (DEF1-RES DEF2-RES DEF3-RES)
       <UVECTOR [REST UVECTOR]>
       (DEF1 DEF2A DEF2B DEF3A DEF3B DEF3C)
       <UVECTOR [REST FIX]>
       (OPPV) VECTOR
       (VILLAINS) <LIST [REST OBJECT]>
       (VILLAIN-PROBS) <UVECTOR [REST FIX]>
       (STRENGTH-MIN STRENGTH-MAX CURE-WAIT) FIX>


<DEFINE FIGHTING (FROB "AUX" (HERE ,HERE) (OPPS ,OPPV) (HERO ,PLAYER) (FIGHT? <>)
		  RANDOM-ACTION (THIEF <SFIND-OBJ "THIEF">)) 
	#DECL ((FROB) HACK (OPPS) <VECTOR [REST <OR OBJECT FALSE>]> (HERO) ADV
	       (HERE) ROOM (FIGHT?) <OR ATOM FALSE> (THIEF) OBJECT
	       (RANDOM-ACTION) <OR ATOM NOFFSET FALSE>)
      <COND
       (<AND ,PARSE-WON <NOT ,DEAD!-FLAG>>
	<MAPR <>
	      <FUNCTION (OO OV VOUT "AUX" (O <1 .OO>) (S <OSTRENGTH .O>))
		      #DECL ((OO) <LIST [REST OBJECT]> (OV) VECTOR
			     (VOUT) <UVECTOR [REST FIX]> (O) OBJECT (S) FIX)
		      <PUT .OV 1 <>>
		      <SET RANDOM-ACTION <OACTION .O>>
		      <COND (<==? .HERE <OROOM .O>>
			     <COND (<AND <==? .O .THIEF>
					 ,THIEF-ENGROSSED!-FLAG>
				    <SETG THIEF-ENGROSSED!-FLAG <>>)
				   (<L? .S 0>
				    <COND (<AND <NOT <0? <1 .VOUT>>>
						<PROB <1 .VOUT>
						      </ <+ <1 .VOUT> 100> 2>>>
					   <OSTRENGTH .O <- .S>>
					   <PUT .VOUT 1 0>
					   <AND .RANDOM-ACTION
						<PERFORM .RANDOM-ACTION
							 <FIND-VERB "IN!">>>)
					  (<PUT .VOUT 1 <+ <1 .VOUT> 10>>)>)
				   (<TRNN .O ,FIGHTBIT>
				    <SET FIGHT? T>
				    <PUT .OV 1 .O>)
				   (.RANDOM-ACTION
				    <COND (<PERFORM .RANDOM-ACTION <FIND-VERB "1ST?">>
					   <SET FIGHT? T>
					   <TRO .O ,FIGHTBIT>
					   <SETG PARSE-CONT <>>
					   <PUT .OV 1 .O>)>)>)
			    (<N==? .HERE <OROOM .O>>
			     <COND (<TRNN .O ,FIGHTBIT>
				    <COND (.RANDOM-ACTION
					   <PERFORM .RANDOM-ACTION <FIND-VERB "FGHT?">>)>)>
			     <AND <==? .O .THIEF>
				  <SETG THIEF-ENGROSSED!-FLAG <>>>
			     <ATRZ .HERO ,ASTAGGERED>
			     <TRZ .O ,STAGGERED>
			     <TRZ .O ,FIGHTBIT>
			     <COND (<L? .S 0>
				    <OSTRENGTH .O <- .S>>
				    <COND (.RANDOM-ACTION
					   <PERFORM .RANDOM-ACTION <FIND-VERB "IN!">>)>)>)>>
	      ,VILLAINS
	      .OPPS
	      ,VILLAIN-PROBS>
	<COND (.FIGHT?
	       <CLOCK-INT ,CURIN>
	       <REPEAT ((OUT <>) RES)
		#DECL ((OUT) <OR FIX FALSE> (RES) <OR FIX FALSE>)
		<COND (<MAPF <>
			     <FUNCTION (O) 
				  #DECL ((O) <OR OBJECT FALSE>)
				  <COND (<NOT .O>)
					(<AND <SET RANDOM-ACTION <OACTION .O>>
					      <PERFORM .RANDOM-ACTION <FIND-VERB "FGHT?">>>)
					(<NOT <SET RES
						   <BLOW .HERO .O <OFMSGS .O> <> .OUT>>>
					 <MAPLEAVE <>>)
					(<==? .RES ,UNCONSCIOUS>
					 <SET OUT <+ 2 <MOD <RANDOM> 3>>>)
					(T)>>
			     .OPPS>
		       <COND (<NOT .OUT> <RETURN>)
			     (<0? <SET OUT <- .OUT 1>>> <RETURN>)>)
		      (ELSE <RETURN>)>>)>)>>

<DEFINE PRES (TAB A D W "AUX" (L <LENGTH .TAB>))
	#DECL ((TAB) <UVECTOR [REST VECTOR]> (A D) STRING
	       (W) <OR STRING FALSE>)
	<MAPF <>
	      <FUNCTION (S)
		<COND (<TYPE? .S STRING> <TELL .S 0>)
		      (<TYPE? .S ATOM>
		       <COND (<==? .S A> <TELL .A 0>)
			     (<==? .S D> <TELL .D 0>)
			     (<AND .W <==? .S W>> <TELL .W 0>)>)>>
	      <NTH .TAB <+ 1 <MOD <RANDOM> .L>>>>
	<TELL "" 1>>

"The <MAX 1 ...> is strictly a patch, to keep the thing from dying.  I doubt
it's the right thing.--taa"
"It wasn't."

<DEFINE FIGHT-STRENGTH (HERO "OPTIONAL" (ADJUST? T)
			"AUX" S (SMAX ,STRENGTH-MAX) (SMIN ,STRENGTH-MIN))
	#DECL ((HERO) ADV (S SMAX SMIN VALUE) FIX (ADJUST?) <OR ATOM FALSE>)
	<SET S
	     <+ .SMIN
		<FIX <+ .5
			<* <- .SMAX .SMIN>
			   </ <FLOAT <ASCORE .HERO>>
			      <FLOAT ,SCORE-MAX>>>>>>>
	<COND (.ADJUST? <+ .S <ASTRENGTH .HERO>>)(ELSE .S)>>

<DEFINE VILLAIN-STRENGTH (VILLAIN
			  "AUX"  (OD <OSTRENGTH .VILLAIN>) WV)
	#DECL ((VILLAIN) OBJECT (WV) <OR FALSE VECTOR>
	       (OD VALUE) FIX)
	<COND (<G=? .OD 0>
	       <COND (<AND <==? .VILLAIN <SFIND-OBJ "THIEF">>
			   ,THIEF-ENGROSSED!-FLAG>
		      <SET OD <MIN .OD 2>>
		      <SETG THIEF-ENGROSSED!-FLAG <>>)>
	       <COND (<AND <NOT <EMPTY? <PRSI>>>
			   <TRNN <PRSI> ,WEAPONBIT>
			   <SET WV <MEMQ .VILLAIN ,BEST-WEAPONS>>
			   <==? <2 .WV> <PRSI>>>
		      <SET OD <MAX 1 <- .OD <3 .WV>>>>)>)>
	.OD>

<GDECL (CURIN) CEVENT (BEST-WEAPONS) <VECTOR [REST OBJECT OBJECT FIX]>>

<DEFINE BLOW (HERO VILLAIN REMARKS HERO? OUT?
	      "AUX" DWEAPON (VDESC <ODESC2 .VILLAIN>) ATT DEF OA OD TBL RES
	      NWEAPON RANDOM-ACTION)
	#DECL ((HERO) ADV (VILLAIN) OBJECT (DWEAPON NWEAPON) <OR OBJECT FALSE>
	       (RES OA OD ATT DEF FIX) FIX (REMARKS) <UVECTOR [REST UVECTOR]>
	       (HERO?) <OR ATOM FALSE> (VDESC) STRING (TBL) <UVECTOR [REST FIX]>
	       (OUT?) <OR FIX FALSE> (RANDOM-ACTION) <OR ATOM FALSE NOFFSET>)
	<PROG ()
	      <COND (.HERO?
		     <TRO .VILLAIN ,FIGHTBIT>
		     <COND (<ATRNN .HERO ,ASTAGGERED>
			    <TELL 
"You are still recovering from that last blow, so your attack is
ineffective.">
			    <ATRZ .HERO ,ASTAGGERED>
			    <RETURN>)>
		     <SET OA <SET ATT <MAX 1 <FIGHT-STRENGTH .HERO>>>>
		     <COND (<0? <SET OD <SET DEF <VILLAIN-STRENGTH .VILLAIN>>>>
			    <COND (<==? .VILLAIN <SFIND-OBJ "#####">>
				   <RETURN <JIGS-UP
"Well, you really did it that time.  Is suicide painless?">>)>
			    <TELL "Attacking the " 1 .VDESC " is pointless.">
			    <RETURN>)>
		     <SET DWEAPON
			  <AND <NOT <EMPTY? <OCONTENTS .VILLAIN>>>
			       <1 <OCONTENTS .VILLAIN>>>>)
		    (ELSE
		     <SETG PARSE-CONT <>>
		     <COND (<ATRNN .HERO ,ASTAGGERED> <ATRZ .HERO ,ASTAGGERED>)>
		     <COND (<TRNN .VILLAIN ,STAGGERED>
			    <TELL "The "
				  1
				  .VDESC
				  " slowly regains his feet.">
			    <TRZ .VILLAIN ,STAGGERED>
			    <RETURN 0>)>
		     <SET OA <SET ATT <VILLAIN-STRENGTH .VILLAIN>>>
		     <COND (<L=? <SET DEF <FIGHT-STRENGTH .HERO>> 0> <RETURN>)>
		     <SET OD <FIGHT-STRENGTH .HERO <>>>
		     <SET DWEAPON <FWIM ,WEAPONBIT <AOBJS .HERO> T>>)>
	      <COND (<L? .DEF 0>
		     <COND (.HERO?
			    <TELL "The unconscious " 1 .VDESC
				  " cannot defend himself:  He dies.">)>
		     <SET RES ,KILLED>)
		    (ELSE
		     <COND (<1? .DEF>
			    <COND (<G? .ATT 2> <SET ATT 3>)>
			    <SET TBL <NTH ,DEF1-RES .ATT>>)
			   (<==? .DEF 2>
			    <COND (<G? .ATT 3> <SET ATT 4>)>
			    <SET TBL <NTH ,DEF2-RES .ATT>>)
			   (<G? .DEF 2>
			    <SET ATT <- .ATT .DEF>>
			    <COND (<L? .ATT -1> <SET ATT -2>)
				  (<G? .ATT 1> <SET ATT 2>)>
			    <SET TBL <NTH ,DEF3-RES <+ .ATT 3>>>)>
		     <SET RES <NTH .TBL <+ 1 <MOD <RANDOM> 9>>>>
		     <COND (.OUT?
			    <COND (<==? .RES ,STAGGER> <SET RES ,HESITATE>)
				  (ELSE <SET RES ,SITTING-DUCK>)>)>
		     <COND (<AND <==? .RES ,STAGGER>
				 .DWEAPON
				 <PROB 25 <COND (.HERO? 10)(ELSE 50)>>>
			    <SET RES ,LOSE-WEAPON>)>
		     <PRES <NTH .REMARKS <+ .RES 1>>
			   <COND (.HERO? "Adventurer") (ELSE .VDESC)>
			   <COND (.HERO? .VDESC) (ELSE "Adventurer")>
			   <AND .DWEAPON <ODESC2 .DWEAPON>>>)>
	      <COND (<OR <==? .RES ,MISSED> <==? .RES ,HESITATE>>)
		    (<==? .RES ,UNCONSCIOUS>
		     <COND (.HERO? <SET DEF <- .DEF>>)>)
		    (<OR <==? .RES ,KILLED> <==? .RES ,SITTING-DUCK>> <SET DEF 0>)
		    (<==? .RES ,LIGHT-WOUND> <SET DEF <MAX 0 <- .DEF 1>>>)
		    (<==? .RES ,SERIOUS-WOUND> <SET DEF <MAX 0 <- .DEF 2>>>)
		    (<==? .RES ,STAGGER>
		     <COND (.HERO? <TRO .VILLAIN ,STAGGERED>)
			   (ELSE <ATRO .HERO ,ASTAGGERED>)>)
		    (<AND <==? .RES ,LOSE-WEAPON> .DWEAPON>
		     <COND (.HERO?
			    <REMOVE-OBJECT .DWEAPON>
			    <INSERT-OBJECT .DWEAPON ,HERE>)
			   (ELSE
			    <DROP-OBJECT .DWEAPON .HERO>
			    <INSERT-OBJECT .DWEAPON ,HERE>
			    <COND (<SET NWEAPON <FWIM ,WEAPONBIT <AOBJS .HERO> T>>
				   <TELL
"Fortunately, you still have a " 1 <ODESC2 .NWEAPON> ".">)>)>)
		    (ELSE <ERROR MELEE "CHOMPS" .RES .HERO? .ATT .DEF .TBL>)>
	      <COND (<NOT .HERO?>
		     <PUT .HERO ,ASTRENGTH <COND (<0? .DEF> -10000)(<- .DEF .OD>)>>
		     <COND (<L? <- .DEF .OD> 0>
			    <CLOCK-ENABLE ,CURIN>
			    <PUT ,CURIN ,CTICK ,CURE-WAIT>)>
		     <COND (<L=? <FIGHT-STRENGTH .HERO> 0>
			    <PUT .HERO ,ASTRENGTH <+ 1 <- <FIGHT-STRENGTH .HERO <>>>>>
			    <JIGS-UP 
"It appears that that last blow was too much for you.  I'm afraid you
are dead.">
			    <>)
			   (.RES)>)
		    (ELSE
		     <OSTRENGTH .VILLAIN .DEF>
		     <COND (<0? .DEF>
			    <TRZ .VILLAIN ,FIGHTBIT>
			    <TELL
"Almost as soon as the " ,LONG-TELL .VDESC " breathes his last breath, a cloud
of sinister black fog envelops him, and when the fog lifts, the
carcass has disappeared.">
			    <REMOVE-OBJECT .VILLAIN>
			    <COND (<SET RANDOM-ACTION <OACTION .VILLAIN>>
				   <PERFORM .RANDOM-ACTION <FIND-VERB "DEAD!">>)>
			    <TELL "">
			    .RES)
			   (<==? .RES ,UNCONSCIOUS>
			    <COND (<SET RANDOM-ACTION <OACTION .VILLAIN>>
				   <PERFORM .RANDOM-ACTION <FIND-VERB "OUT!">>)>
			    .RES)
			   (.RES)>)>>>

<DEFINE WINNING? (V H "AUX" (VS <OSTRENGTH .V>) (PS <- .VS <FIGHT-STRENGTH .H>>))
	#DECL ((V) OBJECT (H) ADV (VS PS) FIX)
	<COND (<G? .PS 3> <PROB 90 100>)
	      (<G? .PS 0> <PROB 75 85>)
	      (<0? .PS> <PROB 50 30>)
	      (<G? .VS 1> <PROB 25>)
	      (ELSE <PROB 10 0>)>> 

<DEFINE CURE-CLOCK ("AUX" (HERO ,PLAYER) (S <ASTRENGTH .HERO>) (I ,CURIN))
	#DECL ((HERO) ADV (S) FIX (I) CEVENT)
	<COND (<G? .S 0> <PUT .HERO ,ASTRENGTH <SET S 0>>)
	      (<L? .S 0> <PUT .HERO ,ASTRENGTH <SET S <+ .S 1>>>)>
	<COND (<L? .S 0> <PUT .I ,CTICK ,CURE-WAIT>)
	      (ELSE <CLOCK-DISABLE .I>)>>

<DEFINE DIAGNOSE ("AUX" (W ,WINNER) (MS <FIGHT-STRENGTH .W <>>)
			(WD <ASTRENGTH .W>) (RS <+ .MS .WD>) (I <CTICK ,CURIN>))
	#DECL ((W) ADV (MS WD RD I) FIX)
	<COND (<NOT <CFLAG ,CURIN>>
	       <SET WD 0>)
	      (<SET WD <- .WD>>)>
	<COND (<0? .WD> <TELL "You are in perfect health.">)
	      (<1? .WD> <TELL "You have a light wound," 0>)
	      (<==? .WD 2> <TELL "You have a serious wound," 0>)
	      (<==? .WD 3> <TELL "You have several wounds," 0>)
	      (<G? .WD 3> <TELL "You have serious wounds," 0>)>
	<COND (<NOT <0? .WD>>
	       <TELL " which will be cured after " 0>
	       <PRINC <+ <* ,CURE-WAIT <- .WD 1>> .I>>
	       <TELL " moves.">)>
	<COND (<0? .RS> <TELL "You are at death's door.">)
	      (<1? .RS> <TELL "You can be killed by one more light wound.">)
	      (<==? .RS 2> <TELL "You can be killed by a serious wound.">)
	      (<==? .RS 3> <TELL "You can survive one serious wound.">)
	      (<G? .RS 3> <TELL "You are strong enough to take several wounds.">)>
	<COND (<NOT <0? ,DEATHS>>
	       <TELL "You have been killed " 1 <COND (<1? ,DEATHS> "once.")
						     (T "twice.")>>)>>
