;;; -*- Mode: Lisp; Base: 8; Package: User; Lowercase:t -*-

;Assemble this with HIC;AS8748 and stuff it into a keyboard with LMIO1;PROMP

;This is the new (11/18/80) version for use with the new keyboard PC,
;which contains a 24-bit shift register for faster transmission to the
;host and provides for running the mouse through the keyboard ("remote mouse"
;in the IOB).

;9/18/81 modified as follows:
;	Check the mouse more often in the keyboard-scanning loop
;	   [Hmm, it's already checking the mouse more often, but
;	    I don't think that change was ever installed.]
;	Feep with a low pitch on powering up, and a higher pitch
;	 after successfully sending a character to the Lisp machine.
;	Time out waiting for the DONE flag.  It can get turned off by
;	 random noise on the clock line if the Lisp machine is powered
;	 off or disconnected; we don't want that to break the keyboard.

(defun complement (x)
  (logxor 377 x))

;;; Hardware documentation

;To read from keyboard, P1<4:1> gets column number, then P1<0> gets 0,
;then read back keys from P2, then P1<1> gets 1 again.

;P1<7> = beeper (pin 5 on the connector)
;P1<6> = write register select bit 0 (pin 3 on the connector)
;P1<5> = write register select bit 1 (pin 1 on the connector)
;T1    = pin 2 on the connector (not used any more)
;
;Reading the data bus returns
;DONE in bit 0 and the mouse in bits 1-7.  DONE is 1 if the shift
;register has been sent off to the host computer.
;
;Writing the data bus writes into
;one of the three bytes of the shift register; write the first byte
;last with a start bit in its low-order bits.  P1<6:5> selects which byte.

;The following are the bit numbers of the keys which are specially
;known about for shifting purposes:
;  mode lock	3
;  caps lock	125
;  alt lock	15
;  repeat	115
;  top		104 / 155
;  greek	44 / 35
;  shift	24 / 25
;  hyper	145 / 175
;  super	5 / 65
;  meta		45 / 165
;  control	20 / 26

; For booting, we know that rubout is 23 and return is 136

;Protocol documentation is at the end of this file

;;; Locations in data memory
(setq bitmap 60)	;60-77 Bit map.  0 if key up, 1 if key down.
(setq bootflag 57)	;Normally 0, non-zero to suppress key-up codes
			; and mouse codes while in boot sequence
(setq mouse 56)		;Last known state of the mouse input lines
(setq init 55)		;Non-zero if have sent a character

;;; Note that we always return the beeper output to 0 when not using it.
;;; This is for convenience in the keyboard-scanning loop, since it's
;;; on the same port.

;;; Program
(putprop 'ukbd '(
	(= 0)
	(jmp beg)
	(= 1)	;Table of magic constants for keyboard scanner
	001 003 005 007 011 013 015 017
	021 023 025 027 031 033 035 037

	(= 100)		;Why location 100?
beg	(mov a (/# 377))
	(outl p1 a)			;Mainly turn off data out
	(outl p2 a)			;Enable input
	(mov r0 (/# 40))		;Clear all memory above location 40,
	(mov r1 (/# 40))		; especially the bitmap
	(clr a)
clear-bitmap-loop
	(mov @r0 a)
	(inc r0)
	(djnz r1 clear-bitmap-loop)
	(mov r0 (/# 8))			;Wait 3 seconds after powering up
power-up-delay-1
	(mov r1 (/# 0))			;Delay 400 ms
power-up-delay-2
	(mov r2 (/# 0))			;Delay 1.5 ms
power-up-delay-3
	(djnz r2 power-up-delay-3)
	(djnz r1 power-up-delay-2)
	(djnz r0 power-up-delay-1)
	(mov r0 (/# 24.))		;Give medium pitched feep
	(mov r1 (/# 100.))		;for 1/3 second
	(call feep)
its-all-up				;Send all-up code to initialize the
	(call send-all-up-code)		; shift register in the Lisp machine
	(mov r0 (/# init))		;Initialized yet?
	(mov a @r0)
	(jnz scan-keyboard)		;Yes
	(call await-done)		;Wait for response from Lisp machine
	(ins a bus)			;A<0>=DONE
	(rrc a)				;C=DONE
	(jnc scan-keyboard)		;await-done timed out
	(mov r0 (/# init))		;Success, set initialized flag
	(mov @r0 (/# 1))
	(mov r0 (/# 8))			;Then give high-pitched feep
	(mov r1 (/# 250.))		;For 1/4 second
	(call feep)			;and drop into scan-keyboard

;Scanning Loop.
;R2 is bitmap index in bytes, plus 1
;R1 points to previous mouse status
;R0 is address of bitmap byte that goes with R2

scan-keyboard
	(mov r2 (/# 20))		;Loop counter and index
	(mov r1 (/# mouse))		;Addressibility
	(mov r0 (/# (+ bitmap 17)))	;Address of bitmap byte
scan-loop
	(ins a bus)			;Get mouse status
	(anl a (/# (complement 1)))	;Clear done bit
	(xrl a @r1)			;Has mouse status changed?
	(jnz scan-mouse)		;Yes, punt keyboard and go send mouse char
	(mov a r2)
	(movp a @a)			;A<4:1>  R2-1, A<0>  1
	(outl p1 a)			;Select row and disable decoder
	(anl p1 (/# (complement 1)))	;Strobe the decoder (why?)
	(in a p2)			;Get row of keys
	(xrl a @r0)			;A  changed bits
	(jnz scan-found)		;Jump if key state changed
	(dec r0)
	(djnz r2 scan-loop)
	(jmp scan-keyboard)		;Nothing happening, idle.

scan-mouse
	(xrl a @r1)			;Restore from xor above
	(mov @r1 a)			;Update previous-mouse-state
	(xrl a (/# 340))		;Compensate for hardware bug--buttons complemented
	(mov r2 a)			;Arg for send
	(mov r3 (/# 0))
	(mov r4 (/# 176_1))		;Source ID 6 (mouse)
	(mov r0 (/# bootflag))		;Don't send if in boot sequence
	(mov a @r0)
	(jnz scan-keyboard)
	(call send)
	(jmp scan-keyboard)

;R0 address of bit map entry
;R2 bit number
;R3 changed bits
;R4 bit mask
scan-found
	(mov r3 a)
	(mov r4 (/# 1))
	(mov a r2)			;Bit number is byte number times 8
	(dec a)
	(rl a)
	(rl a)
	(rl a)
	(mov r2 a)
scan-bits-loop
	(mov a r4)
	(anl a r3)
	(jnz scan-found-key)
	(inc r2)
	(mov a r4)			;Shift left one bit, A  0 when done
	(add a r4)
	(mov r4 a)
	(jnz scan-bits-loop)
	(jmp scan-keyboard)		;wtf? should have found something

scan-found-key
	(mov a r2)			;Shift r2 left 1
	(add a r2)
	(mov r2 a)
	(mov a r4)			;Bit mask
	(xrl a @r0)			;Change bitmap bit
	(mov @r0 a)			;Put back in bitmap
	(anl a r4)			;0 if key now up, non-0 if key now down
	(mov r3 (/# 0))			;Assume key down
	(jnz scan-found-key-down)
	(mov r3 (/# 2))			;Key up, middle byte is 1
	;; If booting, don't send key-up codes
	(mov r1 (/# bootflag))
	(mov a @r1)
	(jnz scan-keyboard)
	;; If this is a shifting key, don't send all-keys-up, send this-key-up.
	;; This is so that with paired shifting keys we know which it is.
	(mov a r0)
	(add a (/# (- 200 bitmap)))	;Point to mask of non-shifting keys
	(movp3 a @a)
	(anl a r4)			;A gets bit from table (0 => shifting)
	(jz scan-found-key-down)	;Shifting => don't send all-keys-up
	;; Look through the bit map and see if all non-shifting keys are now
	;; up.  If so, send an all-keys-up instead.
	(mov r0 (/# bitmap))
	(mov r1 (/# 200))		;P3 table at 1600
	(mov r4 (/# 20))
check-for-all-up
	(mov a r1)
	(movp3 a @a)
	(anl a @r0)
	(jnz scan-found-key-down)
	(inc r0)
	(inc r1)
	(djnz r4 check-for-all-up)
	(call await-done)
	(jmp its-all-up)

scan-found-key-down
	(mov r4 (/# 171_1))		;Source ID 1 (new keyboard)
	(call send)			;Transmit character
	(call check-boot)		;See if request to boot machine
	(jmp scan-keyboard)

;Subroutine to transmit like old-type Knight keyboard (using new shift reg hardware)
;Send a 24-bit character from R2, R3, R4
;But note that it's all shifted left 1 bit.  R2<0> must be zero,
;it's the start-bit.
send	(call await-done)
send1	(orl p1 (/# 140))		;P1<5:6>=3
	(mov a r4)
	(outl bus a)
	(anl p1 (/# 277))		;P1<5:6>=2
	(mov a r3)
	(outl bus a)
	(anl p1 (/# 337))		;P1<5:6>=1
	(orl p1 (/# 100))
	(mov a r2)
	(outl bus a)
	(ret)


	(= 400)
;Send all-up key-code.  NOTE that this does not wait for DONE.
;This works by checking through the bitmap looking for shift keys
;that are down, and OR'ing in the bits.
send-all-up-code
	(clr a)				;Cannot clear registers directly
	(mov r2 a)			;Start with no bits set
	(mov r3 a)
	(mov r5 a)			;R5 address in P3
	(mov r0 (/# bitmap))		;R0 address in bitmap
cauc-0	(mov r4 (/# 1))			;R4 bit mask
cauc-1	(mov a r5)
	(movp3 a @a)			;Get table entry
	(jb7 cauc-9)			;Jump if this key not a shifter
	(mov r6 a)			;Save bit number
	(mov a r4)			;Check bit in bit map
	(anl a @r0)
	(jz cauc-9)			;Key not pressed
	(mov a r6)			;See if bit number 7 or more
	(add a (/# -7))
	(jb7 cauc-4)			;Jump if less than 7
	(mov r6 a)			;Save bitnumber within middle byte
	(call cauc-sh)
	(orl a r3)
	(mov r3 a)
	(jmp cauc-9)

cauc-4	(inc r6)
	(call cauc-sh)
	(orl a r2)
	(mov r2 a)
;Done with this key, step to next
cauc-9	(inc r5)			;Advance P3 address
	(mov a r4)			;Shift bit mask left 1
	(add a r4)
	(mov r4 a)
	(jnz cauc-1)			;Jump if more bits this word
	(inc r0)			;Advance bitmap address
	(mov a r0)			;See if done
	(add a (/# (- (+ bitmap 20))))
	(jnz cauc-0)			;Jump if more words in bitmap
	(mov r4 (/# 363))		;Source ID 1, bit 15 on
	(jmp send1)			;Send it and return

;Produce in A a bit shifted left by amount in R6
cauc-sh	(inc r6)			;Compensate for DJNZ
	(mov a (/# 200))
cauc-sh-1
	(rl a)
	(djnz r6 cauc-sh-1)
	(ret)

;Is request to boot machine if both controls and both metas are held
;down, along with rubout or return.  We have just sent the key-down codes
;for all of those keys.  We now send a boot character, then set a flag preventing
;sending of up-codes until the next down-code.  This gives the machine time
;to load microcode and read the character to see whether
;it is a warm or cold boot, before sending any other characters, such as up-codes.
;  meta		45 / 165
;  control	20 / 26
;  rubout	23
;  return	136
; The locking keys are in bytes 1, 3, and 12, conveniently out of the way
;A boot code:
;  15-10	1
;  9-6		0
;  5-0		46 (octal) if cold, 62 (octal) if warm.

check-boot
	(mov r1 (/# bootflag))		;Establish addressibility for later
	(mov r0 (/# 64))		;Check one meta key
	(mov a @r0)
	(xrl a (/# 1_5))
	(jnz not-boot)
	(mov r0 (/# 76))		;Check other meta key
	(mov a @r0)
	(xrl a (/# 1_5))
	(jnz not-boot)
	(mov r0 (/# 62))		;Check byte containing controls and rubout
	(mov a @r0)
	(xrl a (/# (+ 1_0 1_6 1_3)))
	(jz cold-boot)			;Both controls and rubout => cold-boot
	(xrl a (/# 1_3))
	(jnz not-boot)
	(mov r0 (/# 73))		;Check for return
	(mov a @r0)
	(xrl a (/# 1_6))
	(jnz not-boot)
warm-boot
	(mov r2 (/# 62_1))
	(jmp send-boot)

cold-boot
	(mov r2 (/# 46_1))
send-boot
	(mov r3 (/# 174_1))		;1's in bits 14-10
	(mov r4 (/# 363))		;Source ID 1 (new keyboard), 1 in bit 15
	(mov @r1 (/# 377))		;Set bootflag
	(jmp send)			;Transmit character and return

not-boot
	(mov @r1 (/# 0))		;Clear bootflag
	(ret)

;Wait for PC board to say that it is done shifting out previous character
;This will time out after 1 second
;Bashes R0, R1, A
await-done
	(mov r0 (/# 0))
await-done-1
	(mov r1 (/# 0))
await-done-2
	(ins a bus)			;A<0>=DONE
	(rrc a)				;C=DONE
	(jnc await-done-3)		;Not DONE yet
	(ret)

await-done-3
	(djnz r1 await-done-2)
	(djnz r0 await-done-1)
	(ret)				;timeout

;Feep routine.  R0 is the half-period in units of 100 microseconds.
;R1 is the number of cycles to do.
feep	(orl p1 (/# 200))		;Cycle feeper
	(call feep-delay)
	(anl p1 (/# (complement 200)))
	(call feep-delay)
	(djnz r1 feep)
	(ret)

feep-delay
	(mov a r0)
	(mov r2 a)
feep-1	(mov r3 (/# 15.))		;djnz takes 6+ microseconds
feep-2	(djnz r3 feep-2)
	(djnz r2 feep-1)
	(ret)

;In P3 (1400-1577) we have a table, indexed by key number, of shifting
;keys.  The byte is 200 for ordinary keys, or the bit number in the
;all-keys-up message for locking and shifting keys.
	(= 1400)
	200	;0
	200
	200
	9.	;3 mode lock
	200
	6.	;5 super
	200
	200

	200	;10
	200
	200
	200
	200
	8.	;15 alt lock
	200
	200

	4.	;20 control
	200
	200
	200
	0.	;24 shift
	0.	;25 shift
	4.	;26 control
	200

	200	;30
	200
	200
	200
	200
	1.	;35 greek
	200
	200

	200	;40
	200
	200
	200
	1.	;44 greek
	5.	;45 meta
	200
	200

	200	;50
	200
	200
	200
	200
	200
	200
	200

	200	;60
	200
	200
	200
	200
	6.	;65 super
	200
	200

	200	;70
	200
	200
	200
	200
	200
	200
	200

	200	;100
	200
	200
	200
	2.	;104 top
	200
	200
	200

	200	;110
	200
	200
	200
	200
	10.	;115 repeat
	200
	200

	200	;120
	200
	200
	200
	200
	3.	;125 caps lock
	200
	200

	200	;130
	200
	200
	200
	200
	200
	200
	200

	200	;140
	200
	200
	200
	200
	7.	;145 hyper
	200
	200

	200	;150
	200
	200
	200
	200
	2.	;155 top
	200
	200

	200	;160
	200
	200
	200
	200
	5.	;165 meta
	200
	200

	200	;170
	200
	200
	200
	200
	7.	;175 hyper
	200
	200

	(= 1600)
;Locations 1600-1617 contain a mask which has 1's for bit-map positions
;which contain non-shifting keys.
	327	;3 and 5
	337	;15
	216	;20, 24, 25, 26
	337	;35
	317	;44, 45
	377
	337	;65
	377	;70
	357	;104
	337	;115
	337	;125
	377
	337	;145
	337	;155
	337	;165
	337	;175

	)
'code)

;These don't work any more:
;;Look at kbd and print out any characters that come in
;(defun test ()
;  (let ((tv-more-processing-global-enable nil))
;     (do ((ch)) (nil)
;       (process-allow-schedule)
;       (and (setq ch (si:kbd-tyi-raw-no-hang))
;	    (print (ldb 0027 ch))))))
;
;;This version isn't stoppable, because it just gets it right out of the hardware
;;Prevents you from getting screwed by call-processing and the like.
;(defun supertest ()
;  (let ((tv-more-processing-global-enable nil))
;     (do ((ch)) (nil)
;       (or si:kbd-buffer (si:kbd-get-hardware-char-if-any))
;       (and si:kbd-buffer
;	    (progn (setq ch si:kbd-buffer si:kbd-buffer nil)
;		   (print (ldb 0027 ch)))))))

;;; Protocol documentation

; Protocol for new keyboards  -- 9/27/79
;
; Present hardware character format conventions:
;
; A character is 24 bits, sent low-order bit first.  There is also
; a "start bit" or "request signal", which is low.  Bits appear
; on the cable in true-high form.  The cable is high when idle.
; The clock is high when idle, and the falling edge is the clock
; in the central machine.  The leading edge (check this) is the
; clock in the keyboard.
;
; The old (Knight) keyboards send 1's for the high 9 bits.
;
; Bit 16 is normally 1, 0 for the "remote mouse" which the IOB
; claims to support.  Whether the IOB
; hardware actually looks at this bit is under program control.
;
; The IOB boots the lisp machine if a character is received with
; bits 10-13 = 1, bits 6-9 = 0, and bit 16 = 1 (bit 16 may or may
; not be looked at depending on remote mouse enable.)   The low 6
; bits control whether it is a warm or cold boot.
;
; Here is the new standard character format:
; 	15-0	Information
; 	18-16	Source ID
; 	23-19	Reserved, must be 1's.
;
; The following source ID's are defined:
; 	111	Old keyboard, information is as follows:
; 		5-0	keycode
; 		7-6	shift
; 		9-8	top
; 		11-10	control
; 		13-12	meta
; 		14	shift-lock
; 		15	unused
; 	110	IOB's "remote mouse", this also uses up codes 000, 010, 100
; 		Low bits are the input lines from the mouse
; 	101	Reserved.
; 	001	New keyboard, information as follows:
; 		An up-down code:
; 		15	0 (indicates up-down code)
; 		14	0 (reserved for expansion of codes)
; 		13	0 (so it doesn't look like a boot)
; 		12-9	0 (reserved for expansion)
; 		8	1=key up, 0=key down
; 		7	0 (reserved for expansion of keys)
; 		6-0	keycode (not same codes as old keyboards)
;
; 		An all-keys-up:  (This is sent when a key-up code would be sent but
; 			now no keys other than shifting and/or locking keys are
; 			down. This ensures that the status of the shifting keys,
; 			especially the locking ones, does not get out of phase.
; 			A 1 is sent for each special key that is currently down.)
; 		15	1 (indicates not an up-down code)
; 		14	0 (reserved for expansion of codes)
; 		13	0 (so it doesn't look like a boot)
; 		12	0 (reserved for expansion of keys)
; 		11	0 (reserved for expansion of keys)
; 		10	Repeat
; 		9	Mode lock
; 		8	Alt lock
; 		7	Hyper (either one)
; 		6	Super (either one)
; 		5	Meta (either one)
; 		4	Control (either one)
; 		3	Caps lock
; 		2	Top (either one)
; 		1	Greek (either one)
; 		0	Shift (either one)
;
; 		A boot code:
; 		15-10	1
; 		9-6	0
; 		5-0	46 (octal) if cold, 62 (octal) if warm.
;
; 		All key-encoding, including hacking of shifts, will be done
; 		in software in the central machine, not in the keyboard.  Note
; 		that both pressing and releasing a key send a code, therefore
; 		the central machine knows the status of all keys.  If the machine
; 		somehow gets out of phase, the next time the user presses and releases
; 		a key an all-keys-up message will be sent, getting it back into phase.
;
; 		Note that after sending a boot the keyboard must not
; 		send any more characters (such as up-codes) until
; 		another key is depressed, or the keyboard buffer
; 		in the IOB would forget the type of boot.
;
; 	011	Mouse attached via new keyboard.  Information as follows:
; 		[This won't be implemented soon; it's not what this program does.]
; 		5-0	Delta-X, 2's complement
; 		11-6	Delta-Y, 2's complement
; 		12	0.  Prevents accidental booting.
; 		15-13	Current status of buttons.
; 		Every time the mouse moves or the button status changes,
; 		a mouse character is sent, except that there is a minimum
; 		delay between mouse characters of probably 1/30th or 1/40th
; 		second.  Between characters the keyboard tracks motion of
; 		the mouse.  These mouse characters will not be processed
; 		by hardware in the IOB.  They will probably be processed
; 		by the CADR microcode interrupt handler.
