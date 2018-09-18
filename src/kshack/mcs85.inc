;+
;
; Macros to assemble MCS-85 instructions.
;
; By John Wilson.
;
; 08/17/93	JMBW	Created.
;
;-
_b=	0
_c=	1
_d=	2
_e=	3
_h=	4
_l=	5
_m=	6
_a=	7
_sp=	6
_psw=	6
;
ifdef ??version			;;if TASM...
	nowarn	res		;;tell it not to freak out about MOV, JMP etc.
endif
;
; Ignore MNEM, it was supposed to be for switching mnemonics sets on the fly.
;
mnem	macro	cp
;;;ifidn <&cp>,<8085>
	endm
;;;
mov	macro	r1,r2
	db	100q+_&r1*10q+_&r2
	endm
xchg	macro
	db	353q
	endm
push	macro	rp
	db	305q+_&rp*10q
	endm
pop	macro	rp
	db	301q+_&rp*10q
	endm
jmp	macro	dest
	db	303q
	dw	dest
	endm
jc	macro	dest
	db	332q
	dw	dest
	endm
jnc	macro	dest
	db	322q
	dw	dest
	endm
jz	macro	dest
	db	312q
	dw	dest
	endm
jnz	macro	dest
	db	302q
	dw	dest
	endm
jp	macro	dest
	db	362q
	dw	dest
	endm
jm	macro	dest
	db	372q
	dw	dest
	endm
jpe	macro	dest
	db	352q
	dw	dest
	endm
jpo	macro	dest
	db	342q
	dw	dest
	endm
call	macro	dest
	db	315q
	dw	dest
	endm
ret	macro
	db	311q
	endm
in	macro	port
	db	333q,&port
	endm
out	macro	port
	db	323q,&port
	endm
add	macro	r
	db	200q+_&r
	endm
adc	macro	r
	db	210q+_&r
	endm
sub	macro	r
	db	220q+_&r
	endm
sbb	macro	r
	db	230q+_&r
	endm
cmp	macro	r
	db	270q+_&r
	endm
stc	macro
	db	067q
	endm
cmc	macro
	db	077q
	endm
daa	macro
	db	047q
	endm
di	macro
	db	363q
	endm
nop	macro
	db	000q
	endm
;;;else ;; 8086
;;;	purge	mov,xchg,push,pop,jmp,jc,jnc,jz,jnz,jp,jm,jpe,jpo,call,ret
;;;	purge	in,out,add,adc,sub,sbb,cmp,stc,cmc,daa,di,nop,sp
;;;endif
;;;	endm
;
halt	macro
	db	166q
	endm
;
mvi	macro	r,val
	db	006q+_&r*10q,val
	endm
;
lxi	macro	rp,val
	db	001q+_&rp*10q
	dw	val
	endm
;
stax	macro	rp
	db	002q+_&rp*10q
	endm
;
ldax	macro	rp
	db	012q+_&rp*10q
	endm
;
sta	macro	addr
	db	062q
	dw	addr
	endm
;
lda	macro	addr
	db	072q
	dw	addr
	endm
;
shld	macro	addr
	db	042q
	dw	addr
	endm
;
lhld	macro	addr
	db	052q
	dw	addr
	endm
;
xthl	macro
	db	343q
	endm
;
sphl	macro
	db	371q
	endm
;
pchl	macro
	db	351q
	endm
;
cc	macro	dest
	db	334q
	dw	dest
	endm
;
cnc	macro	dest
	db	324q
	dw	dest
	endm
;
cz	macro	dest
	db	314q
	dw	dest
	endm
;
cnz	macro	dest
	db	304q
	dw	dest
	endm
;
cp	macro	dest
	db	364q
	dw	dest
	endm
;
cm	macro	dest
	db	374q
	dw	dest
	endm
;
cpe	macro	dest
	db	354q
	dw	dest
	endm
;
cpo	macro	dest
	db	344q
	dw	dest
	endm
;
rc	macro
	db	330q
	endm
;
rnc	macro
	db	320q
	endm
;
rz	macro
	db	310q
	endm
;
rnz	macro
	db	300q
	endm
;
rp	macro
	db	360q
	endm
;
rm	macro
	db	370q
	endm
;
rpe	macro
	db	350q
	endm
;
rpo	macro
	db	340q
	endm
;
rst	macro	n
	db	307q+&n*10q
	endm
;
inr	macro	r
	db	004q+_&r*10q
	endm
;
dcr	macro	r
	db	005q+_&r*10q
	endm
;
inx	macro	rp
	db	003q+_&rp*10q
	endm
;
dcx	macro	rp
	db	013q+_&rp*10q
	endm
;
adi	macro	n
	db	306q,&n
	endm
;
aci	macro	n
	db	316q,&n
	endm
;
dad	macro	rp
	db	011q+_&rp*10q
	endm
;
sui	macro	n
	db	326q,&n
	endm
;
sbi	macro	n
	db	336q,&n
	endm
;
ana	macro	r
	db	240q+_&r
	endm
;
xra	macro	r
	db	250q+_&r
	endm
;
ora	macro	r
	db	260q+_&r
	endm
;
ani	macro	n
	db	346q,&n
	endm
;
xri	macro	n
	db	356q,&n
	endm
;
ori	macro	n
	db	366q,&n
	endm
;
cpi	macro	n
	db	376q,&n
	endm
;
rlc	macro
	db	007q
	endm
;
rrc	macro
	db	017q
	endm
;
ral	macro
	db	027q
	endm
;
rar	macro
	db	037q
	endm
;
cma	macro
	db	057q
	endm
;
ei	macro
	db	373q
	endm
;
rim	macro
	db	040q
	endm
;
sim	macro
	db	060q
	endm
;
; V-20 8080-mode instructions:
calln	macro	n
	db	355q,355q,&n
	endm
;
retem	macro
	db	355q,375q
	endm
;
; This is a V-20 8086-mode instruction:
intem	macro	n
	db	017q,377q,&n
	endm
;
