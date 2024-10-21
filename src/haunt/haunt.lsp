; (LEFT-OUT/: MYTPLEVEL  <SAV> STARTER  TESTPPN <START/k>)
(DECLARE (SPECIAL <READ>-LINE/# READPROMPT/# RUNNING/# BAD-INPUT-ATN WMI HAUNTSFNS OLDDAY OLDRUN NAME-ATN)
         (*FEXPR TRACE-FUNCTION CONTINUE <SENTENCE> START)
         (*EXPR WM RUN LOAD-TEST)
         (MAPEX T)
         (FIXSW T))

; THE FOLLOWING DISABLES INTERRUPTS
(DEFUN READP NIL NIL)

(DEFUN <GT> (CONSTANT ELM) (AND (NUMBERP ELM) (> ELM (CAR CONSTANT))))

(DEFUN <LT> (CONSTANT ELM) (AND (NUMBERP ELM) (< ELM (CAR CONSTANT))))

;(DEFUN <TIME-INCR> FEXPR (L)
;  (PROG (EXTIME D1 D2 I1 time)
;        (SETQ EXTIME (EXPLODEC (CAR (SETQ L (APPLY 'EVAL-LIST L)))))
;        (SETQ D1 (READLIST (LIST (CAR EXTIME) (CADR EXTIME))))
;        (SETQ D2 (READLIST (LIST (CADDDR EXTIME) (CAR (CDDDDR EXTIME)))))
;        (SETQ D2 (+ D2 (CADR L)))
;        (SETQ I1 (// D2 60.))
;        (SETQ D2 (\ D2 60.))
;        (SETQ D1 (\ (+ D1 I1) 24.))
;        (RETURN (NCONS (READLIST (CONS '//
;                                       (APPEND (COND ((< D1 10.) (CONS '/0 (EXPLODE D1)))
;                                                     (T (EXPLODE D1)))
;                                               '(// /:)
;                                               (COND ((< D2 10.) (CONS '/0 (EXPLODE D2)))
;                                                     (T (EXPLODE D2))))))))))

(DEFUN <TIME-INCR> FEXPR (L)
  (PROG (EXTIME D1 D2 I1 time *nopoint ibase)
    (setq *nopoint t)
    (setq ibase 10.)
    (SETQ EXTIME (EXPLODEC (CAR (SETQ L (APPLY 'EVAL-LIST L)))))
    (setq d1 (readlist (list (nth 0 extime) (nth 1 extime))))
    (setq d2 (readlist (list (nth 3 extime) (nth 4 extime))))
    (SETQ D2 (+ D2 (CADR L)))
    (SETQ I1 (// D2 60.))
    (SETQ D2 (\ D2 60.))
    (SETQ D1 (\ (+ D1 I1) 24.))
    (setq time (format nil "~2,48d:~2,48d" d1 d2))
    (return (ncons (readlist (reverse (cdr (reverse (cdr (explode time))))))))))

(DEFUN <RAN> FEXPR (L) (LIST (RANDOM 9.)))

(DEFUN <WRONG> FEXPR (L) (<SENTENCE> BAD-INPUT-ATN))

(DEFUN <EXIT> FEXPR (L)
  (PROG NIL
   L1   (QUIT)
	(TERPRI)
        (PRINC '|Not to be continued.|)
        (TERPRI)
       (GO L1)))

;(DEFUN <EXIT> FEXPR (L)
;  (break l))

(DEFUN NEWSYS SLXN
  (PROG (SYSTEM-NAME STARTUP-FUNCTION)
        (SETQ SYSTEM-NAME (ARG 1.))
        (COND ((= SLXN 2.) (SETQ STARTUP-FUNCTION (ARG 2.))))
        (SUSPEND)
        (AND STARTUP-FUNCTION (FUNCALL STARTUP-FUNCTION))
        (RETURN 'READY)))

(DEFUN RANDPOS (LENGTH) (RANDOM LENGTH))

(DEFUN MANYPRINQ FEXPR (PL) (MAPC (FUNCTION (LAMBDA (PLONE) (PRINC PLONE))) PL))

(DEFUN FLATN (L)
  (COND ((ATOM L) L)
        ((ATOM (CAR L)) (CONS (CAR L) (FLATN (CDR L))))
        (T (APPEND (FLATN (CAR L)) (FLATN (CDR L))))))

(DEFUN TIN (WT)
  (COND ((ATOM WT) WT)
        ((NUMBERP (CAR WT)) (TIN (NTH (RANDPOS (CAR WT)) (CDR WT))))
        (T (CONS (TIN (CAR WT)) (TIN (CDR WT))))))

(DEFUN COMPILE-TEMPLATE (TMPLT)
  (PROG (TEMP)
        (RETURN (COND ((EQ (TYPEP TMPLT) 'LIST)
                       (COND ((EQ (CAR TMPLT) '/#)
                              (SETQ TEMP
                                    (MAPDEL (FUNCTION NUMBERP)
                                            (APPLY 'APPEND
                                                   (MAPCAR (FUNCTION (LAMBDA (DTMP)
                                                                       (SETQ DTMP (COMPILE-TEMPLATE DTMP))
                                                                       (COND ((EQ (TYPEP DTMP) 'LIST)
                                                                              DTMP)
                                                                             (T (NCONS DTMP)))))
                                                           (CDR TMPLT)))))
                              (CONS (LENGTH TEMP) TEMP))
                             ((EQ (CAR TMPLT) '%)
                              (SETQ TEMP (MAPCAR (FUNCTION COMPILE-TEMPLATE) (CDR TMPLT)))
                              (CONS (LENGTH TEMP) TEMP))
                             (T (CONS (COMPILE-TEMPLATE (CAR TMPLT)) (COMPILE-TEMPLATE (CDR TMPLT))))))
                      ((NULL TMPLT) NIL)
                      ((BOUNDP TMPLT) (COMPILE-TEMPLATE (EVAL TMPLT)))
                      (T TMPLT)))))

(DEFUN STRINGREAD NIL
  (PROG (STRLIST)
        (COND ((= (TYIPEEK) 13.) (TYI) (TERPRI) (RETURN NIL)))
        (SETQ STRLIST (NCONS (ASCII 124.)))
   LAB  (COND ((= (TYIPEEK) 13.) (TYI) (TYI) (RETURN (MAKNAM (NREVERSE (CONS (ASCII 124.) STRLIST)))))
              (T (SETQ STRLIST (CONS (ASCII (TYI)) STRLIST)) (GO LAB)))))

(DEFUN ADD-PHRASE (PHLN)
  (PROG (NPHS NPH)
        (SETQ NPHS NIL)
        (COND ((NOT (BOUNDP PHLN)) (SET PHLN '(%))))
   LAB  (PRINC '|Phrase/:|)
        (SETQ NPH (STRINGREAD))
        (COND (NPH (SETQ NPHS (CONS NPH NPHS)) (GO LAB))
              (T (SET PHLN (APPEND (EVAL PHLN) NPHS))))))

(DEFUN CHAT (ATL) (NTH (RANDPOS (LENGTH ATL)) ATL))

(DEFUN MAPDEL (PRED LST)
  (COND ((ATOM LST) LST)
        ((FUNCALL PRED (CAR LST)) (MAPDEL PRED (CDR LST)))
        (T (CONS (CAR LST) (MAPDEL PRED (CDR LST))))))

(DEFUN CAPITALIZE (WRD)
  (PROG (EWRD CHRNUM)
        (SETQ CHRNUM (GETCHARN WRD 2.))
        (RETURN (COND ((AND (> CHRNUM 96.) (< CHRNUM 123.))
                       (READLIST (APPEND (NCONS (ASCII 124.))
                                         (RPLACA (SETQ EWRD (EXPLODEC WRD))
                                                 (ASCII (- (CHRVAL (CAR EWRD)) 32.)))
                                         (NCONS (ASCII 124.)))))
                      (T WRD)))))

(DEFUN CHRVAL (X) (GETCHARN X 1.))

(DEFUN MY-STRING-APPEND FEXPR (STRINGS)
  (READLIST (APPEND (NCONS (ASCII 124.))
                    (DELETE (ASCII 124.)
                            (MAPCAN (FUNCTION (LAMBDA (STR)
                                                (EXPLODEC (COND ((OR (BOUNDP STR)
                                                                     (EQ (TYPEP STR) 'LIST))
                                                                 (EVAL STR))
                                                                (T STR)))))
                                    STRINGS))
                    (NCONS (ASCII 124.)))))

(DEFUN <SENTENCE> FEXPR (AN)
  (PROG (UNCS)
        (SETQ UNCS (FLATN (TIN (EVAL (CAR AN)))))
        (RETURN (NCONS (APPLY 'MY-STRING-APPEND (CONS (CAPITALIZE (CAR UNCS)) (CDR UNCS)))))))

(DEFUN <CAPTOSM> FEXPR (LN)
  (MAPCAR (FUNCTION (LAMBDA (WD)
                      (READLIST (APPEND (NCONS (ASCII 124.))
                                        (MAPCAR (FUNCTION (LAMBDA (CHR)
                                                            (COND ((AND (> CHR 64.) (< CHR 91.))
                                                                   (ASCII (+ CHR 32.)))
                                                                  (T (ASCII CHR)))))
                                                (MAPCAR (FUNCTION CHRVAL) (EXPLODE WD)))
                                        (NCONS (ASCII 124.))))))
          (APPLY 'EVAL-LIST LN)))

(DEFUN OPS-READ** NIL
  (PROG (INL IC)
        (PRINC '*)
        (SETQ INL NIL)
   LAB  (SETQ IC (TYI))
        (SETQ INL (CONS IC INL))
        (COND ;;((= IC #\return) (RETURN (NREVERSE (CONS 26. INL))))
              ((= IC 13.)  ; <CR>
               (RETURN (NREVERSE (CONS 26. INL))))
              ((MEMBER IC '(127. 8.)) (SETQ INL (CDDR INL)) (TYO 8.) (PRINC '| |) (TYO 8.))
              ((= IC 18.)
		(SETQ INL (CDR INL))
		(tyo 8)
		(tyo 8)
		(princ '|  |)
		(tyo 8)
		(tyo 8)
		(terpri)
		(mapc '(lambda (x) (princ (ascii x))) (reverse inl)))
;              ((= IC #\ctrl-t)
              ((= IC 24.) ; control-t)
               (SETQ INL (CDR INL))
		(tyo 8)
		(tyo 8)
               (PRINc '|DAY/: |)
               (DAY)
		(princ '| RUN/: |)
               (RUN)
               (PRINC '| RD/:0 WR/:0 HAUNT 243+85P TI  PC/:413102|)
               (TERPRI) (PRINC '|INPUT WAIT FOR TTY14|)
	(TERPRI))
	      ((= ic 21.) (setq inl nil) (princ '|^U|) (terpri))
              ((< IC 27.) (SETQ INL (CDR INL)))
              ((MEMBER IC '(124. 39.)) (SETQ INL (CDR INL))))
        (GO LAB)))

(DEFUN DAY NIL
  (PROG (MIN SEC CENTI-SEC)
        (SETQ CENTI-SEC
	      (- (- OLDDAY (SETQ OLDDAY (IFIX (*$ (TIME) 100.0))))))
        (SETQ MIN (// CENTI-SEC 6000.))
        (SETQ SEC (// (\ CENTI-SEC 6000.) 100.))
        (SETQ CENTI-SEC (\ CENTI-SEC 100.))
        (COND ((= MIN 0.) (PRINC SEC) (PRINC '|.|) (PRINC CENTI-SEC))
              (T
               (PRINC '/:)
               (COND ((NULL (CDR (EXPLODEN MIN))) (PRINC '/0)))
               (PRINC MIN)
               (PRINC '/:)
               (PRINC SEC)))))

(DEFUN RUN NIL
  (PROG (MICRO TEMP)
        (SETQ MICRO (- (- OLDRUN (SETQ OLDRUN (RUNTIME)))))
        (PRINC (// MICRO 1000000.))
        (PRINC '|.|)
        (SETQ TEMP (// MICRO 10000.))
        (COND ((NULL (CDR (SETQ TEMP (EXPLODEC TEMP))))
	       (SETQ TEMP (CONS '/0 TEMP))))
        (COND ((CDDR TEMP) (RPLACD (CDR TEMP) NIL)))
        (MAPC 'PRINC TEMP)))

(DEFUN BEGIN NIL
  (PROG NIL
        (START 'START)
        (LINEL T 79.)
	(SSTATUS TOPLEVEL
		'(COND((EQ (STATUS XUNAME) 'ejs)
			(print '*)
			(print (eval (read))))
		      (T (<exit>))))
	(NOINTERRUPT T)
        (and (filep uread) (close uread))
        (and (filep infile) (not (eq infile tyi)) (close infile))
        (setq infile 'T)
        (SUSPEND)
	(NOINTERRUPT T)
	(cond ((eq (status XUNAME) 'ejs) (nointerrupt nil)))
	(cond ((not (eq (status XUNAME) 'ejs))
		(SETQ UNBND-VRBL 'error-exit
		      UNDF-FNCTN 'error-exit
		      FAIL-ACT 'error-exit
        	      UNSEEN-GO-TAG 'error-exit
		      WRNG-TYPE-ARG 'error-exit
        	      WRNG-NO-ARGS 'error-exit
		      IO-LOSSAGE 'error-exit
			*RSET-TRAP 'error-exit
		      MACHINE-ERROR 'error-exit
		      GC-LOSSAGE 'error-exit
		      PDL-OVERFLOW 'error-exit)))
        (DO X (CADDR (STATUS DAYTIME)) (1- X) (< X 0.) (RANDOM))
        (SETQ OLDDAY (IFIX (*$ (TIME) 100.0)))
        (SETQ OLDRUN (RUNTIME))
        (LINEL T 79.)
        (CONTINUE 'XYZZY)))

(DEFUN XBEGIN NIL
  (PROG NIL
        (START 'START)
        (LINEL T 79.)
	(SSTATUS TOPLEVEL
		'(COND((EQ (STATUS XUNAME) 'ejs)
			(print '*)
			(print (eval (read))))
		      (T (<exit>))))
	(NOINTERRUPT T)
	(cond ((eq (status XUNAME) 'ejs) (nointerrupt nil)))
	(cond ((not (eq (status XUNAME) 'ejs))
		(SETQ UNBND-VRBL 'error-exit
		      UNDF-FNCTN 'error-exit
		      FAIL-ACT 'error-exit
        	      UNSEEN-GO-TAG 'error-exit
		      WRNG-TYPE-ARG 'error-exit
        	      WRNG-NO-ARGS 'error-exit
		      IO-LOSSAGE 'error-exit
			*RSET-TRAP 'error-exit
		      MACHINE-ERROR 'error-exit
		      GC-LOSSAGE 'error-exit
		      GC-OVERFLOW 'error-exit
		      PDL-OVERFLOW 'error-exit)))
        (DO X (CADDR (STATUS DAYTIME)) (1- X) (< X 0.) (RANDOM))
        (SETQ OLDDAY (IFIX (*$ (TIME) 100.0)))
        (SETQ OLDRUN (RUNTIME))
        (LINEL T 79.)
        (CONTINUE 'XYZZY)))

(defun error-exit (x) (<exit>))

