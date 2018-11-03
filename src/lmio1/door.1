	TITLE DOOR SERVER

;A chaosnet server which performs useful functions like opening the
;9th floor door to let urchins in to rip off virtually everything in the place.

;Protocol:
;Contact to AI, contact name DOOR, argument is a single character as follows:
;	D - buzz the door
;	8 - send an elevator to the 8th floor
;	9 - send an elevator to the 9th floor

;PDP11 hardware documentation
;764050 is the Unibus register (KMS)
;
;bit 8 - 8th floor elevator
;bit 9 - 9th floor elevator
;	;elevators should be called for 1/3 second
;bit 10 - spare
;bit 11 - 9th floor door
;	;door should be buzzed for 3 seconds
;bit 12 - video hardcopy source 2
;bit 13 - video hardcopy source 1
;	;qopy should be enabled for 21 seconds (but this program doesn't hack it anyway)
;
;Other bits in this register are meaningful and should not be munged,
;but probably don't change while the TV's are running.  So simple
;AND'ing and IOR'ing should be safe.

A=1
B=2
C=3
D=4
E=5
T=6
TT=7
P=17

CHIC=10
CHOC=11

TEN11=100000			;Virtual address mapped into pdp11

DEBUG:	0

PDL:	-20,,.

.INSRT SYSTEM;CHSDEF >

PKTBUF:	BLOCK %CPMXW+%CPKDT

GO:	.CLOSE 1,		;Close load channel
	MOVE P,PDL
	MOVEI T,TSINT
	MOVEM T,42
	.SUSET [.SMASK,,[%PIIOC]]	;Die if IOC error on network
	;Map in via the TEN-11 interface
	MOVEI A,TEN11/2000
	MOVE B,[3_34.+0_26.+<764050/4>_10.+0]	;read/write, pdp-11 #0, 1 word at 764050
	.CALL [ SETZ ? SIXBIT/T11MP/ ? A ? SETZ B ]
	 JSR LOSE
	SETZM PKTBUF
	MOVE T,[PKTBUF,,PKTBUF+1]
	BLT T,PKTBUF+%CPMXW-1	;For extra luck, clear the packet buffer
	MOVSI T,%COLSN_10.
	HRRI T,4_4
	MOVEM T,PKTBUF
	MOVE T,[.BYTE 8 ? "D ? "O ? "O ? "R ]
	MOVEM T,PKTBUF+%CPKDT
	.CALL [ SETZ ? 'CHAOSO ? MOVEI CHIC ? MOVEI CHOC ? SETZI 1 ]
	 JSR LOSE
	.CALL [ SETZ ? 'PKTIOT ? MOVEI CHOC ? SETZI PKTBUF ]	;Listen
	 JSR LOSE
	MOVEI TT,30.*30.	;30-second timeout
	SKIPE DEBUG
	 MOVSI TT,177777	;Or infinite, in debug mode
	MOVEI T,%CSLSN		;Boring state
	.CALL [ SETZ ? 'NETBLK ? MOVEI CHOC ? T ? TT ? SETZM TT ]
	 JSR LOSE
	CAIE TT,%CSRFC		;Should be RFC into LSN
	 JSR LOSE
	.CALL [ SETZ ? 'PKTIOT ? MOVEI CHIC ? SETZI PKTBUF ]	;Get the RFC packet
	 JSR LOSE
	LDB A,[241000,,PKTBUF+%CPKDT+1]	;Get argument character
	PUSHJ P,DOIT		;Process
	 JRST REFUSE		;Not a valid argument, refuse to do it
	MOVEI T,%COANS		;Done, return ANS with nothing in it
	DPB T,[$CPKOP+PKTBUF]
	MOVEI T,0
REFUS2:	DPB T,[$CPKNB+PKTBUF]
	.CALL [ SETZ ? 'PKTIOT ? MOVEI CHOC ? SETZI PKTBUF ]
	 JSR LOSE
	.LOGOUT			;Done

REFUSE:	MOVEI T,%COCLS		;Barf
	DPB T,[$CPKOP+PKTBUF]
	MOVEI T,.LENGTH/Argument no good./
	DPB T,[$CPKNB+PKTBUF]
	MOVEI A,[ASCIZ/Argument no good./]
	HRLI A,440700
	MOVE B,[440800,,PKTBUF+%CPKDT]
	MOVEI T,0
REFUS1:	ILDB TT,A
	JUMPE TT,REFUS2
	IDPB TT,B
	AOJA T,REFUS1

LOSE:	0
	SKIPE DEBUG
	 .VALUE
	.LOGOUT

TSINT:	0 ? 0
	JSR LOSE

DOIT:	AOS (P)			;Usually skip
	CAIN A,"D
	 JRST DOOR
	CAIN A,"8
	 JRST 8TH
	CAIN A,"9
	 JRST 9TH
	SOS (P)			;Fail
	POPJ P,

;Buzz the door by turning on bit 11 for 3 seconds
DOOR:	MOVE T,[<1_11.>_20.]
	MOVEI TT,3*30.
FROBIT:	IORM T,TEN11
	.SLEEP TT,
	ANDCAM T,TEN11
	POPJ P,

;Call the elevator for 1/3 second, bit # = floor #
8TH:	SKIPA T,[<1_8.>_20.]
9TH:	 MOVE T,[<1_9.>_20.]
	MOVEI TT,10.
	JRST FROBIT

END GO
