;+
;
; KS10 CSL V5.2.
;
; I'm sure this is covered by a zillion DEC copyrights but the 4.2 listing has
; been available for FTP from KSHACK; for years with no repercussions.  Anyway
; this is useless to you unless you bought a KS10, so it's hard to get too upset
; about people copying it.
;
; Disassembly of V5.2 EPROMs by John Wilson, with a lot of help from the V4.2
; listing.  Original author unknown.  Might have been Don Lewine?  Someone
; correct me on this.
;
; This can be re-assembled under DOS (I know, I know) using TASM and my
; MCS85.INC macros which turn TASM into an 8080/8085 cross-assembler.  MASM
; might work too.  A little hacking should make it workable with any 8080
; assembler that supports conditional assembly.
;
; Note that setting the conditionals differently from the way they are now is
; unlikely to work, they're just the beginnings of my attempt to figure out
; what goes where.
;
; 08/13/93	JOHNW	Disassembled.
; 08/19/93	JOHNW	Assembles, output matches original EPROMs.
;
; I/O ports (very partial list):
; 41	(w) lights in low 3 bits (1=on), b4=DTR for KLINIK
; 42	(r) may be switches?  40=RESET
; 80	(r/w) CTY data
; 81	(w) CTY ctrl bits (b7=# stop bits, b2=# data bits, b0=ready)
; 82	(r/w) KLINIK data
; 83	(r) KLINIK ctrl bits (see above)
;
;-
	include	mcs85.inc
code	segment
	assume	cs:code
	mnem	8085
;
bel=	07h
tab=	09h
lf=	0Ah
cr=	0Dh
rub=	7Fh
;
ramst=	2000h			;RAM starting addr
ramsz=	400h			;RAM size (1Kx8)
crmsz=	800h			;CRAM size (2Kx96)
;
kpaini=	1700d			;keep-alive loop count
katimx=	35d			;# secs of frozen keep-alive before auto reload
;
ver52=	1
ver42=	0
mm=	1	;covers manufacturing mode stuff
klinik=	1	;covers KLINIK stuff
dumb=	1	;enable inefficient DEC code
;
; KLINIK mode bits, kept in CSLMOD
_mode0=	01h
_mode1=	02h
_mode2=	04h
_mode3=	08h
_mode4=	10h
;
; BUSRES bits (in-line byte)
datack=	01h	;data acknowledge
arbres=	10h	;arbitrator response (bus req)
nonxme=	40h	;NXM error
;
	org	0
L0000:	nop			;supposedly let 8080 settle down
	nop			;(why, is it agitated?)
	di
	jmp	L0040
;
	org	1*8h
L0008:	; RST 1 (write in-line char to CTY)
	xthl
	mov	a,m		;get it
	inx	h
	xthl
	jmp	pchr		;send to CTY, return
;
	org	2*8h
L0010:	; RST 2 (enter "internal" mode -- no CTY output)
	push	h
	lxi	h,nopnt
	inr	m
	pop	h
	ret
;
	org	3*8h
L0018:	; RST 3 ("PLINE" -- print .ASCIZ string)
	xthl
	mov	e,m
	inx	h
	mov	d,m
	inx	h
	jmp	plne
;
	org	4*8h
L0020:	; RST 4 ("UUO" style calls, in-line byte is function:)
	; 0	copy 5 bytes from 1st in-line addr to 2nd
	; 2	print crlf on CTY
	; 4	parse 16-bit cmd line arg
	; 6	print error if CPU running
	; 8.	parse 36-bit cmd line arg
	; 10.	clear 5-byte buf (addr+5 is in-line)
	xthl			;pt at byte following RST
	mov	a,m		;fetch it
	inx	h
	xthl
	push	h		;save HL
	jmp	rtndis
;
	org	5*8h
L0028:	; RST 5 ("CLRB" -- clrs byte in 1st 256 bytes of RAM (in-line offset))
	xthl			;fetch in-line byte
	mov	a,m
	inx	h
	xthl
	push	h		;save HL
	jmp	clrbyt
;
	org	6*8h
L0030:	; RST 6 (exit "internal" mode)
	push	h
	lxi	h,nopnt
	dcr	m
	pop	h
	ret
;
	org	7*8h
L0038:	; RST 7 (hardware interrupt)
	di			;ints off (aren't they already?)
	push	psw		;save everything
	push	b
	push	d
	push	h
	jmp	intrp
;
L0040:	lxi	sp,ramst+ramsz	;init stack ptr
	; clear RAM
	lxi	h,ramst		;begn
	lxi	d,ramsz		;size
L0049:	mvi	m,0		;zap a byte
	inx	h
	dcx	d
	mov	a,e		;done all?
	ora	d
	jnz	L0049		;loop if not
	xra	a		;clear KS10 ff's:  RUN, EXECUTE, CONT
	out	8Ah
	call	mrint		;KS bus reset, set dflt parity/traps
	; init UARTs
	in	0C0h		;get DIP switches
	cma			;(they read inverted)
	lxi	b,0480h
	mov	h,a		;H<7>=# CTY stop bits
	rar
	rar
	mov	e,a		;E<2>=# KLINIK data bits
	rar
	rar
	mov	l,a		;L<2>=# CTY data bits
	mov	a,h
	ral
	ral
	mov	d,a		;D<7>=# KLINIK stop bits
	mov	a,c		;isolate # CTY stop bits in H
	ana	h
	mov	h,a
	mov	a,c		;isolate # KLINIK stop bits in D
	ana	d
	mov	d,a
	; set CTY mode
	mov	a,b		;A<2>=# data bits
	ana	l
	ora	h		;A<7>=# stop bits
	ori	4Ah		;control bits
	out	81h		;set CTY mode
	; set KLINIK mode
	mov	a,b		;A<2>=# data bits
	ana	e
	ora	d		;A<7>=# stop bits
	ori	4Ah		;control bits
	out	83h		;set KLINIK mode
	; enable UARTs
	mvi	a,15h		;well, CTY anyway
	out	81h
	mvi	a,10h		;just reset the KLINIK one
	out	83h
	in	80h		;flush anything already in holding regs
	in	82h		;(otherwise input will hang)
	call	bfrst		;init CTY input buf
	; do EPROM checksums
	lxi	h,L0000		;start at beginning
L008F:	xra	a		;init BC, DE to 0
if dumb ; about to get nuked
	mov	c,a
endif
	mov	b,a
	mov	e,a		;sum is in DE
	mov	d,a
L0094:	mov	c,m		;get a byte
	inx	h
	xchg
	dad	b		;add to sum (0-extended)
	xchg
	mov	a,l		;finished page?
	ana	a
	jnz	L0094
	mov	a,h		;yep, finished EPROM?
	ani	7
	jnz	L0094		;(2716s are 800h bytes long)
	mov	a,h		;find EPROM #, 0-3
	rrc
	rrc
if dumb
	rrc
	dcr	a
	add	a
else ; saves a byte
	sui	2
endif
	push	psw
	push	h
	jnz	L00CD		;skip if not EPROM #0
	; EPROM #0 contains the checksums, and since they're 16-bit ones
	; we can't necessarily rig things so they'll work out, so
	; eliminate them from the count
	push	psw
	lxi	h,checks	;pt at list
	mvi	a,8h		;# bytes of checkum stuff
L00B5:	sta	t80dt		;save
	mvi	b,0FFh		;1-extend for double precision negate
	mov	a,m		;get a byte
	cma			;find 2's complement in BC
	mov	c,a
	inx	b
	xchg			;get checksum
	dad	b		;subtract this byte
	xchg
	inx	h		;skip a byte
	lda	t80dt		;done?
	dcr	a
	jnz	L00B5		;loop if not
if dumb
	lxi	b,0		;code below depends on B=0
else
	mvi	b,0		;all that's really needed
endif
	pop	psw
L00CD:	mov	c,a		;BC=offset of checksum for this EPROM
	lxi	h,checks	;compute addr
	dad	b
	mov	c,m		;get checksum in BC
	inx	h
	mov	b,m
if dumb
	inx	h		;(value not used)
endif
	; DE=actual checksum, BC=2's comp of expected checksum
	xchg			;do they add to 0?
	dad	b
	mov	a,l		;(DAD doesn't set Z flag)
	ora	h
	xchg
	pop	h
	jnz	L00ED		;skip on bad checksum
	pop	psw
	cpi	6		;done all?
	jnz	L008F		;loop if not
	jmp	L00FA		;skip
;
if ver52
L00E8:	db	'?CHK',0
else
L00E8:	db	'?CHK ',0	;V4.2 had extravagant space after msg
endif
L00ED:	; bad checksum
	rst	3		;"?CHK"
	dw	L00E8
	pop	psw		;get EPROM # *2
	rrc			;/2
	inr	a		;make it 1-4
	ori	'0'		;digit
	call	pchr
	rst	4		;crlf
	db	2
L00FA:	mvi	a,7Ch		;turn on KS10 parity detection
	out	40h
	; init a bunch of stuff in RAM from table
	lxi	h,katim1	;area to init
	lxi	d,prmlst	;constants to load
L0104:	ldax	d		;get a byte
	cpi	0AAh		;end?
	jz	L0131
	mov	m,a		;no, store
	inx	h		;ptrs +1
	inx	d
	jmp	L0104		;loop
prmlst:	dw	kpaini		;initial value for KATIM1
	dw	-1		;soft CRAM err addr
if klinik
	dw	mode0		;KLINIK received char vector
endif
	dw	reini		;vector for cmd completion
	dw	envbuf
	db	7Ch		;default PARBT parity enables
	db	10h		;default TRAPEN trap enables
	db	3*4		;default magtape UBA# = 3
	db	1*4		;default disk UBA# = 1
	db	08h		;default STATE=DTR true
if klinik
	db	41q		;default LSTMSG
endif
	dw	2000q		;default DEN_SL=1600 bpi, slave 0
	db	0,0,0		;(high bits)
	dw	172440q		;default MTBASE (RHBASE for tape)
	db	3,0,0		;(high addr bits)
_dsbas:	dw	176700q		;default DSBASE (RHBASE for disk)
	db	3,0,0		;(high addr bits)
	db	0FFh		;RPINI
	db	0AAh	;end-of-list marker
;
L0131:	mvi	a,15h		;reset/enable KLINIK line (why not before?)
	out	83h
	mvi	a,08h		;set DTR
	out	41h
	rst	3		;"KS10 CSL.V5.2"
	dw	L0564
	rst	2		;internal mode on
if ver52
	xra	a		;this wasn't in V4.2
	out	88h
endif
	call	L09ED		;fake examine to set memory latches
	call	ebcmd		;do EB to make sure bus has no bits stuck on
	ei			;ints on (at last!)
	call	cmp36		;check results
	dw	embuf		;value from bus
	dw	mad000		;36 bits of zeroes
if ver52
	jz	L0158		;OK, try auto boot
else
	jz	pwrchk		;V4.2 checked for never-built BBU option
endif
	; bus hung, should have read as all zeroes
	rst	6		;internal mode off
	rst	3		;"?BUS"
	dw	L1F02
	jmp	reini		;go start anyway
;
if ver42 ; power fail code was flushed in V5.2
pwr.fail: call	microp
	jc	c_bter
	call	dmem2c
	call	bt_go
	rst	4		;clear TMPBF2
	db	0Ah
	dw	tmpbf2+5
	mvi	m,70q		;power fail addr is 000070
	mvi	a,4		;code 4 is power failure
	sta	gocode
	call	stint		;start machine, internal mode
	jmp	reini
;
pwrchk:	rst	4		;clear IOAD so we can set it to 100000
	db	0Ah
	dw	ioad+5
	inx	h		;pt at IOAD+1
	mvi	m,80h		;100000' (MMC control reg)
	call	ei1		;read it
endif
;
L0158:	rst	6		;internal mode off
	mvi	c,150d		;outer loop count
L015B:	lxi	h,25d		;delay loop count
	call	ltloop
	lda	rpend		;char typed at CTY?
	ana	a
	jnz	reini		;restart if so
	in	0C1h		;read boot switch
	ani	2		;switch depressed?  (signal is inverted)
	jz	L01F6		;yes, stop waiting
	in	42h		;read AC PWR LO
	ani	40h		;bit active (low)?
	jz	L0000		;yes, start over
	dcr	c		;outer loop expired?
	jnz	L015B
if ver42
	lda	embuf+2		;get bits 12-19 of MMC status reg
	ani	80h		;BBU worked?
	jz	pwr.fail	;yes
endif
	rst	3		;"BT AUTO"
	dw	L1FF0
	call	btaut
reini:	; restart console null job
	lxi	sp,ramst+ramsz	;reinit stack
	rst	5		;guarantee eol ctr=0
	db	low eol
	rst	5
	db	low errcd
	rst	5
	db	low (errcd+1)
	rst	5
	db	low rpton
	rst	5
	db	low nopnt
	lxi	h,rpini		;init ptr to RP dispatch addr list
	shld	rplst
	lxi	h,reini		;vector=restart
	shld	norend		;set normal end dispatch addr
	call	bfrst		;flush CTY input buf
	ei
	lda	usrmd		;if USR MOD, skip prompt
	ana	a
	jnz	nullj
if mm
	lda	mmflg		;manufacturing mode => skip prompt
	ana	a
	jnz	nullj
endif
	rst	4		;crlf
	db	02h
	rst	3		;"KS10>"
	dw	L1F22
;
nullj:	lxi	h,dcode		;handle cmds on eol
nullw:	; throughout the following code we hold the CTY continuation addr in HL
	in	42h		;check for AC PWR LO
	ani	40h
	jz	L0000		;yes, start all over
if klinik
	in	0C2h		;get KLINIK switches
	cma
	mov	c,a		;save
	ani	0Ch		;b3, b2
	rrc			;make that b2, b1
	mov	b,a		;save
	lda	klnksw		;get curr value
	cmp	b		;changed?
	push	h
	cnz	klnklt		;fix lights if so
	pop	h
	mov	a,c		;check KLINIK CD
	ani	01h
	jz	L01D7		;no carrier, see if we care
	sta	watchc		;CD is on, we must notice if it goes off
	jmp	L01EF
L01D7:	; KLINIK CD is off
	lda	watchc		;was it on before?
	ana	a
	jz	L01EF		;no, relax
	push	h
	lxi	h,200d*2	;wait for about 2 secs
	call	ltloop
	in	0C2h		;see if carrier is back
	ani	01h
	cnz	hangzk		;nope, so hang up, KLNKSW=0
	pop	h
	rst	5		;clear WATCHC
	db	low watchc
endif ; klinik
L01EF:	in	0C1h		;read BOOT switch
	ani	02h		;is it depressed?
	jnz	L01FC
L01F6:	; BOOT switch pressed
	call	boot		;go boot
	jmp	nullj
L01FC:	in	0C1h		;read again (may jump in from below)
	ani	08h		;parity error?
	jnz	L020D		;no
	; parity error, report it if enabled
	lda	chkpar
	ana	a
	jnz	rptpar		;report it
	jmp	L0211
L020D:	;;;; huh?  why have a switch if you always set it?
	cma			;A=FF
	sta	chkpar		;set flag for next time
L0211:	in	0C0h		;see if KS10 is in halt loop
	ani	08h
	jnz	L0227		;no, must be running
	lda	chkhlt		;halted, are we supposed to report it?
	ana	a
	push	psw
	cnz	hltcm		;complain if so
	pop	psw
	jnz	L029E		;weird... check for reload request
	jmp	L022B		;don't report halt
L0227:	; from CO and from above are only ways to get here,
	; CHKHLT=A=0 either way
	cma			;A=FF
	sta	chkhlt		;set flag
L022B:	in	41h		;check for refresh err
	ani	01h
	jnz	L023E		;no, skip
	; refresh error
	lda	chkref		;should we report?
	ana	a
	push	h
	cnz	norefr		;do it if so
	pop	h
	jmp	L0242
L023E:	cma			;A=FF
	sta	chkref		;enable ref err reporting
L0242:	lda	usrmd		;user mode?
	ana	a
	jnz	L028A		;yes, check 10 ints and keep-alive
if klinik
; see if we need to send out a packet
	lda	cslmod		;mode 4?
	cpi	_mode4
	jnz	L0256		;no
	push	h		;save CTY input continuation addr
	call	decnet		;send whatever we have
	pop	h
endif ; klinik
L0256:	; see if we're in an RP cmd
	lda	rpton		;well?
	ana	a
	jnz	L1076		;in RP cmd, continue it
	lda	eol		;eol?
	ora	a
	jz	nullw		;no, keep spinning
	pchl			;jump to continuation addr w/CTY input
;
dcode:	xra	a		;A, B=0
	mov	b,a
	lxi	d,L0463		;pt at cmd table
	lhld	first		;pt at begn of line
	call	fndarg		;skip white space
	jc	norml		;blank line
L0273:	; check next entry in cmd table
	ldax	d		;get 1st char
	ora	a		;end of table?
	jz	L0284		;err if so
	inx	d
	cmp	m		;does 1st char match?
	jz	L035E
L027D:	inx	d		;no, skip rest of entry
	inx	d
	inx	d
	inr	b		;bump # tries
	jmp	L0273		;check next
L0284:	; illegal cmd
	rst	3		;"?IL"
	dw	L1F0D
	jmp	mmerr
;+
;
; Come here from NULLJ when in user mode (mode 3).
;
; Check for chars from KS10, also check keep-alive and BUGHLT.
;
;-
L028A:	in	0C1h		;"interrupt" from KS10?
	ana	a
	push	psw
	cp	chrrdy		;call if so
	pop	psw
	cp	faklit		;subtract random amount to compensate for CALL
	jz	L029E		;do watchdog checks
	call	dtime		;time-1 whatever happens
	jnz	nullj
L029E:	; here every second or so
	lxi	h,kpaini	;reinit clock
	shld	katim1
	rst	2		;internal mode on
	di
	call	examsh		;examine
	dw	31q
	ei
	rst	6		;internal mode off
	lda	embuf+3		;get reload bits
	ral			;C="forced reload" bit
	jc	freloa		;set, do it
	ral			;"keep-alive" bit set?
	jnc	nullj		;no, chill
	; blink the "state" light
	lda	state		;get front panel lights
if dumb
	mov	d,a		;save
	ani	0FBh		;clear "state" bit
	mov	e,a		;save other bits
	mov	a,d		;get original bits back
	cma			;flip them all
	ani	04h		;isolate flipped "state" bit
	ora	e		;OR in other bits, set CC
else
	xri	04h		;you illiterates!!!
endif
	sta	state		;save new lights
	out	41h		;set them on front panel too
	jm	nullj		;shutting down, go back
	; hopefully our data exammed from loc 31 are still current
	lxi	h,kacntr	;pt at prev value
	lda	embuf+1		;get (part of) current count
	cmp	m		;changed?
	jz	L0333		;no, uh oh
	mov	m,a		;save new value
	rst	5		;zap "frozen" ctr
	db	low diecnt
	jmp	nullj
;
faklit:	; supposedly compensate for time spent handling CTY output
	lhld	katim1
	mov	a,l
	ani	0FCh		;subtract 0-3
	mov	l,a
	jmp	L02EA
dtime:	lhld	katim1
	dcx	h		;subtract 1
L02EA:	shld	katim1
	mov	a,l
	ora	h
	ret
;+
;
; We come here when the KS10 sets the "forced reload" bit.
;
;-
freloa:	; forced reload
	rst	5		;enable printing
	db	low nopnt
	rst	3		;"?FRC"
	dw	L1FD4
	mvi	a,02h		;set bit 34
	sta	gocode
	in	0C0h		;CPU running?
	ani	08h
	rst	2		;[internal mode on]
	cnz	hacmd		;halt it if so
	rst	6		;internal mode off
	lda	secret		;get secret flag
;;; is SECRET set anywhere?  this looks like the only ref.  undoc'ed DK cmd?
	ana	a		;are auto reloads disabled?
	jnz	reini		;back to prompt if so
	lxi	d,1004q		;point at monitor pre-boot
	call	filein		;read it
	jc	l_bter		;punt on fatal error
	lxi	h,1		;start at ucode locn 1
	call	sm1_5
	lxi	h,2*200d	;give "SM 1" time to finish
	call	ltloop
	call	bt_go1		;fix parity etc.
	call	infobt
if ver52 ; this looks like some kind of bug fix
	lxi	h,L20BA		;set up magic bits for CO, EX, ST
	mvi	m,04h		;added in on EX, ST
	inx	h
	mvi	m,01h		;added in on CO
endif
	call	lb_go1
	jmp	nullj
;
L0333:	; come here if keep-alive count hasn't changed since last second
	lxi	h,diecnt	;get how long KS10 has been frozen
	inr	m		;+1 first
	mov	a,m
	cpi	katimx		;too long?
	jm	nullj		;no, keep trying (like what's gonna happen?)
	rst	5		;turn on typeout
	db	low nopnt
	rst	5		;reinit counter
	db	low diecnt
	rst	3		;"?KA"
	dw	L1FCF
	rst	2		;internal mode on
	call	hacmd		;stop the KS10 for sure
	di			;don't bug me while examining
	call	examsh		;;get instruction at loc 71
	dw	71q
	ei
	mvi	a,1		;keep-alive code
	sta	gocode
	call	exintm		;exec loc 71, page 0 of mon space
	call	cocmd		;continue the KS10
	rst	6		;internal mode off
	jmp	nullj		;back to doing nothing
;
L035E:	; first char of cmd was a match
	inx	h		;pt at 2nd in line
	ldax	d		;get 2nd in table
	cmp	m		;same?
	jz	L0368		;yes
	dcx	h		;no, back to loop
	jmp	L027D
L0368:	; found match
	inx	d		;skip to dispatch addr
	inx	h		;and to cmd arg, if any
	call	sepchr		;skip blanks
	shld	_arg1		;save ptr
	mov	a,b		;get # tries
	xchg			;pt with HL
	mov	e,m		;DE=dispatch addr
	inx	h
	mov	d,m
	lxi	h,norml		;set return addr
	push	h
	ana	a		;RP cmd?
	sta	t80dt		;[save cmd # anyway]
	jz	L0394		;yes, go
	lda	cmds__		;first cmd of line?
	ana	a
	cz	rpnew		;set RP ptrs if so
	lhld	rplst		;get ptr to free RP buf loc
	mov	m,d		;save addr in case line ends with RP
	inx	h		;(bytes backwards to guarantee first not FF)
	mov	m,e
	inx	h
if dumb
	xra	a		;mark end of list with -1
	cma
	mov	m,a
else
	mvi	m,-1		;not like it's undocumented or something
endif
	shld	rplst		;anyway, update free ptr
L0394:	xchg			;pt into table with HL
	call	eocml		;see if eol (C=1 if so)
	push	psw
	cnc	remarg		;not eol, remember arg
	jnc	L03A4		;and skip
	mov	a,h		;OK not to have arg?  (b15 => arg req'd)
	ral
	jc	L1A56		;screwed, go complain
L03A4:	mov	a,h		;trim off b15, even though it isn't decoded
	ani	7Fh
	mov	h,a
	pop	psw
	pchl			;jump to dispatch address
;+
;
; Remember whether cmd had arg, for RP cmd.
;
;-
remarg:	push	psw		;save
	lda	t80dt		;already in RP?
	ana	a
	jz	L03BD		;never mind if so
	push	h
	lhld	rplst		;get curr ptr to RP list
	dcx	h		;-2 to pt at addr
	dcx	h
	mov	a,m		;set b15 to say had arg
	ori	80h
	mov	m,a
	pop	h		;restore
L03BD:	pop	psw
	ret
;+
;
; Normal return loc, set up ptrs and print next prompt.
;
;-
norml:	lxi	h,eol		;cmd cnt -1
	mov	a,m
	dcr	a
	mov	m,a
if dumb
	dcr	a		;run negative if 0
	jm	L03DF		;take normal dispatch
else ;;; assumption:  EOL is normally >=0
	jz	L03DF
endif
	call	fxnxt
	rst	5		;clear ERRCD
	db	low errcd
	lxi	h,dcode		;what to do on next cr
	jmp	L01FC		;back to null job
;
fxnxt:	lhld	_arg1		;get ptr to 1st arg
	inx	h		;skip eol char
	shld	first		;update cmd ptr
	ret
;
L03DC:	; here on buf overflow
	rst	3		;"?BFO"
	dw	L1F08
L03DF:	lhld	norend		;vector for normal eols
	pchl			;go
;+
;
; Print char in A on CTY.
;
;-
pchr:	; print char in A on CTY
	push	psw
	lda	nopnt		;get "internal" mode flag
	ora	a		;set?
	jz	L03ED
	pop	psw		;trash all output if so
	ret
L03ED:
if klinik
	lda	cslmod		;mode 4?  (APT)
	cpi	_mode4
	jnz	L040A		;print if not
;;; what's APT mode?  anyway this is it, save up chars for packet protocol
	pop	psw
	push	h
	lhld	envpnt		;get env ptr
	mov	m,a		;save char
	inx	h
	mvi	m,0		;0 at end of buf
	shld	envpnt		;update ptr
	pop	h		;restore
	cpi	cr		;eol?
	rnz
	sta	mailfg		;set flag NZ if so
	ret
endif ; klinik
pchr1z:	push	psw
L040A:	in	81h		;get UART status
	ani	1		;xmtr rdy?
	jz	L040A		;spin until it is
if klinik
	lda	cslmod		;get KLINIK mode
	cpi	_mode3		;mode 3?  (parallel output)
	jnz	L0426		;no
L0419:	in	83h		;yes, wait until KLINIK xmtr is rdy too
	ani	1
	jz	L0419
	pop	psw		;restore char
	out	82h		;write to both
	out	80h
	ret
endif ; klinik
L0426:	pop	psw		;get char
	out	80h		;write to UART
	ret
;
if klinik
kchr:	; print in-line char on KLINIK line
	xthl
	mov	a,m
	inx	h
	xthl
kchr0:	; print char in A on KLINIK line
	push	psw
L042F:	in	83h		;spin until KLINIK xmtr rdy
	ani	1
	jz	L042F
	pop	psw		;write char
	out	82h
	ret
;
kline:	; print ASCIZ string at in-line addr using polled I/O
	xthl			;get arg ptr in DE
	call	targ1
	xthl
kline1:	ldax	d		;get a char
	inx	d		;ptr+1
	ana	a		;end?
	rz
	call	kchr0		;no, print and loop
	jmp	kline1
endif ; klinik
;+
;
; Print an ASCIZ string on CTY ior KLINIK line.
; \s in the line are replaced with crlfs.
;
;-
plne:	; continuation of code at RST 3 entry (in-line ptr)
	xthl			;restore return addr
	xchg			;pt with HL
pln1:	; enter here with string at (HL)
	mov	a,m		;get char
	inx	h
	cpi	'\'		;\?
	jz	L0457		;yes, print crlf instead
	ora	a		;end?
	rz
	call	pchr		;print if not
L0457:	cz	L045E		;crlf iff jumped here from above
	jmp	pln1		;loop
L045D:	pop	h
L045E:	; print crlf
	rst	1		;cr
	db	cr
	rst	1		;lf
	db	lf
	ret
;
L0463:	; cmd table, each entry is the 2-byte cmd name followed by the
	; dispatch addr, with the high bit set if the cmd requires an arg
	db	'RP'		;repeat other cmd(s) on line
	dw	rpcmd
	db	'DN'		;deposit next
	dw	dncmd+8000h
	db	'DC'		;deposit CRAM
	dw	dccmd+8000h
	db	'DM'		;deposit KS10 memory
	dw	dmcmd+8000h
	db	'LC'		;load CRAM addr
	dw	lccmd+8000h
	db	'LA'		;load KS10 memory addr
	dw	lacmd+8000h
	db	'DI'		;deposit I/O
	dw	dicmd+8000h
	db	'LI'		;load I/O addr
	dw	licmd+8000h
	db	'DB'		;deposit bus
	dw	dbcmd
	db	'DK'		;deposit 8080A mem
	dw	dkcmd+8000h
	db	'LK'		;load 8080A mem addr
	dw	lkcmd+8000h
	db	'EK'		;exam 8080A mem
	dw	ekcmd
	db	'LF'		;load diag func
	dw	lfcmd+8000h
	db	'DF'		;deposit diag func
	dw	dfcmd+8000h
	db	'MK'		;mark ucode (for scope)
	dw	mkcmd+8000h
	db	'UM'		;unmark ucode
	dw	umcmd+8000h
	db	'PE'		;parity enable/disable
	dw	pecmd
	db	'CE'		;cache enable
	dw	cecmd
	db	'TE'		;1ms clock enable
	dw	tecmd
	db	'TP'		;trap enable
	dw	tpcmd
	db	'ST'		;start
	dw	stcmd+8000h
	db	'HA'		;halt
	dw	hacmd
	db	'CO'		;continue
	dw	cocmd
	db	'SI'		;single instruction
	dw	sicmd
	db	'SM'		;start ucode
	dw	smcmd
	db	'MR'		;master reset
	dw	mrcmd
	db	'CS'		;start CPU clk
	dw	cscmd
	db	'CH'		;halt CPU clk
	dw	chcmd
	db	'CP'		;pulse CPU clk
	dw	cpcmd
	db	'EN'		;exam next
	dw	encmd
	db	'EM'		;exam KS10 memory
	dw	emcmd
	db	'EI'		;exam I/O
	dw	eicmd
	db	'EC'		;exam CRAM
	dw	eccmd
	db	'EB'		;exam bus
	dw	ebcmd
	db	'EJ'		;exam jumps (CRAM addr latches)
	dw	ejcmd
	db	'TR'		;trace
	dw	trcmd
	db	'RC'		;read CRAM ctrl reg
	dw	rccmd
	db	'ZM'		;zero memory (slooooowly)
	dw	zmcmd
	db	'PM'		;pulse ucode
	dw	pmcmd
	db	'BT'		;boot from disk
	dw	btcmd
	db	'BC'		;boot check (test boot path)
	dw	bccmd
	db	'LB'		;load boot
	dw	lbcmd
	db	'EX'		;execute KS10 instruction
	dw	excmd+8000h
	db	'LT'		;lamp test
	dw	ltcmd
if klinik
	db	'KL'		;KLINIK
	dw	klcmd
endif
	db	'ER'		;exam reg
	dw	ercmd
	db	'LR'		;load reg
if dumb
	dw	lrcmd
else
	dw	lrcmd+8000h	;arg required!
endif
	db	'DR'		;deposit reg
if dumb
	dw	drcmd
else
	dw	drcmd+8000h	;arg required!
endif
	db	'MT'		;magtape boot
	dw	mtcmd
	db	'DS'		;disk select (for BT cmd)
	dw	dscmd
	db	'MS'		;magtape select (for MT cmd)
	dw	mscmd
	db	'SH'		;orderly TOPS20 shutdown
	dw	shcmd
	db	'MB'		;magtape bootstrap
	dw	mbcmd
if klinik
	db	'PW'		;password
	dw	pwcmd
	db	'TT'		;KLINIK line to TTY
	dw	ttcmd
endif
	db	'VT'		;vfy against tape
	dw	vtcmd
	db	'VD'		;vfy against disk
	dw	vdcmd
	db	'X1'		;dummy (for testing?)
	dw	ramx1
	db	'FI'		;cmd file
	dw	ficmd+8000h
	db	'B2'		;boot check 2
	dw	b2cmd
if mm
	db	'MM'		;manufacturing mode
	dw	mmcmd
endif
	db	'SC'		;soft CRAM err recovery on/off
	dw	sccmd		;well at least they found SOMETHING to patent
	db	0		;thanks to Fairchild's lousy SRAMs
;
checks:	dw	94CFh,0C30Fh,0E373h,040Dh
;
L0564:	db	'\KS10 CSL.V5.2\',0
;
mrcmd:	; master reset
	xra	a		;zeroes
	out	8Ah		;clear RUN, EXECUTE, CONT
	call	chcmd		;stop CPU clk
mrint:	; do bus reset
	mvi	a,05h		;DP RESET, CRAM RESET
	out	84h		;reset CRAM
	mvi	a,80h		;b7=1
	out	40h		;issue reset, set console mode
	call	smfini		;set parity as instructed
	lda	trapen
	out	85h
	mvi	b,0		;set nothing in state word
	call	statem
	db	0Ah		;clear these bits
	ret
;+
;
; Hardware interrupt.
;
;-
intrp:	; (regs already saved)
	lxi	h,L0665		;set return addr
	push	h
	in	81h		;get status for both UARTs
	mov	b,a		;save CTY status
if klinik
	in	83h
	ora	b		;OR them
endif
	ani	38h		;any errors?
	jnz	L0814		;yes
	mov	a,b		;get CTY status
	ani	2		;rcvr done?
	jnz	L05BC		;yes
if klinik
	; must be KLINIK UART
	in	82h		;get char
	ani	7Fh		;trim to 7 bits
	mov	b,a		;save
	cpi	'Y'-100q ;^Y		;^Y?
	jnz	L05B8
	; ^Y
if mm
	lda	mmflg		;in manufacturing mode?
	ana	a
	jnz	mmerr1		;yes, abort
	mov	a,b
endif ; mm
L05B8:	lhld	moddis		;get KLINIK continuation addr
	pchl			;dispatch (char in A, B)
endif ; klinik
;
L05BC:	in	80h		;get the CTY char
	ani	7Fh		;trim to 7 bits
	mov	b,a		;save
if klinik
	lda	cslmod		;mode 4?
	ani	_mode4
	jz	mode3		;no
	; mode 4, echo CTY chars to KLINIK
	mov	a,b		;get char
	call	kchr0		;print on KLINIK line
	cpi	'Y'-100q;^Y		;did we just change modes?
	rnz
	; CTY user typed ^Y, switch to mode 2
	rst	5		;yes
	db	low klnksw
	rst	5
	db	low mmflg
	call	setm2		;set KLINIK mode 2
	jmp	reini		;restart
endif ; klinik
mode3:	lda	usrmd		;in user mode?
	ana	a
	mov	a,b		;[get char in A]
	jnz	L069E		;yes
	; front-end enabled, this is for us
	cpi	'O'-100q;^O		;^O?
	jnz	L05F4
	; ^O, trash output until next ^O or until flag is reset
	rst	1		;echo it
	db	'^'
	rst	1
	db	'O'
	lda	nopnt		;set "don't print" flag
	adi	80h		;(high bit so not affected by RST 2/RST 6)
	sta	nopnt
if dumb
	xra	a		;"zap char so we can early exit"
else
	ret			;what are we waiting for?!
endif
L05F4:	cpi	'S'-100q;^S		;XOFF?
	cz	L073E
	cpi	'Q'-100q;^Q		;XON?
	jnz	L0601
	rst	5		;yes, clear XOFF flag
	db	low stppd
if dumb
	xra	a
else
	ret
endif
L0601:	sta	rpend		;anything else stops RP
	cpi	'Z'-100q;^Z		;^Z?
	jz	L06D4
	cpi	'U'-100q;^U		;^U?
	jnz	L0618
	; ^U, cancel line
	rst	1		;echo it
	db	'^'
	rst	1
	db	'U'
	rst	4		;crlf
	db	02h
	call	bfrst		;flush CTY input buf
if dumb
	xra	a
else
	ret
endif
L0618:	cpi	'C'-100q;^C		;^C?
	jz	L0843
if dumb
	cpi	0		;check for those stupid "quick outs" above
	rz			;why ret now, could have done it then
endif
	cpi	','		;comma?
	jnz	L0629
	lxi	h,cmcnt		;yes, count it
	inr	m
L0629:	; echo the char
	cpi	'\'-100q;^\		;^\?
	cz	L0674
	cpi	cr		;cr?
	cz	L0674
	cpi	lf		;lf?
	cz	L0674
	lhld	buf_		;get buf ptr
	cpi	rub		;rubout?
	jz	L0683
	call	up_lo		;cvt to upper
	mov	m,a		;save the char
	inx	h		;bump ptr, save
	shld	buf_
if dumb
	mov	b,a		;copy
	sui	' '		;printing char?
	jm	L0658		;no
	mov	a,b
	sui	'~'
	jp	L0658		;no
	mov	a,b
else
	cpi	' '		;it's not a PDP8 y'know
	jm	L0658
	cpi	'~'
	jp	L0658
endif
	call	pchr		;printing char, echo it
L0658:	lda	bfcnt		;get buf count
	inr	a		;+1
	cpi	80d		;full?
	jz	L03DC		;?BFO
	sta	bfcnt		;save
	pop	h		;flush r.a., we didn't call anyone
L0665:	pop	h		;restore regs
	pop	d
	pop	b
	pop	psw
	ei			;ints back on after RET
	ret
;
up_lo:	; convert A to upper case
	cpi	'a'
	rm
	cpi	'z'+1
	rp
	sui	20h
	ret
;
L0674:	; eol char typed (cr, lf, ^\)
	rst	4		;crlf
	db	02h
	lda	cmcnt		;get # commas
	inr	a		;+1 (eol is end of cmd too)
	sta	eol		;set cmd count
	xra	a		;zap comma count
	sta	cmcnt
	cma			;on return, store 0FFh in buf
	ret
;
L0683:	; rubout (HL already set up to pt into buf)
	lda	bfcnt		;get # chars in buf
	ana	a		;stop at left marg
	rz
	dcr	a
	sta	bfcnt		;update
	dcx	h		;ptr-1, save
	shld	buf_
	rst	1		;echo /
	db	'/'
	mov	a,m		;get char
	call	pchr		;print it
	cpi	','		;,?
	rnz
	lxi	h,cmcnt		;yes, remove from count
	dcr	m
	ret
;
L069E:	; come here on char received in user mode
	cpi	'\'-100q;^\		;^\?
	jnz	L074D
L06A3:	; they want to return from user mode
	in	0C1h		;get "LOCK" switch
	ani	4		;console locked?
	rnz			;yes, ignore
;;; this is inelegant, should pass ^\ transparently to KS10
	rst	5		;cancel ^O or whatever
	db	low nopnt
	call	clruse		;leave user mode
	rst	3		;"ENABLED"
	dw	L06BC
	lxi	h,reini		;restart
L06B3:	pop	d
	pop	d
	pop	d
	pop	b
	pop	psw
	inx	sp
	inx	sp
	ei
	pchl			;dispatch
;
L06BC:	db	'ENABLED\',0
;
clruse:	; ^\ leave user mode
;;; EXCMD depends on this routine returning 0 in A
	rst	5		;clear user mode flag
	db	low usrmd
if mm
	lda	mmflg		;manufacturing mode?
	ana	a
	rz			;return if not
	call	setm4		;set mode 4
	call	kchr		;send char to KLINIK line
	db	'\'-100q;^\
endif
	ret
;
L06D4:	; ^Z, enter user mode
	call	setuse		;yep
	call	bfrst		;flush CTY input buf
	rst	3		;"USR MOD"
	dw	L06E3
	lxi	h,nullj		;ptr to null loop
	jmp	L06B3
;
L06E3:	db	'USR MOD\',0
;
setuse:	rst	2		;internal mode on
	call	examsh		;get keep-alive/reload bits from loc 31
	dw	31q
	rst	6		;internal mode off
	lda	gocode		;reload reason in bits 28-35
	lxi	h,dmdat		;pt at low byte of buf
	mov	m,a		;save reload reason
if mm
	lda	trapen		;get trap bit
	rlc			;shift to b7
	rlc
	rlc
	mov	b,a
	lda	mmflg		;manufacturing mode enabled?
	ana	a		;0 if not
	push	psw
	jz	L070B
	mvi	a,40h		;set b6 for manufacturing mode
L070B:	ora	b
endif ; mm
	inx	h		;pt at DMDAT+2
	inx	h
if mm
	mov	m,a		;save manufacturing mode bit
else
	mvi	m,0		;or not
	clc			;for RRC below
endif
	lda	parbt		;get parity enable flags
	rrc			;right 1
if klinik
	mov	b,a
	lda	cslmod		;mode 2 or 3?
	ani	_mode2+_mode3
	jz	L071E
	mvi	a,40h		;yes, set b6
L071E:	ora	b
else
	clc			;for RRC
endif
	rrc			;right another bit
	mov	b,a		;save
	lda	embuf+3		;get byte with curr "KA" bit
	ani	0C0h		;isolate
	ora	b		;OR in mode, parity bits
	inx	h
	mov	m,a		;save at DMDAT+3
	ana	a		;clear C bit to indicate deposit
	call	depsht		;write back loc 31
	dw	31q
	rst	5		;no reload code any more
	db	low gocode
if mm
	pop	psw
endif
	mvi	a,0FFh		;set user mode
	sta	usrmd
if mm
	rz			;return if not manufacturing mode
	call	ack		;send ACK over KLINIK port
	jmp	setm2
else
	ret
endif
;
L073E:	; here if XOFF received
	lxi	h,stppd		;pt at flag
	mov	a,m		;get it, flip
	cma
	ana	a		;was it already set?
	rz			;yes, no op
	mov	m,a		;set flag
	ei			;ints on to allow XON in
L0747:	mov	a,m		;sit 'n spin until flag clears
	ana	a
	rz
	jmp	L0747
;
L074D:	; send char in A to KS10
	sta	chrbuf		;save
	mvi	a,32q		;set bits 28-35 of addr (loc 32)
	out	43h
	xra	a		;the others are all zeroes
	out	45h		;bits 20-27
	out	47h		;12-19
	out	46h		;12-19 of data zapped too
	out	48h		;4-11
	out	4Ah		;0-3
	mvi	a,2		;func=deposit
	out	4Bh
	add	a		;4=COM/ADR CYCLE
	out	4Dh
	lda	chrbuf		;get bits 28-35 of data
	out	42h
	mvi	a,1		;bit 27="valid" bit
	out	44h		;bits 20-27
	out	4Ch		;write 1 to data xfr arbitrator
	mvi	a,0F0h		;CHECK NXM, CSL REQ, T ENB COM/ADR,
				;T ENB DATA CYC
	out	88h
	mvi	a,1		;interrupt the KS10
	out	4Eh
	out	4Eh		;twice (apparently necessary?)
	ret
;
chrrdy:	; char ready "interrupt" from KS10, pick it up
	rst	2		;internal mode on
	di
	lda	trapen		;get trap enable bits
	out	85h		;clear "interrupt"
if klinik
	call	examsh		;read KLINIK buffer
	dw	35q
	rst	6		;internal mode off
	lda	embuf+1		;get "valid" flag
	ana	a		;set?
	jz	L07BB		;no, must be CTY
	mov	b,a		;save flag bits
	lda	cslmod		;see what mode we're in
	ani	_mode0+_mode1+_mode3 ;0, 1, 3 => throw char away
	jnz	L07B5
	mov	a,b		;recover bits
	cpi	1		;char+400'?
	jz	L07A9		;yes, just output the char
	cpi	2		;char+1000'?
	jnz	L0812		;no, ignore
	call	hangzk		;yes, hang up, KLNKSW=0
	ei			;what makes you think we're done?
	ret
L07A9:	in	83h		;spin until KLINIK xmtr rdy
	ani	1
	jz	L07A9
	lda	embuf		;get char
	out	82h		;write it
L07B5:	mvi	a,35q
if ver42
	jmp	ttocom
else ; good fix, otherwise would drop chars if both running at once
	call	ttocom
	di
endif ; ver42
endif ; klinik
L07BB:
if dumb
	rst	2		;internal mode on (already done above)
endif
	call	examsh		;exam CTY buffer
	dw	33q
	rst	6		;internal mode off
	lda	embuf+1		;get bits 20-27
	cpi	1		;char+400'?
	jnz	L0812		;no, ignore
	lda	embuf		;yes, get char
	mov	b,a		;save it
L07CE:	in	81h		;spin until xmtr ready
	ani	1
	jz	L07CE
if klinik
	lda	cslmod		;check KLINIK mode
	cpi	_mode3		;echoing to both?
	jnz	L07E7		;skip if not
L07DD:	in	83h		;spin until KLINIK is also ready
	ani	1
	jz	L07DD
	mov	a,b		;get char
	out	82h		;type it out
endif ; klinik
L07E7:	mov	a,b		;get the char
	out	80h		;write to CTY
	mvi	a,33q		;zap the locn we read
ttocom:	out	43h		;write bits 28-35 of addr
	xra	a		;load 0
	out	45h		;zap bits 20-27 of addr
	out	47h		;12-19 too
	out	42h		;28-35 of data are 0
	out	44h		;20-27
	out	46h		;12-19
	out	48h		;4-11
	out	4Ah		;0-3
	mvi	a,2		;func=deposit
	out	4Bh
	add	a		;4=COM/ADR CYCLE
	out	4Dh
	mvi	a,1		;DATA CYCLE
	out	4Ch
	mvi	a,0F0h		;CHECK NXM, CSL REQ, T ENB FOR COM/ADR,
				;T ENB FOR DATA CYCLE
	out	88h
L080C:	mvi	a,1		;int KS10 to confirm
	out	4Eh
	out	4Eh		;twice for some reason
L0812:	ei			;reenable
	ret
;
L0814:	; UART error
	mov	a,b		;get CTY status bits
	ani	38h		;isolate errors
	jnz	L0826		;at least one set, skip
	; must be KLINIK err
	mvi	a,15h		;reset the UART
	out	83h
	lda	usrmd		;user mode?
	ana	a
	jnz	L05BC		;yes, just deal
	ret
L0826:	; CTY error
if ver42 or (dumb eq 0)
	ani	28h		;check for overrun or fatal error
else
	ani	68h		;didn't we just clear b6?  should use 28h
endif
	mvi	a,15h		;[reset UART]
	out	81h
	jnz	L0836		;go complain
	lda	usrmd		;user mode?
	ora	a
	jnz	L05BC		;just deal if so
L0836:	; print error msg
if klinik
	lxi	h,cslmod	;get KLINIK mode
	mov	c,m
	mvi	m,0		;clear CSL mode temporarily
	push	h
endif
	rst	3		;"?UI" (what do you suppose this means?)
	dw	L1F13
if klinik
	pop	h
	mov	m,c
endif
	ret
;
L0843:	; ^C
	lxi	sp,ramst+ramsz	;reset stack
	rst	1		;echo ^C
	db	'^'
	rst	1
	db	'C'
	jmp	reini		;restart
;+
;
; Flush CTY input buf.
;
;-
bfrst:	lxi	h,bufbg		;pt at begn of buf
	shld	buf_		;with buf ptr
	shld	first		;and cmd ptr
	rst	5
	db	low rpend	;zap RP
	rst	5
	db	low cmds__	;finished interpreting line
	rst	5
	db	low bfcnt	;no chars in buf
	ret
;+
;
; KLINIK line mode 0 (default).
; Line is disabled, but no pw defined.
;
;-
if klinik
mode0:	cpi	bel		;ignore bells (why?)
	rz
	call	kline		;"?NA" (no access)
	dw	L1FDF
	jmp	hangzk		;hang up, KLNKSW=0, return
endif
;+
;
; KLINIK mode 1 -- switch in "protect" posn, waiting for pw entry.
;
; V5.2 change:  the password chars are compared as they are entered.
; In V4.2, they were buffered until cr and then checked, more code.
;
;-
if klinik
mode1:	call	kline		;"PW:"
	dw	L1FE5
	lxi	h,kpwbuf	;init pw buf ptr
	shld	kpwpnt
	rst	5		;# chars=0
	db	low kpwcnt
	rst	5
	db	low L2057
	lxi	h,L087E		;pw char handler
	shld	moddis
	ret
;
L087E:	; here on KLINIK pw char
	cpi	cr		;eol?
	jz	L08A2
	call	up_lo		;no, cvt to upper
	lhld	kpwpnt		;get ptr
	cmp	m		;match?
	inx	h		;[ptr +1, update it]
	shld	kpwpnt
	jz	L0895		;yep
	lxi	h,L2057		;no match, set err flag
	inr	m
L0895:	lda	kpwcnt		;count the char
	inr	a
	cpi	7		;too many?
	jz	L08B1		;punt if so
	sta	kpwcnt
	ret
L08A2:	; cr typed -- see if pw is OK
	lhld	kpwpnt		;get ptr
	mov	a,m		;end?
	ana	a
	jnz	L08B1		;no, err
	lda	L2057		;get err flag
	ana	a		;bad char typed?
	jz	L08C3		;no, happy
L08B1:	; here on bad password
	call	kline		;"?IL<cr><lf>"
	dw	L1F0D
	lxi	h,pwrtry	;count this try
	inr	m
	mov	a,m		;was it try #3?
	cpi	3
	jz	L08CE		;yes, you lose
	jmp	mode1		;otherwise reprompt
;
L08C3:	; password was OK, let them in
	call	setm2		;bump to mode 2
	call	kline		;"OK"
	dw	L1FEB
L08CB:	rst	5		;reinit pw retry ctr
	db	low pwrtry
	ret
L08CE:	call	hangup		;go hang up
	call	setm1		;back to mode 1
	jmp	L08CB		;zap pw retry count, return
endif ; klinik
;+
;
; KLINIK mode 2.
; Like "user mode" to KS10, only uses KS10 words 34/35 instead of 32/33.
;
;-
if klinik
mode2:	cpi	'\'-100q;^\		;do they want out?
	jnz	L08EF		;no
	; they want to go to mode 3
if mm
	lda	mmflg		;in manufacturing mode?
	ana	a
	jnz	L06A3		;yes, pretend came from CTY
endif
	lda	klline		;change allowed?
	ana	a
	rz			;no
	in	0C1h		;see if enabled via front panel switch
	ani	4
	jz	setm3		;yes, go do it
L08EF:	; it's just a char, write it to KS10
	sta	chrbuf		;save
	mvi	a,34q		;addr to deposit
	out	43h		;bits 28-35 of addr
	xra	a		;all other bits 0
	out	45h		;bits 20-27
	out	47h		;12-19
	out	46h		;data bits 12-19 are 0 too
	out	48h		;4-11
	out	4Ah		;0-3
	mvi	a,2		;func=deposit
	out	4Bh
	add	a		;4=COM/ADR CYCLE
	out	4Dh
	lda	chrbuf		;get the char
	out	42h		;write data bits 28-35
	mvi	a,1		;valid bit (bit 27)
	out	44h		;write bits 20-27
	out	4Ch		;write 1 to arbitrator
	mvi	a,0F0h		;CHK NXM, CSL REQ, T ENB FOR COM/ADR,
				;T ENB FOR DATA CYCLE
	out	88h
	mvi	a,1		;int the KS10
	out	4Eh
	out	4Eh		;twice
	ret
endif ; klinik
;
	subttl	commands
ebcmd:	; examine bus
	mvi	a,1		;clear R CLK ENB
	out	88h
	call	rdatt		;read bus bits
	dw	embuf
	lxi	h,rm100
	lxi	d,L096B		;pt at list of regs
	mvi	b,8		;# regs
L092F:	ldax	d		;get reg #
	call	er_utl		;use ER code
	mov	m,a		;save value
	inx	d		;ptrs +1
	inx	h
	dcr	b		;loop through all
	jp	L092F
	xra	a		;reenable R CLK ENB
	out	88h
	rst	3		;"BUS 0-35"
	dw	L1F18
if klinik
	call	decnet		;send to KLINIK too
endif
	call	p36_		;print it
	rst	4		;crlf
	db	02h
if klinik
	call	decnet		;flush KLINIK stuff
endif
	lxi	h,L096B		;pt at reg #'s
	lxi	d,rm100		;and data area where stored
	mvi	b,8		;loop count
L0953:	call	p8bit		;print reg #
	inx	h
	rst	1		;/
	db	'/'
	xchg			;print contents
	call	p8bit
	inx	h
	xchg			;restore regs
	rst	1		;<sp>
	db	' '
	dcr	b		;loop through all
	jnz	L0953
	rst	4		;crlf
	db	02h
if klinik
	call	decnet		;flush to KLINIK too
endif
	ret
;
L096B:	db	40h,41h,42h,43h,0C0h,0C1h,0C2h,0C3h ;I/O regs read by EB
;
dbcmd:	; deposit bus
	rst	4		;make sure not running
	db	06h
	jc	L097C		;skip if no arg
	rst	4		;get arg
	db	08h
	dw	busad
L097C:	call	adatt		;write to addr latches
	dw	busad
	xra	a		;cycle type=none
	out	4Dh
	mvi	a,61h		;CSL REQ, T ENB FOR COM/ADR
	out	88h
	call	busres		;look for arbitrator response
	db	arbres
	jnz	L1E09		;nothing, punt
	call	dbrdin		;read & compare
	jnz	L09CB		;lose
	call	adatt		;write zeroes
	dw	mad000
	call	wdatt		;write to addr latches
	dw	busad
	mvi	a,1		;DATA CYCLE
	out	4Ch
	mvi	a,0F3h		;CSL REQ, T ENB FOR COM/ADR,
				;T ENB FOR DATA CYCLE, LATCH DATA SENT
	out	88h
	call	busres		;arb response?
	db	arbres
	jnz	L1E09		;no, punt
	call	busres		;DATA ACKNOWLEDGE?
	db	datack
	jz	L1DFF		;no
	call	dbrdin		;read/compare
	rz			;happy
	rst	1
	db	'D'		;data compare err
	jmp	L09CD
;
dbrdin:	; read KS10 bus, compare with data we think we wrote
	call	rdatt		;read bus
	dw	tmpb2
	call	cmp36		;match?
	dw	busad
	dw	tmpb2
	ret			;(flags set)
;
L09CB:	rst	1		;err writing cmd cycle
	db	'C'
L09CD:	rst	3		;" CYC<crlf>SENT/"
	dw	L1F29
	lxi	h,busad		;show the addr
	call	p36
	rst	3		;"RCVD/"
	dw	L1F34
	lxi	h,tmpb2		;show the data read
	call	p36
	rst	4		;crlf
	db	02h
	lxi	h,4		;error code
	jmp	errrtn
;
emcmd:	; examine memory
if dumb
	jc	L09ED		;skip if no arg
	 call	lacmd		;do "LA <addr>"
else
	cnc	lacmd
endif
L09ED:	xra	a		;set up for "EN" cmd
	sta	enext
em2:	lxi	d,memad		;pt at addr
emint:	mvi	a,4		;func=exam
L09F6:	mov	b,a		;save
	xchg			;save HL
	shld	am_ai
	xchg
	call	adatp		;write addr
	mov	a,b		;restore func
em_crm:	out	4Bh		;write it
	mvi	a,4		;COM/ADR CYC
	out	4Dh
	lda	eiflag		;doing EI cmd?
	ana	a
	jnz	L0A0F		;yes (A holds func bits)
	 mvi	a,0E3h		;CHECK NXM, CSL REQ, T ENB FOR COM/ADR,
				;LATCH DATA SENT, R CLK DISABLE
L0A0F:	out	88h		;write the bits
	xra	a		;won't be EI cmd next time unless set again
	sta	eiflag
	call	busres		;hello?
	db	arbres
	jnz	L1E09		;no one home
	call	busres		;NXM?
	db	nonxme
	jnz	L1E15		;yes
	call	busres		;DATA ACKNOWLEDGE?
	db	datack
	jz	L1DFF		;no, punt (had 15 usec)
	; happy, print data
	lxi	d,embuf		;pt at buf
	call	rdatp		;get data
	xra	a		;set R CLK ENABLE
	out	88h
	lda	nopnt		;printing disabled?
	ana	a
	rnz			;return if so
	lhld	am_ai		;print addr
	call	p36
	rst	1		;/
	db	'/'
	call	p36_		;print data examined
	rst	4		;crlf
	db	02h
	ret
;
enem:	; EN after EM
	call	inc36		;addr +1
	dw	memad
	jmp	L09ED		;go do EM
;
encmd:	; examine next loc
	lhld	enext		;get type of previous exam cmd
	lxi	d,L0A5A		;add base of table
	dad	d
	mov	e,m		;look up addr
	inx	h
	mov	d,m
	xchg			;put in HL
	pchl			;and dispatch
L0A5A:	dw	enem,enei,enek,enec
;
dndm:	; DN after DM
	call	inc36		;addr +1
	dw	memad
dmcmd:	; deposit memory
	rst	4		;get arg
	db	08h
	dw	dmdat
dm1:	xra	a		;cmd type=DM
	sta	dnext
dm2:	lxi	d,memad		;get ptr to addr
dmint:	; deposit memory, internal format (DE=>addr, DMDAT=data)
	mvi	a,2		;func=deposit
L0A74:	mov	b,a		;save func
	call	adatp		;set addr latches
	mov	a,b		;write func to high bits of bus
	out	4Bh
	mvi	a,4		;COM/ADR CYCLE
	out	4Dh
	call	wdatt		;write data latches
	dw	dmdat
	mvi	a,1		;DATA CYCLE
	out	4Ch
	lda	diflag		;doing DI cmd?
	ana	a
	jnz	L0A91		;yes
dmgo:	mvi	a,0F2h		;CHECK NXM, CSL REQ, T ENB FOR COM/ADR,
				;T ENB FOR DATA CYCLE
				;(LATCH DATA SENT prevents false parity err)
L0A91:	out	88h
	xra	a		;it isn't DI any more
	sta	diflag
	call	busres		;BUS REQ?
	db	arbres
	jnz	L1E09		;no
	call	busres		;NXM?
	db	nonxme
	jnz	L1E15		;yes
	ret
;
dncmd:	; deposit next loc
	lhld	dnext		;get type offset
	lxi	d,L0AB2		;add base of table
	dad	d
	mov	e,m		;look up addr
	inx	h
	mov	d,m
	xchg			;put in HL
	pchl			;dispatch
L0AB2:	dw	dndm,dndi,dndk,dndc
;
eicmd:	; examine I/O
	rst	4		;CPU must be halted
	db	06h
;;; how come EI cares when DI doesn't?
if dumb
	jc	ei1		;no arg, skip
	 call	licmd
else
	cnc	licmd
endif
ei1:	mvi	a,2		;save type for EN
	sta	enext
	lxi	d,ioad		;pt at I/O addr
	mvi	a,63h		;func bits for EI
	sta	eiflag
	mvi	a,0Ch		;func=I/O exam
	jmp	L09F6
;
enei:	; EN after EI
	call	io_inc		;I/O addr +2
	jmp	ei1		;jump into EI code
;
dndi:	; DN after DI
	call	io_inc		;I/O addr +2
dicmd:	; deposit I/O
	rst	4		;parse arg
	db	08h
	dw	dmdat
di1:	mvi	a,2		;set "DN" type
	sta	dnext
	lxi	d,ioad
	mvi	a,70h		;func bits for DI
	sta	diflag
	mvi	a,0Ah		;func=I/O depos
	jmp	L0A74
;
io_inc:	; add 2 to I/O addr (Unibus assumed)
	call	inc36
	dw	ioad
	call	inc36
	dw	ioad
	ret
;
ekcmd:	; examine 8080A mem
	jc	L0B05		;skip if no arg
	rst	4		;fetch 16-bit arg
	db	04h
	dw	c80ad
L0B05:	mvi	a,04h		;set EN type code
	sta	enext
	lxi	h,c80ad		;print addr
	call	p16
	rst	1
	db	'/'		;/
	lhld	c80ad		;data
	mov	a,m
	jmp	p8crlf		;and crlf, return
;
enek:	; EN after EK
	lhld	c80ad		;addr +1
	inx	h
	shld	c80ad
	jmp	L0B05		;go exam
;
lacmd:	; load address for EM/DM
;;; should set type for EN/DN
	rst	4		;parse addr
	db	08h
	dw	memad
	ret
;
licmd:	; load address for EI/DI
;;; should set type for EN/DN
	rst	4		;parse addr
	db	08h
	dw	ioad
	ret
;
lkcmd:	; load address for EK/DK
;;; should set type for EN/DN
	rst	4		;parse addr
	db	04h
	dw	c80ad
	ret
;
dndk:	; DN after DK
	lhld	c80ad		;get addr
	inx	h		;+1
	shld	c80ad		;save
;
dkcmd:	; deposit 8080A mem
	call	arg16_		;get data
	mov	a,l		;into A
	lhld	c80ad		;get addr
	mov	m,a		;store data (fry if EPROM)
	mvi	a,04h		;save code for DN
	sta	dnext
	ret
;
cpcmd:	; CPU clock pulse
	jc	cp1		;single clock if no arg
	call	arg16_		;get arg
L0B4D:	mov	a,l		;done all?
	ora	h
	rz			;return if so
	call	cp1		;otherwise do a pulse
	dcx	h		;count it
	jmp	L0B4D		;loop
cp1:	; here to do a single clock pulse
	mvi	a,08h		;SS MODE
	out	84h
	mvi	a,02h		;SINGLE CLK
	out	86h
	ret
;
ercmd:	; examine 8080A I/O regs
	jc	L0B6A		;no arg, use what we have
	call	arg16_		;get arg into A
	mov	a,l
	sta	eraddr		;save addr
L0B6A:	lda	eraddr		;load it back
	push	psw		;save
	call	p8bita		;print reg #
	rst	1		;/
	db	'/'
	pop	psw		;restore reg #
	call	er_utl		;build an IN instruction, read data
if dumb
	call	p8crlf		;print it, crlf
	ret
else
	jmp	p8crlf
endif
;
ramxct:	; do I/O to/from 8080A I/O regs -- L=IN or OUT opcode, H=I/O addr
	shld	er_loc		;save opcode
	push	psw		;patch in a RET
	mvi	a,0C9h
	sta	er_loc+2
	pop	psw
	call	er_loc		;call it
	cma			;everything reads backwards
	ret
;
er_utl:	; read 8080A I/O loc A, return data in A
	push	h
	mov	h,a		;build IN inst
	mvi	l,0DBh
	call	ramxct		;read it
	pop	h
	ret
;
lrcmd:	; load address for ER/DR
;;; should set type for EN/DN
	call	arg16_		;get 8-bit addr
	mov	a,l
	sta	eraddr		;save
	ret
;
drcmd:	; deposit 8080A I/O reg
	rst	4		;parse 16-bit arg
	db	04h
	dw	t80dt
	mvi	l,0D3h		;form OUT instr
	lda	eraddr
	mov	h,a
	lda	t80dt		;get data to write
if dumb
	call	ramxct		;do it
	ret
else
	jmp	ramxct
endif
;
lccmd:	; load CRAM address
	rst	4		;parse 16-bit arg
	db	04h
	dw	crmad
	ret
;
cecmd:	; cache enable set/clear
	jc	L0BCA		;no arg, show status
	call	arg16_		;get arg
	mov	a,l		;get b0
	ral			;shift to b3
	ral
	ral
	ani	08h		;isolate
	mov	b,a		;save
	lda	parbt		;get current parity/cache bits
	ani	0F7h		;mask off b3
L0BC3:	ora	b		;OR in the new one
ks_par:	sta	parbt		;save
	out	40h		;update
	ret
L0BCA:	; CE w/no arg, show current setting
	lda	parbt		;get par/cache bits
	ani	08h		;isolate b3
L0BCF:	jnz	L0BD6		;skip if set
	rst	3		;"OFF"
	dw	L1F63
	ret
L0BD6:	; yech, this is actually less bytes than RST 3
	rst	1		;"ON"
	db	'O'
	rst	1
	db	'N'
	rst	4		;crlf
	db	02h
	ret
;
tecmd:	; 1 msec clock enable set/clear
	jc	L0BF1		;no arg, show status
	call	arg16_		;get arg
	mov	a,l		;move b0 to b2
	ral
	ral
	ani	04h		;isolate it
	mov	b,a		;save
	lda	parbt		;get current bits
	ani	0FBh		;mask b2 off
	jmp	L0BC3		;finish using CE code
L0BF1:	; TE w/no parm, show status
	lda	parbt		;get bits
	ani	04h		;test b2
	jmp	L0BCF		;print ON or OFF with CE code
;
sccmd:	; soft CRAM recovery on/off
	; (they patented this, had to do it because of flakey 93L415's)
	jc	L0C0F		;no arg, show status
	call	arg16_		;parse arg
	mov	a,l
	ana	a		;0?
	jz	L0C09		;yes, disable
	xra	a		;enable
	sta	sc_off
	ret
L0C09:	; disabling SCE recovery
if dumb
	mvi	a,0FFh		;set flag
else
	cma			;we know A is 0
endif
	sta	sc_off
	ret
L0C0F:	; SC w/no arg, show status
	lda	sc_off		;get flag
	cma			;flip
	ana	a		;set CC
	jmp	L0BCF		;go print status w/CE code
;
tpcmd:	; trap enable set/clr
	jc	L0C27		;no arg, show status
	call	arg16_		;get arg
	mov	a,l		;move b0 to b4
	ral
	ral
	ral
	ral
	ani	10h		;isolate
	jmp	L11E9		;fix TRAPEN, OUT 40h, return
L0C27:	; no arg, show status
	lda	trapen		;get bits
	ani	10h		;isolate b4
	jmp	L0BCF		;go show state
;
ltcmd:	; lamp test
	rst	5		;force light update (huh?)
	db	low klnksw
	mvi	a,07h		;1's
	out	41h		;turn them on
	call	L0C3B		;delay
	xra	a		;turn them off
	out	41h
L0C3B:	lxi	h,300d		;loop count (around 1.5 sec)
ltloop:	; loop HL times
	call	delay_		;short delay
	db	-1
	dcx	h		;HL-1
	mov	a,l		;done?
	ora	h
	jnz	ltloop
	lda	state		;restore the lights (etc.) to old value
	out	41h
	ret
;
if mm
mmcmd:	; put 8080A in manufacturing mode
	call	setm4		;KLINIK mode 4
	mvi	a,41q		;starting msg #
	sta	lstmsg		;init rcv msg #
	sta	envmno		;and xmt msg #
	sta	mmflg		;set MM flag
	call	z_tbuf		;zero some stuff
	jmp	decex2		;clear envelopes, return
endif
;
sicmd:	; single instruction step
	in	0C0h		;get RUN FF
	ani	04h		;running?
	jz	L170B		;yes, must halt first
	mvi	a,1		;CONTINUE
	out	8Ah
	call	dnf		;check for completion
	jmp	pccom		;print PC, return
;
cscmd:	; KS10 clock start
	call	setrn		;set RUN FF
	xra	a		;clear SS mode
	out	84h
	mvi	a,3		;CLK RUN, SINGLE CLK
	out	86h
	ret
;
chcmd:	; KS10 clock halt
	call	clrrn		;clear RUN ff
	mvi	a,08h		;set SS mode
	out	84h
	xra	a		;SINGLE CLK, CLK RUN
	out	86h
	ret
;
lfcmd:	; load diagnostic function
	call	arg16_		;get it
	shld	crmfn		;save (why 16 bits for a 4-bit qty?)
;;;; this appears to be the only place CRMFN is refed as a word
	ret
;
dfcmd:	; deposit diagnostic function
	rst	4		;CPU must be halted
	db	06h
	call	arg16_		;get arg
	push	h		;save
	call	crm_ad		;set CRAM addr from LC cmd
	pop	h		;restore
wfunc:	; write data in HL, function in CRMFN
	mov	a,l		;get low byte of data
	out	43h		;write bits 28-35
	mov	a,h		;high byte
	out	45h		;bits 20-27
L0CA0:	xra	a		;cycle type=none
	out	4Dh
	mvi	a,64h		;CSL REQ, T ENB FOR COM/ADR, CRA R CLK
	out	88h
	lda	crmfn		;get func saved with LF
	out	85h		;write to diag port
; TRAP EN just got cleared, but only needed when ucode running
; and all cmds to start ucode will reset it
	mvi	a,20h		;CRAM WRT
	out	84h		;write to CRAM ctrl port
	xra	a		;clear CRAM WRT
	out	84h
	ret
;
crm_ad:	; load CRAM addr latches from LC cmd
	lhld	crmad		;get addr to use
cadwr:	; set CRAM addr latches to value in HL
	mvi	a,1		;CRAM RESET
	out	84h
	xra	a		;clear CRAM RESET
	out	84h
	mov	a,l		;write addr in low 12 bits of latches
	out	43h
	mov	a,h
	out	45h
	xra	a		;clear all others
	out	47h
	out	49h
	out	4Bh
	out	4Dh		;cycle type=0
	mvi	a,64h		;CSL REQ, T ENB FOR COM/ADR, CRA R CLK
	out	88h
	mvi	a,11h		;CRM ADDR LOAD
	out	84h
	xra	a		;clear CRM ADDR LOAD
	out	84h
	ret
;
readc:	; diag func read
	mov	d,a		;save
	lda	trapen		;OR in trap enables
	ora	d
	out	85h		;write diag func
	mvi	a,4Dh		;CSL REQ, CRA T CLK, R CLK ENB, CRA R CLK
	out	88h
	in	00h		;get bits 28-35
	cma			;(inverted from bus)
	sta	tmpb2		;save
	in	01h		;get bits 20-27
	cma			;(fix inversion)
	ani	0Fh		;mask to 12 bits
	sta	tmpb2+1		;save
	xra	a		;clear
	out	88h
	ret
;
rccmd:	; read CRAM control register
	rst	4		;CPU must be halted
	db	06h
rcint:	xra	a
	lxi	b,crmbf+(16d*2)-1 ;init buf ptr
L0CFC:	mov	e,a		;save a
	call	readc		;read diag func
	lda	nopnt		;printing disabled?
	ana	a
	jnz	L0D19		;yes, skip all this
	mov	a,e		;print diag func name
	call	p8bita
	rst	1		;/
	db	'/'
	call	p16_		;print
	rst	4		;crlf
	db	02h
if klinik
	push	b
	push	d
	call	decnet		;keep KLINIK up to date if enabled
	pop	d
	pop	b
endif
L0D19:	; save RC stuff in buf
	lhld	tmpb2		;get data
	mov	a,h		;save (byte-swapped for some reason)
	stax	b
	dcx	b		;post-decrement
	mov	a,l
	stax	b
	dcx	b
	inr	e		;buf full?
	mov	a,e
	cpi	16d
	jnz	L0CFC		;loop if not
	ret
;
ejcmd:	rst	4		;CPU must be halted
	db	06h
	lxi	h,L0D4F		;"CUR/", "NXT/", "J/", "SUB/"
	lxi	b,0487h		;b=4, c=10 00 01 11
L0D32:	mov	a,c		;get pair of bits from c
	ani	3		;isolate low 2 as diag func
	call	readc		;read whatever it is
	call	pln1		;print next heading
	push	h		;save hdng ptr
	call	p16_		;print data
;;; should display the / inline too
	rst	1		;<sp><sp>
	db	' '
	rst	1
	db	' '
	pop	h		;restore hdng ptr
	mov	a,c		;shift next func into place
	rrc
	rrc
	mov	c,a		;and put back in C
	dcr	b		;loop through all 4
	jnz	L0D32
	rst	4		;crlf
	db	02h
	ret
;
L0D4F:	db	'CUR/',0	;current CRAM loc
	db	'NXT/',0	;next CRAM loc
	db	'J/',0		;J field of uinstruction
	db	'SUB/',0	;top of subroutine stack
;
trcmd:	; trace microcode
	; EJ followed by single ustep, continues until user types a char
	; if arg is given, it's a break addr at which to stop
	jc	L0D6D		;no arg, just go
	rst	4		;get 16-bit arg
	db	04h
	dw	brkdt
	mvi	a,3Fh		;set flag non-zero
	sta	brkon
L0D6D:	rst	4		;CPU must be halted
	db	06h
	rst	5		;shoot out RP cmd ctr so we can poll it
	db	low rpend
L0D71:	lda	brkon		;was break addr given?
	ana	a
	jz	L0D7F		;no
	lxi	d,brkdt		;yes, pt at addr
	call	break		;see if break addr reached
	rz			;return if so
L0D7F:	call	pulse		;pulse ucode
	rst	4		;crlf
	db	02h
	lda	rpend		;have they typed anything?
	ana	a
	jz	L0D71		;loop if not
	rst	5		;clear break flag if so
;;; bug:  if they type ^C and later type another TR cmd w/no arg,
;;; the previous break addr will be used anyway
	db	low brkon
	ret
;
pmcmd:	; pulse microcode (single ustep)
	rst	4		;machine must be halted
	db	06h
pulse:	call	cp1		;one clock
if dumb
	call	ejcmd		;EJ
	ret
else
	jmp	ejcmd
endif
;
eccmd:	; examine CRAM
	rst	4		;must be halted
	db	06h
if dumb
	jc	L0DA9
	call	lccmd		;get addr if arg given
else
	cnc	lccmd
endif
L0D9F:	rst	4		;clear buf
	db	0Ah
	dw	tmpb2+5
	call	crm_ad		;set CRAM addr
	call	cp1		;do a clock pulse (ld ctrl reg)
L0DA9:	mvi	a,06h		;set type for EN
	sta	enext
	lxi	h,L0E08		;list of diag funcs to rd
L0DB1:	mov	a,m		;get next one
	inx	h
	ana	a		;end of list?
	jm	L0DCB		;yes (FF marks end)
	call	readc		;read
	shld	ecsav		;save data (stack is about to get trashed)
	lxi	h,tmpb2		;pt at data read
	call	octal		;convert the next 4 digits (put on stack)
	db	2,4		;2 bytes, 4 digits
	lhld	ecsav		;restore ptr
	jmp	L0DB1		;loop
L0DCB:	; all read, digits on stack
	; but for some idiotic reason we have two copies of *SOME* bits,
	; so compare them
	mov	a,m		;table continues, get func
	inx	h
	ana	a		;end of table?
	jm	L0DF1		;yes
	call	readc		;read into TMPB2
	rst	4		;copy
	db	00h
	dw	tmpb2		;from TMPB2
	dw	tmpbf2		;to TMPBF2
	mov	a,m		;get bits w/which to compare
	inx	h
	call	readc		;read into TMPB2
	push	h
	call	cmp36		;compare
	dw	tmpb2		;bits just read
	dw	tmpbf2		;with those read earlier
	pop	h
	jz	L0DCB		;loop if matched
	; A and B copies didn't match
	rst	3		;"?A/B"
	dw	L1F3B
	jmp	rcint		;go do RC
L0DF1:	; print out this loc
	mvi	a,03h		;we seem to have forgotten the CRAM address
	call	readc		;get it
	call	p16_		;print it (6 digits even though 4 will do)
	rst	1		;/
	db	'/'
	mvi	b,32d		;digit count
L0DFD:	pop	psw		;pull chars off stack
	call	pchr		;and print them
	dcr	b
	jnz	L0DFD		;until done all
	rst	4		;crlf
	db	02h
	ret
;
L0E08:	; table of diag funcs to read 12-bit bytes CRAM for EC
	db	0Fh		;84-95
	db	0Eh		;72-83
	db	0Dh		;60-71
	db	0Ch		;48-59
	db	0Ah		;36-47A
	db	05h		;24-35A
	db	04h		;12-23
	db	00h		;0-11
	db	-1
	; some of the bits have duplicates but not all -- WHY?
	db	0Ah,0Bh		;36-47A, 36-47B
	db	05h,06h		;24-35A, 24-35B
	db	-1
;
enec:	; EN after EC
	lhld	crmad		;get addr
	inx	h		;+1
	shld	crmad		;save
	jmp	L0D9F		;go do EC
;
dndc:	; DN after DC
	lhld	crmad		;get adr
	inx	h		;+1
	shld	crmad		;save
dccmd:	; deposit CRAM
	rst	4		;must be halted
	db	06h
	call	arg96		;read arg (we're ARG96's only caller)
	dw	crmtm
	lxi	d,crmbf		;buf for 12-bit bytes in 16-bit words
	lxi	h,crmtm		;buf for packed 8-bit bytes
	mvi	c,4		;loop count
L0E36:	call	place		;get first 12 bits
	mvi	a,3		;# bytes for SHR24
	call	shr24		;shift right
	db	12d		;bit count
	call	place		;grab 2nd 12 bits
	inx	h		;skip 24 bits
	inx	h
	inx	h
	dcr	c		;done all 4 sets of 24?
	jnz	L0E36		;loop if not
	call	crm_ad		;set CRAM addr
	lxi	h,crmbf		;pt at  data
	mvi	a,06h		;set type for DN
	sta	dnext
	inr	a		;initial func=07h
	lxi	b,crmfn		;ptr at func (needed by WFUNC)
L0E58:	stax	b		;save func
	mov	e,m		;get 12 bits
	inx	h
	mov	d,m
	inx	h
	xchg			;put data in HL
	call	wfunc		;write 12 bits
	xchg			;restore ptr
	ldax	b		;get CRMFN
	dcr	a		;-1
	jp	L0E58		;loop if .GE. 0
	ret
;
smcmd:	; start microcode
	jc	sm1		;skip if no arg
	call	arg16_		;get starting addr
	jmp	sm1_5
sm1:	lxi	h,0		;default addr=0
sm1_5:	; start at ucode loc in HL
	shld	t80dt		;save addr
	call	mrcmd		;master reset
	rst	4		;copy
	db	00h
	dw	ones		;all ones
	dw	dmdat		;to DMDAT
	lxi	d,mad000	;addr=0
	call	dmint		;deposit -1 in loc 0
	lda	parbt		;get parity bits
	ani	60h		;isolate b6, b5
	out	40h		;turn off almost everything
	lhld	t80dt		;get addr
	call	cadwr		;write to latches
	call	cscmd		;start clock
hltcm:	call	delay_		;wait a while for halt loop
	db	-1
	call	clruse		;exit user mode
	in	0C0h		;get halt loop flag
	cma
	ani	08h		;isolate
	jnz	L0EAC		;set, cool
	; started ucode but "halt loop" flag didn't come on
	rst	3		;"?DNC"
	dw	L1F5D
	stc
	jmp	smfini		;go fix parity
L0EAC:	rst	2		;internal mode on
	call	examsh		;get ucode stop code
	dw	0		;from KS10 loc 0
	rst	6		;internal mode off
	call	setrn		;fix STATE light if was blinking
	rst	3		;"%HLTD/"
	dw	L1F45
	lxi	h,embuf		;pt at data read from loc 0
	call	p18		;print rh
	rst	5		;clear flag (already printed "%HLTD")
	db	low chkhlt
	rst	1
	db	' '
	rst	1
	db	' '
pccom:	rst	2		;internal mode on
	call	examsh		;read PC from loc 1
	dw	1
	rst	6		;internal mode off
	rst	3		;"PC/"
	dw	L1F41
	call	p36_		;print it
	rst	4		;crlf
	db	02h
	ana	a		;clear C bit
smfini:	lda	parbt		;get parity enables
	out	40h		;write them all
	ret
;
mad000:	db	0,0,0,0,0	;word of zeroes
;
pecmd:	; parity enable
	; arg is sum of bits:  1=DP, 2=CRM, 4=PE
	jc	L0EF7		;print curr status if no arg
	call	arg16_		;get arg
	mov	a,l		;low byte
	ani	7		;isolate low 3 bits
	ral			;left 4
	ral
	ral
	ral
	mov	l,a		;save
	lda	parbt		;get current bits
	ani	8Fh		;trim bits 6:4
	ora	l		;OR in the new ones
	jmp	ks_par		;update PARBT, write bits, return
L0EF7:	lda	parbt		;get curr bits
	ani	70h		;isolate bits 6:4
	rar			;move to 2:0
	rar
	rar
	rar
p8crlf:	call	p8bita		;print
	rst	4		;crlf
	db	02h
	ret
;
excmd:	; execute single PDP10 instruction
	rst	4		;get instruction
	db	08h
	dw	embuf		;into EMBUF
exintm:	lxi	d,embuf		;pt at it
exint:	call	wdatp		;write to latches
	mvi	a,2		;I/O DATA CYCLE
	out	4Ch
	mvi	a,3		;EXECUTE, CONTINUE
if ver52
	lxi	h,L20BA
	add	m		;get any other bits
endif
	out	8Ah
if ver52
	mvi	m,0		;clear them
endif
dnf:	nop			;give ucode time to clear CONT
	nop
	in	0C0h		;has CONT cleared?
if dumb
	cma
	ani	01h
	rz			;return if so
else
	ani	01h
	rnz
endif
	rst	3		;"?DNF"
	dw	L1F4C
	call	clruse		;leave user mode
	cma			;careful!  doesn't necessarily return 0
	ana	a		;supposed to set Z=0 (why not ORI 1?)
	ret
;
stcmd:	; start KS10
	call	lacmd		;get starting addr
	rst	4		;copy it
	db	00h
	dw	memad		;from MEMAD
	dw	tmpbf2		;to TMPBF2
stint:	; start at addr in TMPBF2
	rst	4		;clear DMDAT
	db	0Ah
	dw	dmdat+5
if ver42
	ana	a		;clear keep-alive word
	call	depsht
	dw	31q
endif
	ana	a		;C=0 for deposit
	call	depsht		;zap CTY input word
	dw	32q
	ana	a		;C=0
	call	depsht		;zap CTY output word
	dw	33q
if ver52
	lda	gocode		;put start code in low byte of keep-alive word
	lxi	h,dmdat
	mov	m,a
	ana	a		;C=0 for deposit
	call	depsht
	dw	31q
endif
	lxi	h,254q*8d	;JRST opcode
	shld	tmpbf2+3	;insert into starting addr
	lxi	d,tmpbf2	;pt at it
	call	exint		;and execute it
	rnz			;return if succeeded
if ver42
	lxi	h,200d		;wait 2/3 sec
	call	ltloop
endif
	;drop into CO
cocmd:	; continue KS10
	call	setuse		;user mode
	mvi	a,5		;CONTINUE, RUN
if ver52
	lxi	h,L20BA+1	;subtract 1 iff first time after forced reload
	sub	m
	mvi	m,0		;not next time
endif
	out	8Ah
coint:	sta	chkhlt		;set flag NZ to check for halts
	rst	3		;"KS10>"
	dw	L1F22
	rst	3		;"USR MOD"
	dw	L06E3
	jmp	dnf		;go make sure CPU woke up
;
hacmd:	; halt KS10
	xra	a		;clear RUN, EXECUTE, CONTINUE
	out	8Ah
	jmp	hltcm
;
shcmd:	; shut down TOPS20
	rst	4		;copy a word
	db	00h
	dw	_dsbas
	dw	dmdat
	ana	a		;C=0 for deposit
	call	depsht		;deposit 776700
	dw	30q		;in loc 30 (WHY?)
	call	setuse
	mvi	b,80h		;bit to set
	call	statem		;ignore keep-alive while it's shutting down
	db	0FFh		;(bits to clear)
	jmp	coint		;let OS come down
;
if klinik
klcmd:	; KLINIK
	jc	L0FB4		;no arg, show curr mode
	call	arg16_		;get arg
	mov	a,l		;copy low byte
	ana	a		;=0?
if dumb
	jz	L0FA8		;skip if so
	sta	klline		;turn KLINIK line on
	ret
L0FA8:	sta	klline
else
	sta	klline		;save flag
	rnz			;return if on
endif
	; maybe change modes
	lda	cslmod		;in mode 3?
	cpi	_mode3
	cz	setm2		;set mode 2 if so
	ret
L0FB4:	; no arg, show KLINIK mode
	lda	klline		;get flag
	ana	a
	jmp	L0BCF		;go print ON or OFF
endif ; klinik
;
if klinik
ttcmd:	; put CTY in user mode (or KLINIK line?)
	call	setuse
	rst	3		;"KS10>"
	dw	L1F22
	rst	3		;"USR MOD"
	dw	L06E3
if ver52
	lda	cslmod		;get curr mode
	sui	_mode2		;mode 2 or above?
	jp	setm2		;yes, set mode 2
	rst	5		;otherwise clear KLNKSW
	db	low klnksw	;(re-exam KLINIK mode)
	ret
else
	jmp	setm2		;just set mode 2
endif ; ver52
endif ; klinik
;
if klinik
pwcmd:	; set password for KLINIK line
if ver52
	rst	5		;KLNKSW=0, force re-exam of KLINIK mode
	db	low klnksw
else
	mvi	a,0		;same but 5 bytes of code
	sta	klnksw
endif ; ver52
	jc	L0FF1		;null pw, go clear it
	lhld	_arg1		;get ptr to it
	lxi	d,kpwbuf 	;buf where it goes
	mvi	b,-6		;count (it's not a PDP8 y'know...)
L0FDC:	mov	a,m		;get a byte
if dumb
	cpi	0FFh		;return if end of cmd
	rz
else
	ora	a		;everything else was trimmed to 7 bits
	rm
endif
	call	up_lo		;cvt to upper (wasn't it already?)
	stax	d		;save
	inx	d		;bump both ptrs
	inx	h
	inr	b		;bump backwards loop count
	jnz	L0FDC		;loop until buf full
	mov	a,m		;pw must be exactly 6 chars
if dumb
	cpi	0FFh
	rz
else
	ora	a
	rm
endif
	; password was >6 chars
	rst	3		;"?PWL"
	dw	L1FDA
L0FF1:	; set null password
	rst	4		;clear 5 of 6 bytes
	db	0Ah
	dw	kpwbuf+1+5
	dcx	h		;get the last one ourself
	mvi	m,0
	ret
;
endif ; klinik
;
umcmd:	; unmark microcode loc (undoes MK)
	mvi	c,0		;mark bit value
	jmp	L1000		;skip
mkcmd:	; mark microcode (set low bit in uword, for watching with scope)
	mvi	c,1		;mark bit value
L1000:	push	b		;save C
	rst	4		;make sure CPU halted
	db	06h
	call	lccmd		;C bit clear, get CRAM addr
	call	crm_ad		;write to addr latches
	call	cp1		;clk pulse to read curr contents
	mvi	a,0Fh		;func=get bits 84-95 of uword
	call	readc		;do it
	call	crm_ad		;set addr latches again
	lxi	d,tmpb2		;pt at data read
	pop	b		;get bit to write in c
	ldax	d		;get data
	ani	0FEh		;mask off low bit
	ora	c		;OR in this bit
	stax	d		;write it back
;;;; is this needed?  didn't CRM_AD set addr latches above
	call	adatp		;write addr latches (again?!)
	mvi	a,07h		;func=write bits 84-95 of uword
	sta	crmfn		;save
	jmp	L0CA0		;go write data
;
zmcmd:	; zero memory (slooooowly)
	rst	4		;LA 0
	db	0Ah
	dw	memad+5
	mvi	a,02h		;patch in func=DEPOSIT MEMORY
	sta	memad+4
	rst	4		;data=zeroes
	db	0Ah
	dw	dmdat+5
	rst	2		;internal mode on
	call	dm1		;DM 0
L1039:	call	inc36		;addr +1
	dw	memad
	lxi	d,memad		;write to addr latches
	call	adatp
	mvi	a,4		;COM/ADR CYCLE
	out	4Dh
	call	dmgo		;DN 0
	lda	errcd		;error?  (presumably NDA)
	ana	a
	jz	L1039		;loop if not
	rst	6		;internal mode off
	ret
;
rpcmd:	; repeat preceding commands (on same line)
	jnc	L1069		;have arg, skip
	xra	a		;repeat forever (until ^C)
L1058:	sta	rpcntr		;init repetition ctr
	call	rpfoo		;reset ctrs
	xra	a		;clear "stop RP" flag
	sta	rpend
	cma			;RP is active
	sta	rpton
	jmp	L107D
L1069:	; arg specified
	call	arg16_		;get it
	mov	a,h		;must be .LE. 255
	ana	a
	jnz	kilnm		;err if not
	mov	a,l		;get count +1
	inr	a
	jmp	L1058		;set it, go
L1076:	; do next iteration
	lda	rpend		;stop requested?
	ana	a
	jnz	L109B		;yes
L107D:	lhld	rplst		;get ptr to dispatch list
	mov	a,m		;see if end of addr list
	inr	a
	jnz	L10A0		;skip if not
	; reached end of dispatch list, start over
	lda	rpcntr		;get count
if dumb
	cz	rpfoo		;reinit ptrs
else
	call	rpfoo		;we know Z=1
endif
	ana	a		;=0?  (repeat forever?
	jz	L1076		;yes, just loop
	dcr	a		;count it update count
	sta	rpcntr
	cpi	1		;done?
if dumb
	cnz	rpfoo		;we already did this above
endif
	jnz	L1076		;loop if not
L109B:	; RP done
	xra	a		;RP no longer active
	sta	rpton
	ret
L10A0:	; execute next cmd in line
	mov	d,m		;get dispatch addr
	inx	h		;(stored byte-swapped so first can't be FF)
	mov	e,m
	inx	h
	shld	rplst		;save ptr
	lxi	h,nullw		;set return addr
	push	h
	xchg			;get call addr into HL
	mov	a,h		;see if "needs arg" bit set
	ana	a		;(C=0)
	jp	L10B5		;no
	ani	7Fh		;yes, clear it (pointless, not decoded)
	mov	h,a
	stc			;compensate for CMC, say "has arg"
L10B5:	cmc
	pchl			;call the routine
;
rpnew:	cma			;A=FF (was 0)
	sta	cmds__
rpfoo:	; init ctrs to begn of cmd dispatch list
	lxi	h,rpini		;reinit dispatch ptr
	shld	rplst
	lxi	h,rptbfi	;and arg ptr
	shld	rpbufs
	ret
;
dscmd:	; disk select
	rst	3		;">>UBA?"
	dw	L1FA1
	call	pickup		;get response
	jc	L10D9		;nothing, use default
	lda	tmpb2		;get it
	rlc			;left 2 bits to align in byte
	rlc
	sta	dskuba		;save
L10D9:	rst	3		;">>RHBASE?"
	dw	L1FA8
	call	pickup
	jc	L10E8
	rst	4		;copy
	db	00h
	dw	tmpb2		;from TMPB2
	dw	dsbase		;to DSBASE
L10E8:	rst	3		;">>UNIT?"
	dw	L1FB2
	call	pickup
	rc			;done if blank
	lda	tmpb2		;get it
	sta	unitnm
	ret
;
mscmd:	; magtape select
	rst	3		;">>UBA?"
	dw	L1FA1
	call	pickup
	jc	L1107
	lda	tmpb2		;get UBA #
	rlc			;align in byte (middle of 5)
	rlc
	sta	mtauba		;save
L1107:	rst	3		;">>RHBASE?"
	dw	L1FA8
	call	pickup
	jc	L1116
	rst	4		;copy
	db	00h
	dw	tmpb2		;from TMPB2
	dw	mtbase		;to MTBASE
L1116:	rst	3		;">>TCU?"
	dw	L1FBA
	call	pickup
	jc	L1125
	lda	tmpb2
	sta	tapeun		;save Massbus unit # of TM03
L1125:	rst	3		;">>DEN?"
	dw	L1FC1
	call	inbuf		;set up buffer, get answer
	jc	L114D
	push	h
	lxi	d,L115B		;"800"?
	call	strcmp
	jnz	L113E		;no
	mvi	a,02h		;yes, get bit for 800 bpi
	pop	h
	jmp	L114A
L113E:	pop	h
	lxi	d,L115F		;"1600"
	call	strcmp
	jnz	kilnm		;no
	mvi	a,04h		;yes, get bit for 1600 bpi
L114A:	sta	den_sl+1	;save
L114D:	rst	3		;">>SLV?"
	dw	L1FC8
	call	pickup
	rc
	lda	tmpb2		;get slave (to TM03) # of drive
	sta	den_sl		;save
	ret
;
L115B:	db	'800',0		;strings for comparing density
L115F:	db	'1600',0
;
pickup:	; read numerical arg, come back when cr typed
	call	inbuf		;set up buffer
	rc			;return now if nothing typed
	rst	4		;read it as 36-bit arg
	db	08h
	dw	tmpb2		;save in TMPB2
	xra	a		;C=0
	ret
;
inbuf:	; set up buf, arrange to return when cr typed
	lxi	h,eol		;pt at eol ctr
	dcr	m		;-1
	call	bfrst		;flush CTY input buf
	lhld	buf_		;get ptr to begn of buf
	shld	_arg1		;will point to 1st arg
	lxi	h,L1181		;return addr
	jmp	nullw		;go back to null job until cr
L1181:	; come here on cr
	lhld	_arg1		;get ptr to arg
fndarg:	call	sepchr		;skip white space
	shld	_arg1		;save ptr
	jmp	eocml		;set C if eol, return
;
;;indire=	3Fh	;;; (used anywhere?)
boot:	rst	3		;"BT SW"
	dw	L1F57
btaut:	rst	4		;crlf
	db	02h
	mvi	a,08h		;set bit 32 to say BOOT switch pressed
	sta	gocode
	stc			;BT (no arg)
	;jmp	btcmd
;
btcmd:	; boot from disk
	call	btchoi		;monitor or diag?
bt_src:	; enter here with offset in RM100
	call	microp		;read home block into 1000'
	jc	c_bter		;error
	call	dmem2c		;deposit memory into CRAM
	call	lbint		;read bootstrap into core
lb_go1:	rst	4		;set addr to 1000'
	db	00h
	dw	ma1000
	dw	tmpbf2		;(ptr in TMPBF2)
	jmp	stint		;go start KS10 at 1000'
;
lbcmd:	; load bootstrap
	call	btchoi		;choose bootstrap if arg given
lbint:	lxi	d,1000q		;get base addr of blk
	lda	rm100		;get offset they chose
	add	e		;add to base (in first half of blk, no carry)
	mov	e,a
	call	filein		;read in the selected boot block
	jc	l_bter		;failed
	call	bt_go		;start ucode, turn on printout
infobt:	; give RHBASE etc. to bootstrap so it can find the drive
	lhld	unitnm		;get unit #
	jmp	passsr		;set up locs 36, 37, 40
;
btchoi:	; choose which boot block to load
if (dumb eq 0)
	mvi	a,4		;assume monitor boot
	jc	L11D2		;no arg, good guess
else
	jc	L11D6		;no arg, skip
endif
	call	arg16_		;get arg and ignore it
	mvi	a,6		;boot diags
L11D2:	sta	rm100
	ret
if dumb
L11D6:	mvi	a,4		;boot monitor
	jmp	L11D2
endif
;
bt_go:	; start KS10, reinit parity
	call	sm1		;start ucode
	jc	d_bter		;error
bt_go1:	rst	6		;internal mode off
	mvi	a,7Ch		;default parity enables
	call	ks_par		;set + remember them
	mvi	a,10h		;default trap enables
L11E9:	sta	trapen		;save
	out	85h		;and set
	ret
;
mtcmd:	; magtape boot
	shld	cmd__		;save our addr for retries
	call	mtsetu		;setup
	mvi	a,71q		;magtape read cmd
	call	mtxfr		;read ucode
	jnc	L1203		;skip if happy
	call	nonfat		;see what kind of err
	jnz	a_bter		;type A
L1203:	mvi	a,2		;boot dev=tape
	call	mem2cr		;copy ucode from mem to CRAM
	call	mbint		;load boot record
	call	bt_go		;start ucode, set parity/trap defaults
	jmp	lb_go1		;go
;
mbint:	; rewind, skip ucode file, read 1st rec of 2nd file
	mvi	a,31q		;cmd=file skip
	call	mtxfr		;rewind, file skip
	jnc	L121F		;no error, happy
	call	nonfat		;expect frame count err, make sure that's it
	jnz	l_bter		;lose lose lose
L121F:	mvi	a,71q		;cmd=read
	call	qmxfr		;do it w/o rewind
	jnc	L122D		;happy
	call	nonfat		;error, make sure unimportant
	jnz	l_bter		;punt if bad
L122D:	lhld	tapeun		;get tape unit #
	;jmp	passsr		;tell boot about device
;
passsr:	; set up locs 36, 37, 40 with boot device info
	push	h		;save unit
	rst	4		;copy
	db	00h
	dw	rhbase		;RHBASE
	dw	dmdat		;to DMDAT
	lxi	h,dmdat+2	;pt at UBA part of I/O addr
	lda	ubanum		;get UBA #
	ora	m		;OR into I/O addr
	mov	m,a
	push	h		;save ptr
	ana	a		;C=0 for deposit
	call	depsht
	dw	36q		;36=complete base I/O addr of RH11
	pop	h		;restore
	mvi	m,0		;zap out UBA byte
	pop	h		;get unit # from stack
	shld	dmdat		;save
	ana	a		;C=0 for deposit
	call	depsht
	dw	37q		;37=unit #
	rst	4		;copy
	db	00h
	dw	den_sl		;density, slave #
	dw	dmdat		;to mem buffer
	ana	a		;C=0 for deposit
	call	depsht
	dw	40q		;40=<density><slave> (<slave> in low 8 bits)
	ret
;
nonfat:	; check magtape error to see if non-fatal
	mvi	a,<(low (frmerr+2))> ;frame error
	lxi	h,errcd		;pt at code
	cmp	m		;is that all?
if dumb
	push	psw
	cz	mtrese		;reset tape if so
	pop	psw
	rz			;and return too
else
	jz	mtrese		;yes, reset, return
endif
	mvi	a,<(low (retry_+2))> ;OK, see if retryable err
	cmp	m		;is it?
	rnz			;no
	; retryable, so retry it
	lxi	sp,ramst+ramsz	;flush stack
	lxi	h,norml		;set return addr
	push	h
	lhld	cmd__		;get addr of cmd to retry
	pchl			;go do it
;
mbcmd:	; load magtape bootstrap (but don't start)
	shld	cmd__		;set "retry" addr
	call	mtsetu		;init
	call	mbint		;load boot record
if dumb
	call	bt_go		;start ucode
	ret
endif
;
mtsetu:	call	btint		;set up for booting
	lda	mtauba		;get UBA
	sta	ubanum		;set it
	rst	4		;copy
	db	00h
	dw	mtbase		;MTBASE
	dw	rhbase		;to RHBASE
	ret
;
ma1000:	dw	1000q		;mem addr 1000'
	db	0,0,0
homewd:	db	00,00,0B4h,2Fh,0Ah ;SIXBIT/HOM/,,0
ones:	db	0FFh,0FFh,0FFh,0FFh,0Fh
;
; home block is block 0, or block 10' if block 0 is unreadable.
; format:
;
; +0	SIXBIT/HOM/,,0
; . . .
; +103	ptr to page of pointers
; . . .
;
; page of pointers format:
;
; +0	ptr to free
; +1	length of "
; +2	ptr to ucode
; +3	length of "
; +4	ptr to monitor boot block
; +5	length of "
; +6	ptr to diag boot block
; +7	length of "
; +10	ptr to BC1 ucode
; +11	length of "
; +12	ptr to BC2 boot block
; +13	length of "
; +14	ptr to monitor boot program
; +15	length of "
; +16	ptr to diag boot prog
; +17	length of "
; +20	ptr to BC2 itself
; +21	length of "
; +22	ptr to FI 0
; +23	length of "
; . . .
; +776	ptr to FI 366
; +777	length of "
;
microp:	lxi	d,1002q		;ptr to ucode will be at 1002' in core
filein:	; read file pted to by word at (DE-1000') in home blk
	push	d
	call	btint		;master reset, parity/traps off
	pop	d		;compensate for below
filesh:	push	d		;save (again)
	call	dskdft		;get disk defaults
	lxi	h,0		;load 0
	shld	blkadr		;set cyl
	inx	h		;HL=1 (INR L would be neater)
	shld	blknum		;set sector
	call	chkhom		;see if valid home blk
	jz	L12CE		;yes
	mvi	a,10q		;no, try alternative home blk
	sta	blknum
	call	chkhom		;how's it look?
	jnz	a_bter		;bad
L12CE:	; got a valid home blk, one or the other
	call	examsh		;get ptr to page of ptrs
	dw	1103q		;what the hell?
	call	blkrdr		;read page of ptrs
	jc	b_bter		;err
	pop	h		;restore mem addr of ptr they wanted
	stc			;examine
	call	exmhl
	; now drop through to read blk from that ptr
blkrdr:	lhld	embuf+3		;get cyl from high 12 bits
	shld	blkadr
	lhld	embuf		;get surface,,sector
	shld	blknum
if dumb
	call	dsxfr		;read the blk
	ret
else
	jmp	dsxfr		;read, return
endif
;
chkhom:	; read a home blk and see if it has valid signature
	call	dsxfr		;read it
	jc	a_bter		;punt on err
	call	examsh		;read first word
	dw	1000q		;(core addr 1000')
	call	cmp36		;compare
	dw	homewd		;SIXBIT/HOM/,,0
	dw	embuf		;to data read
	ret
;
btint:	; init for booting
	rst	2		;internal mode on
	rst	5		;disable parity checks
	db	low parbt
	rst	5		;and traps
	db	low trapen
if dumb
	call	mrcmd		;master reset
	ret
else
	jmp	mrcmd		;master reset, return
endif
;
dskdft:	; set disk defaults
	lda	dskuba		;get UBA #
	sta	ubanum
	rst	4		;copy
	db	00h
	dw	dsbase		;DSBASE
	dw	rhbase		;to RHBASE
	ret
;+
;
; Load microcode from memory into CRAM.
;
; Microcode blocks are loaded at 1000' (first assumed already loaded).
; Each 96-bit microword is loaded from three PDP10 words in 12-bit bytes
; (since that's the word size used by the hardware "diag write" function).
; Bytes are stored right-to-left in both the 36-bit and 96-bit words, and
; the leftmost 12 bits of every third PDP10 word are wasted.
;
; PDP10 words:
; X+0/ CCCCBB,,BBAAAA
; X+1/ FFFFEE,,EEDDDD
; X+2/ ????HH,,HHGGGG
;
; Microword:
; HHHHGGGGFFFFEEEEDDDDCCCCBBBBAAAA
;
;-
dmem2c:	; load ucode from disk
	mvi	a,1		;flag=disk
mem2cr:	; load ucode
	; A holds flag: 1=disk, 2=tape
	sta	bt_typ		;save
	lxi	h,0		;init CRAM addr to 0
	push	h		;save
	call	cadwr		;write to CRAM addr ctr
	mvi	a,07h		;diag func=load bits 84-95
	sta	crmfn		;save
L1328:	rst	4		;copy
	db	00h
	dw	ma1000		;1000'
	dw	memad		;to mem addr
	lhld	memad		;HL=1000'
L1331:	mov	a,l		;set mem addr
	out	43h
	mov	a,h
	out	45h
	mvi	a,4		;func=exam
	call	em_crm		;do it
	lhld	embuf		;get low 12. bits of data read
	mov	a,h		;chop off high 4 bits
	ani	0Fh		;(doesn't the hardware do it?)
	mov	h,a
	call	wfunc		;write 12 bits
	lxi	h,crmfn		;move diag func up by 12 bits
	dcr	m
	lhld	embuf+1		;get middle 12 bits of word, left-justified
	; shift HL right 4 bits
if dumb
	mvi	c,4		;loop count
	xra	a		;init
L1350:	mov	a,h		;H right 1 bit
	rar
	mov	h,a
	mov	a,l		;L right 1 bit
	rar
	mov	l,a
	dcr	c		;loop
	jnz	L1350
else
	mvi	a,10h		;init A, b4=1 to detect end of loop
L1350:	dad	h		;left a bit
	ral			;into A
	jnc	L1350		;loop until 1 falls off (4 iterations)
	mov	l,h		;get low byte
	mov	h,a		;and high byte
endif
	call	wfunc		;write 12 more bits
	lxi	h,crmfn		;take out of total func
	dcr	m		;finished uword?
	jp	L1377		;skip if not
	; uword ends 2/3 of the way through every third PDP10 word
	mvi	a,07h		;start func over, uword bits 84-95
	sta	crmfn
	pop	h		;CRAM addr +1
	inx	h
	push	h
	call	cadwr		;write to CRAM addr bits
	mov	a,h		;get high bits of addr
	ani	crmsz/100h	;loaded 2KW of ucode?
	jz	L1385		;continue if not
	pop	h		;flush addr (could save this with RZ in loop)
	ret
L1377:	lhld	embuf+3		;get 3rd 12 bits
	mov	a,h		;mask off high 4 (should be clear already)
	ani	0Fh
	mov	h,a
	call	wfunc		;write them
	lxi	h,crmfn		;bump diag func down to next 12 bits
	dcr	m
L1385:	; finished PDP10 word, get another
	lhld	memad		;core addr +1
	inx	h
	shld	memad
	mov	a,h		;get high bits
	ani	2000q/100h	;2000s bit set?
	jz	L1331		;no, go fetch this word
	; off end of page, load next block
	call	nextcr		;get next page of CRAM
	jmp	L1328		;loop
;
nextcr:	; read a page of CRAM data
	lda	bt_typ
	cpi	1		;disk?
	jnz	L13AA
	; load next ucode blk from disk
	lxi	h,qxfr		;pt at cmd list
	call	chnxct		;execute it
	jc	c_bter
	ret
L13AA:	; load next ucode rec from tape
	mvi	a,71q		;cmd=read
	call	qmxfr		;read a rec
	rnc			;no err
	call	nonfat		;lame errors are OK
	jnz	c_bter		;we lose
	ret
;+
;
; The FI cmd reads a page from the file system and treats its contents
; as a single cmd line.  This line is not checked for length and can overflow
; its buffer if too long.  The file is made up of 8-bit bytes, which are
; stored right-to-left in the low 32 bits of PDP10 words.  The end of line
; is marked by byte of all ones.
;
; This command seems like more trouble than it's worth, but it isn't much code.
;
;-
ficmd:	; indirect command file
	call	arg16_		;get file # (0-366')
	lxi	d,1022q		;add base
	dad	d
	call	filein		;read the file
	jc	l_bter		;err
	rst	4		;copy
	db	00h
	dw	ma1000		;1000'
	dw	memad		;to mem addr
	lxi	d,e_beg+2	;pt into buf
L13CD:	rst	2		;internal mode on
	call	gather		;read a word from core
	rst	6		;internal mode off
	mvi	l,4		;4 valid bytes per word
	lxi	b,embuf		;pt at first
L13D7:	ldax	b		;get a byte
	stax	d		;save
if dumb
	cpi	0FFh		;end of line?
else
	inr	a		;(value not needed)
endif
	jnz	L13E4
	call	mv_all		;copy to line buf
	jmp	dcode		;and go decode cmd
L13E4:	inx	b		;ptrs +1
	inx	d
	dcr	l		;finished word?
	jnz	L13D7		;loop if not
	jmp	L13CD		;around for next word
;
if ver42
if 0 ; this is commented out in the source (listed as "proposed")
b1cmd:	; load bootcheck 2 microcode
	lxi	d,1010q		;offset
	call	filein		;read first page
	jc	c_bter		;punt on err
	mvi	a,1		;disk boot
	call	mem2cr		;load into CRAM
if dumb
	call	bt_go		;start ucode
	ret
else
	jmp	bt_go
endif ; dumb
endif ; 0
endif ; ver42
;
b2cmd:	; bootcheck 2
	mvi	a,12q		;offset
	sta	rm100		;save
	jmp	bt_src		;go boot
;
vdcmd:	; verify CRAM against disk copy
	call	microp		;read home blk, page of ptrs, 1st page of ucode
	jc	c_bter		;err
	mvi	a,1		;say loading from disk
	jmp	vercra		;go verify
;
vtcmd:	; verify CRAM against tape copy
	call	mtsetu		;set up tape parms
	mvi	a,71q		;cmd=read
	call	mtxfr		;read first page
	jc	a_bter		;error
	mvi	a,2		;boot type=tape
	;jmp	vercra		;verify, return
;
vercra:	; verify CRAM against page in core
	; the rest is on dev in A (1=disk, 2=tape)
	sta	bt_typ		;save load dev
	rst	4		;copy
	db	00h
	dw	ma1000		;1000'
	dw	memad		;to mem addr
	lxi	h,0		;init CRAM addr
if dumb
	shld	crmad		;gets done in loop too
endif
	jmp	L1427		;into loop
L141F:	lhld	crmad		;get CRAM addr
	inx	h		;+1
	mov	a,h		;done?
	ani	crmsz/100h
	rnz			;return if so
L1427:	; read next uword
	call	cadwr		;write addr latches
	shld	crmad		;save value
	call	cp1		;clock pulse to read
	call	rcint		;read a word, explode it 12 bits per 2 bytes
	lxi	b,verlst	;pt at offsets
	lxi	d,crmbf		;init ptr into uword
L1439:	call	gather		;read a word from core
	mvi	a,3		;init word-within-uword count
	sta	vercnt
L1441:	ldax	b		;get offset
	ani	3Fh		;trim flags
	lhld	embuf		;get low 12 bits
	inx	b		;offs tbl ptr +1
	add	e		;add offset to DE
	mov	e,a
	mov	a,d
	aci	0
	mov	d,a
	ldax	d		;get the byte at that loc
	inx	d		;(+1 in case we skip)
	cmp	l		;match?
	jnz	L145A		;punt if not
	mov	a,h		;get high 4 bits
	ani	0Fh
	mov	h,a
	ldax	d		;read next byte
	cmp	h		;match?
L145A:	cnz	verrpt		;complain if not
	dcx	d		;back up to low 8 bits
	inx	b		;skip to next entry
	ldax	b		;get offset
	ral			;b7=1?
	jc	L141F		;done if so
if dumb
	ral			;b6=1?
	jc	L1441		;yes, 2 copies of this one, loop w/o inc
else
	jm	L1441		;b6=1, go check 2nd copy
endif
	lxi	h,vercnt	;done all PDP10 words in this uword?
	dcr	m
	jz	L1439		;start next uword if so
	lxi	h,embuf		;otherwise pt at data
	call	shr36		;shift it right
	db	12d		;12 bits
	jmp	L1441		;and compare next byte
;
verlst:	; offset to next 12-bit group, diag read func to read it (for VERRPT)
	db	00h,0Fh		;84-95
	db	02h,0Eh		;72-83
	db	02h,0Dh		;60-71
	db	02h,0Ch		;48-59
	db	02h,0Bh		;36-47A
	db	42h,0Ah		;36-47B
	db	08h,06h		;24-35A
	db	42h,05h		;24-35B
	db	02h,04h		;12-23
	db	08h,00h		;0-11
	db	80h		;end
;
gather:	; read next word from KS10 memory, get new page if needed
	push	d		;save
	push	b
	lhld	memad		;get addr
	push	h		;save
	mov	a,h
	ani	2000q/100h	;reached 2000' yet?
	jz	L14A5
	call	nextcr		;yes, read next page of CRAM
	pop	h		;flush addr
	lxi	h,1000q		;reinit addr
	push	h		;save
	shld	memad		;set addr to read
L14A5:	call	em2		;read next word
	pop	h		;get addr it was at
	inx	h		;+1
	shld	memad		;save
	pop	b		;restore
	pop	d
	ret
;
verrpt:	; verify error, print msg and continue
	push	h		;save
	push	d
	rst	6		;internal mode off
	lxi	h,crmad		;pt at addr
	call	p16		;print it
	rst	1		;/
	db	'/'
	ldax	b		;get diag read function for this 12-bit group
	call	p8bita		;print
	rst	1		;:
	db	':'
	rst	1		;<sp>
	db	' '
	rst	1		;A (actual)
	db	'A'
	rst	1		;<sp>
	db	' '
	xchg			;HL=ptr into buf of 12-bit #'s
	dcx	h		;pt at value read from CRAM
	call	p16		;print it
	xchg			;restore ptrs
	rst	1		;<sp>
	db	' '
	rst	1		;E (expected)
	db	'E'
	rst	1		;<sp>
	db	' '
	lhld	embuf		;get data from disk/tape
	mov	a,h		;mask to 12 bits
	ani	0Fh
	mov	h,a
	shld	tmpb2		;save
	call	p16_		;print
	rst	4		;crlf
	db	02h
if klinik
	push	b
	call	decnet		;update KLINIK line if enabled
	pop	b
endif
	rst	2		;internal mode on
	pop	d		;restore
	pop	h
	ret
;
dsxfr:	; do disk xfr (cyl, hd, sec set up)
	lxi	h,dskseq	;pt at cmd list
xctnow:
if dumb
	call	chnxct		;call interpreter
	ret
else
	jmp	chnxct		;interpret, return
endif
;
mtxfr:	; do magtape xfr (A=TM03 cmd)
	lxi	h,mtaseq	;pt at cmd list
xctmta:	sta	skp_go		;save cmd
	jmp	xctnow
;
qmxfr:	lxi	h,qtxfr		;pt at cmd list
	jmp	xctmta		;save cmd in A, go
;
mtrese:	; clear magtape err
	lxi	h,mtarst	;pt at list
if dumb
	jmp	xctnow		;it jumps back here!
else
	;jmp	chnxct		;drop through
endif
;+
;
; Routine to execute I/O command list.
;
; HL points to a series of 24-bit words.
; Our cmd is in the low 4 bits of the high 6:
; 00	DI
; 02	LI
; 04	EI
; 06	WAIT
; 10	ERRTST
; 12	END
; 14	TWAIT
; 16	UBA
; The argument is in the low 18 bits.
;
;-
di_=	000q
di_ind=	200q	;deposit indirect
li_=	010q
ei_=	020q
wait_=	030q
errts_=	040q
end_=	050q
twait_=	060q
uba_=	070q
chnxct:	; execute cmd list at (HL)
	rst	2		;internal mode on
	push	b		;save
	push	d
	push	h
L150B:	lxi	d,2		;bump HL up to middle byte of word
	dad	d
	mov	b,h		;copy to BC
	mov	c,l
	push	h		;save
	mov	a,m		;get our byte
	rar			;right 2 bits
	rar
	ani	0Fh		;isolate low 4 (bit 0 assumed 0 already)
	mov	e,a		;put in E (D=0 from above)
	lxi	h,L152A		;add base of table
	dad	d
	mov	e,m		;look up routine
	inx	h
	mov	d,m
	xchg			;put in HL
	lxi	d,L1525		;set return addr
	push	d
	pchl			;simulate CALL to routine
L1525:	pop	h		;restore ptr
	inx	h		;skip opcode
	jmp	L150B
;
L152A:	dw	cmddi		;DI
	dw	cmdli		;LI
	dw	cmdei		;EI
	dw	cmdwai		;WAIT
	dw	cmderr		;ERRTST
	dw	cmdend		;END
	dw	cmdtwa		;TWAIT (no timeout)
	dw	cmduba		;LI to UBA (abs addr, not offs from RHBASE)
;
cmdei:	; EI in cmd list
	ana	a		;C=0
	jmp	L153F
cmdli:	; LI in cmd list
	stc			;C=1
L153F:	; LI or EI, 1-byte offset in 2nd byte of cmd is added to UBA,,RHBASE
	push	psw		;save C
	rst	4		;copy
	db	00h
	dw	rhbase		;RHBASE for curr dev
	dw	ioad		;to IOAD
	lxi	h,ioad+2	;point at where UBA # goes
	lda	ubanum		;get curr UBA #
	ora	m		;OR it into addr
	mov	m,a
	dcx	h		;pt at IOAD
	dcx	h
	dcx	b		;back up to 2nd byte of cmd
	ldax	b		;get it
	add	m		;add to RHBASE
	mov	m,a
	pop	psw		;LI?
	rc			;yes, done
if dumb
	call	ei1		;examine
	ret
else
	jmp	ei1		;examine, return
endif
;
cmduba:	; abs LI in cmd list
	; abs addr, not RHBASE-relative (presumably for talking to UMRs)
	lxi	d,ioad+2	;pt at high end of addr
	push	d		;save
	call	mov18b		;get abs addr, clear UBA #
	pop	h		;restore ptr
	lda	ubanum		;get UBA #
	ora	m		;OR it in
	mov	m,a
	ret
;
cmddi:	; DI in cmd list
	ldax	b		;high bit of opcode byte set?
	ana	a
	jp	L1575		;no
	; indirect, low 16 bits are 8080A addr of word to really use
	mov	l,c		;pt into cmd list with HL
	mov	h,b
	dcx	h		;BC=low 16 bits of addr
	mov	b,m
	dcx	h
	mov	c,m
	inx	b		;+2 (pt at high end)
	inx	b
L1575:	lxi	d,dmdat+2	;dest=DMDAT
	call	mov18b		;copy arg
if dumb
	call	di1		;depos
	ret
else
	jmp	di1		;depos, return
endif
;
cmdwai:	; wait for cmd to finish (time out after a while)
	xra	a		;init timeout count to 0
	mov	d,a
	mov	e,a
L1582:
;;; since we do the CHKBIT before the EI1, this depends on the prev cmd
;;; in the cmd list being an EI. cmd.  fix this and we can save a cmd
;;; (it only matters in one place)
	push	b		;save ptr to cmd word
	call	chkbit		;has any masked bit come on?
	pop	b
	rnz			;return if so
	push	b		;save regs
	push	d
	call	ei1		;read CSR
	pop	d
	pop	b
	inx	d		;count this
	mov	a,e		;wrapped around to 64K polls?
	ora	d
	jnz	L1582		;loop if not
	jmp	deverr		;go complain
;
cmdtwa:	; as above, but read only once (no polling)
	push	b
	call	ei1		;read the CSR
	pop	b
	push	b
	call	chkbit		;check for masked bit
	pop	b
	rnz			;got one
	jmp	deverr		;lose
;
cmderr:	; error check, punt if any selected bit is 1
	push	b
	call	chkbit		;see if any bit is set
	pop	b
	rz			;happy if not
	;jmp	deverr		;otherwise drop through
;
deverr:	; print "?BT" msg, punt
	mov	h,b		;copy ptr into cmd list
	mov	l,c		;(failing cmd +2)
	shld	errcd		;save
	rst	6		;internal mode off
	xra	a		;C=0 (flipped below)
	jmp	devexi		;go punt
;
cmdend:	; end of cmd list
	lxi	d,mad000	;reset bus addr to 0
	call	adatp		;(why?)
	rst	6		;internal mode off
	stc			;C=1 for below
devexi:	cmc			;flip C
	pop	h		;flush r.a.
	pop	h		;flush cmd list ptr
	pop	h		;restore regs
	pop	d
	pop	b
	mvi	a,0		;guarantee A=0 (XRA A would trash C)
	ret
;
mov18b:	; copy 18-bit cmd arg to buf at (DE-2)
	mvi	h,2		;loop count
	ldax	b		;get high 2 bits
	ani	3		;isolate
	stax	d		;save
	dcx	b		;ptrs -1
	dcx	d
L15CF:	ldax	b		;get next byte
	stax	d		;store
	dcx	b		;ptrs -1
	dcx	d
	dcr	h		;done all?
	jnz	L15CF		;loop if not
	ret
;
chkbit:	; set flags according to EMBUF<15:0>&cmd<15:0>
	lhld	embuf		;get last data read using EI
	dcx	b		;pt at low byte in cmd list
if dumb
	dcx	b
	ldax	b		;get it
	ana	l		;bits set in low byte?
	rnz
	inx	b		;no, try high byte
	ldax	b
	ana	h		;(set flags)
	ret
else
	ldax	b		;doing high-order first saves a byte
	ana	h
	rnz
	dcx	b
	ldax	b
	ana	l
	ret
endif
;
bccmd:	; boot check (test everything we can to do with disk boot)
	call	mrcmd		;master reset, halt etc.
	rst	2		;internal mode on
	rst	5		;zap ERRCD
	db	low errcd
	rst	5
	db	low (errcd+1)
	; float single ones and zeroes across the bus
	rst	4		;zap BUSAD
	db	0Ah
	dw	busad+5
	mvi	a,08h		;set bit 0 (addr=400000,,000000)
	sta	busad+4
	lxi	b,100h		;B=1, C=0
L15F8:	push	b		;save loop count
	call	dbcmd		;deposit our 1 (or 0) onto the bus
	lda	errcd		;trouble?
	ana	a
	jnz	bca_er		;punt if so
	lxi	h,busad		;otherwise shift addr right 1 bit
;;; BUG:
;;; SHR36 does a logical shift, so in fact when we say we're floating a single
;;; 0 across the bus, actually we're shifting in a new 0 each time
	call	shr36
	db	1
	pop	b		;get count
	inr	c		;done all 36 bits?
	mov	a,c
	cpi	36d
	jc	L15F8		;loop if not
	dcr	b		;done both tests?  (single 1, single 0)
	jm	L1626		;skip if so
	rst	4		;no, copy (377777,,777777) to bus addr
	db	00h
	dw	L1621
	dw	busad
	mvi	c,0		;reinit bit count
	jmp	L15F8		;loop
L1621:	dw	-1,-1		;377777,,777777
	db	7
L1626:	; write all zeroes to CRAM
	lxi	h,0		;init CRAM addr
L1629:	call	w_crmz		;write this loc
	inx	h		;+1
	mov	a,h		;done all locs?
	ani	crmsz/100h
	jz	L1629		;loop if not
	mvi	h,0		;reinit addr to 0 again (L=0 already)
L1635:	; read each loc, verify all zeroes, then write all ones
	call	cadwr		;set addr
	push	h		;save
	call	cp1		;clk pulse to read CRAM
	call	rcint		;read/explode the data
	lxi	h,0		;should be 0
	call	v_ver		;make sure it is
	call	a_crm0		;now write all ones to same loc
	pop	h		;restore addr
	inx	h		;+1
	mov	a,h		;done all?
	ani	crmsz/100h
	jz	L1635		;loop if not
	; write zeroes to all of memory (that's why this is so slow)
	call	zmcmd		;zero memory
	; loop through locs 1000-1777
	; verify that they read as 0, then write all ones and verify that too
	rst	4		;copy
	db	00h
	dw	ones		;-1,,-1
	dw	dmdat		;to DMDAT
	rst	4		;copy
	db	00h
	dw	ma1000		;1000'
	dw	memad		;to MEMAD
L165F:	call	em2		;read a loc
	call	cmp36		;compare
	dw	embuf		;data read
	dw	mad000		;to 0 (should have been cleared by ZM)
	jnz	bc_cer		;err if diff
	call	dm2		;deposit -1,,-1
	call	em2		;read it back
	call	cmp36		;compare
	dw	embuf		;data read
	dw	ones		;to -1,,-1
	jnz	bc_cer		;err if diff
	lhld	memad		;get addr
	inx	h
	mov	a,h
	ani	2000q/100h	;reached 2000' yet?
	shld	memad
	jz	L165F		;loop if not
	ret			;that's IT?!
;
a_crm0:	; write all ones to curr CRAM loc
	push	h		;save
	lxi	h,-1		;write ones
	jmp	L1698
;
w_crmz:	; write all zeroes to CRAM loc in HL
	call	cadwr		;set addr latches
	push	h		;save
	lxi	h,0		;data to write
L1698:	mvi	c,07h		;write diag func
L169A:	mov	a,c		;set diag func
	sta	crmfn
	call	wfunc		;write 12 bits
	dcr	c		;done all 7...0?
	jp	L169A		;loop if not
	pop	h		;restore
	ret
;
v_ver:	; verify CRAM data against HL (repeated)
;;; only called from one place...
	shld	crmbf+0Ch	;store HL in all "don't care" locs
	shld	crmbf+0Eh
	shld	crmbf+10h	;(overlay CRMTM)
	shld	crmbf+18h
	shld	crmbf+1Ah
	shld	crmbf+1Ch
	mov	a,l		;BC=NOT HL
	cma
	mov	c,a
	mov	a,h
	cma
	mov	b,a
	lxi	h,crmbf		;pt at buf
L16C2:	mov	e,m		;get data read
	inx	h
	mov	d,m
	inx	h
	xchg			;into HL (save HL in DE)
	dad	b		;add (NOT expected data), should get all ones
	inx	h		;if so this should make 0
	mov	a,l		;does it?
	ora	h
	jnz	bc_ber		;error if not
	xchg			;restore CRMBF ptr in HL
	mvi	a,<(low (crmbf+32d))> ;see if we've done all 16. words
	cmp	l
	jnz	L16C2		;loop if not
	ret
;
bc_cer:	lhld	memad		;get error loc
	mvi	b,40h		;err bit
	jmp	L16E2		;skip
bc_ber:	pop	h		;flush V_VER's return addr
	mvi	b,80h		;err bit
	pop	h		;catch CRAM addr
L16E2:	shld	errcd		;save error addr
	mov	a,h		;OR in err bit
	ora	b
	sta	errcd+1		;overwrite high bit
	jmp	L16F2		;skip
bca_er:	pop	b		;get bit # we were floating
	mov	a,c		;save it
	sta	errcd
L16F2:	rst	5		;enable printing
	db	low nopnt
	rst	3		;"?BC "
	dw	L1F78
	lxi	h,errcd		;get error code
	call	p16		;print it
	jmp	mmerr
;
L1700:	; see if KS10 is running, display msg if so
	pop	h		;restore HL
	push	psw
	lda	rnflg		;is it?
	ana	a
	jnz	L170B		;yes, punt
	pop	psw		;return to caller
	ret
;
L170B:	rst	3		;"?RUNNING"
	dw	L1F7D
	jmp	mmerr
;
rptpar:	; report parity error
	rst	5		;enable printing
	db	low nopnt
	xra	a		;stop clock
	out	86h
	lda	sc_off		;is soft CRAM error recovery disabled?
	ana	a
	jnz	hrderr		;yes, skip
	lxi	h,200d		;delay to let disk finish what it's doing
	call	ltloop
if dumb
	mvi	a,40h		;reg with parity stuff
	call	er_utl		;read it
else
	in	40h		;so what's the problem?
endif
	cma			;flip bits
	ani	12h		;OK if both clear
	jz	hrderr		;yep, skip
	in	42h		;check for mem busy
	cma
	ani	30h		;isolate
	mov	b,a		;and save
	in	41h		;check for mem refresh err
	cma
	ani	1		;isolate low bit
	ora	b		;mem ref err or mem busy?
	jz	softer		;no
L173D:	; non-recoverable
	rst	3		;"?NR-SCE "
	dw	L178E
hrderr:	rst	5		;don't get into a loop
	db	low chkpar
	call	clruse		;out of user mode
	rst	3		;"?PAR ERR "
	dw	L1F68
	in	40h		;get err type again
	cma
	call	p8bita		;print it
	rst	1		;<sp>
	db	' '
	in	0C3h		;get DPM PAR ERR
	cma
	ani	1		;isolate it
	call	p8bita		;print
	rst	1		;<sp>
	db	' '
	in	43h		;get R PAR RIGHT, R PAR LEFT
	cma
	ani	0F0h		;isolate
	call	p8crlf		;print
	call	clrrn		;CPU is stopped
	call	ltflt		;light FAULT light
	jmp	reini		;restart
;
uba_rd:	; cmd list to read UBA page reg #1
	dw	163001q		;UBA. 763001
	db	uba_+3
	db	0,0,end_	;END.
rh_tst:	; cmd list for checking recoverable/nonrecoverable ctrl status
	db	374q,000q,ei_+3	;EI. 776700 (vestigal, really RHBASE+000)
	dw	60000q		;ERRTS. 60000
	db	errts_
	db	374q,012q,ei_+3	;EI. 776712 (really RHBASE+012)
	dw	40000q		;ERRTS. 40000
	db	errts_
	db	0,0,end_	;END.
;
rh_exe:	; examine RH
	db	374q,000q,ei_+3	;EI. 776700 (RHBASE+000)
	db	0,0,end_	;END.
;
savlst:	db	00q		;read 776700
	db	02q		;read 776702
	db	04q		;read 776704
	db	06q		;read 776706
	db	10q		;read 776710
	db	32q		;read 776732
	db	34q		;read 776734
	db	-1		;end of list
;
L178E:	db	'?NR-SCE ',0	;non-recoverable soft (?) CRAM error (?)
L1797:	db	'%SCE ',0	;soft CRAM error
;
softer:	; check for hard CRAM err
	lxi	d,sceadr	;pt at addr buf
	call	break		;is this the addr we want?
	jz	hrderr		;yes, go complain
	mvi	a,1		;disable PE(1)
	out	84h
	shld	sceadr		;set new prev
	lxi	h,rh_tst	;check RH11 to see if ready to read
	call	chnxct
	jc	L173D		;RH11 busy, you lose
	; recover
	rst	3		;"%SCE"
	dw	L1797
	lxi	h,sceadr	;get addr
	call	p16		;print it
	rst	4		;crlf
	db	02h
	call	dskdft
	xra	a		;turn off parity checking
	out	40h
	lxi	h,uba_rd	;pt at disk UMR #1
	call	chnxct
	rst	2		;internal mode on
	call	ei1		;read the UMR
	rst	6		;internal mode off
	lxi	b,rh_exe	;cmd list
	lxi	d,rm100		;place to copy it
	mvi	a,6		;byte count
	call	m5b		;copy
	lxi	h,savlst	;list of regs to save
	push	h
	lxi	d,rhsave	;pt at buf
L17E4:	lxi	b,embuf		;move from EMBUF
	call	movreg		;copy 5 bytes
	pop	h		;get list ptr
	mov	a,m		;get next byte
	sta	rm100+1		;patch into cmd list
	inr	a		;-1?
	jz	L1800		;yes, end of list
	inx	h		;otherwise ptr +1
	push	h		;save again
	lxi	h,rm100		;pt at list
	push	d		;save DE
	call	chnxct		;read next reg
	pop	d		;restore
	jmp	L17E4		;go save
L1800:	; ready to reload ucode
	rst	2		;internal mode on
	lxi	d,1002q		;ptr to ucode
	call	filesh		;read first page
	jc	c_bter
	call	dmem2c		;dump out to CRAM
	; done, restore CRAM addr
	lhld	sceadr		;get failing addr
	call	cadwr		;set it
	; restore RH11
	lxi	h,uba_rd	;set I/O addr to UMR #1
	call	chnxct
	; restore UMR (need to shift + mask first)
	lda	rhsave+3	;get ctrl bits
	ani	78h		;isolate
	mov	c,a		;copy
	lxi	h,rhsave	;pt at buf
	call	shr36		;right 4 bits
	db	4
	mov	a,c		;restore bits
	sta	rhsave+2	;put them where they belong
	call	shr36		;right 5 more bits
	db	5
	rst	4		;copy
	db	00h
	dw	rhsave		;UMR data
	dw	dmdat		;to DMDAT
	call	di1		;and deposit it
	; restore RH11C regs
	lxi	h,rh_exe	;set I/O addr
	call	chnxct
	lxi	h,savlst	;list of reg #'s
	push	h		;put on stack
	lxi	b,rhsave+5	;start with 1st RH11 reg (skip UMR)
L1844:	lxi	d,dmdat		;dest=DMDAT
	call	movreg		;copy data into buf
	pop	h		;get reg # list
	lda	ioad		;get curr one
	ani	0C0h		;isolate reg offset (6 bits) (necessary?)
	ora	m		;OR in the next one
	sta	ioad		;patch it back in
	mov	a,m		;was that end of list?
	inr	a
	jz	L1863		;skip if so (don't write random reg)
	inx	h		;otherwise ptr +1
	push	h		;save
	push	b
	call	di1		;deposit the register
	pop	b
	jmp	L1844		;loop for next
L1863:	call	smfini		;set parity defaults
	call	cscmd		;restart clock
	rst	6		;internal mode off
	jmp	nullj		;back to doing nothing
;
break:	; see if curr CRAM addr is brk addr (DE=ptr to word holding brk addr)
	push	d		;save
	mvi	a,03h		;func=read CRAM addr
	call	readc
	pop	d		;restore
	lhld	tmpb2		;get curr CRAM addr
	mov	a,h
	ani	(crmsz/100h)-1	;mask off bad bits
	mov	h,a
	ldax	d		;get low byte
	cmp	l		;is this right?
	rnz			;no
	inx	d		;maybe, check high byte
	ldax	d
	cmp	h		;set flags
	ret
;+
;
; Examine KS10 memory using short (16-bit) in-line addr.
;
;-
examsh:	stc
depsht:	; stupid, zillions of places do "ANA A" before calling here to set C=0
	; should have separate entry that does it
	xthl
	call	targ1		;get in-line arg
	xthl
	xchg
exmhl:	; (come here with C=1 for examine addr in HL)
	shld	shrtad		;save
	lxi	d,shrtad	;pt at it
if dumb
	push	psw
	cc	emint		;call whichever
	pop	psw
	cnc	dmint
	ret
else
	jc	emint		;was all that carry flag shit really worth it?
	jmp	dmint
endif
;
arg16_:	; parse 16-bit arg
	rst	4		;call arg routine
	db	04h
	dw	t80dt
	lhld	t80dt		;get the data
	ret
;
p8bit:	; print 3-digit octal #, ptr to it in HL
	push	h		;save
L18A1:	push	b
	push	d
	push	psw
	call	octal		;convert it on stack
	db	1,3		;1 byte data, 3 digits
	mvi	c,3		;loop count
L18AB:	pop	psw		;catch a digit
	call	pchr		;print it
	dcr	c		;loop
	jnz	L18AB
	pop	psw		;restore everything
	pop	d
	pop	b
	pop	h
	ret
;
p8bita:	; print 8-bit datum in A
	push	h		;save
	lxi	h,p8_tmp	;point at buf
	mov	m,a		;save byte there
	jmp	L18A1		;go print it
;
p16_:	; print 16-digit octal # in TMPB2
	lxi	h,tmpb2		;pt at it
p16:	; print 6-digit octal # at (HL)
	push	psw		;save
	push	b
	push	d
	push	h
	call	octal		;convert
	db	2,6		;2 data bytes, 6 digits
	mvi	b,6		;loop count
L18CE:	pop	psw		;catch a char
	call	pchr		;print it
	dcr	b		;loop
	jnz	L18CE
	pop	h		;restore
	pop	d
	pop	b
	pop	psw
	ret
;
p36_:	; print 36-bit # in EMBUF
	lxi	h,embuf		;pt at it
p36:	; print 36-bit # at (HL)
	push	psw		;save
	push	b
	push	d
	push	h
	call	octal		;convert
	db	5,12d		;5 data bytes, 12 digits
	call	phalf		;do l.h. (6 digits)
	rst	1		;,,
	db	','
	rst	1
	db	','
L18EE:	call	phalf		;do r.h. (6 digits)
	pop	h		;restore
	pop	d
	pop	b
	pop	psw
	ret
;
phalf:	; print 6 octal digits (prepared by OCTAL)
	pop	h		;catch r.a.
	mvi	b,6		;loop count
L18F9:	pop	psw		;do a digit
	call	pchr
	dcr	b		;loop
	jnz	L18F9
	pchl			;return
;
p18:	; print 18-bit octal #
	push	psw		;save
	push	b
	push	d
	push	h
	call	octal		;convert
	db	3,6		;3 data bytes, 6 digits
	jmp	L18EE		;go print it
;
octal:	; convert # at (HL) to octal
	; in-line: db n,m (n=# bytes in #, m=# digits to convert)
	; digits are pushed onto the stack in reverse order
	lxi	d,0307h		;BTMSK=07, BTNUM=03
;;; wasteful, they're both constants, no need to save in memory
;;; comments say they were allowing for other radixes
	xchg
	shld	btmsk		;save
	xthl
	mov	b,m		;# valid bytes in # (?)
	inx	h
	mov	c,m		;# digits to convert
	inx	h
	shld	hlsave		;save return addr (stack will be trashed)
	pop	h		;get HL
	push	b		;save ctrs
	lxi	h,tmpbf2	;addr of our buf
L1922:	ldax	d		;copy b bytes from (DE) to (HL)
	inx	d
	mov	m,a
	inx	h
	dcr	b
	jnz	L1922
	pop	b
if dumb
	lxi	h,tmpbf2	;pt at buf again
	xra	a
	mov	d,a		;pt at last byte with (HL)
	mov	e,b
	dcr	e
	dad	d
else
	dcx	h		;is it just me?
;;; even this is needless, if you put the DCX H before the RAR stuff in
;;; the shift loop below you can just use HL=TMPBF2+B as it was a second ago
endif
	shld	octsv		;save
L1936:	; convert next digit
	lxi	h,tmpbf2	;pt at low end of buf
if dumb
	lda	btmsk		;get mask
else
	mvi	a,7		;always octal
endif
	ana	m		;get digit
	adi	'0'		;convert
	push	psw		;save
	dcr	c		;done all digits?
	jz	L195C
if dumb
	lda	btnum		;get shift count
	mov	d,a
else
	mvi	d,3		;it's always 3
endif
L1948:	mov	e,b		;copy byte count
	lhld	octsv		;get ptr to high end
	ana	a		;C=0
L194D:	mov	a,m		;shift this byte
	rar
	mov	m,a
	dcx	h		;ptr -1
	dcr	e		;done all bytes?
	jnz	L194D
	dcr	d		;shifted all bits?
	jnz	L1948
	jmp	L1936		;yes, around for next digit
L195C:	lhld	hlsave		;restore r.a.
	pchl
;
shr36:	; shift 36-bit # at (HL) right by # bits given by in-line byte
	mvi	a,5		;5 bytes
shr24:	; enter here with A set for other sizes
	xthl			;fetch in-line byte
	push	b
	mov	b,m
;;; interrupts had better be fucking disabled!!!
;;; otherwise the RST 7 sequence will overwrite the stuff we're keeping
;;; above the top of the stack
	inx	sp		;skip merrily up the stack
	inx	sp
	inx	h		;to fix our PC
	xthl			;and get HL back
	dcx	sp		;asking for it (unless you didn't need BC)
	dcx	sp
	push	d		;save others
	push	h
	mov	e,a		;copy # bytes
	dcr	a		;advance HL to HL+A-1
	add	l
	mov	l,a
	mov	a,h
	aci	0
	mov	h,a
	push	h		;save that too
L1976:	pop	h		;easy on the clutch...
	push	h
	mov	c,e		;get byte count
	ana	a		;C=0
L197A:	mov	a,m		;shift this byte right
	rar
	mov	m,a
	dcx	h		;ptr -1
	dcr	c		;loop (C still valid)
	jnz	L197A
	dcr	b		;finished shifting?
	jnz	L1976		;loop if not
	pop	h		;flush ptr to high byte
	pop	h		;restore regs
	pop	d
	pop	b
	ret
;
arg96:	; shouldn't be subroutine, only called once
	mvi	a,12d		;read 12 bytes
	jmp	L1998
;
L1990:	; read 36-bit arg
	mvi	a,5		;read 5 bytes
	jmp	L1997
L1995:	; read 16-bit arg
	mvi	a,2		;read 2 bytes
L1997:	pop	h		;restore HL (from RST service)
L1998:	sta	chrcnt		;save # bytes to read
	lda	rpton		;already parsed in first RP iteration?
	ana	a
	jnz	L19F9		;yes, go get it
	lhld	_arg1		;pt at 1st arg
	lxi	b,0		;b, c=0
L19A8:	mov	a,m		;get char
	sui	'0'		;cvt to binary
if dumb
	ani	0F8h		;octal digit?
	jnz	L19B9		;no
	mov	a,m		;yes, convert
	sui	'0'
else
	cpi	10d		;valid?
	jnc	L19B9		;no
endif
	push	psw		;save
	inr	c		;count it
	inx	h		;skip it
	jmp	L19A8
L19B9:	call	sepchr		;skip blanks, tabs
	shld	_arg1		;update ptr
	call	eocml		;end of cmd line?
	jnc	kilnm
	lhld	rpbufs		;yes, get ptr to RP data buf
	xra	a		;init byte count
	mov	m,a
	inx	h		;ptr +1
if dumb
	mov	e,l		;copy to DE
	mov	d,h
else
	xchg			;don't need HL anyway
endif
	dcr	c
L19CE:	push	d		;copy DE
	pop	h		;to HL
	inx	d		;+3
	inx	d
	inx	d
	push	h		;save
	lhld	rpbufs		;get ptr to byte count
	mov	a,m		;count+3
	adi	3
	mov	m,a
	pop	h		;restore
	mvi	b,8d		;loop count (pad to at least 8 chars)
L19DE:	pop	psw		;get a digit
L19DF:	stax	d		;save it
	call	shr36		;shift buf (still at (HL)) left 3
	db	3
	dcr	c		;done all chars?
	jp	L19F0		;skip
	; done all chars, now we're padding
	xra	a		;pad
	dcr	b		;done all 8?
	jz	L19F4		;skip if so
	jmp	L19DF		;otherwise loop
L19F0:	dcr	b
	jnz	L19DE
L19F4:	; looped 8 times, finished all chars?
	mov	a,c		;well?
	ana	a
	jp	L19CE		;keep going if not
L19F9:	; parsed # first time through RP loop, pick it up
	lhld	rpbufs		;get ptr
	mov	b,m		;get char count
	inx	h		;skip it
	xthl
	call	targ1		;get dest ptr
	xthl
	lda	chrcnt		;get # bytes wanted
	mov	c,a		;C=wanted, B=have
L1A07:	mov	a,m		;get a byte
	stax	d		;save it
	inx	h		;ptrs +1
	inx	d
	dcr	c		;satisfied?
	jz	L1A1E		;yes
	dcr	b		;ran out yet?
	jnz	L1A07		;no, loop
	mov	a,b		;A=0
L1A14:	; pad buf
	dcr	c		;done?
	jm	L1A22		;yes
	stax	d		;no, pad
	inx	d		;ptr +1
	jmp	L1A14		;loop
L1A1D:	inx	h		;skip unused digits
L1A1E:	dcr	b
	jnz	L1A1D
L1A22:	shld	rpbufs		;update ptr
	ret
;
place:	; copy 12 bits from (HL) to (DE), preserve HL but DE=DE+2
	mov	a,m		;get low byte
	stax	d		;copy
	inx	h		;ptrs +1
	inx	d
	mov	a,m		;get high byte
	ani	0Fh		;mask
	stax	d		;save
	inx	d		;DE+1
	dcx	h		;restore HL
	ret
;
rtndis:	; RST 4 function dispatcher
	; HL already pushed, in-line byte fetched in A
	lxi	h,L1A43		;get base of table
	push	psw
	push	d
	add	l		;index using A
	mov	l,a
	mov	a,h		;(propogate C into high byte)
	aci	0
	mov	h,a
	mov	e,m		;fetch dispatch addr
	inx	h
	mov	d,m
	xchg			;put in HL
	pop	d		;(restore others)
	pop	psw
	pchl			;go
L1A43:	dw	L1AF5,L045D,L1995,L1700,L1990,L1B90
;
clrbyt:	; clear a byte in first 256 bytes of RAM
	mvi	h,<(high ramst)> ;RAM base addr
	mov	l,a		;A is low byte of addr
	mvi	m,0		;zap it
	pop	h
	ret
;
L1A56:	; cmd requires argument
	rst	3		;"?RA"
	dw	L1F99
	jmp	norml
;
kilnm:	; bad number
	rst	3		;"?BN"
	dw	L1F9D
;
mmerr:
if mm
	lda	mmflg
	ana	a
	jz	reini		;restart
	call	decnet		;flush msgs
else
	jmp	reini
endif
;
mmerr1:	call	mmcmd		;reset mode
	jmp	reini		;restart
;
d_bter:	adi	02h		;004XXX -- err starting ucode
c_bter:	adi	02h		;003XXX -- err reading ucode
b_bter:	adi	02h		;002XXX -- err reading page of pointers
a_bter:	adi	02h		;001XXX -- err reading home block
	call	ltflt		;light fault light
L1A7A:	sta	errcd+1		;save type
	rst	5		;enable printing
	db	low nopnt
	rst	3		;"?BT "
	dw	L1F52
	lxi	h,errcd		;pt at code
	call	p16		;print it
	rst	4		;crlf
	db	02h
	jmp	reini		;restart
;
l_bter:	; error loading boot block
	lxi	h,state		;pt at state
	mvi	a,01h		;set FAULT light w/o changing state
	ora	m
	mov	m,a
	mvi	a,8d*2		;010XXX -- err loading boot block
	jmp	L1A7A
;
busres:	; check bus status (set flags according to status AND inline byte)
	xthl			;get ptr
	in	0C1h		;read status
	cma			;(flip)
	ana	m		;set flags
	inx	h		;+1
	xthl			;restore stack, HL
	ret
;
setrn:	; set RUN flag
	mvi	b,04h		;set STATE light
	call	statem
	db	0Fh		;preserve all 4 low bits
	xra	a		;no worse than MVI A,-1, but why?
	cma
L1AA9:	sta	rnflg		;set flag
	ret
;
clrrn:	; clear RUN flag
	mvi	b,00h		;clear RUN light
	call	statem
	db	0Bh		;clear bit 2
	xra	a		;set flag to 0
	jmp	L1AA9		;go do it, return
;
norefr:	; memory refresh error
	rst	5		;enable printing
	db	low nopnt
	rst	5		;don't loop
	db	low chkref
	call	clruse		;leave user mode
	rst	3		;"?MRE"
	dw	L1F72
ltflt:	; light FAULT light
	push	psw		;save
	mvi	b,01h		;set bit 1
	call	statem
	db	0Ah		;clear b0 (RUN?), b2 (STATE?)
	pop	psw		;restore
	ret
;+
;
; Modify bits in state word.
; B has bits to set, in-line byte has mask to AND.
;
;-
statem:	xthl			;get ptr
	lda	state		;mask off bits to clear
	ana	m
	inx	h		;skip inline byte
	xthl			;restore HL, r.a.
	ora	b		;set bit(s)
	sta	state		;save
	out	41h		;update lights
	ret
;
eocml:	; check for end of cmd line (C=1 if so)
	push	h		;save
	lhld	_arg1		;get ptr
	mov	a,m		;get char
if ver52
	cpi	';'		;semicolon?
	jz	mmerr		;manufacturing mode err if so (what?)
endif
	cpi	0FFh		;eol marker?
	jz	L1AF2
	cpi	','		;or comma?
	jz	L1AF2
	ana	a		;no, not eol, C=0
	pop	h
	ret
if dumb ; is this referenced anywhere?
L1AEF:	call	bfrst		;flush CTY input buf
endif
L1AF2:	stc			;eol
	pop	h
	ret
;
L1AF5:	; move 5 bytes from one buf to another (two in-line args to RST 4)
	pop	h		;restore things for TARG2
	xthl
	push	d		;save regs
	push	b
	call	targ2		;get 2 inline args
	call	movreg		;move the word
	pop	b		;restore
	pop	d
	xthl
	ret
;
movreg:	; copy 5 bytes from (BC) to (DE) (don't trash A)
	mvi	a,05h
m5b:	; copy A bytes
	dcr	a
	cnz	m5b		;no worse than pushing PSW each time
	ldax	b
	stax	d
	inx	d
	inx	b
	ret
;
cmp36:	; compare two 36-bit #'s (two in-line ptrs)
	xthl
	call	targ2		;get 2 in-line args
	xthl
	xchg
	mvi	d,5
L1B16:	ldax	b		;compare a byte
	cmp	m
	rnz			;no match
	inx	b		;ptrs +1
	inx	h
	dcr	d		;done all 5 bytes?
	jnz	L1B16		;loop if not (luckily leaves Z=1 when done)
	ret
;
targ2:	; fetch two in-line args into BC, DE (after XTHL)
	mov	c,m
	inx	h
	mov	b,m
	inx	h
targ1:	; fetch one in-line arg into DE (after XTHL)
	mov	e,m
	inx	h
	mov	d,m
	inx	h
	ret
;
inc36:	; bump 36-bit # by 1 (addr of buf is in in-line word)
	xthl
	call	targ1		;get ptr
	xthl
	xchg			;pt with HL
	xra	a		;load 0
	stc			;C=1
L1B31:	adc	m		;A=0+M+1
	mov	m,a		;save
	rnc			;no carry, punt
	inx	h		;carry, A is 0 once again, C=1
	jmp	L1B31		;loop
;
rdatt:	; read bus latches, in-line buf ptr
	xthl
	call	targ1		;get ptr
	xthl
rdatp:	; enter here with ptr in DE
	push	d		;save it
	in	00h		;28-35
	cma			;flip
	stax	d		;save
	inx	d
	in	01h		;20-27
	cma
	stax	d
	inx	d
	in	02h		;12-19
	cma
	stax	d
	inx	d
	in	03h		;4-11
	cma
	stax	d
	inx	d
	in	43h		;0-3
	cma
	ani	0Fh		;isolate low 4 bits
	stax	d
	pop	d		;restore
	ret
;
wdatt:	; opposite of above, write data latches from buf (in-line ptr)
	xthl
	call	targ1		;get buf ptr
	xthl
wdatp:	; write data latches with data from (DE)
	push	d		;save
	ldax	d		;28-35
	out	42h
	inx	d
	ldax	d		;20-27
	out	44h
	inx	d
	ldax	d		;12-19
	out	46h
	inx	d
	ldax	d		;4-11
	out	48h
	inx	d
	ldax	d		;0-3
	out	4Ah
	pop	d		;restore
	ret
;
adatt:	; as above, but write addr latches
	xthl
	call	targ1		;get in-line arg
	xthl
adatp:	; addr is in buf at (DE)
	push	d
	ldax	d		;28-35
	out	43h
	inx	d
	ldax	d		;20-27
	out	45h
	inx	d
	ldax	d		;12-19
	out	47h
	inx	d
	ldax	d		;4-11
	out	49h
	inx	d
	ldax	d		;0-3
	out	4Bh
	pop	d		;restore
	ret
;
L1B90:	; clear a word, addr+5 passed in-line
	pop	h		;fix things for TARG1
	xthl
	call	targ1		;get addr
	xthl
	xchg			;pt with HL
	mvi	a,5		;loop count
L1B99:	dcx	h		;ptr -1
	mvi	m,0		;zap a byte
	dcr	a		;loop until done all
	jnz	L1B99
	ret
;
sepchr:	; skip blanks, tabs
	push	psw		;save
	dcx	h		;correct for next
L1BA3:	inx	h		;+1
	mov	a,m		;get char
	cpi	' '		;blank?
	jz	L1BA3		;skip it
	cpi	tab		;tab?
	jz	L1BA3		;skip it
	pop	psw		;done, HL pts at non-blank
	ret
;
delay_:	; delay, in-line byte is multiple of 1.02 usec to delay
	xthl			;get arg
	push	psw
	mov	a,m
	inx	h
L1BB5:	dcr	a		;count
	push	psw		;(waste time)
	pop	psw
	jnz	L1BB5		;loop until done
	pop	psw		;restore everything
	xthl
	ret
;
strcmp:	; compare ASCIZ strings (HL) and (DE)
	; if equal (when (DE) runs out anyway)
	ldax	d		;end of (DE)?
	ana	a
	jz	L1BCA		;yes
	cmp	m		;match?
	rnz			;return if not
	inx	d		;ptrs +1
	inx	h
	jmp	strcmp
L1BCA:	shld	_arg1		;update cmd line ptr
	call	eocml		;eol?
	rc			;yes (Z=1)
	ora	h		;set Z=0 (H is non-zero)
	ret
;+
;
; Fix KLINIK lights after key turn.
;
; B=new switch state, KLNKSW=old state.
;
; 2	ENABLE
; 4	DISABLE
; 6	PROTECT
;
;-
if klinik
klnklt:	mov	a,b		;get new state
	sta	klnksw		;save it
	cpi	4		;disabled?
	jz	setm0
	cpi	6		;protected?
	jz	L1BF0
	lda	cslmod		;get KLINIK mode
	cpi	_mode3		;mode 3?
	cnz	setm2		;go to mode 2 if not
L1BE9:	mvi	b,2		;turn on REMOTE
kl_lam:	call	statem
	db	0FDh		;preserve all but REMOTE
	ret
L1BF0:	lda	kpwbuf		;get password
	ana	a		;is there one?
	jz	setm0		;no, mode 0
;;; CNZ, JNZ are dumb, we're only here on NZ anyway
	cnz	setm1		;yes, mode 1
	jnz	L1BE9		;go turn on REMOTE lamp
;
setm1:	; set KLINIK mode 1
	mvi	a,_mode1	;flag
	lxi	h,mode1		;dispatch
	jmp	setm		;go set it
;
setm0:
if ver52
	rst	5		;don't change to mode 3
	db	low klline
endif
	mvi	b,0
	call	kl_lam		;set lights
	call	hangup		;hang up
	mvi	a,_mode0	;flag
	lxi	h,mode0		;dispatch
	jmp	setm		;go set it
;
setm3:	; set KLINIK mode 3
	mvi	a,_mode3	;flag
	lxi	h,mode3		;dispatch
	jmp	setm
;
setm4:	; set KLINIK mode 4
	lda	usrmd		;in user mode?
	ana	a
	rnz			;yes, don't do it
	sta	mailfg		;clear flags
	sta	e_cnt
	lxi	h,e_beg-1	;reset enveloper
	shld	e_buf
	mvi	a,_mode4	;flag
	lxi	h,mode4		;dispatch
	jmp	setm
;
setm2:	; set KLINIK mode 2
	lda	cslmod		;get curr mode
	ani	_mode0+_mode1	;mode 0 or 1?
	jz	L1C45		;no
	mvi	a,02h		;set flag in loc 34 ("KLINIK active")
	call	wrd34
L1C45:	lxi	h,mode2		;flag
	mvi	a,_mode2	;dispatch
setm:	sta	cslmod		;set mode
setdis:	shld	moddis		;and dispatch
	ret
;
hangzk:	rst	5		;KLNKSW=0
	db	low klnksw
hangup:	lda	state		;get state
	ani	7		;turn off DTR
	out	41h
	mvi	a,03h		;set flag in loc 34 ("CARRIER LOSS")
	call	wrd34
	lxi	h,200d*2	;wait 2 seconds
	jmp	ltloop		;and return
;
wrd34:	; deposit A in KS10 loc 34 and interrupt the KS10
	push	psw		;save flag
	rst	4		;clear DMDAT
	db	0Ah
	dw	dmdat+5
	pop	psw
	inx	h		;pt at 2nd byte
	mov	m,a		;write bits 20-27
	ana	a		;C=0 for deposit
	call	depsht		;deposit loc 34
	dw	34q
	jmp	L080C
;
chkadd:	; update checksum (char in A, checksum in B)
	add	b		;add in the new char
	mov	b,a		;save
	inx	h		;ptr +1
	jmp	L1C90		;back into loop
;
decnet:	; "APT envelope sender" -- send a packet if we have one ready
	lda	mailfg		;are we running?
	ana	a
	rz			;no op if not
	ei			;ints on in case host punts
	lda	envmno		;get 1's comp of packet #
	cma
	ani	7Fh		;trim to 7 bits
	sta	envmno		;put back
	; compute checksum
	lxi	h,envbuf	;pt at buf
	mvi	b,0
L1C90:	mov	a,m		;get a byte
	cpi	'M'-100q;^M		;end of msg?
	jz	L1C9A
	ana	a		;^@?
	jnz	chkadd		;update checksum otherwise, and loop
L1C9A:	inx	h		;skip the cr
	mvi	m,0		;put ^@ after cr
	mov	a,b		;get checksum
	cma			;negate
	inr	a
	ani	77q		;trim to 6 bits
	cpi	75q		;need quoting?
	jp	L1CA9
	ori	100q		;yes, make it a letter or something
L1CA9:	sta	envchk		;save it
L1CAC:	rst	5		;reset answer type
	db	low aptans
	call	kchr		;send 2 SOHs for sync
	db	'A'-100q;^A
	call	kchr
	db	'A'-100q;^A
	lxi	d,envmno	;send the rest of the packet
	call	kline1
	lda	envbuf		;get first char
	cpi	'?'		;? or % => abort
	jz	mmerr1
	cpi	'%'
	jz	mmerr1
L1CC9:	lda	aptans		;poll for answer
	ana	a
	jz	L1CC9
	cpi	'N'		;NAK?
	jz	L1CAC		;retry if so (otherwise assume ACK)
decex2:	xra	a		;end of envelope
	sta	mailfg
	lxi	h,envbuf	;init ptr
	shld	envpnt
	ret
endif ; klinik
;
mv_all:	; copy a line into CTY buf (called by FI cmd)
	lxi	b,e_beg+2	;input ptr
	call	bfrst		;flush CTY input buf
	lxi	d,bufbg		;output ptr
	lxi	h,eol		;pt at cmd counter
	mvi	m,0		;init to 0
L1CEE:	ldax	b		;get a char
	stax	d		;copy
	inx	b		;ptrs +1
	inx	d
	cpi	','		;cmd sep?
	cz	L1CFC		;bump ptr if so (cute)
if dumb
	cpi	0FFh		;end of line?
else
	inr	a
endif
	jnz	L1CEE		;loop if not
L1CFC:	inr	m		;bump cmd count
	ret
;
if klinik
mode4:	; handle input in KLINIK mode 4 (packets)
	cpi	'A'-100q;^A		;sync char?
	jnz	mmout		;no, just write char
	lxi	h,L1D09		;got a sync, set continuation addr
	jmp	setdis		;and return
L1D09:	cpi	'A'-100q;^A		;ignore extra SOHs
	rz
	lxi	h,collec	;set vector for further chars
	shld	moddis
collec:	; data chars come here
	cpi	'$'		;$?
	jz	L1D95		;treat as ESC
	cpi	33q;^[		;ESC?
	jz	L1D95		;treat that as ESC too!
	cpi	15q;^M		;cr?
	jz	L1D39		;packet end if so
	cpi	1;^A		;another SOH?
	jz	setm4		;resync if so
	; nothing special, just store it
	lhld	e_buf		;get ptr
	inx	h		;+1
	mov	m,a		;save the char
	shld	e_buf		;update ptr
	lxi	h,e_cnt		;pt at count
	inr	m		;+1
	mov	a,m
	cpi	134q		;too long?
	jnc	nack_e		;NAK if so
	ret
L1D39:	; cr received, go with it
	lda	e_cnt		;get length
if (dumb eq 0)
	sui	3		;count stuff we're skipping
endif
	mov	c,a		;copy
	lxi	h,e_beg+1	;pt at checksum
	mov	a,m		;get it
	inx	h		;and skip
if dumb
	dcr	c
	dcr	c
	dcr	c
endif
L1D45:	add	m		;add in next byte
	inx	h		;ptr +1
	dcr	c		;done all?
	jp	L1D45		;loop if not
	ani	77q		;low 6 bits are 0 right?
	jnz	nack_e		;no
	mvi	m,0FFh		;mark end
	lxi	h,lstmsg	;pt at prev pkt #
	mov	c,m		;save
	lda	e_beg		;get this thing's msg #
	cmp	c		;is this a retrans of prev pkt?
	jz	L1D79		;yes, ACK & drop
	mov	m,a		;oh well, hope they didn't hallucinate any ACKs
	call	mv_all		;copy into cmd buf
	mvi	a,41q		;reinit envelope #
	sta	envmno
	call	setm4		;mode 4
	call	decex2		;clear old msgs
	lxi	h,L1D75		;come back here when done w/cmd
	shld	norend
	jmp	dcode
L1D75:	; here when cmd has finished
	ei			;ints on
	call	decnet		;flush output
L1D79:	call	setm4		;back to wait for next packet
;
ack:	call	kline		;send ACK
	dw	L1D82
	ret
L1D82:	db	1,1,'A',33q,0
	;;;byte	^A,^A,'A,^[,0	;ACK for KLINIK port when user mode set
;
nack_e:	call	setm4		;reinit input handler
	call	kline		;send NAK down KLINIK line
	dw	L1D90
	ret
L1D90:	db	1,1,'N',33q,0
	;;;byte	^A,^A,'N,^[,0
;
L1D95:	; ESC or $ in packet
	lhld	e_buf		;get ptr
	mov	a,m		;read control type (ACK/NAK)
	sta	aptans		;save
	jmp	setm4		;reinit for input, return
;+
;
; Output from KLINIK line to CTY, with buffering to handle speed mismatch
; (for a while anyway).  If interrupted during output, outgoing chars are
; pulled from buf at SYSOUT, new chars are inserted at SYSIN.
;
;-
mmout:	ana	a		;^@?
	rz			;ignore
	lhld	sysout		;get ptr
	mov	a,h		;NZ?
	ana	a
	jz	L1DC7		;no, just do the output
	; store in buf
	xchg			;DE=SYSOUT
	lhld	sysin		;is SYSIN defined?
	mov	a,h
	ana	a
	jnz	L1DB8		;yes
	lxi	h,sysbuf	;no, init it
	shld	sysin
L1DB8:	lxi	h,-(sysend-L0000) ;see if at end of buf
	dad	d		;are we?
if dumb ;?????????? are flags already set?
	mov	a,h		;(HL should be 0)
	ora	l
endif
	rz			;drop the char if so
	xchg			;HL=SYSOUT again
	mov	m,b		;luckily we had the char in B too
	inx	h		;ptr +1
	mvi	m,0		;0 at end
	jmp	setout		;set SYSOUT, return
L1DC7:	; not busy, start first char going out and set up buf for more
	lxi	h,sysbuf	;init SYSOUT
	shld	sysout		;(SYSIN initted on next call -- why?)
	mov	a,b		;copy char
L1DCE:	mov	b,a		;whee
	cpi	12q;^J		;line feed?
	jnz	L1DDB		;no
	; we may be expected to send ^Q after each ^J printed
	lda	cntlq_		;so?
	ana	a		;NZ?
	cnz	kchr0		;send it if so
L1DDB:	mov	a,b		;get char back
	ei			;ints on
	call	pchr1z		;print char on CTY, may get inted w/more stuff
	di			;off again
	lhld	sysin		;get fill ptr
	mov	a,h		;anything?
	ana	a
	jz	z_tbuf		;no, turn off buffering, return
	mov	a,m		;get it
	ana	a		;^@?
	jz	z_tbuf		;yes, turn off buffering, return
	inx	h		;update ptr
	shld	sysin
	jmp	L1DCE		;print the char, loop
;
z_tbuf:	; zap MMOUT buffers
	lxi	h,0		;set both to 0
	shld	sysin
setout:	shld	sysout
	ret
endif ; klinik
;
L1DFF:	; no data acknowledge
	rst	3		;"?NDA"
	dw	L1F87
	lxi	h,1		;err code
;
errrtn:	; set err code in HL
	shld	errcd		;save it
	ret
;
L1E09:	; no bus response
	xra	a		;clear the err
	out	88h
	rst	3		;"?NBR"
	dw	L1F93
	lxi	h,2		;err code
	jmp	errrtn
;
L1E15:	; nonexistent memory
	xra	a		;clear the err
	out	88h
	rst	3		;"?NXM"
	dw	L1F8D
	lxi	h,3		;err code
	jmp	errrtn
;
; UMR bits:
; 40000=VALID
; 100000=36BIT
;
dskseq:	; UBA. 763001
	dw	163001q		;select UMR01 (for Unibus addrs 4000-7777)
	db	uba_+3
	; DI. 140001
	dw	140001q		;VALID, 36BIT, base addr=1000'
	db	di_
	; LI. RHBASE+10
	db	374q,010q,li_+3	;get CSR to set unit (374, +3 vestigal)
	; DI.IND UNITNM
	dw	unitnm		;set unit #
	db	di_ind
	; EI. RHBASE+12
	db	374q,012q,ei_+3	;read drive status
	; TWAIT 400
	dw	400q		;check for drive present
	db	twait_
	; WAIT 200
	dw	200q		;wait for ctrl rdy (w/timeout)
	db	wait_
	; LI. RHBASE+10
	db	374q,010q,li_+3	;drive status reg
	; DI. 40q
	dw	40q		;controller clear
	db	di_
	; DI.IND UNITNM
	dw	unitnm		;set unit #
	db	di_ind
	; LI. RHBASE+00
	db	374q,000q,li_+3	;controller CSR
	; DI. 11
	dw	11q		;drive clear
	db	di_
	; DI. 21
	dw	21q		;set read-in preset
	db	di_
	; LI. RHBASE+12
	db	374q,012q,li_+3	;drive status reg
	; WAIT. 200
	dw	200q		;wait for RIP to complete
	db	wait_
	; TWAIT. 100
	dw	100q		;look for volume valid
	db	twait_
	; LI. RHBASE+06
	db	374q,006q,li_+3	;select track/sector reg
	; DI.IND BLKNUM
	dw	blknum		;write it
	db	di_ind
	; LI. RHBASE+34
	db	374q,034q,li_+3	;select desired cyl reg
	; DI.IND BLKADR
	dw	blkadr		;write it
	db	di_ind
;
qxfr:	; LI. RHBASE+02
	db	374q,002q,li_+3	;select RH11C word count reg
	; DI. -2000
	dw	-2000q		;2000 18-bit Unibus words = 1000 KS10 words
	db	di_
	; LI. RHBASE+04
	db	374q,004q,li_+3	;select RH11C bus addr reg
	; DI. 4000
	dw	4000q		;base of UMR01 space
	db	di_
	; LI. RHBASE+00
	db	374q,000q,li_+3	;select CSR
	; DI. 71
	dw	71q		;cmd=read
	db	di_
	; EI. RHBASE+00
	db	374q,000q,ei_+3	;CSR again (wouldn't need this if CMDWAI fixed)
	; WAIT. 200
	dw	200q		;wait for ready bit
	db	wait_
	; EI. RHBASE+12
	db	374q,012q,ei_+3	;select drive status reg
	; ERRTS. 40000
	dw	40000q		;check for drive errors
	db	errts_
	; EI. RHBASE+00
	db	374q,000q,ei_+3	;RH11C CSR
	; ERRTS. 60000
	dw	60000q		;check for RH11C errors
	db	errts_
	; END.
	db	0,0,end_
;
; TM03 cmds:
; 07	rewind
; 11	drive clear
; 25	erase
; 27	write tape mark
; 31	file space forward
; 33	file space reverse
; 51	write check forward
; 57	write check reverse
; 61	write forward
; 71	read forward
; 77	read reverse
;
mtaseq:	; UBA. 763001
	dw	163001q		;select UMR01 (for Unibus addrs 4000-7777)
	db	uba_+3
	; DI. 40001
	dw	40001q		;VALID, base addr=1000' (why no 36BIT?)
	db	di_
	; LI. RHBASE+10
	db	364q,010q,li_+3	;select drive ctrl reg
	; DI. 40
	dw	40q		;controller/slave clear
	db	di_
	; DI.IND TAPEUN
	dw	tapeun		;set TM03 unit #
	db	di_ind
	; LI. RHBASE+32
	db	364q,032q,li_+3	;select slave/format/density reg
	; DI.IND DEN_SL
	dw	den_sl		;set it
	db	di_ind
	; EI. RHBASE+12
	db	364q,012q,ei_+3	;select drive status reg
	; TWAIT. 400
	dw	400q		;check for drive present
	db	twait_
	; WAIT. 200
	dw	200q		;wait for it to be ready
	db	wait_
	; LI. RHBASE+06
	db	364q,006q,li_+3	;select frame count reg
	; DI. 0
	dw	0		;we just don't care (but only 1 page is mapped)
	db	di_
	; LI. RHBASE+00
	db	364q,000q,li_+3	;select RH11C CSR
	; DI. 07
	dw	07q		;cmd=rewind
	db	di_
	; EI. RHBASE+12
	db	364q,012q,ei_+3	;read drive status
	; WAIT. 200
	dw	200q		;wait for ready bit
	db	wait_
qtxfr:	; LI. RHBASE+04
	db	364q,004q,li_+3	;select RH11C bus addr reg
	; DI. 4000
	dw	4000q		;base of UMR01 space
	db	di_
	; LI. RHBASE+02
	db	364q,002q,li_+3	;select RH11C word count reg
	; DI. -2000
	dw	-2000q		;2000' 18-bit Unibus words=1000' KS10 words
	db	di_
	; LI. RHBASE+06
	db	364q,006q,li_+3	;select TM03 frame count reg
	; DI. 0
	dw	0		;we don't care
	db	di_
	; LI. RHBASE+00
	db	364q,000q,li_+3	;select RH11C CSR
	; DI.IND SKP_GO
	dw	skp_go		;get cmd (31=skip or 71=read)
	db	di_ind
	; EI. RHBASE+12
	db	364q,012q,ei_+3	;select TM03 drive status
	; WAIT. 200
	dw	200q		;wait for ready
	db	wait_
	; EI. RHBASE+14
	db	364q,014q,ei_+3	;select TM03 drive error reg
retry_:	; ERRTS. 70300
	dw	70300q		;check for retryable error
	db	errts_
frmerr:	; ERRTS. 103400
	dw	103400q		;check for correctable error
	db	errts_
	; EI. RHBASE+12
	db	364q,012q,ei_+3	;select TM03 drive status
	; ERRTS. 40000
	dw	40000q		;drive errors?
	db	errts_
	; LI. RHBASE+00
	db	364q,000q,li_+3	;select RH11C CSR
	; ERRTS. 60000
	dw	60000q		;check for I/O errors
	db	errts_
	; END.
	db	0,0,end_
;
mtarst:	; reset magtape after recoverable error
	; LI. RHBASE+10
	db	364q,010q,li_+3	;select TM03 drive control reg
	; DI. 40
	dw	40q		;ctrl/slave clear
	db	di_
	; DI.IND TAPEUN
	dw	tapeun		;set unit #
	db	di_ind
	; LI. RHBASE+04
	db	364q,004q,li_+3	;select RH11C bus addr reg
	; DI. 4000
	dw	4000q		;set addr=base of UMR01
	db	di_
	; LI. RHBASE+06
	db	364q,006q,li_+3	;select TM03 frame count reg
	; DI. 0
	dw	0		;make sure it's enough
	db	di_
	; END.
	db	0,0,end_
;
L1F02:	db	'?BUS\',0
L1F08:	db	'?BFO',0
L1F0D:	db	'?IL',cr,lf,0	;<crlf> instead of \ for KLINE
L1F13:	db	'?UI\',0
L1F18:	db	'BUS 0-35\',0
L1F22:	db	'KS10>',0FFh,0	;prompt
L1F29:	db	' CYC\SENT/',0
L1F34:	db	'\RCVD/',0
L1F3B:	db	'?A/B\',0
L1F41:	db	'PC/',0
L1F45:	db	'%HLTD/',0
L1F4C:	db	'?DNF\',0
L1F52:	db	'?BT ',0
L1F57:	db	'BT SW',0
L1F5D:	db	'?DNC\',0
L1F63:	db	'OFF\',0
L1F68:	db	'?PAR ERR ',0
L1F72:	db	'?MRE\',0
L1F78:	db	'?BC ',0
L1F7D:	db	'?RUNNING\',0
L1F87:	db	'?NDA\',0
L1F8D:	db	'?NXM\',0
L1F93:	db	'?NBR\',0
L1F99:	db	'?RA',0
L1F9D:	db	'?BN',0
L1FA1:	db	'>>UBA?',0
L1FA8:	db	'>>RHBASE?',0
L1FB2:	db	'>>UNIT?',0
L1FBA:	db	'>>TCU?',0
L1FC1:	db	'>>DEN?',0
L1FC8:	db	'>>SLV?',0
L1FCF:	db	'?KA\',0
L1FD4:	db	'?FRC\',0
L1FDA:	db	'?PWL',0
L1FDF:	db	'?NA',cr,lf,0
L1FE5:	db	'PW:',cr,lf,0
L1FEB:	db	'OK',cr,lf,0
L1FF0:	db	'BT AUTO',0
	db	8d dup(0)
;
if ($-L0000) gt ramst
	.err	Overflowed ROM
endif
;
	subttl	RAM
;
	org	ramst
if dumb
	dw	1 dup(?)	;place holder for T80DT's old locn
				;(why?  anyway this loc is never reffed)
endif
c80ad:	dw	1 dup(?)	;addr for EK/DK
crmad:	dw	1 dup(?)	;addr for EC/DC
bytcnt:	dw	1 dup(?)	;;;;;;; never reffed
crmfn:	dw	1 dup(?)	;CRAM diag func
embuf:	db	5 dup(?)	;buf for examining memory
memad:	db	5 dup(?)	;addr for EM/DM
ioad:	db	5 dup(?)	;addr for EI/DI
enext:	dw	1 dup(?)	;code for "EN" type
				;0 => EM
				;2 => EI
				;4 => EK
				;6 => EC
dnext:	dw	1 dup(?)	;code for "DN" type (see above)
chrbuf:	db	5 dup(?)	;holding buf for rcvd UART char
;;; (really need all 5?)
busad:	db	5 dup(?)	;bus addr buf
dmdat:	db	5 dup(?)	;deposit memory buf
ramx1:	db	12d dup(?)	;code for X1 cmd (patch it in, I guess)
er_loc:	db	3 dup(?)	;buffer to build IN/OUT instr, RET
tmpbf2:	db	5 dup(?)	;temp buf
tmpb2:	db	5 dup(?)	;temp buf
blknum:	db	5 dup(?)	;sector # on disk
;;; (I think only low word is used)
blkadr:	db	5 dup(?)	;cyl on disk
;;; (I think the same, not sure)
if dumb
exm1:	db	1 dup(?)	;;;;; never reffed
endif
nopnt:	db	1 dup(?)	;NZ => no printing on CTY ("internal" mode)
bt_typ:	db	1 dup(?)	;boot type, 1=disk, 2=tape
p8_tmp:	db	1 dup(?)	;temp storage for P8BITA
eraddr:	db	1 dup(?)	;addr for ER cmd
if klinik
klnksw:	db	1 dup(?)	;KLINIK switch state (key on front panel)
kpwpnt:	dw	1 dup(?)	;ptr into KPWBUF (KLINIK password)
if ver52
L2057:	db	1 dup(?)	;NZ if KLINIK pw contains bad char,
				;waiting for cr
endif
watchc:	db	1 dup(?)	;NZ => CD has been seen on,
				;watch it if goes away
endif ; klinik
cmds__:	db	1 dup(?)	;cmd # within line (out of EOL total)
unitnm:	db	5 dup(?)	;Massbus unit # of disk
tapeun:	db	5 dup(?)	;Massbus unit # of TM03 tape controller
skp_go:	db	5 dup(?)	;TM03 cmd for curr tape xfr
brkon:	db	1 dup(?)	;NZ => TR cmd had arg (break addr)
brkdt:	dw	1 dup(?)	;TR cmd break addr
errcd:	dw	1 dup(?)	;curr err code (usually an address)
usrmd:	db	1 dup(?)	;NZ => USR MOD
rpend:	db	1 dup(?)
rpcntr:	db	1 dup(?)	;RP count
bfcnt:	db	1 dup(?)	;# chars in input line buffer (up to 80.)
stppd:	db	1 dup(?)	;NZ => XOFFed
eiflag:	db	1 dup(?)	;NZ => func bits for EI cmd (not EM)
diflag:	db	1 dup(?)	;NZ => func bits for DI cmd (not DM)
rnflg:	db	1 dup(?)	;NZ => KS10 is running
chkpar:	db	1 dup(?)	;NZ => report parity errs
chkref:	db	1 dup(?)	;NZ => report refresh errs
ecsav:	dw	1 dup(?)	;saved diag func in ECCMD
rm100:	db	8d dup(?)	;I/O reg buf
btmsk:	db	1 dup(?)	;bit mask in OCTAL
btnum:	db	1 dup(?)	;bit ctr in OCTAL
eol:	db	1 dup(?)	;# cmds in line (so why "eol"?), = # commas +1
am_ai:	dw	1 dup(?)	;ptr to mem addr
rpbufs:	dw	1 dup(?)	;ptr into RPTBFI
rplst:	dw	1 dup(?)	;ptr to RP cmd disp addr list (in RPINI)
rpton:	db	1 dup(?)	;NZ => RP cmd is executing
chrcnt:	db	1 dup(?)	;# bytes to read in octal arg parsing routines
buf_:	dw	1 dup(?)	;ptr into input buf
hlsave:	dw	1 dup(?)	;holds r.a. in OCTAL
cmd__:	dw	1 dup(?)	;ptr to cmd routine, for retries
_arg1:	dw	1 dup(?)	;ptr to 1st arg of cmd
cmcnt:	db	2 dup(?)	;count of commas seen in input line
;;;; I think only the low byte is used
first:	dw	1 dup(?)	;ptr to first char in cmd
chkhlt:	db	2 dup(?)	;NZ => check for halts and print "%HLTD"
;;; only low byte seems to be used?
octsv:	dw	1 dup(?)	;saved ptr to last byte of buf in OCTAL
shrtad:	db	5 dup(?)	;short addr for EXAMSH, DEPSHT (high 3 bytes 0)
rhbase:	db	5 dup(?)	;RHBASE for boot dev
if klinik
cslmod:	db	1 dup(?)	;console mode (_MODE0, _MODE1...)
endif ; klinik
kacntr:	db	1 dup(?)	;keep-alive counter (snapshot of part of loc 31)
if klinik
mmflg:	db	1 dup(?)	;NZ => in manufacturing mode
mailfg:	db	1 dup(?)	;NZ => "envelope" rdy to go out
endif
vercnt:	db	1 dup(?)	;inner loop count in VERCRA
				;(10-word within uword)
ubanum:	db	1 dup(?)	;UBA # of boot device in <3:2>
gocode:	db	1 dup(?)	;start code for KS10 bootstrap
secret:	db	1 dup(?)	;what's this for???
diecnt:	db	1 dup(?)	;# loop counts since keep-alive has incremented
if klinik
cntlq_:	db	1 dup(?)	;0 or ^Q (for MMOUT)
aptans:	db	1 dup(?)	;APT answer packet type
kpwbuf:	db	7 dup(?)	;KLINIK password buf
kpwcnt:	db	1 dup(?)	;KLINIK pw char count
endif
if ver52 ; some kind of bug fix for 1st cmd after forced reload
L20BA:	db	3 dup(?)	;used to doctor bits for CPUCTL port
;;; only low 2 bytes are used
endif
t80dt:	db	2 dup(?)	;temp buffer
if klinik
pwrtry:	db	1 dup(?)	;KLINIK pw retry count
klline:	db	1 dup(?)	;NZ => KLINIK line change to mode 3 allowed
e_cnt:	db	1 dup(?)
endif
crmbf:	db	16d dup(?)	;"RC" buf, overlays CRMTM
				;(also holds unpacked CRAM)
crmtm:	db	16d dup(?)	;CRAM data buf
;;; this is the first loc loaded from PRMLST
katim1:	dw	1 dup(?)	;keep-alive timer
sceadr:	dw	1 dup(?)	;soft CRAM error addr
if klinik
moddis:	dw	1 dup(?)	;ptr to where to call on next KLINIK input chr
endif
norend:	dw	1 dup(?)	;normal end dispatch addr
envpnt:	dw	1 dup(?)	;ptr into envelope
parbt:	db	1 dup(?)	;parity bit flags
trapen:	db	1 dup(?)	;written to port 85h in MRCMD
mtauba:	db	1 dup(?)	;tape UBA # in bits <3:2>
dskuba:	db	1 dup(?)	;disk UBA # in bits <3:2>
state:	db	1 dup(?)	;front panel lights in low 3 bits
				;other bits have meaning too
if klinik
lstmsg:	db	1 dup(?)	;last rcvd msg #
endif
den_sl:	db	5 dup(?)	;density,,slave
				;(copied as word, that's why 5 bytes)

mtbase:	db	5 dup(?)	;tape RHBASE
dsbase:	db	5 dup(?)	;disk RHBASE
rpini:	db	25d dup(?)	;cmd dispatch addrs for RP
rptbfi:	db	50d dup(?)	;RP data buf
bufbg:	db	90d dup(?)	;CTY input buf
bufen:	db	1 dup(?)	;;;; never reffed
e_buf:	dw	1 dup(?)	;ptr into E_BEG
e_beg:	db	140q dup(?)	;"FI" cmd buf
if klinik
envmno:	db	1 dup(?)	;xmt msg #
envchk:	db	1 dup(?)	;envelope checksum (6 bits, +100' if <75')
envbuf:	db	70d dup(?)	;packet buffer ("EB" has longest output, 67.)
sysin:	dw	1 dup(?)	;MMOUT buf empty ptr
sysout:	dw	1 dup(?)	;MMOUT rbuf fill ptr
sysbuf:	db	200q dup(?)	;MMOUT buf
sysend:	db	1 dup(?)	;end of SYSBUF (gets ^@ when buf full)
endif ; klinik
sc_off:	db	1 dup(?)	;NZ => SCE recovery disabled
rhsave:	db	8d*5 dup(?)	;saved UMR #1, RH11C regs during SCE recovery
;
if ($-L0000) gt (ramst+ramsz)
	.err	Overflowed RAM
endif
;
code	ends
	end
