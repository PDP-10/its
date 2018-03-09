;;; -*- Mode:LISP; Package:MACSYMA -*-

;	** (c) Copyright 1982 Massachusetts Institute of Technology **

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                ;;;
;;;                Miscellaneous Out-of-core Files                 ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module outmis)

(DECLARE (FIXNUM NN))

#+ITS (DECLARE (SPECIAL TTY-FILE))

(DECLARE (SPLITFILE STATUS))

#+(or ITS Multics TOPS-20)
(DECLARE (SPECIAL LINEL MATHLAB-GROUP-MEMBERS)
	 (*EXPR STRIPDOLLAR MEVAL)
	 (*LEXPR CONCAT))



#+(or ITS Multics TOPS-20)
(PROGN 'COMPILE

;;; These are used by $SEND when sending to logged in Mathlab members
#-Multics
(SETQ MATHLAB-GROUP-MEMBERS
      '(JPG ELLEN GJC RZ KMP WGD MERMAN))

;;; IOTA is a macro for doing file I/O binding, guaranteeing that
;;;  the files it loads will get closed.
;;;  Usage: (IOTA ((<variable1> <filename1> <modes1>)
;;;                (<variable2> <filename2> <modes2>) ...)
;;;		  <body>)
;;;  Opens <filenameN> with <modesN> binding it to <variableN>. Closes
;;;   any <variableN> which still has an open file or SFA in it when
;;;   PDL unwinding is done.
;;; No IOTA on Multics yet,
#-Multics
(EVAL-WHEN (EVAL COMPILE)
           (COND ((NOT (STATUS FEATURE IOTA))
                  (LOAD #+ITS '((DSK LIBLSP) IOTA FASL)
			#-ITS '((LISP) IOTA FASL)))))

;;; TEXT-OUT
;;;  Prints a list of TEXT onto STREAM.
;;;
;;;  TEXT must be a list of things to be printed onto STREAM.
;;;    For each element in TEXT, A, if A is a symbol with first
;;;    character "&", it will be fullstripped and PRINC'd into the
;;;    stream; otherwise it will be $DISP'd onto STREAM (by binding
;;;    OUTFILES and just calling $DISP normally).
;;;
;;;  STREAM must be an already-open file object.

(DEFUN TEXT-OUT (TEXT STREAM)
  (DO ((A TEXT (CDR A))
       (/^R T)
       (/^W T)
       (LINEL 69.)
       (OUTFILES (NCONS STREAM)))
      ((NULL A))
    (COND ((AND (SYMBOLP (CAR A))
		(EQ (GETCHAR (CAR A) 1.) '/&))
	   (PRINC (STRIPDOLLAR (CAR A)) STREAM))
	  (T (TERPRI STREAM)
	     (MEVAL `(($DISP) ($STRING ,(CAR A))))))
	   (TERPRI STREAM)))

;;; MAIL
;;;  Sends mail to a recipient, TO, via the normal ITS mail protocol
;;;  by writing out to DSK:.MAIL.;MAIL > and letting COMSAT pick it 
;;;  up and deliver it. Format for what goes in the MAIL > file should
;;;  be kept up to date with what is documented in KSC;?RQFMT >
;;;
;;;  TO must be a name (already STRIPDOLLAR'd) to whom the mail should
;;;    be delivered.
;;;
;;;  TEXT-LIST is a list of Macsyma strings and/or general expressions
;;;    which will compose the message.

#+(OR LISPM ITS) ;Do these both at once.
(DEFUN MAIL (TO TEXT-LIST)
  (IOTA ((STREAM  "DSK:.MAIL.;MAIL >" 'OUT))
    (mformat stream
       "FROM-PROGRAM:Macsyma
AUTHOR:~A
FROM-UNAME:~A
RCPT:~A
TEXT;-1~%"
       (STATUS USERID)
       (STATUS UNAME)
       (NCONS TO))
    (TEXT-OUT TEXT-LIST STREAM)))

;;; This code is new and untested. Please report bugs -kmp
#+TOPS-20 
(DEFUN MAIL (TO TEXT-LIST)
  (IOTA ((STREAM "MAIL:/[--NETWORK-MAIL--/]..-1"
		 '(OUT ASCII DSK BLOCK NODEFAULT)))
    (MFORMAT STREAM
      "/~A
~A
/
From: ~A at ~A~%"
      (STATUS SITE) TO (STATUS USERID) (STATUS SITE))
    (COND ((NOT (EQ (STATUS USERID) (STATUS UNAME)))
	   (MFORMAT STREAM "Sender: ~A at ~A~%" (STATUS UNAME) (STATUS SITE))))
    (MFORMAT STREAM "Date: ~A
TO:   ~A~%~%"
	    (TIME-AND-DATE) TO)
    (TEXT-OUT TEXT-LIST STREAM)))

#+Multics
(defvar macsyma-mail-count 0 "The number of messages sent so far")
#+Multics
(progn 'compile
(DEFUN MAIL (TO TEXT-LIST)
  (let* ((open-file ())
	 (macsyma-unique-id (macsyma-unique-id 'unsent
					       (increment macsyma-mail-count)))
	 (file-name (catenate (pathname-util "pd")
			      ">macsyma_mail." macsyma-unique-id)))
    (unwind-protect
      (progn
       (setq open-file (open file-name '(out ascii block dsk)))
       (text-out text-list open-file)
       (close open-file)
       (cline (catenate "send_mail " to " -input_file " file-name
	                " -no_subject")))
      (deletef open-file))))

(defun macsyma-unique-id (prefix number)
  (implode (append (explode prefix) (list number))))
)

;;; $BUG
;;;  With no args, gives info on itself. With any positive number of
;;;  args, mails all args to MACSYMA via the MAX-MAIL command.
;;;  Returns $DONE

(DEFMSPEC $BUG (X) (SETQ X (CDR X))
       (COND ((NULL X)
	      (MDESCRIBE '$BUG))
	     (T 
	      (MAX-MAIL 'BUG X)))
       '$DONE)

#+MULTICS
(DEFMACRO CHECK-AND-STRIP-ADDRESS (ADDRESS)
  `(COND ((EQUAL (GETCHARN ,ADDRESS 1) #/&)
	  (STRIPDOLLAR ,ADDRESS))
	 (T (MERROR "Mail: Address field must be a string"))))
#-MULTICS
(DEFMACRO CHECK-AND-STRIP-ADDRESS (ADDRESS)
  `(STRIPDOLLAR ,ADDRESS))

;;; $MAIL
;;;  With no args, gives info on itself.
;;;  With 1 arg, sends the MAIL to Macsyma. Like bug, only doesn't
;;;   tag the mail as a bug to be fixed.
;;;  With 2 or more args, assumes that arg1 is a recipient and other
;;;   args are the text to be MAIL'd.
;;; Works for Multics, ITS, and TOPS-20.
 
(DEFMSPEC $MAIL (X) (SETQ X (CDR X)) 
  (COND ((NULL X)
	 (MDESCRIBE '$MAIL))
	((= (LENGTH X) 1.)
	 (MAX-MAIL 'MAIL X))
	(T (LET ((NAME (CHECK-AND-STRIP-ADDRESS (CAR X))))
	     (MAIL NAME (CDR X))
    #-Multics(MFORMAT NIL "~&;MAIL'd to ~A~%" NAME))))
;;;On Multics Mailer will do this.
       '$DONE)

;;; MAX-MAIL
;;;  Mails TEXT-LIST to MACSYMA mail. Normal ITS mail header 
;;;  is suppressed. Header comes out as:
;;;  From <Name> via <Source> command. <Date>
;;;
;;;  SOURCE is the name of the originating command (eg, BUG or 
;;;    MAIL) to be printed in the header of the message.
;;;
;;;  TEXT-LIST is a list of expressions making up the message.

#+(OR LISPM ITS)
(DEFUN MAX-MAIL (SOURCE TEXT-LIST)
 (IOTA ((MAIL-FILE "DSK:.MAIL.;_MAXIM >" '(OUT ASCII DSK BLOCK)))
   (LINEL MAIL-FILE 69.)
   (MFORMAT MAIL-FILE
      "FROM-PROGRAM:Macsyma
HEADER-FORCE:NULL
TO:(MACSYMA)
SENT-BY:~A
TEXT;-1
From ~A via ~A command. ~A~%"
      (STATUS UNAME) 
      (STATUS USERID)
      SOURCE
      (TIME-AND-DATE))
   (TEXT-OUT TEXT-LIST MAIL-FILE)
   (RENAMEF MAIL-FILE "MAIL >"))
 (MFORMAT NIL "~&;Sent to MACSYMA~%")
 '$DONE)

;;; This code is new and untested. Please report bugs -kmp
#+TOPS-20 
(DEFUN MAX-MAIL (SOURCE TEXT-LIST)
  (IOTA ((MAIL-FILE "MAIL:/[--NETWORK-MAIL--/]..-1"
		    '(OUT ASCII DSK BLOCK NODEFAULT)))
    (MFORMAT MAIL-FILE
	     "/MIT-MC
BUG-MACSYMA
/From ~A at ~A via ~A command. ~A~%"
	  (STATUS USERID) (STATUS SITE) SOURCE (TIME-AND-DATE))
    (TEXT-OUT TEXT-LIST MAIL-FILE)
    (MFORMAT NIL "~%;Sent to MACSYMA")))

#+Multics
(defun max-mail (source text-list)
  (let ((address (cond ((eq source 'mail)
			(setq source "Multics-Macsyma-Consultant -at MIT-MC"))
		       (t (setq source "Multics-Macsyma-Bugs -at MIT-MC")))))
    (mail address text-list)))

); END of (or ITS Multics TOPS-20) conditionalization.


;; On ITS, this returns a list of user ids for some random reason.  On other
;; systems, just print who's logged in.  We pray that nobody uses this list for
;; value.

#+ITS
(PROGN 'COMPILE
(DEFMFUN $who nil
  (do ((tty*)
       (wholist nil (cond ((eq (getchar tty* 1)  ;just consoles, not device
			       '/D)
			   wholist)
			  (t (LET ((UNAME (READUNAME)))
			       (COND ((MEMQ UNAME WHOLIST) WHOLIST)
				     (T (CONS UNAME WHOLIST)))))))
       (ur (crunit))
       (tty-file ((lambda (tty-file)
		    (readline tty-file)	   ;blank line
		    tty-file)  ;get rid of cruft
		  (open '((tty) |.file.| |(dir)|) 'single))))
      ((progn (readline tty-file)
	      (setq tty* (read tty-file))
	      (eq tty* 'free))
       (close tty-file)
       (apply 'crunit ur)
       (cons '(mlist simp) wholist))))

;;; $SEND
;;;  With no args, gives info about itself.
;;;  With one arg, sends the info to any logged in Macsyma users.
;;;  With 2 or more args, assumes that arg1 is a recipient and
;;;   args 2 on are a list of expressions to make up the message.

(DEFMSPEC $SEND (X) (SETQ X (CDR X)) 
       (COND ((NULL X)
	      (MDESCRIBE '$SEND))
	     ((= (LENGTH X) 1.)
	      (MAX-SEND X))
	     (T
	      (MSEND (STRIPDOLLAR (CAR X)) (CDR X) T)))
       '$DONE)

;;; MSEND
;;;  Sends mail to a recipient, TO, by opening the CLI: device on the
;;;  recipient's HACTRN.
;;;
;;;  TO must be a name (already FULLSTRIP'd) to whom the mail should
;;;    be delivered. A header is printed of the form:
;;;    [MESSAGE FROM MACSYMA USER <Uname>  <time/date>] (To: <Recipient>)
;;;
;;;  TEXT-LIST is a list of Macsyma strings and/or general expressions
;;;    which will compose the message.
;;;
;;;  MAIL? is a flag that says whether the text should be forwarded
;;;    as mail to the recipient if the send fails. Since the only current
;;;    use for this is when sending to all of Mathlab, a value of NIL
;;;    for this flag assumes a <Recipient> in the header should be
;;;    "Mathlab Members" rather than the real name of the recipient.
;;;    An additional flag might be used to separate these functions
;;;    at some later time, but this should suffice for now.

(DEFUN MSEND (TO TEXT-LIST MAIL?)
  (COND ((EQ TO (STATUS UNAME))
	 (MERROR "You cannot SEND to yourself.  Use MAIL.")
	 ())
	((ERRSET (IOTA ((STREAM (LIST '(CLI *) TO 'HACTRN) 'OUT))
		    (MFORMAT STREAM
		       "/[Message from MACSYMA User ~A] (To: ~A) ~A~%"
		       (STATUS UNAME)
		       (COND (MAIL? TO)
			     (T "Mathlab Members"))
		       (DAYTIME))
		    (TEXT-OUT TEXT-LIST STREAM))
		 NIL)
	 (MFORMAT NIL "~&;Sent to ~A~%" TO)
	 T)
	(MAIL? (COND ((PROBEF (LIST '(USR *) TO 'HACTRN))
		      (MFORMAT NIL "~&;~A isn't accepting message.~%" TO))
		     (T (MFORMAT NIL "~&;~A isn't logged in.~%" TO)))
	       (MAIL TO TEXT-LIST)
	       (MFORMAT NIL "~&;Message MAIL'd.~%")
	       () )
	(T ())))

;;; MAX-SEND
;;;  Send TEXT-LIST to any Mathlab members logged in.
;;;  If no one on the list is logged in, or if the only logged in
;;;  members are long idle, this command will forward the message
;;;  to MACSYMA mail automatically (notifying the user).
;;; 
;;;  TEXT-LIST is a list of expressions or strings making up the
;;;    message.


(DEFUN MAX-SEND (TEXT-LIST)				;
  (LET ((SUCCESS NIL)
	(PEOPLE (DELETE (STATUS UNAME) (CDR ($WHO)))))
       (DO ((PERSON))
	   ((NULL PEOPLE))
	 (SETQ PERSON (PROG1 (CAR PEOPLE)
			     (SETQ PEOPLE (CDR PEOPLE))))
	 (COND ((MEMQ PERSON MATHLAB-GROUP-MEMBERS)
		(LET ((RESULT (MSEND PERSON TEXT-LIST NIL)))
		     (SETQ SUCCESS
			   (OR SUCCESS
			       (AND (< (IDLE-TIME PERSON) 9000.)
				    RESULT
				    T)))
		     (COND ((AND RESULT (> (IDLE-TIME PERSON) 9000.))
			    (MFORMAT NIL
				     " (but he//she is idle a long time)")))
		     (COND (RESULT (TERPRI)))))))
       (COND ((NOT SUCCESS)
	      (MFORMAT NIL "There's no one around to help, so I have mailed
your message to MACSYMA. Someone will get back
to you about the problem.")
	      (MAX-MAIL 'SEND TEXT-LIST)))
	    '$DONE))

(DEFUN READUNAME NIL 
       (TYI TTY-FILE)
       (DO ((I 1. (1+ I)) (L) (N))
	   ((> I 6.) (IMPLODE (NREVERSE L)))
	   (SETQ N (TYI TTY-FILE))
	   (OR (= N 32.) (SETQ L (CONS N L)))))

;;; IDLE-TIME
;;;  Given an arg of UNAME (already FULLSTRIP'd) returns the idle-time
;;;  of that user.

(MACRO 6BIT (X) (CAR (PNGET (CADR X) 6.)))

(DEFUN IDLE-TIME (UNAME)
  (IOTA ((USR-FILE (LIST '(USR *) UNAME 'HACTRN)))
    (LET ((TTY-NUMBER (SYSCALL 1 'USRVAR USR-FILE (6BIT CNSL))))
      (CLOSE USR-FILE)
      (COND ((ATOM TTY-NUMBER)
	     (MFORMAT NIL "USRVAR BUG in SEND. Please report this.
Mention error code: ~A~%Thank you." TTY-NUMBER)
	     100000.)
	    (T
	     (LET ((IDLE-TIME (SYSCALL 1 'TTYVAR
				       (+ (CAR TTY-NUMBER) #O 400000)
				       (6BIT IDLTIM))))
		  (COND ((ATOM IDLE-TIME)
			 (MFORMAT NIL
			   "TTYVAR bug in SEND.  Please report this.
Mention error code:  ~A~%Thank you." IDLE-TIME)
			 100000.)
			(T (CAR IDLE-TIME)))))))))

) ;End of PROGN 'Compile for WHO on ITS.

#+Multics
(DEFMFUN $WHO ()
  (CLINE "who -long")
  '$DONE)

;Turn sends into MAIL on foreign hosts.
#+(or Multics TOPS-20 LISPM)
(progn 'compile
#+Multics
(defmacro check-sendee-and-strip (sendee)
  `(cond ((eq (getcharn ,sendee 1) #/&)
	  (stripdollar ,sendee))
	 (t (merror "Send: 1st argument to SEND must be a string"))))
#-Multics
(defmacro check-sendee-and-strip (sendee)
  `(stripdollar ,sendee))
	 
(DEFMSPEC $SEND (X) (SETQ X (CDR X)) 

	    (COND ((NULL X)
		   (MDESCRIBE '$SEND))
;;;O.K. we gotta get the documentation to agree with what we're doin' here.
		  ((= (LENGTH X) 1.)
		   (MAX-MAIL 'SEND X))
		  (T (LET ((NAME (check-sendee-and-strip (CAR X))))
		       (MAIL NAME (CDR X))
	      #-Multics(MFORMAT NIL "~&;MAIL'd to ~A~%" NAME))))
	    '$DONE)
)

;; ALARMCROCK only exists in MacLisp.  I would really like to know
;; what Macsyma users do with this.

#+MacLisp 
(PROGN 'COMPILE

;;; $TIMEDATE
;;;  A command to return the time and date as a Macsyma string.

(DEFMFUN $TIMEDATE () (CONCAT '/& (TIME-AND-DATE)))

;;; DAY-OF-WEEK
;;;  Returns day of week as a capitalized symbol (Uppercase initial
;;;  char, all other chars lower case). (eg, |Sunday|)

(DEFUN DAY-OF-WEEK ()
       (LET ((DOW (EXPLODEN (STATUS DOW))))
	    (IMPLODE
	     (CONS (CAR DOW)
		   (MAPCAR (FUNCTION (LAMBDA (X) 
				       (COND ((< X 91.) ;;Is it already lower?
					      (+ X 32.))
					     (t x))))
			   (CDR DOW))))))

;;; DAYTIME
;;;  Returns time of day as a symbol in format Hours:Minutes<am\pm>
;;;  (eg, |12:03pm|)

(DEFUN DAYTIME ()
       (LET ((BASE 10.) (*NOPOINT T)
	     ((HOUR MINUTES) (STATUS DAYTIME)))
	    (CONCAT (COND ((< (\ HOUR 12.) 0.) '|12|) (T (\ HOUR 12.)))
		    '|:|
		    (COND ((< (FLATC MINUTES) 2.) (CONCAT '/0 MINUTES))
			  (T MINUTES))
		    (COND ((ZEROP (// HOUR 12.)) '|am|) (T '|pm|)))))

;;; DATE*
;;;  Returns as a symbol: Month Date, Year 
;;;  (eg, |Jan 17, 1943|)

(DEFUN DATE* ()
       (LET ((BASE 10.) (*NOPOINT T)
	     ((YEAR MONTH DATE) (STATUS DATE)))
	    (SETQ MONTH
		  (CDR (ASSQ MONTH
			     '((1. . |Jan|)  (2.  . |Feb|)
			       (3. . |Mar|)  (4.  . |Apr|)
			       (5. . |May|)  (6.  . |Jun|)
			       (7. . |Jul|)  (8.  . |Aug|)
			       (9. . |Sep|)  (10. . |Oct|)
			       (11. . |Nov|) (12. . |Dec|)))))
	    (CONCAT MONTH '| | DATE '|, 19| YEAR)))
		    
;;; TIME-AND-DATE
;;;  Puts all time/date info together as a symbol in format:
;;;   <Day-of-Week>, <Month> <Date>, <Year>  <Hour>:<Min><am\pm>
;;;  (eg, |Sunday, Feb 30, 1984  4:38pm|)

(DEFUN TIME-AND-DATE ()
       (CONCAT  (DAY-OF-WEEK) '|, | (DATE*) '|  | (DAYTIME)))

(DECLARE (SPECIAL ALARMCLOCK))

(DEFMSPEC $ALARMCLOCK (L) (SETQ L (CDR L)) 
  (AND
   (CDDR L)
   (SETQ ALARMCLOCK
	 (APPEND '(LAMBDA (X))
		 (NCONS (LIST 'MEVAL1
			      (LIST 'QUOTE
				    (NCONS (CDDR L))))))))
  (LET ((TPARM (CAR L))
	(AMOUNT (MEVAL (CADR L))))
       (COND ((EQ TPARM '$TIME)
	      (ALARMCLOCK 'TIME AMOUNT))
	     ((EQ TPARM '$RUNTIME)
	      (ALARMCLOCK 'RUNTIME (TIMES AMOUNT 1000.)))
	     (T (MERROR "The first argument of ALARMCLOCK must be either TIME or RUNTIME")))))

) ;End of Maclisp PROGN.

(DECLARE (SPLITFILE ISOLAT)
	 (SPECIAL *XVAR $EXPTISOLATE $LABELS $DISPFLAG ERRORSW)
	 (FIXNUM (GETLABCHARN))) 

(DEFMVAR $EXPTISOLATE NIL)
(DEFMVAR $ISOLATE_WRT_TIMES NIL)

(DEFMFUN $ISOLATE (E *XVAR) (SETQ *XVAR (GETOPR *XVAR)) (ISO1 E)) 

(DEFUN ISO1 (E) 
 (COND ((SPECREPP E) (ISO1 (SPECDISREP E)))
       ((AND (FREE E 'MPLUS) (OR (NULL $ISOLATE_WRT_TIMES) (FREE E 'MTIMES))) E)
       ((FREEOF *XVAR E) (MGEN2 E))
       ((ALIKE1 *XVAR E) *XVAR)
       ((MEMQ (CAAR E) '(MPLUS MTIMES)) (ISO2 E))
       ((EQ (CAAR E) 'MEXPT)
	(COND ((NULL (ATOM (CADR E))) (LIST (CAR E) (ISO1 (CADR E)) (CADDR E)))
	      ((OR (ALIKE1 (CADR E) *XVAR) (NOT $EXPTISOLATE)) E)
	      (T (LET ((X ($RAT (CADDR E) *XVAR)) (U 0) (H 0))
		      (SETQ U (RATDISREP ($RATNUMER X)) X (RATDISREP ($RATDENOM X)))
		      (IF (NOT (EQUAL X 1))
			  (SETQ U ($MULTTHRU (LIST '(MEXPT) X -1) U)))
		      (IF (MPLUSP U)
			  (SETQ U ($PARTITION U *XVAR) H (CADR U) U (CADDR U)))
		      (SETQ U (POWER* (CADR E) (ISO1 U)))
		      (COND ((NOT (EQUAL H 0))
			     (MUL2* (MGEN2 (POWER* (CADR E) H)) U))
			    (T U))))))
	     (T (CONS (CAR E) (MAPCAR #'ISO1 (CDR E))))))

(DEFUN ISO2 (E) 
       (PROG (HASIT DOESNT OP) 
	     (SETQ OP (NCONS (CAAR E)))
	     (DO I (CDR E) (CDR I) (NULL I)
		 (COND ((FREEOF *XVAR (CAR I)) (SETQ DOESNT (CONS (CAR I) DOESNT)))
		       (T (SETQ HASIT (CONS (ISO1 (CAR I)) HASIT)))))
	     (COND ((NULL DOESNT) (GO RET))
		   ((AND (NULL (CDR DOESNT)) (ATOM (CAR DOESNT))) (GO RET))
		   ((PROG2 (SETQ DOESNT (SIMPLIFY (CONS OP DOESNT)))
			   (AND (FREE DOESNT 'MPLUS)
				(OR (NULL $ISOLATE_WRT_TIMES)
				    (FREE DOESNT 'MTIMES)))))
		   (T (SETQ DOESNT (MGEN2 DOESNT))))
	     (SETQ DOESNT (NCONS DOESNT))
	RET  (RETURN (SIMPLIFYA (CONS OP (NCONC HASIT DOESNT)) NIL)))) 

(DEFUN MGEN2 (H)
 (COND ((MEMSIMILARL H (CDR $LABELS) (GETLABCHARN $LINECHAR)))
       (T (SETQ H (DISPLINE H)) (AND $DISPFLAG (MTERPRI)) H))) 

(DEFUN MEMSIMILARL (ITEM LIST LINECHAR) 
       (COND ((NULL LIST) NIL)
	     ((AND (= (GETLABCHARN (CAR LIST)) LINECHAR)
		   (BOUNDP (CAR LIST))
		   (MEMSIMILAR ITEM (CAR LIST) (SYMEVAL (CAR LIST)))))
	     (T (MEMSIMILARL ITEM (CDR LIST) LINECHAR)))) 

(DEFUN MEMSIMILAR (ITEM1 ITEM2 ITEM2EV) 
 (COND ((EQUAL ITEM2EV 0) NIL)
       ((ALIKE1 ITEM1 ITEM2EV) ITEM2)
       (T (LET ((ERRORSW T) R)
	       (SETQ R (*CATCH 'ERRORSW (DIV ITEM2EV ITEM1)))
	       (AND (MNUMP R) (NOT (ZEROP R)) (DIV ITEM2 R))))))

(DEFMFUN $PICKAPART (X LEV)
 (SETQ X (FORMAT1 X))
 (COND ((NOT (EQ (TYPEP LEV) 'FIXNUM))
	(MERROR "Improper 2nd argument to PICKAPART:~%~M" LEV))
       ((OR (ATOM X) (AND (EQ (CAAR X) 'MMINUS) (ATOM (CADR X)))) X)
       ((= LEV 0) (MGEN2 X))
       ((AND (ATOM (CDR X)) (CDR X)) X)
       (T (CONS (CAR X) (MAPCAR #'(LAMBDA (Y) ($PICKAPART Y (1- LEV))) (CDR X)))))) 

(DEFMFUN $REVEAL (E LEV) 
 (SETQ E (FORMAT1 E))
 (COND ((AND (EQ (TYPEP LEV) 'FIXNUM) (> LEV 0)) (REVEAL E 1 LEV))
       (T (MERROR "Second argument to REVEAL must be positive integer."))))

(DEFUN SIMPLE (X) (OR (ATOM X) (MEMQ (CAAR X) '(RAT BIGFLOAT)))) 

(DEFUN REVEAL (E NN LEV) 
 (COND ((SIMPLE E) E)
       ((= NN LEV)
	(COND ((EQ (CAAR E) 'MPLUS) (CONS '(|&Sum| SIMP) (NCONS (LENGTH (CDR E)))))
	      ((EQ (CAAR E) 'MTIMES) (CONS '(|&Product| SIMP) (NCONS (LENGTH (CDR E)))))
	      ((EQ (CAAR E) 'MEXPT) '|&Expt|)
	      ((EQ (CAAR E) 'MQUOTIENT) '|&Quotient|)
	      ((EQ (CAAR E) 'MMINUS) '|&Negterm|)
	      (T (GETOP (MOP E)))))
       (T (LET ((U (COND ((MEMQ 'SIMP (CDAR E)) (CAR E))
			 (T (CONS (CAAR E) (CONS 'SIMP (CDAR E))))))
		(V (MAPCAR #'(LAMBDA (X) (REVEAL (FORMAT1 X) (1+ NN) LEV))
			   (MARGS E))))
	       (COND ((EQ (CAAR E) 'MQAPPLY) (CONS U (CONS (CADR E) V)))
		     ((EQ (CAAR E) 'MPLUS) (CONS U (NREVERSE V)))
		     (T (CONS U V)))))))

(DECLARE (SPLITFILE PROPFN)
	 (SPECIAL ATVARS MUNBOUND $PROPS $GRADEFS $FEATURES OPERS
		  $CONTEXTS $ACTIVECONTEXTS $ALIASES)) 

(DEFMSPEC $PROPERTIES (X)
  (NONSYMCHK (SETQ X (GETOPR (FEXPRCHECK X))) '$PROPERTIES)
  (LET ((U (PROPERTIES X)) (V (OR (GET X 'NOUN) (GET X 'VERB))))
       (IF V (NCONC U (CDR (PROPERTIES V))) U)))

(DEFUN PROPERTIES (X) 
  (DO ((Y (PLIST X) (CDDR Y))
       (L (CONS '(MLIST SIMP) (AND (BOUNDP X)
				   (IF (OPTIONP X) (NCONS '|&System Value|)
						   (NCONS '$VALUE)))))
       (PROP))
      ((NULL Y) (IF (MEMQ X (CDR $FEATURES)) (NCONC L (NCONS '$FEATURE)))
		(IF (MEMQ X (CDR $CONTEXTS)) (NCONC L (NCONS '$CONTEXT)))
		(IF (MEMQ X (CDR $ACTIVECONTEXTS))
		    (NCONC L (NCONS '$ACTIVECONTEXT)))
		L)
      ;; TOP-LEVEL PROPERTIES
      (COND ((SETQ PROP (ASSQ (CAR Y)
			      '((BINDTEST . $BINDTEST)
				(SP2 . $DEFTAYLOR) (ASSIGN . |&Assign Property|)
				(NONARRAY . $NONARRAY) (GRAD . $GRADEF)
				(NOUN . $NOUN) (EVFUN . $EVFUN) (SPECIAL . $SPECIAL)
				(EVFLAG . $EVFLAG) (OP . $OPERATOR) (ALPHABET . $ALPHABETIC))))
	     (NCONC L (NCONS (CDR PROP))))
	    ((SETQ PROP (MEMQ (CAR Y) OPERS)) (NCONC L (LIST (CAR PROP))))
	    ((AND (EQ (CAR Y) 'OPERATORS) (NOT (EQ (CADR Y) 'SIMPARGS1)))
	 (NCONC L (LIST '$RULE)))
	 ((AND (MEMQ (CAR Y) '(FEXPR FSUBR MFEXPR*S MFEXPR*))
		 (NCONC L (NCONS '|&Special Evaluation Form|))
		 NIL))
	 ((AND (MEMQ (CAR Y) '(SUBR FSUBR LSUBR EXPR FEXPR MACRO
			       TRANSLATED-MMACRO SPECSIMP MFEXPR*S))
		 (NOT (MEMQ '|&System Function| L)))
	 (NCONC L
		 (LIST (COND ((GET X 'TRANSLATED) '$TRANSFUN)
				((MGETL X '($RULE RULEOF)) '$RULE)
				(T '|&System Function|)))))
	 ((AND (EQ (CAR Y) 'AUTOLOAD) (NOT (MEMQ '|&System Function| L)))
	  (NCONC L (NCONS (IF (MEMQ X (CDR $PROPS))
			      '|&User Autoload Function|
			      '|&System Function|))))
	 ((AND (EQ (CAR Y) 'REVERSEALIAS) (MEMQ (CAR Y) (CDR $ALIASES)))
	  (NCONC L (NCONS '$ALIAS)))
	 ((EQ (CAR Y) 'DATA)
	  (NCONC L (CONS '|&Database Info| (CDR ($FACTS X)))))
	 ((EQ (CAR Y) 'MPROPS)
	 ;; PROPS PROPERTIES
	  (DO Y
		 (CDADR Y)
		 (CDDR Y)
		 (NULL Y)
		 (COND ((SETQ PROP (ASSQ (CAR Y)
					 '((MEXPR . $FUNCTION)
					 (MMACRO . $MACRO)
					 (HASHAR . |&Hashed Array|)
					 (AEXPR . |&Array Function|)
					 (ATVALUES . $ATVALUE)
					 ($ATOMGRAD . $ATOMGRAD)
					 ($NUMER . $NUMER)
					 (DEPENDS . $DEPENDENCY)
					 ($CONSTANT . $CONSTANT)
					 ($NONSCALAR . $NONSCALAR)
					 ($SCALAR . $SCALAR)
					 (MATCHDECLARE . $MATCHDECLARE)
					 (MODE . $MODEDECLARE))))
			(NCONC L (LIST (CDR PROP))))
		 ((EQ (CAR Y) 'ARRAY)
			(NCONC L
			 (LIST (COND ((GET X 'ARRAY) '|&Complete Array|)
					 (T '|&Declared Array|)))))
		 ((AND (EQ (CAR Y) '$PROPS) (CDADR Y))
			(NCONC L
			 (DO ((Y (CDADR Y) (CDDR Y))
			      (L (LIST '(MLIST) '|&User Properties|)))
				 ((NULL Y) (LIST L))
				 (NCONC L (LIST (CAR Y))))))))))))


(DEFMSPEC $PROPVARS (X)
  (SETQ X (FEXPRCHECK X))
  (DO ((ITEML (CDR $PROPS) (CDR ITEML)) (PROPVARS (NCONS '(MLIST))))
      ((NULL ITEML) PROPVARS)
    (AND (AMONG X (MEVAL (LIST '($PROPERTIES) (CAR ITEML))))
	 (NCONC PROPVARS (NCONS (CAR ITEML))))))

(DEFMSPEC $PRINTPROPS (R) (SETQ R (CDR R))
  (IF (NULL (CDR R)) (MERROR "PRINTPROPS takes two arguments."))
  (LET ((S (CADR R)))
    (SETQ R (CAR R))
    (SETQ R (COND ((ATOM R)
		   (COND ((EQ R '$ALL)
			  (COND ((EQ S '$GRADEF) (MAPCAR 'CAAR (CDR $GRADEFS)))
				(T (CDR (MEVAL (LIST '($PROPVARS) S))))))
			 (T (NCONS R))))
		  (T (CDR R))))
    (COND ((EQ S '$ATVALUE) (DISPATVALUES R))
	  ((EQ S '$ATOMGRAD) (DISPATOMGRADS R))
	  ((EQ S '$GRADEF) (DISPGRADEFS R))
	  ((EQ S '$MATCHDECLARE) (DISPMATCHDECLARES R))
	  (T (MERROR "UNKNOWN PROPERTY - PRINTPROPS:  ~:M" S)))))

(DEFUN DISPATVALUES (L) 
       (DO L
	   L
	   (CDR L)
	   (NULL L)
	   (DO LL
	       (MGET (CAR L) 'ATVALUES)
	       (CDR LL)
	       (NULL LL)
	       (MTELL-OPEN
		"~M~%"
		(LIST '(MLABLE) NIL 
		      (LIST '(MEQUAL)
			    (ATDECODE (CAR L) (CAAR LL) (CADAR LL))
			    (CADDAR LL)))
	       )))
       '$DONE)

(DECLARE (FIXNUM N))

(DEFUN ATDECODE (FUN DL VL) 
       (SETQ VL (APPEND VL NIL))
       (ATVARSCHK VL)
       ((LAMBDA (EQS NVARL) (COND ((NOT (MEMQ NIL (MAPCAR '(LAMBDA (X) (SIGNP E X)) DL)))
				   (DO ((VL VL (CDR VL)) (VARL ATVARS (CDR VARL)))
				       ((NULL VL))
				       (AND (EQ (CAR VL) MUNBOUND) (RPLACA VL (CAR VARL))))
				   (CONS (LIST FUN) VL))
				  (T (SETQ FUN (CONS (LIST FUN)
						     (DO ((N (LENGTH VL) (1- N))
							  (VARL ATVARS (CDR VARL))
							  (L NIL (CONS (CAR VARL) L)))
							 ((ZEROP N) (NREVERSE L)))))
				     (DO ((VL VL (CDR VL)) (VARL ATVARS (CDR VARL)))
					 ((NULL VL))
					 (AND (NOT (EQ (CAR VL) MUNBOUND))
					      (SETQ EQS (CONS (LIST '(MEQUAL) (CAR VARL) (CAR VL)) EQS))))
				     (SETQ EQS (CONS '(MLIST) (NREVERSE EQS)))
				     (DO ((VARL ATVARS (CDR VARL)) (DL DL (CDR DL)))
					 ((NULL DL) (SETQ NVARL (NREVERSE NVARL)))
					 (AND (NOT (ZEROP (CAR DL)))
					      (SETQ NVARL (CONS (CAR DL) (CONS (CAR VARL) NVARL)))))
				     (LIST '(%AT) (CONS '(%DERIVATIVE) (CONS FUN NVARL)) EQS))))
	NIL NIL)) 

(DEFUN DISPATOMGRADS (L) 
       (DO I
	   L
	   (CDR I)
	   (NULL I)
	   (DO J
	       (MGET (CAR I) '$ATOMGRAD)
	       (CDR J)
	       (NULL J)
	       (MTELL-OPEN "~M~%"
			   (LIST '(MLABLE)
				 NIL
				 (LIST '(MEQUAL)
				       (LIST '(%DERIVATIVE)
					     (CAR I) (CAAR J) 1.)
				       (CDAR J))))
	       ))
       '$DONE) 

(DEFUN DISPGRADEFS (L) 
       (DO I
	   L
	   (CDR I)
	   (NULL I)
	   (SETQ L (GET (CAR I) 'GRAD))
	   (DO ((J (CAR L) (CDR J)) (K (CDR L) (CDR K)) (THING (CONS (NCONS (CAR I)) (CAR L))))
	       ((OR (NULL K) (NULL J)))
	     (MTELL-OPEN "~M~%"
			 (LIST '(MLABLE)
			     NIL
			     (LIST '(MEQUAL) (LIST '(%DERIVATIVE) THING (CAR J) 1.) (CAR K))))
	       ))
       '$DONE) 

(DEFUN DISPMATCHDECLARES (L) 
  (DO ((I L (CDR I)) (RET))
      ((NULL I) (CONS '(MLIST) RET))
      (SETQ L (CAR (MGET (CAR I) 'MATCHDECLARE)))
      (SETQ RET (CONS (APPEND (COND ((ATOM L) (NCONS (NCONS L))) (T L))
			      (NCONS (CAR I)))
		      RET))))


(DECLARE (SPLITFILE CHANGV)
	 (SPECIAL TRANS OVAR NVAR TFUN INVFUN $PROGRAMMODE NFUN
		  *ROOTS *FAILURES VARLIST GENVAR)
	 (*LEXPR $LIMIT $SOLVE SOLVABLE)) 

(DEFMFUN $CHANGEVAR (EXPR TRANS NVAR OVAR) 
  (LET (INVFUN NFUN)
    (COND ((OR (ATOM EXPR) (EQ (CAAR EXPR) 'RAT) (EQ (CAAR EXPR) 'MRAT))  EXPR)
	  ((ATOM TRANS) (MERROR "2nd arg must not be atomic"))
	  ((NULL (ATOM NVAR)) (MERROR "3rd arg must be atomic"))
	  ((NULL (ATOM OVAR)) (MERROR "4th arg must be atomic")))
    (SETQ TFUN (SOLVABLE (SETQ TRANS (MEQHK TRANS)) OVAR))
    (CHANGEVAR EXPR)))

(DEFUN SOLVABLE (L VAR &OPTIONAL (ERRSWITCH NIL))
 (LET (*ROOTS *FAILURES)
   (SOLVE L VAR 1)
   (COND (*ROOTS ($RHS (CAR *ROOTS)))
	 (ERRSWITCH
	  (MERROR "Unable to solve for ~M" VAR)
	  )
	 (T NIL))))

(DEFUN CHANGEVAR (EXPR)
       (COND ((ATOM EXPR) EXPR)
	     ((OR (NOT (MEMQ (CAAR EXPR) '(%INTEGRATE %SUM %PRODUCT)))
		  (NOT (ALIKE1 (CADDR EXPR) OVAR)))
	      (RECUR-APPLY #'CHANGEVAR EXPR))
	     (T (LET ((DERIV (IF TFUN (SDIFF TFUN NVAR)
				 (NEG (DIV (SDIFF TRANS NVAR) ;IMPLICIT DIFF.
					   (SDIFF TRANS OVAR))))))
		  (COND ((AND (MEMQ (CAAR EXPR) '(%SUM %PRODUCT))
			      (NOT (EQUAL DERIV 1)))
			 (MERROR "Illegal change in summation or product"))
			((SETQ NFUN ($RADCAN   ;NIL IF KERNSUBST FAILS
				     (IF TFUN
					 (MUL (SUBSTITUTE TFUN OVAR (CADR EXPR))
					      DERIV)
					 (KERNSUBST ($RATSIMP (MUL (CADR EXPR)
								   DERIV))
						    TRANS OVAR)))) 
			 (COND     ;; DEFINITE INTEGRAL,SUMMATION, OR PRODUCT
			  ((CDDDR EXPR)
			   (OR INVFUN (SETQ INVFUN (SOLVABLE TRANS NVAR T)))
			   (LIST (NCONS (CAAR EXPR))	;THIS WAS CHANGED
				 NFUN			;FROM '(%INTEGRATE)
				 NVAR
				 ($LIMIT INVFUN OVAR (CADDDR EXPR) '$PLUS)
				 ($LIMIT INVFUN
					 OVAR
					 (CAR (CDDDDR EXPR))
					 '$MINUS)))
			  (T				;INDEFINITE INTEGRAL
			   (LIST '(%INTEGRATE) NFUN NVAR))))
			(T EXPR)))))) 

(DEFUN KERNSUBST (EXPR FORM OVAR)
  (LET (VARLIST GENVAR NVARLIST)
    (NEWVAR EXPR)
    (SETQ NVARLIST (MAPCAR #'(LAMBDA (X) (IF (FREEOF OVAR X) X
					     (SOLVABLE FORM X)))
			   VARLIST))
    (IF (MEMQ NIL NVARLIST) NIL
	(PROG2 (SETQ EXPR (RATREP* EXPR)
		     VARLIST NVARLIST)
	       (RDIS (CDR EXPR))))))
	  

(DECLARE (SPLITFILE FACSUM) (SPECIAL $LISTCONSTVARS FACFUN)) 

(DEFMFUN $FACTORSUM (E) (FACTORSUM0 E '$FACTOR)) 

(DEFMFUN $GFACTORSUM (E) (FACTORSUM0 E '$GFACTOR)) 

(DEFUN FACTORSUM0 (E FACFUN) 
       (COND ((MPLUSP (SETQ E (FUNCALL FACFUN E)))
	      (FACTORSUM1 (CDR E)))
	     (T (FACTORSUM2 E)))) 

(DEFUN FACTORSUM1 (E) 
       (PROG (F LV LLV LEX CL LT C) 
	LOOP (SETQ F (CAR E))
	     (SETQ LV (CDR ($SHOWRATVARS F)))
	     (COND ((NULL LV) (SETQ CL (CONS F CL)) (GO SKIP)))
	     (DO ((Q LLV (CDR Q)) (R LEX (CDR R)))
		 ((NULL Q))
		 (COND ((INTERSECT (CAR Q) LV)
			(RPLACA Q (UNION* (CAR Q) LV))
			(RPLACA R (CONS F (CAR R)))
			(RETURN (SETQ LV NIL)))))
	     (OR LV (GO SKIP))
	     (SETQ LLV (CONS LV LLV) LEX (CONS (NCONS F) LEX))
	SKIP (AND (SETQ E (CDR E)) (GO LOOP))
	     (OR CL (GO SKIP2))
	     (DO ((Q LLV (CDR Q)) (R LEX (CDR R)))
		 ((NULL Q))
		 (COND ((AND (NULL (CDAR Q)) (CDAR R))
			(RPLACA R (NCONC CL (CAR R)))
			(RETURN (SETQ CL NIL)))))
	SKIP2(SETQ LLV NIL LV NIL)
	     (DO
	      R
	      LEX
	      (CDR R)
	      (NULL R)
	      (COND ((CDAR R)
		     (SETQ LLV
			   (CONS (FACTORSUM2 (FUNCALL FACFUN (CONS '(MPLUS)
							   (CAR R))))
				 LLV)))
		    ((OR (NOT (MTIMESP (SETQ F (CAAR R))))
			 (NOT (MNUMP (SETQ C (CADR F)))))
		     (SETQ LLV (CONS F LLV)))
		    (T (DO ((Q LT (CDR Q)) (S LV (CDR S)))
			   ((NULL Q))
			   (COND ((ALIKE1 (CAR S) C)
				  (RPLACA Q (CONS (DCON F) (CAR Q)))
				  (RETURN (SETQ F NIL)))))
		       (AND F
			    (SETQ LV (CONS C LV) 
				  LT (CONS (NCONS (DCON F)) LT))))))
	     (SETQ 
	      LEX
	      (MAPCAR '(LAMBDA (S Q) 
			       (SIMPTIMES (LIST '(MTIMES)
						S
						(COND ((CDR Q)
						       (CONS '(MPLUS)
							     Q))
						      (T (CAR Q))))
					  1.
					  NIL))
		      LV
		      LT))
	     (RETURN (SIMPLUS (CONS '(MPLUS)
				    (NCONC CL LEX LLV))
			      1.
			      NIL)))) 

(DEFUN DCON (MT) 
       (COND ((CDDDR MT) (CONS (CAR MT) (CDDR MT))) (T (CADDR MT)))) 

(DEFUN FACTORSUM2 (E) 
       (COND ((NOT (MTIMESP E)) E)
	     (T (CONS '(MTIMES)
		      (MAPCAR '(LAMBDA (F) 
				       (COND ((MPLUSP F)
					      (FACTORSUM1 (CDR F)))
					     (T F)))
			      (CDR E)))))) 

(DECLARE (SPLITFILE COMBF) (SPECIAL $COMBINEFLAG)) 

(DEFMFUN $COMBINE (E) 
 (COND ((OR (ATOM E) (EQ (CAAR E) 'RAT)) E)
       ((EQ (CAAR E) 'MPLUS) (COMBINE (CDR E)))
       (T (RECUR-APPLY #'$COMBINE E)))) 

(DEFUN COMBINE (E) 
       (PROG (TERM R LD SW NNU D LN XL) 
	AGAIN(SETQ TERM (CAR E) E (CDR E))
	     (COND ((OR (NOT (OR (MTIMESP TERM) (MEXPTP TERM)))
			(EQUAL (SETQ D ($DENOM TERM)) 1))
		    (SETQ R (CONS TERM R))
		    (GO END)))
	     (SETQ NNU ($NUM TERM))
	     (AND $COMBINEFLAG (FIXP D) (SETQ XL (CONS TERM XL)) (GO END))
	     (DO ((Q LD (CDR Q)) (P LN (CDR P)))
		 ((NULL Q))
		 (COND ((ALIKE1 (CAR Q) D)
			(RPLACA P (CONS NNU (CAR P)))
			(RETURN (SETQ SW T)))))
	     (AND SW (GO SKIP))
	     (SETQ LD (CONS D LD) LN (CONS (NCONS NNU) LN))
	SKIP (SETQ SW NIL)
	END  (AND E (GO AGAIN))
	     (AND XL (SETQ XL (COND ((CDR XL) ($XTHRU (ADDN XL T)))
				    (T (CAR XL)))))
	     (MAPC 
	      #'(LAMBDA (NU DE) 
		        (SETQ R (CONS (MUL2 (ADDN NU NIL) (POWER* DE -1)) R)))
	      LN LD)
	     (RETURN (ADDN (IF XL (CONS XL R) R) NIL))))

(DECLARE (SPLITFILE FACOUT) (FIXNUM NUM))

(DEFMFUN $FACTOROUT NUM
  (PROG (E VL EL FL CL L F X)
	(SETQ E (ARG 1) VL (LISTIFY (- 1 NUM)))
	(AND (NULL VL)(MERROR "FACTOROUT called on only one argument"))
	(AND (NOT (MPLUSP E)) (RETURN E))
	(OR (NULL VL) (MPLUSP E) (RETURN E))
	(SETQ E (CDR E))
LOOP	(SETQ F (CAR E) E (CDR E))
	(AND (NOT (MTIMESP F))(SETQ F (LIST '(MTIMES) 1 F)))
	(SETQ FL NIL CL NIL)
	(DO I (CDR F) (CDR I) (NULL I)
	  (COND ((AND (NOT (NUMBERP (CAR I)))
		      (APPLY '$FREEOF (APPEND VL (NCONS (CAR I)))))
		 (SETQ FL (CONS (CAR I) FL)))
	        (T (SETQ CL (CONS (CAR I) CL)))))
	(AND (NULL FL) (SETQ EL (CONS F EL)) (GO END))
	(SETQ FL (COND ((CDR FL) (SIMPTIMES (CONS '(MTIMES) FL) 1 NIL))
			(T (CAR FL))))
	(SETQ CL (COND ((NULL CL) 1)
		       ((CDR CL) (SIMPTIMES (CONS '(MTIMES) CL) 1 T))
		       (T (CAR CL))))
	(SETQ X T) (DO I L (CDR I)(NULL I)
	(COND ((ALIKE1 (CAAR I) FL) (RPLACD (CAR I) (CONS CL (CDAR I))) (SETQ I NIL X NIL))))
       (AND X (SETQ L (CONS (LIST FL CL) L)))
END	(AND E (GO LOOP))
	(DO I L (CDR I) (NULL I)
	    (SETQ EL (CONS (SIMPTIMES (LIST '(MTIMES) (CAAR I)
				 ($FACTORSUM (SIMPLUS (CONS '(MPLUS) (CDAR I)) 1 NIL))) 1 NIL) EL)))
	(RETURN (ADDN EL NIL))))

(DECLARE (SPLITFILE SCREEN))
;; This splitfile contains primitives for manipulating the screen from MACSYMA
;; This stuff should just be stuck in STATUS.

;; $PAUSE(); does default --PAUSE--
;; $PAUSE("--FOO--") uses --FOO-- instead of --PAUSE
;; $PAUSE("--FOO--","--BAR--") is like above, but uses --BAR-- instead of
;;			       --CONTINUED--

(DECLARE (SPECIAL MOREMSG MORECONTINUE))

(DEFMFUN $PAUSE (&OPTIONAL (MORE-MSG MOREMSG) (MORE-CONTINUE MORECONTINUE))
   (LET ((MOREMSG (STRIPDOLLAR MORE-MSG))
	 (MORECONTINUE (STRIPDOLLAR MORE-CONTINUE)))
      (MORE-FUN NIL)
      '$DONE))

;; $CLEARSCREEN clears the screen.  It takes no arguments.

(DEFMFUN $CLEARSCREEN () (CURSORPOS 'C) '$DONE)

