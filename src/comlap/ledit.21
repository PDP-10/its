
(comment LISP-TECO EDITOR INTERFACE)			; -*-LISP-*-


(declare (special ledit-jname		  ;atomic name of emacs job 
		  ledit-loadfile	  ;namestring of binary file for editor
		  ledit-library		  ;namestring of teco macro library
		  ledit-tags		  ;namestring of tags file
		  ledit-tags-find-file	  ;0 or 1 controls setting of qreg in 
					  ; teco whether to use Find File
		  ledit-deletef		  ;switch, if T delete file from teco
					  ; after reading
		  ledit-pre-teco-func	  ;called with list of arguments given
					  ; to ledit
		  ledit-post-teco-func	  ;called with namestring of file
					  ; returned from teco
		  ledit-pre-eval-func	  ;called with form to be eval'ed,
					  ; returns form to be eval'ed instead
		  ledit-completed-func    ;called after reading in is complete
		  ledit-eof		  ;gensym once to save time
		  ledit-jcl		  ;pre-exploded strings to save time
		  ledit-valret		  ;
		  ledit-proceed		  ;
		  ledit-jname-altj	  ;
		  ledit-lisp-jname	  ;
		  ledit-find-tag	  ;
		  ledit-find-file	  ;
		  ledit-lisp-mode	  ;
		  defun			  ;system variable
		  tty-return))		  ;system variable



;; autoload properties for FLOAD stuff that used to be part of LEDIT

(defprop fload ((liblsp) fload fasl) autoload)
(defprop cload ((liblsp) fload fasl) autoload)
(defprop ledit-olderp ((liblsp) fload fasl) autoload))
(defprop ledit-agelist ((liblsp) fload fasl) autoload))

;; default values for global variables

(mapc
 '(lambda (x y) (or (boundp x) (set x y)))
 '(ledit-jname ledit-loadfile ledit-library ledit-tags ledit-tags-find-file 
   ledit-deletef ledit-pre-teco-func ledit-post-teco-func ledit-pre-eval-func
   ledit-completed-func)
 '(LEDIT |SYS2;TS EMACS| |EMACS;LEDIT| () 1 
   () () () () ())
)

(mapc '(lambda (x y) (set x (exploden y)))
      '(ledit-jcl ledit-find-tag 
	ledit-find-file ledit-lisp-jname ledit-lisp-mode )
      '(|:JCL | |WMM& LEDIT FIND TAG| |WMMFIND FILE| 
	|W:ILEDIT LISP JNAME| |WF~MODELISP"N1MMLISP MODEW'|)
)

(setq ledit-eof (gensym) ledit-jname-altj () ledit-valret () )
(setq ledit-proceed (exploden '|
/
..UPI0// /
:IF E Q&<%PIBRK+%PIVAL>/
(:ddtsym tygtyp///
:if n q&10000/
(: Teco Improperly Exited, Use ^Z (NOT CALL!)/
)/
:else/
(: Teco Improperly Exited, Use ^X^C (NOT ^Z !)/
)/
:SLEEP 30./
P/
:INPOP/
)/
2// /
Q+8//-1 /
.-1G|))
    
(defun LEDIT fexpr (spec)
       ;; if given one arg, is tag to be searched for (using FIND FILE) if more
       ;; than one arg, taken as file name to find (may be newio or oldio form)
       (let ((newjob (cond ((not (job-exists-p (status uname) ledit-jname))
			    (setq ledit-jname-altj nil)
			    (setq ledit-valret nil)
			    (mapcan 'exploden (list '/
'|L| ledit-loadfile '/
'|G|)))))
	     (firstcall)
	     (atomvalret))

	    (and ledit-pre-teco-func (funcall ledit-pre-teco-func spec))

	    (or ledit-jname-altj	          ;memoize for fast calls later
		(setq ledit-jname-altj (mapcan 'exploden (list '/
 ledit-jname '|J|))
		      firstcall t))

	    (cond ((and ledit-valret (null spec))    ;go to teco in common case
		   (valret ledit-valret))

		  ('t
		   (setq 
		    atomvalret
		    (nconc 
		     (list 23.)				;ctl-W
		     (append ledit-jcl () )		;set own jcl line to ()
		      (append ledit-jname-altj () )	;$J to ledit job
		      (append ledit-jcl () )		;set jcl line for teco
		      (and newjob			;for new job only
			  (mapcan 'exploden	        
			   (list '|F~EDITOR TYPELEDIT/"NMMLOAD LIBRARY|
				 ledit-library '|'|)))
		      (and firstcall			;for first call only
			   (append ledit-lisp-mode () ))
		      (and firstcall ledit-tags		;for first call only
			   (mapcan 'exploden
			    (list ledit-tags-find-file
				  '|MMVISIT TAG TABLE| ledit-tags '/)))
		      
		      (nconc (append ledit-lisp-jname () )	;tell teco 
			     (exploden (status jname))		;lisp's jname
			     (list 27.))			; altmode
		      (cond ((= (length spec) 1)		;tag
			     (nconc (append ledit-find-tag () )
				    (exploden (car spec))
				    (list 27.)))	
			    ((> (length spec) 1)	;file name
			     (nconc (append ledit-find-file () )
				    (exploden (namestring 
					       (mergef spec defaultf)))
				    (list 27.)
				    (append ledit-lisp-mode () ))))
		      (or newjob ledit-proceed))) ;start new job
						  ; or proceed old one
		   (setq atomvalret (maknam atomvalret))
		   (and (not firstcall)	(not newjob) (null spec)
			(setq ledit-valret
			      atomvalret))	;memoize common simple case
		   (valret atomvalret)))	  ;go to teco
	    '*))

(defun LEDIT-TTY-RETURN (unused)
       ;; this function called by tty-return interrupt to read code back
       ;;  from Teco
       ;; check JCL to see if it starts with LEDIT-JNAME
       ;; if so, rest of JCL is filename to be read in
       ;; note: need to strip off trailing <cr> on jcl
       (declare (fixnum i))
       (let ((jcl (status jcl)))
         (cond ((and jcl
		     (setq jcl
			   (errset
			    (readlist (nreverse (cdr (nreverse jcl)))) nil))
		     (not (atom (setq jcl (car jcl))))
		     (eq (car jcl) ledit-jname))

	        (valret '|:JCL/
P|)							;clear jcl
		(cursorpos 'c)
		(nointerrupt nil)

		(and ledit-post-teco-func
		     (funcall ledit-post-teco-func (cadr jcl)))

		(cond ((cadr jcl)			;if non-null then read in file
		       ;; read in zapped forms
		       (let ((file (open (cadr jcl) 'in))
			     (defun nil))		;disable expr-hash
			    (princ '|;Reading from |)(prin1 ledit-jname)
			    ;; Read-Eval-Print loop
			    (do ((form (cond (read (funcall read file ledit-eof))
					     (t (read file ledit-eof)))
				       (cond (read (funcall read file ledit-eof))
					     (t (read file ledit-eof)))))
				((eq form ledit-eof) (close file)
						     (and ledit-deletef
							  (deletef file)))
				(and ledit-pre-eval-func
				     (setq form (funcall ledit-pre-eval-func form)))
				;; check if uuolinks might need to be snapped
				(let ((p (memq (car (getl (cadr form)
							  '(expr subr fexpr
								 fsubr lsubr)))
					       '(subr fsubr lsubr))))
				     (print (eval form))
				     (cond ((and p
						 (memq (car (getl (cadr form)
								  '(expr subr fexpr
									 fsubr lsubr)))
						       '(expr fexpr)))
					    (sstatus uuolinks)
					    (princ '|	; sstatus uuolinks|))))))))

		(and ledit-completed-func (funcall ledit-completed-func))
		(terpri)
		(princ '|;Edit Completed|)
		(terpri)))))


(defun LEDIT-TTYINT (fileobj char)
       ;; intended to be put on control character, e.g.
       ;; (sstatus ttyint 5 'ledit-ttyint)
       (nointerrupt nil)
       (and (= (tyipeek nil fileobj) char)
	    (tyi fileobj))				;gobble up control char
       (apply 'ledit
	      (cond ((= (boole 1 127.		        ;note masking for 7 bit
			       (tyipeek nil fileobj)) 32.)
		     (tyi fileobj)			;gobble space
		     ;; if space typed then just (ledit)
		     nil)
		    (t (let ((s (cond (read (funcall read fileobj))
				      (t (read fileobj)))))
			    (cond ((atom s)
				   (tyi fileobj)
				   (list s))		;atom is taken as tag
				  (t s)))))))		;list is filename

;;Lap courtesy of GLS.

(declare (setq ibase 8.))

(LAP JOB-EXISTS-P SUBR)
(ARGS JOB-EXISTS-P (NIL . 2))	;ARGS ARE UNAME AND JNAME, AS SYMBOLS
	(PUSH P B)
	(SKIPN 0 A)		;NULL UNAME => DEFAULT TO OWN UNAME
	(TDZA TT TT)		;ZERO UNAME TELLS ITS TO DEFAULT THIS WAY
	(PUSHJ P SIXMAK)	;CONVERT UNAME TO SIXBIT
	(PUSH FXP TT)
	(POP P A)
	(PUSHJ P SIXMAK)	;CONVERT JNAME TO SIXBIT
	(POP FXP T)		;UNAME IN T, JNAME IN TT
	(MOVEI A '())
	(*CALL 0 JEP43)		;SEE IF JOB EXISTS
	(POPJ P)		;NO - RETURN NIL
	(*CLOSE 0)		;YES - CLOSE THE CHANNEL
	(MOVEI A 'T)		; AND RETURN T
	(POPJ P)
JEP43	(SETZ)
	(SIXBIT OPEN)
	(0 0 16 5000)		;CONTROL BITS: IMAGE BLOCK INPUT/INSIST
				; JOB EXISTS
	(0 0 0 1000)		;CHANNEL # - 0 IS SAFE IN BOTH OLDIO AND NEWIO
	(0 0 (% SIXBIT USR))	;DEVICE NAME (USR)
	(0 0 T)			;UNAME
	(0 0 TT 400000)		;JNAME
    ()  




 ;set control-E unless already defined
(or (status ttyint 5) (sstatus ttyint 5 'ledit-ttyint))
(or tty-return (setq tty-return 'ledit-tty-return))
