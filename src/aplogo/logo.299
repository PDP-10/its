.NLIST SEQ
.ENABL LC
.TITLE MIT LOGO

;  Logo Language Interpreter for the Apple-II-Plus Personal Microcomputer

;  Written and developed by Stephen L. Hain, Patrick G. Sobalvarro, and
;  Leigh L. Klotz with the M.I.T. Logo Group under the supervision of Hal
;  Abelson at the Massachusetts Institute of Technology.

;  Property of the M.I.T. Logo Laboratory,
;  545 Technology Square, Cambridge, MA 02139.
;  Copyright (C) 1980 Massachusetts Institute of Technology
;  All rights reserved.

;  This version of the Logo Language Interpreter requires an Apple-II-Plus
;  microcomputer with the Autostart ROM monitor, a full 48 kilobytes of
;  random access memory, a floppy disk, and the Apple Language System card.

GRPINC	=1	;Nonzero means include graphics.
MUSINC	=0	;Nonzero means include music.
.PAGE
.SBTTL	Assembly Data
.SBTTL		Page Zero Variables

LNIL	= $00	;The nil node
PRECED	= $04	;Current function's precedence
NARGS	= $05	;No. of arguments for current function
EXPOUT	= $06	;Output expected if nonzero
OTPUTN	= $07	;Output given if nonzero
DEFFLG	= $08	;Defining a ufun if nonzero
RUNFLG	= $09	;Evaluating RUN or REPEAT if nonzero
STPFLG	= $0A	;Stop executing current ufun if nonzero
COFLAG	= $0B	;Return from current break-loop (CONTINUE) if nonzero
FUNTYP	= $0C	;Typecode of current function (ufun or sfun)
UFRMAT	= $0D	;Format (list or fpack) of current ufun
ERRNUM	= $0E	;Error code of last error
COLNUM	= $0F	;Graphics, current line color number
GCFLG	= $10	;If positive, doing a garbage collect.  For gc unwind protect.
;$11 -- free.
;ERRRET	= $10	;Pointer to "unwind-protect" routine vectored to early in error handler.
SP	= $12	;Stack pointer
VSP	= $14	;Value-stack pointer
SIZE1	= $16	;Size of area pointed to by AREA1
SIZE2	= $18	;Size of area pointed to by AREA2
AREA1	= $1A	;Pointer to g.c.-protected area of SIZE1 contiguous nodes
AREA2	= $1C	;Pointer to g.c.-protected area of SIZE2 contiguous nodes
NNODES	= $1E	;Number of nodes allocated
;	Monitor variables:
WNDLFT	= $20	;Left column of text window (0-$37)
WNDWTH	= $21	;Width of text window (1-$28)
WNDTOP	= $22	;Top line of text window (0-$17)
WNDBTM	= $23	;Length of text window (1-$18)
CH	= $24	;Cursor column number
CV	= $25	;Cursor line number
;	DOS wants $26,$27
BASLIN	= $28	;Cursor line memory pointer
;	DOS wants $2A,$2B,$2C,$2D,$2E,$2F
BSLTMP	= $2A	;I/O temp. var.
HMASK	= $30	;Graphics, bit mask
HNDX	= $31	;Graphics, index variable
INVFLG	= $32	;Character output mask (flash, invert, normal)
;	DOS wants $33
DOSFL1	= $33	;DOS parameter #1
PALETN	= $34	;Graphics, current palette number
;	DOS wants $35,$36,$37,$38,$39
YSAV1	= $35	;Temp. Y reg. storage
OTPDEV	= $36	;Output device driver address
INPDEV	= $38	;Input device driver address
TSHOWN	= $3A	;Graphics, Turtle shown if nonzero
IFTEST	= $3B	;Local TEST pointer (TRUE if zero)
PLINE	= $3C	;Input line character pointer for parser
;	DOS wants $3E,$3F,$40,$41,$42,$43,$44,$45,$46,$47,$48
;	(Don't modify $3E,$3F)
A1L	= $40	;Temp. var.
A1H	= $41	;Temp. var.
A2L	= $42	;Temp. var.
A2H	= $43	;Temp. var.
A3L	= $44	;Temp. var.
A4L	= $46	;Temp. var.
A5L	= $48	;Temp. var.
;	DOS wants $4A,$4B,$4C,$4D
SHAPE	= $4A	;Graphics, shape address
RNDL	= $4C	;Random no. seed (low)
RNDH	= $4D	;Random no. seed (high)
CHBUFR	= $4E	;Character buffer next-char-to-read pointer
CHBUFS	= $4F	;Character buffer next-free-loc pointer
LTRUE	= $50	;TRUE atom pointer
LFALSE	= $52	;FALSE atom pointer
RANDOM	= $54	;Random number
PRSFLG	= $56	;Indicates the parser is executing, for CONS
INPFLG	= $57	;Nonzero means evaluating from the edit buffer
OTPFLG	= $58	;Nonzero means print-to-buffer mode
SOBLST	= $59	;Pointer to start of System Object List
SOBTOP	= $5B	;Pointer to end of System Object List
SFSTCH	= $5D	;pointer to first char on screen
SLSTCH	= $5F	;pointer to char after last char on screen
FRLIST	= $61	;Pointer to start of Freelist
BRKSP	= $63	;pointer to last break-frame
CURTOK	= $65	;Curent Token pointer
NEXTOK	= $67	;Next Token pointer
FUNCT	= $69	;Points to current Function
IFLEVL	= $6B	;IF nesting level
BKTFLG	= $6C	;0 means PRINT acts normally. 1 means print [] on lists and '' on pnames.
FRAME	= $6D	;Pointer to current stack frame
XFRAME	= $6F	;Pointer to end of current stack frame
FBODY	= $71	;Pointer to full body of current Ufun
FBODY1	= $73	;Current ufun body or system function index
FPTR	= $75	;Pointer to remainder of Ufun being executed
GOPTR	= $77	;Pointer to location of Ufun line to GO to
ULNEND	= $79	;Pointer to end of current line of Fpack Ufun
LEVNUM	= $7B	;Ufun nesting level
NEST	= $7D	;EVAL nesting of current EVLINE
;7E IS FREE.
;	DOS wants $7F
DOSFL2	= $7F	;DOS parameter #2
TLLEVS	= $80	;Number of tail recursions included in LEVNUM
DEFATM	= $82	;Pointer to atom of Ufun currently being edited
MARK1	= $84	;G.C.-protected ptr.
MARK2	= $86	;G.C.-protected ptr.
MARK3	= $88	;G.C.-protected ptr.
MARK4	= $8A	;G.C.-protected ptr.
DEFBOD	= $8C	;Pointer to body of ufun currently being defined
UNSUM	= $8E	;Unary Sum pointer
UNDIF	= $90	;Unary Difference pointer
TOKPTR	= $92	;Token list Pointer
OBLIST	= $94	;Pointer to Oblist
PODEFL	= $96	;Default ufun atom
TRACE	= $98	;Trace mode if nonzero
GRPHCS	= $99	;Indicates graphics mode if negative
NPARTS	= $99	;Indicates number of voices for music (same location as GRPHCS)
EPOINT	= $9A	;Editor point
ENDBUF	= $9C	;Location after last character in edit buffer
ARG2	= $9E	;Primitive's second argument ptr.
NARG2	= $9E	;Fix/flonum temp.
ARG1	= $A2	;Primitive's first argument ptr.
NARG1	= $A2	;Fix/flonum temp.
;Be sure there is enough room for these if you add one.  Look at TMPTAB.
TEMPNH	= $A6	;Temp. var. (first swapped; must follow NARG1 for flt. pt. routines)
TEMPN	= $A8	;Temp. var.
TEMPN1	= $AA	;Temp. var. (must follow TEMPN for XDIVID,SRANDM routines)
TEMPN2	= $AC	;Temp. var. (must follow TEMPN1)
TEMPN3	= $AE	;Temp. var.
TEMPN4	= $B0	;Temp. var. (must follow TEMPN4)
ANSN	= $B2	;Temp. var.
ANSN1	= $B3	;Temp. var.
TEMPN5	= $B4	;Temp. var. (last swapped)
;
TEMPN6	= $B6	;Temp. var. (must follow TEMPN5)
TEMPN7	= $B8	;Temp. var.
TEMPN8	= $BA	;Temp. var. (must follow TEMPN7)
TEMPX1	= $BC	;Temp. var.
TEMPX2	= $BE	;Temp. var. (must follow TEMPX1)
TEMPX3	= $C0	;Temp. var.
ANSN2	= $C2	;Temp. var.
ANSN3	= $C3	;Temp. var.
ANSN4	= $C4	;Temp. var.
PNCOLR	= $C5	;Graphics, current line color
XCOR	= $C6	;Graphics, X-Coordinate, floating pt.
YCOR	= $CA	;Graphics, Y-Coordinate, floating pt. (must follow XCOR fo TTLHOM)
HEADNG	= $CE	;Graphics, Heading, floating pt. (must follow YCOR for TTLHOM)
BKGND	= $D2	;Graphics, background color
PEN	= $D3	;Graphics, indicates pen down if nonzero
NARGX	= $D4	;Numeric temporary, 4 bytes
;	DOS wants $D8
DOSERR	= $D8	;DOS "ONERR GOTO" flag - set high bit to turn on
X0L	= $D9	;Graphics, X loc. (low)
X0H	= $DA	;Graphics, X loc. (high)
Y0	= $DB	;Graphics, Y loc.
HBASLN	= $DC	;Graphics, screen memory line pointer

PARPNT	= $DE	;Music, current buffer pointer

DEFINP	= $E0	;default input device -- KEYIN initially
DEFOUT	= $E2	;default output device -- COUT initially
USHAPE	= $E4	;user shape pointer for user-defined turtles (sans rotation).
SSIZE	= $E6	;shape size -- default 1. THIS IS A BYTE.
SAVMOD	= $E7	;read/save mode. Normally 0, but if 1, save and read don't
		;do pofuns/pons or evlbuf (respectively). For saving text.
ARGSAV	= $E8	;this location is guaranteed not to be used by anything but
		;primitives.  No routines bash it.

.PAGE
.SBTTL		Page Three Storage

;	Logo primitive pointers:
ALL	=$340
COMMNT	=$342	;Comment
ELSE	=$344
END	=$346
IF	=$348
LPAR	=$34A	;(Left-parenthesis)
STOP	=$34C
THEN	=$34E
NAMES	=$350
PROCS	=$352	;Procedures
RPAR	=$354	;(Right-parenthesis)
TITLES	=$356
INFSUM	=$358	;(Infix Sum)
INFDIF	=$35A	;(Infix Difference)
GO	=$35C
TO	=$35E
EDIT	=$360

SCRNCH	=$362	;Graphics Y-axis scrunch factor
MSLOT	=$366	;Music card slot number times 16.

SVXCOR	=$367		;Graphics intermediary values
SVYCOR	=$36B
SHEDNG	=$36F
SPEN	=$373
STSHWN	=$374
SCLNM	=$375
SPLTN	=$376

MEACTP	=$377		;Music state variables
MPACTP	=$379
MEPRT	=$37B

TMPTAB	=$37D		;Start of temporary storage area
ETMPTB	=TMPTAB+TMPNUM
;$38D is end of tmptab.
CYXCT	=$3F8		;Monitor ^Y instruction (1 byte).
CYADR	=$3F9		;address -- two bytes.
;	Shared variables:
NODPTR	=ANSN		;Returned pointer address
CCOUNT	=ANSN1		;Char. count
TYPPTR	=TEMPNH		;Pointer into type-array

;	Other storage: Buffer information for disk-saving
DSKB1	=$4000
DSKB2	=$4001
PROGRM	=$4002		;Start of Logo code above buffer
.PAGE
.SBTTL		Assembly Constants

;	Type code constants:
LIST	=0	;List
ATOM	=1	;Atom
STRING	=2	;Alphanumeric linked-list
FIX	=3	;Fixnum (GT1NUM,GT2NUM require that FIX < FLO)
FLO	=4	;Floating point number
SFUN	=5	;System function
UFUN	=6	;User function
SATOM	=7	;Primitive
FPACK	=8	;Packed ufun
QATOM	=9	;Quoted atom (must equal 9 for PUTTYP,GETTYP)
DATOM	=10	;Dotted atom (must equal 10 for PUTTYP,GETTYP)
LATOM	=11	;Label atom (must equal 11 for PUTTYP,GETTYP)
HITYP	=11	;Highest type, for dispatch tables.
;	Parser constants:
NEWLIN	=1	;Start of input line
NEWLST	=2	;Start of sublist
REGCEL	=3	;Regular linked cell
;	General constants:
FULCHR	=$06	;Full-screen graphics character (Control-F)
STPKEY	=$07	;Stop-key character code (Control-G)
MIXCHR	=$13	;Splitscreen graphics character (Control-S)
PULCHR	=$10	;Redisplay last line typed (Control-P)
LSTKEY	=$17	;Interrupt output listing (Control-W)
PAUSKY	=$1A	;Pause-key character code (Control-Z)
TXTCHR	=$14	;Text-screen character (Control-T)
VEWCHR	=$16	;Graphics-screen character (Control-V)
IOKEY	=$1D	;reset io to default. (C-S-N)
RPRMPT	='<	;REQUEST prompt
QPRMPT	='?	;Regular prompt
LBRAK	='^	;Left-bracket replacement character
GCVST	=MARK1	;Start of Garbage Collecor protected variable area
GCVND	=OBLIST+2;End of Garbage Collector protected variable area
RANDA	=5353	;Random transform constant "A"
RANDC	=43277	;Random transform constant "C"
;	Storage Parameters:
LINARY	=$200		;Input line buffer (Must be page 2, because DOS uses it)
PRSBUF	=$200		;Parse-string buffer (must be at least $100 bytes for GETLN)
PRSLIM	=$2FF		;Parse-string buffer upper limit
CHBSTT	=$300		;Start of character buffer
CHBLEN	=64		;Length of character buffer
TMPSTT	=TEMPNH		;Start of page-zero swapped temporaries
TMPNUM	=TEMPN5-TMPSTT+2;Number of temporary bytes to swap
GRPSTT	=$2000		;Start of hires graphics area
GRPEND	=$4000		;End of Hires graphics area
EDBUF	=$2000		;Start of editor buffer
EBFEND	=$3FFB		;End of edit buffer (with room for CR and EOF marker)
;	Mapped I/O locations:
GETRM1	=$C08B	;Enable high RAM (with first 4K bank)
GETRM2	=$C083	;Enable high RAM (with second 4K bank, "Ghost-memory")
KILRAM	=$C08A	;Deselect high RAM (enable Monitor/BASIC)
KBDBYT	=$C000	;Keyboard input byte
KBDCLR	=$C010	;Keyboard clear strobe
GSW	=$C050	;Graphics mode
TXTMOD	=$C051	;Display text page
FULLGR	=$C052	;Full Graphics screen
MIXGR	=$C053	;Mixed Text/Graphics switch
PRMPAG	=$C054	;Primary page
HGSW	=$C057	;High-res mode
SPKR	=$C030	;Toggle speaker
PTRIG	=$C070	;Paddle timer reset
PADDL	=$C064	;Paddle counter locations
PADBTN	=$C061	;Paddle button locations
;	Interrupt Vector areas:
RSTVEC	=$FFFC	;Location of RESET vector
IRQVEC	=$FFFE	;Location of IRQ vector
NMIVEC	=$FFFA	;Location of NMI vector (BRK command)
;	System vectors:
RESETV	=SBPT	;RESET Vector
ROMMON	=$FA4C	;ROM Monitor entry point BREAK
ROMSTN	=$FE84	;ROM Monitor SETNORM routine
ROMNIT	=$FB2F	;ROM Monitor INIT routine
ROMSTV	=$FE93	;ROM Monitor SETVID routine
ROMSTK	=$FE89	;ROM Monitor SETKBD routine
MONACC	=$45	;ROM Monitor ACC location
MONBKV	=$03F0	;ROM Monitor BRKV vector
MONOBK	=$FA59	;ROM Monitor OLDBRK routine
;	DOS sacred locations:
DOSEAT	=$A851	;DOS subroutine to give DOS control of input
DSERET	=$9D5A	;DOS error return address location
DLNGFG	=$AAB6	;DOS language flag -- stuff a $40 for Applesoft
FILLEN	=$AA60	;length of last file loaded
APCOUT	=$FDED	;location of COUT routine in monitor (DOS calls it)
.PAGE
.SBTTL		System Function Index
;primitive index -- primitive indices.
;	Arithmetic:
IUNSUM	=1	;(unary sum)
IUNDIF	=2	;(unary difference)
INSUM	=3	;+
INDIF	=4	;-
INPROD	=5	;*
INQUOT	=6	;/
IQTENT	=7	;quotient
IRMNDR	=8	;remainder
IROUND	=9
ISIN	=10
ICOS	=11
ITWRDS	=12	;towards
;sqrt is at the end because this is stupid.
;	Boolean:
INGRTR	=13	;>
INLESS	=14	;<
INEQUL	=15	;=
INOT	=16
IAND	=17
IOR	=18
ITHNGP	=19	;thing?
IWORDP	=20	;word?
ILISTP	=21	;list?
INMBRP	=22	;number?
IRCP	=23	;RC?
;	Word/list:
IFIRST	=24
ILAST	=25
IBTFST	=26	;Butfirst
IBTLST	=27	;Butlast
IWORD	=28
IFPUT	=29
ILPUT	=30
ILIST	=31
ISNTNC	=32	;Sentence
;	Miscellaneous:
IMAKE	=33
IOTPUT	=34	;Output
ISTOP	=35
ICOMNT	=36	;;
ICNTIN	=37	;Continue
ITEST	=38
IIFT	=39
IIFF	=40
IIF	=41
ITHEN	=42
IELSE	=43
IGO	=44
IRUN	=45
IRPEAT	=46	;Repeat
IREQST	=47	;Request
ITHING	=48
IGCOLL	=49	;.Gcoll
INODES	=50	;.Nodes
IDEFIN	=51	;Define
ITEXT	=52
ITO	=53
IEDIT	=54
IEND	=55
IPRINT	=56
IPRNT1	=57
IPO	=58
IPOTS	=59
IERASE	=60
IERNAM	=61
IALL	=62
INAMES	=63
ITITLS	=64	;Titles
IPROCS	=65	;Procedures
ITRACE	=66
INTRAC	=67	;Notrace
IRANDM	=68	;Random
IRNDMZ	=69	;Randomize
IRC	=70
ICURSR	=71	;Cursor
ICLINP	=72	;Clearinput
ICLEAR	=73
IPADDL	=74	;Paddle
IEXM	=75	;.Examine
IDEP	=76	;.Deposit
ICALL	=77	;.Call
IPAUSE	=78
IBPT	=79	;.Bpt
ITPLVL	=80	;Toplevel
IGDBYE	=81	;Goodbye
ILPAR	=82	;(left-parenthesis)
IRPAR	=83	;(right-parenthesis)
IPDBTN	=84	;Paddlebutton
;	Filing:
IREAD	=85
ISAVE	=86
IDELET	=87	;Delete
ICATLG	=88	;Catalog
IERPCT	=89	;Erasepict
;	New primitives:
INUMOF	=90	;Ascii
ILETOF	=91	;Charred
IINT	=92	;Integer
ISQRT	=93	;Sqrt
IINADR	=94	;input slot/address
IOTADR	=95	;output

LP	=IOTADR
.IFNE GRPINC
;	Graphics:
IFORWD	=LP+1	;Forward
IBACK	=LP+2
IRIGHT	=LP+3
ILEFT	=LP+4
IDRAW	=LP+5
IHOME	=LP+6
IPENUP	=LP+7
IPENDN	=LP+8	;Pendown
ISHOWT	=LP+9	;Showturtle
IHIDET	=LP+10	;Hideturtle
ITSTAT	=LP+11	;Turtlestate
INDSPL	=LP+12	;Nodisplay
ISETX	=LP+13
ISETY	=LP+14
ISETXY	=LP+15
ISETH	=LP+16
ISETT	=LP+17
IXCOR	=LP+18
IYCOR	=LP+19
IHDING	=LP+20	;Heading
IFULL	=LP+21	;Fullgraphics
ISPLIT	=LP+22	;Splitscreen
IRDPCT	=LP+23	;Readpict
ISVPCT	=LP+24	;Savepict
IPALET	=LP+25	;Palette
IPENC	=LP+26	;Pencolor
ICS	=LP+27
IBKGND	=LP+28	;Background
ISCNCH	=LP+29	;Scrunch
LP	=ISCNCH
.ENDC
.IFNE MUSINC
;	Music:
IVOICE	=LP+1
INVOIC	=LP+2	;Nvoices
IPLAYM	=LP+3	;Playmusic
INOTE	=LP+4
IAD	=LP+5	;Setad
IVS	=LP+6	;Setvs
IRG	=LP+7	;Setrg
ISFZ	=LP+8	;Setfuzz
ISVMUS	=LP+9	;Savemusic
IRDMUS	=LP+10	;Readmusic
IERMUS	=LP+11	;Erasemusic
.ENDC
.PAGE
.SBTTL		Error Codes

XUOP	=1	;What to do with
XEOL	=2	;Unexpected end of line
XUDF	=3	;Haven't told me how to
XHNV	=4	;Has no value
XNIP	=5	;Nothing inside parenthesis
XNOP	=6	;Didn't output
XRPN	=7	;Unexpected right parenthesis
XIFX	=8	;Nothing before operator
XNTM	=9	;Haven't set NVOICES
XTIP	=10	;Too much inside parenthesis
XWTA	=11	;Doesn't like input
XUBL	=12	;Logo primitive
XNTL	=13	;Only in procedures
XNTF	=14	;Not true or false
XELS	=15	;Else out of place
XBRK	=16	;Pause
XLAB	=17	;Label out of place
XTHN	=18	;Then out of place
XLNF	=19	;Label not found
XETL	=20	;Not in procedures
XNED	=21	;END only in editor
XOPO	=22	;Only for PO or ERASE
XDBZ	=23	;Divide by zero
XOFL	=24	;Arithmetic overflow
XNDF	=25	;Not defined
XCSR	=26	;Cursor off screen
XOOB	=27	;Turtle out of bounds
XIOR	=28	;Disk error
XWTP	=29	;Write-protected disk
XFNF	=30	;File not found
XDKF	=31	;Disk full
XLKF	=32	;File locked
XTMN	=33	;Too many notes
XNTM	=34	;Haven't set nvoices
XSYN	=35	;Syntax error in filename
XRNG	=36	;Nothing to save
XLB1	=37	;Labels only in procedures
XCED	=38	;Can't edit
XUOPT	=39	;Result: (Top-Level XUOP)
XZAP	=100	;(Not in dispatch table)

;	XZAP Quantifiers:
XNSTOR	=0	;No storage left
XSTOP	=1	;Stopped!
XNSTRN	=2	;Out of nodes (No storage left msg)
XNRGEX	=3	;Too many inputs
XPNEST	=4	;Procedure nesting too deep
XTNEST	=5	;Tail-recursion nesting too deep
PRNNST	=6	;Parenthesis nesting too deep
XIFLEX	=7	;If-level nesting too deep
XENEST	=8	;Evaluator nesting too deep
.PAGE
.SBTTL		Storage Parameters

;	Miscellaneous:	Page 0 - Variables
;			Page 1 - Processor Stack
;			Page 2 - Input line buffer (for DOS also)
;			Page 3 - Pointers, variable storage, character buffer
;			Pages 4 to 7 - Text screen page
;			Pages 8 to 27 - Stacks (PDL, VPDL)
;			Pages 28 to 31 - Separated code (I/O Routines)
;			Pages 32 to 63 - Hi-res. graphics/Screen editor buffer

;	MISC.:    $0000 - $07FF: $ 800 bytes (2K bytes)
;	STACKS:   $0800 - $1BF5: $13F6 bytes (2555 words) PDL, VDPL
;	VECTORS:  $1BF6 - $1BFF: $   A bytes (3 vectors) Cold start, warm start, crash re-entry
;	OTHERCODE:$1C00 - $1FFF: $ 400 bytes (1k bytes, maximum) I/O subroutines
;	BUFFER:   $2000 - $3FFF: $2000 bytes (8K bytes) Screen Editor, Graphics, boot buffer
;	LOGO:     $4000 - $977F: $57FF bytes (22.5K bytes, maximum) Logo code
;	USER:     $9780 - $9AA0: $ 320 bytes (800 bytes, maximum) Free memory.
;	DOS:      $9AA0 - $BFFF: $255F bytes (9567 bytes) DOS code, buffers
;	I/O:      $C000 - $CFFF: $1000 bytes (4K bytes) Mapped I/O addresses
;	NODEARRAY:$D000 - $F65F: $2660 bytes (2456. nodes) Nodespace
;	TYPEARRAY:$F660 - $FFF7: $ 998 bytes (2456. typecodes) Type-codes
;	UNUSED:   $FFF8 - $FFF9: $   2 bytes
;	INTRPTS.: $FFFA - $FFFF: $   6 bytes (3 vectors) Interrupt vectors

;	GHOSTMEM: $D000 - $DFFF: $1000 bytes (4K bytes) Static storage

NODBEG	=$D000		;Nodespace beginning
BBASX	=NODBEG-4
NODLEN	=$2660		;Nodespace length
NODEND	=NODBEG+NODLEN	;Nodespace end
;OFSET1	=NODBEG/4 but the stupid cross assembler can't divide correctly so we have to do it...
OFSET1	=$3400		;Offset constant
TYPARY	=NODEND-OFSET1	;Typebase offset
TYPLEN	=NODLEN/4	;Typebase length
TYPEND	=NODEND+TYPLEN	;Typebase end
NODTST	=50		;Minimum free nodes for parser
NODLIM	=TYPLEN-NODTST	;Node allocation limit
STKLEN	=$13F6		;Combined stack length
PDLBAS	=$800		;PDL beginning (grows upwards, Push-then-incr.)
VPDLBA	=PDLBAS+STKLEN-2;VPDL beginning (grows downwards, Push-then-decr.)
STKLIM	=80		;Minimum unused stack space before panicking

SYSTAB	=$30		;Page no. of System tables (after loading)
GHOMEM	=$D0		;Page no. of Ghost-memory
TDIFF	=$A000		;Difference between above storage areas
OCODE	=$1C00		;Location of separated code
.PAGE
.SBTTL	Macro definitions

;VAL gets the car of NODE. VAL can't equal NODE.
.MACRO	CAR VAL,NODE
	LDY #$00
	LDA (NODE),Y
	STA VAL
	INY
	LDA (NODE),Y	;(Last instruction that affects flags)
	STA VAL+1
.ENDM

;(X) gets the car of NODE. X can't equal #NODE.
.MACRO	CARX NODE
	LDY #$00
	LDA (NODE),Y
	STA $00,X
	INY
	LDA (NODE),Y	;(Last instruction that affects flags)
	STA $01,X
.ENDM

;NODE gets the car of NODE.
.MACRO	CARME NODE
	LDY #$00
	LDA (NODE),Y
	TAX
	INY
	LDA (NODE),Y	;(Last instruction that affects flags)
	STA NODE+1
	STX NODE
.ENDM

;VAL gets the cdr of NODE. VAL can't equal NODE.
.MACRO	CDR VAL,NODE
	LDY #$02
	LDA (NODE),Y
	STA VAL
	INY
	LDA (NODE),Y	;(Last instruction that affects flags)
	STA VAL+1
.ENDM

;(X) gets the cdr of NODE. X can't equal #NODE.
.MACRO	CDRX NODE
	LDY #$02
	LDA (NODE),Y
	STA $00,X
	INY
	LDA (NODE),Y	;(Last instruction that affects flags)
	STA $01,X
.ENDM
.PAGE
;NODE gets the cdr of NODE.
.MACRO	CDRME NODE
	LDY #$02
	LDA (NODE),Y
	TAX
	INY
	LDA (NODE),Y
	STA NODE+1	;(Last instruction that affects flags)
	STX NODE
.ENDM

;VAL gets the car of NODE, NODE gets the cdr of NODE. VAL can't equal NODE.
.MACRO	CARNXT VAL,NODE
	LDY #$00
	LDA (NODE),Y
	STA VAL
	INY
	LDA (NODE),Y
	STA VAL+1
	INY
	LDA (NODE),Y
	TAX
	INY
	LDA (NODE),Y	;(Last instruction that affects flags)
	STA NODE+1
	STX NODE
.ENDM

;The car of NODE becomes VAL.
.MACRO	RPLACA NODE,VAL
	LDY #$00
	LDA VAL
	STA (NODE),Y
	INY
	LDA VAL+1
	STA (NODE),Y
.ENDM

;The car of NODE becomes (X).
.MACRO	RPLCAX NODE
	LDY #$00
	LDA $00,X
	STA (NODE),Y
	INY
	LDA $01,X
	STA (NODE),Y
.ENDM
.PAGE
;The cdr of NODE becomes VAL.
.MACRO	RPLACD NODE,VAL
	LDY #$02
	LDA VAL
	STA (NODE),Y
	INY
	LDA VAL+1
	STA (NODE),Y
.ENDM

;The cdr of NODE becomes (X).
.MACRO	RPLCDX NODE
	LDY #$02
	LDA $00,X
	STA (NODE),Y
	INY
	LDA $01,X
	STA (NODE),Y
.ENDM

;PTR (p.z. variable name) gets pushed on the PDL.
.MACRO	PUSH PTR
	LDX #PTR
	JSR PUSHP
.ENDM

;ADDR gets pushed on the PDL
.MACRO	PUSHA ADDR
	LDX #ADDR&$FF
	LDY #ADDR^
	JSR PUSH
.ENDM

;PTR (p.z. variable name) gets popped from the PDL.
.MACRO	POP PTR
	LDX #PTR
	JSR POP
.ENDM

;PTR (p.z. variable name) gets pushed on the VPDL.
.MACRO	VPUSH PTR
	LDX #PTR
	JSR VPUSHP
.ENDM

;PTR (p.z. variable name) gets popped from the VPDL.
.MACRO	VPOP PTR
	LDX #PTR
	JSR VPOP
.ENDM
.PAGE
;VAR (one byte) gets pushed on the PDL.
.MACRO	PUSHB VAR
	LDA VAR
	JSR PUSHB
.ENDM

;VAR gets the byte popped off of the PDL.
.MACRO	POPB VAR
	JSR POPB
	STA VAR
.ENDM
.PAGE
;PTR (p.z. variable name) points to the new node, with car CAR
; and cdr CDR (both p.z. variable names) and type TYPE.
.MACRO	CONS PTR,CAR,CDR,TYPE
	LDA #PTR
	STA NODPTR
	LDX #CDR
	LDY #CAR
.IIF EQ, TYPE-LIST, JSR LCONS
.IIF EQ, TYPE-STRING, JSR STCONS
.IIF EQ, TYPE-FIX, JSR INCONS
.IIF EQ, TYPE-FLO, JSR FNCONS
.IIF EQ, TYPE-ATOM, JSR ACONS
.IIF EQ, TYPE-SATOM, JSR SACONS
.ENDM

;Load four bytes into a numerical variable.
.MACRO	SETNUM NUMPTR,VALUE ?SETNM1
	LDX #$03
SETNM1:	LDA VALUE,X
	STA NUMPTR,X
	DEX
	BPL SETNM1
.ENDM

;Signal an error.
.MACRO	ERROR ERRN,PTR1,PTR2
.NARG NRGS
.IFGE NRGS-2
	LDY #PTR1
.ENDC
.IFGE NRGS-3
	LDX #PTR2
.ENDC
	LDA #ERRN
	JMP ERROR
.ENDM
.PAGE
;VALUE gets incremented by 1.
.MACRO	INC1 VALUE ?INC1A
	INC VALUE
	BNE INC1A
	INC VALUE+1
INC1A:
.ENDM

;VALUE gets incrmented by 2.
.MACRO	INC2 VALUE ?INC2A
	CLC
	LDA VALUE
	ADC #$02
	STA VALUE
	BCC INC2A
	INC VALUE+1
INC2A:
.ENDM

;(X) gets incremented by 2.
.MACRO	INC2X ?INC2XA
	CLC
	LDA $00,X
	ADC #$02
	STA $00,X
	BCC INC2XA
	INC $01,X
INC2XA:
.ENDM

;VALUE gets incrmented by 4.
.MACRO	INC4 VALUE ?INC4A
	CLC
	LDA VALUE
	ADC #$04
	STA VALUE
	BCC INC4A
	INC VALUE+1
INC4A:
.ENDM

;(X) gets incremented by 4.
.MACRO	INC4X ?INC4XA
	CLC
	LDA $00,X
	ADC #$04
	STA $00,X
	BCC INC4XA
	INC $01,X
INC4XA:
.ENDM

;VALUE gets decremented by 2.
.MACRO	DEC2 VALUE ?DEC2A
	SEC
	LDA VALUE
	SBC #$02
	STA VALUE
	BCS DEC2A
	DEC VALUE+1
DEC2A:
.ENDM
.PAGE
;Print MSG (text string name).
.MACRO	PRTSTR MSG
	LDX #MSG&$FF
	LDY #MSG^
	JSR PRTSTR
.ENDM

;Dispatch off of type from table ADDR.
.MACRO	TYPDSP ADDR
	LDX #ADDR&$FF
	LDY #ADDR^
	JMP TYPDSP
.ENDM

;Get type of NODE.
.MACRO	GETTYP NODE
	LDX #NODE
	JSR GETTYP
.ENDM

;(X) gets VALUE.
.MACRO	PUTX VALUE
	LDA VALUE
	STA $00,X
	LDA VALUE+1
	STA $01,X
.ENDM

;VALUE gets (X).
.MACRO	GETX VALUE
	LDA $00,X
	STA VALUE
	LDA $01,X
	STA VALUE+1
.ENDM

;VALUE gets (Y).
.MACRO	GETY VALUE
	LDA $00,Y
	STA VALUE
	LDA $01,Y
	STA VALUE+1
.ENDM

;I wish we had a sixteen bit processor...
.MACRO	MOV DEST,SOURCE
	LDA SOURCE
	STA DEST
	LDA SOURCE+1
	STA DEST+1
.ENDM

;Ditto...
.MACRO	SETV DEST,SOURCE
	LDA #SOURCE&$FF
	STA DEST
	LDA #SOURCE^
	STA DEST+1
.ENDM
.PAGE
.SBTTL 	Top Level

.=PROGRM
;	Local variable block:
BOTPTR	=TEMPNH		;Boot-area pointer
BOTPT1	=TEMPN		;Destination-area pointer

;Calling point for the Logo Interpreter
LOGO:	LDA GETRM1	;Enable high RAM
	LDA GETRM1
	SETV RSTVEC,RESETV	;Set up the RESET key vector
	LDA #$4C	;Crock. JMP opcode.
	STA CYXCT
	SETV CYADR,WMBT		;set up ^Y in monitor to warm boot.
	LDA #SYSTAB	;Page no. of tables
	STA BOTPTR+1
	LDA #GHOMEM	;Page no. of ghost-memory
	STA BOTPT1+1
	LDX #ENDTAB^	;Last page
	LDY #$00
	STY BOTPTR
	STY BOTPT1
	LDA GETRM2	;Select Ghost-memory for writing
	LDA GETRM2
MOVLOP:	LDA (BOTPTR),Y
	STA (BOTPT1),Y
	INY
	BNE MOVLOP
	INC BOTPTR+1
	INC BOTPT1+1
	CPX BOTPTR+1	;See if last page transferred
	BCS MOVLOP
;	...

;Re-entry point for GOODBYE:
;	...
LOGO1:	SEI		;Disable interrupts
	CLD		;Disable decimal mode
	LDX #$FF
	TXS		;Initialize processor stack
	INX
	STX $00		;Define LNIL as $0000 at $0000
	STX $01
	STX $02
	STX $03
	LDA GETRM1
	LDA GETRM1	;Disable Ghost-memory
	LDA #MONBRK&$FF
	STA IRQVEC
	STA NMIVEC	;Interrupts cause a break to Monitor
	LDA #MONBRK^
	STA IRQVEC+1
	STA NMIVEC+1
	JSR INITLZ
	PRTSTR HELSTR	;Types Hello-String
TOPLOP:	LDA #QPRMPT
	JSR PGTLIN	;Read a line
	LDX #TOKPTR
	JSR PRSLIN	;Parse the line
	LDA TOKPTR+1
	BEQ TOPLOP	;Ignore if line is empty
;	...
.PAGE
.SBTTL	Evaluator Routines

;EVLUAT initializes the Evaluator variables, starts EVLINE.
;	...
EVLUAT:	SETV SP,PDLBAS
	SETV VSP,VPDLBA
	LDA #$00
	STA EXPOUT
	STA RUNFLG
	STA STPFLG
	STA COFLAG
	STA ERRNUM
	STA LEVNUM
	STA LEVNUM+1
	STA TLLEVS
	STA TLLEVS+1
	STA FRAME+1
	STA XFRAME+1
	STA BRKSP+1	;BRKSP = nil means break to toplevel
	STA UFRMAT
	PUSHA TOPLOP	;Top-level Return Address
;	...
.PAGE
;	Local variable block:
TOKEN	=TEMPN		;Token ptr.

;EVLINE called with TOKPTR pointing to line of code to execute.
; Pushes IFLEVEL and EXPOUT and then resets them.

;	...
EVLINE:	JSR TSTSTK
	JSR POLLZ
	PUSHB EXPOUT
	PUSHB IFLEVL
	LDA #$00
	STA EXPOUT
	STA IFLEVL
	LDA TOKPTR+1
	BEQ EVLN1P
EVLN1:	CAR TOKEN,TOKPTR
	GETTYP TOKEN
	CMP #LATOM
	BNE EVLN1A
	LDA LEVNUM
	ORA LEVNUM+1
	BNE EVLN2
	ERROR XLB1
EVLN2:	JSR TOKADV
;	...

;EVLIN1 keeps calling EVLEXP until EOL.

;	...
EVLIN1:	LDA TOKPTR+1
	BNE EVLN1A
EVLN1P:	POPB IFLEVL
	POPB EXPOUT
;	...

;	Local variable block:
ADRESS	=TEMPN		;Popped return address

;	...
POPJ:	POP ADRESS
	JMP (ADRESS)
EVLN1A:	LDA STPFLG
	BNE EVLN1P
	PUSHA EVLIN1	;Push EVLIN1 return address
;	...

;EVLEXP calls EVAL with PRECED = 0. EVAL returns to EVEX1,
;which restores old PRECED.

;	...
EVLEXP:	PUSHB PRECED
	LDA #$00
	STA PRECED
	PUSHA EVEX1
;	...
.PAGE
;	Local variable block:
VALUE	=TEMPN		;Binding value

;EVAL dispatches to either EVWRAP, PARLOP, UFUNCL, or SFUNCL.
;All return eventually to EVWRAP.

;	...
EVAL:	JSR POLL	;Poll at every token to be evaluated
	PUSH CURTOK
	LDA FRAME+1
	BEQ XEVL2
XEVL1:	INC NEST
	BPL XEVL2
XENXC:	LDX #XENEST
	JMP EXCED	;Evaluator nesting too deep

XEVL2:	LDA TOKPTR+1
	BNE XEVL3
	JMP ERXEOL
XEVL3:	CAR CURTOK,TOKPTR	;Get CURTOK and NEXTOK
	JSR TOKADV
	JSR GTNXTK
	GETTYP CURTOK	;Dispatch off Type of CURTOK
	TYPDSP EVLTB1
;Evaluator type dispatch table
EVLTB1:	.ADDR XCASQ	;List
	.ADDR XCASA	;Atom
	.ADDR SYSBG1	;String
	.ADDR XCASQ	;Fix
	.ADDR XCASQ	;Flo
	.ADDR SYSBG1	;Sfun
	.ADDR SYSBG1	;Ufun
	.ADDR XCASA	;Satom
	.ADDR SYSBG1	;Fpack
	.ADDR XCASQ	;Qatom
	.ADDR XCASD	;Datom
	.ADDR XCASL	;Latom

SYSBG1:	LDA #$01
	JMP SYSBUG
XCASL:	LDX #CURTOK
	LDA $00,X
	AND #$FC	;Strip off label bits
	STA $00,X
	ERROR XLAB	;ERROR, can't execute a label
XCASD:	LDY #CURTOK	;DATOM, so VPush it unless it's Novalue (then Error)
	LDX #VALUE
	JSR GETVAL
	LDX #VALUE	;For VPUSH in XCASQ1
	CMP #$01
	BNE XCASQ1
	LDA CURTOK
	AND #$FC
	STA CURTOK
	LDA #XHNV
	ERROR XHNV,CURTOK
XCASQ:	LDA CURTOK	;QATOM, FIX, FLO, LIST: Just push it and set OTPUTN
	AND #$FC	;Strip off last two bits
	STA CURTOK
	LDX #CURTOK
XCASQ1:	JSR VPUSHP
	LDA #$01
	STA OTPUTN
	JMP EVWRAP
XCASA:	JSR GETCFN	;ATOM, SATOM: It's some sort of Function
	STY FUNTYP
	CMP #$01
	BNE XCASA1
	ERROR XUDF,CURTOK	;Error if no function gotten
XCASA1:	JSR INFIXP
	BCC XCASA2
	CMP #INSUM
	BNE XCASA3
	LDX UNSUM
	LDY UNSUM+1
	BNE XCASA4	;(Always)
XCASA5:	ERROR XIFX,CURTOK
XCASA3:	CMP #INDIF
	BNE XCASA5
	LDX UNDIF
	LDY UNDIF+1
XCASA4:	STX CURTOK
	STY CURTOK+1
	JSR GETCFN
	STY FUNTYP
XCASA2:	PUSHB PRECED	;It should be a UFUN or SFUN
	JSR GETPRC
	STA PRECED
	JSR GETNGS
	AND #$7F
	STA NARGS
	PUSHA EVAL1
;	...
.PAGE
;	Local variable block:
NARGS1	=ANSN		;Temporary NARGS (shared: ARGLOP,AL1,AL2)

;	...
ARGLOP:	LDA NARGS	;ARGLOP gets the args for a function
	BNE ARGLP1
	JMP POPJ	;Exit if no args to be gotten
ARGLP1:	LDA NARGS
	STA NARGS1	;AL1 will push this
	JSR PUSHB
	PUSH FUNCT
	PUSHB FUNTYP
	PUSHB EXPOUT
	PUSHB IFLEVL
;	...

;	Local variable block:
NARGS1	=ANSN		;Temporary NARGS (shared: ARGLOP,AL1,AL2)

;	...
AL1:	JSR GTNXTK
	PUSH NEXTOK
	PUSHB NARGS1
	PUSHB PRECED
	LDX #$00
	STX IFLEVL
	INX
	STX EXPOUT
	PUSHA AL2
	JMP EVAL
ERXNPJ:	JMP ERXNOP

;	Local variable block:
NARGS1	=ANSN		;Temporary NARGS (shared: ARGLOP,AL1,AL2)

AL2:	POPB PRECED
	POPB NARGS1
	POP NEXTOK
	LDA OTPUTN
	BEQ ERXNPJ
	DEC NARGS1
	BNE AL1		;Get another arg if not done
	POPB IFLEVL
	POPB EXPOUT
	POPB FUNTYP
	POP FUNCT
	POPB NARGS
	JMP POPJ

EVEX1:	POPB PRECED
	JMP POPJ
.PAGE
PARLOP:	LDX #NEXTOK	;Executed when an LPAR is encountered
	JSR GTCFN1
	STY FUNTYP
	CPY #SFUN
	BNE PARLPA
	LDA NEXTOK
	CMP RPAR
	BNE PARLPA
	LDA NEXTOK+1
	CMP RPAR+1
	BNE PARLPA
	ERROR XNIP	;"Nothing inside parenthesis"
PARLPA:	LDA FUNCT+1
	CMP #$01
	BEQ PARLP7
	JSR GETNGS
	STA NARGS
	TAX
	BMI PARLP3
PARLP7:	PUSHB EXPOUT
	PUSHB IFLEVL
	LDX #$00
	STX IFLEVL
	INX
	STX EXPOUT
	PUSHA PLOP1
	JMP EVLEXP
PARLP3:	JSR GETPRC
	STA PRECED
	MOV CURTOK,NEXTOK
	JSR TOKADV
	LDA #$00
	STA NARGS
	PUSH FUNCT
	PUSHB FUNTYP
;	...
.PAGE
;	...
VARGLP:	JSR GTNXTK
	LDA NEXTOK
	CMP RPAR
	BNE VRGLP1
	LDA NEXTOK+1
	CMP RPAR+1
	BNE VRGLP1
	POPB FUNTYP
	POP FUNCT
	JSR TOKADV
	ASL NARGS	;Set high bit of NARGS
	SEC
	ROR NARGS
	JMP FNCAL1
VRGLP1:	PUSHB NARGS
	PUSH NEXTOK
	PUSHB EXPOUT
	PUSHB IFLEVL
	PUSHB PRECED
	PUSHA VAL1
	LDX #$00
	STX IFLEVL
	INX
	STX EXPOUT
	JMP EVAL
.PAGE
VAL1:	POPB PRECED
	POPB IFLEVL
	POPB EXPOUT
	POP NEXTOK
	POPB NARGS
	LDA OTPUTN
	BEQ ERXNOP
	INC NARGS
	BNE VARGLP
EXCED:	ERROR XZAP,XNRGEX
ERXNOP:	ERROR XNOP,NEXTOK
.PAGE
;PLOP1 cleans up after a parenthesized expression.

PLOP1:	POPB IFLEVL
	POPB EXPOUT
	LDA TOKPTR+1
	BEQ ERXELJ
	JSR GTNXTK
	LDA NEXTOK
	CMP RPAR	;Next token must be an RPAR, else Error
	BNE PLOP1B
	LDA NEXTOK+1
	CMP RPAR+1
	BNE PLOP1B
	JSR TOKADV	;Everything OK, get the next token and exit
	JMP POPJ
PLOP1B:	ERROR XTIP
ERXELJ:	JMP ERXEOL
.PAGE
;Evaluates the edit buffer.
EVLBUF:	PUSHB UFRMAT	;Save type of superior line
EVLBF1:	LDA INPFLG	;If something reset it to default,
	BNE SRED1A
	JMP SREAD3	;then break out, don't check for EOF.
SRED1A:	LDA ENDBUF+1
	CMP EPOINT+1
	BNE EDIN
	LDA ENDBUF
	CMP EPOINT
	BNE EDIN
	JMP SREAD2
EDIN:	LDY #EPOINT
	LDX #TOKPTR
	JSR PARSTR	;Parse the line
	MOV EPOINT,PLINE
	INC1 EPOINT	;Set the point to right after the carriage return
	LDA TOKPTR+1
	BEQ SRED1A
	LDA DEFFLG
	BEQ SRD1E
	LDY #$00
	LDA (TOKPTR),Y
	CMP END
	BNE EDLINE
	INY
	LDA (TOKPTR),Y
	CMP END+1
	BNE EDLINE
SRD1E:	PUSHA EVLBF1
	LDA #$00	;Buffer lines are type LIST
	STA UFRMAT
	JMP EVLINE

;	Local variable block:
NXLINE	=TEMPN		;Next line ptr.
NWLINE	=TEMPN1		;New consed line

;Add TOKPTR to procedure DEFBOD. Simple, huh?
EDLINE:	LDX DEFBOD
	LDA DEFBOD+1
EDL1:	STX NXLINE
	STA NXLINE+1
	LDY #$02
	LDA (NXLINE),Y	;CDR through DEFBOD
	TAX
	INY
	LDA (NXLINE),Y
	BNE EDL1	;until we hit a nil
	CONS NWLINE,TOKPTR,0,LIST	;Make a node for the new line
	RPLACD NXLINE,NWLINE	;Link it on to DEFBOD
	JMP EVLBF1
.PAGE
SREAD2:	LDA DEFFLG
	BEQ SRD2A
	PUSHA SRD2A
	JMP SEND	;Call END to end the procedure
SRD2A:	JSR RSTIO	;Break out of read-loop
SREAD3:	LDA #$00
	STA EXPOUT
	STA OTPUTN
	STA TOKPTR+1
	POPB UFRMAT	;Get superior line-type back
	JMP POPJ	;Return to superior
.PAGE
;	Local variable block:
PREC1	=ANSN2		;Temp. precedence

EVWRAP:	LDA TOKPTR+1
	BEQ EVRETN
	LDA OTPUTN
	BEQ EVRETN
	LDA STPFLG
	BNE EVRETN
	CAR CURTOK,TOKPTR
	CMP RPAR+1
	BNE EVW2
	LDA CURTOK
	CMP RPAR
	BEQ EVRETN
EVW2:	JSR GETCFN
	STY FUNTYP
	JSR INFIXP
	BCC EVRETN
	JSR GETPRC
	STA PREC1
	CMP PRECED
	BCC EVRETN
	BEQ EVRETN
	JSR TOKADV
	JSR GTNXTK
	PUSH NEXTOK
	PUSH FUNCT
	PUSHB FUNTYP
	PUSHB EXPOUT
	PUSHB IFLEVL
	PUSHB PRECED
	LDA #$01
	STA EXPOUT
	LDA PREC1
	STA PRECED
	PUSHA EW1
	JMP EVAL

EVRETN:	LDA FRAME+1
	BEQ EVRET1
	DEC NEST
EVRET1:	LDA OTPUTN
	BEQ EVRET2
	LDA EXPOUT
	BNE EVRET2
	LDA STPFLG
	BNE EVRET2
	LDA RUNFLG
	BNE EVRET2
	VPOP NEXTOK
;If at top-level or break loop, make this be a feature, otherwise a bug.
	LDA LEVNUM
	ORA LEVNUM+1
	BEQ EVRET3
	LDA FBODY+1
	BEQ EVRET3
	ERROR XUOP,NEXTOK
EVRET2:	POP CURTOK
	JMP POPJ
;Top-level error message.
EVRET3:	ERROR XUOPT,NEXTOK
	JMP EVRET2
.PAGE
;EW1 pops everything EVWRAP pushed, checks for output (error if none),
;then goes to FUNCAL with NARGS = 2.

EW1:	POPB PRECED
	POPB IFLEVL
	POPB EXPOUT
	POPB FUNTYP
	POP FUNCT
	POP NEXTOK
	LDA OTPUTN
	BNE EW1A
	JMP ERXNOP
EW1A:	LDA #$02
	STA NARGS
	BNE FUNCAL	;(Always)

EVAL1:	POPB PRECED	;Now that we have the args, get the old PRECED back and do the function
;	...

;FUNCAL calls either SFUNCL (with FBODY1 = Funct. #) or UFUNCL (with FBODY1
; pointing to text). Both return to EVWRAP. (FNCAL1 is same, except U&SFNCL
; don't return to EVWRAP).

;	...
FUNCAL:	PUSHA EVWRAP
FNCAL1:	LDA FUNTYP
	CMP #SFUN
	BNE UFUNCL
	LDA GETRM2	;Enable ghost-memory
	LDY #PRMIDX
	LDA (FUNCT),Y
	STA FBODY1
	LDA GETRM1	;Disable ghost-memory
	LDA GETRM1
;	...
.PAGE
;	Local variable block:
INDEX	=TEMPN		;Table index
ADRESS	=TEMPNH		;Primitive address

;	...
SFUNCL:	LDA #$00
	STA OTPUTN	;Default, no outputs
	LDA FBODY1
	ASL A
	STA INDEX
	LDA #GHOMEM	;Page no. of dispatch addresses
	ADC #$00
	STA INDEX+1
	LDA GETRM2	;Enable Ghost-memory
	CAR ADRESS,INDEX
	LDA GETRM1	;Ghost-memory disable
	LDA GETRM1
	JMP (ADRESS)	;Execute the routine

;Primitives which give errors if explicitly evaluated:
STHEN:	ERROR XTHN
SRPAR:	ERROR XRPN
SQFIER:	ERROR XOPO,CURTOK	;ALL, NAMES, TITLES, and PROCEDURES
.PAGE
;	Local variable block:
LASLIN	=ANSN3		;High byte of current ufun line
VSPPTR	=TEMPX1		;VSP pointer (shared: UFUNCL,XTAIL,NWBNDS,STPTR1,SPRNT,SWORD)
ARGLST	=TEMPN8		;Arglist pointer for bindings (shared: UFUNCL,XTAIL,NWBNDS,GETALN)
VARNAM	=TEMPN7		;Binding name ptr. (shared: UFUNCL,XTAIL,NWBNDS)
TMPVAL	=TEMPN6		;Temporary binding value (shared: UFUNCL,XTAIL,NWBNDS,TRCBND)

;UFUNCL calls a ufun, pushing a new stack frame or calling XTAIL to tail-recurse.
;
;	Before pushing a stack-frame, the following information is pushed:
;ULNEND	Uline-end for current command-line
;UFRMAT	Format of current command line
;FBODY	Body of current ufun (0 if toplevel)
;FPTR	Pointer to current ufun line (0 if toplevel)
;RUNFLG	Run-flag at time of call
;
;	This is a stack frame:
;Index	Offset	Value
;
SFFBDY	=5	;Negative offset from Frame-pointer, so it can be G.C.-protected
SFFRAM	=0	;FRAME: Pointer to start of last frame (0 if toplevel)
SFXFRM	=2	;XFRAME: Pointer to top of last frame (0 if toplevel)
SFFRMT	=4	;UFRMAT: Type of this ufun
SFTOKN	=5	;CURTOK: Pointer to this ufun atom (ie, its name)
SFNEST	=7	;NEST: Nesting level at time of ufun call
SFTEST	=8	;IFTEST: Test flag at time of ufun call
SFTKNP	=9	;TOKPTR: Pointer to rest of command line
SFNRGS	=11	;NARGS: No. of args to this ufun, plus one for funct/frame pair
SFTLVS	=12	;TLLEVS: No. of tail-recursions at time of ufun call
SFIFLV	=14	;IFLEV: No. of levels of IF nesting.
;
;	Binding Pairs:
SFBNDS	=15	;BINDGS: No. of bindings of this ufun
SFFNCT	=17	;FUNCT: Pointer to new ufun block (of 4 consecutive words)
;VALUEn	19+2*n	Pointer to value of binding at time of ufun call
;NAMEn	21+2*n	Pointer to binding atom (ie, variable name)
;
;XFRAME points directly above last binding pair.

UFUNCL:	CDR FBODY1,FUNCT	;UFUN, get text pointer
	LDY #$03
	LDA UFRMAT
	BEQ LPK1
	INY
	INY
LPK1:	LDA (FPTR),Y
	STA LASLIN	;If nil, we're on the last line
	JSR TSTSTK
	PUSH ULNEND
	PUSHB UFRMAT
	PUSH FBODY
	PUSH FPTR
	PUSHB RUNFLG
	LDA #$00
	STA STPFLG
	STA RUNFLG
	STA GOPTR+1
	LDA FBODY1
	STA FBODY
	STA FPTR
	LDA FBODY1+1
	STA FBODY+1
	STA FPTR+1
	LDA TRACE
	BEQ XUFN11
	PRTSTR TRACM1	;"Executing "
	LDX #CURTOK
	JSR LTYPE	;A=???
	LDA #$20
	JSR TPCHR
XUFN11:	LDA NEST
	BNE XUFN6	;Can't tail recurse if NEST>0.
	LDA LEVNUM
	ORA LEVNUM+1	;Can't tail recurse from toplevel.
	BEQ XUFN6
XUFN2:	LDA LASLIN
	BNE XUFN3
	LDA TOKPTR+1	;On last line, see if on last token.
	BNE XUFN5	;Not on last token. See if token is STOP or ELSE
	JMP XUFN1B	;On last token.  Tail-recurse.

XUFN3:	LDA TOKPTR+1	;Not on last line
	BEQ XUFN6	;End of line, don't tail-recurse
	LDY #$00	;else see if next token is STOP
	LDA (TOKPTR),Y
	TAX
	INY
	LDA (TOKPTR),Y
	JMP XUFN1A

XUFN5:	LDY #$00
	LDA (TOKPTR),Y
	TAX
	INY
	LDA (TOKPTR),Y
XUFN1:	CPX ELSE
	BNE XUFN1A
	CMP ELSE+1
	BEQ XUFN1B
XUFN1A:	CPX STOP
	BNE XUFN6
	CMP STOP+1
	BNE XUFN6
XUFN1B:	GETTYP FBODY
	STA UFRMAT
	MOV SP,XFRAME
	JMP XTAIL
XUFN6:	GETTYP FBODY
	STA UFRMAT
	LDX FRAME
	LDY FRAME+1
	MOV FRAME,SP	;FRAME points to previous frame
	JSR PUSH
	PUSH XFRAME
	PUSHB UFRMAT
	PUSH CURTOK
	PUSHB NEST
	PUSHB IFTEST
	PUSH TOKPTR
	LDX NARGS
	INX
	TXA
	JSR PUSHB	;Push (NARGS)+1 (+1 is for ufun binding)
	PUSH TLLEVS
	PUSHB IFLEVL
	LDY #$00
	LDA (FUNCT),Y
	TAX
	INY
	STY IFTEST	;Default is FALSE (nonzero)
	LDA (FUNCT),Y
	TAY
	JSR PUSH
	LDX FUNCT
	LDY FUNCT+1
	INX
	JSR PUSH	;Push FUNCT+1
	LDY #$01
	STY TLLEVS
	DEY
	STY TLLEVS+1
	DEY
	STY NEST
	INC LEVNUM
	BNE XUFN6C
	INC LEVNUM+1
	BNE XUFN6C
	LDX #XPNEST
	JMP EXCED	;Procedure nesting too deep
XUFN6C:	INY		;Y is -1 here
	LDA FRAME
	STA (FUNCT),Y
	INY
	LDA FRAME+1
	STA (FUNCT),Y
	JSR STPTR1	;VSPPTR := VSP + (NARGS * 2)
	JSR GETALN
	JSR NWBNDS
	LDA SP
	STA XFRAME	;XFRAME points to location after last binding pair
	LDA SP+1
	STA XFRAME+1
	JSR INCVSP
;	...
.PAGE
;	Local variable block:

LINPTR	=TEMPN8		;Fpacked line ptr.
ENDPTR	=TEMPX2		;Fpacked line-end ptr.

;UF1 does a line of the procedure.
;	...
UF1:	LDA GOPTR+1
	BEQ UF1A
	MOV FPTR,GOPTR	;GOPTR <> NIL, so FPTR := GOPTR, reset GOPTR.
	LDA #$00
	STA GOPTR+1
	BEQ UF1C	;(Always)
UF1A:	LDX #FPTR
	JSR ULNADV
UF1C:	LDA STPFLG
	BNE UF2A
	LDA FPTR+1
	BEQ UF2
UF1D:	LDY #FPTR
	LDX #TOKPTR
	JSR GETULN
	PUSHA UF1
	LDA TRACE
	BEQ UF1E
	CAR LINPTR,FPTR
	LDA UFRMAT	;In TRACE mode, so print the line
	BEQ UF1TCL
	CDR ENDPTR,FPTR	;Type FPACK
	JSR TPLINF
	JMP UF1TC2
UF1TCL:	LDA #$20	;Type LIST
	JSR TPCHR
	LDX #LINPTR
	JSR LTYPE1
UF1TC2:	JSR RDKEY	;Get a character
	JSR CKINTZ
	BCC UF1TC2	;Get another if intercepted, else continue
	JSR BREAK1
UF1E:	JMP EVLINE

	;Local variable block:
ATMNAM	=TEMPN8

;End of a procedure.
UF2:	LDA STPFLG
	BNE UF2A
	STA OTPUTN
UF2A:	SEC
	LDA LEVNUM
	SBC TLLEVS
	STA LEVNUM
	LDA LEVNUM+1
	SBC TLLEVS+1
	STA LEVNUM+1
	LDA #$00
	STA STPFLG
	LDA TRACE
	BEQ UF3
	PRTSTR TRACM2	;"Ending "
	LDY #SFTOKN	;Frame UFUN (CURTOK) index
	LDA (FRAME),Y
	STA ATMNAM
	INY
	LDA (FRAME),Y
	STA ATMNAM+1
	LDX #ATMNAM
	JSR LTYPE	;a=???
	JSR BREAK1
UF3:	JSR POPFRM	;Pop the ufun's stack frame, restoring bindings
	POPB RUNFLG
	POP FPTR
	POP FBODY
	POPB UFRMAT
	POP ULNEND
	JMP POPJ
.PAGE
;	Local variable block:
VSPPTR	=TEMPX1		;VSP pointer (shared: UFUNCL,XTAIL,NWBNDS,STPTR1,SPRNT,SWORD)
BNDNGS	=ANSN3		;No. of ufun bindings
ARGLST	=TEMPN8		;Arglist pointer for bindings (shared: UFUNCL,XTAIL,NWBNDS,GETALN)
VARNAM	=TEMPN7		;Binding name (shared: UFUNCL,XTAIL,NWBNDS)
TMPVAL	=TEMPN6		;Binding value (shared: UFUNCL,XTAIL,NWBNDS,TRCBND)
FRAMEP	=TEMPX2		;Frame pointer (for Funct/Frame pair)

;Tail-recursive ufun handler.
XTAIL:	LDA #$FF
	STA NEST
	INC LEVNUM
	BNE XTAIL1
	INC LEVNUM+1
	BNE XTAIL1
	LDX #XPNEST
	JMP EXCED	;Procedure nesting too deep
XTAIL1:	INC TLLEVS
	BNE XTAIL2
	INC TLLEVS+1
	BNE XTAIL2
	LDX #XTNEST	;Tail-recursion nesting too deep
	JMP EXCED
XTAIL2:	JSR STPTR1
	LDY #SFNRGS	;Frame index for Number-of-bindings
	LDA (FRAME),Y
	STA BNDNGS
	JSR GETALN
	LDY #SFFRMT	;Frame index for Format
	LDA UFRMAT
	STA (FRAME),Y
	LDY #SFTOKN	;Frame index for UFUN (CURTOK)
	LDA CURTOK
	STA (FRAME),Y
	INY
	LDA CURTOK+1
	STA (FRAME),Y
	LDY #SFFRAM	;Frame index for FRAME
	LDA (FUNCT),Y
	CMP FRAME
	BNE XTALWB
	INY
	LDA (FUNCT),Y
	CMP FRAME+1
	BNE XTALWB
XTALWA:	LDA ARGLST+1
	BEQ XTLWAE
	CAR VARNAM,ARGLST
	LDX #ARGLST
	JSR TTKADV
	CAR TMPVAL,VSPPTR
	JSR TRCBND
	DEC2 VSPPTR
	LDX #TMPVAL
	LDY #VARNAM
	JSR PUTVAL
	JMP XTALWA
XTLWAE:	LDY #SFNRGS	;Frame index for Number-of-bindings
	LDA BNDNGS
	STA (FRAME),Y
	LDA TRACE
	BEQ XTAIL4
	JSR BREAK1
	JMP XTAIL4
XTALWB:	JSR NWBNDS
XTLWBE:	CAR FRAMEP,FUNCT
	PUSH FRAMEP
	LDX FUNCT
	LDY FUNCT+1
	INX
	JSR PUSH	;Push FUNCT+1
	RPLACA FUNCT,FRAME
	LDY #SFNRGS	;Frame index for Number-bindings
	SEC		;Carry added in (BINDINGS + NARGS + 1)
	LDA BNDNGS
	ADC NARGS
	STA (FRAME),Y
	MOV XFRAME,SP	;XFRAME := SP (right above last binding pair)
XTAIL4:	JSR INCVSP
	JMP UF1
.PAGE
;	Local variable block:
VSPPTR	=TEMPX1		;VSP pointer (shared: UFUNCL,XTAIL,NWBNDS,STPTR1,SPRNT,SWORD)
ARGLST	=TEMPN8		;Arglist pointer for bindings (shared: UFUNCL,XTAIL,NWBNDS,GETALN)
VARNAM	=TEMPN7		;Binding name (shared: UFUNCL,XTAIL,NWBNDS)
TMPVAL	=TEMPN6		;Binding value (shared: UFUNCL,XTAIL,NWBNDS,TRCBND)

NWBNDS:	LDA ARGLST+1
	BEQ NWBNDR
	CAR VARNAM,ARGLST
	LDX #ARGLST
	JSR TTKADV
	LDY #VARNAM
	LDX #TMPVAL
	JSR GETVAL
	PUSH TMPVAL
	CAR TMPVAL,VSPPTR
	JSR TRCBND
	DEC2 VSPPTR
	LDX #TMPVAL
	LDY #VARNAM
	JSR PUTVAL
	PUSH VARNAM
	JMP NWBNDS
NWBNDR:	LDA TRACE
	BEQ NWBRTS
	JMP BREAK1

;	Local variable block:
VSPPTR	=TEMPX1		;VSP pointer (shared: UFUNCL,XTAIL,NWBNDS,STPTR1,SPRNT,SWORD)

STPTR1:	LDA NARGS
	ASL A
	ADC VSP
	STA VSPPTR
	LDA VSP+1
	ADC #$00
	STA VSPPTR+1	;VSPPTR := VSP + (NARGS * 2)
NWBRTS:	RTS

INCVSP:	LDA NARGS
	ASL A
	ADC VSP
	STA VSP
	BCC INCVE
	INC VSP+1	;VSP := VSP + NARGS * 2
INCVE:	RTS

;	Local variable block:
TMPVAL	=TEMPN6		;Binding value (shared: UFUNCL,XTAIL,NWBNDS,TRCBND)

;Print out binding value if in TRACE mode.
TRCBND:	LDA TRACE
	BEQ INCVE
	LDA #$20
	JSR TPCHR
	LDX #TMPVAL
	JMP LTYPE0	;(Type toplevel list brackets)
.PAGE
;	Local variable block:
ERRNM1	=ANSN4		;Error number
ERRY	=ANSN3		;Error X ptr. (shared: ERROR1,ERROR)

;Error-handler exit routine.
ERROR1:	LDX #$00
	STX RUNFLG
	LDA ERRNUM
	STA ERRNM1
	STX ERRNUM
	CMP #XZAP
	BEQ PPTTP	;XZAP is fatal, always return to toplevel
	CMP #XBRK
	BEQ ENTLOP	;A Pause, go to Break-loop handler
	LDA BRKSP+1
	BEQ PPTTP	;Non-fatal, but not inside a break-loop, go to toplevel
	JMP BRKENT	;Non-fatal, inside a Break-loop, so re-enter it
PPTTP:	LDA FRAME+1
	BEQ PPTT2
	JSR UNWFRM	;unwind one frame, restoring bindings, frame, and xframe.
	JMP PPTTP
PPTT2:	LDA #$00
	STA LEVNUM
	STA LEVNUM+1
	LDA ERRNM1
	CMP #XZAP
	BNE JTOP
	LDA ERRY
	CMP #XNSTRN
	BNE JTOP
	SETV VSP,VPDLBA	;If error was "out-of-nodes", reset VPDL, do a garbage collect,
	JSR GARCOL	;and check remaining nodes. If low, ask user to delete something.
	LDA NNODES+1
	CMP #NODLIM^
	BCC JTOP
	BNE NWARN
	LDA NNODES
	CMP #NODLIM&$FF
	BCC JTOP
NWARN:	PRTSTR WRNMSG	;"Please delete something"
JTOP:	JMP TOPLOP
ENTLOP:	PUSH ULNEND	;Push the state where the PAUSE occurred
	PUSH FBODY
	PUSH FPTR
	PUSHB RUNFLG
	PUSH TOKPTR
	PUSHB OTPUTN
	PUSHB IFLEVL
	PUSHB EXPOUT
	PUSHB STPFLG
	PUSHB UFRMAT	;That should be enough
	PUSH BRKSP	;Now push the Break-frame SP for the last level
	MOV BRKSP,SP	;and compute the new one
;	...
.PAGE
;Break-loop error handler.
;	...
BRKLOP:	LDA COFLAG
	BEQ ERR2A
	DEC COFLAG	;Nonzero means break out, so reset it
	POP BRKSP	;Exit this Break-loop, pop back last one
	POPB UFRMAT	;Pop back the state at which the PAUSE occurred
	POPB STPFLG
	POPB EXPOUT
	POPB IFLEVL
	POPB OTPUTN
	POP TOKPTR
	POPB RUNFLG
	POP FPTR
	POP FBODY
	POP ULNEND	;And that's the state
	JMP EVLINE	;Go back where you came from
ERR2A:	LDA #'L		;Both flags = 0, it's a Pause.
	JSR TPCHR	;Type an "L"
	LDX #LEVNUM
	JSR TYPFIX
	LDA #QPRMPT
	JSR PGTLIN	;Get a line (with prompt)
	LDX #TOKPTR
	JSR PRSLIN	;Parse it
ERR2A2:	PUSHA BRKLOP
	LDA #LIST
	STA UFRMAT
	LDA #$00
	STA FBODY+1	;Tells ERROR that we're now at toplevel of a break-loop
	JMP EVLINE
;Re-enter a Break-loop from a non-fatal error. Unwinds successive stack frames of
;all frames above BRKSP, and resets SP to top of break-frame.
BRKENT:	LDA FRAME+1	;See if FRAME is smaller than BRKSP
	CMP BRKSP+1
	BCC BRKDN	;Yes, done
	BNE BRKUWF	;Larger, continue
	LDA FRAME
	CMP BRKSP
	BCC BRKDN	;Smaller, done
BRKUWF:	JSR UNWFRM	;Unwind the frame, restoring FRAME, XFRAME, and variable bindings.
	JMP BRKENT
BRKDN:	MOV SP,BRKSP	;Bindings restored, restore SP
	JMP ERR2A	;Re-enter the break-loop
.PAGE
.SBTTL	Parser

;	Local variable block:
LINPTR	=TEMPX2		;Addr. of ptr. to returned list (shared: PRSLIN,ALLSTC)
CELTYP	=TEMPX2+1	;Type of cell for next token (shared: PRSLIN,ALLSTC)
NEWCEL	=TEMPN		;Temp. ptr. to new token cell (shared: PRSLIN,ALLSTC)
FUNPNM	=TEMPN7+1	;Funny-pname or comment if nonzero (shared: PRSLIN,SELFDL)
LSNEST	=TEMPN8		;List nesting counter (shared: PRSLIN,POPLST,SELFDL)
TEMP	=TEMPN1		;List ptr. discard
TOKTYP	=ANSN3		;Type of current token being processed (shared: PRSLIN,SELFDL)
QUOTED	=TEMPN4+1	;Current token is a quoted atom if nonzero (shared: PRSLIN,SELFDL)
TKNPTR	=TEMPX1		;Ptr. to final (interned) token
PTRTMP	=TEMPN2		;Temp. char. ptr. during number-parsing
STRPTR	=TEMPN6		;Token pname ptr.
LNKLST	=TEMPX1		;Pname cell link
NXTLNK	=TEMPN5		;Newest pname cell
ENDPNM	=ANSN4		;Nonzero signal end-of-pname consing
CHARS	=TEMPN		;String characters

SCRO1:	SETV OTPDEV,COUT	;always to screen, but restore afterwards.
	RTS
PGTLIN:	PHA
	JSR SCRO1
	PLA
	JSR TPCHR
GETLIN:	LDX #$00
	JSR SCRO1
GETL1:	LDA LINARY,X	;Transfer the LINARY
	STA PRSBUF,X	;Into the PRSBUF
	INX
	BNE GETL1
	JSR GETLN	;Get a line into the Parse buffer
	LDX #$00
GETL2:	LDA PRSBUF,X	;Transfer the PRSBUF
	STA LINARY,X	;Into the LINARY
	INX
	BNE GETL2
	SETV PLINE,LINARY	;Parse line at LINARY
	JMP SETVID	;reset to whatever output device was in use.

PARSTR:	GETY PLINE
PRSLIN:	STX LINPTR	;Input line returned list pointer location
	LDA #$00
	STA $01,X	;Initialize parse-list to nil
	STA LSNEST	;List-nesting counter
	STA MARK1+1	;List-pointer
	STA FUNPNM	;Zero FUNPNM initially
	INC PRSFLG	;Tells CONS we're in the parser (if nonzero)
	LDA #NEWLIN
	STA CELTYP	;Current cell type
NXTOKN:	LDA #$00
	STA TOKTYP	;No typecode yet (for SELFDL)
	STA QUOTED	;Indicates quoted atom if non-zero
	LDX FUNPNM
	BMI JNTNM1	;If funny-pname negative, rest is comment
	STA FUNPNM	;Else zero funny-pname
TGT1:	JSR PSPACP
	BEQ TGT1
	BNE TGT2

PSPACP:	LDY #$00	;See if next character is a space, and INC1 PLINE if so.
	LDA (PLINE),Y
	CMP #$20
	BNE PSPRTS	;Return with z clear when not a space.
	INC1 PLINE
	LDA #$00	;Return with z set when a space was passed over.
PSPRTS:	RTS

RDLNWE:	JSR POPLST
	LDA #$00
	STA MARK1+1
	STA PRSFLG
	RTS
JNTNM1:	JSR ALLSTC	;A comment now, make a new cell, then cons a string
;JNTNUM:	;In a list, everything's an string
;Everything in a list is a string my ass.  This was totally useless and
;is only part of the plot to make Logo use more memory.
	LDA #STRING
	STA TOKTYP
	JMP NOTNUM
TGT2:	CMP #$0D
	BEQ RDLNWE
	CMP #']
	BEQ TKRBR
	PHA
	JSR ALLSTC
	PLA
	CMP #'[
	BEQ TKLBR
	JSR SELFDL	;SELFDL knows that nothing is self-delimiting inside a list.
	BCC TKNDL
	INC PLINE	;Delimiter, advance to next char.
	BNE TKDLM
	INC PLINE+1
TKDLM:	STA CHARS
	LDA #$00
	STA CHARS+1
	CONS STRPTR,CHARS,0,STRING	;cons up a pname
	LDA #ATOM
	STA TOKTYP
	LDA CHARS
	CMP #$3B	;(Semicolon)
	BNE JADDTK
	DEC FUNPNM	;If semicolon (comment), decrement (to -1) to indicate comment
	JSR PSPACP	;Flush one space after a semicolon if there is one.
JADDTK:	JMP ADDTOK
TKLBR:	INC LSNEST	;Start list - increment list nesting counter
	INC1 PLINE	;Skip to next character
	PUSH MARK1	;Push the list-pointer cell
	LDA #NEWLST
	STA CELTYP	;Next cell allocated will be New-list type
	JMP NXTOKN	;Continue processing line
TKRBR:	DEC LSNEST	;End list - decrement list nesting counter
	BMI TKRBR2	;Error if unbalanced brackets
	INC1 PLINE	;Skip to next character
	POP MARK1	;Pop list pointer
	LDA #REGCEL
	STA CELTYP
	JMP NXTOKN	;Continue processing line
TKRBR2:	PRTSTR RDRER2	;Print "Ignoring unmatched bracket" warning
	INC LSNEST	;Reset brackets counter
	INC1 PLINE	;Skip this bracket
	JMP NXTOKN
TKNDL:	CMP #'"		;Token is not a delimiter
	BNE TGT3A
	INC QUOTED	;Quoted atom
	INC1 PLINE
	LDA #QATOM
	STA TOKTYP
	JMP TGT3B1	;Check for funny-pname
TGT3A:	CMP #$27	;(Single Quote)
	BNE TGT3B
	INC1 PLINE
	INC FUNPNM	;Token is a funny-pname
TKAORL:	LDA #ATOM	;Token is an Atom or Label
	STA TOKTYP
	JMP TKATOM	;Tokenize it
TGT3B:	CMP #':
	BNE TKAORL
	INC1 PLINE	;Dotted atom, skip to next character
	LDA #DATOM
	STA TOKTYP
TGT3B1:	LDY #$00
	LDA (PLINE),Y
	CMP #$27	;(funny pname single-quote ('))
	BNE TKATOM
	INC FUNPNM	;Token is funny-pname
	INC PLINE
	BNE TKATOM
	INC PLINE+1
TKATOM:	LDY #$00
	LDA (PLINE),Y
	CMP #$0D	;Check for empty word at end-of-line
	BEQ EMPTWD
	LDX FUNPNM
	BNE NOTNUM	;Funny-pname, not fixnum then
TKATM1:	JSR SELFDL
	BCS EMPTWD	;Delimiter encountered immediately, so empty word
	LDA TOKTYP
	CMP #ATOM
	BNE NOTNUM	;Only atoms can be numbers now
	JSR CNUML0	;Attempt to compute numerical value, clear indicators
	MOV PTRTMP,PLINE	;Save temporary character pointer
ATM1:	LDY #$00
	LDA (PLINE),Y
	CMP #$0D
	BEQ ATM2	;End of line encountered, must be numerical
	JSR SELFDL
	BCC ATM1A	;Continue if not self delimiter
	LDA TOKTYP
	CMP #LATOM
	BNE ATM2	;Self delimiter, not colon, so clean up
	BEQ NTNUMA	;(Always) It's a label, treat it as a word
EMPTWD:	LDA #STRPTR
	JSR MAKMTW	;Make STRPTR point to the empty word
	JMP ADDTOK	;and link it (intern it)
ATM1A:	JSR CNUML1	;Process the next digit
	BCC NOTNMX	;Carry clear means not a number
	INC PLINE	;Get next digit
	BNE ATM1
	INC PLINE+1
	BNE ATM1	;(Always)
ATM2:	JSR CNUML2	;Finish numerical processing (type in A)
	BCC NOTNMX
	LDX #TKNPTR
	STX NODPTR
	LDX #NARG1+2		;High word
	LDY #NARG1		;Low word
	JSR FICONS		;Cons a numerical cell with the value in it. Type in A.
	RPLACA MARK1,TKNPTR	;Link the cell on to the input line
	JMP NXTOKN		;Continue processing line
NTNUMA:	LDA #ATOM
	STA TOKTYP	;Don't say it's a label yet
NOTNMX:	MOV PLINE,PTRTMP	;Not a number, reset real character pointer
NOTNUM:	LDX #LNKLST	;cons up a pname (original pointer)
	LDA #$00
	STA STRPTR+1	;Zero pointer in case it's nil
	STA ENDPNM	;Indicates end of pname if non-zero
	PHA		;First time around, push zero
	BEQ NXTCHS	;(Always)
NXTTWO:	LDA ENDPNM	;Next two characters
	BNE ADDTOK	;Link up token if end of pname
	LDA #$02
	PHA		;Not first time around, push 2
	LDX #NXTLNK	;Next pointer
NXTCHS:	STX NODPTR
	LDY #$00
	LDA (PLINE),Y
	CMP #$0D
	BEQ ADDTK1	;Finish token (end of line), even no. chars.
	STA CHARS	;First character in pair
	JSR SELFDL
	BCS ADDTK1	;Finish token (delimiter hit), even no. chars.
	INC1 PLINE	;Skip to next character
	LDY #$00
	LDA (PLINE),Y
	CMP #$0D
	BEQ FINTK1	;Finish token (end of line), odd no. chars.
	STA CHARS+1	;Second character in pair
	JSR SELFDL
	BCS FINTK1	;Finish token (delimiter hit), odd no. chars.
	INC PLINE
	BNE CNSSTR
	INC PLINE+1
	BNE CNSSTR	;(Always) Cons new pair on to pname string
FINTK1:	LDA #$00
	STA CHARS+1	;Odd no. chars. in pname, zero last character
	INC ENDPNM	;Indicates end of pname
CNSSTR:	LDY #CHARS
	LDX #$00
;	LDA #STRING
	JSR STCONS	;Cons up the new pname pair
	PLA
	TAY		;0 first time, 2 otherwise
	BNE NTFRST
	LDA LNKLST
	STA (MARK1),Y	;(Linking garbage-collect-protects it)
	STA STRPTR	;Atom pointer
	INY
	LDA LNKLST+1
	STA (MARK1),Y
	STA STRPTR+1
	JMP NXTTWO	;Continue making the pname
NTFRST:	LDA NXTLNK	;Link cell onto pname string
	TAX
	STA (LNKLST),Y
	INY
	LDA NXTLNK+1
	STA (LNKLST),Y
	STA LNKLST+1
	STX LNKLST
	JMP NXTTWO	;Continue making the pname
ADDTK1:	PLA		;Pop chain indicator if loop exit
ADDTOK:	LDA TOKTYP
	CMP #STRING
	BEQ ADDSTR	;Don't intern strings
	LDX #STRPTR
	LDY #TKNPTR
	JSR INTERN	;Intern atom
	LDA TOKTYP
	CMP #ATOM
	BEQ LNKATM
	LDX #TKNPTR
	JSR PUTTYP	;Give atom a type if not Atom
LNKATM:	RPLACA MARK1,TKNPTR	;Link atom onto input line
	LDA FUNPNM
	BMI NXTE
	BEQ NXTE
	LDA TKNPTR
	AND #$FC
	STA TKNPTR
	CDRME TKNPTR
	LDY #$02
	LDA (TKNPTR),Y
	ORA #$01
	STA (TKNPTR),Y
NXTE:	JMP NXTOKN	;Continue processing line
ADDSTR:	RPLACA MARK1,STRPTR	;Link up a string (either list element or comment)
	LDA FUNPNM
	BEQ NXTE
	JMP RDLNWE	;Funny-pname set, so it's a comment, nothing else on line

;	Local variable block:
LSNEST	=TEMPN8		;List nesting counter (shared: PRSLIN,POPLST,SELFDL)
TEMP	=TEMPN1		;List ptr. discard

POPLST:	LDA LSNEST
	BEQ PLRTS
POPLS1:	LDA INPFLG
	BNE RDL1A2
	LDA #']		;Close the list (unless in read-eval loop)
	JSR TPCHR
RDL1A2:	POP TEMP
	DEC LSNEST	;Decrement list nesting counter
	BNE POPLS1
	LDA INPFLG
	BNE PLRTS
	JMP BREAK1
.PAGE
;	Local variable block:
LINPTR	=TEMPX2		;Addr. of ptr. to returned list (shared: PRSLIN,ALLSTC)
CELTYP	=TEMPX2+1	;Type of cell for next token (shared: PRSLIN,ALLSTC)
NEWCEL	=TEMPN		;Temp. ptr. to new token cell (shared: PRSLIN,ALLSTC)

ALLSTC:	CONS NEWCEL,0,0,LIST	;Allocate a new list cell
	LDY #$00
	LDA CELTYP
	CMP #NEWLIN
	BNE ALSTC1
	LDX LINPTR	;New line, ANS pointer points to cell
	PUTX NEWCEL
	JMP ALSTC3
ALSTC1:	CMP #NEWLST
	BEQ ALSTC4	;For new-list, rplaca onto input line
	INY		;Regular cell, link onto input line
	INY
ALSTC4:	LDA NEWCEL
	STA (MARK1),Y	;Rplaca or Rplacd for new-list or regular-cell
	INY
	LDA NEWCEL+1
	STA (MARK1),Y
ALSTC3:	MOV MARK1,NEWCEL	;New input line end pointer
	LDA #REGCEL
	STA CELTYP	;Next cell allocated will be regular-cell
PLRTS:	RTS
.PAGE
;	Local variable block:
FUNPNM	=TEMPN7+1	;Funny-pname or comment if nonzero (shared: PRSLIN,SELFDL)
LSNEST	=TEMPN8		;List nesting counter (shared: PRSLIN,POPLST,SELFDL)
TOKTYP	=ANSN3		;Type of current token being processed (shared: PRSLIN,SELFDL)
QUOTED	=TEMPN4+1	;Current token is a quoted atom if nonzero (shared: PRSLIN,SELFDL)

SELFDL:	LDX FUNPNM
	BMI DIGN	;If comment, nothing's a delimiter
	LDX LSNEST
	BNE SLF2A	;Treat list elements like Qatoms
	LDX PRSFLG
	BMI SLF2A	;(Also if REQUEST set PRSFLG negative)
	LDX FUNPNM
	BEQ SLF2	;Not funny-pname
	CMP #$27	;If funny-pname, look for quote
	BNE DIGN	;Not delimiter if no quote
	INC1 PLINE	;Skip quote always
	LDY #$00
	LDA (PLINE),Y
	CMP #$27	;Look for pair of quotes
	BEQ DIGN	;If pair, not delimiter (one skipped)
	JMP DIGY	;If no pair, the quote is a delimiter (skipped)
SLF2:	LDX QUOTED	;Check for quoted atom
	BEQ SLF1
SLF2A:	CMP #$20	;Quoted atoms can be terminated by a space,
	BEQ DIGY
	CMP #']		;or a closing bracket,
	BEQ DIGY
	CMP #'[
	BEQ DIGY
	BNE DIGN	;(Always)
SLF1:	LDX TOKTYP	;Check for type Atom
	CPX #ATOM
	BNE SLF3
	CMP #':		;If Atom, check for colon (for Label atom)
	BNE SLF3
	INC1 PLINE	;If colon, skip over it and change type to Latom
	LDX #LATOM
	STX TOKTYP
	JMP DIGY
DIGN:	CLC
	RTS
SLF3:	CMP #$20	;Compare character to all delimiters
	BEQ DIGY
	CMP #'<
	BEQ DIGY
	CMP #'>
	BEQ DIGY
	CMP #'=
	BEQ DIGY
	CMP #$3B	;(Semicolon)
	BEQ DIGY
	CMP #')
	BEQ DIGY
	CMP #'(
	BEQ DIGY
	CMP #'+
	BEQ DIGY
	CMP #'-
	BEQ DIGY
	CMP #'*
	BEQ DIGY
	CMP #'/
	BEQ DIGY
	CMP #']
	BEQ DIGY
	CMP #'[
	BNE DIGN
DIGY:	SEC		;Carry set means true
	RTS
.PAGE
PARSEL:	SETV OTPDEV,CRUNP	;Here we have to dump and reparse the ARG1 list before
	SETV PLINE,PRSBUF	;evaluating it. First make the output routine CRUNP,
	LDX #ARG1		;which dumps output into the Line-array. Init PLINE for CRUNP
	JSR LTYPE1		;Dump line, don't type outer brackets!
	LDA #$0D		;Store CR without checking limit
	JSR CRUNP1
	LDA #$00
	JSR RSTIO1		;Reset the output routine (don't zap INPFLG)
	SETV PLINE,PRSBUF	;Reset PLINE to beginning of buffer
	LDX #TOKPTR
	JSR PRSLIN	;Parse the line
	LDA #$0D	;Null the PRSBUF
	STA PRSBUF
	RTS

CRUNP:	LDX PLINE
	CPX #PRSLIM&$FF
	BNE CRUNP1
	LDX PLINE+1
	CPX #PRSLIM^
	BNE CRUNP1
	PRTSTR BUFEXC	;Print "Buffer exceeded" warning, ignore rest of line
	RTS
CRUNP1:	STY YSAV1
	LDY #$00
	STA (PLINE),Y
	INC1 PLINE
	LDY YSAV1
	RTS
.PAGE
.SBTTL	Number Parsing Utilities

;	Local variable block:
FLMODE	=TEMPN5		;Indicates mode (shared: CNUML1,CNUML2,CNUML0)
EXPSGN	=TEMPN5+1	;Sign of exponent, nonzero=negative (shared: CNUML1,CNUML2,CNUML0)
ADIGIT	=TEMPN6+1	;Indicates prescence of a digit (shared: CNUML1,CNUML2,CNUML0)
SAVNUM	=A1L		;Temp. number storage

;Process a character, number-building
CNUML1:	LDX FLMODE	;Flonum indicator
	BNE NFLDIG	;Process next flonum character
	JSR DIGITP	;Still a fixnum
	BCC NTFIX1	;Not a digit, isn't a fixnum then
	INC ADIGIT	;Indicate presence of digit
	PHA		;Save digit
	JSR NMROL1	;Multiply by 2 first
	BMI NTFIX3	;Not a fixnum if value overflow
	LDY #SAVNUM
	JSR XN1TOY	;Copy doubled number
	JSR NMROL1	;Multiplied by 4
	BMI NTFIX2
	JSR NMROL1	;Multiplied by 8
	BMI NTFIX2
	JSR ADDNUM	;Multiplied by 10.
	BMI NTFIX2
	PLA
	PHA
	JSR ADDDIG	;Add value of current digit to subtotal
	BMI NTFIX2
	PLA		;Retrieve digit
NUMOK:	SEC		;Indicate number OK
	RTS
NTFIX2:	LDY #SAVNUM
	JSR XYTON1	;Fixnum overflow, doubled number is in SAVNUM, transfer
NTFIX3:	JSR NMROR1	;Halve it
	INC FLMODE	;Indicate flonum (1)
	JSR FLOTN1	;Convert to floating pt.
	PLA		;Get the digit back
FADNML:	INC ADIGIT	;Indicate prescence of digit
	JSR MULN10	;Shift number before adding
	BCS NTNUM	;Balk if overflow
	JSR FADDIG	;Add it to the number (left of point)
	JMP NUMOK
FNDIGD:	INC ADIGIT	;Indicate presence of digit
	JSR FADDGN	;Add it to the number (right of point)
	JMP NUMOK
NFLDIG:	CPX #$02	;New flonum digit
	BNE NFLDG1
	JSR DIGITP	;In decimal mode
	BCS FNDIGD	;If digit, add to number
	BCC FCKEN	;Else check for E or N
NFLDG1:	CPX #$03	;See if exponent mode
	BEQ FXDIG
	JSR DIGITP	;Normal mode, check for digit
	BCS FADNML	;Add it if it is, else
NTFIX1:	CMP #'.		;See if digit is legal
	BEQ FMDECI
FCKEN:	CMP #'E		;Check for E or N
	BEQ FXPOS
	CMP #'N
	BNE NTNUM
	INC EXPSGN	;Indicate negative exponent
FXPOS:	LDA ADIGIT
	BEQ NTNUM	;Check that a digit was typed (so ".Ex" is illegal)
	LDX FLMODE
	LDA #$03
	STA FLMODE	;Indicate exponent mode (3)
	LDA #$00
	STA ADIGIT	;Now, indicates exponent digit presence
	BEQ MAKFLO	;(Always)
FXDIG:	JSR DIGITP	;Exponent mode, must be a digit
	BCC CNMR
	INC ADIGIT	;Indicate presence of exponent digit
	JSR INCEXP	;Exponentiate by vA
	JMP NUMOK
FMDECI:	JSR FMDC1
	LDX FLMODE
	LDA #$02
	STA FLMODE	;Indicate decimal mode (2)
MAKFLO:	TXA
	BNE NUMOK	;Exit OK if flonum, else...
	JSR FLOTN1	;make it one
	JMP NUMOK
NTNUM:	CLC		;Not a number
CNMR:	RTS

DIGITP:	CMP #':		;Checks to see if character is a digit (0-9)
	BCC DIGP1
	CLC		;Carry clear means not digit
	RTS
DIGP1:	CMP #'0		;(Sets carry correctly)
	RTS

FMDC1:	SETNUM NARGX,FLT1	;Decimal mode, set up place divisor (10.)
	RTS

FLT1:	$80
	$40
	$00
	$00

FLT10:	$83	;Floating-point constant, 10.0
	$50
	$00
	$00
.PAGE
;	Local variable block:
FLMODE	=TEMPN5		;Indicates mode (shared: CNUML1,CNUML2,CNUML0)
EXPSGN	=TEMPN5+1	;Sign of exponent, nonzero=negative (shared: CNUML1,CNUML2,CNUML0)
ADIGIT	=TEMPN6+1	;Indicates prescence of a digit (shared: CNUML1,CNUML2,CNUML0)
EXP	=TEMPX1		;Exponent (CNUML2,CNUML0,INCEXP)

;Number gobbled, finish number-building.
CNUML2:	LDX FLMODE
	BEQ CNUM2X
	LDA ADIGIT	;If floating pt., make sure that there's a digit
	BEQ NTNUM
	LDA EXP		;Check for exponent
	BEQ CNUM2R
	LDY #SAVNUM
	JSR XN1TOY	;Save number
	JSR FMDC1	;Setup divisor/multiplier (to 1.)
	LDY #NARGX
	JSR XYTON1	;and put in NARG1
CNUM2C:	JSR MULN10	;Multiply by 10 according to exponent value
	BCS NTNUM
	DEC EXP
	BNE CNUM2C
	LDY #SAVNUM	;Put number in NARG2
	JSR XYTON2
	LDA EXPSGN	;Check its sign
	BEQ CNUM2M
	JSR FDIVX	;Divide by divisor (NARG2/NARG1)
	BCS NTNUM
	BCC CNUM2R	;(Always)
CNUM2M:	JSR FMUL	;Mulyiply by multiplier
	BCS NTNUM
CNUM2R:	LDA #FLO
	SEC
	RTS
CNUM2X:	LDA #FIX
	SEC
	RTS

;	Local variable block:
FLMODE	=TEMPN5		;Indicates mode (shared: CNUML1,CNUML2,CNUML0)
EXPSGN	=TEMPN5+1	;Sign of exponent, nonzero=negative (shared: CNUML1,CNUML2,CNUML0)
ADIGIT	=TEMPN6+1	;Indicates prescence of a digit (shared: CNUML1,CNUML2,CNUML0)
EXP	=TEMPX1		;Exponent (CNUML2,CNUML0,INCEXP)

ZNARG1:	LDA #$00
	STA NARG1
	STA NARG1+1
	STA NARG1+2
	STA NARG1+3
	RTS

ZNARG2:	LDA #$00
	STA NARG2
	STA NARG2+1
	STA NARG2+2
	STA NARG2+3
	RTS

CNUML0:	JSR ZNARG1	;Initialize number to 0
	STA FLMODE	;Flonum indicator
	STA EXPSGN	;Exponent sign indicator
	STA ADIGIT	;Indicates the presence of a mant. or exp. digit
	STA EXP		;Exponent counter
	RTS
.PAGE
NMROL1:	ASL NARG1	;Double number in NARG1
	ROL NARG1+1
	ROL NARG1+2
	ROL NARG1+3
	RTS

NMROR1:	LSR NARG1+3	;Halve number in NARG1
	ROR NARG1+2
	ROR NARG1+1
	ROR NARG1
	RTS

XN1TOY:	LDX #$FC
XN1YL:	LDA NARG1+4,X
	STA $00,Y
	INY
	INX
	BMI XN1YL
	RTS

XYTON1:	LDX #$FC
XYN1L:	LDA $00,Y
	STA NARG1+4,X
	INY
	INX
	BMI XYN1L
	RTS

XYTON2:	LDX #$FC
XYN2L:	LDA $00,Y
	STA NARG2+4,X
	INY
	INX
	BMI XYN2L
	RTS

XN2TOY:	LDX #$FC
XN2YL:	LDA NARG2+4,X
	STA $00,Y
	INY
	INX
	BMI XN2YL
	RTS

ADDNUM:	LDX #$FC	;Add SAVNUM to NARG1
	CLC
ADDNML:	LDA SAVNUM+4,X
	ADC NARG1+4,X
	STA NARG1+4,X
	INX
	BMI ADDNML
	TAX
	RTS

ADDDIG:	SEC		;Add Ascii digit in A to NARG1
	SBC #'0
	CLC
	LDX #$FC
	BNE ADDL1A	;(Always)
ADDLP1:	LDA #$00
ADDL1A:	ADC NARG1+4,X
	STA NARG1+4,X
	INX
	BMI ADDLP1
	TAX
	RTS

FADDGX:	SEC
	SBC #'0		;Get the digit's value
	TAX
	JSR ZNARG2	;clear out narg2.
	STX NARG2	;Add A to NARG1, floating pt.
	JSR FLOTN2	;Put A in NARG2, make it floating pt., and add
	JMP FADD

FADDIG:	JSR FADDGX
	BCS NUMOVF
	RTS

;Add decimal digit to floating pt. number
FADDGN:	PHA		;Save digit
	LDY #SAVNUM
	JSR XN1TOY	;Save NARG1
	LDY #NARGX	;Get decimal place constant
	JSR XYTON1
	JSR MULN10	;Multiply by 10 (bashes NARG2)
	LDY #NARGX
	JSR XN1TOY	;And put back
	PLA
	SEC
	SBC #'0
	TAX
	JSR ZNARG2	;zero narg2.
	STX NARG2	;Put digit in NARG2
	JSR FLOTN2
	JSR FDIVX	;Divide digit by decimal place (10^N)
	LDY #SAVNUM
	JSR XYTON2	;Get orig. number back
	JMP FADD	;and add new scaled digit
.PAGE
;Multiply NARG1 by 10., floating pt.
MULN10:	SETNUM NARG2,FLT10	;Put 10. (floating pt. constant) in NARG2
	JMP FMUL	;and multiply (calling procedure checks for overflow)

;Divide NARG1 by 10., floating pt.
FDVD10:	SETNUM NARG2,FLT10	;Put 10. (floating pt. constant) in NARG2
	JMP FDIV

;	Local variable block:
EXP	=TEMPX1		;Exponent (CNUML2,CNUML0,INCEXP)

INCEXP:	SEC
	SBC #'0
	TAY		;Multiply exponent by ten and add new digit
	ASL EXP
	BMI NUMOVF
	LDA EXP
	ASL A
	BMI NUMOVF
	ASL A
	BMI NUMOVF
	ADC EXP
	BMI NUMOVF
	STA EXP
	TYA
	ADC EXP
	BMI NUMOVF
	STA EXP
	RTS

NUMOVF:	PLA		;Overflow, pop past subroutine
	PLA
	CLC		;Indicate not a number
	RTS
.PAGE
.SBTTL	Initializations

;	Local variable block:
TABIDX	=TEMPN		;Index into prim- and vprim-tables
IDXPTR	=TEMPNH		;Index pointer
INDEX	=ANSN		;Primitive index no.
PTRDEP	=TEMPN3		;Primitive pointer deposit address
PRMPTR	=TEMPN2		;Primitive address
LASTOB	=TEMPN1		;Ptr. to last soblist object to check
NXTNOD	=TEMPN		;Used to link freelist together
NOVALU	=TEMPN1		;Temp. novalue constant
NAME	=TEMPN3		;Pname of new Logo name
OBJECT	=ANSN2		;INTRNX shares, Logo name to add to oblist

;	Primitive-array offsets:
PRMNGS	=0	;No. of arguments
PRMPRC	=1	;Precedence
PRMIDX	=2	;Primitive index no.
PRMNAM	=3	;Primitive pname offset

INITLZ:	LDA #$00
	STA GRPHCS
	STA TRACE
	STA GCFLG	;not doing a gc.
	STA NNODES	;Node allocation counter
	STA NNODES+1
	STA DEFFLG
	STA DEFBOD+1
	STA LEVNUM
	STA LEVNUM+1
	STA FRAME+1	;Reset frame for ERROR
	STA PODEFL+1
	STA SIZE1
	STA SIZE1+1
	STA SIZE2
	STA SIZE2+1
	STA BKTFLG	;Don't print brackets on lists, or funny '' on pnames.
	STA USHAPE
	STA USHAPE+1	;user-defined turtle shape.
	STA SAVMOD	;SAVE/READ act normally.
	JSR CLMK4
;end of things that need 0 in A.
	LDA #$01
	STA IFTEST	;Default is FALSE (nonzero)
	STA SSIZE	;default shape size.
	JSR CLRCBF
	LDA #$0D
	STA LINARY	;Null the line-array
	SETV SP,PDLBAS
	SETV VSP,VPDLBA
	JSR RIODEF	;Set I/O to to default
	JSR CLRMRK	;Reset G.C. Array (Typebase bits)
	JSR RESETT	;Clear screen, etc.
	JSR NOEDBF
	JSR GRINIT	;Graphics init
.IFNE MUSINC
	JSR MSINIT	;Music init
.ENDC
	LDA #NODBEG&$FF
	STA SOBLST
	STA SOBTOP
	LDA #NODBEG^
	STA SOBLST+1
	STA SOBTOP+1
	SETV TABIDX,PRMTAB	;Points to first byte of Primitive-table
SOBLP1:	JSR SOBST1
	LDA TABIDX+1
	CMP #VPRMTB^
	BNE SOBLP1
	LDA TABIDX
	CMP #VPRMTB&$FF
	BNE SOBLP1
	SEC
	LDA SOBTOP
	SBC #$08
	STA LASTOB	;LASTOB is second-to-last node
	LDA SOBTOP+1
	SBC #$00
	STA LASTOB+1
SBVLP1:	LDA GETRM2	;Enable Ghost-memory
	LDY #$00
	LDA (TABIDX),Y
	STA PTRDEP
	INY
	LDA (TABIDX),Y
	STA INDEX
	LDA GETRM1	;Disable ghost-memory
	LDA GETRM1
	INC2 TABIDX
	SETV PRMPTR,BBASX	;BBASX is NODBEG - 4.
SBVRW:	LDA PRMPTR+1
	CMP LASTOB+1
	BNE SBVRW1
	LDA PRMPTR
	CMP LASTOB
	BNE SBVRW1
	LDA #$02
	JMP SYSBUG
SBVRW1:	INC4 PRMPTR
	CDR IDXPTR,PRMPTR
	LDA GETRM2	;Enable ghost-memory
	LDY #PRMIDX
	LDA (IDXPTR),Y
	LDX GETRM1	;Disable ghost-memory
	LDX GETRM1
	CMP INDEX
	BNE SBVRW
	LDX PTRDEP
	LDA PRMPTR
	STA $300,X	;Primitive pointers are on page 3
	LDA PRMPTR+1
	STA $301,X
	LDA TABIDX+1
	CMP #VPRMTE^
	BNE SBVLPJ
	LDA TABIDX
	CMP #VPRMTE&$FF
	BEQ SBVLL1
SBVLPJ:	JMP SBVLP1
SBVLL1:	CLC
	LDA SOBTOP
	STA FRLIST
	ADC #$04
	STA NXTNOD
	LDA SOBTOP+1
	STA FRLIST+1
	ADC #$00
	STA NXTNOD+1
	LDY #$03
	LDA #$00
	STA (SOBTOP),Y	;Terminate Soblist with nil
RINLP2:	RPLACD NXTNOD,FRLIST
	CLC
	LDA NXTNOD
	STA FRLIST
	ADC #$04
	STA NXTNOD
	LDA NXTNOD+1
	STA FRLIST+1
	ADC #$00
	STA NXTNOD+1
	CMP #NODEND^	;(Ptr. to byte after last node)
	BNE RINLP2
	LDA NXTNOD
	CMP #NODEND&$FF
	BNE RINLP2
	LDX #$00
	STX OBLIST+1
	INX
	STX NOVALU+1	;Set Novalue for MKSFUN
	LDX #UNSUM
	LDA #PRMSUM&$FF
	LDY #PRMSUM^
	JSR MKSFUN
	LDX #UNDIF
	LDA #PRMDIF&$FF
	LDY #PRMDIF^
	JSR MKSFUN
	LDY #$00
	STY CCOUNT
TRUEL:	LDA PTRUE,Y
	BEQ TRUELE
	JSR PUSHB
	INC CCOUNT
	LDY CCOUNT
	BNE TRUEL	;(Always)
TRUELE:	LDA #NAME
	JSR CNSPDL
	LDX #NAME
	LDA #LTRUE
	STA OBJECT
	JSR INTRNX
	LDY #$00
	STY CCOUNT
FALSL:	LDA PFALSE,Y
	BEQ FALSLE
	JSR PUSHB
	INC CCOUNT
	LDY CCOUNT
	BNE FALSL	;(Always)
FALSLE:	LDA #NAME
	JSR CNSPDL
	LDX #NAME
	LDA #LFALSE
	STA OBJECT
	JMP INTRNX

;	Logo names:
PTRUE:	.ASCII "TRUE"
	$00
PFALSE:	.ASCII "FALSE"
	$00
.PAGE
SOBST1:	LDY #$01
	TYA
	STA (SOBTOP),Y	;Novalue in car of node
	INY
	LDA TABIDX
	STA (SOBTOP),Y
	INY
	LDA TABIDX+1
	STA (SOBTOP),Y	;Pointer into ghost-memory in cdr of node
	LDA #SATOM
	LDX #SOBTOP
	JSR PUTTYP
	LDA GETRM2	;Enable ghost-memory
	LDY #PRMNAM-1
SOBLP:	INY
	LDA (TABIDX),Y
	BNE SOBLP
	LDA GETRM1	;Disable ghost-memory
	LDA GETRM1
	SEC
	TYA
	ADC TABIDX
	STA TABIDX
	BCC ADHAK6
	INC TABIDX+1
ADHAK6:	INC4 SOBTOP
	INC1 NNODES
	RTS
.PAGE
MKSFUN:	STA PRMPTR
	STY PRMPTR+1
	STX NODPTR
	LDX #PRMPTR
	LDY #NOVALU
;	LDA #SATOM
	JMP SACONS
.PAGE
.SBTTL	Miscellaneous and Evaluator Utility Routines
.SBTTL		Toplevel Evaluator Utility Routines

;	Local variable block:
TBLADR	=TEMPNH		;Addr. of dispatch table

;Dispatch routine Called with typecode in A; table address in XY.
TYPDSP:	STX TBLADR
	STY TBLADR+1	;Store table address
	CMP #HITYP+1	;See if out of range
	BCS TYPBUG	;Yes, system bug
	ASL A
	TAY		;Get table index
	LDA (TBLADR),Y
	TAX
	INY
	LDA (TBLADR),Y
	STA TBLADR+1	;Get table entry
	STX TBLADR
	JMP (TBLADR)	;Jump to it
TYPBUG:	LDA #$03
	JMP SYSBUG

GTNXTK:	CAR NEXTOK,TOKPTR
	RTS
.PAGE
.SBTTL		Stack Frame Utility Routines

POPFRM:	JSR RSTBND
	POPB IFLEVL
	POP TLLEVS
	JSR POPB	;Skip NUMBER-BINDINGS
	POP TOKPTR
	POPB IFTEST
	POPB NEST
	POP CURTOK
	POPB UFRMAT
	POP XFRAME
	LDX #FRAME
	JMP POP

;	Local variable block:
VALUE	=TEMPN1		;Binding value
NAME	=TEMPN		;Binding name
ARGS	=ANSN		;No. of ufun args

RSTBND:	MOV SP,XFRAME
	LDY #SFNRGS	;Frame index for NUMBER-BINDINGS
	LDA (FRAME),Y
	BEQ RSTBWE
	STA ARGS
RSTBW:	POP VALUE
	POP NAME
	LDX #NAME
	LDY #VALUE
	JSR PUTVAL
	DEC ARGS
	BNE RSTBW
RSTBWE:	RTS

;This routine UNWINDS a stack frame, ignoring all information in it
;but FRAME, XFRAME, and the variable binding pointers.  The VPDL
;bindings associated with the frame are undone.

UNWFRM:	JSR RSTBND
	LDY #SFXFRM	;XFRAME index
	LDA (FRAME),Y
	STA XFRAME
	INY
	LDA (FRAME),Y
	STA XFRAME+1
	LDY #SFFRAM	;Previous-frame index
	LDA (FRAME),Y
	TAX
	INY
	LDA (FRAME),Y
	STA FRAME+1
	STX FRAME
	RTS
.PAGE
.SBTTL		Stack Routines

;PUSHP is given the location of a page-zero variable in X,
;and pushes the contents of the variable onto the Logo stack.
PUSHP:	RPLCAX SP
	INC2 SP
	RTS

;PUSH pushes onto the stack the sixteen-bit value in the X and Y registers.
PUSH:	TYA
	LDY #$01
	STA (SP),Y
	DEY
	TXA
	STA (SP),Y
	INC2 SP
	RTS

;PUSHB pushes onto the stack the eight-bit value in the A register.
PUSHB:	LDY #$00
	STA (SP),Y
	INC1 SP
	RTS

;VPUSH is given the address of a page-zero variable in X,
;and pushes the contents of that variable onto the Value stack.
VPUSHP:	RPLCAX VSP
	DEC2 VSP
	RTS
.PAGE
;POP pops a value off of the Logo stack and into the page-zero variable
;whose address is in X.
POP:	DEC2 SP
	CARX SP
	RTS

;VPOP pops a value off of the Value stack and into the page-zero variable
;whose address is in X. Doesn't destroy X.
VPOP:	INC2 VSP
	CARX VSP
	RTS

;POPB pops a one-byte value off of the Logo stack and returns with it in A.
POPB:	SEC
	LDA SP
	SBC #$01
	STA SP
	BCS POPB1
	DEC SP+1
POPB1:	LDY #$00
	LDA (SP),Y
	RTS

GRM1:	BIT GETRM1
	BIT GETRM1
	RTS

.PAGE
;TSTSTK tests to see if the Logo stack test limit has been exceeded,
;and gives an error if so. It doesn't poll for interrupts.
TSTSTK:	LDA VSP+1
	CMP SP+1
	BCC STKTZ
	BNE STKTR
	SEC
	LDA VSP
	SBC SP
	CMP #STKLIM
	BCC STKTZ
STKTR:	RTS
STKTZ:	SETV SP,PDLBAS		;Reset the stack for reader/tokenizer
	SETV VSP,VPDLBA
	JSR CLRMRK		;Clear the mark bits -- they interefere with typecodes.
	ERROR XZAP,XNSTOR	;(No Stack) "No storage left" zapcode

;POLLZ is the special polling routine which also checks for Pause key.

POLLZ:	JSR TSTCHR
	BCC PRTS	;Return if no chars. pending
	BIT KBDCLR	;Else reset strobe and gobble char.
	JSR CKINTZ
	JMP STPPKX

;TSTPOL tests to see if the Logo stack test limit has been exceeded,
;and gives an error if so. Polls for interrupts.
TSTPOL:	JSR TSTSTK
;	...

;POLL is the polling routine for user interrupts.
;	...
POLL:	JSR TSTCHR
	BCC PRTS	;Return if no kbd character pending
	CMP #PAUSKY
	BEQ PRTS	;If PAUSE, don't reset strobe, just exit
	BIT KBDCLR	;Else reset strobe and gobble char.
	JSR CKINTS	;Entry point for Pause-key poller
STPPKX:	BCC PRTS	;If intercepted, we're done
	TAY		;Save character
	LDA CHBUFR
	SBC CHBUFS	;Check for buffer-full (carry is set)
	AND #$3F
	CMP #$01
	BEQ BOFL	;Buffer overflow if next-free loc right before next-to-read
	LDA CHBUFS
	AND #$3F
	TAX
	TYA
	STA CHBSTT,X	;Store character in buffer
	INC CHBUFS	;Increment next-free-loc
PRTS:	RTS
BOFL:	JMP BELL	;Ding-dong if buffer overflow

CKINTZ:	CMP #PAUSKY
	BEQ SPAUSE
CKINTS:	CMP #STPKEY
	BEQ STPPK1
	CMP #LSTKEY	;Halt listing temporarily
	BEQ LWAIT
	CMP #FULCHR	;Full-screen graphics character
	BEQ STPFUL
	CMP #MIXCHR	;Mixed-screen graphics character
	BEQ STPMIX
	CMP #TXTCHR	;Show text screen
	BEQ STPTXT
	CMP #IOKEY	;restore I/O drivers.
	BEQ RIODEF	;reset io default.
NOINT:	SEC		;Carry set means character not intercepted
	RTS

LWAIT:	JSR RDKEY1	;Wait for a character before continuing (doesn't reset strobe)
	CMP #LSTKEY	;If it's another stop-list key, hold it until next poll
	BEQ LWAIT1
	BIT KBDCLR	;clear the strobe
	CMP #STPKEY	;stop if the key is a stop key.
	BEQ STPPK1
;Can't allow pause, since might not have gotten here through CKINTZ.
;Maybe put in a flag to allow CMP #PAUSKY/BEQ SPAUSE if got here through CKINTZ.
LWAIT1:	CLC
	RTS

STPPK1:	ERROR XZAP,XSTOP
;
SPAUSE:	LDA FBODY+1		;Pause does nothing inside break loops toplevel.
	BEQ SPPJ
SPZR:	ERROR XBRK
SPPJ:	JMP POPJ

.IFNE MUSINC
;set carry to indiate these keys do nothing, and should not be intercepted.
STPTXT:
STPMIX:
STPFUL:	SEC
	RTS
.ENDC ;MUSINC

.IFNE GRPINC
STPFUL:	LDA GRPHCS
	BPL PRTS
	LDA GSW
	LDA FULLGR
	CLC
	RTS

STPMIX:	LDA GRPHCS
	BPL PRTS
	LDA GSW
	LDA MIXGR
	CLC
	RTS
STPTXT:	LDA TXTMOD
CKRTS:	CLC
	RTS

.ENDC ;GRPINC
RIODEF:	SETV DEFINP,KEYIN
	SETV DEFOUT,COUT
	JSR RSTIO
	CLC
	RTS
.PAGE
.SBTTL		Atomic Value Routines

;	Local variable block:
ATOMM	=TEMPNH		;Atom ptr.

;Should return with high byte of value in A.
GETVAL:	LDA $00,Y	;Get value into X's pointer from Y's pointer
	AND #$FC	;Strip off last two bits
	STA ATOMM
	LDA $01,Y
	STA ATOMM+1
	CARX ATOMM
	RTS

;	Local variable block:
ATOMM	=TEMPNH		;Atom ptr.

PUTVAL:	LDA $00,Y
	AND #$FC
	STA ATOMM
	LDA $01,Y
	STA ATOMM+1
	RPLCAX ATOMM
	RTS
.PAGE
.SBTTL		Function Utility Routines

;	Local variable block:
OBJECT	=TEMPN		;Object ptr.
FUN	=ANSN		;Function ptr. addr.

;Should return with high byte of function-ptr. in A.
GETCFN:	LDX #CURTOK
GTCFN1:	LDA #FUNCT
GETFUN:	STA FUN
	GETX OBJECT
	JSR GETTYP
	LDX FUN
	CMP #ATOM
	BEQ GTFN1
	CMP #SATOM
	BEQ GTFN2
	LDA #$01
	STA $01,X
	RTS
GTFN1:	LDY #$02
	LDA (OBJECT),Y
	PHA
	INY
	LDA (OBJECT),Y
	STA OBJECT+1
	PLA
	STA OBJECT
	CARX OBJECT
	LDY #UFUN
	RTS
GTFN2:	CDRX OBJECT
	LDY #SFUN
	RTS
.PAGE
GETPRC:	LDA FUNTYP
	CMP #UFUN
	BEQ GTPRC1
GPRCS:	LDA GETRM2	;Enable ghost-memory
	LDY #PRMPRC
	BNE GTNGPC	;(Always)
GTPRC1:	LDA #$05	;Ufun, precedence 5
	RTS

GETNGS:	LDA FUNTYP
	CMP #SFUN
	BEQ GTNG2
GTNG1:	LDY #$04
	LDA (FUNCT),Y
	RTS
GTNG2:	LDA GETRM2	;Enable ghost-memory
	LDY #PRMNGS
GTNGPC:	LDA (FUNCT),Y
	LDX GETRM1	;Disable ghost-memory
	LDX GETRM1
	RTS
.PAGE
INFIXP:	LDA FUNTYP
	CMP #SFUN
	BNE IFP1
	LDA FUNCT+1
	CMP #$01
	BNE IFP2
IFP1:	CLC		;Not infix
	RTS
IFP2:	LDA GETRM2	;Enable ghost-memory
	LDY #PRMIDX
	LDA (FUNCT),Y
	LDX GETRM1	;Disable ghost-memory
	LDX GETRM1
	CMP #INSUM
	BEQ IFP3
	CMP #INDIF
	BEQ IFP3
	CMP #INPROD
	BEQ IFP3
	CMP #INQUOT
	BEQ IFP3
	CMP #INGRTR
	BEQ IFP3
	CMP #INLESS
	BEQ IFP3
	CMP #INEQUL
	BNE IFP1
IFP3:	SEC		;Infix.
	RTS		;Return with proper index in A
.PAGE
;	Local variable block:
FNTXTP	=ANSN4		;Function text ptr. addr.
NARGSP	=ANSN3		;Addr. of no. of args
ATMPTR	=TEMPN7		;Atom ptr. addr.
ATOMM	=TEMPNH		;Atom ptr.
CELL	=TEMPN5		;Function cell
FUNCTP	=TEMPN6		;Function ptr.
SIZE	=TEMPN8		;Length of contiguous area to get

PTFTXT:	STY FNTXTP
	STA NARGSP
	STX ATMPTR
	JSR GETTYP
	CMP #ATOM
	BEQ PTFTX2
	LDY ATMPTR
	ERROR XUBL
PTFTX2:	LDX ATMPTR
	GETX ATOMM
	CDR CELL,ATOMM
	CAR FUNCTP,CELL
	CMP #$01	;See if it's novalue
	BNE PTFTX3
	LDX FNTXTP
	GETX MARK1
	LDA #$04
	STA SIZE
	LDA #$00
	STA SIZE+1
	LDY #SIZE
	LDX #FUNCTP
	JSR GETWDS
	LDA FUNCTP+1
	BEQ PTFER
	RPLACA CELL,FUNCTP
	LDA #$00
	STA MARK1+1
	LDX #FUNCTP
	LDA #UFUN
	JSR PUTTYP
	LDY #$06
	LDX ATMPTR
	LDA $00,X
	STA (FUNCTP),Y
	INY
	LDA $01,X
	STA (FUNCTP),Y
PTFTX3:	LDY #$01
	LDA #$00
	STA (FUNCTP),Y
	LDX FNTXTP
	RPLCDX FUNCTP
	LDY #$04
	LDX NARGSP
	LDA $00,X
	STA (FUNCTP),Y
	INY
	LDA $01,X
	STA (FUNCTP),Y
PTFTXE:	RTS
PTFER:	JMP CONSR	;(No Nodes, most likely) "No storage left" zapcode
.PAGE
;	Local variable block:
FUN	=TEMPNH		;Function ptr.

UNFNC1:	LDX #ARG1
UNFUNC:	GETX FUN
	CDRME FUN
	LDY #$01
	TYA		;Ufun <- novalue
	STA (FUN),Y
	RTS
.PAGE
.SBTTL		Nodespace Routines
;CONS creates a new node from the freelist. X points to the Cdr,
;Y to the Car, NODPTR to the node's pointer, and A holds the typecode.
;CONS:	PHA
;	CMP #LIST
;	BEQ FCONS
;	CMP #STRING
;	BEQ SCONS
;	CMP #FIX
;	BEQ NCONS
;	CMP #FLO
;	BEQ NCONS
;	CMP #ATOM
;	BEQ SCONS
;	CMP #SATOM
;	BEQ S1CONS
;	LDA #$04
;	JMP SYSBUG

;	Local variable block:
XCAR	=TEMPNH		;Addr. of car ptr.
XCDR	=TEMPNH+1	;Addr. of cdr ptr.

;"L" CONS - Protect both CAR and CDR. Used for Lists.
LCONS:	LDA #LIST
	PHA
;FCONS:
	JSR XCONS
	LDX XCAR
	JSR VPUSHP	;VPUSH Xcar
	LDX XCDR
	JSR VPUSHP	;VPUSH Xcdr
	JSR GARCOL
	CLC		;Reset the VPDL
	LDA VSP
	ADC #$04
	JMP SCONS2

FNCONS:	LDA #FLO
	BNE FICONS	;(always)

;Integer (FIX) cons.
INCONS:	LDA #FIX
;...
;"N" CONS - Doesn't protect either CAR or CDR. Used for numbers.
FICONS:	PHA		;Fix or Integer cons. doesn't typecheck.
NCONS:	JSR XCONS
	JSR GARCOL
	JMP CONSG1



;Atom cons.  Calls string cons.
ACONS:	LDA #ATOM
	PHA
	BNE SCONS	;(always)

;String cons.
STCONS:	LDA #STRING
	PHA
;"S" CONS - Protects only CDR. Used for strings.
SCONS:	JSR XCONS
	LDX XCDR
	JSR VPUSHP	;VPUSH Xcdr
	JSR GARCOL
	JMP SCONS1	;Reset the VPDL

;"SA" CONS - Protects only CAR. Used for Satoms.
SACONS:	LDA #SATOM
	PHA
;S1CONS:
	JSR XCONS
	LDX XCAR
	JSR VPUSHP
	JSR GARCOL
;...
SCONS1:	CLC
	LDA VSP
	ADC #$02
SCONS2:	STA VSP
	BCC CONSG1
	INC VSP+1
	BNE CONSG1	;(Always)

XCONS:	STY XCAR
	STX XCDR
	LDA FRLIST+1
	BEQ XCONSG
	LDA PRSFLG
	BNE XCONS2	;Don't check limit for parser calls
	LDA NNODES+1
	CMP #NODLIM^
	BCC XCONS2
	BNE XCONSG
	LDA NNODES
	CMP #NODLIM&$FF
	BCC XCONS2
XCONSG:	RTS
XCONS2:	PLA
	PLA
	JMP CONS2

CONSG1:	LDA PRSFLG
	BEQ CONST2
	LDA FRLIST+1
	BNE CONS2
	BEQ CONSR
CONST2:	LDA NNODES+1
	CMP #NODLIM^
	BCC CONS2
	BNE CONSR
	LDA NNODES
	CMP #NODLIM&$FF
	BCC CONS2
CONSR:	ERROR XZAP,XNSTRN	;Error "No storage left" (No nodes)

CONS2:	INC1 NNODES	;Increment node counter
	LDX XCAR
	RPLCAX FRLIST
	LDX XCDR
	LDY #$02
	LDA (FRLIST),Y
	PHA
	LDA $00,X
	STA (FRLIST),Y
	INY
	LDA (FRLIST),Y
	PHA
	LDA $01,X
	STA (FRLIST),Y
	LDX NODPTR
	PUTX FRLIST
	PLA
	STA FRLIST+1
	PLA
	STA FRLIST
	PLA		;Retrieve typecode
;	...
.PAGE
;	...
PUTTYP:	CMP #LATOM+1
	BCS PUTTP2
	CMP #QATOM
	BCC PUTTP2
	AND #$03
	ORA $00,X
	STA $00,X
	RTS
PUTTP2:	LDY $01,X
	BEQ PUTTPE	;Can't give nil a type, ignore
	PHA
	STY TYPPTR+1
	LDA $00,X
	STA TYPPTR
	JSR TYPACS
	PLA
	STA (TYPPTR),Y
PUTTPE:	RTS

;Doesn't destroy X.
GETTYP:	LDA $01,X
	BEQ GETTPE	;Pointer to 00 is empty list, type 0 (LIST)
	STA TYPPTR+1
	LDA $00,X
	STA TYPPTR
	JSR TYPACS
	CMP #ATOM
	BEQ GETTP4
	CMP #SATOM
	BNE GETTPE
GETTP4:	TAY
	LDA $00,X
	AND #$03
	BEQ GETTPF
	ORA #$08
GETTPE:	RTS
GETTPF:	TYA
	RTS

;Return with Y=$00.
TYPACS:	LSR TYPPTR+1
	ROR TYPPTR
	LSR TYPPTR+1
	ROR TYPPTR
	CLC
	LDA TYPPTR
	ADC #TYPARY&$FF
	STA TYPPTR
	LDA TYPPTR+1
	ADC #TYPARY^
	STA TYPPTR+1
	LDY #$00
	LDA (TYPPTR),Y
	RTS
.PAGE
;	Local variable block:
RETPTR	=ANSN		;Ptr. to contig. area
SIZEP	=ANSN1		;Addr. of size of area
LSTPTR	=TEMPN		;Search ptr.
LSTPT1	=TEMPN4		;Search ptr.
PTR	=TEMPN1		;Search ptr.
PTR1	=TEMPN3		;Search ptr.
SOFAR	=TEMPN2		;Size of area so far
CONTIG	=ANSN2		;Zero if contiguous so far
TMPPTR	=TEMPNH		;Temp. search ptr.

;Tries to find a block of (Y) contiguous free words in nodespace.
;If successful, return the start addr in (X). If not, returns nil.
GETWDS:	STX RETPTR
	STY SIZEP
	LDA #$00
	STA $00,X		;zero ans
	STA $01,X
	LDA $00,Y
	BNE GW1A
	LDA $01,Y
	BEQ RTS2		;If size=0, just return with ANS = 0
GW1A:	JSR GW1			;try once
	LDX RETPTR
	LDA $01,X
	BNE GWRTS		;if found something, adjust nodes-count and quit.
	JSR GARCOL		;otherwise, try again after a GC
;	...

;	...
GW1:	LDA #$00
	STA LSTPTR+1		;Zero lastptr
	STA LSTPT1+1		;and lastptr1
	LDA FRLIST		;init ptr and
	STA PTR			;ptr1 to freelist
	STA PTR1
	LDA FRLIST+1
	STA PTR+1
	STA PTR1+1
GW1W:	LDX RETPTR
	LDA $01,X		;if ans neq nil, done
	BEQ GW1WA		;cuz found something
GWRTS:	INC1 SOFAR		;Adjust allocation pointer, Nodes := (words + 1) / 2
	LSR SOFAR+1
	ROR SOFAR
	CLC
	LDA NNODES
	ADC SOFAR
	STA NNODES
	LDA NNODES+1
	ADC SOFAR+1
	STA NNODES+1
RTS2:	RTS
GW1WA:	LDA PTR+1		;if ptr = nil, done cuz been thru whole
	BEQ RTS2		;freelist, found nothing
GW1W1:	LDA #$00
	STA SOFAR		;sofar:= 0
	STA SOFAR+1
	STA CONTIG		;contig:= 0 (T)
GW1X:	LDX SIZEP
	LDA SOFAR+1
	CMP $01,X
	BCC GW1X2		;if sofar >= size, go if2
	BNE GWIF2
	LDA SOFAR
	CMP $00,X
	BCS GWIF2
	LDA CONTIG		;if contig = false, go else
	BNE GWELSE
	LDA PTR1
	BNE GW1X2		;if ptr1 = nil, goto else
	LDA PTR1+1
	BEQ GWELSE
GW1X2:	INC2 SOFAR		;sofar := sofar + 2
	CDR TMPPTR,PTR1		;temp:= (cdr ptr1)
	CLC
	LDA TMPPTR		;add 4 to temp and see if
	ADC #$04		;result is = ptr1
	TAX
	LDA TMPPTR+1
	ADC #$00
	CMP PTR1+1
	BNE NCNTIG
	CPX PTR1
	BEQ CNTIG		;if so, contig := 1 (false)
NCNTIG:	INC CONTIG
CNTIG:	MOV LSTPT1,PTR1		;lastptr1 := ptr1
	MOV PTR1,TMPPTR		;ptr1 := temp
	JMP GW1X		;round the while loop
GWIF2:	LDA LSTPTR+1		;if lastptr = nil, freelist := ptr1
	BNE GWIF3
	MOV FRLIST,PTR1		;freelist := ptr1
	JMP GWIF4
GWIF3:	RPLACD LSTPTR,PTR1	;else (rplacd lasptr ptr1)
GWIF4:	LDX RETPTR
	PUTX LSTPT1		;ans := lastptr1
	JMP GW1W		;back to top
GWELSE:	MOV PTR,PTR1		;ptr := ptr1
	MOV LSTPTR,LSTPT1	;lastptr := lastptr1
	JMP GW1W		;back to top
.PAGE
.SBTTL		Ufun Line Utility Routines

;	Local variable block:
ARGLST	=TEMPN8		;Arglist pointer for bindings (shared: UFUNCL,XTAIL,NWBNDS,GETALN)
BODY	=TEMPNH		;Body ptr.

GETALN:	LDY #FBODY
	LDX #ARGLST
GETULN:	GETY BODY
	CARX BODY
	LDA UFRMAT
	BNE GTTFPK
	LDA $01,X
	BNE GTTCK
	RTS
GTTFPK:	CDR ULNEND,BODY
	CMP $01,X
	BNE GTTCK
	LDA ULNEND
	CMP $00,X
	BEQ GTTNIL
GTTCK:	GETX BODY
	LDY #$00
	LDA (BODY),Y
	CMP COMMNT
	BNE GTTRTS
	INY
	LDA (BODY),Y
	CMP COMMNT+1
	BNE GTTRTS
GTTNIL:	LDA #$00
	STA $01,X
GTTRTS:	RTS
.PAGE
;	Local variable block:
BODY	=TEMPNH		;Body ptr.

GLNADV:	LDX #GOPTR
ULNADV:	GETX BODY
	LDA UFRMAT
	BNE ULDV2
ULDV1:	LDY #$02
	LDA (BODY),Y
	PHA
	INY
	LDA (BODY),Y
	STA $01,X
	PLA
	STA $00,X
	RTS
ULDV2:	LDY #$05
	LDA (BODY),Y
	BEQ ULDV3
	INC2X
	RTS
ULDV3:	STA $01,X
TPLINR:	RTS
.PAGE
;	Local variable block:
TOKEN	=TEMPX1		;Token
LINPTR	=TEMPN8		;Fpacked line ptr. (shared: TPLINF,ERROR,POFUN)
ENDPTR	=TEMPX2		;Fpacked line-end ptr. (shared: TPLINF,ERROR,POFUN)

;Type an Fpacked line
TPLINF:	LDA LINPTR
	CMP ENDPTR
	BNE TPLIN1
	LDA LINPTR+1
	CMP ENDPTR+1
	BEQ TPLINR
TPLIN1:	CAR TOKEN,LINPTR
	INC2 LINPTR
	LDA #$20
	JSR TPCHR
	LDX #TOKEN
	JSR LTYPE0
	JMP TPLINF
.PAGE
.SBTTL		Token-list Routines

;	Local variable block:
TOKEN	=TEMPNH		;Token list ptr.

TOKADV:	LDX #TOKPTR
TTKADV:	JSR TFKADV
	GETX TOKEN
	LDY #$00
	LDA (TOKEN),Y
	CMP COMMNT
	BNE TTKE
	INY
	LDA (TOKEN),Y
	CMP COMMNT+1
	BNE TTKE
	LDA #$00
	STA $01,X
TTKE:	RTS

TFKADV:	LDA UFRMAT
	CMP #FPACK
	BEQ TFK2
TFK1:	GETX TOKEN
	CDRX TOKEN
	RTS
TFK2:	INC2X
	CMP ULNEND
	BNE TFK3
	LDA $01,X
	CMP ULNEND+1
	BNE TFK3
	LDA #$00
	STA $01,X
TFK3:	RTS
.PAGE
;	Local variable block:
TOKEN	=TEMPN		;Token ptr.
PCOUNT	=ANSN		;Parenthesis counter

SKPPTH:	LDA TOKPTR+1
	BEQ RTSA2X
	CAR TOKEN,TOKPTR
	JSR TOKADV
	LDA TOKEN
	CMP LPAR
	BNE RTSA2X
	LDA TOKEN+1
	CMP LPAR+1
	BNE RTSA2X
	LDA #$01
	STA PCOUNT
SKPPW:	LDA TOKPTR+1
	BEQ RTSA2X
	CAR TOKEN,TOKPTR
	JSR TOKADV
	LDX TOKEN
	LDY TOKEN+1
	CPX LPAR
	BNE SKPPW2
	CPY LPAR+1
	BNE SKPPW2
	INC PCOUNT
	BNE SKPPW
	LDX #PRNNST
	JMP EXCED	;Parenthesis nesting too deep
SKPPW2:	CPX RPAR
	BNE SKPPW
	CPY RPAR+1
	BNE SKPPW
	DEC PCOUNT
	BNE SKPPW
RTSA2X:	RTS
.PAGE
;	Local variable block:
RETTKN	=ANSN1		;Addr. of returned token ptr.
IFCNTR	=TEMPN1		;If-level counter

EXIFSC:	STX RETTKN
	LDA IFLEVL
	STA IFCNTR
EXIFLP:	LDA IFCNTR
	CMP IFLEVL
	BCS EXFWA1
EXFWE:	DEC IFLEVL
EXFWR:	RTS
EXFWA1:	LDA TOKPTR+1
	BEQ EXFWE
	LDX RETTKN
	LDY #$00
	CARX TOKPTR
	TAY
	LDA $00,X
	CMP IF
	BNE EXFW2
	CPY IF+1
	BNE EXFW2
	INC IFCNTR
	JSR TOKADV
	JMP EXIFLP
EXFW2:	CMP ELSE
	BNE EXFW3
	CPY ELSE+1
	BNE EXFW3
	DEC IFCNTR
	LDA IFCNTR
	CMP IFLEVL
	BCC EXFWE
	JSR TOKADV
	JMP EXFWA1
EXFW3:	CMP RPAR
	BNE EXFW4
	CPY RPAR+1
	BEQ EXFWE
EXFW4:	JSR SKPPTH
	JMP EXIFLP
.PAGE
.SBTTL		Edit mode Utility Routines

DEFSTP:	LDA TOKPTR+1
	BEQ ERELJ1
	JSR GETRG1	;car ARG1 from TOKPTR
	JSR TOKADV
	GETTYP ARG1
	CMP #SATOM
	BEQ EDTSR4
	CMP #ATOM
	BNE EDTSR5
	LDA ARG1
	STA DEFATM
	STA PODEFL
	LDA ARG1+1
	STA DEFATM+1
	STA PODEFL+1
	RTS
ERELJ1:	JMP ERXEOL
EDTSR4:	JMP ERXUBL
EDTSR5:	JMP ERXWT1

EXTDEF:	LDA #$00
	STA DEFFLG
	STA DEFBOD+1
	STA DEFATM+1
	RTS
.PAGE
.SBTTL		Stuffed stuff Routines

;	Local variable block:
ATMPTR	=ANSN3		;Atom ptr. addr.
BODYP	=ANSN4		;Body ptr. addr.
BODY	=TEMPNH		;Body ptr.
LINE	=TEMPN7		;Ufun line
LENGTH	=TEMPX2		;Length of line
SIZE	=TEMPN6		;Length of fpacked space
LINE1	=TEMPN		;Line ptr. while computing size
PTR	=TEMPN5		;Ptr. to fpacked area
INDEX	=TEMPX1		;Ptr. to fpacked area
INDEX1	=TEMPN1		;Alt. index
TOKEN	=TEMPN3		;Token ptr.

STUFF:	STA ATMPTR		;try to associate the atom
	STX BODYP		;definition with the function body
	LDA $00,X
	STA BODY
	PHA
	LDA $01,X
	STA BODY+1
	PHA
	CAR LINE,BODY
	LDX #LENGTH
	LDY #LINE
	JSR GETLEN
	LDA #$00
	STA SIZE
	STA SIZE+1
	PLA
	STA BODY+1
	PLA
	STA BODY
GTSZW:	LDA BODY+1
	BEQ GTSZND
	CARNXT LINE1,BODY
GTSZX:	LDA LINE1+1
	BEQ GTSZW
GTSZX1:	INC1 SIZE
	CDRME LINE1
	BNE GTSZX1
	BEQ GTSZW	;(Always)
GTSZND:	LDX #PTR
	LDY #SIZE
	JSR GETWDS
	LDA PTR+1
	BNE STFF1
STFFA:	LDA #LENGTH
	LDY BODYP
	LDX ATMPTR
	JMP PTFTXT
STFF1:	MOV AREA1,PTR
	MOV SIZE1,SIZE
	LDX #SIZE
	LDY BODYP
	JSR GETLEN
	INC2 SIZE
	LDX #INDEX
	LDY #SIZE
	JSR GETWDS
	LDA INDEX+1
	BNE STFF2
	STA SIZE1
	STA SIZE1+1
	JMP STFFA
STFF2:	LDA INDEX
	STA AREA2
	STA INDEX1
	LDA INDEX+1
	STA AREA2+1
	STA INDEX1+1
	CLC
	LDA SIZE
	ADC #$02
	STA SIZE2
	LDA SIZE+1
	ADC #$00
	STA SIZE2+1
	LDX BODYP
	GETX BODY
STFFW:	LDA BODY+1
	BEQ STFFWE
	RPLACA INDEX1,PTR
	INC2 INDEX1
STFFX:	LDA LINE+1
	BEQ STFFXE
	CARNXT TOKEN,LINE
	RPLACA PTR,TOKEN
	INC2 PTR
	JMP STFFX
STFFXE:	CDRME BODY
	CAR LINE,BODY
	JMP STFFW
STFFWE:	RPLACA INDEX1,PTR
	LDY #$03
	LDA #$00
	STA (INDEX1),Y
	LDX #INDEX
	LDA #FPACK
	JSR PUTTYP
	LDA #LENGTH
	LDY #INDEX
	LDX ATMPTR
	JSR PTFTXT
	LDA #$00
	STA SIZE1
	STA SIZE1+1
	STA SIZE2
	STA SIZE2+1
RTS3:	RTS
.PAGE
;	Local variable block:
BODYP	=ANSN1		;Addr. of Body ptr.
FUN	=TEMPNH		;Function ptr.
INDEX	=TEMPN1		;Fpacked area index
SPPTR	=TEMPN4		;Stack ptr. temp
PTR	=TEMPN2		;Ptr. into fpack area
ENDPTR	=TEMPN3		;Fpack end-pointer
TOKEN	=TEMPN		;Token ptr.

UNSTUF:	STY BODYP
	GETX FUN
	CDR INDEX,FUN
	GETTYP INDEX
	CMP #FPACK
	BEQ USTF2
USTF1:	LDX BODYP
	PUTX INDEX
	RTS
USTF2:	LDA #$00
	STA MARK1+1
	MOV SPPTR,SP
USTFW2:	CAR PTR,INDEX
	CDR ENDPTR,INDEX
USTFW:	LDA ENDPTR+1
	BEQ USTFWE
	JSR TSTPOL
	PUSH PTR
	INC2 INDEX
	JMP USTFW2
USTFWE:	MOV ENDPTR,PTR
USTFX:	LDA SPPTR
	CMP SP
	BNE USTFX1
	LDA SPPTR+1
	CMP SP+1
	BEQ USTFXE
USTFX1:	POP PTR
	LDA #$00
	STA MARK2+1
USTFY:	LDA ENDPTR
	CMP PTR
	BNE USTFY1
	LDA ENDPTR+1
	CMP PTR+1
	BEQ USTFYE
USTFY1:	DEC2 ENDPTR
	CAR TOKEN,ENDPTR
	CONS MARK2,TOKEN,MARK2,LIST
	JMP USTFY
USTFYE:	LDX #MARK2
	LDA #LIST
	JSR PUTTYP
	CONS MARK1,MARK2,MARK1,LIST
	JMP USTFWE
USTFXE:	LDX BODYP
	PUTX MARK1
	LDA #$00
	JMP CLMK2	;Clear MARK1, MARK2
.PAGE
.SBTTL		Oblist Interning Routine

STRNGP	=ANSN1		;Addr. of string ptr.
RETPTR	=ANSN2		;Addr. of returned pointer
OBPTR	=TEMPN4		;Oblist pointer
PNAME	=TEMPN5		;Comparison pname
STRNG1	=TEMPNH		;Comparison string
NOVALU	=TEMPN1		;Novalue constant
SOBPTR	=TEMPNH		;Soblist object ptr.
SOBNAM	=TEMPN2		;Soblist object pname
CHARS	=TEMPN		;Temp. char. storage

INTERN:	STX STRNGP
	STY RETPTR
	JSR VPUSHP
	MOV OBPTR,OBLIST
OBFW:	LDX RETPTR
	CARX OBPTR	;Assume it's this Oblist object
	LDY #PNAME
	JSR GETPNM
	LDX STRNGP
	GETX STRNG1
MTC2W:	LDA STRNG1+1
	BNE MTC2W1
	LDA PNAME+1
	BNE OBFNF	;If STRING is 0 and PNAME isn't, not found
MTCFND:	LDX #PNAME
	JMP VPOP	;Pop the Vpushed string (we found it, since both are 0)
MTC2W1:	LDY #$00
	LDA (STRNG1),Y
	CMP (PNAME),Y
	BNE OBFNF
	TAX
	BEQ MTCFND	;First char both 0, so found
	INY
	LDA (STRNG1),Y
	CMP (PNAME),Y
	BNE OBFNF
	INY
	LDA (STRNG1),Y
	TAX
	INY
	LDA (STRNG1),Y
	STA STRNG1+1
	STX STRNG1
	DEY
	LDA (PNAME),Y
	TAX
	INY
	LDA (PNAME),Y
	STA PNAME+1
	STX PNAME
	JMP MTC2W	;try next two characters
OBFNF:	CDRME OBPTR	;try next Oblist object
	BNE OBFW
OBFNFE:	LDX STRNGP	;it's not on the oblist
	JSR VPOP	;get string back
	LDX RETPTR	;ans becomes soblist pointer
	PUTX SOBLST
SBFW:	LDX RETPTR	;object pointer
SBFWX:	LDA $00,X
	CMP SOBTOP
	BNE SBFW1
	LDA $01,X
	CMP SOBTOP+1
	BNE SBFW1
SBFWEN:	LDX STRNGP
INTRNX:	LDA #$01	;Not found anywhere
	STA NOVALU+1
	LDA RETPTR
	STA NODPTR
	LDY #NOVALU
;	LDA #LIST
	JSR LCONS
	LDA RETPTR
	STA NODPTR
	TAX
	LDY #NOVALU
;	LDA #ATOM
	JSR ACONS
;	LDA #LIST
	LDX #OBLIST
	STX NODPTR
	LDY RETPTR
	JMP LCONS
SBFW1:	GETX SOBPTR
	LDY #$02
	LDA (SOBPTR),Y
	INY
	CLC
	ADC #PRMNAM
	STA SOBNAM
	LDA (SOBPTR),Y
	ADC #$00
	STA SOBNAM+1
	LDX STRNGP
	GETX STRNG1
MTC1W:	LDA STRNG1+1
	BEQ SBFNF
MTC1W1:	CAR CHARS,STRNG1
	LDY #$00
	LDA GETRM2	;Enable ghost-memory
	LDA (SOBNAM),Y
	LDX GETRM1	;Disable ghost-memory
	LDX GETRM1
	CMP CHARS
	BNE SBFNF
	INC1 SOBNAM
	LDA GETRM2	;Enable ghost-memory
	LDA (SOBNAM),Y
	LDX GETRM1	;Disable ghost-memory
	LDX GETRM1
	CMP CHARS+1
	BNE SBFNF
	CDRME STRNG1
	LDA GETRM2	;Enable ghost-memory
	LDY #$00
	LDA (SOBNAM),Y
	LDX GETRM1	;Disable ghost-memory
	LDX GETRM1
	TAX
	BEQ MTC1WF
	INC1 SOBNAM
	LDA STRNG1+1
	BNE MTC1W1
	LDA GETRM2	;Enable ghost-memory
	LDA (SOBNAM),Y
	LDX GETRM1	;Disable ghost-memory
	LDX GETRM1
	TAX
	BNE SBFNF
MTC1WF:	RTS
SBFNF:	CLC		;not this soblist object
	LDX RETPTR
	INC4X
	JMP SBFWX
.PAGE
.SBTTL		Linked-list Utility Routines

;	Local variable block:
LSTPTR	=TEMPNH		;List ptr.

;Return length of list Y to addr. in X.
GETLEN:	GETY LSTPTR
	LDA #$00
	STA $00,X
	STA $01,X
GLENW1:	LDA LSTPTR+1
	BEQ GLENR
	LDY #$00
	LDA (LSTPTR),Y
	CMP COMMNT
	BNE GLENW2
	INY
	LDA (LSTPTR),Y
	CMP COMMNT+1
	BEQ GLENR
GLENW2:	LDY #$02
	LDA (LSTPTR),Y
	PHA
	INY
	LDA (LSTPTR),Y
	STA LSTPTR+1
	PLA
	STA LSTPTR
	INC $00,X
	BNE GLENW1
	INC $01,X
	BNE GLENW1	;(Always)

;	Local variable block:
RETPTR	=ANSN		;Addr. of returned ptr.
LSTPTR	=TEMPNH		;List ptr.

GTLSTC:	STX RETPTR
	GETX LSTPTR
	LDY #$02
GTLC2:	LDA (LSTPTR),Y
	TAX
	INY
	LDA (LSTPTR),Y
	BEQ GTLC3
	STA LSTPTR+1
	STX LSTPTR
	DEY
	BNE GTLC2	;(Always)
GTLC3:	LDX RETPTR
	PUTX LSTPTR
GLENR:	RTS

MAKMTW:	STA NODPTR	;Make A point to the empty word
	LDA #$00
	TAX
	TAY
;	LDA #STRING
	JMP STCONS
.PAGE
.SBTTL		Error Routines

;	Local variable block:
ERPTR1	=TEMPX1		;X reg. error pointer
ERPTR2	=TEMPX2		;Y reg. error pointer
ERRX	=ANSN2		;X reg. error ptr. addr.
ERRY	=ANSN3		;Y reg. error ptr. addr. (shared: ERROR,ERROR1)
ERRIDX	=ANSN1		;Error table index
ERRMSG	=TEMPN8		;Error message address
LINPTR	=TEMPN8		;Fpacked line ptr. (shared: TPLINF,ERROR,POFUN)
ENDPTR	=TEMPX2		;Fpacked line-end ptr. (shared: TPLINF,ERROR,POFUN)
ATMNAM	=TEMPN8		;Atom name
JMPADR	=TEMPNH		;Error handler address

PTRXOK:	GETX ERPTR1	;Use explicit pointers so they don't get bashed
	LDX #ERPTR1
	RTS

PTRYOK:	GETY ERPTR2
	LDY #ERPTR2
	RTS

;This runs all the unwind protects for the error routines.  If a section
;of code needs something undone before it exits abnormally via some error,
;there should be a call to a routine which knows whether this routine needs
;to be run at any time.  Every error will call this routine, which should
;do what needs to be done, including clearing the flag which says it
;needs to be run, if that is appropriate.
;These routines must not bash ERRNUM, ERRX, ERRY, ERPTR1, or ERPTR2.
;

EUNWPT:	JSR RSTIO	;reset io. Always. Can't hurt.
.IFNE GRPINC
	JSR GRUNW
.ENDC
.IFNE MUSINC
	JSR MUUNW	;Music Unwind protect.
.ENDC
	JSR EXTDEF	;Zap out of EDIT or CHANGE mode if necessary
	JSR GCUNW	;clear mark array; clear MARKN pointers if during GC.
	JMP RUNUNW	;RUN/REPEAT unwind protect.


ERROR:	STA ERRNUM
	STX ERRX
	STY ERRY
	JSR PTRXOK
	JSR PTRYOK
	JSR EUNWPT	;Run all the Unwind-protects.
	LDA ERRNUM
	STA ERRIDX
	ASL ERRIDX
	CMP #XZAP
	BEQ ERRZ1
	CLC		;The Error-table holds pointers to the error-strings
	LDA #ERRTBL&$FF
	ADC ERRIDX
	STA ERRMSG
	LDA #ERRTBL^
	ADC #$00
	STA ERRMSG+1
	LDA GETRM2	;Enable Ghost-memory
	CARME ERRMSG
ERRW:	LDA GETRM2	;Enable Ghost-memory
	LDY #$00
	LDA (ERRMSG),Y
	LDX GETRM1	;Ghost-memory disable
	LDX GETRM1
	TAX
	BEQ ERRWE
	CMP #$01
	BEQ ERRW1
	CMP #$02
	BEQ ERRW2
	JSR TPCHR
	JMP ERRW4
ERRZ1:	JSR BREAK1
	LDA ERRY
	ASL A
	TAY
	LDA GETRM2	;Enable ghost-memory
	LDX ZAPTBL,Y
	LDA ZAPTBL+1,Y
	TAY
	LDA GETRM1	;Disable ghost-memory
	LDA GETRM1
	JSR PRTSTR
	LDA ERRY
	CMP #$04
	BCC ERRWE
	PRTSTR ZPMX1
	JMP ERRWE
ERRW2:	LDX ERRX
	BCS ERRW3	;(Always)
ERRW1:	LDX ERRY
ERRW3:	INC OTPFLG	;Fake out LTYPE so funny-pnames are quoted
	JSR LTYPE0
	DEC OTPFLG	;Restore flag
ERRW4:	INC ERRMSG
	BNE ERRW
	INC ERRMSG+1
	BNE ERRW	;(Always)
ERRWE:	LDA LEVNUM
	ORA LEVNUM+1
	BEQ ERR1
	LDA FBODY+1
	BEQ ERR1	;Toplevel of a break-loop if this is zero
	PRTSTR ERRM2
	CAR LINPTR,FPTR	;Get the line from the rest of the body
ERRWE2:	LDA UFRMAT
	BEQ TPLINE
	CDR ENDPTR,FPTR
	JSR TPLINF
	JMP ERWE1B
TPLINE:	LDA #$20
	JSR TPCHR
	LDX #LINPTR
	JSR LTYPE1
ERWE1B:	PRTSTR ERRM1
	LDX #LEVNUM
	JSR TYPFIX
	PRTSTR ERRM3
	LDY #SFTOKN	;Frame UFUN (CURTOK) index
	LDA (FRAME),Y
	STA ATMNAM
	INY
	LDA (FRAME),Y
	STA ATMNAM+1
	LDX #ATMNAM
	JSR LTYPE
ERR1:	JSR BREAK1
	JMP ERROR1	;Unwind the stack and return to toplevel, probably.
.PAGE
;SYSBUG prints an error message and exits to the Monitor.
;Associated error codes are:
; 1 - Bad  EVAL typecode
; 2 - V-Primitive not found
; 3 - Dispatch typecode out of range
; 4 - Bad CONS typecode NO LONGER USED.
; 5 - Bad LTYPE typecode
; 6 - Music code bug
; 7 - Bad GCOLL typecode (Sfun)

SYSBUG:	STA $02		;Error code
	PLA
	STA $01		;Store calling point in locations $00,$01
	PLA
	STA $00
	TXA
	PHA
	TYA
	PHA
	JSR RSTIO
	PRTSTR LBUG1	;Print "LOGO BUG!"
	PLA		;we can re-enter from monitor at POPJ
	TAY
	PLA
	TAX
	LDA $02
SBPT:	BRK
	NOP
	NOP
	JSR SETUP
	JMP POPJ
.PAGE
.IFNE GRPINC	;Include Graphics if GRPINC nonzero
.SBTTL	Turtle-Graphics Primitives

;Graphics unwind-protect routine.
GRUNW:	LDA GRPHCS
	BPL GRUNWX
	LDA MIXGR	;If graphics, make MIXED. Ok if already mixed.
GRUNWX:	RTS

SDRAW:	LDA GRPHCS
	BMI SDRAWA
SDRAWB:	JSR SDRAW1
	JMP POPJ
SDRAWA:	JSR SDRAW2
	JMP POPJ

SCS:	LDA GRPHCS
	BPL SDRAWB
	JSR SCS1
	JMP POPJ

SNDSPL:	JSR RESETT	;Nodisplay, get the text page back
	INC GRPHCS
	JMP POPJ

SPENUP:	JSR GSTART
	LDA #$00	;Penup
	BEQ STPEN	;(Always)

SPENDN:	JSR GSTART
	LDA #$01	;Pendown
STPEN:	STA PEN
	JMP POPJ

SHOME:	JSR GSTART
	JSR GSHWT1	;Erase turtle if it's there
	JSR TTLHOM
	JSR GETX
	JSR GETY
	JSR GDLINE
	JMP POPJ

SXCOR:	JSR GSTART	;Xcor
	LDY #XCOR
	JMP OTPFLO

SYCOR:	JSR GSTART	;Ycor
	LDY #YCOR
	JMP OTPFLO

SHDING:	JSR GSTART	;Heading
	LDY #HEADNG
	JMP OTPFLO
.PAGE
SRT:	JSR GSTART
	JSR GT1FLT
	LDY #HEADNG
	JSR XYTON2
	JSR FADD
	JSR MOD360
	JSR HDNDON
	JMP STRTTL

SLT:	JSR GSTART
	JSR GT1FLT
	LDY #HEADNG
	JSR XYTON2
	JSR FSUBX
	JSR MOD360
	JSR HDNDON
	JMP STRTTL

STS:	JSR GSTART	;Turtlestate
	LDA #$00
	STA MARK1+1
	LDA COLNUM
	JSR CONSN1
	LDA PALETN
	JSR CONSN1
	LDA TSHOWN
	JSR CONSTF
	LDA PEN
	JSR CONSTF
	LDA #HEADNG
	JSR CONSNM
	LDA #YCOR
	JSR CONSNM
	LDA #XCOR
	JSR CONSNM
	VPUSH MARK1
	INC OTPUTN
	LDA #$00
	STA MARK1+1
	JMP POPJ
.PAGE
SSETX:	JSR GSTART
	VPOP ARG1
	JSR GSETX
	JSR XOK
	JSR GSHWT1
	JSR GETY
	JSR GDLINE
	JMP POPJ

SSETY:	JSR GSTART
	VPOP ARG1
	JSR GSETY
	JSR YOK
	JSR GSHWT1
	JSR GETX
	JSR GDLINE
	JMP POPJ

;	Local variable block:
SAVRG2	=TEMPX2		;ARG2 save

SSETXY:	JSR GSTART
	VPOP SAVRG2
	VPOP ARG1
	JSR GSETX
	MOV NARG1,SAVRG2
	JSR GSETY
	JSR XOK
	JSR YOK
	JSR GSHWT1
	JSR GDLINE
	JMP POPJ

SSETH:	JSR GSTART
	VPOP ARG1
	JSR GSETH
STRTTL:	JSR GSHWT1
	JSR HOK
	JSR GSHWT1
	JMP POPJ
.PAGE
;	Local variable block:
LSTPTR	=TEMPX2		;Running arglist pointer (shared: SSETT,SSTTLL)
DSPTCH	=ANSN4		;Element disptach no. (shared: SSETT,SSTTLL)

SSETT:	JSR GSTART
	VPOP LSTPTR	;Setturtle
	JSR GETTYP
	CMP #LIST
	BNE SSETTR
	LDA #$F9	;Index for dispatching
	STA DSPTCH
SSETTL:	LDA LSTPTR+1
	BEQ SSETTD
	JSR SSTTLL
	INC DSPTCH
	BNE SSETTL
SSETTD:	JSR GSHWT1	;erase the turtle if it is being shown.
	JSR HOK
	JSR XOK
	JSR YOK
	JSR GDLINE
	LDA SPEN
	STA PEN
	LDA STSHWN
	STA TSHOWN
	LDX SPLTN
	JSR BKGNDX
	LDX SCLNM
	STX COLNUM
	LDA CLTAB1,X
	STA PNCOLR
	JMP GSHTPJ	;draw turtle in new position, if it is supposed
			;to be shown, and POPJ.
SSETTR:	JMP ERXWT1

SSHOWT:	JSR GSTART
	LDA TSHOWN
	BNE SSHWTR
	INC TSHOWN
	JSR DRWTTL
SSHWTR:	JMP POPJ

SHIDET:	JSR GSTART
	LDA TSHOWN
	BEQ SSHWTR
	DEC TSHOWN
	JSR DRWTTL
	JMP POPJ

SFULL:	JSR GSTART
	LDA FULLGR
	JMP POPJ

SSPLIT:	JSR GSTART
	LDA MIXGR
	JMP POPJ
.PAGE
SFD:	JSR GSTART
	JSR GT1FLT
SFD1:	JSR SFDX
	JSR GSHWT1
	JSR XOK
	JSR YOK
	JSR GDLINE
	JMP POPJ

SBK:	JSR GSTART
	JSR GT1FLT
	JSR FCOMPL
	JMP SFD1
.PAGE
;SPALET:	JSR GSTART
;	JSR GT1FIX
;	JSR CKCOLR
;	LDX NARG1
;	STX PALETN
;	LDA CLTAB1,X	;Lookup the background color
;	STA BKGND
;	JSR SDRAW2
;	LDX #$01	;Default is PC 1
;	STX COLNUM
;	LDA CLTAB1+1
;	STA PNCOLR
;	JMP POPJ

CKCOLR:	LDA #$06	;Highest palette no.
	JSR SMLFX1	;Check the argument in NARG1.
	BCC CKCLR
	JMP GTERR1

SPENC:	JSR GSTART
	JSR GT1FIX
	JSR CKCOLR
	LDX NARG1
	STX COLNUM
	LDA CLTAB1,X
	STA PNCOLR
	JMP POPJ

SBKGND:	JSR GSTART
	JSR GT1FIX
	JSR CKCOLR
	LDX NARG1
	JSR BKGNDX
	JMP POPJ

BKGNDX:	CPX PALETN
	BEQ CKCLR
	LDA CLTAB1,X
	STX PALETN
	EOR BKGND
	JSR CBKGND
	LDX PALETN
	LDA CLTAB1,X
	STA BKGND
CKCLR:	RTS

SSCNCH:	JSR GT1FLT
	SETNUM SCRNCH,NARG1
	JMP POPJ

;		  0	  1	  2	  3	  4	  5	  6
;Colors:	BLACK	WHITE	GREEN	VIOLET	BLUE	ORANGE	XOR
;Palettes:	BLACK	WHITE	GREEN	VIOLET	BLUE	ORANGE	SINGLE

;Color table.
CLTAB1:	$00
	$FF
	$2A
	$55
	$AA
	$D5
	$00
.PAGE
SRDPCT:	JSR GSTART
	JSR SRDX1
	LDX #SCRNM&$FF
	LDY #SCRNM^
	JSR SRDX2
	LDX DSKB1
	STX PALETN
	LDA CLTAB1,X
	STA BKGND
	LDX DSKB2
	STX COLNUM
	LDA CLTAB1,X
	STA PNCOLR
GSHTPJ:	JSR GSHWT1	;Re-show turtle if shown, and POPJ.
SRDPC1:	JMP POPJ

SSVPCT:	JSR GSTART
	VPOP ARG1
	JSR GETTYP
	CMP #ATOM
	BEQ SSVST2
	CMP #SATOM
	BEQ SSVST2
	CMP #STRING
	BNE SSVSR3
SSVST2:	LDA TSHOWN	;Hide turtle if shown
	PHA		;Save TSHOWN
	BEQ SSVST3
	DEC TSHOWN
	LDA ARG1
	PHA
	LDA ARG1+1
	PHA
	JSR DRWTTL
	PLA
	STA ARG1+1
	PLA
	STA ARG1
SSVST3:	LDA PALETN
	STA DSKB1
	LDA COLNUM
	STA DSKB2
	JSR DOSSTP	;Wake up DOS
	PRTSTR SAVEM
	JSR DTPATM	;Type atom DOS-style
	PRTSTR SCRNM
	PRTSTR SAVEM2
	PRTSTR SAVEM4	;write file
	LDA #$8D
	JSR TPCHR	;let it go
	JSR DOSOFF
	PLA
	STA TSHOWN
	JSR GSHWT1
SSVPC1:	JMP POPJ
SSVSR3:	JMP ERXWT1
.PAGE
.SBTTL		Turtle-Graphics Utility Routines

;Graphics init routine: set up scrunch factor to GRPHK1.
GRINIT:	SETNUM SCRNCH,GRPHK1
	RTS

GSTART:	LDA INPFLG
	BNE GRIGN	;Ignore primitive if in eval-loop
	LDA GRPHCS	;Checks to see if Graphics mode
	BMI SDRAW3
SDRAW1:	LDX #$00	;Set up default palette and pencolor
	STX PALETN	;(Double width white on black)
	LDA CLTAB1
	STA BKGND
	INX
	STX COLNUM
	LDA CLTAB1+1	;Default is pencolor 1
	STA PNCOLR
	JSR NOEDBF	;Buffer is not retrievable
	LDA PRMPAG	;Primary page
	LDA HGSW
	LDA MIXGR
	LDA #$00
	STA CH
	LDA #$14
	STA CV
	JSR BCALCA	;Put cursor at line 20.
	JSR CLREOP	;Clear to end of page
	LDA #$FF
	STA GRPHCS	;Indicate Graphics mode
SDRAW2:	LDA #$01
	STA PEN
	STA TSHOWN	;turtle shown
	JSR TTLHOM
SCS1:	JSR GETX
	JSR GETY
	JSR GPOSN	;Set initial POSN point for future GLINE's
	LDA BKGND
	JSR HBKGND
	JSR GSHWT1
	LDA GSW
SDRAW3:	RTS
GRIGN:	JMP POPJ

TTLHOM:	LDA #$00	;NOTE: XCOR,YCOR,HEADNG must be contiguous
	LDX #$0B
TTLL1:	STA XCOR,X
	DEX
	BPL TTLL1
	RTS
.PAGE
;	Local variable block:
NUMPTR	=TEMPX1
XNUM	=TEMPN

CONSTF:	BNE CNSTF1
	LDY #LFALSE
	BNE CNSNM1	;(Always)
CNSTF1:	LDY #LTRUE
	BNE CNSNM1	;(Always)
CONSN1:	STA XNUM
	LDA #$00
	STA XNUM+1
	CONS NUMPTR,XNUM,0,FIX
	JMP CNSNM2
CONSNM:	TAX
	TAY
	INX
	INX
	LDA #NUMPTR
	STA NODPTR
;	LDA #FLO
	JSR FNCONS	;CONS the number
CNSNM2:	LDY #NUMPTR
CNSNM1:	LDX #MARK1
	STX NODPTR
;	LDA #LIST
	JMP LCONS	;CONS the node

;	Local variable block:
LSTPTR	=TEMPX2		;Running arglist pointer (shared: SSETT,SSTTLL)
DSPTCH	=ANSN4		;Element no. (shared: SSETT,SSTTLL)

SSTTPL:	JSR GT1FX1
	JSR CKCOLR
	LDA NARG1
	STA SPLTN
	RTS
SSTTPC:	JSR GT1FX1
	JSR CKCOLR
	LDA NARG1
	STA SCLNM
	RTS

SSTTLL:	CARNXT ARG1,LSTPTR
	LDX #ARG1
	LDY DSPTCH
	INY
	BEQ SSTTPC
	INY
	BEQ SSTTPL
	INY
	BEQ SSTTS
	INY
	BEQ SSTTP
	INY
	BEQ GSETH
	INY
	BEQ GSETY
	BNE GSETX	;(Always)
SSTTS:	JSR GTBOOL
	INY
	TYA
	AND #$01
	STA STSHWN
	RTS
SSTTP:	JSR GTBOOL
	INY
	TYA
	AND #$01
	STA SPEN
	RTS
.PAGE
GSETH:	JSR GT1FLX	;Setheading
	JSR MOD360
HDNDON:	SETNUM SHEDNG,NARG1
	RTS

;	Local variable block:
XSCR	=EPOINT		;Screen X-coordinate (shared: GSETX,GNORM)

GSETX:	JSR GT1FLX	;Set X
XCHK:	SETNUM SVXCOR,NARG1
	JSR RNDN1
	LDX #NARG1
	JSR CHKINT
	BCS ERXOOB
	TAX
	BMI XCHKM
	LDA NARG1+1
	BNE ERXOOB
	LDA NARG1
	CMP #$8C	;Must be <140.
	BCC STOX
	BCS ERXOOB	;(Always)
XCHKM:	LDA NARG1+1
	CMP #$FF
	BNE ERXOOB
	LDA NARG1
	CMP #$74	;Must be >=-140.
	BCC ERXOOB
STOX:	LDA NARG1
	STA XSCR
	LDA NARG1+1
	STA XSCR+1
	RTS

;	Local variable block:
YSCR	=A5L		;Screen Y-coordinate (shared: GSETY,GNORM)

GSETY:	JSR GT1FLX	;Set Y
YCHK:	LDX #$03
YCHKL:	LDA NARG1,X
	STA SVYCOR,X
	LDA SCRNCH,X
	STA NARG2,X
	DEX
	BPL YCHKL
	JSR FMUL	;First multiply by scrunch factor
	JSR RNDN1
	LDX #NARG1
	JSR CHKINT
	BCS ERXOOB
	TAX
	BMI YCHKM
	LDA NARG1+1
	BNE ERXOOB
	LDA NARG1
	CMP #$60	;Must be <96.
	BCC STOY
ERXOOB:	ERROR XOOB	;Error "Out of Bounds"
YCHKM:	LDA NARG1+1
	CMP #$FF
	BNE ERXOOB
	LDA NARG1
	CMP #$A1	;Must be >=-95.
	BCC ERXOOB
STOY:	LDA NARG1
	STA YSCR
	RTS

XOK:	SETNUM XCOR,SVXCOR
	RTS

YOK:	SETNUM YCOR,SVYCOR
	RTS

HOK:	SETNUM HEADNG,SHEDNG
	RTS
.PAGE
GDLINE:	LDA PEN
	BNE GDLIN1
	JSR GPOSN	;Just do a GPOSN if pen is up
        JMP GSHWT1
GDLIN1:	JSR GLINE
;	...

;now draw the turtle if it is being shown
;	...
GSHWT1:	LDA TSHOWN	;If the turtle isn't shown, exit.
	BNE DRWTTL	
GSHWTR:	RTS
;	...
;	Local variable block:
QDRNT	=TEMPN6+1
;	...
;this draws the turtle
DRWTTL:	LDY #HEADNG
	JSR XYTON1	;Get heading in NARG1
	LDA Y0		;Save enpoint state
	PHA
	LDA X0L
	PHA		;Popped after DRWL3.
	LDA X0H
	PHA
	SETNUM NARG2,FROTK1	;Get shift factor (2.5) in NARG2
	JSR FADD	;Shift turtle over 2.5 degrees
	JSR RNDN1	;Get the heading as a rounded integer
;Actually, I think that "quadrant" here is the counter for which
;pre-defined turtle shape to use, and shape number is which rotation
;to use.
	LDA #$05
	JSR XDVDX	;Divide by 5 to get shape number
	LDX #$FF	;Quadrant counter
	LDA NARG1
	SEC
DRWL2:	INX		;indicate next quadrant
	SBC #$12	;See if it's smaller than 18. yet
	BCS DRWL2	;Nope, subtract 18.
	ADC #$12	;OK, add last subtraction back in
	ASL A		;Shift left to get table index
	TAY
	LDA USHAPE	;Use a user shape instead of our wonderful
	ORA USHAPE+1	;turtle?
	BEQ DRWL3
	LDA USHAPE
	STA SHAPE
	LDA USHAPE+1
	STA SHAPE+1
	JMP DRWL4
;Get the proper shape for this rotation.
DRWL3:	LDA GETRM2	;Enable Ghost-memory
	LDA SHPTBL,Y
	STA SHAPE
	LDA SHPTBL+1,Y
	STA SHAPE+1
	LDA GETRM1	;Disable Ghost-memory
	LDA GETRM1
;Determine what orientation to display this shape in.
DRWL4:	TXA		;Quadrant
	ASL A
	ASL A
	ASL A
	ASL A		;Multiply quadrant index by 4 to get rotation factor
	JSR XDRAW	;called with A = ROT, shape addr. in SHAPE
	PLA		;(X0H)
	TAY
	PLA		;(X0L)
	TAX
	PLA		;(Y0)
	JMP HPOSN	;Re-position at endpoint
.PAGE
;	Local variable block:
LENGTH	=TEMPX1		;Line length
SGNX	=ANSN1		;X-Incr. sign (shared: SSIN,GETSIN,SFDX)
SGNY	=ANSN2		;Y-Incr. sign (shared: SCOS,GETSIN,SFDX)
FRACT	=TEMPN7		;Interpolation fraction (shared: SSIN,SCOS,GETSIN,SFDX)
LOWENT	=TEMPN5		;Low table entry (shared: SSIN,MULCOS,SFDX)
HIENT	=TEMPN3		;High table entry (shared: SCOS,MULCOS,SFDX)

SFDX:	LDY #LENGTH
	JSR XN1TOY
	LDY #HEADNG
	JSR XYTON2	;Get HEADING in NARG2
	LDY #HEADNG
	JSR XYTON1	;And in NARG1
	JSR GETSN1
	LDA NARG1
	PHA		;Save table index
	JSR MULSIN
	LDY #FRACT
	JSR XYTON2	;Restore interpolation fraction
	JSR FMUL	;Get interpolation correction
	LDY #LOWENT
	JSR XYTON2	;Get uncorrected table value...
	JSR FADD	;and correct it!
	LDY #LENGTH
	JSR XYTON2	;Get length back
	JSR FMUL	;Multiply Length by fraction
	LDA SGNX	;X-Incr. sign
	BEQ SFDP1
	JSR FCOMPL
SFDP1:	LDY #XCOR	;Get XCOR in NARG2
	JSR XYTON2
	JSR FADD
	JSR XCHK
	PLA		;Retrieve NARG1
	STA NARG1
	JSR MULCOS
	LDY #FRACT
	JSR XYTON2	;Restore interpolation fraction
	JSR FMUL	;Get interpolation correction
	LDY #HIENT
	JSR XYTON2	;Get uncorrected table value...
	JSR FSUBX	;and correct it!
	LDY #LENGTH
	JSR XYTON2	;Get length back
	JSR FMUL	;Multiply Length by fraction
	LDA SGNY	;Y-Incr. sign
	BEQ SFDP2
	JSR FCOMPL
SFDP2:	LDY #YCOR
	JSR XYTON2	;Get YCOR in NARG2
	JSR FADD	;Add YCOR and NARG1 (Y-incr.)
	JMP YCHK
.PAGE
GETX:	LDY #XCOR
	JSR XYTON1
	JSR RNDN1
	JMP STOX

GETY:	LDY #YCOR
	JSR XYTON1
	SETNUM NARG2,SCRNCH
	JSR FMUL	;multiply by scrunch factor
	JSR RNDN1
	JMP STOY

;	Local variable block:
XSCR	=EPOINT		;Screen X-coordinate (shared: GSETX,GNORM)
YSCR	=A5L		;Screen Y-coordinate (shared: GSETY,GNORM)
XCORD	=NARG2+1	;Mapped X coordinate (shared: GNORM,GPOSN,GLINE)
YCORD	=NARG2		;Mapped Y coordinate (shared: GNORM,GPOSN,GLINE)

GNORM:	SEC
	LDA #$60
	SBC YSCR	;Subtract Ycoord from 96.
	STA YCORD
	CLC
	LDA XSCR
	ADC #$8C	;Add 140. to Xcoord
	STA XCORD
	LDA XSCR+1
	ADC #$00
	STA XCORD+1
	RTS
.PAGE
;Lowest-level graphics routines:

HCOLR1	=TEMPN3		;Interface labels to temporaries
COUNTH	=TEMPN3+1
DXL	=TEMPN5
DXH	=TEMPN5+1
DY	=TEMPN6
QDRNT	=TEMPN6+1
EL	=TEMPN7
EH	=TEMPN7+1
SHAPEX	=ANSN2

HBKGND:	STA HCOLR1
	LDA #$20
	STA SHAPE+1	;SHAPE is byte address
	LDY #$00
	STY SHAPE
BKGND1:	LDA HCOLR1
	STA (SHAPE),Y
	JSR CSHFT2	;Shift mask over every byte (XABABABA -> XBABABAB)
	INY
	BNE BKGND1
	INC SHAPE+1	;Next page
	LDA SHAPE+1
	CMP #$40
	BNE BKGND1
	RTS

;XORs HCOLR1 with every screen byte.
CBKGND:	STA HCOLR1
	LDA #$20
	STA SHAPE+1	;SHAPE is byte address
	LDY #$00
	STY SHAPE
CBKGN1:	LDA (SHAPE),Y
	EOR HCOLR1
	STA (SHAPE),Y
	JSR CSHFT1	;Shift mask over
	INY
	BNE CBKGN1
	INC SHAPE+1	;Next page
	LDA SHAPE+1
	CMP #$40
	BNE CBKGN1
	RTS

;	Local variable block:
XCORD	=NARG2+1	;Mapped X coordinate (shared: GNORM,GPOSN,GLINE)
YCORD	=NARG2		;Mapped Y coordinate (shared: GNORM,GPOSN,GLINE)

GPOSN:	JSR GNORM
	LDX XCORD
	LDY XCORD+1
	LDA YCORD
HPOSN:	STA Y0		;Calculates HBASLN and HNDX from dot coordinates
	STX X0L		;Just trust it, don't ask any questions...
	STY X0H
	PHA
	AND #$C0
	STA HBASLN	;Y coord. is ABCDEFGH
	LSR A
	LSR A
	ORA HBASLN
	STA HBASLN	;HBASLN now ABAB0000
	PLA
	STA HBASLN+1	;HBASLN+1 now ABCDEFGH
	ASL A
	ASL A
	ASL A		;A now DEFGH000
	ROL HBASLN+1	;HBASLN+1 now BCDEFGHC
	ASL A		;A now EFGH0000
	ROL HBASLN+1	;HBASLN+1 now CDEFGHCD
	ASL A		;A now FGH00000
	ROR HBASLN	;HBASLN now EABAB000
	LDA HBASLN+1
	AND #$1F
	ORA #$20
	STA HBASLN+1	;HBASLN,+1 now 001FGHCD EABAB000 (of course)
	TXA		;(X coord. low in A, high in Y)
	CPY #$00	;High byte either 0 or 1
	BEQ HPOSN2	;It's 0, start byte count (Y) at 0
	LDY #$23	;It's 1, start byte count at $23 and add four to X coord.
	ADC #$04	;(because $23 * 7 + 4 = $FF, that's why)
HPOSN1:	INY
HPOSN2:	SBC #$07	;Subtract sevens until borrow set
	BCS HPOSN1
	STY HNDX	;Byte count is offset index (for memory accesses from HBASLN)
	TAX		;Remainder specifies bit position, get the byte mask
	LDA MSKTBL-249,X
	STA HMASK
	TYA
	LSR A		;Sets carry if on odd byte
	LDA PNCOLR
HPOSN3:	STA HCOLR1	;Deposits the color mask, shifts it
	BCS CSHFT2	;if we are on an odd byte
	RTS

LFTRT:	BPL RIGHT	;Sign of A determines left/right direction
	LDA HMASK	;Going left: rotate bits right (Apple's shift register is
	LSR A		;in backwards, no doubt...)
	BCS LEFT1	;Whoops, into next byte
	EOR #$C0	;Change the top bits (ie bit 6 off, bit seven on)
LR1:	STA HMASK
	RTS

LEFT1:	DEY		;Mask bit was bumped into MSB of the byte to the left
	BPL LEFT2	;If we're at the left edge,
	LDY #$27	;then wrap around
LEFT2:	LDA #$C0
NEWNDX:	STA HMASK	;New HMASK along with
	STY HNDX	;new horiz. index, let's see
CSHFT1:	LDA HCOLR1	;if the color mask should be shifted...
CSHFT2:	ASL A		;Reverses color mask if necessary.
	CMP #$C0	;CMP gives Minus if top two bits different
	BPL GRTS1	;i.e., reverse mask only if mask isn't solid
	LDA HCOLR1
	EOR #$7F	;XABABABA -> XBABABAB
	STA HCOLR1
GRTS1:	RTS

RIGHT:	LDA HMASK	;Going right: shift mask to the left (backwards shift register,
	ASL A		;again...)
	EOR #$80	;Reverse top bit
	BMI LR1		;Mask OK if bit 7 on (ie bit 6 was off)
	LDA #$81	;The new mask (bit 0 on)
	INY		;Incr. horiz. index
	CPY #$28	;If at edge, wrap around. Store new mask.
	BCC NEWNDX
	LDY #$00
	BCS NEWNDX	;(Always taken)
.PAGE
LRUDX1:	CLC
LRUDX2:	LDA SHAPEX
	AND #$04
	BEQ LRUD4
	LDA #$7F
	AND HMASK
	EOR (HBASLN),Y
	STA (HBASLN),Y
LRUD4:	LDA SHAPEX
	ADC QDRNT
EQ3:	AND #$03
	CMP #$02
	ROR A
	BCS LFTRT
UPDWN:	BMI DOWN4	;Dispatch off sign in A
	CLC		;We're going up
	LDA HBASLN+1	;No need to extrapolate the details...
	BIT EQ1C
	BNE UP4
	ASL HBASLN
	BCS UP2
	BIT EQ3+1
	BEQ UP1
	ADC #$1F
	SEC
	BCS UP3		;(Always taken)
UP1:	ADC #$23
	PHA
	LDA HBASLN
	ADC #$B0
	BCS UP5
	ADC #$F0
UP5:	STA HBASLN
	PLA
	BCS UP3
UP2:	ADC #$1F
UP3:	ROR HBASLN
UP4:	ADC #$FC
UPDWN1:	STA HBASLN+1
	RTS

DOWN4:	LDA HBASLN+1	;We're going down
EQ4:	ADC #$04	;Weeeeeee...
	BIT EQ1C
	BNE UPDWN1
	ASL HBASLN
	BCC DOWN1
	ADC #$E0
	CLC
	BIT EQ4+1
	BEQ DOWN2
	LDA HBASLN
	ADC #$50
	EOR #$F0
	BEQ DOWN3
	EOR #$F0
DOWN3:	STA HBASLN
	LDA #$20
	BCC DOWN2
DOWN1:	ADC #$E0
DOWN2:	ROR HBASLN
	BCC UPDWN1	;(Always branches)
.PAGE
;	Local variable block:
XCORD	=NARG2+1	;Mapped X coordinate (shared: GNORM,GPOSN,GLINE)
YCORD	=NARG2		;Mapped Y coordinate (shared: GNORM,GPOSN,GLINE)
HMASK1	=TEMPNH		;HMASK with MSB=0
HMASK2	=TEMPNH+1	;HMASK shifted left one bit

GLINE:	JSR GNORM	;Map coordinates onto Apple's axes
	LDA YCORD
	CMP Y0
	BCS GLINE1	;OK if drawing downwards or horiz.
	LDA XCORD
	PHA
	TAX
	LDA X0L
	STA XCORD
	LDA XCORD+1
	PHA
	TAY
	LDA X0H
	STA XCORD+1
	LDA YCORD
	PHA
	LDA Y0
	STA YCORD
	PLA
	PHA
	JSR HPOSN	;Position turtle at other endpoint
	LDA HBASLN	;Save endpoint sate
	PHA
	LDA HBASLN+1
	PHA
	LDA HMASK
	PHA
	LDA HCOLR1
	PHA
	LDA HNDX
	PHA
	JSR GLINE1
	PLA		;Update turtle position to new endpoint
	STA HNDX
	PLA
	STA HCOLR1
	PLA
	STA HMASK
	PLA
	STA HBASLN+1
	PLA
	STA HBASLN
	PLA
	STA Y0
	PLA
	STA X0H
	PLA
	STA X0L
	RTS

GLINE1:	LDA HNDX
	LSR A
	LDA PNCOLR
	JSR HPOSN3	;Deposit and init color mask (shifts if necessary)
	LDY YCORD
	LDX XCORD+1
	LDA XCORD
	PHA
	SEC		;Compare X0 and XCORD
	SBC X0L
	PHA
	TXA
	SBC X0H
	STA QDRNT	;Quadrant := XCORD - X0, sign determines right or left dir.
	BCS HLIN2	;Branch if XCORD geq X0
	PLA		;Retrieve XCORD - X0 (low)
	EOR #$FF	;Negate
	ADC #$01
	PHA		;Save again
	LDA #$00
	SBC QDRNT	;Negative QDRNT for...
HLIN2:	STA DXH		;X-Incr. := ABS ( XCORD - X0 )
	STA EH
	PLA
	STA DXL
	STA EL
	PLA
	STA X0L		;X0 := XCORD
	STX X0H
	TYA
	CLC
	SBC Y0
	BCC HLIN3
	EOR #$FF
	ADC #$FE
HLIN3:	STA DY		;Y-Incr. := - ABS ( YCORD - Y0 ) - 1
	STY Y0		;Y0 := YCORD
	ROR QDRNT	;QDRNT sign bit gets 0 for up, 1 for down
	SEC		;(so bit 6 is now right/left direction select)
	SBC DXL		;Compute - (Delta.X + Delta.Y + 1)
	STA YSAV1	;in YSAV1 for loop dot counter
	LDA #$FF
	SBC DXH
	STA COUNTH	;COUNTH gets -1 if more than 256 dots, ie is counter high byte
	LDY HNDX	;Y has horiz. index during loop
	BCS MOVEX2	;(Always taken)
MOVEX:	ASL A		;Move horizontally: Bit 6 of QDRNT (in A)
	JSR LFTRT	;determines direction, LFTRT looks at sign (bit 7)
	SEC
MOVEX2:	LDA EL		;(Carry set here) 
	ADC DY
	STA EL		;Compute epsilon
	LDA EH
	SBC #$00	;Carry bit after this operation determines horiz. or vert. movement
HCOUNT:	STA EH
	PHP		;Save carry through dot computation
	LDA HMASK
	ASL A
	STA HMASK2
	LSR A
	STA HMASK1
	JSR FIGDOT	;hack up a correctly-colored/placed dot-byte
	STA (HBASLN),Y	;put it where it shows
	PLP		;Restore carry for branch
	INC YSAV1	;incr. dot counter
	BNE HLIN4	;continue if not done
	INC COUNTH	;really really done?
	BNE HLIN4	;Nope.
	RTS		;Yup, exit.
HLIN4:	LDA QDRNT	;(sign of QDRNT says whether to move right or left)
	BCS MOVEX	;If carry set from "MOVEX2" computation, move horiz.
	JSR UPDWN	;else move vertically
	CLC
	LDA EL		;Update epsilon
	ADC DXL
	STA EL
	LDA EH
	ADC DXH
	BVC HCOUNT	;(Always taken) Continue looping
.PAGE
;The high bit is set because the parity of the top bits (6,7)
;determine when the color mask should be shifted)
MSKTBL:	$81
	$82
	$84
	$88
	$90
	$A0
	$C0

EQ1C:	$1C

COS:	$FF
	$FE
	$FA
	$F4
	$EC
	$E1
	$D4
	$C5
	$B4
	$A1
	$8D
	$78
	$61
	$49
	$31
	$18
	$FF
.PAGE
XDRAW:	TAX		;Enter with ROT in A & X, shape addr. in SHAPE
	LSR A
	LSR A
	LSR A
	LSR A
	STA QDRNT
	TXA
	AND #$0F
	TAX
	LDY COS,X
	STY DXL		;Cosine in DX
	EOR #$0F
	TAX
	LDY COS+1,X
	INY
	STY DY		;Sine in DY
XDRAW2:	LDY HNDX
	LDX #$00
	LDA GETRM2	;Enable ghost-memory
	LDA (SHAPE,X)
	BNE XDRAW3
	LDA GETRM1
	LDA GETRM1	;Disable ghost-memory
	RTS
XDRAW3:	STA SHAPEX
	LDA GETRM1	;Disable ghost-memory
	LDA GETRM1
	LDX #$80
	STX EL
	STX EH
	LDX SSIZE	;Shape Size.
XDRAW4:	LDA EL
	SEC
	ADC DXL
	STA EL
	BCC XDRAW5
	JSR LRUDX1
	CLC
XDRAW5:	LDA EH
	ADC DY
	STA EH
	BCC XDRAW6
	JSR LRUDX2
XDRAW6:	DEX
	BNE XDRAW4
	LDA SHAPEX
	LSR A
	LSR A
	LSR A
	BNE XDRAW3
	INC1 SHAPE
	LDA GETRM2	;Enable ghost-memory
	LDA (SHAPE,X)
	BNE XDRAW3
	LDA GETRM1	;Disable ghost-memory
	LDA GETRM1
	RTS
.PAGE
	;Local variable block:
LBYTE	=ANSN3	;Left byte modify

FIGDOT:	LDA COLNUM
	CMP #$06	;PC 6 is XOR mode
	BNE FIGDT1
	LDA HMASK1	;XOR: dot
	EOR (HBASLN),Y
	RTS
FIGDT1:	LDA #$00
	STA LBYTE
	LDA PALETN
	BEQ C3TO5	;Black background (double width)
	CMP #$06
	BEQ C1TO2	;Black background (single width)
	CMP #$01
	BEQ C6TO8	;White background
	LDA HCOLR1	;Colored background here
	AND #$7F
	BEQ CASE5	;Black line, off: dot,dot+1
	CMP #$7F
	BEQ CASE3	;White line, on: dot,dot+1
	LDA PNCOLR	;Colored line here
	CMP BKGND
	BNE CAS10	;Other color line, on: dot; off: dot-1,dot+1 (or shift+1)
	JMP CAS12	;Same color line, on: dot-1,dot+1; off: dot (or shift+1)
C3TO5:	LDA HCOLR1	;Black background (double width)
	AND #$7F
	BEQ CASE5	;Black color, off: dot,dot+1
	CMP #$7F
	BNE CAS10F	;Colored line
CASE3:	LDA HMASK1	;On: dot,dot+1
	LSR A
	ROR LBYTE	;Dot+1
	ORA HMASK1	;Dot
	JMP FXCON
CASE5:	LDA HMASK1	;Off: dot,dot+1
	LSR A
	ROR LBYTE	;Dot+1
	ORA HMASK1	;Dot
	JMP FXCOFF
C1TO2:	LDA HCOLR1	;Black background (single width)
	AND #$7F
	BEQ FXCIOF	;Black line, off: dot
	LDA (HBASLN),Y
	EOR PNCOLR	;Match high bit
	BPL FXCION
	EOR PNCOLR
	EOR #$80
	STA (HBASLN),Y
FXCION:	LDA HMASK1	;On: dot
	ORA (HBASLN),Y
	RTS
FXCIOF:	LDA HMASK1	;Off: dot
	EOR #$FF
	AND (HBASLN),Y
	RTS
C6TO8:	LDA HCOLR1	;White background
	AND #$7F
	BEQ CASE5	;Black line, off: dot,dot+1
	CMP #$7F
	BNE CAS10F
	JMP CASE8	;White line, on: dot-1,dot,dot+1,dot+2
CAS10F:	LDA (HBASLN),Y	;Colored line, on: dot; off: dot-1, dot+1 (or shift+1)
	EOR PNCOLR	;Match high bit
	BPL C6TO8A
	EOR PNCOLR
	EOR #$80
	STA (HBASLN),Y
C6TO8A:	LDA HCOLR1
	AND HMASK1
	BNE CAS10A	;Match
	LDA HMASK1
	LSR A
	BCC CAS10B	;OK if not bit 0
	TYA		;Else match high bit of leftmost byte
	BEQ CAS10B	;Ignore if at left edge
	DEY
	LDA (HBASLN),Y
	EOR PNCOLR
	BPL C6TO8B
	EOR PNCOLR
	EOR #$80
	STA (HBASLN),Y
	JMP C6TO8B
CAS10:	LDA HCOLR1
	AND HMASK1
	BEQ CAS10B	;No match
CAS10A:	LDA HMASK1	;On: dot; off: dot-1,dot+1
	ORA (HBASLN),Y	;Dot
	STA (HBASLN),Y
	LDA HMASK1
	LSR A
	ROR LBYTE	;Dot+1
	ORA HMASK2	;Dot-1
	JMP FXCOFF
C6TO8B:	INY
CAS10B:	LDA HMASK1	;On: dot+1; off: dot,dot+2
	LSR A
	ROR LBYTE
	LSR A
	ROR LBYTE	;Dot+2
	ORA HMASK1	;Dot
	JSR FXCOFF
	STA (HBASLN),Y
	LDA #$00
	STA LBYTE
	LDA HMASK1
	LSR A
	ROR LBYTE	;Dot+1
	TAX		;(FXCON wants status of A)
	JMP FXCON
CAS12:	LDA HCOLR1
	AND HMASK1
	BNE CAS12A	;Match
CAS12B:	LDA HMASK1	;On: dot-1,dot+1; Off:dot
	EOR #$FF
	AND (HBASLN),Y	;Dot
	STA (HBASLN),Y
	LDA HMASK1
	LSR A
	ROR LBYTE	;Dot+1
	ORA HMASK2	;Dot-1
	BNE FXCON	;(Always)
CAS12A:	LDA HMASK1	;On: dot,dot+2; Off:dot+1
	LSR A
	ROR LBYTE
	LSR A
	ROR LBYTE	;Dot+2
	ORA HMASK1	;Dot
	JSR FXCON
	STA (HBASLN),Y
	LDA #$00
	STA LBYTE
	LDA HMASK1
	LSR A
	ROR LBYTE	;Dot+1
	TAX		;(FXCOFF wants status of A)
	JMP FXCOFF
CASE8:	LDA HMASK1	;On: dot-1,dot,dot+1,dot+2
	LSR A
	ROR LBYTE
	ORA HMASK1	;Dot+1
	LSR A
	ROR LBYTE	;Dot+2
	ORA HMASK1	;Dot
	ORA HMASK2	;Dot-1
FXCON:	PHA		;Save middle mask
	BPL FXCN1	;Right ok
	CPY #$27	;At right edge?
	BEQ FXCN1	;Yes, ignore
	INY		;Next byte
	LDA #$01	;Leftmost bit on
	ORA (HBASLN),Y
	STA (HBASLN),Y
	DEY		;Middle byte
FXCN1:	LDA LBYTE
	BEQ FXCN2	;Left ok
	CPY #$00	;At left edge?
	BEQ FXCN2	;Yes, ignore
	DEY		;Previous byte
	LSR A		;Position the mask
	ORA (HBASLN),Y	;Bits on
	STA (HBASLN),Y
	INY		;Back to middle
FXCN2:	PLA		;Retrieve middle mask
	AND #$7F	;Zap top bit
	ORA (HBASLN),Y	;Bits on
	RTS
FXCOFF:	PHA
	BPL FXCF1
	CPY #$27
	BEQ FXCF1
	INY
	LDA #$FE
	AND (HBASLN),Y
	STA (HBASLN),Y
	DEY
FXCF1:	LDA LBYTE
	BEQ FXCF2
	CPY #$00
	BEQ FXCF2
	DEY
	LSR A
	EOR #$FF
	AND (HBASLN),Y
	STA (HBASLN),Y
	INY
FXCF2:	PLA
	AND #$7F
	EOR #$FF
	AND (HBASLN),Y
	RTS
.PAGE
;	Constants:
FROTK1:	$81	;Floating-point constant, 2.5
	$50
	$00
	$00

GRPHK1:	$7F	;Floating-point constant, 0.8 (scrunch factor)
	$66
	$66
	$66

.ENDC		;End of conditional graphics inclusion
.IFEQ GRPINC
;		Dummy graphics routines
GRINIT:	RTS
.ENDC
;	Local variable block:
LOWENT	=TEMPN5		;Low table entry (shared: SSIN,MULCOS,SFDX)
HIENT	=TEMPN3		;High table entry (shared: SCOS,MULCOS,SFDX)

MULCOS:	CLC		;Indexes 90-ANGLE-1 entry and following entry
	LDA #$5A
	SBC NARG1
MULSIN:	CLC
	ADC #$01	;Increment index (see below)
	ASL A		;Multiply by 2 for offset
	PHA		;Save index
	TAX
	LDA GETRM2	;Enable ghost-memory
	LDA SINTB1,X	;Get the table's entry
	STA NARG1	;(Indexed from 1 before zero value, with
	LDA SINTB1+1,X	;an index incremented by 2, so that the
	STA NARG1+1	;value before zero gets indexed properly)
	LDA SINTB2,X
	STA NARG1+2
	LDA SINTB2+1,X
	STA NARG1+3
	LDY #LOWENT
	JSR XN1TOY	;Save table value
	PLA		;Retrieve index
	TAX
	LDA SINTB1+2,X	;Get the next entry for interpolating
	STA NARG2
	LDA SINTB1+3,X
	STA NARG2+1
	LDA SINTB2+2,X
	STA NARG2+2
	LDA SINTB2+3,X
	STA NARG2+3
	LDA GETRM1	;Disable ghost-memory
	LDA GETRM1
	LDY #HIENT
	JSR XN2TOY	;Save table value
	JMP FSUBX	;Get difference of entries in NARG1
.PAGE
.SBTTL	File System

;DOS error routine vectors here
DERROR:	TXA		;Error code is in X from DOS
	PHA		;Save DOS error code on stack
	LDA GETRM1	;Re-enable high RAM
	LDA GETRM1
	JSR DOSOFF
	PLA		;Get DOS error code from stack
	AND #$0F	;Only bottom four bits matter
	TAX
	LDA DSRTBL,X	;Get error code
	JMP ERROR

;reset i/o and empty character buffer.
DOSOFF:	JSR RSTIO	;detaches DOS
	LDA #$0D
	STA LINARY
	RTS

;DOS Error number table
DSRTBL:	.BYTE XIOR	;0
	.BYTE XIOR	;1
	.BYTE XRNG	;2
	.BYTE XRNG	;3
	.BYTE XWTP	;4
	.BYTE XIOR	;5
	.BYTE XFNF	;6
	.BYTE XIOR	;7
	.BYTE XIOR	;8
	.BYTE XDKF	;9
	.BYTE XLKF	;A
	.BYTE XSYN	;B
	.BYTE XIOR	;C
	.BYTE XIOR	;D
	.BYTE XIOR	;E
	.BYTE XIOR	;F

;set up magic things for DOS
;NOTE: DOS uses page 2 for its character buffer!
DOSSTP:	LDA #$40	;magic number for Applesoft
	STA DLNGFG	;store in DOS language flag
	LDA #$00
	STA DOSFL2	;store things not = to $FF
	STA DOSFL1	;or apple val for ], in these, respectively.
	LDA #$80	;this sets up error return from DOS.
	STA DOSERR
	SETV DSERET,DERROR
	SETV OTPDEV,APOUT	;store APOUT in OTPDEV so DOS prints properly
	LDA KILRAM	;Enable Monitor ROM in case DOS wants it
	JSR DOSEAT	;let DOS eat these
	LDA GETRM1	;Re-enable high RAM
	LDA GETRM1
RSTR:	RTS
.PAGE
;	Local variable block:
PNAME	=TEMPN5		;Atom pname ptr.
CHARS	=TEMPNH		;String characters


DTPATM:	LDX #ARG1		;type atom DOS-style.
	LDY #PNAME
	JSR GETPNM
DTPTMW:	LDA PNAME+1
	BEQ RSTR
	CARNXT CHARS,PNAME
	LDA CHARS
	BEQ RSTR
	ORA #$80
	JSR TPCHR
	LDA CHARS+1
	BEQ RSTR
	ORA #$80
	JSR TPCHR
	JMP DTPTMW

;	Local variable block:
LENGTH	=TEMPN		;File length (bytes)

DPRLEN:	SEC
	LDA ENDBUF
	SBC #EDBUF&$FF
	STA LENGTH
	LDA ENDBUF+1
	SBC #EDBUF^
	STA LENGTH+1
	JSR DPR2HX
	LDA LENGTH
DPR2HX:	PHA
 	LSR A
	LSR A
	LSR A
	LSR A
	JSR DPRHXZ
	PLA
DPRHEX:	AND #$0F
DPRHXZ:	ORA #$B0
	CMP #$BA
	BCC DPRH1
	ADC #$06
DPRH1:	JMP TPCHR
.PAGE
SREAD:	LDA INPFLG
	BNE SAVSR1	;Can't do if in read-eval loop
	JSR ZAPBUF
	JSR SRDX1
	LDX #LOGOM&$FF
	LDY #LOGOM^
	JSR SRDX2
	CLC
	LDA FILLEN
	ADC #EDBUF&$FF
	STA ENDBUF	;recover buffer length from file length
	LDA FILLEN+1
	ADC #EDBUF^
	STA ENDBUF+1
	JSR PNTBEG	;point to beginning
	LDA SAVMOD	;Savemode. Normally 0, but if 1 don't eval, just read.
	BNE SRDPJ	;See SSAVE.
	INC INPFLG	;Indicate read-eval-loop
	VPUSH TOKPTR	;Save token pointer
	PUSHA SRDF3	;Push return address
	JMP EVLBUF

SRDF3:	VPOP TOKPTR	;Get token pointer back
SRDPJ:	JMP POPJ

SRDX1:	VPOP ARG1
	JSR GETTYP
	CMP #ATOM
	BEQ SRDX1A
	CMP #SATOM
	BEQ SRDX1A
	CMP #STRING
	BNE SAVSR3
SRDX1A:	JSR DOSSTP
	PRTSTR LOADM
	JMP DTPATM	;Type atom DOS-style

SRDX2:	JSR PRTSTR
	LDA #$8D
	JSR TPCHR
	JMP DOSOFF

SAVSR1:	JMP ERXETL	;can't hack files from editor
SAVSR3:	JMP ERXWT1

SSAVE:	LDA INPFLG
	BNE SAVSR1	;Error if editing with ALEC
	JSR ZAPBUF
	VPOP ARG1
	JSR GETTYP
	CMP #ATOM
	BEQ SAVST2
	CMP #SATOM
	BEQ SAVST2
	CMP #STRING
	BNE SAVSR3
SAVST2:	LDA ARG1
	PHA		;Save ARG1 for DOS-command string
	LDA ARG1+1
	PHA
	LDA SAVMOD	;Savemode. 0 normally, but when 1, saves buffer as is.
	BNE SAVBUF	;See SREAD.
;Nothing before here should change the buffer contents.	
	JSR EDTIN1	;output to buffer
	JSR POFUNS	;get functions into buffer
	INC OTPFLG	;Indicate print-to-buffer
	JSR PONAMS	;get variables into buffer
	DEC OTPFLG	;End print-to-buffer mode
;Come here just to save the buffer.
	MOV ENDBUF,EPOINT
SAVBUF:	JSR DOSSTP	;Wake up DOS
	PRTSTR SAVEM
	PLA		;Retrieve ARG1 (file name)
	STA ARG1+1
	PLA
	STA ARG1
	JSR DTPATM	;Type atom DOS-style
	PRTSTR LOGOM
	PRTSTR SAVEM2	;write file
	JSR DPRLEN	;Give it file's length
	LDA KILRAM	;Enable ROM for DOS
	LDA #$8D
	JSR TPCHR	;let it go
	JSR DOSOFF
	JSR PNTBEG
	JMP POPJ

SDELET:	JSR SDELTX
	LDX #LOGOM&$FF
	LDY #LOGOM^
	JSR SRDX2
	JMP POPJ

SCATLG:	JSR DOSSTP
	LDX #CATLGM&$FF
	LDY #CATLGM^
	JSR SRDX2
	JMP POPJ

SERPCT:	JSR SDELTX
	LDX #SCRNM&$FF
	LDY #SCRNM^
	JSR SRDX2
	JMP POPJ


.IFNE MUSINC
.PAGE
SERMUS:	JSR SDELTX
	LDX #MUSM&$FF
	LDY #MUSM^
	JSR SRDX2
	JMP POPJ

SSVMUS:	JSR MUSICP
	VPOP ARG1
	JSR GETTYP
	CMP #ATOM
	BEQ SSVSM2
	CMP #SATOM
	BEQ SSVSM2
	CMP #STRING
	BNE SSVSM3
SSVSM2:	LDA NPARTS
	STA DSKB1	;DOS will save this.
	JSR DOSSTP	;Wake up DOS
	PRTSTR SAVEM
	JSR DTPATM	;Type atom DOS-style
	PRTSTR MUSM
	PRTSTR SAVEM2
	PRTSTR SAVEM4	;write file
	LDA #$8D
	JSR TPCHR	;let it go
	JSR DOSOFF
IGNPRM:	JMP POPJ
SSVSM3:	JMP ERXWT1

SRDMUS:	LDA INPFLG
	BNE IGNPRM
	LDA GRPHCS
	BPL SRDMS1
	JSR RESETT
SRDMS1:	JSR SRDX1
	LDX #MUSM&$FF
	LDY #MUSM^
	JSR SRDX2
	LDA DSKB1
	STA NPARTS
	JMP POPJ
.ENDC ;musinc

SDELTX:	VPOP ARG1
	JSR GETTYP
	CMP #SATOM
	BEQ SDELT1
	CMP #ATOM
	BEQ SDELT1
	CMP #STRING
	BNE SDELR3
SDELT1:	JSR DOSSTP
	PRTSTR DELETM
	JMP DTPATM	;Type atom DOS-style
SDELR3:	JMP ERXWT1
.PAGE
.SBTTL	Garbage Collector

;	Local variable block:
INDEX	=TEMPN3		;Indexes oblist and soblist
NODE	=TEMPN		;Node to mark (shared: GARCOL,MARK)
TYPPTR	=TEMPNH		;TYPACS shares
NARGS1	=ANSN1		;No. of ufun bindings
GCPROT	=ANSN1		;G.C-protected variable pointer
FRMPTR	=TEMPN3		;Frame pointer
BINDNG	=TEMPN4		;Binding ptr.
FBDPTR	=TEMPNH		;FBODY ptr. from pre-stack-frame info.

;If GARCOL routine error exits, it should clear the mark bits
;and clear the random gc-protected variables.
;If there are any error exits in the sweep routine, then there
;should be a sweep routine unwind protect which zeros the freelist.

GCUNW:	LDA GCFLG
	BEQ GCUNWX
	LDA #$00
	STA GCFLG	;gc no longer in progress.
	JSR CLMK4	;clear MARKN vars.
	JSR CLRMRK	;clear mark bits in typearray.
GCUNWX:	RTS

GARCOL:	LDA #$01
	STA GCFLG	;doing a garbage collect -- set up for GCUNW on error.
	JSR SWAPT1
	MOV INDEX,SOBLST
GCLP2:	LDX #INDEX
	JSR MARK
	INC4 INDEX
	LDA INDEX
	CMP SOBTOP
	BNE GCLP2
	LDA INDEX+1
	CMP SOBTOP+1
	BNE GCLP2
	SETV INDEX,VPDLBA
GCLP3:	LDA INDEX
	CMP VSP
	BNE GCLP3X
	LDA INDEX+1
	CMP VSP+1
	BEQ GCLP3A
GCLP3X:	CAR NODE,INDEX
	JSR MARKX
	DEC2 INDEX
	JMP GCLP3
GCLP3A:	LDA FRAME+1
	BEQ GCOL1
	STA FRMPTR+1
	LDA FRAME
	STA FRMPTR
GCLP4:	SEC
	LDA FRMPTR
	SBC #SFFBDY	;Indexes the Fbody of the previous frame (Subtraction)
	STA FBDPTR
	LDA FRMPTR+1
	SBC #$00
	STA FBDPTR+1
	CAR NODE,FBDPTR	;Indexes the pre-stack-frame FBODY pointer
	JSR MARKX	;Mark the Fbody
	LDY #SFNRGS	;Frame NUMBER-BINDINGS index
	LDA (FRMPTR),Y
	BEQ GCLP5E
	STA NARGS1
	CLC
	LDA FRMPTR
	ADC #SFBNDS	;Binding pairs frame index
	STA BINDNG	;BINDNG points to a binding pair
	LDA FRMPTR+1
	ADC #$00
	STA BINDNG+1
GCLP5:	LDY #$02
	LDA (BINDNG),Y	;See if it's a fun/frame pair
	ROR A
	BCS GCLP5A
	CAR NODE,BINDNG	;Nope, get value and mark
	JSR MARKX
GCLP5A:	INC4 BINDNG
	DEC NARGS1
	BNE GCLP5
GCLP5E:	LDY #SFFRAM	;Previous-frame index
	LDA (FRMPTR),Y
	TAX
	INY
	LDA (FRMPTR),Y
	STA FRMPTR+1
	STX FRMPTR
	BNE GCLP4
GCOL1:	LDA #GCVST	;Mark all G.C.-protected variables
	STA GCPROT
GCOL1L:	LDX GCPROT
	JSR MARK
	INC GCPROT
	INC GCPROT
	LDA GCPROT
	CMP #GCVND
	BNE GCOL1L
	LDX #SIZE1
	LDY #AREA1
	JSR MARKA
	LDX #SIZE2
	LDY #AREA2
	JSR MARKA
	LDA #$00
	STA FRLIST+1
	STA NNODES
	STA NNODES+1
	SETV NODE,NODBEG
	SETV TYPPTR,NODEND
GCLP6:	LDY #$00
	LDA (TYPPTR),Y
	ROL A		;Get mark bit
	BCS GCLP6C
	RPLACD NODE,FRLIST
	MOV FRLIST,NODE
	BCC GCLP6F	;(Always)
GCLP6C:	INC1 NNODES
GCLP6F:	INC4 NODE
	INC1 TYPPTR
	LDA TYPPTR
	CMP #TYPEND&$FF
	BNE GCLP6
	LDA TYPPTR+1
	CMP #TYPEND^
	BNE GCLP6
	LDA #$00
	STA GCFLG	;no longer gc'ing.
	JSR CLRMRK
	JMP SWAPT2
.PAGE
CLRMRK:	SETV TYPPTR,NODEND
	LDY #$00
GCLP1:	LDA (TYPPTR),Y
	AND #$7F	;Set Mark bit to 0 (reap)
	STA (TYPPTR),Y
	INC1 TYPPTR
	LDA TYPPTR
	CMP #TYPEND&$FF
	BNE GCLP1
	LDA TYPPTR+1
	CMP #TYPEND^
	BNE GCLP1
MRKRTS:	RTS

;	Local variable block:
SIZE	=TEMPN		;Size of contiguous area (in nodes)

MARKA:	GETX SIZE
	GETY TYPPTR
	JSR TYPACS	;Returns with Y=$00.
MRKAW:	LDA SIZE+1
	BNE MRKAW1
	LDA SIZE
	BEQ MRKRTS
MRKAW1:	LDA (TYPPTR),Y
	ORA #$80	;Mark the node
	STA (TYPPTR),Y
	INC1 TYPPTR
	DEC2 SIZE
	JMP MRKAW
.PAGE
;	Local variable block:
NODE	=TEMPN		;Node to mark (shared: GARCOL,MARK)
LINE	=TEMPN1		;Line ptr. for fpacked ufuns
LINEND	=TEMPN2		;Line-end ptr. for fpacked ufuns

MARK:	GETX NODE
MARKX:	LDX #$FF
	LDY #$FF
	JSR PUSH
MRKW:	LDA #$FF
	CMP NODE
	BNE MRKW1
	CMP NODE+1
	BEQ MRKRTS
MRKW1:	LDA NODE+1
	CMP #$02
	BCC MRKW3	;Don't mark if nil or novalue
	STA TYPPTR+1
	LDA NODE
	STA TYPPTR
	JSR TYPACS
	ASL A
	BCC MRKW2
MRKW3:	POP NODE
	JMP MRKW
MRKW2:	PHA
	JSR TSTSTK
	PLA
	SEC
	ROR A
	STA (TYPPTR),Y
	AND #$7F
	TYPDSP GCLTAB

SYSBG7:	LDA #$07
	JMP SYSBUG
MRKCT:	LDA NODE
	AND #$FE	;This string might be a funny-pname
	STA NODE
MRKCF:	LDY #$02
MRKCN:	LDA (NODE),Y
	TAX
	INY
	LDA (NODE),Y
	BEQ MRKW3
	TAY
MRKCF1:	JSR PUSH
	JMP MRKW3
MRKCS:	LDY #$00
	BEQ MRKCN	;(Always)
MRKCL:	LDA NODE
	AND #$FC
	STA NODE
	LDY #$00
	LDA (NODE),Y
	TAX
	INY
	LDA (NODE),Y
	BEQ MRKCF
	TAY
MRKCL1:	JSR PUSH
	JMP MRKCF
MRKCU:	CLC
	LDA NODE
	ADC #$04
	STA TYPPTR
	LDA NODE+1
	ADC #$00
	STA TYPPTR+1
	JSR TYPACS
	ORA #$80
	STA (TYPPTR),Y
	BNE MRKCF	;(Always)

MRKCP:	CAR LINE,NODE		;LINE is line pointer
MRKCP1:	CDR LINEND,NODE		;LINEND is next-line pointer or 0
	CLC
	LDA NODE
	ADC #$02
	STA TYPPTR
	LDA NODE+1
	ADC #$00
	STA TYPPTR+1
	JSR TYPACS
	ORA #$80
	STA (TYPPTR),Y
	LDA LINEND+1
	BNE MRKPX
	JMP MRKW3
MRKPX:	LDA LINE
	CMP LINEND
	BNE MRKPX1
	LDA LINE+1
	CMP LINEND+1
	BNE MRKPX1
MRKPXE:	INC2 NODE
	JMP MRKCP1
MRKPX1:	MOV TYPPTR,LINE
	JSR TYPACS
	ORA #$80
	STA (TYPPTR),Y
	LDA (LINE),Y
	TAX
	INY
	LDA (LINE),Y
	TAY
	JSR PUSH
	JSR TSTSTK
	INC2 LINE
	JMP MRKPX

;Garbage collector type dispatches
GCLTAB:	.ADDR MRKCL	;List
	.ADDR MRKCL	;Atom
	.ADDR MRKCT	;String
	.ADDR MRKW3	;Fix
	.ADDR MRKW3	;Flo
	.ADDR SYSBG7	;Sfun
	.ADDR MRKCU	;Ufun
	.ADDR MRKCS	;Satom
	.ADDR MRKCP	;Fpack
	.ADDR MRKCL	;Qatom
	.ADDR MRKCL	;Datom
	.ADDR MRKCL	;Latom
.PAGE
CLMK4:	STA MARK4+1
CLMK3:	STA MARK3+1
CLMK2:	STA MARK2+1
	STA MARK1+1
	RTS

SWAPT1:	LDY #TMPNUM-1
	LDX #TMPSTT
SWPLP1:	LDA $00,X
	STA TMPTAB,Y
	INX
	DEY
	BPL SWPLP1
	RTS

SWAPT2:	LDY #TMPNUM-1
	LDX #TMPSTT
SWPLP2:	LDA TMPTAB,Y
	STA $00,X
	INX
	DEY
	BPL SWPLP2
	RTS
.PAGE
.IFNE 0
NXTNOD	=TEMPN3		;Oblist index
LSTNOD	=TEMPN4		;Other Oblist index

;PUT TRUE AND FALSE WITH THE GARBAGE-COLLECT-PROTECTED POINTERS AND
;REMOVE "OBLIST" FROM THEM.
;	...
	MOV NXTNOD,OBLIST
GCOB1:	LDA NXTNOD+1
	BEQ GCOBD
	CARNXT LSTNOD,NXTNOD	;Mark the value, ufun, and pname of each node
	CARNXT NODE,LSTNOD	;Value
	JSR MARKX
	CAR NODE,LSTNOD		;Ufun
	JSR MARKX
	CDR NODE,LSTNOD		;Pname
	JSR MARKX
	JMP GCOB1
GCOBD:	MOV NXTNOD,OBLIST
GCOBD1:	JSR CKOBEL		;First find a marked or nonempty oblist element (and mark it)
	BCS GCOBF		;Returns carry set if object marked or nonempty
	CDRME NXTNOD		;Not this one, try next
	BNE GCOBD1		;(Always - There's always something there (TRUE,FALSE))
COBF:	LDA NXTNOD
	STA OBLIST
	STA LSTNOD
	LDA NXTNOD+1
	STA OBLIST+1
	STA LSTNOD+1
COBF1:	CDR NXTNOD,LSTNOD	;Try a new node
COBF2:	LDA NXTNOD+1
	BEQ GCOBE		;End of Oblist, done
	JSR CKOBEL
	BCC GCOBN
	MOV LSTNOD,NXTNOD	;This one's okay, so advance pointers
	JMP COBF1
GCOBN:	CDRME NXTNOD		;Not okay, advance to next node
	RPLACD LSTNOD,NXTNOD	;And re-link around the bad node
	JMP COBF2
GCOBE:	...

	;Local variable block:
FUN	=TEMPN1
VALUE	=TEMPN1

CKOBEL:	CAR NODE,NXTNOD
	MOV TYPPTR,NODE
	JSR TYPACS		;See if the node is marked
	ASL A
	BCS CKOBOK		;Yes
	LDX #NODE
	LDA #FUN
	JSR GETFUN
	CMP #$01
	BNE CKOBKM		;Has a ufun, it's ok, mark it
	LDY #NODE
	LDX #VALUE
	JSR GETVAL
	CMP #$01
	BNE CKOBKM		;Has a value, mark it
	CLC			;No value, waste the sucker
	RTS
CKOBKM:	MOV TYPPTR,NODE		;Mark the node itself
	JSR TYPACS
	ORA #$80
	STA (TYPPTR),Y
CKOBOK:	MOV TYPPTR,NXTNOD	;Always mark the oblist pointer
	JSR TYPACS
	ORA #$80
	STA (TYPPTR),Y
	SEC
	RTS
.ENDC
;
.PAGE
.SBTTL	Argument Passing Routines

;Gets a numerical argument. Returns with carry set if flonum.
GT1NUM:	VPOP NARG1
GT1NMX:	JSR GTNUM1	;Alt. entry
	BCC GTERR1
	CMP #FLO	;(Sets carry if Flonum)
GTFRTS:	RTS

GT1FLT:	VPOP NARG1
GT1FLX:	JSR GTNUM1
	BCC GTERR1
	CMP #FLO
	BEQ GTFRTS
	JMP FLOTN1

;	Local variable block:
TYPE1	=ANSN3		;Type of first arg
ARGSAV	=TEMPX2		;Temp. storage for arg2 (shared: GT2NUM,GT2FIX,GTNUM2)

;Gets two numerical arguments. Coerces one to Real if not same type.
;Returns with carry set if Flonum results.
GT2NUM:	VPOP ARGSAV
	VPOP ARG1
	JSR GETNUM	;GETNUM returns carry clear if argument non-numerical
	BCC GTERR1
	STA TYPE1	;Save first type
	JSR GTNUM2	;Special GETNUM for NARG2
	BCC GTERR2
	CMP TYPE1
	BNE GT2NM1
	CMP #FLO	;(Sets carry if Flonum)
	RTS
GT2NM1:	CMP #FIX	;Assume ARG1 is the integer
	BNE GT2NM2
	JSR FLOTN2	;Nope, it was NARG2, convert to flt. pt.
	SEC
	RTS
GT2NM2:	JSR FLOTN1	;Convert NARG1 to floating pt.
	SEC
	RTS

;	Local variable block:
VSPPTR	=TEMPNH		;Ptr. to arg on VSP

;ERROR wants a pointer to the erroneous argument, not the
;number itself, so we get it from the Vpdl position it was in
;(GTERR1 is for values just Vpopped)
GTERR1:	CAR ARG1,VSP
	JMP ERXWT1

GTERR2:	SEC		;(GTERR2 is for values which were the second
	LDA VSP		;Vpopped)
	SBC #$02
	STA VSPPTR
	LDA VSP+1
	SBC #$00
	STA VSPPTR+1
	CAR ARG1,VSPPTR
	JMP ERXWT1

;Gets a numerical argument, changes to integer if Real.
GT1FIX:	VPOP ARG1
GT1FX1:	JSR GETNUM
	BCC GTERR1
	CMP #FIX
	BEQ GTFXRT
	JMP RNDN1

;	Local variable block:
ARGSAV	=TEMPX2		;Temp. storage for arg2 (shared: GT2NUM,GT2FIX,GTNUM2)

;Gets two numerical arguments, changes either or both to integer if Real.
GT2FIX:	VPOP ARGSAV
	VPOP ARG1
	JSR GETNUM
	BCC GTERR1
	CMP #FIX
	BEQ GT2FX1
	JSR RNDN1
GT2FX1:	JSR GTNUM2	;Special GETNUM for NARG2
	BCC GTERR2
	CMP #FIX
	BEQ GTFXRT
	JMP RNDN2

;Carry clear if 16 bit integer, set otherwise.
;Checks thing at X.
CHKINT:	LDA $02,X
	BNE CHKIN2
	LDA $03,X
	BNE CHKNNT
CHKIOK:	CLC
GTFXRT:	RTS
CHKIN2:	CMP #$FF
	BNE CHKNNT
	CMP $03,X
	BEQ CHKIOK
CHKNNT:	SEC
	RTS

;Carry clear if positive 16 bit integer, set otherwise.
;Check Positive Integer. Checks thing at X.
CHKPIN:	JSR CHKINT
	BCS GTFXRT
	TAX
	BMI CHKNNT
	CLC
	RTS

;Carry clear if positive 8 bit integer, set otherwise.
;Check Byte Number. Checks thing at X.
CHKPBN:	JSR CHKINT
	BCS GTFXRT
	TAY
	BMI CHKNNT
	LDA $01,X
	BNE CHKNNT
	CLC
	RTS

;Gets a positive one byte fixnum, entered with maximum value allowed in A.
;Checks thing at X.  Returns with carry clear of ok.
SMLFX1:	LDX #NARG1
SMALFX:	PHA		;Save the limit
	JSR CHKPBN
	PLA
	BCS SMLFXN
	CMP $00,X
	BCC SMLFXY
	CLC
	RTS
SMLFXY:	SEC
SMLFXN:	RTS

;	Local variable block:
NUMSAV	=A3L		;Temp. storage for arg1
ARGSAV	=TEMPX2		;Temp. storage for arg2 (shared: GT2NUM,GT2FIX,GTNUM2)

;GTNUM2 saves NARG1 before calling GETNUM with NARG2, then restores NARG1.
GTNUM2:	MOV NARG2,ARGSAV
GTNM2X:	LDY #NUMSAV	;Entry point for EQ - the pointer is in NARG2, not ARGSAV.
	JSR XN1TOY	;Save NARG1
	LDX #NARG2
	JSR GETNUM
	PHP		;Save carry
	PHA		;Save type
	LDY #NUMSAV
	JSR XYTON1	;Restore NARG1
	PLA		;Get type back
	PLP		;Get carry back
	RTS

;	Local variable block:
ARG	=ANSN1		;Address of ptr. to argument
ARGPTR	=TEMPNH		;Ptr. to argument

;Gets a numerical argument if possible. Returns with carry clear if successful.
;Returns with type of argument (Fix/Flo) in A.
;(Note: ATMTNM destroys previous values of NARG1 and NARG2. Call with NARG1 first,
; then save it, then call with NARG2, then restore NARG1.)

GTNUM1:	LDX #NARG1
GETNUM:	STX ARG		;Address of argument
	JSR GETTYP
	LDX ARG
	CMP #ATOM
	BEQ ATMTNX
	CMP #STRING
	BEQ ATMTNX
	CMP #FIX
	BEQ LODNUM
	CMP #FLO
	BEQ LODNUM
GTNMNO:	CLC		;Carry clear means argument not OK
	RTS

;Entry point for EQ - already know it's a number.
LODNUM:	PHA		;Save type
	GETX ARGPTR
	LDY #$03
GTNML:	LDA (ARGPTR),Y
	STA $03,X
	DEX
	DEY
	BPL GTNML
	PLA		;Retrieve type
	SEC		;Carry set means argument OK
	RTS
.PAGE
;	Local variable block:
ARG	=ANSN1		;Address of ptr. to argument
PNAME	=TEMPN4		;Pname of atom
CHARS	=TEMPN7		;String characters
SIGN	=ANSN2		;Sign of number

;Convert an atom to a Fixnum or Flonum if possible. Sets the carry
;if successful. Returns type of number (Fix/Flo) in A.
;(Note: Destroys previous values of NARG1 and NARG2.)

ATMTNM:	STX ARG		;Points to argument
ATMTNX:	LDY #PNAME	;(Entry point for GETNUM)
	JSR GETPNM
	LDA PNAME+1
	BEQ GTNMNO
	JSR CNUML0	;Initialize number to 0
	LDY #$01
	LDA (PNAME),Y
	STA CHARS+1
	DEY
	STY SIGN
	LDA (PNAME),Y
	STA CHARS	;(CAR) a pair of digits to CHARS
	CMP #'-
	BNE ATMT3
	INC SIGN
	BNE ATMT4A	;(Always)
ATMT3:	JSR GOBDIG
ATMT4:	LDX PNAME+1
	BEQ ATMT4E
ATMT4A:	CDRME PNAME	;next two characters
	LDA CHARS+1
	BEQ ATMT4
	JSR GOBDIG
	LDX PNAME+1
	BEQ ATMT4E
	LDY #$01
	LDA (PNAME),Y
	STA CHARS+1
	DEY
	LDA (PNAME),Y	;(CAR) next two characters
	JSR GOBDIG
	JMP ATMT4
ATMT4E:	JSR CNUML2
	BCC NOTNM2
	PHA		;Save type
	LDX SIGN
	BEQ ATMT5
	LDX #NARG1
	CMP #FIX	;(Type of number is in A)
	BNE ATMT41
	JSR COMPL
	JMP ATMT5
ATMT41:	JSR FCOMPL
ATMT5:	LDY ARG		;Argument pointer
	LDX #$FC
ATMT5L:	LDA NARG1+4,X	;NARG1 is NUMBER
	STA $00,Y
	INY
	INX
	BMI ATMT5L
	PLA		;Retrieve type
	SEC		;Carry set means argument is a number
	RTS

GOBDIG:	JSR CNUML1
	BCS GBDGR
NOTNM1:	PLA		;Return back past ATMTNM
	PLA
NOTNM2:	CLC		;Carry clear means argument non-numeric
GBDGR:	RTS
.PAGE
;	Local variable block:
ARG	=ANSN1		;Address of ptr. to argument
NEWATM	=TEMPX1		;Interned atom ptr.

GTBOOL:	STX ARG
	JSR GETTYP
	LDX ARG
	CMP #STRING
	BNE GTBOL1
	LDY #NEWATM
	JSR INTERN	;Intern it if it's a String, in case it's a boolean word
	LDX #NEWATM
GTBOL1:	LDA $00,X
	LDY #$00	;Assume TRUE (zero)
	CMP LTRUE
	BNE GTBL1
	LDA $01,X
	CMP LTRUE+1
	BNE GTBL1
GTRTS:	RTS
GTBL1:	INY
	LDA $00,X
	CMP LFALSE
	BNE GTBL2
	LDA $01,X
	CMP LFALSE+1
	BEQ GTRTS
GTBL2:	JSR PTRXOK
	ERROR XNTF,CURTOK
.PAGE
;	Local variable block:
ARG	=ANSN1		;Address of ptr. to argument
PNAME	=ANSN2
ARGPTR	=TEMPNH		;Ptr. to argument

MAKPNM:	STY PNAME	;Note: X may equal Y at this point (ARG=PNAME)
	STX ARG
	JSR GETTYP
	LDX ARG
	LDY PNAME
	CMP #ATOM
	BEQ GETPNM
	CMP #SATOM
	BEQ GETPNM
	CMP #STRING
	BNE MKPF
	JMP GTPNS
MKPF:	PHA		;Save type
	GETX ARGPTR	;Assume it's a fixnum or flonum
	LDX #$03
	LDY #$00
MKP2L1:	LDA (ARGPTR),Y
	STA NARG1,Y
	INY
	DEX
	BPL MKP2L1
	PLA		;Retrieve type
	TAX
	LDA PNAME
	PHA		;Save pointer
	CPX #FIX
	BEQ MKPN2
	CPX #FLO
	BEQ MKPN3
	LDX ARG
ERXWTX:	JSR PTRXOK
ERXWTY:	ERROR XWTA,CURTOK
MKPN2:	JSR CVBFIX	;Get string on PDL
	JMP CNSPD1	;CONS string from PDL
MKPN3:	JSR CVFLO	;Get the string on PDL
	JMP CNSPD1
.PAGE
;	Local variable block:
PNAME	=TEMPN1+1	;Returned pname ptr.
ATOMM	=TEMPN1		;Address of atom ptr.
ATMPTR	=TEMPNH		;Atom ptr.
INDEX	=TEMPN		;Prim-array index
OFFSET	=TEMPN1		;Prim-array index offest
TEMP	=TEMPN

GETPNM:	STY PNAME
	STX ATOMM
	LDA $00,X
	STA TEMP	;Save low byte w/extra bits
	AND #$FC
	STA $00,X
	JSR GETTYP
	LDX ATOMM
	CMP #STRING
	BNE GTPNM1
	LDY PNAME
GTPNS:	LDA $00,X
	STA $00,Y
	LDA $01,X
	STA $01,Y
	LDA TEMP	;Get low byte back (w/funny bits)
	AND #$01	;0 if reg. string, 1 if funny-pname
	RTS
GTPNM1:	LDY $00,X
	STY ATMPTR
	LDY $01,X
	STY ATMPTR+1
	CMP #SATOM
	BEQ GTPN2
	CDRME ATMPTR
	LDX PNAME
	DEY
	LDA (ATMPTR),Y
	PHA
	INY
	LDA (ATMPTR),Y
	STA $01,X
	PLA
	TAY	
	AND #$FC
	STA $00,X
	TYA
	AND #$03
	RTS
GTPN2:	CDR INDEX,ATMPTR
	LDA #PRMNAM
	STA OFFSET
	LDA #$00
	STA CCOUNT	;Character counter
GTPNW:	LDA GETRM2	;Enable ghost-memory
	LDY OFFSET
	LDA (INDEX),Y	;Pname index is 3 for Sfuns
	BEQ GTPNWE
	JSR PUSHB
	INC CCOUNT
	INC OFFSET
	BNE GTPNW	;(Always)
GTPNWE:	LDA GETRM1	;Disable ghost-memory
	LDA GETRM1
	LDA PNAME
	JMP CNSPDL	;Should return with $00 in A (No funny pname)
.PAGE
;	Local variable block:
CHARS	=TEMPN		;String characters

;CONS a string from the characters on the PDL, CCOUNT holds counter, ANS in vA.
;Should return with $00 in A for GETPNM.
CNSPDL:	PHA		;Save ANS ptr on stack
CNSPD1:	LDX #$00	;(JMP here if ANS already on stack)
	STX MARK1+1
	LDA CCOUNT
	ROR A
	BCC CSPD1
	INC CCOUNT
	LDA #$00
	BEQ CSPD2	;(Always) If odd, first char. seen will be a zero
CSPD1:	JSR POPB	;Pop two characters
CSPD2:	STA CHARS+1
	POPB CHARS
	CONS MARK1,CHARS,MARK1,STRING	;Cons a node
	DEC CCOUNT
	DEC CCOUNT
	BNE CSPD1	;Continue if not done
	PLA		;Retrieve pointer
	TAX
	PUTX MARK1
	LDA #$00
	STA MARK1+1
	RTS

;Converts a two-byte fixnum to  a string on the PDL
CVFIX:	GETX NARG1	;NARG1 is the number to type
	LDA #$00
	STA CCOUNT	;Character counter
CVFIXX:	STA NARG1+2	;(Alternate entry point)
	STA NARG1+3
	BEQ CVFX2	;(Always)

;	Local variable block:
DCOUNT	=ANSN		;Digit counter

;Get 4-byte fixnum in NARG1 to string on PDL
CVBFIX:	LDA #$00
	STA CCOUNT	;Character counter
	LDA NARG1+3
	BPL CVFX1
	LDX #NARG1
	JSR COMPL
	LDA #'-
	JSR PUSHB
	INC CCOUNT
CVFX1:	LDA #$00
CVFX2:	STA DCOUNT	;Digit counter
CVBNMR:	LDA #$0A
	JSR XDVDX	;Divide NARG1 by ten and get remainder
	CLC
	ADC #'0		;Make the digit Ascii
	PHA		;Push remainder digit
	INC DCOUNT	;Increment digit counter
	LDX #$03
CVBL1:	LDA NARG1,X
	BNE CVBNMR
	DEX
	BPL CVBL1
CVBNMF:	PLA		;Pop a digit
	JSR PUSHB	;Push it
	INC CCOUNT
	DEC DCOUNT
	BNE CVBNMF
	RTS
.PAGE
;	Local variable block:
ODE	=ANSN2		;Running decimal pt. shift counter
ECOUNT	=ANSN3		;No. of mantissa digits to print
DIGIT	=TEMPN1		;Newest digit

;Converts flonum NARG1 to characters on PDL
CVFLO:	LDA #$00
	STA CCOUNT	;Counts number of characters pushed
	STA ODE
	LDX #$03
TPFLL1:	LDA NARG1,X
	BNE TPFL1
	DEX
	BPL TPFLL1
	INC CCOUNT
	LDA #'0		;If NARG1 = 0, push "0." and return
	JSR PUSHB
	INC CCOUNT
	LDA #'.
	JMP PUSHB
TPFL1:	LDA NARG1+1
	BPL TPFL2
	JSR FCOMPL	;If NARG1 negative, invert and push "-"
	LDA #'-
	JSR PUSHB
	INC CCOUNT
TPFL2:	LDA NARG1	;Now get 1 <= NARG1 < 10
	BPL TPFLS1	;Exponent too small, so multiply number
	CMP #$84
	BCS TPFLG1	;Exponent greater than 3, so too big
	CMP #$83
	BNE GINTP1	;Ok if 0,1, or 2
	LDA NARG1+1	;Else if 3,
	CMP #$50	;Make sure X < 10 (01.01 0000 Bin)
	BCC GINTP1
TPFLG1:	JSR FDVD10	;So divide by 10
	INC ODE
	LDA NARG1
	CMP #$83
	BCC GINTP1
	BNE TPFLG1
	LDA NARG1+1
	CMP #$50
	BCS TPFLG1
	BCC GINTP1	;(Always)
TPFLS1:	JSR MULN10	;NARG1 too small, so multiply by 10
	DEC ODE
	LDA NARG1
	BPL TPFLS1
GINTP1:	SETNUM NARG2,FRNDUP	;Round up (add 0.000005)
	JSR FADD
	LDA NARG1
	CMP #$84
	BCS GNTPLG	;Exponent greater than 3, so too big
	CMP #$83
	BNE GINTP2	;Ok if 0,1, or 2
	LDA NARG1+1	;Else if 3,
	CMP #$50	;Make sure X < 10 (01.01 0000 Bin)
	BCC GINTP2
GNTPLG:	JSR FDVD10	;So divide by 10
	INC ODE
GINTP2:	JSR GETINT
	LDA ODE
	BPL TPFLG2
	CMP #$FF
	BCC TPFLF1	;NARG1 < 0.1, use floating pt. format (neg exp)
TPFLR:	STA ECOUNT	;Counter for Exp+1 iterations
	INC ECOUNT
	BEQ TPFLR1
TPFLL5:	JSR GTDECH
	DEC ECOUNT
	BNE TPFLL5
TPFLR1:	LDA #'.
	JSR PUSHB	;Push decimal pt.
	INC CCOUNT
	SEC
	LDA #$05
	SBC ODE
	STA ECOUNT	;Counter for 5-Exp iterations
	BEQ POPTZS
TPFLL6:	JSR GTDECH
	DEC ECOUNT
	BNE TPFLL6
POPTZS:	JSR POPB	;Pop all trailing zeroes
	DEC CCOUNT
	CMP #'0
	BEQ POPTZS
	INC CCOUNT
	JMP PUSHB	;Done
TPFLG2:	CMP #$06
	BCC TPFLR	;NARG1 < 1000000, use regular format
TPFLF1:	JSR GTDECH	;Floating pt. format, call Get-Decimal-Char for digit
	LDA #'.
	JSR PUSHB	;Push a "."
	INC CCOUNT
	LDA #$05	;Counter for five iterations
	STA ECOUNT
TPFLL3:	JSR GTDECH	;Get another decimal digit
	DEC ECOUNT
	BNE TPFLL3
	JSR POPTZS	;Pop all trailing zeros
	LDA ODE
	BPL TPFLEP
	EOR #$FF	;If Exp negative, invert
	STA ODE
	INC ODE		;(Complement and increment)
	LDA #'N		;and push "N"
	BNE TPFLEX	;(Always)
TPFLEP:	LDA #'E		;Exp positive, push "E"
TPFLEX:	JSR PUSHB
	INC CCOUNT
	LDA ODE
	STA NARG1
	LDA #$00
	STA NARG1+1
	JMP CVFIXX	;Routine converts (2-byte) ARG1 into string on PDL

FRNDUP:	$6E	;Floating-point constant, 0.000005
	$53
	$E2
	$D6
.PAGE
;Gets the most significant decimal digit of NARG1, then positions it for next one.
GTDECH:	CLC
	LDA DIGIT
	ADC #'0
	JSR PUSHB
	INC CCOUNT
	JSR ZNARG2	;clear out narg2.
	LDA DIGIT
	STA NARG2
	JSR FLOTN2
	JSR FSUB	;Subtract the last digit we got
	JSR MULN10	;Multiply by 10 to get next digit
GETINT:	LDA #$00	;Gets the integer part of NARG1
	STA DIGIT	;Init DIGIT to 0
	LDA NARG1+1	;MSB in A
	LDX NARG1	;Exp in X
	BEQ GTNTR	;Done if exp 0
GTNTL:	CPX #$80	;Loop done when $80
	BEQ GTNTLE
	ASL A		;Shift bit from MSB
	ROL DIGIT	;into DIGIT
	DEX		;Dec exp
	BNE GTNTL	;(Always) Continue for 0-3 bits
GTNTLE:	ASL A		;Then do two more bits
	ROL DIGIT
	ASL A
	ROL DIGIT
GTNTR:	RTS
.PAGE
;Execution diagram, flonum-to-string conversion:
;ODE := 0
;IF NUM < 1 THEN DO NUM := NUM * 10, ODE := ODE - 1, UNTIL NUM >= 1
;   ELSE IF NUM >= 10 THEN DO NUM := NUM / 10, ODE := ODE + 1, UNTIL NUM < 10
;NUM := NUM + ROUND
;IF NUM >= 10 THEN NUM := NUM / 10, ODE := ODE + 1
;INTP := INT(NUM)
;IF ODE > 6 OR ODE < -1 THEN GET-DIG, PUSH("."), (REPEAT 5 GET-DIG), POP-TZS, PR-EXP
;   ELSE (REPEAT ODE+1 GET-DIG), PUSH("."), (REPEAT 5-ODE GET-DIG), POP-TZS
;
;GET-DIG:
;  PUSH(INTP)
;  NUM := NUM - INTP, NUM := NUM * 10, NUM := NUM + ROUND
;  IF NUM >= 10 THEN NUM := NUM / 10
;  INTP := INT(NUM)
.PAGE

OTFXS2:	STA NARG1
	LDA #$00
	STA NARG1+1
OTFXS1:	CONS ARG1,NARG1,0,FIX
	JMP OTPRG1

OTPFX1:	LDY #NARG1
OTPFIX:	LDA $03,Y
	CMP #$80
	BNE OTPFXA
	LDA $02,Y
	BNE OTPFXA
	LDA $01,Y
	BNE OTPFXA
	LDA $00,Y
	BNE OTPFXA
	SETNUM NARG1,FNEG0	;Attempted to output -2^31, so change to flonum
OTPFL1:	LDY #NARG1
OTPFLO:	LDA #FLO
	BNE OTPNUM	;(Always)
OTPFXA:	LDA #FIX
OTPNUM:	PHA		;Save type
	LDA #ARG1
	STA NODPTR
	TYA
	TAX
	INX
	INX
	PLA		;Retrieve type
	JSR FICONS
	JMP OTPRG1

FNEG0:	$9E	;Negative zero, ie -2^31
	$80
	$00
	$00
	$00
.PAGE
.SBTTL	Output Routines

;	Local variable block:
STRPTR	=TEMPNH		;String address

;PRTSTR prints the Ascii string whose address is in the X and Y registers.
;The string is terminated with a 0.
PRTSTR: STX STRPTR
	STY STRPTR+1
	LDY #$00
PTSTR1:	LDA GETRM2	;Enable Ghost-memory
	LDA (STRPTR),Y
	BEQ PTRRTS
	JSR TPCHR
	INY
	BNE PTSTR1	;(Always)
PTRRTS:	LDA GETRM1	;Ghost-memory disable
	LDA GETRM1
	RTS
.PAGE
;	Local variable block:
TPLVLP	=TEMPN4		;Zero = print outer brackets on lists
NOSPCE	=TEMPN4+1	;Nonzero = print space before next element
THING	=TEMPN5		;Pointer to thing to print (shared: LTYPE,TYPATM,TPSATM)

LTYPE1:	LDA #$01
	BNE LTYPE	;(Always)
LTYPE0:	LDA #$00
LTYPE:	STA TPLVLP
	GETX THING
	PUSHA LTRTS1
PRTHNG:	GETTYP THING
	TYPDSP LTPTAB

;LTYPE type dispatch table
LTPTAB:	.ADDR LTPLS	;List
	.ADDR LTPA	;Atom
	.ADDR LTPA	;String
	.ADDR LTPF	;Fix
	.ADDR LTPF1	;Flo
	.ADDR SYSBG2	;Sfun
	.ADDR SYSBG2	;Ufun
	.ADDR LTPS	;Satom
	.ADDR SYSBG2	;Fpack
	.ADDR LTPQ	;Qatom
	.ADDR LTPD	;Datom
	.ADDR LTPL	;Latom

SYSBG2:	LDA #$05
	JMP SYSBUG

LTPFX:	LDY #$00
	LDX #$03
LTYPL1:	LDA (THING),Y
	STA NARG1,Y
	INY
	DEX
	BPL LTYPL1
	RTS

LTPQ:	LDA #'"
	BNE LTPD1	;(Always)
;...
LTPD:	LDA #':
LTPD1:	JSR TPCHR
	JSR LTPQDL	;Type the atom or satom without the :, ", or :.
	JMP POPJ

LTPA:	JSR TYPATM
	JMP POPJ

LTPS:	JSR TPSATM
	JMP POPJ

LTPL:	JSR LTPQDL
	LDA #':
	JSR TPCHR
	JMP POPJ

LTPF:	JSR LTPFX
	JSR TPBFIX
	JMP POPJ

LTPF1:	JSR LTPFX
	JSR TYPFLO
	JMP POPJ

LTPLS:	LDA #$01
	STA NOSPCE
	LDA TPLVLP
	BNE PLSTLP
	LDA #'[
	JSR TPCHR
;...
PLSTLP:	JSR TSTPOL
	LDA THING+1
	BNE PLLP1
	LDA TPLVLP
	BNE PLLP2
	STA NOSPCE	;Print a space after Sublists
	LDA #']
	JSR TPCHR
PLLP2:	JMP POPJ

PLLP1:	LDA NOSPCE
	BNE PLLP1A
	LDA #$20	;(Space)
	JSR TPCHR
PLLP1A:	PUSH THING
	PUSHB TPLVLP
	LDA #$00
	STA TPLVLP
	STA NOSPCE
	CARME THING
	PUSHA TPP1
	JMP PRTHNG

TPP1:	POPB TPLVLP
	POP THING
	CDRME THING
	JMP PLSTLP
.PAGE
;	Local variable block:
FUNPNM	=ANSN		;Nonzero = Funny-pname atom
CHARS	=TEMPNH		;String characters
THING	=TEMPN5		;Pointer to thing to print (shared: LTYPE,TYPATM,TPSATM)

;Find out if the Q,D, or Latom is an Atom or Satom and type it.
LTPQDL:	LDA THING
	AND #$FC
	STA THING
	GETTYP THING
	CMP #SATOM
	BEQ TPSATM
;...
TYPATM:	LDX #THING
	LDY #THING
	JSR GETPNM	;Returns with A=1 if Funny-pname
	STA FUNPNM
	TAX
	BEQ TPATMW
	LDA OTPFLG
	BEQ TPATMW
	LDA #$27	;Type quote if printing to buffer or funny-pname
	JSR TPCHR
TPATMW:	LDA THING+1
	BEQ TPTMWE
	CARNXT CHARS,THING
	LDA CHARS
	BEQ TPTMWE
	JSR TPCHR
	LDA CHARS+1
	BEQ TPTMWE
	JSR TPCHR
	JMP TPATMW
TPTMWE:	LDA FUNPNM
	TAX
	BEQ LTRTS1
	LDA OTPFLG
	BEQ LTRTS1
	LDA #$27	;Type quote if printing to buffer
	JMP TPCHR
.PAGE
;	Local variable block:
THING	=TEMPN5		;Pointer to thing to print (shared: LTYPE,TYPATM,TPSATM)

TPSATM:	CDRME THING
	LDY #PRMNAM
TPSTMW:	LDA GETRM2	;Enable ghost-memory
	LDA (THING),Y
	BEQ LTPRTS
	JSR TPCHR
	INY
	BNE TPSTMW	;(Always)
LTPRTS:	LDA GETRM1	;Disable ghost-memory
	LDA GETRM1
LTRTS1:	RTS

;Types a two-byte fixnum, always positive.
TYPFIX:	JSR CVFIX	;Get string on PDL
	JMP PRTPDL	;Type string on PDL

;Types a four-byte fixnum in NARG1.
TPBFIX:	JSR CVBFIX	;Get string on PDL
	JMP PRTPDL	;Type string on PDL

;Type the flonum in NARG1.
TYPFLO:	JSR CVFLO	;Get String on PDL
;	...

;Type the string on the PDL, CCOUNT holds character count. Must be a small string!
;	...
PRTPDL:	LDA #$00
	PHA		;Push stop indicator
PRTPL1:	JSR POPB	;Pop chars off PDL and onto stack
	PHA
	DEC CCOUNT
	BNE PRTPL1
PRTPL2:	PLA		;Pop chars from stack and type them
	BEQ LTRTS1	;until stop indicator popped
	JSR TPCHR
	JMP PRTPL2
.PAGE
;	Local variable block:
OBPTR	=TEMPN8		;Oblist ptr.
NAME	=TEMPN6		;Name ptr. (shared: PONAMS,PONAME)
SOBPTR	=TEMPN6		;Soblist ptr.

PONAMS:	MOV OBPTR,OBLIST	;OBPTR is OBLIST pointer
PONW1:	LDA OBPTR+1
	BEQ PONW1E	;See if done
	CARNXT NAME,OBPTR
	JSR PONAME	;Print the name and value
	JMP PONW1
PONW1E:	MOV SOBPTR,SOBLST	;SOBPTR is SOBLIST pointer
PONW2:	LDA SOBPTR
	CMP SOBTOP
	BNE PONW2A	;See if done
	LDA SOBPTR+1
	CMP SOBTOP+1
	BNE PONW2A
PONRTS:	RTS
PONW2A:	JSR PONAME	;Print the name and value
	INC4 SOBPTR
	JMP PONW2
.PAGE
;	Local variable block:
VALUE	=TEMPN7		;Value ptr.
NAME	=TEMPN6		;Name ptr. (shared: PONAMS,PONAME)

PONAME:	LDX #VALUE
	LDY #NAME
	JSR GETVAL
	CMP #$01
	BEQ PONRTS	;Skip if novalue
PON1A:	LDA OTPFLG
	BNE PON1B	;Use MAKE if printing to buffer
	LDA #'"
	JSR TPCHR
	INC OTPFLG	;Always print quotes
	LDX #NAME
	JSR LTYPE
	PRTSTR PNMSG1	;"IS "
	LDX #VALUE
	JSR LTYPE0
	DEC OTPFLG	;Restore it
	JMP BREAK1
PON1B:	PRTSTR PNMSG2	;'MAKE "'
	LDX #NAME
	JSR LTYPE
	LDA #$20
	JSR TPCHR
	GETTYP VALUE
	CMP #ATOM
	BEQ PON1D
	CMP #SATOM
	BEQ PON1D
	CMP #STRING
	BNE PON1C
PON1D:	LDA #'"
	JSR TPCHR
PON1E:	LDX #VALUE
	JSR LTYPE0
	JMP BREAK1
PON1C:	CMP #FIX
	BEQ PON1G
	CMP #FLO
	BNE PON1E
	LDY #$00	;A flonum, see if it's negative
	LDA (VALUE),Y
	BPL PON1E
PON1F:	LDA #'(		;It's negative, enclose it in ()'s
	JSR TPCHR
	LDX #VALUE
	JSR LTYPE0
	LDA #')
	JSR TPCHR
	JMP BREAK1
PON1G:	LDY #$03	;A fixnum, see if it's negative
	LDA (VALUE),Y
	BPL PON1E
	BMI PON1F	;(Always)
.PAGE
;	Local variable block:
FUNPTR	=TEMPX2		;Function ptr.
FULL	=ANSN4		;Zero = print only title lines (shared: POFUNS,POFUN)

POFUNS:	STA FULL
	MOV FUNPTR,OBLIST	;FUNPTR is OBLIST pointer
POFNSW:	LDY #$03
	LDA (FUNPTR),Y
	PHA
	DEY
	LDA (FUNPTR),Y
	PHA
	DEY
	LDA (FUNPTR),Y
	TAX
	DEY
	LDA (FUNPTR),Y
	STA FUNPTR
	STX FUNPTR+1
	LDX #FUNPTR
	JSR POFUNX
	PLA
	STA FUNPTR
	PLA
	STA FUNPTR+1
	BNE POFNSW
	RTS
.PAGE
;	Local variable block:
ATMPTR	=ANSN1		;Function atom ptr.
FUN	=TEMPN6		;Function body
LINE	=TEMPN8		;Function line ptr.
LINPTR	=TEMPN8		;Fpacked line ptr. (shared: TPLINF,ERROR,POFUN)
ENDPTR	=TEMPX2		;Fpacked line-end ptr. (shared: TPLINF,ERROR,POFUN)
TOKEN	=TEMPX1		;Token pointer
FULL	=ANSN4		;Zero = print only title lines (shared: POFUNS,POFUN)

POFUN:	STA FULL
POFUNX:	STX ATMPTR	;Save ATMPTR (Entry point for POFUNS)
	LDA #FUN
	JSR GETFUN
	CMP #$01
	BEQ PFNRTS
	INC OTPFLG	;Print funny-pname quotes
	PRTSTR TOMSG	;"TO "
	LDX ATMPTR	;Retrieve ATMPTR
	JSR LTYPE	;Print the name
	CDRME FUN
	GETTYP FUN
	CMP #LIST
	BEQ POTXTL
	JMP POTXTF
POTXTL:	CARNXT LINE,FUN
	LDA #$20
	JSR TPCHR
	LDX #LINE
	JSR LTYPE1
	JSR BREAK1
	LDA FULL
	BEQ PTXRTS
PTXLX:	LDA FUN+1
	BEQ PTXEND
	CARNXT LINE,FUN
	LDX #LINE	;LTYPE the list-line
	JSR LTYPE1
	JSR BREAK1
	JMP PTXLX
PTXEND:	PRTSTR ENDMSG
	JSR BREAK1
PTXRTS:	DEC OTPFLG	;Reset OTPFLG to its previous value
PFNRTS:	RTS
POTXTF:	CAR LINPTR,FUN
	CDR ENDPTR,FUN
	INC2 FUN
	JSR TPLINF	;Type the title line
	JSR BREAK1
	LDA FULL
	BNE PTXFX
	DEC OTPFLG	;Reset OTPFLG to its previous value
	RTS
PTXFX:	LDA ENDPTR+1
	BEQ PTXEND
	STA LINPTR+1
	LDA ENDPTR
	STA LINPTR
	CDR ENDPTR,FUN
	INC2 FUN
	LDA ENDPTR+1
	BEQ PTXEND
	JSR TPLINF
	JSR BREAK1
	JMP PTXFX
.PAGE
.SBTTL	Arithmetic Routines
.SBTTL		Floating Point Routines

FLOTN2:	JSR SWAP
	JSR FLOTN1
	JMP SWAP

FLOTN1:	LDA NARG1+3
	BPL XFLOAT
	LDX #NARG1
	JSR COMPL
	JSR XFLOAT
	JMP FCOMPL

;	Local variable block:
EXP	=ANSN		;Exponent

XFLOAT:	LDA #$9E
	STA EXP		;Shift counter (exponent)
XFLT1:	LDA NARG1+3
	CMP #$C0
	BMI XFLT2
	ASL NARG1
	ROL NARG1+1	;Rotate left to left-justify
	ROL NARG1+2
	ROL NARG1+3
	DEC EXP
	BNE XFLT1	;Stop if exponent is zero
XFLT2:	LDA NARG1+1	;Reverse LSB, MSB for floating pt. format
	LDY NARG1+3
	STY NARG1+1
	STA NARG1+3
	LDA EXP
	STA NARG1	;Put in exponent
	RTS
.PAGE
;	Local variable block:
SIGN	=ANSN		;Mantissa sign
NARG0	=TEMPNH		;Temp. number storage

;Add M1 and M2, result in M1.
ADD:	CLC		;Clear carry
	LDX #$02	;Index for 3-byte add
ADD1:	LDA NARG1+1,X
	ADC NARG2+1,X	;Add a byte of Mant2 to Mant1
	STA NARG1+1,X
	DEX		;Index to next more signif. byte
	BPL ADD1	;Loop until done
	RTS		;Return

;Makes X/M1 and X/M2 positive. Returns with LSB of SIGN equal to XOR of
;signs of original numbers. Copies (positive) mantissa of X/M1 into E.
MD1:	ASL SIGN	;Clear LSB of Sign
	JSR ABSWAP	;Abs. val. of M1, then swap with M2
ABSWAP:	BIT NARG1+1	;Is Mant1 negative...
	BPL ABSWP1	;No, swap with Mant2 and return
	JSR FCOMPL	;Yes, complement it.
	INC SIGN	;Increment sign, complementing LSB
ABSWP1:	SEC		;Set carry for return to MUL/DIV
;	...

;Swaps X/M1 and X/M2 and leaves a copy of M1 in E.
;	...
SWAP:	LDX #$04	;Index for 4-byte swap
SWAP1:	STY NARG0-1,X
	LDA NARG1-1,X	;Swap a byte of Exp/Mant1 with
	LDY NARG2-1,X	;Exp/Mant2 and leave a copy of
	STY NARG1-1,X	;Mant1 in E (3 bytes). (E+3 is destroyed.)
	STA NARG2-1,X
	DEX		;Advance index to next byte
	BNE SWAP1	;Loop until done
	RTS		;Return

;Normalize M1 and X1 to standard format floating pt. (left-justified mantissa,
;exponent tells how much so).
NORM1:	LDA NARG1+1	;High-order Mant1 byte
	CMP #$C0	;Are Upper two bits unequal...
	BMI RTS1	;Yes, return with Mant1 normalized.
	DEC NARG1	;Decrement X1
	ASL NARG1+3
	ROL NARG1+2	;Shift Mant1 3 bytes left
	ROL NARG1+1
FNORM:	LDA NARG1	;Is Exp1 zero...
	BNE NORM1	;No, continue normalizing.
RTS1:	RTS		;Return

;Floating pt. add. X/M1 becomes X/M2 + X/M1.
FADD:	JSR FADD1
	CLC		;If it returns, then no overflow
	RTS

FSUB:	JSR SWAP	;It does M2-M1, we want M1-M2
FSUBX:	JSR FSUB1
	CLC
	RTS

FMUL:	JSR FMULT
	CLC
	RTS

FDIV:	JSR SWAP	;It does M2/M1, we want M1/M2.
FDIVX:	JSR FDIVD
	CLC
	RTS
.PAGE
;Floating pt. subtract. X/M1 becomes X/M2 - X/M1.
FSUB1:	JSR FCOMPL	;Complement Mant1, clears carry unless 0
SWPALN:	JSR ALNSWP	;Right shift Mant1 or swap
FADD1:	LDA NARG2
	CMP NARG1	;Compare Exp1 with Exp2
	BNE SWPALN	;If unequal, swap addends or align mantissas
	JSR ADD		;Add aligned mantissas
ADDEND:	BVC FNORM	;No overflow, normalize result
	BVS RTLOG	;(Always) Overflow - shift M1 right, carry into Sign

;Either swap mantissas (for another alignment) or do an alignment. Carry bit
;resultants determine which to do each time over.
ALNSWP:	BCC SWAP	;Swap if carry clear, else shift right arith.
RTAR:	LDA NARG1+1	;Sign of M1 into carry for
	ASL A		;right arith. shift
RTLOG:	INC NARG1	;Increment X1 to adjust for right shift
	BEQ OVFL	;Exp1 out of range
RTLOG1:	LDX #$FA	;Index for 6 byte right shift
ROR1:	ROR NARG0+3,X	;(M1 and E must be contiguous)
	INX		;Next byte of shift
	BNE ROR1	;Loop until done
	RTS		;Return

;Floating pt. multiply. X/M1 becomes X/M1 * X/M2.
FMULT:	JSR MD1		;Absolute value of Mant1, Mant2.
	ADC NARG1	;Add Exp1 to Exp2 for product Exp
	JSR MD2		;Check product exp. and prepare for multiply
	CLC		;Clear carry for first bit
FMUL1:	JSR RTLOG1	;M1 and E right (product and multiplier)
	BCC FMUL2	;If carry clear, skip partial product
	JSR ADD		;Add multiplicand to product
FMUL2:	DEY		;Next multiply iteration
	BPL FMUL1	;Loop until done
MDEND:	LSR SIGN	;Test Sign LSB
NORMX:	BCC FNORM	;If even, normalize product, else complement
;	...

;Complement the mantissa of M1.
;	...
FCOMPL:	SEC		;Set carry for subtract
	LDX #$03	;Index for 3-byte subtract
COMPL1:	LDA #$00	;Clear A
	SBC NARG1,X	;Subtract byte of Exp1
	STA NARG1,X	;Restore it
	DEX		;Next more significant byte
	BNE COMPL1	;Loop until done
	BEQ ADDEND	;(Always)

;Floating pt. multiply. X/M1 becomes X/M1 / X/M2.
FDIVD:	JSR MD1		;Take abs. val. of Mant1, Mant2
	SBC NARG1	;Subtract Exp1 from Exp2
	JSR MD2		;Save as quotient exp.
DIV1:	SEC		;Set carry for subtract
	LDX #$02	;Index for 3-byte subtraction
DIV2:	LDA NARG2+1,X
	SBC NARG0,X	;Subtract a byte of E from Mant2
	PHA		;Save on stack
	DEX		;Next more significant byte
	BPL DIV2	;Loop until done
	LDX #$FD	;Index for 3-byte conditional move
DIV3:	PLA		;Pull byte of difference off stack
	BCC DIV4	;If M2 smaller than E then don't restore M2
	STA NARG2+4,X
DIV4:	INX		;Next less significant byte
	BNE DIV3	;Loop until done
	ROL NARG1+3
	ROL NARG1+2	;Roll quotient left, carry into LSB
	ROL NARG1+1
	ASL NARG2+3
	ROL NARG2+2	;Shift dividend left
	ROL NARG2+1
	BCS OVFL	;Overflow is due to un-normalized divisor
	DEY		;Next divide iteration
	BNE DIV1	;Loop until done 23 iterations
	BEQ MDEND	;(Always) Normalize quotient and correct sign

;Prepare for multiply or divide, check result's exponent.
MD2:	STX NARG1+3
	STX NARG1+2	;Clear Mant1 (3 bytes) for MUL/DIV
	STX NARG1+1
	BCS OVCHK	;If calculation set carry, check for overflow
	BMI MD3		;If negative, then no underflow
	PLA		;Pop one return level (undeflow, answer is 0)
	PLA
	BCC NORMX	;Clear X1 and return
MD3:	EOR #$80	;Complement sign bit of exponent
	STA NARG1	;Store it.
	LDY #$17	;Count 24. (MUL) or 23. (DIV) iterations
	RTS		;Return

OVCHK:	BPL MD3		;If positive exponent, then no overflow.
	PLA
	PLA		;Pop past MD2 call

OVFL:	PLA	;Overflow, pop past first function call
	PLA
	SEC	;Indicate overflow
	RTS
.PAGE
;Changes the argument in (X) from Flonum to four-byte Fixnum (rounds).
RNDN2:	JSR SWAP	;Pos or neg, only NARG2
	JSR RNDN1
	JMP SWAP

RNDN1:	LDA NARG1+1	;is it positive
	BPL XINTN1	;yes
	JSR FCOMPL	;for negatives: negate --> convert --> negate
	JSR XINTN1
	LDX #NARG1
	JMP COMPL

XINTN1:	LDX #$03	;(Bashes NARG2)
SINTL:	LDA NARG2,X
	PHA		;Save NARG2
	LDA RNDUP,X	;Get 0.5 into NARG2
	STA NARG2,X
	DEX
	BPL SINTL
	JSR FADD
	JSR INTN1
FFIXD:	LDX #$FC
FFIXDL:	PLA		;Restore NARG2
	STA NARG2+4,X
	INX
	BMI FFIXDL
	RTS

RNDUP:	$7F	;Floating-point constant, 0.5
	$40
	$00
	$00

;Pos or neg, only NARG1
INTN1:	LDA NARG1
	BMI FFIXP
	JSR ZNARG1		;Negative exponent gives zero result
FFIXR:	RTS
FFIXP:	CMP #$9F
	BCS OVFL1	;Exponent too high, overflow
	LDA NARG1+1
	BPL FFIXP1
	JSR FCOMPL
	JSR FFIXP1
	LDX #NARG1
	JMP COMPL
FFIXP1:	LDA NARG1
	STA EXP
	LDA #$00
	STA NARG1	;Init LSB to zero
	LDA NARG1+1
	LDY NARG1+3	;Switch LSB, MSB for fixnum format
	STY NARG1+1
	STA NARG1+3
FFIX1:	LDA EXP
	CMP #$9E
	BEQ FFIXR	;Done when Exp=30. (4 bytes, binary point two places in)
	LSR NARG1+3
	ROR NARG1+2	;Rotate to right-justify
	ROR NARG1+1
	ROR NARG1
	INC EXP
	BNE FFIX1	;(Always)
OVFL1:	ERROR XOFL
.PAGE
;	Local variable block:
PRODCT	=TEMPN		;Partial product (shared: IMULT,MOD360,SPROD,SRANDM)
SAVNG1	=TEMPN2		;NARG1 save

;this routine expects a flonum in NARG1, bashes it to between 0 and 360
;and puts the result in NARG1.
;cases: positive, < 360: ok.
;	positive, < 720: subtract 360.
;	negative, > -360: add 360.
;	else bash 
;bash (x) temp := (int (x/360.0)) * 360
;	  x := x - (float temp)
;	  if negative, add 360.

MOD360:	LDY #SAVNG1
	JSR XN1TOY		;Save NARG1
	LDA NARG1+1
	BMI M3NEG		;check for neg
	JSR M3SUB		;NARG1 := NARG1 - 360
	LDA NARG1+1
	BMI M3REST		;if we got a neg result, just restore (0 < x < 360)
	JSR M3SUB
	LDA NARG1+1		;restore adds 360 to NARG1
	BPL M3BASH
M3REST:	JSR SET360
	JMP FADD		;add 360 back to NARG1
M3NEG:	JSR M3ADD		;get NARG1 + 360. in NARG1
	LDA NARG1+1
	BPL M3RTS
M3BASH:	LDY #SAVNG1		;restore NARG1
	JSR XYTON1
	JSR SET360
	JSR FDIV
	JSR INTN1		;integerize result
	LDA #$68
	STA NARG2		;putting a fixnum 360 in
	LDX #$01		;NARG2
	STX NARG2+1
	DEX
	STX NARG2+2
	STX NARG2+3
	JSR IMULT		;fixnum multiply, PRODCT := NARG1*NARG2
	LDY #PRODCT
	JSR XYTON1		;NARG1 := PRODCT
	JSR FLOTN1		;floating-pointify NARG1
	LDY #SAVNG1
	JSR XYTON2		;original arg in NARG2
	JSR FSUBX
	LDA NARG1+1		;if still negative, just add 360
	BPL M3RTS
M3ADD:	JSR SET360
	JMP FADD		;floating add of NARG2 and NARG1,

M3SUB:	JSR SET360
	JMP FSUB		;floating point sub of NARG2 and NARG1,

SET360:	SETNUM NARG2,F360
	RTS

;	Constants:
F180:	$87	;Floating-point constant, 180.0
	$5A
	$00
	$00

F360:	$88	;Floating-point constant, 360.0
	$5A
	$00
	$00
.PAGE
.SBTTL		Fixnum Routines

;Complement (negate) a fixnum.
COMPL:	LDY #$03
	SEC
CMPL1:	LDA $00,X
	EOR #$FF	;Complement
	ADC #$00	;and increment.
	STA $00,X
	INX
	DEY
	BPL CMPL1
M3RTS:	RTS

;	Local variable block:
SIGN	=ANSN		;Sign of product
PRODCT	=TEMPN		;Partial product (shared: IMULT,MOD360,SPROD,SRANDM)

;PRODCT gets NARG1 * NARG2.
IMULT:	LDA NARG1+3	;(Bashes NARG2)
	EOR NARG2+3
	STA SIGN
	LDA NARG1+3
	BPL SPRD1
	LDX #NARG1
	JSR COMPL
SPRD1:	LDA NARG2+3
	BPL SPRD2
	LDX #NARG2
	JSR COMPL
SPRD2:	LDA #$00
	LDX #$03
SPRDL1:	STA PRODCT,X
	DEX
	BPL SPRDL1
	LDY #$20	;Bit counter
MUL2:	LSR NARG2+3
	ROR NARG2+2
	ROR NARG2+1
	ROR NARG2
	BCC MUL4
	CLC
	LDX #$FC
SPRDL2:	LDA PRODCT+4,X	;Add multiplicand (NARG1) to partial product
	ADC NARG1+4,X
	STA PRODCT+4,X
	INX
	BMI SPRDL2
	TAX
	BMI IMULOV
MUL4:	ASL NARG1
	ROL NARG1+1
	ROL NARG1+2
	ROL NARG1+3
	BPL MUL4A
	LDX #$03	;Sig. bit dropped from NARG1, so bit counter better be 0
MUL4B:	LDA NARG2,X
	BNE IMULOV	;It isn't, error
	DEX
	BPL MUL4B
	BMI MULEND	;(Always) It is, so we're done
MUL4A:	DEY
	BNE MUL2	;Next bit
MULEND:	LDA SIGN
	BPL SPRD3
	LDX #PRODCT
	JSR COMPL
SPRD3:	CLC
	RTS
IMULOV:	SEC
	RTS
.PAGE
IDIVID:	LDA #$00
	STA SIGN
	LDA NARG1+3
	BPL SDVD2
	LDX #NARG1
	JSR COMPL
	INC SIGN
SDVD2:	LDA NARG2+3
	BPL SDVD3
	LDX #NARG2
	JSR COMPL
	LDA SIGN
	EOR #$01
	STA SIGN
SDVD3:	JSR XDIVID	;NARG2 is divisor, NARG1 is dividend, then quotient
	LDA SIGN
	BEQ SDVD4
	LDX #NARG1
	JSR COMPL
SDVD4:	RTS
.PAGE
;Divides NARG1 by vA.
XDVDX:	TAX
	JSR ZNARG2	;clear out narg2.
	STX NARG2
;	...

;	Local variable block:
BITHLD	=TEMPN		;Bitholder
QUOTNT	=A1L		;Quotient

;Fast and clean fixnum division routine, assumes positive numbers.
;Dividend in NARG1, divisor in NARG2.
;NARG1 becomes quotient, low byte of remainder in vA, full remainder in NARG2.
;	...
XDIVID:	LDX #$03
SDVLP1:	LDA NARG2,X
	BNE XDVD1
	DEX
	BPL SDVLP1
	ERROR XDBZ
XDVD1:	LDA #$00		;Zero temp. quotient
	LDX #$03
XDLP1:	STA QUOTNT,X
	STA BITHLD,X
	DEX
	BPL XDLP1
	INC BITHLD		;Initialize bitholder
NORM:	ASL BITHLD		;Normalize the bitholder...
	ROL BITHLD+1
	ROL BITHLD+2
	ROL BITHLD+3
	ASL NARG2
	ROL NARG2+1		;and the divisor
	ROL NARG2+2
	ROL NARG2+3
	BPL NORM		;to the left side
	BMI SHFT		;(Always)
SHFTX:	PLA			;(Discard intermediate result)
SHFT:	LSR BITHLD+3		;Back 'em off one
	ROR BITHLD+2
	ROR BITHLD+1
	ROR BITHLD
	LSR NARG2+3
	ROR NARG2+2
	ROR NARG2+1
	ROR NARG2
	LDX #$03
XDLP2:	LDA BITHLD,X
	BNE DV2			;If bitholder is zero, done
	DEX
	BPL XDLP2
	BMI DONE		;(Always)
DV2:	SEC			;Subtract divisor from dividend
	LDA NARG1
	SBC NARG2
	PHA
	LDA NARG1+1
	SBC NARG2+1
	TAX
	LDA NARG1+2
	SBC NARG2+2
	TAY
	LDA NARG1+3
	SBC NARG2+3
	BCC SHFTX		;If borrow, don't save remainder
	STA NARG1+3		;or add to result
	STY NARG1+2
	STX NARG1+1
	PLA
	STA NARG1
	CLC
	LDX #$FC
XDLP3:	LDA QUOTNT+4,X		;Add bitholder to result
	ADC BITHLD+4,X
	STA QUOTNT+4,X
	INX
	BMI XDLP3
	BPL SHFT		;(Always)
DONE:	LDY #NARG2
	JSR XN1TOY	;Put remainder in NARG2
	LDY #QUOTNT
	JSR XYTON1
	LDA NARG2
	RTS

;	Local variable block:
ARG	=TEMPN3		;Argument copy
GUESS	=TEMPN5		;Square-root guess

SQRTR:	JMP OVFL1	;number out of range.
SSQRT:	JSR GT1FLT	
	LDA NARG1+1
	BMI SQRTR	;We don't do negatives
	LDA NARG1
	ORA NARG1+1
	ORA NARG1+2
	ORA NARG1+3
	BNE SQRTAE	;Nope
SQRTO:	JMP OTPFL1	;Yup, output it
SQRTAE:	LDY #ARG
	JSR XN1TOY	;Keep a copy of the arg around
	LDA NARG1	;Halve the exponent to get the first guess...
	BMI SQRTA
	LSR A		;Positive exponent, just shift to right
	BPL SQRTB	;(Always)
SQRTA:	SEC		;Negative exponent
	ROR A		;Shift in a one
	AND #$BF	;Zap the one from before
SQRTB:	STA NARG1
	LDY #GUESS
	JSR XN1TOY	;Copy arg into Guess
SQRT1:	LDY #ARG
	JSR XYTON2	;Put orig. arg in NARG2 (Guess is in NARG1 now)
	JSR FDIVX	;Get Arg/Guess
	LDY #GUESS
	JSR XYTON2	;Get guess in NARG2
	JSR FADD	;Get Guess+Arg/Guess
	DEC NARG1	;Divide NARG1 by 2 to get (Guess+Arg/Guess)/2
	LDX #$02	;Compare new guess to old guess
SQRTL1:	LDA GUESS,X	;First three bytes must be equal
	CMP NARG1,X
	BNE SQRT2
	DEX
	BPL SQRTL1
	LDA GUESS+3	;Compare 4 most sig. bits of least sig. bytes
	EOR NARG1+3
	AND #$F0
	BEQ SQRTO	;Good enough, return with new guess
SQRT2:	LDY #GUESS
	JSR XN1TOY	;Still not good enough, make this new guess
	JMP SQRT1	;Try again
.PAGE
.SBTTL	Screen Editor

;Tell RETRIEVE that buffer is not retrievable
NOEDBF:	SETV ENDBUF,EDBUF
	RTS

;increment the point (EPOINT,EPOINT+1).

INCPNT:	INC1 EPOINT
	RTS

;decrement the point.

DECPNT:	LDA EPOINT
	SEC
	SBC #$01
	STA EPOINT
	BCS DECPT2
	DEC EPOINT+1
DECPT2:	RTS

;set the point to the beginning of the buffer.

PNTBEG:	SETV EPOINT,EDBUF
	RTS

;place cursor at top of screen

TOPSCR:	LDA #$00	;cursor at top of screen
	STA BASLIN	;baseline for top of screen
	STA CH
	STA CV
	LDA #$04
	STA BASLIN+1
	RTS

;output char in AC to EDBUF at point. Increments point. Does NOT
;increment last-char-in-buffer pointer. Returns without modifying if
;at end of buffer.
;THE CODE FOR THIS ROUTINE HAS BEEN MOVED TO THE I/O SECTION.
;THERE'S A GOOD REASON FOR IT -- IT HAS MEMORY ALLOTED TO IT
;THAT IT ISN'T USING.

.PAGE
;	Local variable block:
CHRSAV	=A2L		;Temp. character
ADRESS	=A2L		;Dispatch address

;top level loop in the editor; listens for characters; outputs them to
;the screen and the edit buffer; accepts commands and has them
;processed.

EDTLOP:	JSR RDKEY	;get char from kbd
	STA CHRSAV	;save it
	LDA #<EDTLOP-1>^	;push return address
	PHA
	LDA #<EDTLOP-1>&$FF
	PHA
	LDY #$00
EDSLOP:	LDA EDSTBL,Y	;dispatch off command table
	BEQ EDSLOS	;0 signifies end of table
	CMP CHRSAV
	BEQ EDSWIN
	INY
	INY		;go for next entry
	INY
	BNE EDSLOP	;always, unless table is too big
EDSWIN:	INY
	LDA EDSTBL,Y
	STA ADRESS
	INY
	LDA EDSTBL,Y
	STA ADRESS+1
	JMP (ADRESS)

EDSTBL:	$01
	.ADDR BEGLIN
	$02
	.ADDR PRVSCR
	$03
	.ADDR EDDONE
	$04
	.ADDR DELETE
	$05
	.ADDR EOLLIN
	$06
	.ADDR NXTSCR
	$07
	.ADDR EDQUIT
	$08
	.ADDR BCKCHR
	$0B
	.ADDR KILLIN
	$0C
	.ADDR CENTER
	$0D
	.ADDR DINSRT
	$0E
	.ADDR NXTLIN
	$0F
	.ADDR OPLINE
	$10
	.ADDR PRVLIN
	$15
	.ADDR FORCHR
	$1B
	.ADDR RUBOUT
	$00

EDSLOS:	LDA CHRSAV
	CMP #$20	;lowest legal character
	BCS DINSR2	;not a command, insert it.
	JMP BELL
DINSRT:	LDA #$0D	;A2L is bashed by now; so get a CR in AC.
DINSR2:	JMP INSERT

EDQUIT:	JSR RESETT
	ERROR XZAP,XSTOP

;EDDONE will read the editor-defined code back into Logo.

EDDONE:	PLA
	PLA		;get EDTLOP return addr off stack
	LDY #$00
	LDA #$0D	;Carriage return at end if there isn't one.
	STA (ENDBUF),Y
	INC1 ENDBUF
	JSR PNTBEG	;point to beginning
	JSR RESETT	;Clear the screen
	INC INPFLG
	PRTSTR WAITM
	PUSHA EDDONX
	JMP EVLBUF
EDDONX:	JSR PNTBEG
	JMP POPJ

;	Local variable block:
EPNT1	=A4L		;Alt. EPOINT
CH1	=A2L		;Alt. CH
CV1	=A2H		;Alt. CV

;this function will display the buffer beginning at the point on the
;screen, beginning at CH, CV (should be consistent with BASLIN). It
;will stop if there is nothing more in the buffer, or when there is no
;more room on the screen. Updates SLSTCH (last-char-displayed
;pointer). EDPBUF will check as it displays for the point (which is
;recovered from EPNT1) and will set CV, CH accordingly.

EDSPBF:	MOV EPNT1,EPOINT
EDPBUF:	MOV CH1,CH
EDSPLP:	LDA EPOINT+1
	CMP ENDBUF+1
	BCC EDSPB1
	BNE EDPRTS
	LDA EPOINT
	CMP ENDBUF
	BCS EDPRTS	;quit if no more in buffer
EDSPB1:	LDY #$00
	LDA (EPOINT),Y	;get char
	CMP #$0D	;#$0D = CR
	BEQ EDSPCR
	LDX CH
	INX
	CPX WNDWTH	;if at end of line and next char is a
	BCC EDPCHR	;cr, then no !. otherwise yes.
	PHA
	LDA #'!
	JSR SCROUT	;output continuation line char
	PLA
	LDX CV		;when we output the continuation char SCROUT
	JMP EDPCR1	;inc'ed CV, so don't now.
EDOPCR:	LDX CV
	INX		;if we output the CR (or char on next line),
;give you a little lecture, boys and girls. we have a pointer, SLSTCH,
;which points to the character after the last character on the screen.
;It makes it possible for us to tell when we're over, stuff like that.
;Well, turns out there's ambiguity in just keeping that -- we need
;more information. Cause if we have a line with a CR at the end of it,
;and that CR is at the end of the buffer, and it's at the bottom of
;the screen, then the last char on the screen is that CR, so SLSTCH =
;ENDBUF, but there's a next screenful(!), so we'll fuck up in various
;ways. The thing we do here is make SLSTCH be one less in that case,
;but that causes unnecessary redisplays. So take my advice, boys and
;girls, and put a line table in your screen editor. It's worth it in
;the end.
EDPCR1:	CPX WNDBTM	;will we have exceeded the screen length...
	BCS EDRTS2	;yes, quit while we're not ahead
EDPCHR:	LDX EPOINT
	CPX EPNT1
	BNE EDPCH2
	LDX EPOINT+1	;if we're at point then set CV, CH so we can
	CPX EPNT1+1	;display the cursor in the right place when
	BNE EDPCH2	;we come back
	LDX CV
	STX CV1
	LDX CH
	STX CH1
EDPCH2:	JSR SCROUT	;output char; back for more
	JSR INCPNT
	JMP EDSPLP
EDSPCR:	PHA
	JSR CLREOL
	PLA 
	JMP EDOPCR
EDPRTS:	JSR CLREOP
EDRTS2:	LDX EPOINT
	CPX EPNT1
	BNE EDPRS2
	LDX EPOINT+1	;if we're at point then set CV, CH so we can
	CPX EPNT1+1	;display the cursor in the right place when
	BNE EDPRS2	;we come back
	LDX CV
	STX CV1
	LDX CH
	STX CH1
EDPRS2:	MOV SLSTCH,EPOINT	;point is now at location after last char on
	MOV CH,CH1	;screen; store in char-after-last-char-pointer
	JSR BCALC
	MOV EPOINT,EPNT1
ZPBRTS:	RTS

SCROUT:	CMP #$0D
	BEQ SCRCR
	LDY CH
	ORA #$80	;uppercase.
	CMP #$E0
	BCC SCRUC
	AND #$DF
SCRUC:	STA (BASLIN),Y
	INC CH
	LDA CH
	CMP WNDWTH
	BCC ZPBRTS
SCROT2:	LDA #$00
	STA CH
	INC CV
	JMP BCALC
SCRCR:	JSR CLREOL
	JMP SCROT2

.PAGE
ZAPBUF:	LDA GRPHCS	;The graphics flag is the same location as the
	PHA		;music flag. If it is 0, neither graphics nor
	LDA #$00	;music own the buffer.  If it is non-negative,
	STA NPARTS	;then there is no need to RESETT.  If negative,
	PLA		;graphics was in effect, so the screen must be cleared.
	BPL ZPBRTS
	JMP RESETT

;	Local variable block:
FUN	=TEMPN1		;Function ptr.

SEDIT:	LDA EXPOUT
	BNE EDTER1
	LDA INPFLG
	BNE ERXETL	;Error if already editing with screen editor
EDTST1:	JSR ZAPBUF
	JSR GARCOL	;GCOLL to perhaps alleviate the nodespace-full bug
	LDA TOKPTR+1
	BNE EDTST2
	JMP EDTNON
EDTST2:	JSR GETRG1	;car ARG1 from TOKPTR
	GETTYP ARG1
	CMP #SATOM
	BEQ EDTST4
	CMP #ATOM
	BNE EDTER5
	LDX #ARG1
	LDA #FUN
	JSR GETFUN
	CMP #$01
	BNE EDTOLD
	JMP EDTNEW
EDTOLD:	JSR EDTIN1
	LDA #$01
	LDX #ARG1
	JSR POFUN	;store function text in EDBUF
	JMP EDTXA1
ERXETL:	ERROR XETL,CURTOK
EDTER1:	LDA EDIT
	LDX EDIT+1
ERXNP1:	STA TEMPX2
	STX TEMPX2+1
	ERROR XNOP,TEMPX2
EDTER5:	JMP ERXWT1
EDTST4:	LDA ARG1
	LDX ARG1+1
	CMP ALL
	BNE EDTS4A
	CPX ALL+1
	BNE EDTS4A
	JSR EDTIN1
	JSR POFUNS
	JMP EDTX2
EDTS4A:	CMP PROCS
	BNE EDTS4B
	CPX PROCS+1
	BNE EDTS4B
	JSR EDTIN1
	JSR POFUNS
	JMP EDTXA1
EDTS4B:	CMP NAMES
	BNE EDTER4
	CPX NAMES+1
	BNE EDTER4
	JSR EDTIN1
EDTX2:	INC OTPFLG
	JSR PONAMS
	DEC OTPFLG
EDTXA1:	JSR EDTIN2
	JMP EDTIN3
EDTER4:	ERROR XCED,ARG1		;"Can't edit"

EDTNON:	LDA ENDBUF
	CMP #EDBUF&$FF
	BNE SEDT1
	LDA ENDBUF+1
	CMP #EDBUF^
	BNE SEDT1
	JSR EDTIN1	;Unretrievable, start with empty buffer
	JSR EDTIN2
	JMP EDTIN3
	JSR PNTBEG
SEDT1:	JSR EDTX1
EDTIN3:	JSR EDSPBF	;call edit-display-buffer
	JMP EDTLOP	;call text and command handling loop

EDTNEW:	JSR EDTIN1
	INC OTPFLG
	PRTSTR TOMSG
	LDX #ARG1
	JSR LTYPE
EDTNLP:	LDX #TOKPTR
	JSR TFKADV
	LDA TOKPTR+1
	BEQ EDTN2
	JSR GETRG1	;car ARG1 from TOKPTR
	LDA #$20
	JSR TPCHR
	LDX #ARG1
	JSR LTYPE0
	JMP EDTNLP
EDTN2:	DEC OTPFLG
	JSR BREAK1
	MOV EPNT1,EPOINT
	JSR EDTIN2
	JSR EDPBUF
	JMP EDTLOP

EDTIN2:	JSR SETVID	;make output device be screen again
	JSR ENDPNT	;mov endbuf,epoint  Edout leaves epoint -> last char.
	JSR PNTBEG	;label EDTX1 was here.
EDTX1:	LDA #$17	;Window bottom to allow display of
	STA WNDBTM	;"MIT Logo Editor" crock
	SETV SFSTCH,EDBUF	;store location of first char displayed on screen
	JSR TOPSCR	;(at beginning of buffer, maybe)
	JSR CENTER	;(Redisplay about point.);
	JMP EDTNYM	;print editor name

EDTIN1:	SETV OTPDEV,EDOUT	;location of edbuf output routine (for TPCHR)
	JMP PNTBEG	;initialize point for INSERT

EDTNYM:	LDA INVFLG
	PHA		;Save old INVFLG
	JSR SETINV	;print the "MIT Logo Screen Editor" thing on
	LDA CH		;the bottom line in reversed characters.
	PHA
	LDA CV		;save current screen location
	PHA
	LDA BASLIN	;save old baseline
	PHA
	LDA BASLIN+1
	PHA
	LDA #$00
	STA CH		;far left
	LDA #$23
	STA CV		;bottom of screen
	LDA #$D0	;slight speed bum -- we know we want
	STA BASLIN	;the bottom of the screen, so instead
	LDA #$07	;of calculating it via BCALC, we load
	STA BASLIN+1	;it up.
	PRTSTR EDTMSG
	PLA
	STA BASLIN+1
	PLA
	STA BASLIN
	PLA
	STA CV
	PLA
	STA CH
	PLA
	STA INVFLG	;Restore previous INVFLG
	RTS
.PAGE
;Command subroutines. It is the responsibility of a command to do its
;own redisplay, leave CH and CV indicating the position of the point
;on the screen, and the appropriate value in BASLIN before returning
;to EDTLOP. The cursor will be turned on by EDTLOP, however.
;Any command (that does anything) must update the database. The
;database consists of the edit buffer (EDBUF), whose contents must be
;updated by insertions/deletions; the point (EPOINT,EPOINT+1); the
;location in the EDBUF of the first character displayed on the screen
;(SFSTCH,SFSTCH+1); the location in the EDBUF AFTER the last character
;displayed on the screen (SLSTCH,SLSTCH+1), and the location AFTER
;the last character in the EDBUF (ENDBUF,ENDBUF+1).

INSERT:	PHA		;save char
	JSR MVDOWN	;move the buffer (starting at point) down one.
	PLA
	PHA
	JSR EDOUT	;put the char in the edit buffer
	PLA
	CMP #$0D
	BEQ INSRCR
	LDX CH
	INX
	CPX WNDWTH	;Are we at end of line...
	BCC INSRT2	;no, output straight
	PHA
	LDA #'!		;output a line continuation char.
	JSR SCROUT
	PLA		;recover char
	LDX CV		;if we output the line cont. char then SCROUT
	JMP INSRT0	;has inc'ed CV, so don't do it again.
INSRT1:	LDX CV
	INX
INSRT0:	CPX WNDBTM	;are we at end of screen...
	BNE INSRT2	;yes, redisplay instead of EDSPBF
	JMP CENTER	;^L type redisplay

INSRT2:	JSR SCROUT	;output char to screen
	JMP EDSPBF	;redisplay buffer from point down
INSRCR:	PHA
	JSR CLREOL
	PLA
	JMP INSRT1

;	Local block:
ENDBF1	=A1L		;Index starting at end of buffer, going in reverse

;move the contents of the edit buffer after point down one until
;reaching end of buffer contents (NOT end of buffer). Increments end
;of buffer contents pointer. Bashes AC,Y.

MVDOWN:	LDA ENDBUF
	SEC
	SBC #$01
	STA ENDBF1
	LDA ENDBUF+1
	SBC #$00
	STA ENDBF1+1
	LDY #$01
MVLOOP:	LDA ENDBF1+1
	CMP EPOINT+1
	BCC MVRTS
	BNE MVCONT
	LDA ENDBF1
	CMP EPOINT
	BCC MVRTS
MVCONT:	DEY
	LDA (ENDBF1),Y
	INY
	STA (ENDBF1),Y
	LDA ENDBF1
	SEC
	SBC #$01
	STA ENDBF1
	BCS MVLOOP
	DEC ENDBF1+1
	BCC MVLOOP	;(Always)
MVRTS:	INC1 ENDBUF
	RTS

;	Local variable block:
LINCNT	=A2L		;Line counter
CHRCNT	=A2H		;Character counter
CHCNT1	=A1L		;Alt. char. counter
LINES	=A1H		;No. of lines before point
CHCNT2	=A3L		;Alt. alt. chr. counter

;RDSPNT repositions the text on the screen around the point. The AC
;should hold the number of lines before the point one wants redisplay
;to start from. So, for ^L it should hold 12; for M-V it should hold
;23. RDSPNT will get confused if given a buffer that contains more
;than 256*39 contiguous chars without a carriage-return in them,
;because we have a one-bite physical line counter. You change it. Sets
;first and last char on screen pointers.

RDSPNT:	STA LINES	;save # lines wanted before point
	BNE RDSPT1	;do nothing if zero
RDSPT0:	RTS
RDSPT1:	LDA EPOINT
	CMP #EDBUF&$FF	;at bob?
	BNE RDSP15
	LDA EPOINT+1
	CMP #EDBUF^
	BEQ RDSPT0	;yo, quit
RDSP15:	LDY #$00
	STY LINCNT	;zero the line counter
	MOV EPNT1,EPOINT	;save the point
	LDA EPOINT
	SEC
	SBC CH		;get to beginning of this screen line
	STA EPOINT
	BCS RDSPT2
	DEC EPOINT+1
RDSPT2:	STY CHCNT2	;zero the char counter for SRCHBK
	STY CHCNT2+1
	JSR DECPNT	;Now, find out what the char at the end
	LDA (EPOINT),Y	;of the previous line is, because if it's
	PHA		;a CR, the line can be $28 long.
	JSR SRCHBK	;search back for after a CR or bob
	TAX		;save the indicator (0 -> bob; #$0D -> CR)
	PLA		;was the last char in this (previous) line a CR?
	CMP #$0D
	BEQ RDSPCR
RDSPT3:	LDA CHCNT2+1	;nope, see if it's bigger than $27
	BNE RDSPLS
	LDA CHCNT2
	CMP #$27
	BCC RDSPWN	;smaller(!), we can stop
	BEQ RDSPWN
RDSPLS:	LDA CHCNT2	;otw we have to count the screen lines in this
	SEC		;text line.
	SBC #$27
RDSPL1:	STA CHCNT2
	BCS RDSPL2
	DEC CHCNT2+1
RDSPL2:	INC LINCNT
	JMP RDSPT3

RDSPCR:	LDA CHCNT2+1
	BNE RDSPC2
	LDA CHCNT2	;this is the CR case from above
	CMP #$28
	BCC RDSPWN
	BEQ RDSPWN
RDSPC2: LDA CHCNT2
	SEC
	SBC #$28
	JMP RDSPL1

RDSPWN: INC LINCNT	;we have at least one line every time
	LDA LINCNT
	CMP LINES	;now do we have enough lines?
	BCS CNTDWN	;maybe, let's see
	TXA		;see if at beginning of buffer
	BEQ RDSPDN	;we were at bob, quit
	BNE RDSPT2	;we weren't, go fer more
CNTDWN: LDA LINCNT
	CMP LINES
	BEQ RDSPDN	;yep, done
	DEC LINCNT	;too many, count down
	LDA EPOINT
	CLC
	ADC #$27
	STA EPOINT
	BCC CNTDWN
	INC EPOINT+1
	JMP CNTDWN

RDSPDN:	JSR TOPSCR
	MOV SFSTCH, EPOINT
	JMP EDPBUF

;redisplay screen around point. Sets CV, CH, BASLIN,
;first-char-on-screen, char-after-last-char-on-screen.
CENTER:	LDA #$0C	;#$0C = 12.
	JMP RDSPNT	;redisplay for point on 13th line

;NXTSCR moves to the next screenful in the buffer and displays it,
;setting point to the character after the last char on the previous
;screenful (thus it will be at top of screen).
ECMPLN:	JMP BELL
NXTSCR:	LDA EPOINT+1
	CMP ENDBUF+1
	BNE NXTSC1
	LDA EPOINT
	CMP ENDBUF
	BEQ ECMPLN	;complain if at end of buffer
NXTSC1: LDA SLSTCH
	CMP ENDBUF
	BNE NXTSC2	;move to eob if on last screen
	LDA SLSTCH+1
	CMP ENDBUF+1
	BNE NXTSC2
	MOV EPNT1,SLSTCH
	JMP EDPBUF	;EDPBUF will recover EPNT1 as point.
NXTSC2:	LDY #$00
	LDA (SLSTCH),Y
	CMP #$0D	;CR
	BNE NXTSC3	;don't bother me, I know what I'm doing.
	INC SLSTCH	;See the "boys and girls" comment in EDSPBF.
	BNE NXTSC3
	INC SLSTCH+1
NXTSC3:	LDA SLSTCH
	STA EPOINT	;point
	STA SFSTCH	;first char on screen
	LDA SLSTCH+1
	STA EPOINT+1
	STA SFSTCH+1
	JSR TOPSCR
	JMP EDSPBF	;display

;PRVSCR moves to the previous screenful in the buffer, leaves point at
;the top.

PRVSCR:	LDA EPOINT
	CMP #EDBUF&$FF
	BNE PRVSC1
	LDA EPOINT+1
	CMP #EDBUF^
	BNE PRVSC1
	JMP BELL
PRVSC1:	LDA SFSTCH
	CMP #EDBUF&$FF	;move to buffer beginning if no previous screen
	BNE PRVSC2
	LDA SFSTCH+1
	CMP #EDBUF^
	BNE PRVSC2
	JSR PNTBEG
	JSR TOPSCR
	JMP EDSPBF
PRVSC2:	MOV EPOINT,SFSTCH	;make point be beginning of screen
	LDA #$17	;redisplay 23 lines before it
	JSR RDSPNT
	MOV EPOINT,SFSTCH	;make point be beginning of screen
	JMP TOPSCR	;cursor at top of screen

;RUBOUT deletes char behind cursor, redisplays.
RUBOUT:	LDA EPOINT+1
	CMP #EDBUF^
	BCC RCMPLN	;are we before or at beginning...
	BNE RUBOT2
	LDA #EDBUF&$FF	;I know the switch is unorthodox, sorry
	CMP EPOINT
	BCS RCMPLN
RUBOT2:	JSR BCKCHR
	JMP DELET2
RCMPLN:	JMP BELL	;complain if so.

;DELETE deletes char under cursor, redisplays.
DELETE:	LDA ENDBUF+1
	CMP EPOINT+1
	BCC RCMPLN	;if at buffer end, complain
	BNE DELET2
	LDA EPOINT
	CMP ENDBUF
	BCS RCMPLN
DELET2:	LDA #$01	;only moving stuff up one place
	STA CHCNT1
	LDA #$00
	STA LINES
DELET3:	LDA #CHCNT1
	JSR MOVEUP
	JMP EDSPBF

;	Local variable block:
EPNT2	=TEMPX3		;Alt. EPOINT

;MOVEUP takes the location of an arg in AC,Y and moves the argth char
;after the point into the point, the arg+1th into the point+1, and so
;on until the buffer end is reached. Then it sets the end of buffer
;pointer to the point before restoring it. Better make plenty damned
;sure that MOUEUP is used carefully so that end-of-buffer-pointer
;doesn't become too small.
MOVEUP:	TAX
	LDA EPOINT	;we are saving point to restore it later
	PHA
	STA EPNT2	;in EPNT2 for source
	LDA EPOINT+1
	PHA
	STA EPNT2+1
	LDA $00,X
	CLC
	ADC EPNT2	;and add to point for source address
	STA EPNT2
	LDA $01,X
	ADC EPNT2+1
	STA EPNT2+1
MVULOP:	LDA EPNT2+1
	CMP ENDBUF+1	;are we looking at end-of-buffer...
	BCC MVULP2	;no, continue
	BNE MVURTS	;past, return
	LDA EPNT2
	CMP ENDBUF
	BCS MVURTS	;past or end, return
MVULP2:	LDY #$00
	LDA (EPNT2),Y	;source
	STA (EPOINT),Y	;dest
	JSR INCPNT	;inc dest
	INC EPNT2	;inc source
	BNE MVULOP
	INC EPNT2+1
	JMP MVULOP
MVURTS:	MOV ENDBUF,EPOINT	;new end-of-buffer
	PLA
	STA EPOINT+1
	PLA
	STA EPOINT	;recover point
	RTS		;that's all, folks

;	Local variable block:
SLSTC1	=A3L		;Alt. SLSTCH

;FORCHR moves forward one character, bells if at end of buffer.
FORCHR: LDA EPOINT+1
	CMP ENDBUF+1
	BCC FORCH2	;if at buffer end complain
	BNE FCMPLN
	LDA EPOINT
	CMP ENDBUF
	BCS FCMPLN
FORCH2:	LDA SLSTCH	;!!**CROCK**!! THIS CAUSES REDISPLAY WHEN
	SEC		;YOU TRY FORWARD ON NEXT TO LAST CHAR IN
	SBC #$01	;BUFFER!!! SHOULD CHECK CV,CH OR (EPOINT).
	STA SLSTC1		;see if on last char on screen
	LDA SLSTCH+1
	SBC #$00
	STA SLSTC1+1
	CMP EPOINT+1
	BNE FORCH3
	LDA SLSTC1
	CMP EPOINT
	BNE FORCH3
	JSR INCPNT	;yes, inc point and center
	JMP CENTER
FCMPLN:	JMP BELL
FORCH3:	LDY #$00
	LDA (EPOINT),Y
	CMP #$0D
	BNE FORCH5
FORCH4:	STY CH		;if on a CR, we know we're not at end of
	INC CV		;screen by now, so zero CH, inc CV.
	JSR BCALC	;must calc new baseline
	JMP INCPNT
FORCH5:	LDA CH
	CMP #$26	;at right before "!"
	BEQ FORCH4
	INC CH
	JMP INCPNT
.PAGE
;BCKCHR backs CH and CV up, decs point. No redisplay, unless page
;boundary crossed, or previous char is a CR. Don't call it unless the
;database is consistent; i.e., CV and CH are at the point on the
;screen.
BCKCHR:	LDA #EDBUF^	;check if at beginning of buffer
	CMP EPOINT+1
	BCC BACK2	;no, win
	BNE FCMPLN	;yes, complain, quit
	LDA #EDBUF&$FF
	CMP EPOINT
	BCS FCMPLN
BACK2:	JSR DECPNT
	LDA CV		;see if we're at beginning of screen
	BNE BACK3
	LDA CH
	BNE BACK3
	JMP CENTER	;center
BACK3:	LDA CH
	BNE BACK5
	LDY #$00
	LDA (EPOINT),Y
	CMP #$0D	;#$0D = CR
	BNE BACK4
	MOV EPNT1,EPOINT	;when we back over a cr we call
	MOV EPOINT,SFSTCH	;EDPBUF so as to save space (by
	JSR TOPSCR		;not having code here to count down a line)
	JMP EDPBUF		;don't need redisplay, space bum
BACK4:	DEC CV
	LDA #$26	;just before the "!"
	STA CH
	JSR BCALC
	RTS
BACK5:	DEC CH
	RTS
.PAGE
;algorithm for previous line: search back for a CR, counting chars. if
;you hit bob, complain. got it? save its addr, as well as offset.
;search back for another one, or bob. add last offset to this addr. gt
;than other addr? good, make other addr current. if not, make this
;addr current. redisplay point to turn on cursor, or RDSPNT if off
;screen.

PRVLIN:	LDY #$00
	STY CHCNT2
	STY CHCNT2+1	;A2 is char counter.
	MOV EPNT1,EPOINT
	JSR SRCHBK
	CMP #$0D
	BNE PCMPLN	;PCMPLN recovers point from A4 and complains
	MOV NARG2,CHCNT2	;saving offset into line in NARG2
	MOV NARG2+2,EPOINT	;saving beginning of line in NARG2+2
	JSR DECPNT	;do a DECPNT to get on previous line
	JSR SRCHBK
	LDA EPOINT
	CLC
	ADC NARG2
	STA NARG2
	LDA EPOINT+1
	ADC NARG2+1	;have beginning of prev line + offset of
	STA NARG2+1	;this'n in NARG2
	CMP NARG2+3	;compare to beginning of this line
	BCC PRVLN2	;strictly less than, use NARG2
	BNE PRVLN3	;gt or =, use NARG2+2-1
	LDA NARG2
	CMP NARG2+2
	BCC PRVLN2	;less, use NARG2
PRVLN3:	LDA NARG2+2
	SEC
	SBC #$01
	STA EPNT1
	LDA NARG2+3
	SBC #$00
	STA EPNT1+1	;for recovery by EDPBUF
	JMP PVRDSP
PRVLN2:	MOV EPNT1,NARG2
PVRDSP:	LDA EPNT1+1
	CMP SFSTCH+1	;before first char on screen?
	BCC PRDSPT	;yo, RDSPNT
	BNE PVRDS2	;no, normal
	LDA EPNT1
	CMP SFSTCH
	BCC PRDSPT
PVRDS2:	JSR TOPSCR
	MOV EPOINT,SFSTCH
	JMP EDPBUF
PRDSPT:	MOV EPOINT,EPNT1
	JMP CENTER
PCMPLN:	MOV EPOINT,EPNT1
	JMP BELL

;SRCHBK returns with a CR in AC if found CR; with 0 in AC if found
;bob. Incs CHCNT2 as it goes so it can be used as a counter.
;does right thing (this is a kludge) if on a CR initially - ignores
;it, but counts it.

SRCHBK:	LDY #$00
SRCBK1:	LDA EPOINT
	CMP #EDBUF&$FF
	BNE SRCBK2
	LDA EPOINT+1
	CMP #EDBUF^
	BEQ SRCBK4
SRCBK2:	JSR DECPNT
	INC CHCNT2
	BNE SRCBK3
	INC CHCNT2+1
SRCBK3:	LDA (EPOINT),Y
	CMP #$0D	;got a CR?
	BEQ SRCBK5	;y, done
	LDA EPOINT
	CMP #EDBUF&$FF	;at bob?
	BNE SRCBK2	;no, loop
	LDA EPOINT+1
	CMP #EDBUF^
	BNE SRCBK2
SRCBK4:	TYA		;y, done
	RTS
SRCBK5:	JSR INCPNT
	LDA CHCNT2
	SEC
	SBC #$01
	STA CHCNT2
	LDA CHCNT2+1
	SBC #$00
	STA CHCNT2+1
	LDA #$0D
	RTS
.PAGE
;	Local variable block:
OFFSET	=TEMPN8		;Offset from beginning of current line
ENDLIN	=TEMPN7		;End of next line

;algorithm for NXTLIN is as follows: get offset to beginning of your
;current line, and save in, say, OFFSET. try to find a CR, if you win,
;save it in NARG2. If you run into eob, complain. If you find a CR,
;try to find another or eob. Save the address of either in ENDLIN. Add
;NARG2 + 1 to OFFSET and save in OFFSET. If OFFSET is less than end of
;next line, i.e., ENDLIN, make point OFFSET, otherwise make point
;ENDLIN.

NXTLIN:	LDY #$00
	STY CHCNT2
	STY CHCNT2+1		;zero char counter
	MOV EPNT1,EPOINT	;for recovery in the event of disaster
	JSR SRCHBK		;get offset to beginning of this line in A2
	MOV OFFSET,CHCNT2	;save
	JSR SRCHFD		;try to find a CR
	CMP #$0D
	BNE NCMPLN		;complain if none
	MOV NARG2,EPOINT	;save location of end of current line
	JSR INCPNT		;inc point to get onto beginning of next line
	JSR SRCHFD
	MOV ENDLIN,EPOINT
	LDA NARG2
	CLC
	ADC #$01
	STA NARG2	;get beginning of next line in NARG2
	LDA NARG2+1
	ADC #$00
	STA NARG2+1
	LDA NARG2
	CLC
	ADC OFFSET	;add offset to beginning of next line
	STA OFFSET
	LDA NARG2+1
	ADC OFFSET+1
	STA OFFSET+1
	CMP ENDLIN+1	;is beginning of next line + offset <
	BCC NXTLN2	;end of next line? y, use first
	BNE NXTLN3	;n, use end of next
	LDA OFFSET
	CMP ENDLIN
	BCC NXTLN2
NXTLN3:	MOV EPNT1,ENDLIN
	JMP NXRDSP
NXTLN2:	MOV EPNT1,OFFSET
NXRDSP:	LDA EPNT1+1
	CMP SLSTCH+1	;this makes redisplay occur sometimes when it
	BCC NXRDS2	;doesn't have to. too bad. vanilla if on screen.
	BNE NRDSPT	;else redisplay
	LDA EPNT1
	CMP SLSTCH
	BCS NRDSPT
NXRDS2:	JSR TOPSCR
	MOV EPOINT,SFSTCH
	JMP EDPBUF
NRDSPT:	MOV EPOINT,EPNT1
	JMP CENTER
NCMPLN:	MOV EPOINT,EPNT1
	JMP BELL

;SRCHFD returns with a CR in AC if found CR; with 0 in AC if found
;eob.

SRCHFD:	LDY #$00
SRCHF1:	LDA EPOINT
	CMP ENDBUF
	BNE SRCHF2
	LDA EPOINT+1
	CMP ENDBUF+1
	BEQ SRCHF3
SRCHF2:	LDA (EPOINT),Y
	CMP #$0D
	BEQ SRCHF4	;found a CR, return
	JSR INCPNT
	JMP SRCHF1
SRCHF3:	TYA
	RTS
SRCHF4:	RTS
.PAGE
;EOLLIN moves point to end of current line, or to end of buffer.
EOLLIN:	LDY #$00
	LDA (EPOINT),Y
	CMP #$0D	;if on a cr, do nothing
	BEQ EOLRTS
	LDA EPOINT
	CMP ENDBUF
	BNE EOLLN2
	LDA EPOINT+1
	CMP ENDBUF+1	;if at end-of-buffer, do nothing.
	BEQ EOLRTS
EOLLN2:	JSR SRCHFD	;otherwise, move point forward to a CR or eob.
	MOV EPNT1, EPOINT
	JMP NXRDSP	;redisplay as from next line
EOLRTS:	RTS
.PAGE
;BEGLIN moves point to beginning of current line, or to beginning of
;buffer.
BEGLIN:	LDA EPOINT
	CMP #EDBUF&$FF
	BNE BEGLN2
	LDA EPOINT+1
	CMP EDBUF^	;if at beginning of buffer
	BEQ EOLRTS	;do nothing
BEGLN2:	MOV EPNT1,EPOINT
	LDA EPNT1
	SEC
	SBC #$01
	STA EPNT1
	LDA EPNT1+1
	SBC #$00
	STA EPNT1+1
	LDY #$00
	LDA (EPNT1),Y
	CMP #$0D	;if on a cr
	BEQ EOLRTS	;do nothing
	JSR SRCHBK	;OTW, find beginning of line or buffer
	MOV EPNT1,EPOINT	;and redisplay as from previous line.
	JMP PVRDSP
.PAGE
;KILLIN deletes all the characters from the point to the end of the
;line. If the point is already at the end of the line, it deletes the
;CR; if the point is already at the end of the buffer, it complains.
KILLIN: LDA EPOINT
	CMP ENDBUF
	BNE KILLN2
	LDA EPOINT+1
	CMP ENDBUF+1	;if at end of buffer, complain
	BEQ KCMPLN
KILLN2:	LDY #$00
	LDA (EPOINT),Y
	CMP #$0D	;if on a cr, delete it
	BNE KILLN3
	JMP DELETE
KILLN3:	MOV EPNT1,EPOINT	;save point
	JSR SRCHFD
	LDA EPOINT
	SEC
	SBC EPNT1	;figger out how many chars to delete
	STA CHCNT1
	LDA EPOINT+1
	SBC EPNT1+1
	STA LINES
	MOV EPOINT,EPNT1
	JMP DELET3	;save three bytes -- return as from delete
KCMPLN: JMP BELL
.PAGE
;OPLINE inserts a CR at point w/o inc'ing point.
OPLINE:	LDA EPOINT+1
	CMP #EBFEND^
	BCC OPLIN1
	BNE OPLRTS
	LDA EPOINT
	CMP #EBFEND&$FF	;Are we at end of edit buffer...
	BCS OPLRTS	;if so, quit
OPLIN1:	JSR MVDOWN
	LDY #$00
	LDA #$0D
	STA (EPOINT),Y	;insert CR at point
	JMP EDSPBF	;redisplay from here down.
OPLRTS:	RTS
.PAGE
.SBTTL	Primitives
.SBTTL		Arithmetic Primitives

SUNSUM:	MOV CURTOK,INFSUM	;(For possible error message in GT1NUM)
	JSR GT1NUM
	BCS SNSM1
	JMP OTPFX1

SUNDIF:	MOV CURTOK,INFDIF	;(For possible error message in GT1NUM)
	JSR GT1NUM
	BCS SNDIF2
	LDX #NARG1
	JSR COMPL
RESOK:	JMP OTPFX1
SNDIF2:	JSR FCOMPL	;Complements flonum in NARG1.
SNSM1:	JMP OTPFL1

;	Local variable block:
SIGN1	=TEMPN1		;Sign of NARG1

SSUM:	JSR GT2NUM
	BCS SSUMF
	JSR SAVNGS
	LDA NARG1+3
	STA SIGN1
	CLC
	LDX #$FC
SSMLP1:	LDA NARG1+4,X
	ADC NARG2+4,X
	STA NARG1+4,X
	INX
	BMI SSMLP1
	LDA NARG2+3
	EOR SIGN1
	BMI RESOK	;Different signs, never an overflow
	LDA NARG1+3
	EOR NARG2+3
	BPL RESOK	;Overflow if result not same sign as one argument
	JSR CONV
SSUMF:	JSR FADD	;Floating pt. addition
	BCS ERXOVF
	JMP OTPFL1
ERXOVF:	ERROR XOFL

;	Local variable block:
SIGN1	=TEMPN1		;Sign of NARG1

SDIF:	JSR GT2NUM
	BCS SDIFF
	JSR SAVNGS
	LDA NARG1+3
	STA SIGN1
	SEC
	LDX #$FC
SDIFL1:	LDA NARG1+4,X
	SBC NARG2+4,X
	STA NARG1+4,X
	INX
	BMI SDIFL1
	LDA SIGN1
	EOR NARG2+3
	BPL RESOK	;Same signs, never an overflow
	LDA NARG1+3
	EOR SIGN1
	BPL RESOK
	JSR CONV
SDIFF:	JSR FSUB	;Floating pt. subtraction
	BCS ERXOVF
	JMP OTPFL1

;	Local variable block:
SIGN1	=TEMPN1		;Sign of NARG1
PRODCT	=TEMPN		;Partial product (shared: IMULT,MOD360,SPROD,SRANDM)

SPROD:	JSR GT2NUM
	BCS SPRODF
	JSR SAVNGS
	JSR IMULT	;Returns with carry set if overflow
	BCS SPRODR
	LDY #PRODCT
	JMP OTPFIX
SPRODR:	JSR CONV
SPRODF:	JSR FMUL	;Floating pt. multiply
	BCS ERXOVF
	JMP OTPFL1

SDIVID:	JSR GT2NUM
	BCS SDIVF
	JSR FLOTN1
	JSR FLOTN2
SDIVF:	LDA NARG2
	BEQ SDIVR1
	JSR FDIV	;Floating pt. divide
	BCS SDIVR
	JMP OTPFL1
SDIVR:	ERROR XOFL
SDIVR1:	ERROR XDBZ

SQTENT:	JSR GT2NUM
	BCC SQTNT1
	JSR RNDN1
	JSR RNDN2
SQTNT1:	JSR IDIVID
	JMP OTPFX1

SRMNDR:	JSR GT2NUM
	BCC SRMND1
	JSR RNDN1
	JSR RNDN2
SRMND1:	JSR IDIVID
	LDY #NARG2
	JMP OTPFIX

SINT:	JSR GT1NUM
	BCC SINT1
	JSR INTN1
SINT1:	JMP OTPFX1

SROUND:	JSR GT1NUM
	BCC SRND1
	JSR RNDN1
SRND1:	JMP OTPFX1

;	Local variable block:
SAVNG1	=A1L		;NARG1 save
SAVNG2	=A3L		;NARG2 save

SAVNGS:	LDY #SAVNG1	;Save NARG1 and NARG2 in case of overflow
	JSR XN1TOY
	LDY #SAVNG2
	JMP XN2TOY

CONV:	LDY #SAVNG1
	JSR XYTON1	;Overflow, get NARG1 and NARG2 back
	LDY #SAVNG2
	JSR XYTON2
	JSR FLOTN1	;Convert both to floating pt.
	JMP FLOTN2
.PAGE
;	Local variable block:
SGNX	=ANSN1		;X-Incr. sign (shared: SSIN,GETSIN,SFDX)
FRACT	=TEMPN7		;Interpolation fraction (shared: SSIN,SCOS,GETSIN,SFDX)
LOWENT	=TEMPN5		;Low table entry (shared: SSIN,MULCOS,SFDX)

SSIN:	JSR GT1FLT
	JSR GETSIN
	LDA NARG1
	JSR MULSIN
	LDY #FRACT
	JSR XYTON2	;Restore interpolation fraction
	JSR FMUL	;Get interpolation correction
	LDY #LOWENT
	JSR XYTON2	;Get uncorrected table value...
	JSR FADD	;and correct it!
	LDA SGNX	;X-Incr. sign
	BEQ SSIN2
	JSR FCOMPL
SSIN2:	JMP OTPFL1

;	Local variable block:
SGNY	=ANSN2		;Y-Incr. sign (shared: SCOS,GETSIN,SFDX)
FRACT	=TEMPN7		;Interpolation fraction (shared: SSIN,SCOS,GETSIN,SFDX)
HIENT	=TEMPN3		;High table entry (shared: SCOS,MULCOS,SFDX)

SCOS:	JSR GT1FLT
	JSR GETSIN
	LDA NARG1
	JSR MULCOS
	LDY #FRACT
	JSR XYTON2	;Restore interpolation fraction
	JSR FMUL	;Get interpolation correction
	LDY #HIENT
	JSR XYTON2	;Get uncorrected table value...
	JSR FSUBX	;and correct it! Note that we subtract because we are
			;reading table backwards for cosine
	LDA SGNY	;Y-Incr. sign
	BEQ SCOS2
	JSR FCOMPL
SCOS2:	JMP OTPFL1
.PAGE
;	Local variable block:
SGNX	=ANSN1		;X-Incr. sign (shared: SSIN,GETSIN,SFDX)
SGNY	=ANSN2		;Y-Incr. sign (shared: SCOS,GETSIN,SFDX)
FRACT	=TEMPN7		;Interpolation fraction (shared: SSIN,SCOS,GETSIN,SFDX)
SAVNG1	=TEMPN5		;NARG1 save

GETSIN:	JSR MOD360	;Convert NARG1 to 0-360
	LDY #NARG1
	JSR XYTON2	;Get NARG1 in NARG2
GETSN1:	LDA #$00
	STA SGNX
	STA SGNY
	LDY #SAVNG1	;Save NARG1 through subtract
	JSR XN1TOY
	JSR INTN1	;Make it integer... (don't round!)
	JSR FLOTN1	;then floating again, zapping fraction bits
	JSR FSUBX	;which remain after subtract
	LDY #FRACT
	JSR XN1TOY	;Save fraction for interpolating
	LDY #SAVNG1
	JSR XYTON1	;Get heading back for munching
	LDA NARG1
	CMP #$87
	BCC HDPOS
	BNE HDNPOS
	LDA NARG1+1
	CMP #$5A
	BCC HDPOS
	BNE HDNPOS
	LDA NARG1+2
	BNE HDNPOS
	LDA NARG1+3
	BEQ HDPOS
HDNPOS:	SETNUM NARG2,F360	;Subtract from 360.
	JSR FSUBX
	INC SGNX	;Sign of X incr.
HDPOS:	LDA NARG1	;See if it's > 90.
	CMP #$86
	BCC HDYPOS
	BNE HDYNEG
	LDA NARG1+1
	CMP #$5A
	BCC HDYPOS
	BNE HDYNEG
	LDA NARG1+2
	BNE HDYNEG
	LDA NARG1+3
	BEQ HDYPOS
HDYNEG:	SETNUM NARG2,F180
	JSR FSUBX	;Subtract from 180. if > 90.
	INC SGNY
HDYPOS:	JMP INTN1	;Make Heading integer (don't round)
.PAGE
;This gets y := arctan(x):
;	x1 := a9
;	x2 := x*x
;	do for x3 := a7,a5,a3,a1
;		x1 := x2 * x1 + x3
;	y := x * x1
;Where	a1 =  .9998660
;	a3 = -.3302995
;	a5 =  .1801410
;	a7 = -.0851330
;	a9 =  .0208351

	;Local variable block:
EX2	=TEMPN4
SAVN2	=TEMPN6
SGNDX	=TEMPN8
SGNDY	=TEMPN8+1
COUNT	=ANSN2
KINDEX	=ANSN3

STWRDS:	JSR GT2NUM	;Get A and B
	BCS STWRD1
	JSR FLOTN1
	JSR FLOTN2
STWRD1:	LDY #EX2
	JSR XN1TOY	;Save NARG1
	LDY #YCOR
	JSR XYTON1	;Get YCOR in NARG1
	JSR FSUBX	;Get B-YCOR
	LDA NARG1+1
	STA SGNDY
	BPL STWRD2
	JSR FCOMPL
STWRD2:	LDY #SAVN2
	JSR XN1TOY	;Save B-YCOR
	LDY #EX2
	JSR XYTON1	;Get A back
	LDY #XCOR
	JSR XYTON2	;Get XCOR in NARG2
	JSR FSUB	;Get A-XCOR
	LDA NARG1+1
	STA SGNDX
	BPL STWRD3
	JSR FCOMPL
STWRD3:	LDY #SAVN2
	JSR XYTON2	;Get B-YCOR back
	JSR TWRD1
	LDA SGNDY
	BPL STWRD4
	SETNUM NARG2,F180
	JSR FSUBX	;Get 180-ANG
STWRD4:	LDA SGNDX
	BPL STWRD5
	SETNUM NARG2,F360
	JSR FSUBX	;Get 360-ANG
STWRD5:	JMP OTPFL1

TWRD1:	LDX #$03	;DX is NARG1
TWRDL1:	LDA NARG1,X             ;See if DX is 0
	BNE TWRD2
	DEX
	BPL TWRDL1
	RTS		;DX = 0, return with 0
TWRD2:	LDX #$03
TWRDL2:	LDA NARG2,X	;DY is NARG2
	BNE TWRD3	;See if DY is 0
	DEX
	BPL TWRDL2
	SETNUM NARG1,F90	;DY = 0, output 90.
	RTS
TWRD3:	JSR FDIV	;Get DX/DY
	JSR ATNEXP	;Get ATNEXP (DX/DY)
	SETNUM NARG2,KRDEG	;Get 180/PI in NARG2
	JMP FMUL	;Return with ATNEXP(DX/DY)*57.3
ATNEXP:	LDA NARG1	;Complete expansion.
	CMP #$80	;See if X > 1.0
	BCC ATNXP1	;X < 1.0
	BNE ATAN1	;X > 1.0
	LDA NARG1+1
	CMP #$40
	BCC ATNXP1
	BNE ATAN1
	LDA NARG1+2
	BNE ATAN1
	LDA NARG1+3
	BEQ ATNXP1
ATAN1:	LDA #$40	;X > 1.0
	STA NARG2+1	;Put 1.0 in NARG2
	ASL A
	STA NARG2
	ASL A
	STA NARG2+2
	STA NARG2+3
	JSR FDIVX	;Get 1./X
	JSR ATNXP1	;Get ATNEXP (1./X)
	SETNUM NARG2,KHLFPI	;Get PI/2 in NARG2
	JMP FSUBX	;Get PI/2. - ATNEXP (1./X)
ATNXP1:	SETNUM NARGX,NARG1	;The raw expansion. Save X.
	LDY #NARG2
	JSR XN1TOY		;Put in NARG2
	JSR FMUL		;and get X^2
	LDY #EX2
	JSR XN1TOY		;X2 := X*X
	SETNUM NARG1,KA9	;X1 := A9
	LDA #$04
	STA COUNT		;Four iterations
	LDA #$00
	STA KINDEX		;Constant index (A7,A5,A3,A1)
ATANL:	LDY #EX2
	JSR XYTON2
	JSR FMUL		;X1 := X2 * X1
	LDY KINDEX
	LDX #$FC
ATANL1:	LDA KATANS,Y
	STA NARG2+4,X
	INC KINDEX
	INY
	INX
	BMI ATANL1		;NARG2 := A (A7,A5,A3,A1)
	JSR FADD		;X1 := X1 + A
	DEC COUNT
	BNE ATANL		;Four expansions
	SETNUM NARG2,NARGX	;Get X back
	JMP FMUL		;Y := X1 * X

KRDEG:	$85	; 180/PI = 57.2957799
	$72
	$97
	$71

F90:	$86	; 90.0
	$5A
	$00
	$00

KHLFPI:	$80	; PI/2 = 1.57079632
	$64
	$87
	$ED

KA9:	$7A	; 0.0208351
	$55
	$57
	$30

KATANS	=.
KA7:	$7C	; -0.0851330
	$A8
	$D2
	$E5

KA5:	$7D	; 0.1801410
	$5C
	$3B
	$71

KA3:	$7E	; -0.3302995
	$AB
	$71
	$7E

KA1:	$7F	;0.9998660
	$7F
	$FB
	$9C
.PAGE
.SBTTL		Boolean Primitives

SGRTR:	JSR GT2NUM
SGRTRX:	BCS SGRTRF
	LDA NARG1+3
	BMI SGRTRM
	LDA NARG2+3
	BMI JTRU	;POS > NEG
SGRTRP:	LDX #$03
SGRLP1:	LDA NARG2,X
	CMP NARG1,X
	BCC JTRU
	BNE JFLS
	DEX
	BPL SGRLP1
JFLS:	JMP VPLFLS
SGRTRM:	LDA NARG2+3
	BPL JFLS	;NEG not > POS
	AND #$7F	;Both negative, strip sign bit and compare
	STA NARG2+3
	LDA NARG1+3
	AND #$7F
	STA NARG1+3
	JMP SGRTRP
JTRU:	JMP VPLTRU
SGRTRF:	LDA NARG1+1
	BMI SGRTFM
	LDA NARG2+1
	BMI JTRU	;POS > NEG
	BPL SGRTF1
SGRTFM:	LDA NARG2+1
	BPL JFLS	;NEG not > POS
SGRTF1:	JSR FSUBX	;Both same sign - subtract NARG1 from NARG2
	LDA NARG1+1	;If NARG1 negative, then it was larger
	BMI JTRU
	BPL JFLS

SLESS:	JSR GT2NUM
	JSR SWAP	;Switch the args and call SGREATER
	JMP SGRTRX
.PAGE
;	Local variable block:
ANSWER	=TEMPX2		;Equality result (TRUE or FALSE)
SPPTR	=TEMPN8		;Original SP to restore
TYPE1	=ANSN4		;Type of ARG1
TYPE2	=ANSN		;Type of ARG2

SEQUAL:	MOV ANSWER,LTRUE
	VPOP ARG2
	VPOP ARG1
	INC OTPUTN
	MOV SPPTR,SP
	PUSHA SEQEND
EQ:	GETTYP ARG2
	STA TYPE2
	GETTYP ARG1
	STA TYPE1
	CMP #LIST
	BEQ EQL
	CMP #FIX
	BEQ EQF
	CMP #FLO
	BEQ EQF
	CMP #ATOM
	BEQ EQA
	CMP #STRING
	BNE EQO
	JMP EQSTR
EQO:	LDA TYPE1	;Loses if not same type
	CMP TYPE2
	BNE EQFF
EQO1:	LDA ARG1	;Loses if not same pointer
	CMP ARG2
	BNE EQFF
	LDA ARG1+1
	CMP ARG2+1
	BEQ EQPOP
EQFF:	MOV ANSWER,LFALSE	;We lost
	JMP SEQEND
EQPOP:	JMP POPJ	;We won this round
EQL:	LDA TYPE2	;ARG1 is a list
	CMP #LIST
	BNE EQFF	;Lose if ARG2 not a list
	JMP EQLIST	;Compare the lists
EQF:	LDX #ARG1	;ARG1 is a number
	JSR LODNUM	;Get arg1 into NARG1
	JSR GTNM2X	;Get arg2 into NARG2 (without bashing NARG1)
	BCC EQFF	;Not a number, lose
EQFC:	CMP TYPE1	;(Here we have two numbers) See if NARG1 same type...
	BEQ EQF1	;Yes, compare them
	CMP #FLO	;Not same type: If NARG2 is Flonum,
	BEQ EQF2	;then branch
	JSR FLOTN2	;Else NARG2 is Fixnum, convert to flt. pt.
	JMP EQF1	;and compare (NARG1 is a flonum)
EQF2:	JSR FLOTN1	;Convert NARG1 to floating pt. (NARG2 is a flonum)
EQF1:	LDX #$03	;Compares two numbers of same type
EQFLP:	LDA NARG1,X
	CMP NARG2,X
	BNE EQFF
	DEX
	BPL EQFLP
	JMP POPJ
EQA:	LDA TYPE2	;ARG1 is an atom, look at ARG2
	CMP #STRING
	BNE EQA2
	JMP EQSTRX	;String, so compare with atom
EQA2:	CMP #FIX
	BEQ EQA1
	CMP #FLO
	BNE EQO		;ARG2 not a fixnum or flonum, must be the same atom then
EQA1:	LDA TYPE2
	PHA
	LDA NARG2	;Save NARG2 pointer through GTNUM1
	PHA
	LDA NARG2+1
	PHA
	JSR GTNUM1	;ARG1 is an atom, ARG2 is a number: Get arg1 into NARG1 if you can
	BCC EQFF	;Can't, so lose
	STA TYPE1
	PLA
	STA NARG2+1
	PLA
	STA NARG2
	LDX #NARG2
	JSR LODNUM	;Get number arg2 into NARG2
	PLA		;Have two numbers in NARG1, NARG2, do CMP of types for branch at EQFC
	JMP EQFC
EL1:	POP ARG2
	POP ARG1
	CDRME ARG1
	CDRME ARG2
EQLIST:	LDA ARG1+1
	BNE EQLST1
	LDA ARG2+1
	BNE EQFFJ
	JMP POPJ
EQLST1:	LDA ARG2+1
	BEQ EQFFJ
	PUSH ARG1
	PUSH ARG2
	CARME ARG1
	CARME ARG2
	JSR TSTPOL
	PUSHA EL1
	JMP EQ
SEQEND:	VPUSH ANSWER
	MOV SP,SPPTR
	JMP POPJ
EQFFJ:	JMP EQFF

;	Local variable block:
PNAME	=TEMPN6		;Pname pointer

EQSTRX:	LDX #ARG1	;ARG1 is an Atom, ARG2 is the String
	LDY #PNAME
	JSR MAKPNM
	MOV ARG1,PNAME
	JMP CMPSTR
EQSTR:	LDA TYPE2	;ARG1 is a String, see what ARG2 is
	CMP #STRING
	BEQ CMPSTR	;A String, so compare them
	CMP #LIST
	BEQ EQFFJ	;A List, we lose
	LDA ARG1
	PHA		;Save ARG1 through MAKE_PNAME
	LDA ARG1+1
	PHA
	LDX #ARG2
	LDY #PNAME
	JSR MAKPNM	;Otherwise, get its Pname
	MOV ARG2,PNAME
	PLA		;Retrieve ARG1
	STA ARG1+1
	PLA
	STA ARG1
CMPSTR:	LDY #$00
	LDA (ARG1),Y
	CMP (ARG2),Y
	BNE EQFFJ	;Lose if first bytes not equal
	TAX
	BEQ EQPOPJ	;Win if both zero (done)
	INY
	LDA (ARG1),Y
	CMP (ARG2),Y
	BNE EQFFJ	;Lose if second bytes not equal
	TAX
	BEQ EQPOPJ	;Win if both zero (done)
	INY
	LDA (ARG1),Y
	TAX
	INY
	LDA (ARG1),Y
	STA ARG1+1
	BNE CMPS1
	LDA (ARG2),Y
	BEQ EQPOPJ	;Win if both CDRs zero (done)
	BNE EQFFJ	;(Always) Else lose if only one is (ARG1's)
CMPS1:	STX ARG1
	LDA (ARG2),Y
	BEQ EQFFJ	;Lose if only one is (ARG2's)
	TAX
	DEY
	LDA (ARG2),Y
	STA ARG2
	STX ARG2+1
	JMP CMPSTR
EQPOPJ:	JMP EQPOP
.PAGE
SNOT:	VPOP ARG1
	JSR GTBOOL
	TYA
	BNE VPLTRU
	JMP VPLFLS

;	Local variable block:
ANSWER	=ANSN4		;Boolean answer byte

SAND:	ASL NARGS
	LSR NARGS
	BEQ SBTHER	;need more inputs
	LDA #$00
	STA ANSWER
SBTHL:	VPOP ARG1
	JSR GTBOOL
	LDA ANSWER
	BNE SBTH2
	STY ANSWER
SBTH2:	DEC NARGS
	BNE SBTHL
	LDA ANSWER
	BEQ VPLTRU
	JMP VPLFLS
SBTHER:	ERROR XEOL

;	Local variable block:
ANSWER	=ANSN4		;Boolean answer byte

SOR:	ASL NARGS
	LSR NARGS
	BEQ SBTHER	;need more inputs
	LDA #$01
	STA ANSWER
SEITHL:	VPOP ARG1
	JSR GTBOOL
	LDA ANSWER
	BEQ SEITH2
	STY ANSWER
SEITH2:	DEC NARGS
	BNE SEITHL
	LDA ANSWER
	BNE VPLFLS
VPLTRU:	VPUSH LTRUE
	INC OTPUTN
	JMP POPJ

;	Local variable block:
NEWATM	=TEMPX1

STHNGP:	VPOP ARG2
	JSR GETTYP
	CMP #ATOM
	BEQ SPTH1
	CMP #SATOM
	BEQ SPTH1
	CMP #STRING
	BEQ SPTH4
SPTH2:	JMP VPLFLS
SPTH4:	LDY #NEWATM
	LDX #ARG2
	JSR INTERN
	LDY #NEWATM
	BNE SPTH1A	;(Always)
SPTH1:	LDY #ARG2
SPTH1A:	LDX #ARG1
	JSR GETVAL
	CMP #$01
	BEQ VPLFLS
SPTH3:	JMP VPLTRU

SWORDP:	VPOP ARG1
	JSR GETTYP
	CMP #LIST
	BNE SPTH3
VPLFLS:	VPUSH LFALSE
	INC OTPUTN
	JMP POPJ

SLISTP:	VPOP ARG1
	JSR GETTYP
	CMP #LIST
	BNE VPLFLS
	BEQ VPLTRU	;(Always)

SNMBRP:	VPOP ARG1
	JSR GETTYP
	CMP #FIX
	BEQ VPLTRU
	CMP #FLO
	BEQ VPLTRU
	CMP #LIST
	BEQ VPLFLS
	LDX #ARG1
	JSR ATMTNM
	BCS VPLTRU
	BCC VPLFLS	;(Always)

SCRCP:	LDA CHBUFR	;RC?
	CMP CHBUFS
	BEQ VPLFLS	;If CHBUFR=CHBUFS, then buffer empty
	JMP VPLTRU

SPDBTN:	JSR GT1FIX
	LDA #$03
	JSR SMLFX1	;check the thing in narg1.
	BCS SPDBNE
	LDX NARG1
	CPX #$03
	BCS SPDBNE
	LDA PADBTN,X
	BPL VPLFLS
	JMP VPLTRU
SPDBNE:	JMP GTERR1

.PAGE
.SBTTL		Word/List primitives:

;	Local variable block:
PNAME	=TEMPN6		;Pname ptr.
CHARS	=TEMPN5		;Characters

SFIRST:	LDX #ARG1
	JSR WRDLST
	BCC SFRST2
	LDA ARG1+1
	BEQ SDFNRR	;FIRST [] should giver error
	CARME ARG1
	JSR CHKARG	;Make sure we didn't produce a Q,D,Latom (fix it if so)
	JMP OTPRG1
SDFNRR:	JMP ERXWT1
SFRST2:	LDY #PNAME
	LDX #ARG1
	JSR MAKPNM
	LDY #$00
	LDA (PNAME),Y
	BEQ SDFNRR	;FIRST " will give error
	STA CHARS
	STY CHARS+1
	CONS ARG1,CHARS,0,STRING
	JMP OTPRG1

;	Local variable block:
CHARS	=TEMPN		;Characters

SLAST:	LDX #ARG2
	JSR WRDLST
	BCC SLST2
SLST1:	LDA ARG2+1
	BEQ SLSTR	;LAST [] will give error
	LDX #ARG2
	JSR GTLSTC
	CAR ARG1,ARG2
	JSR CHKARG	;Make sure we didn't produce a Q,D,Latom (fix it if so)
	JMP OTPRG1
SLSTR:	JMP ERXWT2
SLST2:	LDY #ARG1
	LDX #ARG2
	JSR MAKPNM
	LDY #$00
	LDA (ARG1),Y
	BEQ SLSTR
	LDX #ARG1
	JSR GTLSTC
	LDY #$01
	LDA (ARG1),Y
	BEQ SLST3
	STA CHARS
	LDA #$00
	STA CHARS+1
	CONS ARG1,CHARS,0,STRING
SLST3:	JMP OTPRG1

;	Local variable block:
NEWCEL	=TEMPN		;New cons cell for Latom colon
CHARS	=TEMPN1		;String characters

CHKARG:	GETTYP ARG1	;If ARG1 is a Q,D, or Latom, make it a string that looks like pname
	CMP #QATOM	;(ie, add a prefix colon or quotes, or a postfix colon)
	BEQ CQATOM
	CMP #DATOM
	BEQ CDATOM
	CMP #LATOM
	BNE CKRGR
	LDX #ARG1	;It's an Latom, append a colon to it
	LDY #ARG2
	JSR GETPNM	;Get pname
	LDY #ARG1
	LDA ARG2
	LDX ARG2+1
	JSR COPY	;Get a new pname copy
	MOV ARG2,ARG1	;Save pointer, ARG1 will be final product
	LDX #ARG2
	JSR GTLSTC
	LDY #$01
	LDA (ARG2),Y	;Look at last char in cell
	BNE CLATM1	;If nonzero, have to cons new cell
	LDA #':		;Else just add colon
	BNE CLATM2	;(Always)
CLATM1:	LDA #':
	STA CHARS
	LDA #$00
	STA CHARS+1
	CONS NEWCEL,CHARS,0,STRING
	LDY #$02
	LDA NEWCEL	;Link new cell on
	STA (ARG2),Y
	INY
	LDA NEWCEL+1
CLATM2:	STA (ARG2),Y
CKRGR:	RTS
CQATOM:	LDA #'"
	BNE CQDATM	;(Always)
CDATOM:	LDA #':
CQDATM:	PHA		;Save prefix character
	LDX #ARG1
	LDY #ARG2
	JSR GETPNM	;Get pname
	LDY #ARG1
	LDA ARG2
	LDX ARG2+1
	JSR COPY	;Make a copy of the pname
	MOV ARG2,ARG1	;Save pointer
	PLA
	STA CHARS
CQDLOP:	LDY #$01	;Loop pushes new character (in CHARS) into CAR,
	LDA (ARG2),Y
	STA CHARS+1	;Save second char.
	DEY
	LDA (ARG2),Y
	INY
	STA (ARG2),Y	;Put first char. in second char.
	LDA CHARS
	DEY
	STA (ARG2),Y	;Put new char in first char.
	LDA CHARS+1	;"new" char is last from this cell
	BEQ CKRGR	;If zero, done!
	STA CHARS
	CDRME ARG2
	BNE CQDLOP
CQDDN1:	LDA CHARS+1	;If last cell, make a new one with last char.
	STA CHARS
	LDA #$00
	STA CHARS+1
	CONS NEWCEL,CHARS,0,STRING	;New cell with last char. in it
	RPLACD ARG2,NEWCEL	;Link it on to the string.
	RTS
.PAGE
;	Local variable block:
OLDCAR	=TEMPN1
BEGPNM	=ANSN1		;Beginning of pname if zero
NEWNOD	=TEMPN2
NEWPTR	=TEMPN

SBTFST:	LDX #ARG2
	JSR WRDLST
	BCC SBFA
SBFL:	LDA ARG2+1
	BEQ SBFR
	CDR ARG1,ARG2
	JMP OTPRG1
SBFR:	JMP ERXWT2
SBFA:	LDX #ARG2
	LDY #ARG1
	JSR MAKPNM
	VPUSH ARG1
	LDA #$00
	STA BEGPNM
	CAR OLDCAR,ARG1
	LDA OLDCAR+1
	BNE SBFA1A
	LDA OLDCAR
	BEQ SBFR	;Empty word gives error
SBFA1A:	LDX #$00
	LDA OLDCAR+1
	BEQ SBFB
	STA OLDCAR
	STX OLDCAR+1
	CONS NEWNOD,OLDCAR,0,STRING
	LDA BEGPNM
	BNE SBFC
	VPUSH NEWNOD
	INC BEGPNM
	BNE SBFC1	;(Always)
SBFC:	RPLACD NEWPTR,NEWNOD
SBFC1:	MOV NEWPTR,NEWNOD
SBFB:	CDRME ARG1
	BEQ SBFD
	LDX OLDCAR
	CAR OLDCAR,ARG1
	LDY #$00
	TXA
	STA (NEWPTR),Y
	INY
	LDA OLDCAR
	STA (NEWPTR),Y
	JMP SBFA1A
SBFD:	LDA BEGPNM
	BNE SBFDA
	LDA #ARG1
	JSR MAKMTW	;Make ARG1 the empty word
	JMP SBFD1
SBFDA:	VPOP ARG1
SBFD1:	VPOP NEWPTR
	JMP OTPRG1

;	Local variable block:
NEWLST	=ANSN1
TMPCAR	=TEMPN1
PNAME	=TEMPN5		;Pname ptr.
ANSTYP	=ANSN2		;Result type
TEMP	=TEMPN
TEMP2	=TEMPN2

SBTLST:	LDX #ARG1
	JSR WRDLST
	BCS BTLSTL
BTLSTA:	LDY #PNAME
	LDX #ARG1
	JSR MAKPNM
	LDA #STRING
	STA ANSTYP
	LDY #$00
	LDA (PNAME),Y
	BEQ BTLSTR	;Empty word gives error
	LDA PNAME
	STA ARG1
	LDA PNAME+1
	STA ARG1+1
	BNE BTLSTX	;(Always)
BTLSTR:	JMP ERXWT1
BTLSTL:	STA ANSTYP
	LDA ARG1+1
	BEQ BTLSTR	;Emptry list gives error
BTLSTX:	LDA #$00
	STA NEWLST
	VPUSH ARG1
BTLSW:	LDY #$03
	LDA (ARG1),Y
	BEQ BTLSWE
	CAR TMPCAR,ARG1
	LDA #TEMP
	STA NODPTR
	LDY #TMPCAR
	LDX #$00
	LDA ANSTYP	;(List or String)
	BNE BTLWCS
	JSR LCONS	;it's a list.
BTLSW1:	LDA NEWLST
	BNE BTLSW2
	VPUSH TEMP
	INC NEWLST
	BNE BTLSW3	;(Always)
BTLSW2:	RPLACD TEMP2,TEMP
BTLSW3:	MOV TEMP2,TEMP
	CDRME ARG1
	JMP BTLSW
BTLSWE:	LDA ANSTYP
	BNE BTLWE1
	LDA NEWLST	;It's a list
	BNE BTLWL1
	LDA #$00
	STA ARG1+1
	BEQ BTLWL2	;(Always)
BTLWL1:	VPOP ARG1
BTLWL2:	VPOP TMPCAR
	JMP OTPRG1

BTLWCS:	JSR STCONS	;cons a string and continue.
	JMP BTLSW1

BTLWE1:	CAR TMPCAR,ARG1	;It's a string
	BEQ BTLWE2
	LDA #$00
	STA TMPCAR+1
	CONS TEMP,TMPCAR,0,STRING
	LDA NEWLST
	BNE BTLWE3
	MOV ARG1,TEMP
	JMP BTLWE5
BTLWE3:	RPLACD TEMP2,TEMP
	JMP BTLWE4
BTLWE2:	LDA NEWLST
	BNE BTLWE4
	LDA #ARG1
	JSR MAKMTW	;Make ARG1 the empty word
	JMP BTLWE5
BTLWE4:	VPOP ARG1
BTLWE5:	VPOP TEMP
	JMP OTPRG1

;Initial processing for word/list primitives.
;Arg ptr. in X, returns Carry clear if Fix,Flo,Atom,Satom,String; set if List, else error.
WRDLST:	JSR VPOP
	JSR GETTYP
	CMP #LIST
	BEQ LST
WRD:	CLC
	RTS
LST:	SEC
	RTS
.PAGE
;	Local variable block:
VSPPTR	=TEMPX1		;VSP arg. index (shared: UFUNCL,XTAIL,NWBNDS,STPTR1,SPRNT,SWORD)
NEWARG	=TEMPX2		;Newest arg.

SWORD:	LDA #$00
	STA MARK4+1	;MARK4 is the result pointer
	ASL NARGS
	LSR NARGS
	BEQ SWRD3
	JSR STPTR1	;VSPPTR := VSP + (NARGS * 2)
SWRDW:	LDA VSPPTR
	CMP VSP
	BNE SWRDW1
	LDA VSPPTR+1
	CMP VSP+1
	BEQ SWRD2
SWRDW1:	CAR NEWARG,VSPPTR
	DEC2 VSPPTR
	LDY #MARK3	;MARK3 is the newest arg pname
	LDX #NEWARG
	JSR MAKPNM
	LDY #$00
	LDA (MARK3),Y
	BEQ SWRDW	;Ignore arg if empty pname
	JSR CONCAT	;MARK4 := (Concatenate MARK4 MARK3)
	JMP SWRDW
SWRD2:	JSR INCVSP	;VSP := VSP + (NARGS * 2)
SWRD3:	LDA MARK4+1
	BNE SWRD4
	LDA #MARK4
	JSR MAKMTW	;Make MARK4 the empty word
SWRD4:	VPUSH MARK4
	INC OTPUTN
	LDA #$00
	JSR CLMK4
	JMP POPJ

;	Local variable block:
COPY1	=TEMPN3		;Copy of MARK4
COPY2	=TEMPN4		;Copy of MARK3
CHARS	=TEMPN1		;String chars.
NXTCHR	=ANSN1		;Next character
NEWCEL	=TEMPN		;Newest cell ptr.

CONCAT:	LDA MARK4+1
	BNE CNCT1
	LDA MARK3	;MARK4 is Lnil, so make
	LDX MARK3+1	;MARK4 a copy of second word (MARK3) and return
	LDY #MARK4
	JMP COPY
CNCT1:	LDA MARK4	;Here, neither is empty
	LDX MARK4+1
	LDY #MARK2	;Make a copy of MARK4
	JSR COPY
	MOV COPY1,MARK2	;Save the first word's pointer
	LDX #COPY1	;Get the last cell of first word
	JSR GTLSTC
	LDY #$01
	LDA (COPY1),Y
	BEQ CNCODD
	LDA MARK3	;Even no. chars. in first word
	LDX MARK3+1
	LDY #COPY2	;Make a copy of second word
	JSR COPY
	RPLACD COPY1,COPY2	;Link second word onto first
CNCTWE:	MOV MARK4,MARK2	;Restore pointer to new word
	RTS
CNCODD:	LDY #$00	;Odd no. chars. in first word
	STY CHARS+1
	LDA (MARK3),Y	;Get first char. of second word
	INY
	STA (COPY1),Y	;Append it to end of first word
	LDA (MARK3),Y
	STA CHARS	;Second char. of second word
CNCTW:	LDA MARK3+1
	BEQ CNCTWE
	CDRME MARK3	;Advance second word char-ptr
	LDA CHARS	;If even-numbered char. of second word nil, exit
	BEQ CNCTWE	;(already appended odd-numbered char. preceeding)
	LDA MARK3+1
	BNE CNCTW1
	STA CHARS+1	;Zero last character (because odd no.)
	BEQ CNCTW2	;(Always) Just add last char. if end of second word
CNCTW1:	LDY #$00
	LDA (MARK3),Y
	STA CHARS+1	;Get odd-numbered (3,5,...) char.
	INY
	LDA (MARK3),Y
	STA NXTCHR	;Get next even-numbered (4,6,...) char.
CNCTW2:	CONS NEWCEL,CHARS,0,STRING	;Cons new cell
	LDY #$02
	LDA NEWCEL
	STA (COPY1),Y
	TAX
	INY
	LDA NEWCEL+1
	STA (COPY1),Y	;Append to new word
	STA COPY1+1
	STX COPY1	;New new-word end pointer
	LDA NXTCHR
	STA CHARS	;Last even char. becomes new odd char.
	JMP CNCTW

;	Local variable block:
NEWCPY	=ANSN1		;Returned copy ptr. addr.
STRNGP	=TEMPN1		;String ptr.
LSTCEL	=TEMPN2		;Last cell of copy
NEWCEL	=TEMPN		;New cons cell

COPY:	STY NEWCPY
	STA STRNGP	;Make NEWCPY point to a copy of STRNGP
	STX STRNGP+1
	TXA
	BNE CCOPY1
	STA $00,Y	;nil -> nil
	RTS
CCOPY1:	STY NODPTR	;Cons up an empty cell
	LDA #$00
	TAX
	TAY
;	LDA #STRING
	JSR STCONS
	LDX NEWCPY
	JSR VPUSHP	;Vpush forming string
COPYW:	LDX NEWCPY
	GETX LSTCEL	;LSTCEL points to empty last cell of copy
	LDY #$00
	LDA (STRNGP),Y
	STA (LSTCEL),Y	;Copy two characters into cell
	INY
	LDA (STRNGP),Y
	STA (LSTCEL),Y
	INY
	LDA (STRNGP),Y
	TAX
	INY
	LDA (STRNGP),Y
	STA STRNGP+1	;Advance char-ptr of original
	STX STRNGP
	TAX
	BEQ COPYWE	;Exit if end of original
	CONS NEWCEL,0,0,STRING	;Cons a new cell
	LDY #$02
	LDX NEWCPY
	LDA NEWCEL
	STA (LSTCEL),Y
	STA $00,X
	INY
	LDA NEWCEL+1
	STA (LSTCEL),Y	;Link new cell on to end of copy
	STA $01,X	;Advance copy's last-cell ptr
	JMP COPYW
COPYWE:	LDX NEWCPY	;Vpop copy's beginning pointer
	JMP VPOP
.PAGE
;	Local variable block:
CHARS	=TEMPN		;String characters

;Output a typed character. RDKEY looks in the buffer, if none there it
;waits for one, flashing the cursor.
SRPOPJ:	JMP POPJ
SREADC:	LDA OTPUTN	;If OTPUTN is set, then we've got character, so return
	BNE SRPOPJ
	PUSHA SREADC	;Else return to SREADC again after a try in case of Pause
SRDC1:	JSR RDKEY
	JSR CKINTZ
	BCC SRDC1
OTPCHR:	STA CHARS
	LDA #$00
	STA CHARS+1
	CONS ARG1,CHARS,0,STRING	;Cons a cell with the character in it
	JMP OTPRG1

;CHAR <number> returns character with ascii value <number>
SLETOF:	JSR GT1FIX	;Get integer arg
	LDX #NARG1
	JSR CHKINT	;Check 16 bits
	BCS SLETE
	LDA NARG1+1	;Check for 8 bits
	BNE SLETE
	LDA NARG1
	JMP OTPCHR
SLETE:	JMP OVFL1	;number out of range.

;ASCII <letter> returns ascii value of letter
SNUMOF:	VPOP ARG1	;Get arg
	MOV ARGSAV,ARG1	;MAKPNM trashes arg1,arg2 if thing is a number.
	LDX #ARG1
	LDY #CHARS
	JSR MAKPNM	;Get pname --??? Should not cons!
	LDY #$01
	LDA (CHARS),Y	;Get the character
	BNE SNUME	;if second character<>0, then error.
	DEY		;we require 1-char strings because 
	LDA (CHARS),Y
	JMP OTFXS2	;Output it as a number
SNUME:	LDX #ARGSAV
	JMP ERXWTX
.PAGE
SFPUT:	VPOP ARG2
	VPOP ARG1
	GETTYP ARG2
	CMP #LIST
	BNE ERXWT2
	CONS ARG1,ARG1,ARG2,LIST
	JMP OTPRG1
ERXWT2:	ERROR XWTA,CURTOK,ARG2

;	Local variable block:
ELMENT	=TEMPN1
NEWNOD	=TEMPN2
NEWPTR	=TEMPN

SLPUT:	VPOP ARG2
	VPOP ARG1
	GETTYP ARG2
	CMP #LIST
	BNE ERXWT2
	LDA ARG2+1
	BNE SLPUT2
	CONS ARG1,ARG1,0,LIST
	JMP OTPRG1
SLPUT2:	MOV MARK2,ARG1	;Protect the last element
	MOV MARK3,ARG2	;Protect the original list (or what's left of it)
	CARNXT ELMENT,MARK3	;First element
	CONS MARK1,ELMENT,0,LIST	;Pointer to start of new list
	MOV NEWNOD,MARK1	;Pointer to newest node
SLPTW:	LDA MARK3+1	;Make a new list, element by element
	BEQ SLPT2
	CARNXT ELMENT,MARK3	;Get an element
	CONS NEWPTR,ELMENT,0,LIST	;New pointer to newest node
	LDY #$02
	LDA NEWPTR
	STA (NEWNOD),Y	;Pointer to last node
	TAX
	INY
	LDA NEWPTR+1
	STA (NEWNOD),Y	;(CDR) Link new node onto list
	STA NEWNOD+1
	STX NEWNOD
	JMP SLPTW
SLPT2:	CONS NEWPTR,ARG1,0,LIST	;Get a pointer to first argument
	RPLACD NEWNOD,NEWPTR	;Link final node on
	JMP SSN2	;MARK1 points to our new list

SLIST:	ASL NARGS
	LSR NARGS
	LDA #$00
	STA MARK1+1
	LDA NARGS
	BEQ SLSTWE
SLISTW:	VPOP MARK2
	CONS MARK1,MARK2,MARK1,LIST
	DEC NARGS
	BNE SLISTW
SLSTWE:	MOV ARG1,MARK1
	LDA #$00
	JSR CLMK2
	JMP OTPRG1

;	Local variable block:
ELMCNT	=TEMPN2		;Element counter

SSNTNC:	LDA #$00
	STA MARK1+1
	ASL NARGS
	LSR NARGS
SSN1:	BNE SSNWA
SSN2:	MOV ARG1,MARK1
	LDA #$00
	JSR CLMK3
	JMP OTPRG1
SSNWA:	VPOP MARK2
	JSR GETTYP
	CMP #LIST
	BEQ SSNW1
	CONS MARK1,MARK2,MARK1,LIST
	JMP SSNW2
SSNW1:	LDA #$00
	STA ELMCNT
	STA ELMCNT+1
SSNX:	LDA MARK2+1
	BEQ SSNY
	CARNXT MARK3,MARK2
	VPUSH MARK3
	INC ELMCNT
	BNE SSNX
	INC ELMCNT+1
	BNE SSNX	;(Always)
SSNY:	LDA ELMCNT
	BNE SSNY1
	LDA ELMCNT+1
	BEQ SSNW2
SSNY1:	VPOP MARK3
	CONS MARK1,MARK3,MARK1,LIST
	SEC
	LDA ELMCNT
	SBC #$01
	STA ELMCNT
	BCS SSNY
	DEC ELMCNT+1
	BCC SSNY1	;(Always)
SSNW2:	DEC NARGS
	JMP SSN1
.PAGE
.SBTTL		Miscellaneous Primitives

;	Local variable block:
NEWATM	=TEMPX1		;New interned atom

SMAKE:	VPOP ARG2
	VPOP ARG1
	JSR GETTYP
	LDY #ARG1
	CMP #ATOM
	BEQ SMAKE1
	CMP #SATOM
	BEQ SMAKE1
	CMP #STRING
	BNE ERXWT1
	LDX #ARG1
	LDY #NEWATM
	JSR INTERN	;Intern the Name if it's a string
	LDY #NEWATM
SMAKE1:	LDX #ARG2
	JSR PUTVAL
	JMP POPJ
ERXWT1:	ERROR XWTA,CURTOK,ARG1

SOUTPT:	LDA LEVNUM
	ORA LEVNUM+1
	BEQ SOTPT1
SOTPT2:	LDA #$01
	STA STPFLG
	STA OTPUTN
	JMP POPJ
SOTPT1:	ERROR XNTL,CURTOK

SSTOP:	LDA LEVNUM
	ORA LEVNUM+1
	BEQ SOTPT1
	LDA #$01
	STA STPFLG
	JMP POPJ

SCOMMT:	LDA #$00
	STA TOKPTR+1
	LDA EXPOUT
	BNE ERXEOL
	JMP POPJ
ERXEOL:	ERROR XEOL

;If at level 0, can't continue unless there is a break loop and
;RUNFLG is set.
;If not at level 0, can't continue unles there is a break loop.
SCNTIN:	LDA BRKSP+1	;Nonzero means a break loop is in progress.
	ORA LEVNUM	;Nonzero means not toplevel.
	ORA LEVNUM+1
	ORA RUNFLG	;Nonzero means toplevel of a RUN.
	BEQ CNPJ
SCN1:	LDA #$01
	STA STPFLG
	INC COFLAG	;BRKLOP will return from break-loop
CNPJ:	JMP POPJ
.PAGE
STEST:	VPOP ARG1
	JSR GTBOOL
	STY IFTEST
	JMP POPJ

SIFT:	JSR SIFX
	BNE SIF2
	JMP POPJ

SIFF:	JSR SIFX
	BEQ SIF2
	JMP POPJ

SIF:	JSR SIFX
	VPOP ARG1
	JSR GTBOOL
	TYA
	BNE SIF2
SIF3A:	JMP POPJ
SIF2:	LDX #NEXTOK
	JSR EXIFSC
	LDA TOKPTR+1
	BEQ SIF3A
SIF3:	LDA NEXTOK
	CMP ELSE
	BNE SIF3A
	LDA NEXTOK+1
	CMP ELSE+1
	BNE SIF3A
	JSR TOKADV
	JMP POPJ

;	Local variable block:
TEMP	=TEMPN2

SELSE:	DEC IFLEVL
	LDA IFLEVL
	BMI SELSE1
	BEQ SELSE2
	STA TOKPTR+1
	JMP POPJ
SELSE2:	LDX #TEMP
	JSR EXIFSC
	JMP POPJ
SELSE1:	ERROR XELS

SIFX:	INC IFLEVL
	BNE SIFXA
	LDX #XIFLEX
	JMP EXCED
SIFXA:	JSR GTNXTK
	LDA NEXTOK
	CMP THEN
	BNE SIFX1
	LDA NEXTOK+1
	CMP THEN+1
	BNE SIFX1
	JSR TOKADV
SIFX1:	LDY IFTEST
	RTS
.PAGE
;	Local variable block:
PNAME	=TEMPX1		;Numerical pname ptr.
ULNND1	=TEMPN3		;ULNEND save
ULINE	=TEMPN1
	
SGO:	LDA LEVNUM
	ORA LEVNUM+1
	BNE SGOA
	ERROR XNTL,CURTOK
SGOA:	LDA EXPOUT
	BNE GOERR1
	VPOP ARG1
	JSR GETTYP
	CMP #ATOM
	BEQ SGO1
	CMP #SATOM
	BEQ SGO1
	CMP #STRING
	BEQ SGOSTR
	CMP #FIX
	BEQ GONUM
	CMP #FLO
	BEQ GONUM
	JMP ERXWT1
GONUM:	LDX #ARG1
	LDY #PNAME
	JSR MAKPNM	;Make a string out of the number
	LDX #PNAME
	LDY #ARG1
	JSR INTERN	;And Intern it
	JMP SGO1
GOERR1:	LDA GO		;Explicitly signal error, "GO Didn't output"
	LDX GO+1
	JMP ERXNP1
SGOSTR:	MOV ARG2,ARG1	;ARG1 is a String, so Intern it
	LDX #ARG2
	LDY #ARG1
	JSR INTERN
SGO1:	LDA #LATOM
	LDX #ARG1
	JSR PUTTYP
	MOV GOPTR,FBODY
	MOV ULNND1,ULNEND
	JSR GLNADV
SGOW:	LDA GOPTR+1
	BEQ SGOR
	LDX #ULINE
	LDY #GOPTR
	JSR GETULN
	CARME ULINE
	LDA ARG1
	CMP ULINE
	BNE SGOW2
	LDA ARG1+1
	CMP ULINE+1
	BEQ SGOE1
SGOW2:	JSR GLNADV
	JMP SGOW
SGOE1:	JMP POPJ
SGOR:	MOV ULNEND,ULNND1
	ERROR XLNF,ARG1

SRUN:	VPOP ARG1
	JSR GETTYP
	CMP #LIST
	BNE SRUN2
	VPUSH TOKPTR	;Save old line
	JSR PARSEL	;Parse ARG1 into LINARY
	PUSHB EXPOUT
	VPUSH TOKPTR	;Save parsed list
	PUSHA SRNDON
;	...

;Executes the list in TOKPTR.
;	...
RUNHAN:	PUSHB UFRMAT
	PUSH ULNEND
	PUSHB RUNFLG
	LDX #$00
	STX UFRMAT	;Command line is of type List
	INX
	STX RUNFLG
	PUSHA RH1
	JMP EVLINE

RH1:	POPB RUNFLG
	POP ULNEND
	POPB UFRMAT
	JMP POPJ

SRUN1:	JMP GTERR1
SRUN2:	JMP ERXWT1

;RUN/REPEAT unwind-protect routine:
RUNUNW:	LDA RUNFLG	;If RUNFLAG is zero,
	BEQ RUNWX	;the UFRMAT is correct, else
	GETTYP FBODY	;get UFRMAT from FBODY pointer
	STA UFRMAT
;Don't clear RUNFLG.  Will happen itself in stack unwind.
RUNWX:	RTS

SRPEAT:	VPOP ARG2
	LDA ARG2
	PHA		;Save second arg through GT1FIX
	LDA ARG2+1
	PHA
	JSR GT1FIX
	LDX ARG1+3
	BMI SRUN1
	LDX NARG1
	LDY NARG1+1
	PLA		;Retrieve second arg as ARG1
	STA ARG1+1
	PLA
	STA ARG1
	TXA
	PHA		;Save the number through PARSEL
	TYA
	PHA
	LDA NARG1+2
	PHA
	LDA NARG1+3
	PHA
	GETTYP ARG1	;Check the second arg
	CMP #LIST
	BNE SRUN2
	VPUSH TOKPTR	;Save the rest of the command line
	PUSHB EXPOUT	;Save the Expected-output flag
	JSR PARSEL
	VPUSH TOKPTR	;Save the parsed list on the VPDL
	LDX #$03
SRPTL1:	PLA		;Retrieve the number
	STA ARG2,X
	DEX
	BPL SRPTL1
SRPLOP:	LDX #$03	;See if the repeat-counter is zero
SRPTL2:	LDA ARG2,X
	BNE SRPLP1	;Nonzero
	DEX
	BPL SRPTL2
SRNDON:	LDA OTPUTN	;Done repeating - If OTPUTN is 1, there's a value on the VPDL
	BEQ SRNDN1
	VPOP ARG1	;Get the value off the VPDL
SRNDN1:	VPOP TOKPTR	;Get list off of the VPDL (discarded)
	POPB EXPOUT
	VPOP TOKPTR	;Get the rest of the original line back
	LDA OTPUTN
	BEQ SRNDN2
	VPUSH ARG1	;Put the arg back if there is one
SRNDN2:	JMP POPJ

SRPLP1:	CLC		;Another repetition: Decrement the repeat-counter
	LDX #$FC
SRPL1L:	LDA ARG2+4,X
	SBC #$00
	STA ARG2+4,X
	INX
	BMI SRPL1L
SRPLP2:	PUSH ARG2	;Push the number (low word)
	PUSH ARG2+2	;(high word)
	PUSHA SREPT1	;Return to SREPT1 after executing
	JMP RUNHAN

SREPT1:	LDA OTPUTN	;See if there's an output on the VDPL
	BEQ SRPT1A
	VPOP ARG1	;Yes, get it
	LDA EXPOUT	;See if it was wanted
	BEQ RPTER1	;No, error
	DEC EXPOUT	;OK, but clear EXPOUT now
SRPT1A:	CDR TOKPTR,VSP	;Get the run-list but leave on VPDL
	LDA OTPUTN	;If there was an output on the VPDL
	BEQ SRPT1B
	VPUSH ARG1	;put it back
SRPT1B:	POP ARG2+2	;Pop the number (high bytes)
	POP ARG2	;(low bytes)
	LDA STPFLG	;If something set Stop-flag, stop repeating
	BNE SRNDON
	JMP SRPLOP	;Continue Repeating
RPTER1:	ERROR XUOP,ARG1
.PAGE
;	Local variable block:
NEWATM	=TEMPX1

STHING:	VPOP ARG2
	JSR GETTYP
	LDY #ARG2
	CMP #ATOM
	BEQ STH1
	CMP #SATOM
	BEQ STH1
	CMP #STRING
	BNE STH2
	LDX #ARG2
	LDY #NEWATM
	JSR INTERN	;Intern the Name if it's a string
	LDY #NEWATM
STH1:	LDX #ARG1
	JSR GETVAL
	CMP #$01
	BNE OTPRG1
	ERROR XHNV,ARG2
STH2:	LDX #ARG2
	JMP ERXWTY
OTPRG1:	INC OTPUTN
	VPUSH ARG1
	JMP POPJ

SREQU:	VPUSH TOKPTR	;Save rest of cammand line
	PUSHA SREQUX
SREQUX:	LDA OTPUTN	;Will be re-entered here after completion or from CO
	BNE SGCE	;If OTPUTN set, just return, else try again
	LDA #$0D
	STA PRSBUF	;Null the PRSBUF
	LDA #$F0	;Negative PRSFLG tells Parser to parse as a list
	STA PRSFLG	;(it gets incremented once inside PRSLIN.)
	JSR GETLN	;Negative PRSFLG in GETLN means allow ^Z.
	SETV PLINE,PRSBUF
	LDX #TOKPTR
	JSR PRSLIN	;Parse the line
	LDA #$0D
	STA PRSBUF	;Null the PRSBUF
	MOV ARG1,TOKPTR
	VPOP TOKPTR	;Restore command line
	JMP OTPRG1

SGCOLL:	JSR GARCOL
SGCE:	JMP POPJ

SNODES:	SEC
	LDA #TYPLEN&$FF
	SBC NNODES
	STA NARG1
	LDA #TYPLEN^
	SBC NNODES+1
	STA NARG1+1
	JMP OTFXS1
.PAGE
;	Local variable block:
TLIST	=TEMPN2
NAME	=TEMPN3
BODY	=TEMPX1
VSPPTR	=TEMPN1

SDEFIN:	VPOP BODY
	VPOP ARG1
	JSR GETTYP
	CMP #ATOM
	BEQ SDEFN1
	CMP #STRING
	BNE SDFNR1
	LDX #ARG1
	LDY #ARG2
	JSR INTERN
	GETTYP ARG2
	CMP #ATOM
	BNE SDFNR1
	MOV NAME,ARG2
	JMP SDFN1A
SDEFN1:	MOV NAME,ARG1
SDFN1A:	GETTYP BODY
	CMP #LIST
	BNE DEFNER
	CAR ARG1,BODY
	CDR TLIST,BODY
	GETTYP ARG1
	CMP #LIST
	BNE DEFNER
	LDA BODY+1
	BNE DEFUN1
	LDX #NAME
	JSR UNFUNC
	JMP POPJ
SDFNR1:	JMP ERXWT1
DEFNER:	LDX #BODY
	JMP ERXWTX
DEFUN1:	VPUSH TOKPTR	;Save the rest of the line
	VPUSH BODY
	MOV VSPPTR,VSP
	JSR SWAPT1
	JSR PARSEL	;Parse the arglist
	JSR SWAPT2
	JSR CKTITL	;Make sure the arglist is legal
	VPUSH MARK1	;Vpush Arglist
	LDA #$00
	STA MARK1+1
DEFUNW:	LDA TLIST+1
	BEQ DEFNWE
	CAR ARG1,TLIST
	GETTYP ARG1
	CMP #LIST
	BNE DEFNER
	JSR SWAPT1	;Save variables
	JSR PARSEL
	JSR SWAPT2	;Retrieve variables
	VPUSH TOKPTR
	CDRME TLIST
	BNE DEFUNW
DEFNWE:	LDA #$00
	STA ARG2+1
DEFUNX:	LDA VSPPTR
	CMP VSP
	BNE DEFNX1
	LDA VSPPTR+1
	CMP VSP+1
	BEQ DEFNXE
DEFNX1:	VPOP TLIST
	CONS ARG2,TLIST,ARG2,LIST
	JMP DEFUNX
DEFNXE:	MOV ARG1,NAME	;Can only give ARG1 to STUFF, won't like any temporaries
	LDX #ARG2
	LDA #ARG1
	JSR STUFF
	VPOP TLIST	;Vpop & diwcard LISTT
	VPOP TOKPTR	;Get the rest of the line back
	JMP POPJ
.PAGE
;	Local variable block:
FUN	=TEMPN5
BODY	=TEMPN6
VSPPTR	=TEMPN1
LINE	=TEMPN2

STEXT:	VPOP ARG1
	JSR GETTYP
	CMP #ATOM
	BEQ STEXTA
	CMP #STRING
	BNE STEXTR
	LDY #ARG2
	LDX #ARG1
	JSR INTERN
	LDX #ARG2
	BNE STEXTB	;(Always)
STEXTA:	LDX #ARG1
STEXTB:	LDA #FUN
	JSR GETFUN
	CMP #$01
	BNE STEXT1
	LDA #$00
	STA BODY+1
	STA BODY
	JMP STXT1A	;undefined returns nil.
STEXTR:	JMP ERXWT1
STEXT1:	CDR BODY,FUN
	GETTYP BODY
	CMP #FPACK
	BNE STXT1A	;must be type LIST.
STXT1B:	LDY #BODY
	LDX #FUN
	JSR UNSTUF
STXT1A:	VPUSH BODY
	INC OTPUTN
	JMP POPJ
.PAGE
;	Local variable block:
TOKEN	=TEMPX2		;Argument token ptr.
FUN	=TEMPX2		;Function ptr.
LENGTH	=TEMPX1		;Length of area for PTFTXT

STO:	LDA EXPOUT
	BNE STOER1	;Error if an output was expected
	LDA INPFLG
	BNE STO1
	JMP EDTST1	;Not in EDIT-eval loop, so call screen editor
STOER1:	LDA TO
	LDX TO+1
	JMP ERXNP1	;Error "TO didn't output"
STO1:	JSR DEFSTP	;In edit-eval loop, defining procedure
	INC DEFFLG
	JSR CKTITL
	LDA #FUN
	LDX #ARG1
	JSR GETFUN
	CMP #$01
	BEQ STO1A
	JSR UNFNC1
STO1A:	LDA #$00
	STA NARGS
	CONS DEFBOD,MARK1,0,LIST
	LDA #$00
	STA LENGTH+1
	STA MARK1+1
	LDA NARGS
	STA LENGTH
	LDY #DEFBOD
	LDX #DEFATM
	LDA #LENGTH
	JSR PTFTXT
	JMP POPJ

CKTITL:	MOV MARK1,TOKPTR
STOW:	LDA TOKPTR+1
	BEQ STOWE
	CAR TOKEN,TOKPTR
	GETTYP TOKEN
	CMP #ATOM
	BEQ STOW3
	CMP #SATOM
	BEQ STOW3
	CMP #DATOM
	BEQ STOW3
	LDX #TOKEN
	JMP ERXWTX
STOW3:	JSR TOKADV
	INC NARGS
	BPL STOW
	LDX #XNRGEX
	JMP EXCED
STOWE:	RTS

SEND:	LDA INPFLG
	BEQ SENDR1	;Error if not in editor
	LDA DEFFLG
	BNE SEND1
	PRTSTR EXEND	;Warning if no procedure being defined
	JMP POPJ
SENDR1:	ERROR XNED
SEND1:	LDA #DEFATM
	LDX #DEFBOD
	JSR STUFF	;try to put the function def together
	LDA LEVNUM
	ORA LEVNUM+1
	BNE SEND2	;no defined message unless at toplevel or break loop.
	LDX #DEFATM
	JSR LTYPE
	PRTSTR SENDM	;" DEFINED"
SEND2:	JSR EXTDEF
	JMP POPJ
.PAGE
SPRINT:	LDA #$20
	JSR SPRNT
	JSR BREAK1
	JMP POPJ

SPRNT1:	LDA #$00
	JSR SPRNT
	JMP POPJ

;	Local variable block:
VSPPTR	=TEMPX1		;VSP pointer (shared: UFUNCL,XTAIL,NWBNDS,STPTR1,SPRNT)

SPRNT:	PHA		;Space-between-args flag
	ASL NARGS
	LSR NARGS
	BEQ SPRNT2
	JSR STPTR1	;VSPPTR := VSP + (NARGS * 2)
SPRNTW:	LDA VSPPTR
	CMP VSP
	BNE PRNTW1
	LDA VSPPTR+1
	CMP VSP+1
	BEQ PRNTWE
PRNTW1:	CAR ARG1,VSPPTR
	DEC2 VSPPTR
	LDX #ARG1
	LDA BKTFLG	;Let user control bracket printing via BKTFLG.
	BNE PRNTW2	;If BKTFLG is nonzero, then call LTYPE with 0 in A.
	JSR LTYPE1
	JMP PRNTW3
PRNTW2:	INC OTPFLG	;Also print '' always if BKTFLG<>0.
	JSR LTYPE0
	DEC OTPFLG
PRNTW3:	PLA
	PHA
	BEQ SPRNTW
	JSR TPCHR
	JMP SPRNTW
PRNTWE:	JSR INCVSP	;VSP := VSP + (NARGS * 2)
SPRNT2:	PLA
	RTS
.PAGE
;	Local variable block:
FUN	=TEMPN1		;Function ptr.

SPO:	LDA TOKPTR+1
	BNE SPO1
	LDA PODEFL+1
	BNE SPO1A
	JMP POPJ
SPO1:	JSR GETRG1	;car ARG1 from TOKPTR
	JSR TOKADV
	LDX ARG1
	LDY ARG1+1
	CPX ALL
	BNE SPO2
	CPY ALL+1
	BNE SPO2
	LDA #$01
	JSR POFUNS
SPON:	LDA #$01
	JSR PONAMS
	JMP POPJ
SPO2:	CPX NAMES
	BNE SPO3
	CPY NAMES+1
	BEQ SPON
SPO3:	CPX TITLES
	BNE SPO4
	CPY TITLES+1
	BNE SPO4
SPOTS:	LDA #$00
	JSR POFUNS
	JMP POPJ
SPO5A:	MOV PODEFL,ARG1
SPO1A:	LDX #PODEFL
	LDA #FUN
	JSR GETFUN
	CMP #$01
	BEQ PFERR
	LDA #$01
	LDX #PODEFL
	JSR POFUN
	JMP POPJ
SPO4:	CPX PROCS
	BNE SPO5
	CPY PROCS+1
	BNE SPO5
	LDA #$01
	JSR POFUNS
	JMP POPJ
SPO5:	GETTYP ARG1
	CMP #ATOM
	BEQ SPO5A
	CMP #SATOM
	BEQ ERXUBL
	JMP ERXWT1
ERXUBL:	ERROR XUBL,ARG1
PFERR:	ERROR XNDF,PODEFL
.PAGE
SERASE:	LDA TOKPTR+1
	BNE SERAS1
	JMP ERXEOL
SERAS1:	JSR GETRG1	;car ARG1 from TOKPTR
	JSR TOKADV
	LDX ARG1
	LDY ARG1+1
	CPX ALL
	BNE ECMP2
	CPY ALL+1
	BNE ECMP2
	JSR ERPROS
	JSR ERNAMS
	JMP POPJ
ECMP2:	CPX NAMES
	BNE ECMP3
	CPY NAMES+1
	BNE ECMP3
	JSR ERNAMS
	JMP POPJ
ECMP3:	CPX TITLES
	BNE ECMP4
	CPY TITLES+1
	BEQ SERPS
ECMP4:	CPX PROCS
	BNE SERAP
	CPY PROCS+1
	BNE SERAP
SERPS:	JSR ERPROS
	JMP POPJ
SERAP:	GETTYP ARG1
	CMP #ATOM
	BNE SERAR2
	JSR UNFNC1
	JMP POPJ
SERAR2:	JMP ERXWT1

GETRG1:	CAR ARG1,TOKPTR
RTS30:	RTS

;	Local variable block:
OBPTR	=TEMPN		;Oblist ptr.
OBJECT	=TEMPN1		;Oblist object

ERPROS:	MOV OBPTR,OBLIST
ERPRSW:	LDA OBPTR+1
	BEQ RTS30
	CARNXT OBJECT,OBPTR
	LDX #OBJECT
	JSR UNFUNC
	JMP ERPRSW

;	Local variable block:
OBPTR	=TEMPN		;Oblist ptr.
SOBPTR	=TEMPN		;Soblist ptr.
NOVALU	=TEMPN1		;Novalue constant
NAME	=TEMPN2		;Name ptr.

ERNAMS:	MOV OBPTR,OBLIST
	LDA #$01
	STA NOVALU+1
ERNMSW:	LDA OBPTR+1
	BEQ ERNMWE
	CARNXT NAME,OBPTR
	LDX #NOVALU
	LDY #NAME
	JSR PUTVAL
	JMP ERNMSW
ERNMWE:	MOV SOBPTR,SOBLST
ERNMX:	LDA SOBPTR
	CMP SOBTOP
	BNE ERNMX1
	LDA SOBPTR+1
	CMP SOBTOP+1
	BEQ RTS30
ERNMX1:	LDX #NOVALU
	LDY #SOBPTR
	JSR PUTVAL
	INC4 SOBPTR
	JMP ERNMX

	;Local variable block:
NEWATM	=TEMPX1		;Interned atom
VALUE	=TEMPN1		;Name's value

SERNAM:	VPOP ARG1
	JSR GETTYP
	CMP #ATOM
	BEQ SERN1
	CMP #SATOM
	BEQ SERN1
	CMP #STRING
	BNE SERN2
	LDX #ARG1
	LDY #NEWATM
	JSR INTERN	;Intern the Name if it's a string
	MOV ARG1,NEWATM
SERN1:	LDY #ARG1
	LDX #VALUE
	JSR GETVAL
	CMP #$01
	BNE SERN3
	ERROR XHNV,ARG1
SERN2:	LDX #ARG1
	JMP ERXWTY
SERN3:	LDA #$01
	STA NOVALU+1
	LDX #NOVALU
	LDY #ARG1
	JSR PUTVAL
	JMP POPJ
.PAGE
;STRCBK:	JMP POPJ ;COMMENT OUT EVERYWHERE
.IFNE 0	;TRACEBACK temporarily removed
;	Local variable block:
FR	=TEMPX1
XFR	=TEMPX2
PTR	=TEMPN6
PTR1	=TEMPN7
FIRST	=ANSN1
FUN	=TEMPNH
NAME	=TEMPN8

STRCBK:	LDA FRAME+1
	BNE TCBK1
	PRTSTR TBMSG1
	JMP POPJ
TCBK1:	PRTSTR TBMSG2
	LDA #$01
	STA FIRST
	MOV FR,FRAME
	MOV XFR,XFRAME
TCBKW:	LDA FR+1
	BNE TCBKW1
	JMP TCBKWE
TCBKW1:	CLC
	LDA FR
	ADC #SFBNDS	;Frame Bindings pointer
	STA PTR
	LDA FR+1
	ADC #$00
	STA PTR+1
	SEC
	LDA XFR
	SBC #$02	;PTR1 points to top binding (name)
	STA PTR1
	LDA XFR+1
	SBC #$00
	STA PTR1+1
TCBKX:	LDA PTR1+1
	CMP PTR+1
	BCC TCBKXE
	BNE TCBKX1
	LDA PTR1
	CMP PTR
	BCC TCBKXE
TCBKX1:	LDY #$01
	LDA (PTR1),Y
	STA FUN+1
	DEY
	LDA (PTR1),Y
	STA FUN
	ROR A
	BCC TCBKX2
	LDA FIRST
	BNE TCBKX3
	LDA #',
	JSR TPCHR
	LDA #$20
	JSR TPCHR
	JMP TCBKX4
TCBKX3:	DEC FIRST
TCBKX4:	LDY #$05
	LDA (FUN),Y
	STA NAME
	INY
	LDA (FUN),Y
	STA NAME+1
	LDX #NAME
	JSR LTYPE
TCBKX2:	SEC
	LDA PTR1
	SBC #$04
	STA PTR1
	BCS TCBKX
	DEC PTR1+1
	JMP TCBKX
TCBKXE:	LDY #SFXFRM	;Frame Xframe pointer
	LDA (FR),Y
	STA XFR
	INY
	LDA (FR),Y
	STA XFR+1
	LDY #SFFRAM	;Frame Previous-frame pointer
	LDA (FR),Y
	TAX
	INY
	LDA (FR),Y
	STA FR+1
	STX FR
	JMP TCBKW
TCBKWE:	JSR BREAK1
 	JMP POPJ
.ENDC

STRACE:	PRTSTR TRACEM
	LDA #$01
	STA TRACE
	LDA #'N
	JSR TPCHR
	JSR BREAK1
	JMP POPJ

SNTRAC:	PRTSTR TRACEM
	LDA #$00
	STA TRACE
	LDA #'F
	JSR TPCHR
	LDA #'F
	JSR TPCHR
	JSR BREAK1
	JMP POPJ
.PAGE
;	Local variable block:
PRODCT	=TEMPN		;Partial product (shared: IMULT,MOD360,SPROD,SRANDM)
RANGE	=TEMPN3		;Range

SRANDM:	JSR GT1FIX
	LDX #NARG1
	JSR CHKPIN
	BCS SRANDR
	MOV RANGE,NARG1
	SETV NARG2,RANDA	;Multiply 16-bit Random number by transform constant "A"
	MOV NARG1,RANDOM
	LDA #$00
	STA NARG1+2
	STA NARG1+3
	STA NARG2+2
	STA NARG2+3
	JSR IMULT
	CLC
	LDA PRODCT
	ADC #RANDC&$FF	;Add transform constant "C"
	STA RANDOM
	STA NARG1
	LDA PRODCT+1
	ADC #RANDC^
	STA RANDOM+1
	STA NARG1+1
	MOV NARG2,RANGE
	LDA #$00
	STA NARG1+2
	STA NARG1+3
	STA NARG2+2
	STA NARG2+3
	JSR IMULT
	LDA #$00
	STA PRODCT+4
	STA PRODCT+5
	LDY #PRODCT+2
	JMP OTPFIX
SRANDR:	JMP GTERR1

SRNDMZ:	MOV RANDOM,RNDL
	JMP POPJ
.PAGE

SCURSR:	JSR GT2FIX
	LDA #$27
	JSR SMLFX1	;check the thing in narg1
	BCS SCRSR1
	LDX #NARG2
	LDA #$17
	JSR SMALFX
	BCS SCRSR1
	LDA NARG1
	STA CH
	LDA NARG2
	STA CV
	JSR BCALCA
	JMP POPJ
SINDXR: ERROR XUBL,CURTOK
SCRSR1:	ERROR XCSR	;"Position off of screen"

SCLINP:	JSR CLRCBF	;Clear input buffer and character strobe
	JMP POPJ

SCLEAR:	JSR HOME
	LDA GRPHCS
	BPL SCLR1
	LDA #$14	;If in GRAPHICS mode, put the
	STA CV		;cursor at the beginning of the
	JSR BCALCA	;text area
SCLR1:	JMP POPJ

SPADDL:	JSR GT1FIX
	LDA #$04
	JSR SMLFX1	;check the thing in narg1
	BCS SCALL2
;Given paddle number (0-3) in X, returns 0-$FF in Y.
	LDA PTRIG	;Trigger one-shot
	LDY #$00	;Init counter
	NOP
	NOP
	LDX NARG1
PREAD2:	LDA PADDL,X	;Count Y-register every 12. microseconds
	BPL PRXIT	;Unitl high bit reset
	INY
	BNE PREAD2
	DEY
PRXIT:	STY NARG1
	JMP OTFXS1
.PAGE
SEXAM:	JSR GT1FIX
	LDX #NARG1
	JSR CHKPIN
	BCS SCALL2
	LDY #$00
	LDA (NARG1),Y
	STA NARG1
	STY NARG1+1
	JMP OTFXS1

SDEP:	JSR GT2FIX	;First argument is location
	LDX #NARG1
	JSR CHKPIN
	BCS SCALL2
	LDX #NARG2
	JSR CHKPBN
	BCS SPKERR
	LDY #$00
	LDA NARG2
	STA (NARG1),Y
	JMP POPJ
SPKERR:	JMP GTERR2	;Error, ARG2 too big

SCALL:	JSR GT2FIX		;narg2 gets arg for user.
	LDX #NARG1
	JSR CHKPIN
	BCS SCALL2
	LDA #<SCALLX-1>^	;Push return address for RTS
	PHA
	LDA #<SCALLX-1>&$FF
	PHA
	LDA KILRAM		;Most users routines would rather
	JMP (NARG1)		;have the monitor than nodespace.
SCALL2:	JMP GTERR1
SCALLX:	LDA GETRM1
	LDA GETRM1
	JMP POPJ

SINADR:	JSR GT1FIX
	LDX #NARG1
	JSR CHKINT
	BCS SCALL2
	LDA NARG1+1
	BNE SINAD3	;>255 means it is an address for sure.
	CMP NARG1
	BNE SINAD2
	SETV NARG1,KEYIN
	JMP SINAD3
SINAD2:	LDA NARG1
	CMP #$08	;1 to 7 means set to C#00.
	BCS SINAD3	;8-255, ok, if you really want to...
	LDA NARG1
	ORA #$C0
	STA NARG1+1
	LDA #$00
	STA NARG1
SINAD3:	MOV DEFINP,NARG1
	JSR SETKBD
	JMP POPJ

SOTADR:	JSR GT1FIX
	LDX #NARG1
	JSR CHKINT
	BCS SCALL2
	LDA NARG1+1
	BNE SOTAD3	;>255 means it is an address for sure.
	CMP NARG1
	BNE SOTAD2
	SETV NARG1,COUT	;0, reset to screen driver
	JMP SOTAD3
SOTAD2:	LDA NARG1
	CMP #$08	;1 to 7 means set to C#00.
	BCS SOTAD3	;8-255, ok, if you really want to...
	LDA NARG1
	ORA #$C0
	STA NARG1+1
	LDA #$00
	STA NARG1
SOTAD3:	MOV DEFOUT,NARG1
	JSR SETVID
	JMP POPJ

.PAGE
.IFNE MUSINC
.SBTTL	Music Primitives and Routines

PSIZE	=TEMPN3			;length of all parameter buffers together.
MBUFLN	=TEMPN2			;length of each music buffer.
MPPRT	=TEMPX2			;needed only during the scope of PM.
COUNT	=TEMPX2+1		;used in NVOICES as a temporary.

;These are the codes for the commands that are stored in the music buffers.
;All have the msb set.
HINOTE	=71			;Yes, decimal.
CREST	=HINOTE+1

;INITLZ calls this routine.
MSINIT:	LDA #MSLOTI
	STA MSLOT		;Assume slot number is MSLOTI
	JMP QUIETM

;Music Unwind Protect.
;Any time an error occurs, this routine is called.
;It shuts up the ALF card.
;
;Make the ALF card be quiet. It makes random noise on power up.
;Reset the device by sending a "set volume 0" byte  to each stereo
;position of each channel. Then send a mode control byte of $E7
;to each stereo position. (Don't ask me what that means. I don't know.)
MUUNW:	;...
QUIETM:	LDA #$80
	CLC
	ADC MSLOT
	STA TEMPN1
	LDA #$C0
	ADC #$00
	STA TEMPN1+1
	LDY #$00
QMPLUP:	LDA #$9F		;Starting volume setting for each stereo pos.
	CLC
QMCLUP:	JSR ALFWAT		;need to wait for the ALF
	STA (TEMPN1),Y		;TELL CHANNEL SETVOLUME 0
	ADC #$20		;next channel.
	BCC QMCLUP		;when we get past $FF, it's done.
	LDA #$E7		;mode control byte for stereo pos.
	JSR ALFWAT
	STA (TEMPN1),Y
	INY
	CPY #$03		;stereo pos. numbers are 0,1,2.
	BNE QMPLUP		;next stereo position.
	RTS

;cretinous ALF needs 18 cycle wait between frobbing it
;THE JSR and RTS use up 6 cycles each
ALFWAT: NOP
	NOP
	NOP
	RTS    
.PAGE
;	Music buffer configuration section
MJPOPJ:	JMP POPJ
NVERR:	JMP GTERR1	;the error was in the first arg.
SNVOIC:	LDA INPFLG
	BNE MJPOPJ	;Just exit if in the editor.
	LDA GRPHCS
	BPL SNVC1
	JSR RESETT	;Reset graphics screen
SNVC1:	JSR GT1FIX
	LDA #$06	;Maximum no. of voices
	JSR SMLFX1
	BCS NVERR
	LDA NARG1
	BEQ NVERR	;Must be at least 1.
;A is a number 1-9, the number of parts.
	STA NPARTS
	JSR NOEDBF	;tell editor we've clobbered the buffer.
;calculate size of parameter table by multiplying the number by
;the size of the parameter table.
	LDX NPARTS
	LDA #$00
	STA MEACTP
	STA PARPNT
	CLC
MULUP:	ADC #PARSIZ
	DEX
	BNE MULUP
	STA PSIZE	
;now A contains the length of the entire parameter area.
;Put starting address of first PARAMETER AREA into PARPNT. -- $2000. Increment is #PARSIZ
;Put starting address of first MUSIC BUFFER into PARMBS. -- $2000+PSIZE. Increment is MBUFLN.
;Put it in PARMBV also, so PLAYMUSIC can restore it.
;Note that the parameter area may not be >255 bytes.
	STA PENXT	;pointer to place where next note should be put
	STA PSTART	;pointer to beginning of part buffer
	LDA #$20	;this sets up the high byte of these.
	STA PENXT+1
	STA PSTART+1
	STA PARPNT+1		;initially points to beginning of hi-res graphics page.
;PARPNT points to the first parameter table. PSTART points to the first
;music buffer. It shouldn't be touched in entry. PENXT is the register
;to use for pointing to the next place when entering music.

;Figure the length of the music buffers -- <$4000-(PSTART)>/(NPARTS)
	SEC
	LDA #$00
	STA NARG2+1		;this is the zero for hi-byte of (NPARTS)
	STA NARG2+2
	STA NARG2+3
	STA NARG1+2		;zero high bytes of NARG1
	STA NARG1+3
	SBC PSTART
	STA NARG1
	LDA #$40
	SBC PSTART+1
	STA NARG1+1
	LDA NPARTS		;now divide the number of bytes for all the
	STA NARG2		;music buffers by the number of buffers.
	JSR XDIVID
;Length of each music buffer is now in narg1.

	LDA NARG1
	STA MBUFLN
	CLC
	ADC PSTART		;starting address for first buffer.
	STA PEEND		;1+ending address for first buffer.
	LDA NARG1+1
	STA MBUFLN+1
	ADC PSTART+1
	STA PEEND+1
;now calculate the start and end address for each buffer and put it in the default 
;parameter table. Calculate other the defaults and install the parameter table for this buffer.
;Calculate the new SA for each buffer by adding the contents of MBUFLN, MBUFLN+1
;to PSTART, PSTART+1 and storing the result there and in PENXT,
;PENXT+1.
;To figure the new ending address, add contents of MBUFLN, MBUFLN+1
;to PEEND, PEEND+1 and store the result there.
;Figure the SA for the parameter table by adding the immediate quantity #PARSIZ
;to PARPNT, PARPNT+1 and storing the result there. Copy the table at 
;PARAMS to the locations pointed to by PARPNT, PARPNT+1. Do #PARSIZ bytes
	LDA NPARTS		;Do this for each part.
	STA COUNT
;Calculate defaults.
;Set up the channel number.
LODLUP:	LDA #$09		;nine parts
	SEC
	SBC COUNT		;now A contains 9 minus part number
;Why, you may ask, do we subtract the part number from nine? It is simple:
;Channel 2 (of 0,1,2) is the only one which has white noise. We want the
;user to be able to generate percussion sounds without either having to know
;about ordering of channels/sterso positions or having to allocate seven
;(the first one which would be in channel 2 if we didn't do this) buffers.
;The channel number is the quotient of this new number and 3, and the stereo
;position is the remainder.
	LDX #$00
	SEC
DIV3L:	SBC #$03
	BCC DIV3E		;we subtracted one too many 3's.
	INX
	BNE DIV3L
DIV3E:	ADC #$03		;add the 3 that we shouldn't have subtracted.
	CLC
;A now contains <PART#-9> mod 3, the stereo number. X is <PART#-9>/3 -- the
;channel number.
;Add the slot offset to the remainder -- the stereo position number.
	ADC MSLOT		;slot offset is slot number * 16.
	STA PARCHA		;CHAN in the parameter defaults table=slot*16+P
;and now for the quotient -- the channel number. CHAN+1,X=(32*CHAN) OR #$9F.
	TXA
	JSR GETCHN
	STA PARCHA+1		;CHAN+1 in the parameter defaults table.
;And finally copy the default settings (starting address and channel number included)
;to the parameter area in the hires graphics page.
	LDY #PARSIZ-1		;number of bytes in the parameter area -1
PARLUP:	LDA PARAMS,Y
	STA (PARPNT),Y
	DEY
	BNE PARLUP
;Calculate new sa for music buffer by adding MBUFLN to PSTART.
;initialize the next place to put a note to the starting address of
;the buffer.
;new enda by adding MBUFLN to PARFE, the next eob pointer.
;new sa for parameter area by adding #PARSIZ to PARPNT. 
	CLC
	LDA PSTART
	ADC MBUFLN
	STA PSTART
	STA PENXT
	LDA PSTART+1
	ADC MBUFLN+1
	STA PSTART+1
	STA PENXT+1
	CLC
	LDA PEEND
	ADC MBUFLN
	STA PEEND
	LDA PEEND+1
	ADC MBUFLN+1
	STA PEEND+1
	CLC
	LDA PARPNT
	ADC #PARSIZ
	STA PARPNT
	BCC PAR1C
	INC PARPNT+1
PAR1C:	DEC COUNT		;decrement part count.
	BNE LODLUP		;load parameters for next part.
;do the equivalent of a VOICE 1, without error checking.
	LDX #$01
	BNE VCOK		;(always)
.PAGE
;	Music entering section

SNOTE:	JSR MUSICP
	JSR GT2FIX
	LDA #CREST	;highest note allowed is rest.
	JSR SMLFX1	;check the thing in narg1.
	BCS MRGER2
	LDX #NARG2
	JSR CHKPIN	;duration should be a positive, 16-bit integer.
	BCS MRGERR
	LDA NARG1
	LDX MEPRT	;parameter index for current part.
	LDY #$03	;we want to write three bytes
	JSR MCKBY	;errors out if no more bytes.
	JSR PUTBYT
	LDA NARG2
	JSR PUTBYT
	LDA NARG2+1
	JSR PUTBYT
	JMP POPJ

SVOICE:	JSR MUSICP
	JSR GT1FIX
	LDA NPARTS
	JSR SMLFX1	;check the thing in narg1
	LDX NARG1
	BEQ MRGERR
	BCC VCOK
MRGERR:	JMP GTERR1
MRGER2:	JMP GTERR2
VCOK:	LDA #$00	;this is jumped to by nvoices.
	CLC
VCLUP:	DEX
	BEQ VCXIT
	ADC #PARSIZ
	BCC VCLUP
MUSBUG:	LDA #$06
	JMP SYSBUG	;means #parsiz*parts>255. shouldn't happen

VCXIT:	STA MEPRT	;#PARSIZ*(PART-1)
	JMP POPJ

SAD:	JSR MUSICP
	JSR GT2PIN	;get two positive integers.
	LDA #<ATTACK-TIME>	;Attack/Decay index
	JSR MTN12A	;transfer narg1/narg2 to current part parameter indicated by A.
	JMP POPJ
	
SVS:	JSR MUSICP
	JSR GT2PIN
	LDA #<VOLUME-TIME>	;volume/sustain
	JSR MTN12A
	JMP POPJ

SRG:	JSR MUSICP
	JSR GT2PIN
	LDA #<RELEAS-TIME>	;release/gap
	JSR MTN12A
	JMP POPJ

SFZ:	JSR MUSICP		;fuzz. narg1=type, narg2=shift
	JSR GT2PIN
	LDA NARG1		;so that 0 will be in a at nofuzz.
	DEC NARG1		;Noise type is 0 or 1.
	BMI NOFUZZ		;No fuzz if type-1<0.
	LDA NARG1
	AND #$01		;keep user from screwing self.
	ASL A
	ASL A
	STA NARG1
	LDA NARG2		;Shift rate.
	AND #$03		;and protect him again. Stupid, isn't he? 
	CLC
	ADC NARG1
	ORA #$E0		;constant which means noise control.
NOFUZZ:	LDX MEPRT		;Now A=11100TSS or 0 if BMI NOFUZZ.
	STA FUZZ,X
	JMP POPJ

;Gets two positive 16-bit integers.
GT2PIN:	JSR GT2FIX
	JSR CK1PIN
	LDX #NARG2
	JSR CHKPIN
	BCS GT2PN2
	RTS
GT2PN1:	JMP GTERR1
GT2PN2:	JMP GTERR2

;Gets one positive 16-bit integer.
GT1PIN:	JSR GT1FIX
CK1PIN:	LDX #NARG1
	JSR CHKPIN
	BCS GT2PN1
	RTS

SPLAYM: JSR MUSICP
	LDA NPARTS
	STA MPPRT	;current part number
	LDA MEACTP	;number parts with notes in them.
	STA MPACTP
	LDY NPARTS
	LDX #$00	;parameter index. #parsiz*(part.number-1)
ECPYLP:	LDA #$00
	STA TIME,X
	STA TIME+1,X
	STX TEMPN1
	STY COUNT
	LDY #$07	;zero loudns, down, desire, cursus
ECPY1:	STA LOUDNS,X
	INX
	DEY
	BPL ECPY1
	LDX TEMPN1
	LDY COUNT
;MSTART -> MPNXT
;MENXT -> MPEND
;MEDEAD -> MPDEAD
	LDA MSTART,X
	STA MPNXT,X
	LDA MSTART+1,X
	STA MPNXT+1,X
	LDA MENXT,X
	STA MPEND,X
	LDA MENXT+1,X
	STA MPEND+1,X
	LDA MEDEAD,X
	STA MPDEAD,X
	TXA
	CLC
	ADC #PARSIZ	;next parameter index.
	TAX
	DEY		;number of parts left to do.
	BNE ECPYLP
	LDA MPACTP
	BNE PMLUP
	JMP FINIS

PMLUP:	LDX #$00	;start with part 0. X is parameter index.
	STA $C070	;referencing this location resets the timer
;Process the envelope for each part.
;Compare the current loudness and the desired loudness.
;If it is too soft, make it louder. If it is too loud, make it softer. If
;it is just right, the attack or decay is over and we should shoot for
;the currently desired "sustain" (i.e., sustain or release) level.
;After all this, do the next part.
ENVLUP:	LDA LOUDNS,X
	SEC
	SBC DESIRE,X	;find difference between desired and current loudness.
	STA TEMPN1
	LDA LOUDNS+1,X
	SBC DESIRE+1,X
	BCC UPLD	;should be louder.
	ORA TEMPN1
	BNE DWNLD	;should be softer.
	LDA CURSUS,X	;right loudness
	STA DESIRE,X	;now we want to shoot for the sustain level.
	LDA CURSUS+1,X
	STA DESIRE+1,X
	BCS NEXTE		;(always) do next part
;We must be in the attack phase, since no other stage gets louder.
;Increment the current loudness by the attack rate, and compare the result
;to the desired loudness. If it is currently too loud, we have overshot, so
;make the current loudness be the desired loudness
;If it is now right, start the decay and send the pitch to the device.
UPLD:	LDA LOUDNS,X		;INCREMENT current loudness by attack rate
	ADC ATTACK,X
	STA LOUDNS,X
	LDA LOUDNS+1,X
	ADC ATTACK+1,X
	STA LOUDNS+1,X
	BCS ETHERE		;OVERFLOW: we got too loud, make it exact.
	TAY
	LDA LOUDNS,X
	CMP DESIRE,X
	TYA
	SBC DESIRE+1,X
	BCC SENDE	;not loud enough yet, but keep working later.
	BCS ETHERE	;too loud -- make it exact.
;We must be in the decay phase, since no other stage gets softer.
;Decrement the current loudness by the decay rate, and compare the result
;to the desired loudness. If it is currently too soft, we have undershot, so
;make the current loudness be the desired loudness.
;If it is now right, start the release and send the pitch to the device.
DWNLD:	LDA LOUDNS,X
	SBC DOWN,X
	STA LOUDNS,X
	LDA LOUDNS+1,X
	SBC DOWN+1,X
	STA LOUDNS+1,X
	BCC ETHERE	;UNDERFLOW: too soft, make it exact.
	LDA DESIRE,X
	CMP LOUDNS,X
	LDA DESIRE+1,X
	SBC LOUDNS+1,X
	BCS SENDE	;not soft enough, but keep working later.
;too soft, make it exact.

;Make the current loudness=desired loudness.
ETHERE:	LDA DESIRE,X
	STA LOUDNS,X
	LDA DESIRE+1,X
	STA LOUDNS+1,X
;and now we want to head for the sustain level (either the sustain level or 0 in release.)
	LDA CURSUS,X
	STA DESIRE,X
	LDA CURSUS+1,X
	STA DESIRE+1,X
;send the loudness to the thing.
SENDE:	LDA LOUDNS+1,X	;we have a sixteen bit number, but we only
	LSR A		;have four bits of amplitude control,
	LSR A		;so just take the top four bits of the
	LSR A		;most significant byte.
	LSR A
	EOR CHAN+1,X	;sneaky subtraction. CHAN+1,X=(32*CHAN)or$9F.
	ORA FUZZ,X	;mask for white noise.
	LDY CHAN,X	;channel number+16*slot
	STA $C080,Y
;....
;through with this one, now for next part.
NEXTE:	TXA 
	CLC
	ADC #PARSIZ	;advance parameter index to next
	TAX		;part's parameters.
	DEC MPPRT
	BEQ CONT1	;last part?
	JMP ENVLUP	;no -- do more parts.
;We've got the volume set for each note. Now handle their durations.
CONT1:	LDX #0		;Start again with first part. X is
			;parameter index.
;Now handle durations of notes. See if anyone is through this clock cycle.
LNGTH:	LDA MPDEAD,X
	BEQ NEXTL
	LDA TIME,X
	CMP GAP,X
	BNE MDECR	;unless the gap size=time remaining, not through.
	LDA TIME+1,X
	CMP GAP+1,X
	BNE MDECR
;this note is about to finish. start the release phase.
	LDA RELEAS,X	;make the current decay rate=the release rate
	STA DOWN,X
	LDA RELEAS+1,X
	STA DOWN+1,X
	LDA #$00	;and our desired (and sustain) level is zero.
	STA DESIRE,X	
	STA DESIRE+1,X
	STA CURSUS,X
	STA CURSUS+1,X
;decrement time remaining, and get next note if this one's through.
MDECR:	LDA TIME,X
	BNE MDECR1
	LDA TIME+1,X
	BEQ ENDNTE
MDECR1:	LDA TIME,X
	SEC
	SBC #$01
	STA TIME,X
	BCS NEXTL
	DEC TIME+1,X
NEXTL:	TXA		;handle the duration for the next part.
	CLC
	ADC #PARSIZ	;point to next set of part parameters.
	TAX
	INC MPPRT
	LDA MPPRT
	CMP NPARTS
	BNE LNGTH	;more parts to do.
;no more parts to do. Wait for the clock tick.
MWAIT:	BIT $C064
	BMI MWAIT
;that's it for this clock cycle. Calculate new amplitudes and see if
;any note is through again.
	JSR POLL
	JMP PMLUP
.PAGE
;This note has finished.
;Try to get another note. If there are no more, decrement
;the number of active parts and set the volume to 0. Set the dead flag
;to indicate that there are no more notes in this part. Handle the length
;for the next part. 
;If it is the last note of all, return to Logo.

;Otherwise, get the next note from this voice and process it.

DDERR:	JMP MUSBUG
ENDNTE:	JSR MGBCK
	BNE PROCES	;more notes. get one and handle it.
;no more notes in this voice. set the dead flag for this voice
;and set its volume to zero. Decrement number of active parts. If it is
;then zero, there are no more notes at all, so quit. If it is not zero,
;handle the next length to wait for something to happen.
	LDA MPDEAD,X
	BEQ DDERR	;bug if already dead.
	LDA #$00
	STA DESIRE,X
	STA DESIRE+1,X
	STA MPDEAD,X
	DEC MPACTP
	BEQ FINIS
	JMP NEXTL

FINIS:	JSR QUIETM	;make sure it shuts up.
	JMP POPJ

;This is the main note-processing loop. It is called whenever a note runs out,
;and gets the next note for the current part.
;Get a byte from a buffer and figure out what to do with it.
;If there aren't any more bytes in this particular part, then go to the next part
;and get the byte there. If there simply aren't any more notes, then quit.
;If a part never had anything in it to begin with, don't count it as having
;become inactive.

PROCES:	JSR MGTBYT	;Get the next character from the buffer indicated by X
;and increment.
	CMP #CREST	;the number for rest is HINOTE+1.
	BCS NPITCH	;Byte is >=#CREST, so it is a command.
;it's a pitch -- 0-71 decimal.
;get octave number.
	LDY #$00
DIVOCT:	CMP #OCTLEN
	BCC DIVOC1
	SBC #OCTLEN
	INY
	BNE DIVOCT
DIVOC1:	STY TEMPN1	;save quotient.
	ASL A		;make remainder a word index. (2 * pitch) -- pitch is [0,11]
	TAY
	LDA OCTAB+1,Y	;Yth divisor in the table.
	STA TEMPN2	;63920/this-num is frequency.
	LDA OCTAB,Y
	LDY TEMPN1	;Y is octave number again.
;rotate the number we got from the table to make it be in the right octave.
OCTAVE:	DEY
	BMI ROUND
	LSR TEMPN2	;it is a 12 bit number.
	ROR A
	JMP OCTAVE

ROUND:	ADC #$08
	BCC SENDP
	INC TEMPN2	;a carry.
;now we have the right divisor to send to the unit.
;all we have to do is get it in the right format and then find out
;where to send it.
;a contains lower 8 bits of divisor, tempn2 the upper 4.
SENDP:	ORA #$0F	;where we write the info.
	LSR A
	ROR A
	ROR A
	ROR A
	AND CHAN+1,X
	LDY CHAN,X	;The offset from the board's memory location
	STA $C080,Y
	JSR ALFWAT
	LDA TEMPN2
	STA $C080,Y	;rest of info for board.
;now start ADSR cycle.
	LDY #$06
	STX TEMPN2	;x is the param pointer for this part.
CYCLE:	LDA DECAY,X	;we're making
	STA DOWN,X	;DOWN=DECAY,DESIRE=VOLUME,CURSUS=SUSTAN
	INX		;increment index for which bytes to move
	DEY		;decrement number of bytes to move
	BNE CYCLE
	LDX TEMPN2	;restore param index after decrementing it.
;store the duration in TIME.
STORD:	JSR MGTBYT		;get this part's next byte.
	STA TIME,X
	JSR MGTBYT
	STA TIME+1,X
;that's it for this note or rest. Do the next one.
	JMP NEXTL
.PAGE
BADCOD:	JMP MUSBUG
;If we got here, the thing in A must not be a pitch. If the last comparison resulted
;in EQness, then it is a rest; otherwise, it is the result of an error.
NPITCH:	BNE BADCOD	;(just compared with 72) it is a command.
	LDA RELEAS,X
	STA DOWN,X
	LDA RELEAS+1,X
	STA DOWN+1,X
	LDA #$00
	STA DESIRE,X		;a rest has amplitude 0.
	STA DESIRE+1,X
	STA CURSUS,X
	STA CURSUS+1,X
;now store the duration.
	JMP STORD
.PAGE
;Utilities
;Utility. Store the byte in A in the location pointed to by MENXT,X MENXT+1,X.
;Increment MENXT,X, MENXT+1,X. Decrement Y, in case anybody uses it to
;keep track of how many bytes it has written.
;Doesn't check for error. You should call MCKBY first.
PUTBYT:	PHA
	STY TEMPN1
	LDA MENXT,X
	STA PARPNT
	LDA MENXT+1,X
	STA PARPNT+1
	LDY #$00
	PLA
	STA (PARPNT),Y
	INC MENXT,X
	BNE PBXIT
	INC MENXT+1,X
PBXIT:	LDY TEMPN1
	DEY
	RTS
;
;This is the MCKBY routine. It takes a number of bytes in Y and a
;parameter index in X. If the part indicated by X doesn't have at
;least Y bytes left, this routine errors out and doesn't return to the
;caller. If there are enough left, it returns.
;Subtracts the beginning of the next buffer from the current pointer.
;If the difference is less than the number of bytes to write, it
;errors out. Otherwise it returns.

;Additionally, this routine keeps track of the number of parts which
;actually have any notes in them. Each time it is called, it checks
;the MEDEAD flag for that part. If it is set (0), then no notes have
;ever been put into that part's buffer -- so it increments the number
;of active parts and clears the MEDEAD flag for the part.
MCKBY:	PHA
	LDA MEDEAD,X
	BNE MCKBY1
;This is the first time.
	LDA #$01
	STA MEDEAD,X
	INC MEACTP
MCKBY1:	LDA MEEND,X
	SEC
	SBC MENXT,X
	STA TEMPN1
	LDA MEEND+1,X
	SBC MENXT+1,X
	BNE MCKOK		;We can't want more than 255 bytes.
	CPY TEMPN1
	BCC MCKOK
	BEQ MCKOK
	ERROR XTMN		;Error (too many notes) resets the stack pointer.
MCKOK:	PLA
	RTS

;This routine expects a parameter index in X.
;If this part is dead, error out.
;Otherwise, return the next byte from that part buffer and increment the pointer.
MGTBYT:	LDA MPDEAD,X
	BEQ MGBERR
	STY TEMPN2
	LDY #$00
	LDA MPNXT,X
	STA PARPNT
	LDA MPNXT+1,X
	STA PARPNT+1
	LDA (PARPNT),Y
	TAY
	INC MPNXT,X
	BNE MGTBE
	INC MPNXT+1,X
MGTBE:	LDY TEMPN2
	RTS    

;check this part to see if there is note left in it. return 0 in A if there
;aren't. Otherwise, return non-zero in A.
;If the current part pointer is the same as the end pointer, ther are no
;more bytes.
MGBCK:	LDA MPNXT+1,X
	CMP MPEND+1,X
	BEQ MGBCK1
	BCC MGBOK		;more bytes.
MGBERR:	JMP MUSBUG		;Way past end of buffer.
MGBCK1:	LDA MPNXT,X
	CMP MPEND,X
	BEQ MGBNOK		;no more bytes.
	BCS MGBERR		;Past end of buffer.
MGBOK:	LDA #$01		;<>0 means more bytes.
	RTS
MGBNOK:	LDA #$000		;=0 means no more bytes.
	RTS

;This routine gets the number to store in chan+1,x from the channel number,
;given in A.
GETCHN:	LSR A
	ROR A
	ROR A
	ROR A
;In one place, CHAN+1 is eor'd with the high four bits of the current
;loudness put in the low four bits. This makes the result be $9F+$20*C-V.
;So this part constant is $9F+$20*C.
	ORA #$9F
	RTS

;this routine moves narg1 and narg2 to the parameter for the current voice
;indicated by A.
MTN12A:	CLC
	ADC MEPRT
	TAY
	LDA NARG1
	STA TIME,Y
	LDA NARG1+1
	STA TIME+1,Y
	LDA NARG2
	STA TIME+2,Y
	LDA NARG2+1
	STA TIME+3,Y
	RTS
;Check to see if in music mode. If not, error out to top level.
;Otherwise return.
MUSICP:	LDA NPARTS
	BEQ NOTMUS
	BMI NOTMUS
	RTS
NOTMUS:	ERROR XNTM	;error restores the stack.
.PAGE
MSLOTI	=$40		;Initial slot number assumed for music card.

;Command parameters.
;Put them in the Hi-res graphics page.
TIME	=$2000		;must be first
ATTACK	=$2002		;these five must be contiguous
DECAY	=$2004
VOLUME  =$2006
SUSTAN	=$2008
RELEAS	=$200A
GAP	=$200C		;these two must be contiguous
CHAN	=$200E
LOUDNS	=$2010
DOWN	=$2012		;these 3 must be contiguous
DESIRE	=$2014
CURSUS	=$2016
FUZZ	=$2018		;note that FUZZ is a byte.
MEDEAD	=$2019		;MEDEAD is also a byte.
MPDEAD	=$201A		;DEAD flag for PM. A byte.
MSTART	=$201B		;starting address of buffer.
MENXT	=$201D		;pointer to place where next note
			;should put. initialized to start of buffer.
MEEND	=$201F		;beginning of next buffer.
MPNXT	=$2021		;next note to be played. initialized
			;to beginning of buffer.
MPEND	=$2023		;one past last note to be played.
			;initialized to MENXT.
;Here are the defaults for each part.
PARAMS:	.ADDR $0000	;TIME
	.ADDR $2000	;ATTACK
	.ADDR $0019	;DECAY
	.ADDR $D600	;VOLUME
	.ADDR $D600	;SUSTAN
	.ADDR $05DC	;RELEAS
	.ADDR $0016	;GAP
PARCHA:	.ADDR $0000	;CHAN
	.ADDR $0000	;LOUDNS
	.ADDR $0000	;DOWN
	.ADDR $0000	;DESIRE
	.ADDR $0000	;CURSUS
	.BYTE $00	;FUZZ
	.BYTE $00	;MEDEAD
	.BYTE $00	;MPDEAD
PSTART:	.ADDR $0000	;MSTART
PENXT:	.ADDR $0000	;MENXT
PEEND:	.ADDR $0000	;MEEND
	.ADDR $0000	;MPNXT
	.ADDR $0000	;MPEND
PARSIZ=.-PARAMS

;Table of divisors for octaves.
OCTAB:	.ADDR 15632		;C
	.ADDR 14752		;C#
	.ADDR 13936		;D
	.ADDR 13152		;D#
	.ADDR 12416		;E
	.ADDR 11712		;F
	.ADDR 11056		;F#
	.ADDR 10432		;G
	.ADDR 9856		;G#
	.ADDR 9296		;A
	.ADDR 8768		;A#
	.ADDR 8288		;B
OCTLEN	=<.-OCTAB>/2
.ENDC
.IFEQ MUSINC
;		Dummy music routines
MSINIT	=.
QUIETM:	RTS
.ENDC
ZZZZZZ=.	;(Label quickly noticeable in symbol table)
.PRINT ZZZZZZ	;LAST LOCATION - BETTER BE UNDER $9780. (9AA0 absolute limit).
.PAGE
.SBTTL	Input/Output Utilities

.=OCODE		;Code goes before graphics buffer

SETUP:	LDA GETRM1	;Monitor "G" command re-enters here
	LDA GETRM1	;Enable high RAM
	JSR RSTIO	;Restore I/O Drivers
	JSR RESETT
	JSR CLRMRK	;In case of gcol crash
	LDA #$00
	STA $00		;Re-init Lnil for conses!
	STA $01
	STA $02
	STA $03
	JMP CLRCBF

REENT:	JSR SETUP
	JMP TOPLOP

CLRCBF:	LDA CHBUFR	;Buffer empty when next-free equals next-to-read
	STA CHBUFS
	LDA KBDCLR
	RTS

;entry points for .CALL
VOTFX2:	LDY #NARG2
VOTFIX:	JSR GRM1
	JMP OTPFIX	
VPNTBE:	JMP PNTBEG
VVPLFL:	JSR GRM1
	JMP VPLFLS
VVPLTR:	JSR GRM1
	JMP VPLTRU
VPPTTP:	JSR GRM1
	JMP PPTTP


GTBUF:	SEC
	LDA CHBUFR
	SBC CHBUFS
	AND #$3F
	BEQ GTBRTS	;Return zero if buffer empty (CHBUFR = CHBUFS)
	LDA CHBUFR
	AND #$3F
	TAX
	LDA CHBSTT,X
	INC CHBUFR	;Increment next-to-read
GTBRTS:	RTS

;Reset and clear the screen.
RESETT:	LDA GRPHCS
	BPL RESTT1	;OK if music mode
	LDA #$00
	INC GRPHCS	;Clear graphics flag
RESTT1:	JSR SETTXT	;Set up text screen
	JSR SETNRM	;Normal characters
	JMP HOME	;Clearscreen and home cursor

;TPCHR should always be called with an Ascii character.
;If you want it to flash or be inverted, call SETFLS or SETINV first,
;and call SETNRM when done. The output routine should not bash Y.
;TPCHR enables the monitor so fucked up peripheral routines can do JSR $FFCB
;to find out what slot they are in.  I wish I were so smart.
BREAK1:	LDA #$0D
TPCHR:	BIT KILRAM		;BIT doesn't trash any registers, but
	JSR TPCHR1
	BIT GETRM1		;references memory.
	BIT GETRM1
	RTS
TPCHR1:	JMP (OTPDEV)
.PAGE
;Reset I/O to default drivers and mode.
RSTIO:	LDA #$00
	STA INPFLG	;Reset from read-eval mode
RSTIO1:	STA OTPFLG	;Reset from print-to-buffer mode
	STA PRSFLG	;Do this in case resetting from READLINE state
	JSR SETVID	;Set output driver to screen
SETKBD:	MOV INPDEV,DEFINP	;Set input driver to default input.
	RTS

SETVID:	MOV OTPDEV,DEFOUT	;Set output driver to default output.
	RTS

SETFLS:	LDA #$40
	BNE SETIFL	;(Always)
SETINV:	LDA #$00
	BEQ SETIFL	;(Always)
SETNRM:	LDA #$80	;(Negative flag ignored)
SETIFL:	STA INVFLG
	RTS
.PAGE
BELL:	LDA #$40
	JSR WAIT
	LDY #$C0
BELL1:	LDA #$0C
	JSR WAIT
	LDA SPKR
	DEY
	BNE BELL1
BRTS:	RTS

;HOME - Home the cursor and clear the screen
HOME:	LDA WNDTOP
	STA CV
	LDY #$00
	STY CH
	BEQ CLEOP1	;(always branches)

;CLREOP - Clear to end-of-page
CLREOP:	LDY CH
	LDA CV
CLEOP1:	PHA
	JSR BCALCA
	JSR CLEOL1
	LDY #$00
	PLA
	ADC #$00
	CMP WNDBTM
	BCC CLEOP1
	JMP BCALC	;(Always)
.PAGE
APOUT:	PHA		;Save A for DOS
	AND #$7F	;change Apple idiot char codes to type Ascii
	JSR COUT	;type the character
	PLA		;Get A back for DOS
	RTS

COUT:	STY YSAV1	;Save Y
	JSR COUT1
	LDY YSAV1	;Get Y back
	RTS

;COUT1 - Output the character in A to the screen
COUT1:	CMP #$0D
	BEQ CROUT
	CMP #$07
	BEQ BELL	;bell on output of ^G
	ORA #$80	;Assume normal first
	CMP #$E0
	BCC COUTZ	;See if it's lower case
	AND #$DF	;Make it uppercase if so
COUTZ:	LDY INVFLG	;Flash or Invert if set
	BMI COUTZ1
	AND #$3F	;Flash or invert - strip top bits
	ORA INVFLG	;and OR in flag
COUTZ1:	LDY CH
	STA (BASLIN),Y
;GETLN enters here
CHADV:	INC CH		;Advance Horizontally
	LDA CH
	CMP WNDWTH
	BCC BRTS	;Done if not EOL, else do a CR
	BCS CR		;(Always)
CROUT:	JSR CLREOL	;CR output, clear-to end-of line first
CR:	JSR POLL	;Poll at very eol
	LDA #$00	;CR: Go to beginning of line
	STA CH		;and do a LF
LF:	INC CV		;LF: Go to next line
	LDA CV
	CMP WNDBTM
	BCC BCALCA	;If not bottom of screen, calc. new baseline and return.
	DEC CV		;Else scroll: take back the LF first
SCROLL:	LDA WNDTOP	;Scroll: push initial screen line (window top)
	PHA
	JSR BCALCA	;Calculate this baseline
SCRL1:	MOV BSLTMP,BASLIN	;Save baseline
	LDY WNDWTH
	DEY		;Window width minus 1 in Y
	PLA		;Get line no.
	ADC #$01	;Add one to get next line no.
	CMP WNDBTM	;See if below window bottom yet
	BCS SCRL3	;At bottom
	PHA		;Not at bottom, push next line no.
	JSR BCALCA	;Calculate base line for it
SCRL2:	LDA (BASLIN),Y	;Shift a line up one, character by character
	STA (BSLTMP),Y
	DEY
	BPL SCRL2	;Next character
	BMI SCRL1	;Next line
SCRL3:	LDY #$00	;At bottom of screen
	JSR CLEOL1	;Clear the bottom line, then calculate new base
;	...
.PAGE
;	...
BCALC:	LDA CV
BCALCA:	PHA		;Save line no.
	LSR A
	AND #$03
	ORA #$04
	STA BASLIN+1
	PLA
	AND #$18
	BCC BCALC2
	ADC #$7F
BCALC2:	STA BASLIN
	ASL A
	ASL A
	ORA BASLIN
	CLC
	ADC WNDLFT
	STA BASLIN
	RTS

;CLREOL - Clear to end-of-line
CLREOL:	LDY CH
CLEOL1:	LDA #$A0	;(Space, non-flashing, non-inverted)
CLEOL2:	STA (BASLIN),Y
	INY
	CPY WNDWTH
	BCC CLEOL2
	RTS



RDKEY:	JSR GTBUF	;Get character from the buffer if non-empty
	TAX
	BNE KRTS
	BIT KILRAM	;For Apple peripherals which want monitor.
	JSR RDKHAK
	EOR #$80	;complement hi bit, since INPDEV is an apple
	BIT GETRM1	;peripheral routine, or something that looks like one.
	BIT GETRM1
	RTS
RDKHAK:	JMP (INPDEV)

;Keyboard input routine.
KEYIN:	LDY CH
	LDA (BASLIN),Y
	PHA		;Save character under cursor
	AND #$7F
	ORA #$40
	STA (BASLIN),Y	;Make cursor position flash
	JSR RDKEY1	;Waits until a character appears
	BIT KBDCLR	;Reset kbd strobe
	TAX
	PLA		;Retrieve character under cursor
	STA (BASLIN),Y	;Put it back
	TXA
	EOR #$80	;Complement hi bit to convert from regular ascii
KRTS:	RTS		;to apple ascii, so that RDKEY can complement and
			;undo it.  This routine should act like an apple
			;peripheral routine wrt the hi bit.
;Wait for a kbd character. Don't mash Y!
RDKEY1:	INC1 RNDL	;Update random number seed
	JSR TSTCHR	;Test the kbd flag, get char. (carry clear if got one)
	BCC RDKEY1	;Keep waiting
	RTS
.PAGE
;Check for input character. Return with carry set and character in A if
;character pending, else carry clear. Supplies "[" for "M" and $FF for null
;replacement characters. Don't mash Y!
TSTCHR:	BIT KBDBYT
	BPL KNONE
	LDA KBDBYT
	EOR #$80	;Complement hi bit to convert to ascii.
	BNE TSTC1
	LDA #$FF	;translation for null character so it can't be typed.
	SEC
	RTS
TSTC1:	CMP #LBRAK
	BNE TRTS1
	LDA #'[
TRTS1:	SEC
	RTS
KNONE:	CLC		;Return carry clear if no character
	RTS

;SETTXT - Set text mode
SETTXT:	LDA PRMPAG	;Primary page
	LDA TXTMOD	;Set text mode
	LDA #$00	;Full screen window
	STA WNDTOP
	STA WNDLFT
	LDA #$18
	STA WNDBTM
	LDA #$28
	STA WNDWTH
	LDA #$17
	STA CV
	JMP BCALCA	;Calculate baseline
.PAGE
WAIT:	SEC
WAIT1:	PHA
WAIT2:	SBC #$01
	BNE WAIT2
	PLA
	SBC #$01
	BNE WAIT1
	RTS

;Break to ROM Monitor
MONBRK:	STA MONACC	;Save A for monitor
	TXA
	PHA		;Save X
	TYA
	PHA		;Save Y
	LDA KILRAM
	JSR ROMSTN	;Init monitor stuff
	JSR ROMNIT
	JSR ROMSTV	;Reset I/O Drivers
	JSR ROMSTK
	SETV MONBKV,MONOBK	;Set Monitor BRK vector
	PLA
	TAY		;Retrieve Y
	PLA
	TAX		;Retrieve X
	JMP ROMMON
.PAGE
;	Local variable block:
CHRIND	=TEMPNH		;Temp. char. index
CHRND1	=TEMPNH+1	;Alt. temp. char. index
CHRND2	=TEMPN		;Alt. temp. char. index

;Gets a line of input from the keyboard. Looks for Logo interrupt
;characters. Line is terminated with a CR.
;Assumes at least one CR someplace in the buffer already.
;A CR is initially inserted, to delimit the previous line.
;Insertion moves all characters up one. Control-p works by
;finding the first CR and inserting characters until the next CR
;or end-of-buffer.
;If an insert would push the first CR out of the buffer, a bell
;is given.
GETLN:	LDA #$00
	STA CHRIND
	LDX #$FF
GETLN1:	LDA PRSBUF-1,X
	STA PRSBUF,X
	DEX
	BNE GETLN1
	LDA #$0D	;Initially insert a CR (without moving point)
	STA PRSBUF	
NEXTC:	JSR RDKEY	;Get an ascii value from keyboard (or buffer)
	JSR CKINTS	;Check for interrupts
	BCC NEXTC	;Try again if intercepted
	CMP #$08	;(<-)
	BEQ GTBAK
	CMP #$15	;(->)
	BEQ GTFWD
	CMP #$04	;(^D)
	BEQ GTDEL
	CMP #$1B	;(ESC) - Rubout
	BEQ GTRUB
	CMP #$01	;(^A)
	BEQ GTBEG
	CMP #$05	;(^E)
	BEQ GTEND
	CMP #$0B	;(^K)
	BEQ GTCAN
	CMP #$0D	;(CR)
	BEQ GTCR
	CMP #$10	;(^P) - Insert previous line
	BEQ GTPRV
	CMP #PAUSKY	;(^Z) - Pause key.  Makes sense only inside request.
	BEQ GTPZ
	CMP #$20	;Lowest allowable character
	BCC BADCHR	;(anything above is legal)
GTINS:	JSR GTINS1	;Insert the character, move the point forward
	JMP NEXTC	;Get the next one

BADCHR:	JSR BELL
	JMP NEXTC

GTBAK:	JSR GTBAK1
	JMP NEXTC

GTFWD:	JSR GTFWD1
	JMP NEXTC

GTDEL:	JSR GTDEL1
	JMP NEXTC

;Rubout: go back one and do a delete.
GTRUB:	JSR GTBAK1
	JSR GTDEL1
	JMP NEXTC

GTBEG:	LDA CHRIND	;Back to beginning
	BEQ NEXTC	;Continue if there else
	JSR GTBAK1	;Move back one
	JMP GTBEG	;And do it again

;Go to end-of-line.
GTEND:	LDX CHRIND
	LDA PRSBUF,X
	CMP #$0D
	BEQ NEXTC
	JSR GTFWD1
	JMP GTEND

;Delete to end-of-line: delete chars until on a CR.
GTCAN:	LDX CHRIND
	LDA PRSBUF,X	;What are we on?
	CMP #$0D
	BEQ NEXTC	;A CR, so continue
	JSR GTDEL1	;Else delete it!
	JMP GTCAN	;And do it again

;Pause key. Valid only if inside request (prsflg <0)
GTPZ:	LDA PRSFLG
	BPL BADCHR
	JMP SPZR	;execute the pause.

;Carriage-return: move fwd until on a CR.
GTCR:	LDX CHRIND
	LDA PRSBUF,X	;See what we're on
	CMP #$0D	;Is it a CR
	BEQ GTCR1	;Yes, almost done
	JSR GTFWD1	;Else move forward
	JMP GTCR	;And try again
GTCR1:	JMP BREAK1	;Terminate screen line and exit

;Previous-line insert: do an insert for every character
;after the first CR until the second or EOL.
GTPRV:	LDX CHRIND
GTPRV1:	LDA PRSBUF,X	;See what we're on
	CMP #$0D
	BEQ GTPRV2	;CR, go to insert-loop
	INX		;Else look at next character
	BNE GTPRV1	;(Always)
GTPRV2:	INX		;We're here, go to first/next character
	BEQ NEXTCJ	;There aren't any, so done
	STX CHRND2	;Used to index the previous line
	LDA PRSBUF,X	;Get the character
	CMP #$0D
	BEQ NEXTCJ	;It's a CR, we're done
	JSR GTINS1	;Else insert it and move forward
	LDX CHRND2	;and continue loop
	INX		;Incr. once more since Insert shifts everything over
	BNE GTPRV2
NEXTCJ:	JMP NEXTC	;Done

GTFWD1:	LDX CHRIND	;Forward
	LDA PRSBUF,X	;What are we on top of?
	CMP #$0D
	BEQ GTFWD2	;A CR, so insert space
	INX		;Increment char-index
	BEQ GTBAKB	;If at end of buffer, complain
	STX CHRIND
	JMP CHADV	;Update cursor position and continue
GTFWD2:	LDA #$20
	JMP GTINS1	;Insert a space and move forward

GTBAK1:	LDX CHRIND	;Back
	BEQ GTBAKB	;If at beginning of line, complain
	DEX		;Decrement char-index
	STX CHRIND
	DEC CH		;Update cursor position
	BMI GTUPLN	;Hack cursor position if past left screen edge
	LDA WNDLFT
	BEQ GTBAK2	;If WNDLFT zero and CH positive, okay
	CMP CH		;Else see if CH is less than WNDLFT
	BEQ GTBAK2	;Ok if equal
	BCC GTBAK2	;OK if CH greater
GTUPLN:	LDA WNDWTH	;Go to last position on line above
	STA CH
	DEC CH		;(WNDWTH is length, decrement for last position)
	DEC CV		;(Can't be at top of screen, fortunately)
	JMP BCALC	;Get new baseline, too
GTBAKB:	JSR BELL	;Complain
	PLA		;Zap return address
	PLA
	JMP NEXTC	;Continue munching
GTBAK2:	RTS		;Nope, continue

GTDEL1:	LDX CHRIND
	LDA PRSBUF,X	;See what we're on
	CMP #$0D
	BEQ GTBAKB	;If CR, complain
	LDA CH
	PHA		;Save the cursor state and char-index. on the stack
	LDA CV
	PHA
	LDA BASLIN
	PHA
	LDA BASLIN+1
	PHA
	TXA
	PHA
GTDELL:	LDX CHRIND	;Here's the loop.
	LDA PRSBUF+1,X	;Get the next character
	STA PRSBUF,X	;Put it here
	INC CHRIND	;Next character
	CMP #$0D
	BEQ GTDEL2	;If it's a cr, don't show or update
	JSR TPCHR	;Show it, and update the cursor position
	JMP GTDELL	;Go do it
GTDEL2:	LDA #$20	;At first CR, type a space
	JSR TPCHR	;to cover the last character over
	LDX CHRIND	;Then move everything back, not showing anything
GTDEL3:	LDA PRSBUF+1,X
	STA PRSBUF,X
	INX
	BNE GTDEL3	;Put a CR in the last position
	LDA #$0D
	STA PRSBUF+$FF
GTDEL4:	PLA		;All done, restore char-index and cursor position
	STA CHRIND
	PLA
	STA BASLIN+1
	PLA
	STA BASLIN
	PLA
	STA CV
	PLA
	STA CH
	RTS

;Insert character: First, find CR. If it's in last position, buffer is
;full so complain. Else move everything over, typing chars. only up to first CR.
GTINS1:	STA CHRND1	;Save character
	LDX CHRIND
GTINS2:	LDA PRSBUF,X	;Loop until we're on a CR
	CMP #$0D
	BEQ GTINS3
	INX
	BNE GTINS2	;(Always)
GTINS3:	INX		;See if X is #$FF
	BEQ GTBAKB	;Yup, complain
	LDA CHRIND	;Save the char-index. on the stack
	PHA
GTINS4:	LDX CHRIND
	LDA PRSBUF,X	;Get the char we're on
	PHA		;Save it
	LDA CHRND1	;Get the displaced/insert char.
	STA PRSBUF,X	;Put it here
	CMP #$0D	;If it's a CR, loop without typing
	BEQ GTINS5
	JSR TPCHR	;Else type it
	PLA		;Get the displaced char back
	STA CHRND1
	INC CHRIND	;Increment char-index, do next char.
	BNE GTINS4	;(Always)
GTINS5:	PLA		;Get displaced char. back
	STA CHRND1
	INX		;Increment index, do next char.
	BEQ GTINS6	;When done, clean up
	LDA PRSBUF,X	;Get the char. we're on
	PHA		;Save it
	LDA CHRND1	;Get the displaced char.
	STA PRSBUF,X	;Put it here
	JMP GTINS5	;Do next char.
GTINS6:	PLA		;Restore char-index
	STA CHRND1
	INC CHRND1
GTINS7:	LDA CHRIND
	CMP CHRND1	;Backup until CHRIND has original value plus one
	BEQ GTINS8
	JSR GTBAK1
	JMP GTINS7
GTINS8:	RTS
.PAGE
;Editor output routine.
;Prints the character in A at the point in the buffer. Does NOT
;increment ENDBUF.  Does nothing if at physical end of buffer.

EDOUT:	TAX		;save char
	LDA EPOINT+1
	CMP #EBFEND^
	BCC EDOUT1
	BNE GTINS8	;Just return.
	LDA EPOINT
	CMP #EBFEND&$FF	;Are we at end of edit buffer...
	BCS GTINS8	;if so, quit
EDOUT1:	STY YSAV1
	LDY #$00
	TXA
	STA (EPOINT),Y	;if not, store char and inc pointer
	LDY YSAV1
	JMP INCPNT

;This routine sets the end of the buffer to the point.  Cleanup
;routine for EDOUT.
ENDPNT:	MOV ENDBUF,EPOINT
	RTS

.PRINT .-OCODE	;LENGTH OF SEPARATED CODE - BETTER BE LESS THAN $400!!
.PAGE
.SBTTL	Ghost-Memory Storage
.SBTTL		Primitive Address Table

.=SYSTAB*$100		;Original load area
	.ADDR	SINDXR
;	Arithmetic:
	.ADDR	SUNSUM
	.ADDR	SUNDIF
	.ADDR	SSUM
	.ADDR	SDIF
	.ADDR	SPROD
	.ADDR	SDIVID
	.ADDR	SQTENT
	.ADDR	SRMNDR
	.ADDR	SROUND
	.ADDR	SSIN
	.ADDR	SCOS
	.ADDR	STWRDS
;	Boolean:
	.ADDR	SGRTR
	.ADDR	SLESS
	.ADDR	SEQUAL
	.ADDR	SNOT
	.ADDR	SAND
	.ADDR	SOR
	.ADDR	STHNGP
	.ADDR	SWORDP
	.ADDR	SLISTP
	.ADDR	SNMBRP
	.ADDR	SCRCP
;	Word/list:
	.ADDR	SFIRST
	.ADDR	SLAST
	.ADDR	SBTFST
	.ADDR	SBTLST
	.ADDR	SWORD
	.ADDR	SFPUT
	.ADDR	SLPUT
	.ADDR	SLIST
	.ADDR	SSNTNC
;	Miscellaneous:
	.ADDR	SMAKE
	.ADDR	SOUTPT
	.ADDR	SSTOP
	.ADDR	SCOMMT
	.ADDR	SCNTIN
	.ADDR	STEST
	.ADDR	SIFT
	.ADDR	SIFF
	.ADDR	SIF
	.ADDR	STHEN
	.ADDR	SELSE
	.ADDR	SGO
	.ADDR	SRUN
	.ADDR	SRPEAT
	.ADDR	SREQU
	.ADDR	STHING
	.ADDR	SGCOLL
	.ADDR	SNODES
	.ADDR	SDEFIN
	.ADDR	STEXT
	.ADDR	STO
	.ADDR	SEDIT
	.ADDR	SEND
	.ADDR	SPRINT
	.ADDR	SPRNT1
	.ADDR	SPO
	.ADDR	SPOTS
	.ADDR	SERASE
	.ADDR	SERNAM
	.ADDR	SQFIER	;All
	.ADDR	SQFIER	;Names
	.ADDR	SQFIER	;Titles
	.ADDR	SQFIER	;Procedures
	.ADDR	STRACE
	.ADDR	SNTRAC
	.ADDR	SRANDM
	.ADDR	SRNDMZ
	.ADDR	SREADC
	.ADDR	SCURSR
	.ADDR	SCLINP
	.ADDR	SCLEAR
	.ADDR	SPADDL
	.ADDR	SEXAM	
	.ADDR	SDEP
	.ADDR	SCALL
	.ADDR	SPAUSE
	.ADDR	SBPT
	.ADDR	PPTTP
	.ADDR	LOGO1	;Goodbye
	.ADDR	PARLOP	;(left-parenthesis)
	.ADDR	SRPAR	;(right-parenthesis)
	.ADDR	SPDBTN
;	Filing:
	.ADDR	SREAD
	.ADDR	SSAVE
	.ADDR	SDELET
	.ADDR	SCATLG
	.ADDR	SERPCT
;new primitives here.
	.ADDR	SNUMOF
	.ADDR	SLETOF
	.ADDR	SINT
	.ADDR	SSQRT
	.ADDR	SINADR
	.ADDR	SOTADR
.IFNE GRPINC
;	Graphics:
	.ADDR	SFD
	.ADDR	SBK
	.ADDR	SRT
	.ADDR	SLT
	.ADDR	SDRAW
	.ADDR	SHOME
	.ADDR	SPENUP
	.ADDR	SPENDN
	.ADDR	SSHOWT
	.ADDR	SHIDET
	.ADDR	STS
	.ADDR	SNDSPL
	.ADDR	SSETX
	.ADDR	SSETY
	.ADDR	SSETXY
	.ADDR	SSETH
	.ADDR	SSETT
	.ADDR	SXCOR
	.ADDR	SYCOR
	.ADDR	SHDING
	.ADDR	SFULL
	.ADDR	SSPLIT
	.ADDR	SRDPCT
	.ADDR	SSVPCT
	.ADDR	SYSBUG ;SPALET
	.ADDR	SPENC
	.ADDR	SCS
	.ADDR	SBKGND
	.ADDR	SSCNCH
.ENDC
.IFNE MUSINC
;	Music:
	.ADDR	SVOICE
	.ADDR	SNVOIC
	.ADDR	SPLAYM
	.ADDR	SNOTE
	.ADDR	SAD
	.ADDR	SVS
	.ADDR	SRG
	.ADDR	SFZ
	.ADDR	SSVMUS
	.ADDR	SRDMUS
	.ADDR	SERMUS
.ENDC	;musinc
.PAGE
.SBTTL		Error Message Address Table

ERRTBL=.+TDIFF

	.ADDR	0
	.ADDR	XXUOP+TDIFF
	.ADDR	XXEOL+TDIFF
	.ADDR	XXUDF+TDIFF
	.ADDR	XXHNV+TDIFF
	.ADDR	XXNIP+TDIFF
	.ADDR	XXNOP+TDIFF
	.ADDR	XXRPN+TDIFF
	.ADDR	XXIFX+TDIFF
	.ADDR	XXNTM+TDIFF
	.ADDR	XXTIP+TDIFF
	.ADDR	XXWTA+TDIFF
	.ADDR	XXUBL+TDIFF
	.ADDR	XXNTL+TDIFF
	.ADDR	XXNTF+TDIFF
	.ADDR	XXELS+TDIFF
	.ADDR	XXBRK+TDIFF
	.ADDR	XXLAB+TDIFF
	.ADDR	XXTHN+TDIFF
	.ADDR	XXLNF+TDIFF
	.ADDR	XXETL+TDIFF
	.ADDR	XXNED+TDIFF
	.ADDR	XXOPO+TDIFF
	.ADDR	XXDBZ+TDIFF
	.ADDR	XXOFL+TDIFF
	.ADDR	XXNDF+TDIFF
	.ADDR	XXCRS+TDIFF
	.ADDR	XXOOB+TDIFF
	.ADDR	XXIOR+TDIFF
	.ADDR	XXWTP+TDIFF
	.ADDR	XXFNF+TDIFF
	.ADDR	XXDKF+TDIFF
	.ADDR	XXLKF+TDIFF
	.ADDR	XXTMN+TDIFF
	.ADDR	XXNTM+TDIFF
	.ADDR	XXSYN+TDIFF
	.ADDR	XXRNG+TDIFF
	.ADDR	XXLB1+TDIFF
	.ADDR	XXCED+TDIFF
	.ADDR	XXUOPT+TDIFF

ZAPTBL=.+TDIFF
	.ADDR	ZPMSG0+TDIFF
	.ADDR	ZPMSG1+TDIFF
	.ADDR	ZPMSG0+TDIFF
	.ADDR	ZPMSG2+TDIFF
	.ADDR	ZPMSG3+TDIFF
	.ADDR	ZPMSG4+TDIFF
	.ADDR	ZPMSG5+TDIFF
	.ADDR	ZPMSG6+TDIFF
	.ADDR	ZPMSG7+TDIFF
.PAGE
.SBTTL		Error Messages

;Error Message String format:
;	$00 Terminates string
;	$01 Print <Y argument to ERROR>
;	$02 Print <X argument to ERROR>
;	Anything else is printed as an Ascii character

XXUOP:	.ASCII "You don't say what to do with "
	$01
	$00
XXEOL:	.ASCIZ "Missing Inputs"
XXUDF:	.ASCII "There is no procedure named "
	$01
	$00
XXHNV:	.ASCII "There is no name "
	$01
	$00
XXNIP:	.ASCIZ "Nothing inside parentheses"
XXNOP:	$01
	.ASCIZ " didn't output"
XXRPN:	.ASCIZ "Missing inputs inside ()'s"
XXIFX:	$01
	.ASCIZ " needs something before it"
	$00
XXTIP:	.ASCIZ "Too much inside parentheses"
XXWTA:	$01
	.ASCII " doesn't like "
	$02
	.ASCIZ " as input"
XXUBL:	$01
	.ASCIZ " is a Logo primitive"
XXNTL:	$01
	.ASCIZ " should be used only inside a procedure"
XXNTF:	$01
	.ASCII " doesn't like "
	$02
	.ASCII " as input. It expects"
	.ASCIZ " TRUE or FALSE"
XXELS:	.ASCIZ "ELSE is out of place"
XXBRK:	.ASCIZ "Pause"
XXLAB:	.ASCII "The : is out of place at "
	$02
	$00	
XXTHN:	.ASCIZ "THEN is out of place"
XXLNF:	.ASCII "There is no label "
	$01
	$00
XXETL:	$01
	.ASCIZ " cannot be used inside the editor"
XXNED:	.ASCIZ "END should be used only in the editor"
XXOPO:	$01
	.ASCII " should be an input only to"
	$0D
	.ASCIZ "PRINTOUT, ERASE or EDIT"
XXDBZ:	.ASCIZ "Can't divide by zero"
XXOFL:	.ASCIZ "Number out of range"
XXNDF:	.ASCII "There is no procedure named "
	$01
	$00
XXCRS:	.ASCIZ "Cursor coordinates off of screen"
XXOOB:	.ASCIZ "Turtle out of bounds"
XXIOR:	.ASCIZ "Disk error"
XXWTP:	.ASCIZ "The disk is write protected"
XXFNF:	.ASCIZ "File not found"
XXDKF:	.ASCIZ "The disk is full"
XXLKF:	.ASCIZ "The file is locked"
.IFNE MUSINC
XXTMN:	.ASCIZ "Too many notes"
XXNTM:	.ASCIZ "You haven't set NVOICES yet"
.ENDC ;musinc
.IFEQ MUSINC
XXTMN:
XXNTM: $00
.ENDC ;musinc
XXSYN:	.ASCIZ "Unable to understand filename"
XXRNG:	.ASCIZ "There's nothing to save"
XXLB1:	.ASCIZ "Labels can be used only inside procedures"
XXCED:	$01
	.ASCIZ " is a Logo primitive"
XXUOPT:	.ASCII "Result: "
	$01
	$00

ZPMSG0:	.ASCIZ "No storage left!"
ZPMSG1:	.ASCIZ "Stopped!"
ZPMSG2:	.ASCIZ "Too many procedure inputs"
ZPMSG3:	.ASCIZ "Procedure"
ZPMSG4:	.ASCIZ "Tail-recursive"
ZPMSG5:	.ASCIZ "Parenthesis"
ZPMSG6:	.ASCIZ "IF-THEN"
ZPMSG7:	.ASCIZ "Evaluation"
ZPMX1:	.ASCIZ " nesting too deep"
.PAGE
.SBTTL		Miscellaneous Messages

;Terminated by $00

HELSTR=.+TDIFF
	.ASCII "         Logo for the Apple II"
	$0D
	.ASCII "written by S. Hain, P. Sobalvarro"
	$0D
	.ASCII "and L. Klotz under the supervision"
	$0D
	.ASCII "of H. Abelson."
	$0D
	$0D
.IFNE MUSINC
	.ASCII "Music version"
	$0D
.ENDC
	.ASCII "Copyright (C) 1980, 1981 MIT"
	$0D
	.ASCII "All rights reserved"
	$0D
	.ASCII "This version assembled 7/9/81."
	$0D
	$0D
	.ASCII "Welcome to Logo"
	$0D
	$00
LBUG1=.+TDIFF
	$0D
	.ASCII "Logo system bug; entering Apple Monitor"
	$0D
	$00
RDRER2=.+TDIFF
	.ASCII "Ignoring unmatched right-bracket"
	$0D
	$00
WRNMSG=.+TDIFF
	.ASCII "Please ERASE something."
	$0D
	$00
ERRM1=.+TDIFF
	.ASCIZ ' " at level '
ERRM2=.+TDIFF
	.ASCIZ ' - in line "'
ERRM3=.+TDIFF
	.ASCIZ " of "
SENDM=.+TDIFF
	.ASCII " defined"
	$0D
	$00
PNMSG1=.+TDIFF
	.ASCIZ " is "
PNMSG2=.+TDIFF
	.ASCIZ 'MAKE "'
TBMSG1=.+TDIFF
	.ASCII "We're now at top-level."
	$0D
	$00
TBMSG2=.+TDIFF
	.ASCIZ "We're currently inside "
TRACEM=.+TDIFF
	.ASCIZ "TRACING O"
TRACM1=.+TDIFF
	.ASCIZ "Executing "
TRACM2=.+TDIFF
	.ASCIZ "Ending "
EDTMSG=.+TDIFF
	.ASCIZ "         MIT LOGO SCREEN EDITOR        "
TOMSG=.+TDIFF
	.ASCIZ "TO "
ENDMSG=.+TDIFF
	.ASCII "END"
	$0D
	$00
WAITM=.+TDIFF
	.ASCII "Please wait..."
	$0D
	$00
BUFEXC=.+TDIFF
	.ASCII "Line given to RUN, REPEAT, or DEFINE is too long"
	$0D
	$00
EXEND=.+TDIFF
	.ASCII "Ignoring extra END"
	$0D
	$00
.PAGE
SAVEM=.+TDIFF
	$84		;^D for DOS
	$C2		;B	these have their high
	$D3		;S	bits turned on because
	$C1		;A	that's the way that
	$D6		;V	Apple does it and DOS
	$C5		;E	understands it.
	$A0		;<space>
	$00
SAVEM2=.+TDIFF
	$AC		;,
	$C1		;A
	$A4		;$
	$B2		;2
	$B0		;0
	$B0		;0
	$B0		;0
	$AC		;,
	$CC		;L
	$A4		;$
	$00
SAVEM3=.+TDIFF
	$B2		;2
	$B0		;0
	$B0		;0
	$B0		;0
	$00
SAVEM4=.+TDIFF
	$B2		;2
	$B0		;0
	$B0		;0
	$B2		;2
	$00
LOADM=.+TDIFF
	$84		;^D for DOS
	$C2		;B
	$CC		;L
	$CF		;O
	$C1		;A
	$C4		;D
	$A0		;<space>
	$00
DELETM=.+TDIFF
	$84
	$C4		;D
	$C5		;E
	$CC		;L
	$C5		;E
	$D4		;T
	$C5		;E
	$00
CATLGM=.+TDIFF
	$84
	$C3		;C
	$C1		;A
	$D4		;T
	$C1		;A
	$CC		;L
	$CF		;O
	$C7		;G
	$00
LOGOM=.+TDIFF
	$AE		;.
	$CC		;L
	$CF		;O
	$C7		;G
	$CF		;O
	$00
SCRNM=.+TDIFF
	$AE		;.
	$D0		;P
	$C9		;I
	$C3		;C
	$D4		;T
	$00
MUSM=.+TDIFF
	$AE		;.
	$CD		;M
	$D5		;U
	$D3		;S
	$00
.PAGE
;Start of Sine table (92 4-byte flonums, first 2 bytes only)
SINTB1=.+TDIFF
	$00	;Extra entry for interpolation routine (cosine of 90.)
	$00

	$00	;0 degrees
	$00

	$7A
	$47

	$7B
	$47

	$7B
	$6B

	$7C
	$47

	$7C
	$59

	$7C
	$6B

	$7C
	$7C

	$7D
	$47

	$7D
	$50

	$7D
	$58

	$7D
	$61

	$7D
	$6A

	$7D
	$73

	$7D
	$7B

	$7E	;15 degrees
	$42

	$7E
	$46

	$7E
	$4A

	$7E
	$4F

	$7E
	$53

	$7E
	$57

	$7E
	$5B

	$7E
	$5F

	$7E
	$64

	$7E
	$68

	$7E
	$6C

	$7E
	$70

	$7E
	$74

	$7E
	$78

	$7E
	$7C

	$7F	;30 degrees
	$40

	$7F
	$41

	$7F
	$43

	$7F
	$45

	$7F
	$47

	$7F
	$49

	$7F
	$4B

	$7F
	$4D

	$7F
	$4E

	$7F
	$50

	$7F
	$52

	$7F
	$53

	$7F
	$55

	$7F
	$57

	$7F
	$58

	$7F	;45 degrees
	$5A

	$7F
	$5C

	$7F
	$5D

	$7F
	$5F

	$7F
	$60

	$7F
	$62

	$7F
	$63

	$7F
	$64

	$7F
	$66

	$7F
	$67

	$7F
	$68

	$7F
	$6A

	$7F
	$6B

	$7F
	$6C

	$7F
	$6D

	$7F	;60 degrees
	$6E

	$7F
	$6F

	$7F
	$71

	$7F
	$72

	$7F
	$73

	$7F
	$74

	$7F
	$74

	$7F
	$75

	$7F
	$76

	$7F
	$77

	$7F
	$78

	$7F
	$79

	$7F
	$79

	$7F
	$7A

	$7F
	$7B

	$7F	;75 degrees
	$7B

	$7F
	$7C

	$7F
	$7C

	$7F
	$7D

	$7F
	$7D

	$7F
	$7E

	$7F
	$7E

	$7F
	$7E

	$7F
	$7F

	$7F
	$7F

	$7F
	$7F

	$7F
	$7F

	$7F
	$7F

	$7F
	$7F

	$7F
	$7F

	$80	;90 degrees
	$40

	$80	;Extra entry for interpolation routine (sine of 90.)
	$40
.PAGE
;Start of Sine table (92 4-byte flonums, second 2 bytes only)
SINTB2=.+TDIFF
	$00
	$00

	$00	;0 degrees
	$00

	$7C
	$2D

	$79
	$63

	$2F
	$1D

	$6E
	$3E

	$3F
	$5B

	$09
	$82

	$CB
	$51

	$41
	$B2

	$18
	$2E

	$E8
	$6A

	$B1
	$B7

	$73
	$67

	$2C
	$C9

	$DD
	$30

	$41	;15 degrees
	$F7

	$90
	$2B

	$D8
	$DF

	$1B
	$BD

	$58
	$6F

	$8E
	$A2

	$BE
	$01

	$E6
	$38

	$06
	$F5

	$1F
	$E5

	$30
	$B6

	$39
	$17

	$38
	$B9

	$2F
	$4A

	$1C
	$7C

	$00	;30 degrees
	$00

	$EC
	$C5

	$D4
	$65

	$B6
	$BB

	$93
	$A2

	$6A
	$F4

	$3C
	$8C

	$08
	$46

	$CD
	$FF

	$8D
	$92

	$46
	$DD

	$F9
	$BE

	$A6
	$12

	$4B
	$B9

	$EA
	$91

	$82	;45 degrees
	$7A

	$13
	$54

	$9D
	$00

	$1F
	$5F

	$9A
	$53

	$0D
	$BF

	$79
	$85

	$DD
	$89

	$39
	$B0

	$8D
	$DE

	$D9
	$F9

	$1D
	$E7

	$59
	$8F

	$8C
	$D7

	$B7
	$A8

	$D9	;60 degrees
	$EC

	$F3
	$8A

	$04
	$6D

	$0C
	$80

	$0B
	$AF

	$01
	$E5

	$EF
	$0F

	$D3
	$1A

	$AD
	$F6

	$7F
	$90

	$47
	$D9

	$06
	$C1

	$BC
	$38

	$68
	$32

	$0A
	$A0

	$A3	;75 degrees
	$75

	$32
	$A6

	$B8
	$29

	$33
	$F1

	$A5
	$F6

	$0E
	$2E

	$6C
	$92

	$C1
	$1B

	$0B
	$C1

	$4C
	$7E

	$83
	$4F

	$B0
	$2E

	$D3
	$18

	$EC
	$0A

	$FB
	$02

	$00	;90 degrees
	$00

	$00	;Extra entry for interpolation routine
	$00
.PAGE
.IFNE GRPINC
.SBTTL		Turtle Shape Table and Images

SHPTBL=.+TDIFF		;lookup table for selecting shape images
	.ADDR TRT0
	.ADDR TRT0
	.ADDR TRT10
	.ADDR TRT10
	.ADDR TRT20
	.ADDR TRT20
	.ADDR TRT30
	.ADDR TRT30
	.ADDR TRT40
	.ADDR TRT40
	.ADDR TRT50
	.ADDR TRT50
	.ADDR TRT60
	.ADDR TRT60
	.ADDR TRT70
	.ADDR TRT70
	.ADDR TRT80
	.ADDR TRT80
.PAGE
;	Actual shape images:
.radix 8
TRT0=.+TDIFF
	77
	77
	54
	44
	45
	54
	44
	14
	56
	76
	56
	65
	77
	67
	55
	55
	66
	65
	77
	77
	0

TRT10=.+TDIFF
	74
	77
	47
	45
	45
	45
	45
	45
	65
	76
	36
	55
	45
	26
	53
	56
	66
	77
	77
	0

TRT20=.+TDIFF
	47
	73
	47
	41
	51
	14
	55
	54
	14
	66
	67
	53
	65
	66
	76
	77
	70
	0

TRT30=.+TDIFF
	74
	34
	57
	50
	14
	55
	54
	45
	26
	67
	57
	61
	57
	62
	66
	47
	77
	74
	7
	0

TRT40=.+TDIFF
	34
	77
	50
	14
	145
	55
	56
	44
	55
	264
	67
	65
	67
	66
	76
	34
	347
	7
	0

TRT50=.+TDIFF
	74
	74
	74
	14
	55
	55
	54
	56
	54
	45
	55
	76
	66
	47
	67
	257
	65
	67
	66
	67
	47
	47
	47
	7
	0

TRT60=.+TDIFF
	44
	47
	47
	55
	55
	65
	56
	44
	55
	275
	67
	365
	67
	76
	366
	74
	44
	7
	0

TRT70=.+TDIFF
	344
	344
	55
	65
	55
	56
	254
	155
	67
	77
	67
	55
	36
	36
	36
	36
	344
	344
	0

TRT80=.+TDIFF
	44
	74
	54
	55
	25
	65
	56
	44
	65
	55
	55
	27
	77
	67
	375
	76
	76
	36
	47
	74
	7
	0
.radix 10
.ENDC
.PAGE
.SBTTL		Primitive Table

;Primitive-table format:
;	<Index> <Arguments> <Precedence> <Print-name> 0
;Note:	Abbreviations use a separate entry. For primitives with a variable
;	number of arguments, the high bit of <Arguments> is set.

PRMTAB	=.+TDIFF

	0
	0
	IALL
	.ASCIZ "ALL"

	$82
	1
	IAND
	.ASCIZ "ALLOF"

	$82
	1
	IOR
	.ASCIZ "ANYOF"

	1
	5
	IBTFST
	.ASCIZ "BUTFIRST"

	1
	5
	IBTFST
	.ASCIZ "BF"

	1
	5
	IBTLST
	.ASCIZ "BUTLAST"

	1
	5
	IBTLST
	.ASCIZ "BL"

	0
	0
	ICATLG
	.ASCIZ "CATALOG"

	0
	0
	IRCP
	.ASCIZ "RC?"

	0
	0
	ICLEAR
	.ASCIZ "CLEARTEXT"

	0
	0
	ICLINP
	.ASCIZ "CLEARINPUT"

	0
	0
	ICNTIN
	.ASCIZ "CONTINUE"

	0
	0
	ICNTIN
	.ASCIZ "CO"

	1
	5
	ICOS
	.ASCIZ "COS"

	2
	5
	ICURSR
	.ASCIZ "CURSOR"

	2
	0
	IDEFIN
	.ASCIZ "DEFINE"

	1
	0
	IDELET
	.ASCIZ "ERASEFILE"

	1
	0
	IERPCT
	.ASCIZ "ERASEPICT"

	0
	0
	IEDIT
	.ASCIZ "EDIT"

	0
	0
	IEDIT
	.ASCIZ "ED"

	0
	1
	IELSE
	.ASCIZ "ELSE"

	0
	0
	IEND
	.ASCIZ "END"

	0
	0
	IERASE
	.ASCIZ "ERASE"

	0
	0
	IERASE
	.ASCIZ "ER"

	1
	0
	IERNAM
	.ASCIZ "ERNAME"

	1
	5
	IFIRST
	.ASCIZ "FIRST"

	2
	0
	IFPUT
	.ASCIZ "FPUT"

	1
	0
	IGO
	.ASCIZ "GO"

	0
	0
	IGDBYE
	.ASCIZ "GOODBYE"

	1
	0
	IIF
	.ASCIZ "IF"

	0
	0
	IIFF
	.ASCIZ "IFFALSE"

	0
	0
	IIFF
	.ASCIZ "IFF"

	0
	0
	IIFT
	.ASCIZ "IFTRUE"

	0
	0
	IIFT
	.ASCIZ "IFT"

	1
	5
	IINT
	.ASCIZ "INTEGER"
	1
	5
	ILAST
	.ASCIZ "LAST"

	1
	5
	ILETOF
	.ASCIZ "CHAR"
	
	$82
	5
	ILIST
	.ASCIZ "LIST"

	1
	5
	ILISTP
	.ASCIZ "LIST?"

	2
	0
	ILPUT
	.ASCIZ "LPUT"

	2
	0
	IMAKE
	.ASCIZ "MAKE"

	0
	0
	INAMES
	.ASCIZ "NAMES"

	1
	2
	INOT
	.ASCIZ "NOT"

	0
	0
	INTRAC
	.ASCIZ "NOTRACE"

	1
	5
	INMBRP
	.ASCIZ "NUMBER?"

	1
	5
	INUMOF
	.ASCIZ "ASCII"

	1
	0
	IOTPUT
	.ASCIZ "OUTPUT"

	1
	0
	IOTPUT
	.ASCIZ "OP"

	1
	0
	IPADDL
	.ASCIZ "PADDLE"

	1
	0
	IPDBTN
	.ASCIZ "PADDLEBUTTON"

	0
	0
	IPAUSE
	.ASCIZ "PAUSE"

	0
	0
	IPOTS
	.ASCIZ "POTS"

	$81
	0
	IPRINT
	.ASCIZ "PRINT"

	$81
	0
	IPRINT
	.ASCIZ "PR"

	$81
	0
	IPRNT1
	.ASCIZ "PRINT1"

	0
	0
	IPO
	.ASCIZ "PRINTOUT"

	0
	0
	IPO
	.ASCIZ "PO"

	0
	0
	IPROCS
	.ASCIZ "PROCEDURES"

	2
	5
	IQTENT
	.ASCIZ "QUOTIENT"

	1
	0
	IRANDM
	.ASCIZ "RANDOM"

	0
	0
	IRNDMZ
	.ASCIZ "RANDOMIZE"

	1
	0
	IREAD
	.ASCIZ "READ"

	0
	0
	IRC
	.ASCIZ "READCHARACTER"

	0
	0
	IRC
	.ASCIZ "RC"

	2
	5
	IRMNDR
	.ASCIZ "REMAINDER"

	2
	0
	IRPEAT
	.ASCIZ "REPEAT"

	0
	0
	IREQST
	.ASCIZ "REQUEST"

	0
	0
	IREQST
	.ASCIZ "RQ"

	1
	5
	IROUND
	.ASCIZ "ROUND"

	1
	0
	IRUN
	.ASCIZ "RUN"

	1
	0
	ISAVE
	.ASCIZ "SAVE"

	$82
	5
	ISNTNC
	.ASCIZ "SENTENCE"

	$82
	5
	ISNTNC
	.ASCIZ "SE"

	1
	5
	ISIN
	.ASCIZ "SIN"

	1
	5
	ISQRT
	.ASCIZ "SQRT"

	0
	0
	ISTOP
	.ASCIZ "STOP"

	1
	0
	ITEST
	.ASCIZ "TEST"

	1
	5
	ITEXT
	.ASCIZ "TEXT"

	0
	0
	ITHEN
	.ASCIZ "THEN"

	1
	5
	ITHING
	.ASCIZ "THING"

	1
	5
	ITHNGP
	.ASCIZ "THING?"

	0
	0
	ITITLS
	.ASCIZ "TITLES"

	0
	0
	ITO
	.ASCIZ "TO"

	0
	0
	ITPLVL
	.ASCIZ "TOPLEVEL"

	2
	5
	ITWRDS
	.ASCIZ "TOWARDS"

	0
	0
	ITRACE
	.ASCIZ "TRACE"

;	0
;	0
;	ITRCBK
;	.ASCIZ "TRACEBACK"

;	0
;	0
;	ITRCBK 
;	.ASCIZ "TB"

	$82
	5
	IWORD
	.ASCIZ "WORD"

	1
	5
	IWORDP
	.ASCIZ "WORD?"

	0
	0
	ILPAR
	.ASCIZ "("

	0
	0
	IRPAR
	.ASCIZ ")"

	2
	7
	INPROD
	.ASCIZ "*"

	2
	6
	INSUM
	.ASCIZ "+"

	2
	6
	INDIF
	.ASCIZ "-"

	0
	0
	IBPT
	.ASCIZ ".BPT"

	2
	0
	ICALL
	.ASCIZ ".CALL"

	2
	0
	IDEP
	.ASCIZ ".DEPOSIT"

	1
	0
	IEXM
	.ASCIZ ".EXAMINE"

	0
	0
	IGCOLL
	.ASCIZ ".GCOLL"

	
	1
	0
	IINADR
	.ASCIZ ".INDEV"

	1
	0
	IOTADR
	.ASCIZ ".OUTDEV"
	0
	0
	INODES
	.ASCIZ ".NODES"

	2
	7
	INQUOT
	.ASCIZ "/"

	0
	0
	ICOMNT
	.ASCIZ ";"

	2
	4
	INLESS
	.ASCIZ "<"

	2
	3
	INEQUL
	.ASCIZ "="

	2
	4
	INGRTR
	.ASCIZ ">"
.PAGE
.IFNE GRPINC
;	Graphics primitives:
	1
	0
	IBACK
	.ASCIZ "BACK"

	1
	0
	IBACK
	.ASCIZ "BK"

	1
	0
	IBKGND
	.ASCIZ "BACKGROUND"

	1
	0
	IBKGND
	.ASCIZ "BG"

	0
	0
	ICS
	.ASCIZ "CLEARSCREEN"

	0
	0
	ICS
	.ASCIZ "CS"

	0
	0
	IDRAW
	.ASCIZ "DRAW"

	1
	0
	IFORWD
	.ASCIZ "FORWARD"

	1
	0
	IFORWD
	.ASCIZ "FD"

	0
	0
	IFULL
	.ASCIZ "FULLSCREEN"

	0
	0
	IHDING
	.ASCIZ "HEADING"

	0
	0
	IHIDET
	.ASCIZ "HIDETURTLE"

	0
	0
	IHIDET
	.ASCIZ "HT"

	0
	0
	IHOME
	.ASCIZ "HOME"

	1
	0
	ILEFT
	.ASCIZ "LEFT"

	1
	0
	ILEFT
	.ASCIZ "LT"

	0
	0
	INDSPL
	.ASCIZ "NODRAW"

	0
	0
	INDSPL
	.ASCIZ "ND"

;	1
;	0
;	IPALET
;	.ASCIZ "PALETTE"

	1
	0
	IPENC
	.ASCIZ "PENCOLOR"

	1
	0
	IPENC
	.ASCIZ "PC"

	0
	0
	IPENDN
	.ASCIZ "PENDOWN"

	0
	0
	IPENDN
	.ASCIZ "PD"

	0
	0
	IPENUP
	.ASCIZ "PENUP"

	0
	0
	IPENUP
	.ASCIZ "PU"

	1
	0
	IRDPCT
	.ASCIZ "READPICT"

	1
	0
	IRIGHT
	.ASCIZ "RIGHT"

	1
	0
	IRIGHT
	.ASCIZ "RT"

	1
	0
	ISVPCT
	.ASCIZ "SAVEPICT"

	1
	0
	ISCNCH
	.ASCIZ ".ASPECT"

	1
	0
	ISETH
	.ASCIZ "SETHEADING"

	1
	0
	ISETH
	.ASCIZ "SETH"

	1
	0
	ISETT
	.ASCIZ "SETTURTLE"

	1
	0
	ISETT
	.ASCIZ "SETT"

	1
	0
	ISETX
	.ASCIZ "SETX"

	2
	0
	ISETXY
	.ASCIZ "SETXY"

	1
	0
	ISETY
	.ASCIZ "SETY"

	0
	0
	ISHOWT
	.ASCIZ "SHOWTURTLE"

	0
	0
	ISHOWT
	.ASCIZ "ST"

	0
	0
	ISPLIT
	.ASCIZ "SPLITSCREEN"

	0
	0
	ITSTAT
	.ASCIZ "TURTLESTATE"

	0
	0
	ITSTAT
	.ASCIZ "TS"

	0
	0
	IXCOR
	.ASCIZ "XCOR"

	0
	0
	IYCOR
	.ASCIZ "YCOR"
.ENDC
.IFNE MUSINC
.PAGE
;	Music primitives:
	1
	0
	IERMUS
	.ASCIZ "ERASEMUSIC"

	2
	0
	INOTE
	.ASCIZ "NOTE"

	1
	0
	INVOIC
	.ASCIZ "NVOICES"

	0
	0
	IPLAYM
	.ASCIZ "PLAYMUSIC"

	0
	0
	IPLAYM
	.ASCIZ "PM"

	1
	0
	IRDMUS
	.ASCIZ "READMUSIC"

	1
	0
	ISVMUS
	.ASCIZ "SAVEMUSIC"

	2
	0
	IAD
	.ASCIZ "SETAD"

	2
	0
	ISFZ
	.ASCIZ "SETFUZZ"

	2
	0
	IRG
	.ASCIZ "SETRG"

	2
	0
	IVS
	.ASCIZ "SETVS"

	1
	0
	IVOICE
	.ASCIZ "VOICE"
.ENDC
.PAGE
FGRMBT:	$00	;Graphics memory map byte table
	$00
	$00
	$53
	$4C
	$48
	$00
	$00
	$00
	$00
	$50
	$47
	$53
	$00
	$00
	$00
	$00
	$4B
	$4C
	$4F
	$54
	$5A
	$00
	$00
	$00
	$00
	$48
	$41
	$4C
	$00
.PAGE
.SBTTL		V-Primitive Table

;V-Primitive-table format:  3 bytes/entry
;	<Index> <Pointer>
;Note:	V-Primitives are quantifiers and other primitives whose pointer must be
;	available for comparisons.

VPRMTB	=.+TDIFF

	INFSUM&$FF
	INSUM

	INFDIF&$FF
	INDIF

	LPAR&$FF
	ILPAR

	RPAR&$FF
	IRPAR

	IF&$FF
	IIF

	ELSE&$FF
	IELSE

	THEN&$FF
	ITHEN

	NAMES&$FF
	INAMES

	ALL&$FF
	IALL

	TITLES&$FF
	ITITLS

	PROCS&$FF
	IPROCS

	END&$FF
	IEND

	STOP&$FF
	ISTOP

	COMMNT&$FF
	ICOMNT

	GO&$FF
	IGO

	TO&$FF
	ITO

	EDIT&$FF
	IEDIT

VPRMTE	=.+TDIFF

;	Unary primitives created explicitly:
PRMSUM=.+TDIFF
	1
	8
	IUNSUM

PRMDIF=.+TDIFF
	1
	8
	IUNDIF

ENDTAB=.	;End of Ghost-memory storage
.PRINT .-<SYSTAB*$100>	;LENGTH OF GHOST MEMORY - BETTER BE LESS THAN $1000!!

.=OCODE-$0A
DSTART=.
.PRINT .	;Starting address for disk saving.
DSRLEN=ZZZZZZ-DSTART
.PRINT DSRLEN	;Disk save length.
CLDLD:	JMP LOGO	;Cold load address.
CLDBT:	JMP LOGO1	;Cold boot vector instruction
WMBT:	JMP REENT	;Crash re-entry vector instruction (warm boot)

;Local Modes:
;Comment Column:24
;Mode: "Midas"
;End:
.END
