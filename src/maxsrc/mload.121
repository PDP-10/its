;;; -*- Mode: Lisp; Package: Macsyma -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;       (c) Copyright 1982 Massachusetts Institute of Technology       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module mload)

;; I decided to move most of the file hacking utilities I used in TRANSL to
;; this file. -GJC

;; Concepts:
;; Lisp_level_filename. Anything taken by the built-in lisp I/O primitives.
;;
;; User_level_filename. Comes through the macsyma reader, so it has an extra "&"
;;   in the pname in the case of "filename" or has extra "$" and has undergone
;;   ALIAS transformation in the case of 'FOOBAR or '[FOO,BAR,BAZ].
;;
;; Canonical_filename. Can be passed to built-in lisp I/O primitives, and
;;   can also be passed back to the user, is specially handled by the DISPLAY.
;;
;; Functions:
;; $FILENAME_MERGE. Takes User_level_filename(s) and Canonical_filename(s) and
;;   merges them together, returning a Canonical_filename.
;;
;; TO-MACSYMA-NAMESTRING. Converts a Lisp_level_filename to a Canonical_filename
;;
;; $FILE_SEARCH ............ Takes a user or canonical filename and a list of types of
;;                           applicable files to look for.
;; $FILE_TYPE   ............. Takes a user or canonical filename and returns
;;                            NIL, $MACSYMA, $LISP, or $FASL.
;; CALL-BATCH1 ............. takes a canonical filename and a no-echop flag.

;; Note: This needs to be generalized some more to take into account
;; the lispmachine situation of access to many different file systems
;; at the same time without, and also take into account the way it presently
;; deals with that situation. The main thing wrong now is that the file-default
;; strings are constants.

;; What a cannonical filename is on the different systems:
;; This is for informational purposes only, as the Macsyma-Namestringp
;; predicate is provided.
;; [PDP-10 Maclisp] An uninterned symbol with various properties.
;; [Franz Lisp] a string or a symbol (whose print name is used).
;; [Multics Maclisp] A STRING.
;; [LispMachine] A generic pathname object, which is a system-provided FLAVOR.
;; [NIL] Not decided yet, but a STRING should do ok, since in NIL files are
;; a low-level primitive, and programs, modules, and environments are the
;; practical abstraction used. No attempt is made to come up with ad-hoc generalizations
;; of the ITS'ish and DEC'ish filenames, as such attempts fail miserably to provide
;; the functionality of filesystems such as on Multics.

(DECLARE (SPECIAL $FILE_SEARCH $FILE_TYPES))

(DEFMFUN $LISTP_CHECK (VAR VAL)
  "Gives an error message including its first argument if its second
  argument is not a LIST"
  (OR ($LISTP VAL)
      (MERROR "The variable ~:M being set to a non-LISTP object:~%~M"
	      VAR VAL)))

(DEFPROP $FILE_SEARCH $LISTP_CHECK ASSIGN)

(DEFPROP $FILE_TYPES $LISTP_CHECK ASSIGN)

#-Franz
(DEFMFUN $FILE_SEARCH (X &OPTIONAL
			 (LISTP NIL)
			 (L $FILE_TYPES))
  (SETQ X ($FILENAME_MERGE X))
  (IF ($LISTP L) (SETQ L (CDR L))
      (MERROR "3'rd arg to FILE_SEARCH not a list.~%~M" L))
  (DO ((MERGE-SPECS (CONS ($filename_merge)
			  ;; Get a complete "star filename"
			  (CDR $FILE_SEARCH))
		    (CDR MERGE-SPECS))
       (PROBED)
       (FOUND))
      ((NULL MERGE-SPECS)
       (IF LISTP
	   `((MLIST) ,@(NREVERSE FOUND))
	   (MERROR "Could not find file which matches ~M" X)))
    (IF (DO ((L L (CDR L))
	     (U ($FILENAME_MERGE (CAR MERGE-SPECS))))
	    ((NULL L) NIL)
	  (IF (SETQ PROBED (PROBEF ($FILENAME_MERGE X U (CAR L))))
	      (IF LISTP
		  (PUSH (TO-MACSYMA-NAMESTRING PROBED) FOUND)
		  (RETURN T))))
	(RETURN (TO-MACSYMA-NAMESTRING PROBED)))))

;; filename merging is unheard of on Unix.
;; If the user doesn't supply a file extension, we look for .o, .l and .v
;; and finally the file itself.  If the user supplies one of the standard
;; extensions, we just use that.
#+Franz
(defmfun $file_search (x &optional (listp nil) (l $file_types))
   (let ((filelist (cond ((cdr $file_search))
			 (t '("."))))
	 (extlist (cond ((member (substring x -2) '(".o" ".l" ".v"))
			 '(nil))
			(t '(".o" ".l" ".v" nil)))))
      (do ((dir filelist (cdr dir))
	   (ret))
	  ((null dir)
	   (cond (listp '((mlist)))
		     (t (MERROR "Could not find file ~M" X))))
	  (cond ((setq ret
		       (do ((try extlist (cdr try))
			    (this))
			   ((null try))
			   (setq this (cond ((null (car try)) x)
					    (t (concat x (car try)))))
			   (cond ((not (equal "." (car dir)))
				  (setq this (concat (car dir) "//" this))))
			   (cond ((probef this)
				  (return
				     (cond (listp `((mlist)
						    ,(to-macsyma-namestring x)))
						(t (to-macsyma-namestring this))))))))
		 (return ret))))))

			
(DECLARE (SPECIAL $LOADPRINT))

(DEFMFUN LOAD-AND-TELL (FILENAME)
  (LOADFILE FILENAME
	    T ;; means this is a lisp-level call, not user-level.
	    $LOADPRINT))

#+PDP10
(PROGN 'COMPILE
;; on the PDP10 cannonical filenames are represented as symbols
;; with a DIMENSION-LIST property of DISPLAY-FILENAME.

(DEFUN DIMENSION-FILENAME (FORM RESULT)
  (DIMENSION-STRING (CONS #/" (NCONC (EXPLODEN FORM) (LIST #/"))) RESULT))

(DEFUN TO-MACSYMA-NAMESTRING (X)
  ;; create an uninterned symbol, uninterned so that
  ;; it will be GC'd.
  (SETQ X (PNPUT (PNGET (NAMESTRING X) 7) NIL))
  (PUTPROP X 'DIMENSION-FILENAME 'DIMENSION-LIST)
  X)

(DEFUN MACSYMA-NAMESTRINGP (X)
  (AND (SYMBOLP X) (EQ (GET X 'DIMENSION-LIST) 'DIMENSION-FILENAME)))

(DEFMACRO ERRSET-NAMESTRING (X)
  `(LET ((ERRSET NIL))
     (ERRSET (NAMESTRING ,X) NIL)))

(DEFMFUN $FILENAME_MERGE N
  (DO ((F "" (MERGEF (MACSYMA-NAMESTRING-SUB (ARG J)) F))
       (J N (1- J)))
      ((ZEROP J)
       (TO-MACSYMA-NAMESTRING F))))
)

#+Franz
(progn 'compile

;; a first crack at these functions

(defun to-macsyma-namestring (x)
   (cond ((macsyma-namestringp x) x)
	 ((symbolp x)
	  (cond ((memq (getcharn x 1) '(#/& #/$))
		 (substring (get_pname x) 2))
		(t (get_pname x))))
	 (t (merror "to-macsyma-namestring: non symbol arg ~M~%" x))))

(defun macsyma-namestringp (x)
   (stringp x))

;;--- $filename_merge
; may not need this ask filename merging is not done on Unix systems.
;
(defmfun $filename_merge (&rest files)
   (cond (files (filestrip (ncons (car files))))))
)

#+MULTICS
(PROGN 'COMPILE
(DEFUN TO-MACSYMA-NAMESTRING (X) 
  (cond ((macsyma-namestringp x) x)
	((symbolp x) (substring (string x) 1))
	((listp x) (namestring x))
	(t x)))

(DEFUN MACSYMA-NAMESTRINGP (X) (STRINGP X))
(DEFUN ERRSET-NAMESTRING (X)
  (IF (ATOM X) (NCONS (STRING X)) (ERRSET (NAMESTRING X) NIL)))

(DEFMFUN $FILENAME_MERGE (&REST FILE-SPECS)
  (SETQ FILE-SPECS (cond (file-specs 
			  (MAPCAR #'MACSYMA-NAMESTRING-SUB FILE-SPECS))
			 (t '("**"))))
  (TO-MACSYMA-NAMESTRING (IF (NULL (CDR FILE-SPECS))
			     (CAR FILE-SPECS)
			     (APPLY #'MERGEF FILE-SPECS))))

)

#+LISPM
(PROGN 'COMPILE
(DEFUN TO-MACSYMA-NAMESTRING (X)
  (FS:PARSE-PATHNAME X))
(DEFUN MACSYMA-NAMESTRINGP (X)
  (TYPEP X 'FS:PATHNAME))
(DEFUN ERRSET-NAMESTRING (X)
  (LET ((ERRSET NIL))
    (ERRSET (FS:PARSE-PATHNAME X) NIL)))

(DEFMFUN $FILENAME_MERGE (&REST FILE-SPECS)
  (DO ((F "" (FS:MERGE-PATHNAME-DEFAULTS (MACSYMA-NAMESTRING-SUB
					   (NTH (1- J) FILE-SPECS))
					 F))
       (J (LENGTH FILE-SPECS) (1- J)))
      ((ZEROP J)
       (TO-MACSYMA-NAMESTRING F))))
)

(DEFUN MACSYMA-NAMESTRING-SUB (USER-OBJECT)
  (IF (MACSYMA-NAMESTRINGP USER-OBJECT) USER-OBJECT
      (LET* ((SYSTEM-OBJECT
	      (COND ((ATOM USER-OBJECT)
		     (FULLSTRIP1 USER-OBJECT))
		    (($LISTP USER-OBJECT)
		     (FULLSTRIP (CDR USER-OBJECT)))
		    (T
		     (MERROR "Bad file spec:~%~M" USER-OBJECT))))
	     (NAMESTRING-TRY (ERRSET-NAMESTRING SYSTEM-OBJECT)))
	(IF NAMESTRING-TRY (CAR NAMESTRING-TRY)
	    ;; know its small now, so print on same line.
	    (MERROR "Bad file spec: ~:M" USER-OBJECT)))))

(DEFMFUN open-out-dsk (x)
  (open x #-LISPM '(out dsk ascii block)
	  #+LISPM '(:out :ascii)))
(DEFMFUN open-in-dsk (x)
  (open x #-LISPM '(in dsk ascii block)
	  #+LISPM '(:in :ascii)))

#-MAXII
(PROGN 'COMPILE

(DECLARE (SPECIAL DSKFNP OLDST ST $NOLABELS REPHRASE))

(DEFMFUN CALL-BATCH1 (FILENAME ^W)
  (LET ((^R (AND ^R (NOT ^W)))
	($NOLABELS T)
	($CHANGE_FILEDEFAULTS)
	(DSKFNP T)
	(OLDST)
	(ST))
    ;; cons #/& to avoid the double-stripdollar problem.
    (BATCH1 (LIST (MAKNAM (CONS #/& (EXPLODEN FILENAME))))
	    NIL
	    NIL
	    #-Franz T
	    #+Franz nil)
    (SETQ REPHRASE T)))


(DEFMVAR *IN-$BATCHLOAD* NIL
  "I should have a single state variable with a bit-vector or even a list
  of symbols for describing the state of file translation.")
(DEFMVAR *IN-TRANSLATE-FILE* NIL "")
(DEFMVAR *IN-MACSYMA-INDEXER* NIL)

(DEFUN TRANSLATE-MACEXPR (FORM &optional FILEPOS)
       (COND (*IN-TRANSLATE-FILE*
	      (TRANSLATE-MACEXPR-ACTUAL FORM FILEPOS))
	     (*in-macsyma-indexer*
	      (outex-hook-exp form))
	     (T
	      (LET ((R (ERRSET (MEVAL* FORM))))
		   (COND ((NULL R)
			  (LET ((^W NIL))
			       (MERROR "~%This form caused an error in evaluation:~
				       ~%~:M" FORM))))))))


(DEFMFUN $BATCHLOAD (FILENAME)
  (LET ((WINP NIL)
	(NAME ($FILENAME_MERGE FILENAME))
	(*IN-$BATCHLOAD* T))
    (IF $LOADPRINT
	(MTELL "~%Batching the file ~M~%" NAME))
    (UNWIND-PROTECT
     (PROGN (CALL-BATCH1 NAME T)
	    (SETQ WINP T)
	    NAME)
     ;; unwind protected.
     (IF WINP
	 (IF $LOADPRINT (MTELL "Batching done."))
	 (MTELL "Some error in loading this file: ~M" NAME)))))

;; end of moby & crufty #-MAXII
)

#+MAXII
(DEFMFUN $BATCHLOAD (FILENAME)
  (LET ((EOF (LIST NIL))
	(NAME ($FILENAME_MERGE FILENAME))
	(*MREAD-PROMPT* "(Batching) "))
    (IF $LOADPRINT
	(MTELL "~%Batching the file ~M~%" NAME))
    (WITH-OPEN-FILE (STREAM NAME '(:IN :ASCII))
      (DO ((FORM NIL (MREAD STREAM EOF)))
	  ((EQ FORM EOF)
	   (IF $LOADPRINT (MTELL "Batching done."))
	   '$DONE)
	(MEVAL* (CADDR FORM))))))


(DEFMFUN $LOAD (MACSYMA-USER-FILENAME
		&AUX
		(FILENAME ($FILENAME_MERGE MACSYMA-USER-FILENAME)))
  "This is the generic file loading function.
  LOAD(/"filename/") will either BATCHLOAD or LOADFILE the file,
  depending on wether the file contains Macsyma, Lisp, or Compiled
  code. The file specifications default such that a compiled file
  is searched for first, then a lisp file, and finally a macsyma batch
  file. This command is designed to provide maximum utility and
  convenience for writers of packages and users of the macsyma->lisp
  translator."
  (LET* ((SEARCHED-FOR ($FILE_SEARCH FILENAME))
	 (TYPE ($FILE_TYPE SEARCHED-FOR)))
    (CASEQ TYPE
      (($MACSYMA)
       ($BATCHLOAD SEARCHED-FOR))
      (($LISP $FASL)
       ;; do something about handling errors
       ;; during loading. Foobar fail act errors.
       (LOAD-AND-TELL SEARCHED-FOR))
      (T
       (MERROR "MACSYMA BUG: Unknown file type ~M" TYPE)))
    SEARCHED-FOR
    ))

#+Multics
(DEFMFUN $FILE_TYPE (FILE)
  (SETQ FILE ($FILENAME_MERGE FILE))
  (IF (NULL (PROBEF FILE)) NIL
      (CASEQ (CAR (LAST (NAMELIST FILE)))
	((MACSYMA) '$MACSYMA)
	((LISP) '$LISP)
	(T '$FASL))))

#-MULTICS
(DEFMFUN $FILE_TYPE (FILENAME &AUX STREAM)
  (SETQ FILENAME ($FILENAME_MERGE FILENAME))
  (COND ((NULL (PROBEF FILENAME))
	 NIL)
#-Franz ((FASLP FILENAME)
	 '$FASL)
#+Franz ((cdr (assoc (substring filename -2)
		     '((".l" . $lisp) (".o" . $fasl) (".v" . $macsyma)))))
	('ELSE
	 ;; This has to be simple and small for greatest utility
	 ;; as an in-core pdp10 function.
	 (UNWIND-PROTECT
	  (DO ((C (PROGN (SETQ STREAM (OPEN-IN-DSK FILENAME))
			 #\SP)
		  (TYI STREAM -1)))
	      ((NOT (MEMBER C '(#\SP #\TAB #\CR #\LF #\FF)))
	       ;; heuristic number one,
	       ;; check for cannonical language "comment." as first thing
	       ;; in file after whitespace.
	       (COND ((MEMBER C '(-1 #/;))
		      '$LISP)
		     ((AND (= C #//)
			   (= (TYI STREAM -1) #/*))
		      '$MACSYMA)
	   #+Franz   ((eq c 7)		;; fasl files begin with bytes 7,1
		      '$fasl)		;; but just seeing 7 is good enough
		     ('ELSE
		      ;; the above will win with all Lisp files written by
		      ;; the macsyma system, e.g. the $SAVE and
		      ;; $TRANSLATE_FILE commands, all lisp files written
		      ;; by macsyma system programmers, and anybody else
		      ;; who starts his files with a "comment," lisp or
		      ;; macsyma.
		      (FILEPOS STREAM 0)
		      ;; heuristic number two, see if READ returns something
		      ;; evaluable.
		      (LET ((FORM (LET ((ERRSET NIL))
				    ;; this is really bad to do since
				    ;; it can screw the lisp programmer out
				    ;; of a chance to identify read errors
				    ;; as they happen.
				    (ERRSET (READ STREAM NIL) NIL))))
			(IF (OR (NULL FORM)
				(ATOM (CAR FORM)))
			    '$MACSYMA
			    '$LISP))))))
	  ;; Unwind protected.
	  (IF STREAM (CLOSE STREAM))))))

#+LISPM
(defun faslp (filename)
  ;; wasteful to be opening file objects so many times, one for
  ;; each predicate and then again to actually load. Fix that perhaps
  ;; by having the predicates return "failure-objects," which can be
  ;; passed on to other predicates and on to FS:FASLOAD-INTERNAL and
  ;; FS:READFILE-INTERNAL.
  (with-open-file (stream filename '(:read :fixnum))
    (funcall stream ':qfaslp)))

(DEFMVAR $FILE_SEARCH
  #+ITS
  `((MLIST)
    ,@(MAPCAR #'TO-MACSYMA-NAMESTRING
	      '("DSK:SHARE;" "DSK:SHARE1;" "DSK:SHARE2;" "DSK:SHAREM;")))
  #+Franz
  `((mlist)
    ,@(mapcar #'to-macsyma-namestring
	       `("."
		 ,(concat vaxima-main-dir "//share")
		 ,(concat vaxima-main-dir "//demo"))))
    
  #+LISPM
  `((MLIST)
    ,@(MAPCAR #'TO-MACSYMA-NAMESTRING
	      '("MC:LMMAXR;" "MC:LMMAXQ;")))
  #+Multics
  '((MLIST))
  "During startup initialized to a list of places the LOAD function
  should search for files."
  )

#+Multics
(PROGN 'COMPILE
;; We need an abstract entry in this list to indicate "working_dir".
(DEFMFUN INITIATE-FILE-SEARCH-LIST ()
  (LET ((WHERE-AM-I (CAR (NAMELIST EXECUTABLE-DIR))))
    (SETQ 
     $FILE_SEARCH 
     `((MLIST) 
       ,@(mapcar #'to-macsyma-namestring
	   `(,(string-append (PATHNAME-UTIL "hd") ">**")
	     ,(string-append (NAMESTRING `(,WHERE-AM-I "share")) ">**")
	     ,(string-append (NAMESTRING `(,WHERE-AM-I "executable"))
			     ">**")))))))

;; These forms getting evaluated at macsyma start-up time.
(if (boundp 'macsyma-startup-queue)
    (PUSH '(INITIATE-FILE-SEARCH-LIST) MACSYMA-STARTUP-QUEUE)
    (setq macsyma-startup-queue '((initiate-file-search-list))))

;; Done for debuggings sake.
(eval-when (eval load)
  (initiate-file-search-list))

)

#-LISPM
(DEFMVAR $FILE_TYPES
  `((MLIST)
    ,@(MAPCAR #'TO-MACSYMA-NAMESTRING
	      #+ITS
	      ;; ITS filesystem. Sigh. This should be runtime conditionalization.
	      '("* FASL" "* TRLISP" "* LISP" "* >")
	      #+MULTICS
	      '("**" "**.lisp" "**.macsyma")))
  "The types of files that can be loaded into a macsyma automatically")
#+LISPM
(DEFMVAR $FILE_TYPES '((MLIST) "* FASL" "* TRLISP" "* LISP" "* >"))

(defmfun mfilename-onlyp (x)
  "Returns T iff the argument could only be reasonably taken as a filename."
  (cond ((macsyma-namestringp x) t)
	(($listp x) t)
	((symbolp x)
	 (= #/& (getcharn x 1)))
	('else
	 nil)))

