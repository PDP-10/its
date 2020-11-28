<DEFINE MIGSINIT ()
	<COND (<0? .MIGS-INIT-COUNT> "OK")
	      ("ELSE" <L-UNUSE "MIGSMN"> <L-UNUSE "DISPLA">
		      <SET A ,TRMTYP!-MIGS >
		      <COND (<=? .A !\T> <L-UNUSE "MTPRIM">)
			    (<=? .A !\A> <L-UNUSE "MAPRIM">)
			    (<=? .A !\G> <L-UNUSE "MGPRIM">)
			    (<=? .A !\P> <L-UNUSE "MTPRIM">)>)>
	<SET MIGS-INIT-COUNT <+ 1 .MIGS-INIT-COUNT>>
	<RESET .INCHAN>
	<SET REDEFINE T>
	<GC-MON <>>
	<PRINC 
"
Muddle Interactive Graphics System
Enter terminal code or 'H' (help):">
	<PRINC <REPEAT (A)
		       <SET A <TYI .INCHAN>>
		       <SETG TRMTYP!-MIGS .A>
		       <TERPRI>
		       <COND (<==? .A !\T>
			      <SETG PHYCEN!-MIGS (512 512)>
			      <USE "MTPRIM">
			      <RETURN " TEKTRONIX PRIMITIVES LOADED">)
			     (<==? .A !\A>
			      <SETG PHYCEN!-MIGS (0 0)>
			      <USE "MAPRIM">
			      <RETURN " ARDS PRIMITIVES LOADED">)
			     (<==? .A !\I>
			      <SETG PHYCEN!-MIGS (0 0)>
			      <USE "MAPRIM">
			      <RETURN " IMLAC PRIMITIVES LOADED">)
			     (<==? .A !\G>
			      <USE "MGPRIM">
			      <RETURN " GT42 PRIMITIVES LOADED">)
			     (<==? .A !\P>
			      <USE "HPTEK">
			      <EVAL <PARSE "<HPTON>">>
			      <SETG TRMTYP!-MIGS <SET A !\T>>
			      <USE "MTPRIM">
			      <RETURN "HP-TEK MODE. TEK PRIMITIVES LOADED">)
			     (<==? .A !\H>
			      <PRINC "ENTER YOUR TERMINAL TYPE THEN TYPE ">
			      <PRINC "<MIGSHELP>$ FOR HELP. $ IS <-ESC->">
			      <TERPRI>
			      <PRINC "TERMINALS ARE : A FOR ARDS & IMLACS">
			      <PRINC ", G FOR GT42'S, T FOR TEKTRONIX">
			      <TERPRI>
			      <PRINC "P IS FOR HP-2648'S ">
			      <TERPRI>
			      <PRINC "IDENTIFY YOUR TERMINAL :">)
			     (ELSE <PRINC "INVALID ENTRY! TRY AGAIN :">)>>>
	<USE "MIGSMN">
	<TERPRI>
       <USE "DISPLA">
       <TERPRI>
	<PRINC "
MIGS LOADED
">
	<SET REDEFINE <>>
	,NULL>
