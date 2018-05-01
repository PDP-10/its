<NEWTYPE PSTRING WORD>
;"A PSTRING is a 36-bit string containing 5 characters of 7 bits.  This is of course grossly PDP-10 specific, but easily fakeable provided WORD is at least 35 bits"
<DEFINE PSTRING (INSTR "AUX" (BP 36) (OBJ #PSTRING 0))
   <MAPF <> 
      <FUNCTION (CH) 
	     <COND (<G? <SET BP <- .BP 7>> 0>
            <SET OBJ <CHTYPE <PUTBITS .OBJ <BITS 7 .BP> <ASCII .CH>> PSTRING>>)
            (T <MAPLEAVE .OBJ>)
         >
      >
      .INSTR>
>

; STRINGP converts a PSTRING to a STRING
<DEFINE STRINGP (OBJ "AUX" (BP 36) C) 
   <MAPF ,STRING
    <FUNCTION () 
	    <COND (<G? <SET BP <- .BP 7>> 0>
		   <COND (<N==? <SET C <CHTYPE <GETBITS .OBJ <BITS 7 .BP>> FIX>>
				0>
			  <MAPRET <ASCII .C>>) 
                 (T <MAPRET>)>)
		  (T <MAPSTOP>)>>>>


;"F1 upper 18 bits are length to print (from S1?), if not zero"
<DEFINE	TELL(S1 "OPTIONAL" (F1 ,POST-CRLF) S2 S3 "AUX" L)
   #DECL ("VALUE" ATOM <PRIMTYPE STRING> "OPTIONAL" FIX
		  <OR STRING FALSE> <OR STRING FALSE>)
   <AND <NOT <0? <CHTYPE <ANDB .F1 ,PRE-CRLF> FIX>>> <CRLF>>
   <SET L <CHTYPE <GETBITS .F1 <BITS 18 18>> FIX>>
   <AND <0? .L> <SET L <LENGTH .S1>>>
   <PRINTSTRING .S1 .OUTCHAN .L>
   <AND <ASSIGNED? S2> <PRINTSTRING .S2>>
   <AND <ASSIGNED? S3> <PRINTSTRING .S3>>
   <AND <NOT <0? <CHTYPE <ANDB .F1 ,POST-CRLF> FIX>>> <CRLF>>
   <SETG TELL-FLAG T>
>

; Read a line after printing the prompt
; ALT means accept only alternate terminator character
; (ALT not supported yet)
<DEFINE READST (INBUF PROMPT ALT)
   <PRINC .PROMPT>
   <PRINC !\ >
   <READSTRING .INBUF .INCHAN %<STRING <ASCII 10>> >
>

;"A DSKDATE contains
Time in half-seconds in 0-17
day of month ( 1-31) in 5 bits at bit 18
month number ( 1-12) in 4 bits at bit 23
year of century      in 7 bits at bit 27
(Yes, it's not Y2K safe)"
;"It's not necessary to do all the sets, but nesting putbits calls will
make my head hurt a lot -- MTR"
<DEFINE DSKDATE ("AUX" (DVEC <GETTIMEDATE>) (W #WORD 0) TM)
  <SET W <PUTBITS .W <BITS 18 0> <+ </ <7 .DVEC> 500000> <* <1 .DVEC> 2> <* <2 .DVEC> 120> <* <3 .DVEC> 7200>>>>
  <SET W <PUTBITS .W <BITS 7 27> <MOD <6 .DVEC> 100>>>  ;"Year"
  <SET W <PUTBITS .W <BITS 4 23> <5 .DVEC>>>  ;"Month"
  <SET W <PUTBITS .W <BITS 5 18> <4 .DVEC>>>  ;"Day of Month"
>

; "ATMFIX takes the atom, gets the first 36 bits of the PNAME (as with PSTRING), does some bit manipulation on it and on the value of SRUNM (the user name), and returns the result as a fix.  Probably intended to prevent save file sharing
ATMFIX may also be passed a PSTRING, in which case it does the same bit
manipulation as it would on an atom PNAME
The bit manipulation rests on the assumption that the top two bits of a character
are never both set (no lowercase or a few other symbols)"

<DEFINE ATMFIX (A)
   <COND 
      (<TYPE? .A ATOM> <ATMFIX1 <PSTRING <PNAME .A>>>)
      (ELSE <ATMFIX1 .A>)
   >
>

<DEFINE ATMFIX1 (PNW "AUX" (MSK *402010040200*)) 
   <CHTYPE <XORB <ORB <LSH <ANDB .PNW .MSK> -1> .PNW> <PSTRING ,SRUNM>> FIX>
>

; "FIXSTR is the inverse of ATMFIX.  It takes a FIX and returns a STRING
   which is the PNAME of the ATOM which was previously given to ATMFIX."
<DEFINE FIXSTR (F "AUX" PNW (MSK *402010040200*)) 
;"Missing is the <XOR ... <PNAME ,SRUNM>>, applied to .F before the below"
   <SET F <XORB <PSTRING ,SRUNM> .F>>
   <STRINGP <ANDB <XORB <LSH <ANDB .F .MSK> -1> <EQVB>> .F>>
>

<DEFINE WINDOW-YEAR (Y)
   <COND (<G=? .Y 75> <+ 1900 .Y>) (T <+ 2000 .Y>)>
>

<DEFINE GXUNAME () "MTRZORK">
<SETG XUNM "MTRZORK">
<SETG SCRIPT-CHANNEL <>>

<DEFINE STARTER () 1>

<DEFINE GETSYS () <> >

<DEFINE TTY-INIT (ARG) T>

<DEFINE TTY-UNINIT () T>

<DEFINE EXCRUCIATINGLY-UNTASTEFUL-CODE () <> > ;"I don't know what this is supposed to do"

<DEFINE CTRL-S () <>> ;"Interrupt handler -- not implemented"

<SETG STACKDUMP-ATOMS-TO-SKIP '(COND REPEAT PROG BIND AND OR * + /)>
<DEFINE STACKDUMP ("OPT" (CF <FFRAME>))
   <REPEAT ()
      <COND (<NOT <MEMQ <FUNCT .CF> ,STACKDUMP-ATOMS-TO-SKIP>>
         <PRINT <FUNCT .CF>>
         <PRINT <ARGS .CF>>)
      >
      <AND <=? <FUNCT .CF> TOPLEVEL!-> <CRLF> <RETURN>>
      <SET CF <FFRAME .CF>>
   >
>
    
<DEFINE GET-NAME ("OPTIONAL" (CHAN .OUTCHAN))
   <STRING <10 .CHAN> <7 .CHAN>
     <COND (<EMPTY? <8 .CHAN>> "") (T <STRING !\. <8 .CHAN>>)>
   >
>

;" Dispatch -- runs a thing, possibly with an argument"
<DEFINE DISPATCH (NO "OPT" OV) 
	<COND (<TYPE? .NO FUNCTION SUBR>
               <COND (<AND <ASSIGNED? OV> .OV> <APPLY .NO .OV>)
                     (ELSE <APPLY .NO >)
               >)
              (ELSE <ERROR "Wrong dispatch type" <TYPE .NO> .NO>)
         >
>

<AND <NOT <GASSIGNED? NULL>> <SETG NULL <INSERT <ATOM ""> <ROOT>>>> ;",NULL is an atom with a name containing a single rubout in real MDL.  Here it's a totally empty atom (which probably isn't legal in real mdl) "
""
