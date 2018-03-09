;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module tlimit)
(load-macsyma-macros rzmac)

;; TOP LEVEL FUNCTION(S): $TLIMIT $TLDEFINT

(DECLARE (GENPREFIX TL)
	 (*LEXPR $LIMIT)
	 (SPECIAL $TLIMSWITCH TAYLORED EXP VAR VAL LL UL
		  SILENT-TAYLOR-FLAG)) 

(DEFMFUN $TLIMIT NARGS 
       ((LAMBDA ($TLIMSWITCH) (APPLY '$LIMIT (LISTIFY NARGS))) T)) 

(DEFMFUN $TLDEFINT (EXP VAR LL UL) 
       ((LAMBDA ($TLIMSWITCH) ($LDEFINT EXP VAR LL UL)) T))

(DEFUN TLIMP (EXP) ; TO BE EXPANDED TO BE SMARTER (MAYBE)
       T) 

(DEFUN TAYLIM (E *I*) 
  (PROG (EX)
	(SETQ EX (*CATCH 'TAYLOR-CATCH
			 (let ((SILENT-TAYLOR-FLAG t))
			   ($TAYLOR E VAR (RIDOFAB VAL) 1.))))
	(OR EX (RETURN (COND ((EQ *I* T) (LIMIT1 E VAR VAL))
			     ((EQ *I* 'THINK) (COND ((MEMQ (CAAR EXP)
							   '(MTIMES MEXPT))
						     (LIMIT1 E VAR VAL))
						    (T (SIMPLIMIT E VAR VAL))))
			     (T (SIMPLIMIT E VAR VAL)))))
	(RETURN
	 (let ((TAYLORED t))
	   (LIMIT
	    (SIMPLIFY
	     ($logcontract ($RATDISREP ex)))
	    ;;(COND ((EQ (CADR EX) 'PS)
	    ;;       (CONS (CAR EX)
	    ;;             (LIST 'PS (THIRD EX) (FOURTH EX)
	    ;;                   (FIFTH EX))))
	    ;;      (t (EX)))
	    VAR
	    VAL
	    'THINK)))))

(DECLARE (UNSPECIAL TAYLORED EXP VAR VAL LL UL)) 
