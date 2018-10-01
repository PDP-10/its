;;;   DUMPAR			 	  		  -*-LISP-*-
;;;   **************************************************************
;;;   ***** MACLISP ****** LOADARRAYS AND DUMPARRAYS ***************
;;;   **************************************************************
;;;   ** (C) COPYRIGHT 1981 MASSACHUSETTS INSTITUTE OF TECHNOLOGY **
;;;   ****** THIS IS A READ-ONLY FILE! (ALL WRITES RESERVED) *******
;;;   **************************************************************

(herald DUMPAR /8)

(DECLARE (SPECIAL AFILE EOFP))

(DEFUN LOADARRAYS (AFILE)
  (PROG (FILE ARRAYS-LIST EOFP CNT L M FILENAME NEWNAME)
    (DECLARE (FIXNUM CNT M))
    (SETQ FILE (OPEN AFILE '(IN BLOCK FIXNUM)))
    (EOFFN FILE 'LOADARRAYS-FILE-TRAP)
    (*CATCH 'LOADARRAYS 
	    (PROG () 
	     1A	(SETQ EOFP T M (IN FILE))
	        (COND ((= M #o14060301406)
		         ;Stop on a word of ^C's, for compatibility with OLDIO 
		       (*THROW 'LOADARRAYS () )))
		(SETQ CNT (logand M #o777777))
		  ;Number of wds in pname for array
		(OR (= CNT (logand (- (LSH M -18.)) #o777777))
		    (ERROR FILE '|FILE NOT IN DUMPARRAYS FORMAT|))
		(SETQ EOFP NIL NEWNAME (GENSYM) L NIL)
	     LP	(COND ((NOT (MINUSP (SETQ CNT (1- CNT)))) 
		       (SETQ L (CONS (IN FILE) L))
		       (GO LP)))
		(SETQ FILENAME (PNPUT (NREVERSE L) T))
		(SETQ CNT (IN FILE)
		      M (logand CNT #o777777) 			;Type for array
		      CNT (logand (- (LSH CNT -18.)) #o777777))	;Total # of wds
		(*ARRAY NEWNAME 
			(COND ((= M 1) 'FIXNUM) ((= M 2) 'FLONUM) (T NIL)) 
			CNT)
		(FILLARRAY NEWNAME FILE)
		(SETQ ARRAYS-LIST 
		      (CONS (LIST NEWNAME FILENAME CNT)
			    ARRAYS-LIST))
		(GO 1A)))
	  (CLOSE FILE)
	  (RETURN (NREVERSE ARRAYS-LIST))))

(DEFUN LOADARRAYS-FILE-TRAP (X)
    (COND (EOFP (*THROW 'LOADARRAYS () ))
	  (T (ERROR '|FILE NOT IN DUMPARRAYS FORMAT|
		    (CONS 'LOADARRAYS AFILE) 'IO-LOSSAGE))))



(defun DUMPARRAYS (ars x)
  (let ((afile (open (mergef '((*) _LISP_ _DUMP_) x) '(OUT BLOCK FIXNUM))))
    (mapc #'DUMP1ARRAY ars)
    (renamef afile x)))


(DEFUN DUMP1ARRAY (AR)
  (PROG (LN PNLIST AD)
	(DECLARE (FIXNUM LN))
	(SETQ LN (LENGTH (SETQ PNLIST (PNGET AR 7)))
	      AD (ARRAYDIMS AR))
	(OUT AFILE (logior LN (LSH (- LN) 18.)))	;OUTPUT LENGTH OF PNAME
	(SETQ LN (APPLY '* (CDR AD)))
      A	(COND (PNLIST (OUT AFILE (CAR PNLIST))		;OUTPUT WDS OF PNAME
		      (SETQ PNLIST (CDR PNLIST)) 
		      (GO A)))
	(OUT AFILE (logior (LSH (- LN) 18.)		;KEY WD
			   (COND ((EQ (CAR AD) 'FIXNUM) 1)
				 ((EQ (CAR AD) 'FLONUM) 2)
				 (T 0))))
	(FILLARRAY AFILE AR)))

