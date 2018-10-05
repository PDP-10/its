;;; -*- Mode: LISP;  Package: USER; Ibase: 8; Base: 8 -*-

;;; Assemble for 8x48 series of microprocessors

(declare (special as-pc as-labels as-assignments as-pass as-must-be-assigned as-form as-code
		  as-known-new-pc))

(defun as-init ()
  (setq as-pc 0
	as-must-be-assigned (eq as-pass 'PASS-2)
	as-code (ncons (list '= '0))
	as-known-new-pc nil)
  (selectq as-pass
    (PASS-1 (setq as-labels nil
		  as-assignments nil))))

(defun as-pass-1 (forms &aux (as-pass 'PASS-1))
  (as-init)
  (mapc 'as-compile-form forms))

(defun as-pass-2 (forms &aux (as-pass 'PASS-2))
  (as-init)
  (mapc 'as-compile-form forms))

(defun as-internal (forms)
  (as-pass-1 forms)
  (as-pass-2 forms)
  (nreverse as-code))

(defun as (program &aux as-code)
  (setq as-code (as-internal (or (get program 'code)
				 (ferror nil "~A is not a defined program" program))))
  (putprop program as-code 'assembled-code)
  (set program (as-convert-to-prom-image as-code))
  (putprop program program 'USER:LOCATION)
  program)

(defun as-convert-to-prom-image (code)
  (let ((pc -1)
	(high -1)
	(array))
    ;; Calculate highest address used
    (dolist (elt code)
      (cond ((and (listp elt)
		  (eq (car elt) '=))
	     (setq pc (cadr elt)))
	    (t (setq pc (1+ pc))))
      (and (> pc high)
	   (setq high pc)))
    (setq array (make-array nil 'art-q (1+ high)))
    (fillarray array '(0))
    (setq pc -1)
    (dolist (elt code)
      (cond ((and (listp elt)
		  (eq (car elt) '=))
	     (setq pc (cadr elt)))
	    (t (aset elt array pc)
	       (setq pc (1+ pc)))))
    array))

(defun as-generate-8-bits (value)
  (setq as-pc (1+ as-pc))
  (and (eq as-pass 'PASS-2)
       (setq as-code (cons (logand value 377) as-code))))

(defun as-compile-form (as-form)
  (setq as-known-new-pc nil)
  (*catch 'AS-ERROR
    (cond ((symbolp as-form)
	   (selectq as-pass
	     (PASS-1 (and (assq as-form as-labels)
			  (as-error "Duplicate label ~A" as-form))
		     (push (cons as-form as-pc) as-labels))
	     (PASS-2 (let ((label (assq as-form as-labels)))
		       (or label
			   (as-error "Label ~A seen on Pass 2 but not on Pass 1" as-form))
		       (or (= (cdr label) as-pc)
			   (as-error "Phase error: Label ~A, Old PC=~O, New PC=~O"
				     as-form (cdr label) as-pc))))))
	  ((listp as-form)
	   (let ((dispatch (get (car as-form) 'AS-DISPATCH)))
	     (cond (dispatch (funcall dispatch as-form))
		   (( (length as-form) 1)
		    (as-error "Undefined operation in form ~A" as-form))
		   (t (as-generate-8-bits (as-hack-expression (car as-form)))))))
	  ((numberp as-form)
	   (as-generate-8-bits as-form))
	  ((as-error "Garbage form")))))

(do ((r '(R0 R1 R2 R3 R4 R5 R6 R7) (cdr r))
     (n 0 (1+ n)))
    ((null r))
  (putprop (car r) `(REGISTER ,n) 'AS-REGISTER))

(putprop '@R0 '(REGISTER-INDIRECT 0) 'AS-REGISTER)
(putprop '@R1 '(REGISTER-INDIRECT 1) 'AS-REGISTER)

(defun as-parse-arg (arg)
  (prog (tem)
    (cond ((numberp arg) (return arg 'ADDRESS))
	  ((symbolp arg)
	   (cond ((setq tem (get arg 'AS-REGISTER))
		  (return (cadr tem) (car tem)))
		 ((eq arg 'A) (return 'A 'A))
		 ((eq arg 'T) (return 'T 'T))
		 ((eq arg 'PSW) (return 'PSW 'PSW))
		 (t (return (as-hack-expression arg) 'ADDRESS))))
	  ((listp arg)
	   (cond ((eq (car arg) '/#)
		  (setq as-known-new-pc (+ as-pc 2))
		  (return (as-hack-expression (cadr arg)) 'IMMEDIATE))
		 (t (return (as-hack-expression arg) 'ADDRESS))))
	  (t (as-error "~A is illegal arg" arg)))))

(defun as-error (error-string &rest args)
  (lexpr-funcall #'format t error-string args)
  (format t " while assembling ~A~%" as-form)
  (and as-known-new-pc (setq as-pc as-known-new-pc))
  (*throw 'AS-ERROR nil))


;;; "Pseduo-ops"
(defun as-set-pc (form &aux (old-pc as-pc))
  (setq as-pc (as-hack-expression (cadr form)))
  (and (eq as-pass 'PASS-2)
       (setq as-code (cons `(= ,as-pc) as-code))))


;;; Standard forms
(defun as-arithmetic (form)
  (as-generate-8-bits (as-hack-expression form)))

(defun as-hack-expression (form)
  (cond ((symbolp form)
	 (or (and (eq form 'pc) as-pc)
	     (cdr (assq form as-labels))
	     (cdr (assq form as-assignments))
	     (and (boundp form) (symeval form))
	     (and as-must-be-assigned
		  (as-error "~A is undefined" form))
	     1))
	((numberp form) form)
	(t (apply (car form) (mapcar #'as-hack-expression (cdr form))))))

;;; ADD and ADDC instructions
(defun as-add (form &aux (addc-flag (cond ((eq (car form) 'ADDC) 20)
					  (t 0))))
  (or (eq (cadr form) 'A)
      (as-error "~A has ~A, not A, as first operand" (car form) (cadr form)))
  (let ((value) (flag))
    (multiple-value (value flag)
      (as-parse-arg (caddr form)))
    (selectq flag
      (IMMEDIATE
       (as-generate-8-bits (logior 003 addc-flag))
       (as-generate-8-bits value))
      (REGISTER-INDIRECT
       (as-generate-8-bits (logior 140 addc-flag value)))
      (REGISTER
       (as-generate-8-bits (logior 150 addc-flag value)))
      (OTHERWISE (as-error "~A is illegal type argument to ~A" (caddr form) (car form))))))

;;; Conditional jumps (not JMP, JMPP, DJNZ)
(defun as-conditional-jump-class (form &aux value flag)
  (setq as-known-new-pc (+ 2 as-pc))		;We will always generate two bytes
  (multiple-value (value flag)
    (as-parse-arg (cadr form)))
  (selectq flag
    (ADDRESS
     (or (eq as-pass 'PASS-1)
         (= (logior (1+ as-pc) 377) (logior value 377))
	 (as-error "~A is off page address" (cadr form)))
     (as-generate-8-bits (get (car form) 'as-jump-instruction))
     (as-generate-8-bits value))
    (OTHERWISE (as-error "~A is illegal type argument to ~A" (cadr form) (car form)))))

(defun as-JMP (form &aux value flag)
  (setq as-known-new-pc (+ 2 as-pc))		;We will always generate two bytes
  (multiple-value (value flag)
    (as-parse-arg (cadr form)))
  (selectq flag
    (ADDRESS
     (as-generate-8-bits (logior 004 (lsh (ldb 1003 value) 5)))
     (as-generate-8-bits value))
    (OTHERWISE (as-error "~A is illegal type argument to ~A" (cadr form) (car form)))))

(defun as-JMPP (form)
  (setq as-known-new-pc (+ 1 as-pc))		;We will always generate one byte
  (or (eq (cadr form) '@A)
      (as-error "Illegal arg (~A) to JMPP" (cadr form)))
  (as-generate-8-bits 263))

(defun as-DJNZ (form &aux value flag)
  (setq as-known-new-pc (+ 2 as-pc))		;We will always generate two bytes
  (multiple-value (value flag)
    (as-parse-arg (cadr form)))
  (selectq flag
    (REGISTER
     (let ((reg value))
       (multiple-value (value flag)
	 (as-parse-arg (caddr form)))
       (selectq flag
	 (ADDRESS
	  (or (eq as-pass 'PASS-1)
	      (= (logior as-pc 377) (logior value 377))
	      (as-error "~A is off page address" (caddr form)))
	  (as-generate-8-bits (logior 350 reg))
	  (as-generate-8-bits value))
	 (OTHERWISE (as-error "~A is illegal type argument to ~A" (caddr form) (car form))))))
    (OTHERWISE (as-error "~A is illegal type argument to ~A" (cadr form) (car form)))))

(defun as-INC (form &aux flag value)
  (cond ((eq (cadr form) 'A)
	 (as-generate-8-bits 27))
	(t (multiple-value (value flag)
	     (as-parse-arg (cadr form)))
	   (cond ((eq flag 'REGISTER)
		  (as-generate-8-bits (logior value 30)))
		 ((eq flag 'REGISTER-INDIRECT)
		  (as-generate-8-bits (logior value 20)))
		 (t (as-error "~A is illegal arg to INC" (cadr form)))))))

(defun as-DEC (form &aux flag value)
  (cond ((eq (cadr form) 'A)
	 (as-generate-8-bits 7))
	(t (multiple-value (value flag)
	     (as-parse-arg (cadr form)))
	   (cond ((eq flag 'REGISTER)
		  (as-generate-8-bits (logior value 310)))
		 (t (as-error "~A is illegal arg to DEC" (cadr form)))))))

(defun as-OUTL (form)
    (or (eq (caddr form) 'A)
	(as-error "Second arg to OUTL must be A, not ~A" (caddr form)))
    (as-generate-8-bits (selectq (cadr form)
			  (BUS 2)
			  (P1  71)
			  (P2  72)
			  (otherwise (as-error "First arg to OUTL must be BUS, P1, or P2")))))

(defun as-IN (form)
  (as-generate-8-bits
    (cond ((equal form '(INS A BUS)) 010)
	  ((equal form '(IN A P1)) 011)
	  ((equal form '(IN A P2)) 012)
	  (t (as-error "IN//INS illegal args")))))

(defun as-logical-class (form &aux value flag
			           (base-ins (get (car form) 'AS-LOGICAL-INSTRUCTION)))
  (cond ((and (memq (car form) '(ANL ORL))
	      (memq (cadr form) '(BUS P1 P2)))
	 (multiple-value (value flag)
	   (as-parse-arg (caddr form)))
	 (or (eq flag 'IMMEDIATE)
	     (as-error "Second arg to ~A is ~A, but must be immediate"
		       (car form) (caddr form)))
	 (as-generate-8-bits (+ base-ins
				(selectq (cadr form)
				  (BUS 110)
				  (P1 111)
				  (P2 112))))
	 (as-generate-8-bits value))
	(t (or (eq (cadr form) 'A)
	       (as-error "First arg to ~A is ~A, but must be A" (car form) (cadr form)))
	   (multiple-value (value flag)
	     (as-parse-arg (caddr form)))
	   (as-generate-8-bits (+ base-ins
				  (selectq flag
				    (REGISTER-INDIRECT value)
				    (REGISTER (logior value 10))
				    (IMMEDIATE 3)
				    (OTHERWISE
				     (as-error "~A is illegal third arg to ~A"
					       (caddr form) (car form))))))
	   (and (eq flag 'IMMEDIATE)
		(as-generate-8-bits value)))))


(defun as-mov (form &aux arg1-value arg1-flag arg2-value arg2-flag)
  (multiple-value (arg1-value arg1-flag)
    (as-parse-arg (cadr form)))
  (multiple-value (arg2-value arg2-flag)
    (as-parse-arg (caddr form)))
  (as-generate-8-bits
   (selectq arg1-flag
     (A (selectq arg2-flag
	  (IMMEDIATE 43)
	  (PSW 307)
	  (REGISTER (logior 370 arg2-value))
	  (REGISTER-INDIRECT (logior 360 arg2-value))
	  ((T) 102)
	  (OTHERWISE (as-mov-arg2-err form))))
     (PSW (cond ((eq arg2-flag 'A) 327)
		(t (as-mov-arg2-err form))))
     (REGISTER
      (selectq arg2-flag
	(A (logior 250 arg1-value))
	(IMMEDIATE (logior 270 arg1-value))
	(OTHERWISE (as-mov-arg2-err form))))
     (REGISTER-INDIRECT
      (selectq arg2-flag
	(A (logior 240 arg1-value))
	(IMMEDIATE (logior 260 arg1-value))
	(OTHERWISE (as-mov-arg2-err form))))
     ((T) (cond ((eq arg2-flag 'A) 142)
		(t (as-mov-arg2-err form))))
     (OTHERWISE (as-error "~A is illegal first arg to MOV" (cadr form)))))
  (cond ((eq arg1-flag 'IMMEDIATE)
	 (as-generate-8-bits arg1-value))
	((eq arg2-flag 'IMMEDIATE)
	 (as-generate-8-bits arg2-value))))

(defun as-mov-arg2-err (form)
  (as-error "Illegal second arg ~A for first arg ~A to MOV" (caddr form) (cadr form)))

(defun as-MOVX (form &aux value flag)
  (cond ((eq (cadr form) 'A)
	 (multiple-value (value flag)
	   (as-parse-arg (caddr form)))
	 (or (eq flag 'REGISTER-INDIRECT)
	     (as-error "Illegal MOVX"))
	 (as-generate-8-bits (logior 200 value)))
	((eq (caddr form) 'A)
	 (multiple-value (value flag)
	   (as-parse-arg (cadr form)))
	 (or (eq flag 'REGISTER-INDIRECT)
	     (as-error "Illegal MOVX"))
	 (as-generate-8-bits (logior 220 value)))
	(t (as-error "Illegal MOVX"))))


(defun as-MOVP (form)
  (or (equal (cdr form) '(a @a))
      (as-error "Illegal args (~A,~A) to MOVP" (cadr form) (caddr form)))
  (as-generate-8-bits 243))


(defun as-MOVP3 (form)
  (or (equal (cdr form) '(a @a))
      (as-error "Illegal args (~A,~A) to MOVP3" (cadr form) (caddr form)))
  (as-generate-8-bits 343))

(defun as-CLR (form)
  (as-generate-8-bits
   (selectq (cadr form)
     (A 47)
     (C 227)
     (F0 205)
     (F1 245)
     (OTHERWISE (as-error "Illegal arg ~A to CLR" (cadr form))))))

(defun as-CALL (form &aux value flag)
  (setq as-known-new-pc (+ 2 as-pc))
  (multiple-value (value flag)
    (as-parse-arg (cadr form)))
  (selectq flag
    (ADDRESS
     (as-generate-8-bits (logior 024 (lsh (ldb 1003 value) 5)))
     (as-generate-8-bits value))
    (OTHERWISE (as-error "~A is illegal type argument to ~A" (cadr form) (car form)))))

(defun as-RET (form)
  (as-generate-8-bits 203))

(defun as-RETR (form)
  (as-generate-8-bits 223))

(defun as-NOP (form)
  (as-generate-8-bits 0))

(defun as-EN (form)
  (selectq (cadr FORM)
    (I (as-generate-8-bits 005))
    (TCNTI (as-generate-8-bits 045))
    (T0 (or (eq (caddr form) 'CLK)
	    (as-error "Illegal third arg to EN -- ~A" (caddr form)))
	(as-generate-8-bits 165))
    (OTHERWISE (as-error "Illegal arg, ~A, to EN" (cadr form)))))

(defun as-DIS (form)
  (selectq (cadr form)
    (I (as-generate-8-bits 025))
    (TCNTI (as-generate-8-bits 065))
    (OTHERWISE (as-error "Illegal arg, ~A, to DIS" (cadr form))))) 

(defun as-SWAP (form)
  (as-generate-8-bits 087))

(defun as-XCH (form &aux value flag)
  (or (eq (cadr form) 'A)
      (as-error "First arg to XCH is ~A, not A" (cadr form)))
  (multiple-value (value flag)
    (as-parse-arg (caddr form)))
  (selectq flag
    (REGISTER (as-generate-8-bits (logior 050 value)))
    (REGISTER-INDIRECT (as-generate-8-bits (logior 040 value)))
    (OTHERWISE (as-error "~A is illegal second arg to XCH" (caddr form)))))

(defun as-rotate (form)
  (or (eq (cadr form) 'A)
      (as-error "Illegal arg ~A to ~A" (cadr form) (car form)))
  (as-generate-8-bits (selectq (car form)
			(RL 347)
			(RR 167)
			(RLC 367)
			(RRC 147))))

(defun as-CPL (form)
  (as-generate-8-bits
    (selectq (cadr form)
      (A 067)
      (C 247)
      (F0 225)
      (F1 265)
      (OTHERWISE (as-error "Illegal arg to CPL, ~A" (cadr form))))))

(defun as-STRT (form)
  (as-generate-8-bits
    (selectq (cadr form)
      ((T) 125)
      (CNT 105)
      (OTHERWISE (as-error "Illegal arg to STRT, ~A" (cadr form))))))

(defun as-STOP (form)
  (or (eq (cadr form) 'TCNT)
      (as-error "Illegal arg to STOP, ~A" (cadr form)))
  (as-generate-8-bits 145))

(defun as-SEL (form)
  (as-generate-8-bits (cond ((equal form '(SEL RB0)) 305)
			    ((equal form '(SEL RB1)) 325)
			    (t (as-error "Illegal format for SEL")))))

;;; Known operations
(defmacro as-ops (&rest type-op-list)
  `(dolist (x ',type-op-list)
     (dolist (y (cdr x))
       (putprop y (car x) 'AS-DISPATCH))))

(as-ops (as-set-pc =))

(as-ops (as-arithmetic + - // * \ \\ LSH ASH ^))

(as-ops (as-add ADD ADDC))

(as-ops (as-conditional-jump-class
	 JB0 JB1 JB2 JB3 JB4 JB5 JB6 JB7
	 JC JNC JF0 JF1 JZ JNZ 
	 JTF JT0 JT1 JNT0 JNT1 JNI JNIBF JOBF))

(dolist (j '((JB0 022) (JB1 62) (JB2 122) (JB3 162) (JB4 222) (JB5 262) (JB6 322) (JB7 362)
	     (JC 366) (JNC 346) (JF0 266) (JF1 166) (JNI 206) (JNIBF 326) (JZ 306) (JNZ 226)
	     (JOBF 206) (JTF 026) (JT0 066) (JNT0 046) (JT1 126) (JNT1 106)))
  (putprop (car j) (cadr j) 'AS-JUMP-INSTRUCTION))

(as-ops (as-JMP JMP)
	(as-JMPP JMPP)
	(as-DJNZ DJNZ))

(as-ops (as-INC INC)
	(as-DEC DEC))

(as-ops (as-logical-class ORL ANL XRL))
(putprop 'ORL 100 'AS-LOGICAL-INSTRUCTION)
(putprop 'ANL 120 'AS-LOGICAL-INSTRUCTION)
(putprop 'XRL 320 'AS-LOGICAL-INSTRUCTION)

(as-ops (as-MOV MOV)
	(as-MOVX MOVX)
	(as-MOVP MOVP)
	(as-MOVP3 MOVP3))

(as-ops (as-CLR CLR)
	(as-NOP NOP))

(as-ops (as-CALL CALL)
	(as-RET RET)
	(as-RETR RETR))

(as-ops (as-EN EN)
	(as-DIS DIS))

(as-ops (as-swap SWAP))

(as-ops (as-XCH XCH)
	(as-ROTATE RLC RRC RL RR))

(as-ops (as-CPL CPL))

(as-ops (as-STRT STRT)
	(as-STOP STOP))

(as-ops (as-OUTL OUTL)
	(as-IN IN INS))

(as-ops (as-SEL SEL))
