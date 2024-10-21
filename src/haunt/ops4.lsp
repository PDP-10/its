
;		OPS4.MCL -- (Maclisp) interpreter for OPS4
;
;		Copyright (C) 1979 Charles L. Forgy
;				   Pittsburgh, Pennsylvania
;
; Reproduction of this program for noncommercial purposes is
; permitted.  No copy of any part of the program text shall be
; made unless the copy contains this notice of copyright.

(COMMENT --CONTENTS-- INTERSECT COPY CONSP MYERR READP TIME-GCTIME
         GELM PRINTLINE PRINTLINE* PRINTLINEC PRINTLINEC* WITHIN
         ENCODE ENCODE-VAR-TYPE NEWNODE SYSTEM COMPILE-AND-UPDATE
         MATRIX EXCISE-P KILL-NODE COMPILE-PRODUCTION CMP-P DOPE-PART
         RHS-PART MAKE-VAR-DOPE CMP-LHS NOTP CMP-NOT CMP-PRIN-FORM
         BUILD-BETA PROTOMEM FUDGE FUDGE* FULL-NAME ROOT-NAME VAR-ASSQ
         CMP-CEA* CMP-CONDITION CMP-CE* CMP-CEA CMP-CE CMP-VAR
         CMP-P-VAR CMP-N-VAR CMP-NEW-P-VAR CMP-OLD-P-VAR CMP-P-N-VAR
         MAKE-VIN-TEST MAKE-VL-VECTOR VARIABLE-TYPE VARIABLEP POSVARP
         CONSTANTP CMP-CONSTANT USERDEFP PREDICATE CMP-USERDEF
         REGULARLISTP CMP-LIST RESET-POSITION NESTING-LEVEL NEST
         UNNEST LOC-LOOP CURRENT-POSITION MAKE-BOTTOM-NODE
         PLACE-FIRST-NODE STORE-NODE RESET-NODE-STORAGE PLACE-NODES
         PLACE-NODES* PLACE-NODES** LINK-NEW-NODE-BOTH
         LINK-NEW-NODE-LEFT LINK-NEW-NODE-RIGHT LINK-NEW-NODE
         FIND-EQUIV-NODE EQUIV EQUIV1 EQUIV2 EQUIV2NOVAR
         ATTACH-NODE-RIGHT ATTACH-NODE-LEFT RIGHT-OUTS LEFT-OUTS
         ASSEMBLE-NODE MEMORY-PART NAME-PART DENY REAL-DENY REFRESH
         REAL-REFRESH ASSERT REASSERT REAL-ASSERT BUILD-ASSERT MAPWM
         WM WM-CNTS* PP-WM REMOVE-FROM-WM CREATION-TIME PRESENTP
         FIND-EQUAL-WME ADD-TOKEN REAL-ADD-TOKEN REMOVE-OLD
         REMOVE-OLD-NUM REMOVE-OLD-NO-NUM SIMILAR-TOKENP NEXT
         FIRST-ATOM DELETE-OLDS VARIABLE LEVEL1 LEVEL2 TRACEP TRACER
         TRACER* UNTRACER START-OPTIONS START DO-START CONTINUE
         SWITCHES SWASSOC SWNUMBER CYCLE-COUNT ACTION-COUNT RESTART-P
         MAIN PRINT-TIMES PM-SIZE AUTOMATIC-DELETE MATCH &BUS &ATOM
         &LEN &LEN+ &USER &VIN &P &OLD &TWO &MEM FIND-PREDICATE
         DO-TEST &VNO &VEX DO&VEX &NOT DO&NOT SENDTO EVAL-NODELIST
         REMOVECS INSERTCS DSORT CONFLICT-RESOLUTION BEST-OF BEST-OF*
         REMOVE-FROM-CONFLICT-SET CONFLICT-SET-COMPARE
         PNAME-INSTANTIATION ORDER-PART INSTANTIATION NUMCOMP
         UPDATE-RECENCY INTERSECTQ <READ> <WRITE> <WRITE&> <ADD>
         <DELETE> <REASSERT> <NULL> <EXCISE> <BUILD> MAKE-NEW-P-NAME
         <READP> BUILDIT <BIND> <QUOTE> <HALT> <EVAL> EVAL-RHS
         EVAL-RHS-INIT EVAL-LIST OPS-VARIABLE-VALUE EVAL-ELEM FLATTEN
         COPY1L RHS-FUNCTION OPS-READ OPS-READ* OPS-READ** PR EXCISER
         EDITR EQUAL-LHS INITIALIZE-GLOBAL-VARIABLES SAVEIT)


;;; Definitions

(DECLARE (SETQ IBASE 10.))

(DECLARE (FIXSW T)
         (MAPEX T))

;* try also: (setq nfunvars t) (noargs t)

(DECLARE (SPECIAL SENDTOCALL* BUILD-FLAG* ADD-LIST* DELETE-LIST*
          REFRESHED-WMES* REASSERT-LIST* REFRESH-LHS-FLAG* CURRENT-WM*
          NEW-FLAG* WMPART-LIST* WM* ACTION-COUNT* CURRENT-TOKEN*
          FIRST-NODE* NEXT-LOCVEC* MAX-LOCVEC* REG3* REG4* REG5* REG1*
          REG2* REG0* ATOM-PRIORITY* LENGTH-PRIORITY* PCOUNT*
          LAST-NAME* LAST-MATRIX* CREATION-TIME* SPECIAL-CASE-NUMBER*
          CONSTANT-COUNT* KEEP-LHS* POS-VAR-POSN* NEG-VAR-POSN*
          LAST-NODE* SEGMENT-FLAG* LAST-LENGTH* LOCATION-VECTOR*
          VIRTUAL-NODE-COUNT* FEATURES* REAL-FEATURES*
          REAL-NODE-COUNT* TRACE-FUNCTION* CYCLE-COUNT* TRACED-RULES*
          PNODE* TOTAL-WM* MAX-WM* TOTAL-CS* MAX-CS* TOTAL-TOKEN*
          MAX-TOKEN* RUNNING* HALT-FLAG* PHASE* TOTAL-TIME*
          NEXT-DELETE-TIME* MAXIMUM-AGE* ALPHA-FLAG-PART*
          ALPHA-DATA-PART* PM-NAMES* CONFLICT-SET* 
          BUILD-FUNCTION* LAST-GENBIND* VARIABLE-MEMORY* SEGMENT*
          VARIABLE-DOPE* DATA-MATCHED* FOUND-BINDING* FLAG-PART*
          DATA-PART* SIDE* TE-TRACE-FUNCTION* READPROMPT* <READ>-LINE*
          VAR-FNS* RESTART* INSTANCE*))

(DECLARE (*FEXPR PRINL))

(DECLARE (NOTYPE (GELM FIXNUM NOTYPE)))


;;; Utility functions
; Intersect two lists using EQ for the equality test

(DEFUN INTERSECT (X Y)
  (COND ((ATOM X) NIL)
        ((MEMQ (CAR X) Y) (CONS (CAR X) (INTERSECT (CDR X) Y)))
        (T (INTERSECT (CDR X) Y)))) 

(DEFMACRO COPY (X) `(SUBST NIL NIL ,X)) 

(DEFMACRO CONSP (X) `(NOT (ATOM ,X))) 

(DEFUN MYERR (X Y) (ERROR Y X)) 

;  READP returns T if there is anything in the input buffer
;  Dont ask how it works -- it is a total hack 

(DEFUN READP NIL
  (PROG (WEDGE)
        (SETQ WEDGE (TYIPEEK))
   TOP  (COND ((< (LISTEN) 2.) (RETURN NIL))
              ((= (TYIPEEK) 13.) (TYI) (GO TOP))
              (T (RETURN T))))) 

(DEFUN TIME-GCTIME NIL (- (RUNTIME) (STATUS GCTIME))) 

(ARRAY LOCVEC T 501.)

(DEFUN GELM (LOC X)
  (PROG (VEC)
        (COND ((< LOC 1.)
               (COND ((= LOC -1.) (RETURN REG1*))
                     ((= LOC -2.) (RETURN REG2*))
                     ((= LOC 0.) (RETURN REG0*))
                     ((= LOC -3.) (RETURN REG3*))
                     ((= LOC -4.) (RETURN REG4*))
                     (T (RETURN REG5*)))))
        (SETQ VEC (CDR (LOCVEC LOC)))
   TOP  (SETQ LOC (CAR VEC))
   NTH  (COND ((> LOC 1.)
               (SETQ LOC (1- LOC))
               (SETQ X (CDR X))
               (GO NTH)))
        (SETQ VEC (CDR VEC))
        (OR VEC (RETURN X))
        (SETQ X (CAR X))
        (GO TOP))) 

; List printing functions

(DEFUN PRINTLINE (X) (MAPC (FUNCTION PRINTLINE*) X)) 

(DEFUN PRINTLINE* (Y) (PRINC '| |) (PRIN1 Y)) 

(DEFUN PRINTLINEC (X) (MAPC (FUNCTION PRINTLINEC*) X)) 

(DEFUN PRINTLINEC* (Y) (PRINC '| |) (PRINC Y)) 

(DEFUN WITHIN (X LIS)
  (COND ((EQ X LIS) T)
        ((ATOM LIS) NIL)
        (T (OR (WITHIN X (CAR LIS)) (WITHIN X (CDR LIS)))))) 


;;; The LHS Compiler

(DEFUN ENCODE (X)
  (PROG (I NEW)
        (SETQ NEW
              (CONS (ENCODE-VAR-TYPE (CAR X)) (REVERSE (CDR X))))
        (COMMENT |This COND is a special encode for one-input nodes|)
        (COND ((EQUAL NEW '(NIL 1. 1.)) (RETURN 0.))
              ((EQUAL NEW '(NIL 1. 1. 1.)) (RETURN -1.))
              ((EQUAL NEW '(NIL 1. 2. 1.)) (RETURN -2.))
              ((EQUAL NEW '(NIL 1. 3. 1.)) (RETURN -3.))
              ((EQUAL NEW '(NIL 1. 4. 1.)) (RETURN -4.))
              ((EQUAL NEW '(NIL 1. 5. 1.)) (RETURN -5.)))
        (SETQ I 1.)
   LAB  (COND ((NOT (< I NEXT-LOCVEC*)) (GO NOTFOUND))
              ((EQUAL NEW (LOCVEC I)) (RETURN I)))
        (SETQ I (1+ I))
        (GO LAB)
   NOTFOUND (COND ((> NEXT-LOCVEC* MAX-LOCVEC*)
                   (MYERR NEXT-LOCVEC* '|Too many index vectors|)))
        (STORE (LOCVEC NEXT-LOCVEC*) NEW)
        (SETQ NEXT-LOCVEC* (1+ NEXT-LOCVEC*))
        (RETURN (1- NEXT-LOCVEC*)))) 

(DEFUN ENCODE-VAR-TYPE (X) X) 

; If first argument to NEWNODE is non-negative it is a priority
; Nodes with priority are stored for later insertion
; 0 is the highest priority

(DEFUN NEWNODE N
  (PROG (A B C)
        (SETQ A N)
        (SETQ B NIL)
   L1   (COND ((> 3. A) (GO L2)))
        (SETQ B (CONS (ARG A) B))
        (SETQ A (1- A))
        (GO L1)
        (COMMENT |Add the appropriate number of successor fields|)
   L2   (SETQ B
              (COND ((EQ (ARG 2.) '&P) (CONS (ARG 2.) B))
                    ((OR (EQ (ARG 2.) '&TWO) (EQ (ARG 2.) '&MEM))
                     (CONS (ARG 2.) (CONS NIL (CONS NIL B))))
                    (T (CONS (ARG 2.) (CONS NIL B)))))
        (SETQ C (ARG 1.))
        (COND ((> C -1.) (STORE-NODE (NESTING-LEVEL) C B)))
        (RETURN B))) 

(DEFUN SYSTEM FEXPR (SYS)
  (PROG (NAME MATRIX)
   L1   (COND ((ATOM SYS) (RETURN NIL)))
        (SETQ NAME (CAR SYS))
        (SETQ SYS (CDR SYS))
        (COND ((ATOM NAME)
               (OR (CONSP SYS) (MYERR SYS '|NO PRODUCTION|))
               (SETQ MATRIX (CAR SYS))
               (SETQ SYS (CDR SYS)))
              (T (SETQ MATRIX NAME) (SETQ NAME NIL)))
        (COMPILE-PRODUCTION NAME MATRIX)
        (PRINC '*)
        (GO L1))) 

(DEFUN COMPILE-AND-UPDATE (NAME MATRIX)
  (SETQ BUILD-FLAG* (LIST FIRST-NODE*))
  (COMPILE-PRODUCTION NAME MATRIX)
  (MAPWM (FUNCTION BUILD-ASSERT))
  (SETQ BUILD-FLAG* NIL)) 

(DEFUN MATRIX (NAME) (AND (SYMBOLP NAME) (GET NAME 'PRODUCTION))) 

(DEFUN EXCISE-P (NAME)
  (COND ((AND (SYMBOLP NAME) (GET NAME 'RHS))
         (PROGN (REMPROP NAME 'PRODUCTION)
                (REMPROP NAME 'RHS)
                (REMPROP NAME 'VARIABLE-DOPE)
                (REMOVE-FROM-CONFLICT-SET NAME)
                (KILL-NODE (GET NAME 'TOPNODE))
                (REMPROP NAME 'TOPNODE)
                (SETQ PCOUNT* (1- PCOUNT*)))))) 

(DEFUN KILL-NODE (NODE) (COND ((CONSP NODE) (RPLACA NODE '&OLD)))) 

(DEFUN COMPILE-PRODUCTION (NAME MATRIX)
  (PROG (ERM)
        (SETQ LAST-NAME* NAME)
        (SETQ LAST-MATRIX* MATRIX)
        (SETQ ERM (ERRSET (CMP-P LAST-NAME* LAST-MATRIX*)))
        (AND (NULL ERM)
             (NOT (NULL NAME))
             (PRINT (LIST 'ERROR 'IN NAME))))) 

(DEFUN CMP-P (NAME MATRIX)
  (PROG (LHS M DOPE NODE IDENT RATING)
        (SETQ PCOUNT* (1+ PCOUNT*))
        (SETQ CREATION-TIME* (1+ CREATION-TIME*))
        (SETQ SPECIAL-CASE-NUMBER* 0.)
        (SETQ CONSTANT-COUNT* 0.)
        (SETQ M MATRIX)
        (SETQ LHS NIL)
   L1   (COND ((ATOM M)
               (MYERR MATRIX '|WRONG FORMAT FOR PRODUCTION|))
              ((EQ '--> (CAR M)) (GO L2)))
        (SETQ LHS (CONS (CAR M) LHS))
        (SETQ M (CDR M))
        (GO L1)
   L2   (CMP-LHS (NREVERSE LHS))
        (SETQ DOPE (MAKE-VAR-DOPE M POS-VAR-POSN*))
        (SETQ IDENT
              (COND ((NOT (NULL NAME)) NAME)
                    (T (CONS DOPE (CDR M)))))
        (SETQ RATING
              (+ (* 5000000. SPECIAL-CASE-NUMBER*)
                 (* 5000. CONSTANT-COUNT*)
                 CREATION-TIME*))
        (SETQ NODE (LINK-NEW-NODE (NEWNODE -1. '&P RATING IDENT)))
        (COND ((NOT (NULL NAME))
               (EXCISE-P NAME)
               (PUTPROP NAME (CDR M) 'RHS)
               (AND KEEP-LHS* (PUTPROP NAME MATRIX 'PRODUCTION))
               (PUTPROP NAME DOPE 'VARIABLE-DOPE)
               (PUTPROP NAME NODE 'TOPNODE))))) 

(DEFUN DOPE-PART (X) (CAR X)) 

(DEFUN RHS-PART (X) (CDR X)) 

(DEFUN MAKE-VAR-DOPE (RHS POSN)
  (PROG (R NAME VECTOR)
        (SETQ R NIL)
   TOP  (AND (ATOM POSN) (RETURN R))
        (SETQ NAME (CAAR POSN))
        (SETQ VECTOR (CDAR POSN))
        (SETQ POSN (CDR POSN))
        (SETQ NAME (FULL-NAME NAME))
        (AND (WITHIN NAME RHS)
             (SETQ R (CONS (CONS NAME (ENCODE VECTOR)) R)))
        (GO TOP))) 

(DEFUN CMP-LHS (LHS)
  (SETQ NEG-VAR-POSN* (SETQ POS-VAR-POSN* NIL))
  (CMP-PRIN-FORM LHS)
  (COND (NEG-VAR-POSN*
         (MYERR (CAAR NEG-VAR-POSN*)
                '|UNRESOLVED NOT-VARIABLES IN LHS|)))) 

(DEFUN NOTP (X) (AND (CONSP X) (EQ (CAR X) '<NOT>))) 

(DEFUN CMP-NOT (X) (CMP-PRIN-FORM X)) 

; In the following, P, PNEW, POS-VAR-POSN* hold pointers to variables,
; and N, NNEW, NEG-VAR-POSN* hold pointers to NOT-variables.  The two
; SPECIALs are needed because nested <NOT>s have to be able to
; communicate back to higher levels.

(DEFUN CMP-PRIN-FORM (FORM)
  (PROG (N P TYPEOFLAST NNEW PNEW A Z NEWLOCS OLDLOCS LAST X
         SEEN-POS)
        (COND ((ATOM FORM) 
	       (MYERR FORM '|Null LHS or null argument to <NOT>|)))
        (SETQ LAST NIL)
        (SETQ SEEN-POS NIL)
        (SETQ X FORM)
   L1   (COND ((ATOM X) (RETURN NIL)))
        (SETQ N NEG-VAR-POSN*)
        (SETQ P POS-VAR-POSN*)
        (SETQ POS-VAR-POSN* (SETQ NEG-VAR-POSN* NIL))
        (RESET-POSITION)
        (COND ((EQ (CAR X) '-)
               (COND ((NOT SEEN-POS)
                      (MYERR FORM
                             '
                                   
|First condition element cannot be negated|
                                   )))
               (CMP-NOT (LIST (CADR X)))
               (SETQ X (CDDR X))
               (SETQ TYPEOFLAST NIL))
              ((NOTP (CAR X))
               (COND ((NOT SEEN-POS)
                      (MYERR FORM
                             '
                                   
|First condition element cannot be negated|
                                   )))
               (CMP-NOT (CDAR X))
               (SETQ X (CDR X))
               (SETQ TYPEOFLAST NIL))
              (T
               (SETQ SEEN-POS T)
               (SETQ X (CMP-CONDITION X))
               (SETQ TYPEOFLAST T)))
   LX   (SETQ PNEW (SETQ NNEW NIL))
        (SETQ NEWLOCS (SETQ OLDLOCS NIL))
        (COMMENT |If anything in POS-VAR-POSN* use it|)
   BETA (COND ((ATOM POS-VAR-POSN*) (GO BETAN)))
        (SETQ A (CAR POS-VAR-POSN*))
        (SETQ POS-VAR-POSN* (CDR POS-VAR-POSN*))
        (SETQ Z (ASSQ (CAR A) P))
        (COND (Z
               (SETQ NEWLOCS (CONS (CDR A) NEWLOCS))
               (SETQ OLDLOCS (CONS (CDR Z) OLDLOCS)))
              (T (SETQ PNEW (CONS A PNEW))))
   LB   (SETQ Z (ASSQ (CAR A) N))
        (COND ((ATOM Z) (GO BETA)))
        (SETQ NEWLOCS (CONS (CDR A) NEWLOCS))
        (SETQ OLDLOCS (CONS (CDR Z) OLDLOCS))
        (SETQ N (DELQ Z N))
        (GO LB)
        (COMMENT |If anything in NEG-VAR-POSN* use it|)
   BETAN (COND ((ATOM NEG-VAR-POSN*) (GO L5)))
        (SETQ A (CAR NEG-VAR-POSN*))
        (SETQ NEG-VAR-POSN* (CDR NEG-VAR-POSN*))
        (SETQ Z (ASSQ (CAR A) P))
        (COND (Z
               (SETQ NEWLOCS (CONS (CDR A) NEWLOCS))
               (SETQ OLDLOCS (CONS (CDR Z) OLDLOCS)))
              (T (SETQ NNEW (CONS A NNEW))))
        (GO BETAN)
        (COMMENT |Build a beta node unless this is the first CE|)
   L5   (COND (LAST
               (COND ((> (LENGTH NEWLOCS) 6.)
                      (MYERR FORM '|Too many variables|)))
               (SETQ LAST
                     (BUILD-BETA TYPEOFLAST OLDLOCS NEWLOCS LAST)))
              (T (SETQ LAST LAST-NODE*)))
        (COMMENT |Reset SPECIALs so can go to next principal|)
        (COND (TYPEOFLAST
               (FUDGE N)
               (FUDGE P)
               (SETQ NEG-VAR-POSN* (APPEND NNEW N))
               (SETQ POS-VAR-POSN* (APPEND PNEW P)))
              (T (SETQ NEG-VAR-POSN* N) (SETQ POS-VAR-POSN* P)))
        (GO L1))) 

(DEFUN BUILD-BETA (TYPE OLD-VAR-LOCS NEW-VAR-LOCS NODE-ON-LEFT)
  (PROG (R NEW OLD LEFT-PRED LTYPE RIGHT-PRED FUN RIT LEF)
        (SETQ RIGHT-PRED
              (LINK-NEW-NODE (NEWNODE -1. '&MEM (PROTOMEM))))
        (SETQ LTYPE
              (COND (TYPE (NEWNODE -1. '&MEM (PROTOMEM)))
                    (T (NEWNODE -1. '&TWO))))
        (SETQ LEFT-PRED (LINK-NEW-NODE-RIGHT LTYPE NODE-ON-LEFT))
        (SETQ OLD
              (MAPCAN (FUNCTION (LAMBDA (P) (LIST (ENCODE P))))
                      OLD-VAR-LOCS))
        (SETQ NEW
              (MAPCAN (FUNCTION (LAMBDA (P) (LIST (ENCODE P))))
                      NEW-VAR-LOCS))
        (COND (TYPE
               (COND (NEW (SETQ FUN '&VEX))
                     (T (SETQ FUN '&VNO)))
               (SETQ LEF LEFT-PRED))
              (T (SETQ FUN '&NOT) (SETQ LEF (PROTOMEM))))
        (SETQ RIT RIGHT-PRED)
        (COND ((EQ FUN '&VNO) (SETQ R (NEWNODE -1. FUN RIT LEF)))
              (T (SETQ R (NEWNODE -1. FUN RIT LEF OLD NEW))))
        (RETURN (LINK-NEW-NODE-BOTH R LEFT-PRED RIGHT-PRED)))) 

(DEFUN PROTOMEM NIL (LIST NIL)) 

; Both POS-VAR-POSN* and NEG-VAR-POSN* have the same format.
; Both are association lists;  associations are along root name.
; Root name of a variable is the name with first char taken off.
; Example of one entry: (X . LOCATION-VECTOR)

(DEFUN FUDGE (X) (MAPC (FUNCTION FUDGE*) X)) 

(DEFUN FUDGE* (X)
  (COND ((ATOM (CDR X)) (RPLACA X (1+ (CAR X))))
        (T (FUDGE* (CDR X))))) 

(DEFUN FULL-NAME (ROOT) (READLIST (CONS '= (EXPLODE ROOT)))) 

(DEFUN ROOT-NAME (VAR) (READLIST (CDR (EXPLODE VAR)))) 

(DEFUN VAR-ASSQ (X L) (ASSQ (ROOT-NAME X) L)) 

(DEFUN CMP-CEA* (X)
  (COND ((ATOM X) (MYERR X '|Illegal CEA*|)))
  (CMP-CEA (CAR X))
  (COND ((ATOM (CDR X)) (CDR X))
        ((EQ '& (CADR X)) (CMP-CEA* (CDDR X)))
        (T (CDR X)))) 

; CMP-CONDITION is a special kind of CMP-CE*
; It is only called at the top level of the production

(DEFUN CMP-CONDITION (X)
  (PROG (R)
        (SETQ SEGMENT-FLAG* NIL)
        (SETQ SPECIAL-CASE-NUMBER* (1+ SPECIAL-CASE-NUMBER*))
        (RESET-NODE-STORAGE)
        (SETQ R (CMP-CE* X))
        (PLACE-NODES)
        (RETURN R))) 

(DEFUN CMP-CE* (X)
  (COND ((ATOM X) (MYERR X '|Illegal CE*|)))
  (CMP-CE (CAR X))
  (COND ((ATOM (CDR X)) (CDR X))
        ((EQ '& (CADR X)) (CMP-CE* (CDDR X)))
        (T (CDR X)))) 

(DEFUN CMP-CEA (X)
  (COND ((VARIABLEP X) (CMP-VAR X))
        ((CONSTANTP X) (CMP-CONSTANT X))
        ((USERDEFP X) (CMP-USERDEF X))
        (T (MYERR X '|Unidentifiable condition element|)))) 

(DEFUN CMP-CE (X)
  (COND ((REGULARLISTP X) (CMP-LIST X))
        (T (CMP-CEA X)))) 

(DEFUN CMP-VAR (V)
  (COND ((EQ '= V))
        ((POSVARP V) (CMP-P-VAR V))
        (T (CMP-N-VAR V)))) 

(DEFUN CMP-P-VAR (V)
  (PROG (A VL)
        (SETQ VL (MAKE-VL-VECTOR V))
        (SETQ A (VAR-ASSQ V POS-VAR-POSN*))
        (COND (A (RETURN (CMP-OLD-P-VAR VL (CDR A)))))
   L1   (SETQ A (VAR-ASSQ V NEG-VAR-POSN*))
        (COND ((NOT A) (RETURN (CMP-NEW-P-VAR V VL))))
        (CMP-P-N-VAR VL (CDR A))
        (SETQ NEG-VAR-POSN* (DELQ A NEG-VAR-POSN*))
        (GO L1))) 

(DEFUN CMP-N-VAR (V)
  (PROG (A VL)
        (SETQ VL (MAKE-VL-VECTOR V))
        (SETQ A (VAR-ASSQ V POS-VAR-POSN*))
        (COND (A (MAKE-VIN-TEST VL (CDR A)))
              (T
               (SETQ NEG-VAR-POSN*
                     (CONS (CONS (ROOT-NAME V) VL) NEG-VAR-POSN*)))))) 

(DEFUN CMP-NEW-P-VAR (NAME VARLOC)
  (SETQ POS-VAR-POSN*
        (CONS (CONS (ROOT-NAME NAME) VARLOC) POS-VAR-POSN*))) 

(DEFUN CMP-OLD-P-VAR (VAR OLD) (MAKE-VIN-TEST VAR OLD)) 

(DEFUN CMP-P-N-VAR (VAR NOT) (MAKE-VIN-TEST VAR NOT)) 

(DEFUN MAKE-VIN-TEST (A B)
  (NEWNODE 2. '&VIN (ENCODE A) (ENCODE B))) 

; COPY needed below because FUDGE will munge these numbers

(DEFUN MAKE-VL-VECTOR (VAR)
  (COPY (CURRENT-POSITION (VARIABLEP VAR)))) 

(DEFUN VARIABLE-TYPE (V) (CAR (LOCVEC V))) 

(DEFUN VARIABLEP (PROBE)
  (PROG (Z)
        (OR (SYMBOLP PROBE) (RETURN NIL))
        (SETQ Z (GETCHAR PROBE 1.))
        (COND ((ASSOC Z VAR-FNS*) (RETURN Z))
              (T (RETURN NIL))))) 

(DEFUN POSVARP (V) (EQ (VARIABLEP V) '=)) 

(DEFUN CONSTANTP (X)
  (OR (NUMBERP X) (AND (SYMBOLP X) (NOT (VARIABLEP X))))) 

(DEFUN CMP-CONSTANT (X)
  (SETQ CONSTANT-COUNT* (1+ CONSTANT-COUNT*))
  (NEWNODE ATOM-PRIORITY* '&ATOM (ENCODE (CURRENT-POSITION NIL)) X)) 

(DEFUN USERDEFP (X)
  (AND (CONSP X) (SYMBOLP (CAR X)) (GET (CAR X) 'LHS-FN))) 

(DEFUN PREDICATE FEXPR (L)
  (MAPC (FUNCTION (LAMBDA (X) (PUTPROP X T 'LHS-FN))) L)) 

(DEFUN CMP-USERDEF (L)
  (NEWNODE 2.
           '&USER
           (ENCODE (CURRENT-POSITION NIL))
           (CAR L)
           (CDR L))) 

(DEFUN REGULARLISTP (X) (AND (CONSP X) (NOT (USERDEFP X)))) 

(DEFUN CMP-LIST (X)
  (PROG (A TYPE)
        (NEST)
        (SETQ A X)
        (SETQ TYPE '&LEN)
        (SETQ SEGMENT-FLAG* NIL)
   L1   (COND ((ATOM A) (GO L2)))
        (SETQ A (CMP-CE* A))
        (LOC-LOOP)
        (COND ((NOT (AND (CONSP A) (EQ (CAR A) '!))) (GO L1)))
        (SETQ TYPE '&LEN+)
        (SETQ SEGMENT-FLAG* T)
        (SETQ A (CMP-CEA* (CDR A)))
        (COND (A (MYERR X '|Extra form in SEGMENT|)))
   L2   (UNNEST)
        (SETQ SEGMENT-FLAG* NIL)
        (NEWNODE LENGTH-PRIORITY*
                 TYPE
                 (ENCODE (CURRENT-POSITION NIL))
                 (1- LAST-LENGTH*)))) 

(DEFUN RESET-POSITION NIL (SETQ LOCATION-VECTOR* (LIST 1.))) 

(DEFUN NESTING-LEVEL NIL (1- (LENGTH LOCATION-VECTOR*))) 

(DEFUN NEST NIL (SETQ LOCATION-VECTOR* (CONS 1. LOCATION-VECTOR*))) 

(DEFUN UNNEST NIL
  (SETQ LAST-LENGTH* (CAR LOCATION-VECTOR*))
  (SETQ LOCATION-VECTOR* (CDR LOCATION-VECTOR*))) 

(DEFUN LOC-LOOP NIL
  (SETQ LOCATION-VECTOR*
        (CONS (1+ (CAR LOCATION-VECTOR*)) (CDR LOCATION-VECTOR*)))) 

(DEFUN CURRENT-POSITION (X)
  (CONS X
        (COND (SEGMENT-FLAG* LOCATION-VECTOR*)
              (T (CONS 1. LOCATION-VECTOR*))))) 

(DEFUN MAKE-BOTTOM-NODE NIL (SETQ FIRST-NODE* (LIST '&BUS NIL))) 

(DEFUN PLACE-FIRST-NODE NIL (SETQ LAST-NODE* FIRST-NODE*)) 

; Note that NEWNODES* has more elements than are used
; Actually it s used as a 3 by 10 array

(ARRAY NEWNODES* T 4. 11.)

(DEFUN STORE-NODE (NESTED-TO PRIORITY NODE)
  (PROG (N)
        (SETQ N NESTED-TO)
        (COND ((> N 9.) (SETQ N 9.)))
        (STORE (NEWNODES* PRIORITY N)
               (CONS NODE (NEWNODES* PRIORITY N))))) 

(DEFUN RESET-NODE-STORAGE NIL
  (PROG (I J)
        (SETQ I -1.)
   LOUT (SETQ I (1+ I))
        (COND ((> I 9.) (RETURN NIL)))
        (SETQ J -1.)
   LIN  (SETQ J (1+ J))
        (COND ((> J 2.) (GO LOUT)))
        (STORE (NEWNODES* J I) NIL)
        (GO LIN))) 

(DEFUN PLACE-NODES NIL
  (PROG (LVL PRTY)
        (PLACE-FIRST-NODE)
        (SETQ LVL -1.)
   LOUT (SETQ LVL (1+ LVL))
        (COND ((> LVL 9.) (RETURN NIL)))
        (SETQ PRTY -1.)
   LIN  (SETQ PRTY (1+ PRTY))
        (COND ((> PRTY 2.) (GO LOUT)))
        (PLACE-NODES* (NEWNODES* PRTY LVL))
        (GO LIN))) 

(DEFUN PLACE-NODES* (X)
  (COND ((ATOM X))
        (T (PLACE-NODES* (CDR X)) (PLACE-NODES** (CAR X))))) 

(DEFUN PLACE-NODES** (NODE) (LINK-NEW-NODE NODE)) 

(DEFUN LINK-NEW-NODE-BOTH (NODE LEFTPRED RIGHTPRED)
  (PROG (A R)
        (SETQ VIRTUAL-NODE-COUNT* (1+ VIRTUAL-NODE-COUNT*))
        (COND ((MEMQ (CAR NODE) '(&VEX &NOT))
               (SETQ FEATURES*
                     (+ FEATURES* (LENGTH (CAR (CDDDDR NODE))))))
              ((MEMQ (CAR NODE) '(&LEN &LEN+ &ATOM &VIN &USER))
               (SETQ FEATURES* (1+ FEATURES*))))
        (COND ((AND LEFTPRED RIGHTPRED)
               (SETQ A
                     (INTERSECT (RIGHT-OUTS RIGHTPRED)
                                (LEFT-OUTS LEFTPRED))))
              (RIGHTPRED (SETQ A (RIGHT-OUTS RIGHTPRED)))
              (T (SETQ A (LEFT-OUTS LEFTPRED))))
        (SETQ R (FIND-EQUIV-NODE NODE A))
        (COND (R
               (COND (BUILD-FLAG*
                      (SETQ BUILD-FLAG* (CONS R BUILD-FLAG*))))
               (RETURN (SETQ LAST-NODE* R))))
        (COND ((MEMQ (CAR NODE) '(&VEX &NOT))
               (SETQ REAL-FEATURES*
                     (+ REAL-FEATURES*
                        (LENGTH (CAR (CDDDDR NODE))))))
              ((MEMQ (CAR NODE) '(&LEN &LEN+ &ATOM &VIN &USER))
               (SETQ REAL-FEATURES* (1+ REAL-FEATURES*))))
        (SETQ REAL-NODE-COUNT* (1+ REAL-NODE-COUNT*))
        (SETQ NODE (ASSEMBLE-NODE NODE))
        (COND (RIGHTPRED (ATTACH-NODE-RIGHT NODE RIGHTPRED)))
        (COND (LEFTPRED (ATTACH-NODE-LEFT NODE LEFTPRED)))
        (SETQ LAST-NODE* NODE)
        (COND (BUILD-FLAG*
               (SETQ BUILD-FLAG* (CONS NODE BUILD-FLAG*))))
        (RETURN NODE))) 

(DEFUN LINK-NEW-NODE-LEFT (NODE PRED)
  (LINK-NEW-NODE-BOTH NODE PRED NIL)) 

(DEFUN LINK-NEW-NODE-RIGHT (NODE PRED)
  (LINK-NEW-NODE-BOTH NODE NIL PRED)) 

(DEFUN LINK-NEW-NODE (NODE)
  (LINK-NEW-NODE-BOTH NODE NIL LAST-NODE*)) 

(DEFUN FIND-EQUIV-NODE (NODE LIST)
  (PROG (A)
        (SETQ A LIST)
   L1   (COND ((ATOM A) (RETURN NIL))
              ((EQUIV NODE (CAR A)) (RETURN (CAR A))))
        (SETQ A (CDR A))
        (GO L1))) 


;;; The functions on this page know which nodes are HUNKS
; &ATOM, &VIN, &LEN, &LEN+, &VEX, &VNO, and &NOT are HUNKS
; &MEM, &P, and &OLD are modified during execution, so they are lists
; &TWO is a list so that it will be like &MEM
; &BUS and &USER are rare, so little point in making them HUNKS
; EQUIV will not consider a new node to be equivalent to an
; old node if the old node has anything in its memory.
; THE MECHANISMS FOR GROWING NEW PRODUCTIONS REQUIRE THIS.

(DEFUN EQUIV (NODE1 NODE2)
  (AND (EQ (CAR NODE1) (CAR NODE2))
       (COND ((EQ (CAR NODE1) '&MEM)
              (EQUAL (CDDDR NODE1) (CDDDR NODE2)))
             ((EQ (CAR NODE1) '&TWO) T)
             ((EQ (CAR NODE1) '&P) NIL)
             ((MEMQ (CAR NODE1) '(&ATOM &LEN &LEN+ &VIN))
              (EQUIV1 NODE1 NODE2))
             ((MEMQ (CAR NODE1) '(&VEX &NOT))
              (EQUIV2 NODE1 NODE2))
             ((EQ (CAR NODE1) '&VNO) (EQUIV2NOVAR NODE1 NODE2))
             (T (EQUAL (CDDR NODE1) (CDDR NODE2)))))) 

(DEFUN EQUIV1 (X Y)
  (AND (EQUAL (CAR X) (CXR 1. Y))
       (EQUAL (CADDR X) (CXR 3. Y))
       (EQUAL (CADDDR X) (CXR 0. Y)))) 

;* Using EQUAL for the memory pointer parts of 2-input nodes
;* could be very expensive, computationally.  It could be that
;* many nodes would be examined on some occassions.

(DEFUN EQUIV2 (X Y)
  (AND (EQUAL (CAR X) (CXR 1. Y))
       (EQUAL (CADR (CDDDDR X)) (CXR 0. Y))
       (EQUAL (CAR (CDDDDR X)) (CXR 5. Y))
       (EQUAL (CADDDR X) (CXR 4. Y))
       (EQUAL (CADDR X) (CXR 3. Y)))) 

(DEFUN EQUIV2NOVAR (X Y)
  (AND (EQUAL (CAR X) (CXR 1. Y))
       (EQUAL (CADDDR X) (CXR 0. Y))
       (EQUAL (CADDR X) (CXR 3. Y)))) 

(DEFUN ATTACH-NODE-RIGHT (NEW OLD)
  (COND ((MEMQ (CAR OLD) '(&ATOM &VIN &LEN &LEN+ &VEX &NOT &VNO))
         (RPLACX 2. OLD (CONS NEW (CXR 2. OLD))))
        (T (RPLACA (CDR OLD) (CONS NEW (CADR OLD)))))) 

(DEFUN ATTACH-NODE-LEFT (NEW OLD)
  (RPLACA (CDDR OLD) (CONS NEW (CADDR OLD)))) 

(DEFUN RIGHT-OUTS (X)
  (COND ((MEMQ (CAR X) '(&ATOM &VIN &LEN &LEN+ &VEX &NOT &VNO))
         (CXR 2. X))
        (T (CADR X)))) 

(DEFUN LEFT-OUTS (NODE) (CADDR NODE)) 

(DEFUN ASSEMBLE-NODE (X)
  (COND ((MEMQ (CAR X) '(&ATOM &VIN &LEN &LEN+))
         (HUNK (CAR X) (CADR X) (CADDR X) (CADDDR X)))
        ((MEMQ (CAR X) '(&VEX &NOT))
         (HUNK (CAR X)
               (CADR X)
               (CADDR X)
               (CADDDR X)
               (CAR (CDDDDR X))
               (CADR (CDDDDR X))))
        ((EQ (CAR X) '&VNO)
         (HUNK (CAR X) (CADR X) (CADDR X) (CADDDR X)))
        (T X))) 

(DEFUN MEMORY-PART (MEM-NODE) (CAR (CADDDR MEM-NODE))) 

(DEFUN NAME-PART (PROD-NODE) (CADDR PROD-NODE)) 


;;; Working Memory Maintaining Functions
; WM is stored in pieces under property WMPART*.
; Each part is an association list of form: (WME . CREATION-TIME)

(DEFUN DENY (ELM)
  (PROG (A)
        (COND ((OR (NOT ELM)
                   (MEMBER ELM ADD-LIST*)
                   (MEMBER ELM DELETE-LIST*))
               (RETURN NIL)))
        (SETQ A (FIND-EQUAL-WME ELM NIL))
        (COND (A (SETQ DELETE-LIST* (CONS A DELETE-LIST*)))))) 

(DEFUN REAL-DENY (ELM)
  (SETQ CURRENT-WM* (1- CURRENT-WM*))
  (MATCH NIL ELM)) 

(DEFUN REFRESH (OLDELEM)
  (OR (MEMBER OLDELEM ADD-LIST*)
      (MEMBER OLDELEM DELETE-LIST*)
      (REAL-REFRESH (FIND-EQUAL-WME OLDELEM NIL)))) 

(DEFUN REAL-REFRESH (X)
  (SETQ REFRESHED-WMES* (CONS X REFRESHED-WMES*))) 

(DEFUN ASSERT (ELM)
  (COND ((NOT (OR (NOT ELM)
                  (MEMBER ELM ADD-LIST*)
                  (MEMBER ELM DELETE-LIST*)))
         (SETQ ADD-LIST* (CONS ELM ADD-LIST*))))) 

(DEFUN REASSERT (ELM)
  (COND ((NOT (OR (NOT ELM)
                  (MEMBER ELM ADD-LIST*)
                  (MEMBER ELM DELETE-LIST*)))
         (SETQ ADD-LIST* (CONS ELM ADD-LIST*))
         (SETQ REASSERT-LIST* (CONS ELM REASSERT-LIST*))))) 

(DEFUN REAL-ASSERT (ELM)
  (PROG (NEWELM)
        (SETQ NEWELM (FIND-EQUAL-WME ELM T))
        (COND ((OR (EQ NEW-FLAG* 'NEW) (MEMQ ELM REASSERT-LIST*))
               (MATCH NEW-FLAG* NEWELM))
              (T (REAL-REFRESH NEWELM))))) 

; BUILD-ASSERT is called only when <BUILD> is executed
; all nodes except the newly added ones are disabled then

(DEFUN BUILD-ASSERT (WM-ENTRY) (MATCH 'NEW (CAR WM-ENTRY))) 

; MAPWM maps down the elements of wm, applying FN to each element
; each element is of form (DATUM . CREATION-TIME)

(DEFUN MAPWM (FN)
  (PROG (WMPL PART)
        (SETQ WMPL WMPART-LIST*)
   LAB1 (COND ((ATOM WMPL) (RETURN NIL)))
        (SETQ PART (GET (CAR WMPL) 'WMPART*))
        (SETQ WMPL (CDR WMPL))
        (MAPC FN PART)
        (GO LAB1))) 

(DEFUN WM NIL
  (SETQ WM* NIL)
  (MAPWM (FUNCTION WM-CNTS*))
  (PROG2 NIL WM* (SETQ WM* NIL))) 

(DEFUN WM-CNTS* (ELEM) (SETQ WM* (CONS (CAR ELEM) WM*))) 

(DEFUN PP-WM NIL (WM)) 

; REMOVE-FROM-WM uses EQ so WME must be an actual element

(DEFUN REMOVE-FROM-WM (WME)
  (PROG (FA Z PART)
        (SETQ PART (GET (SETQ FA (FIRST-ATOM WME)) 'WMPART*))
        (SETQ Z (ASSQ WME PART))
        (PUTPROP FA (DELQ Z PART) 'WMPART*))) 

(DEFUN CREATION-TIME (WME)
  (CDR (ASSQ WME (GET (FIRST-ATOM WME) 'WMPART*)))) 

(DEFUN PRESENTP (OBJ) (ASSOC OBJ (GET (FIRST-ATOM OBJ) 'WMPART*))) 

(DEFUN FIND-EQUAL-WME (ELM ADD-FLAG)
  (PROG (FIRST-ATOM PART OLD)
        (SETQ ACTION-COUNT* (1+ ACTION-COUNT*))
        (SETQ NEW-FLAG* 'OLD)
        (SETQ FIRST-ATOM (FIRST-ATOM ELM))
        (SETQ PART (GET FIRST-ATOM 'WMPART*))
        (SETQ OLD (ASSOC ELM PART))
        (COND (OLD (RPLACD OLD ACTION-COUNT*) (RETURN (CAR OLD)))
              ((NOT ADD-FLAG) (RETURN NIL)))
        (SETQ CURRENT-WM* (1+ CURRENT-WM*))
        (SETQ NEW-FLAG* 'NEW)
        (PUTPROP FIRST-ATOM
                 (CONS (CONS ELM ACTION-COUNT*) PART)
                 'WMPART*)
        (COND ((NOT (MEMQ FIRST-ATOM WMPART-LIST*))
               (SETQ WMPART-LIST* (CONS FIRST-ATOM WMPART-LIST*))))
        (RETURN ELM))) 

(DEFUN ADD-TOKEN (LIS F D NUM)
  (PROG (WAS-PRESENT)
        (COMMENT |LIS is a list whose CAR is a memory|
                 |F is a flag and D is a data part|)
        (COND ((EQ F 'NEW)
               (COND (BUILD-FLAG*
                      (SETQ WAS-PRESENT (REMOVE-OLD LIS D NUM)))
                     (T (SETQ WAS-PRESENT NIL)))
               (REAL-ADD-TOKEN LIS D NUM))
              ((NOT F) (SETQ WAS-PRESENT (REMOVE-OLD LIS D NUM)))
              ((EQ F 'OLD) (SETQ WAS-PRESENT T)))
        (RETURN WAS-PRESENT))) 

(DEFUN REAL-ADD-TOKEN (LIS DATA-PART NUM)
  (SETQ CURRENT-TOKEN* (1+ CURRENT-TOKEN*))
  (COND (NUM (RPLACA LIS (CONS NUM (CAR LIS)))))
  (RPLACA LIS (CONS DATA-PART (CAR LIS)))) 

(DEFUN REMOVE-OLD (LIS DATA NUM)
  (COND (NUM (REMOVE-OLD-NUM LIS DATA))
        (T (REMOVE-OLD-NO-NUM LIS DATA)))) 

(DEFUN REMOVE-OLD-NUM (LIS DATA)
  (PROG (M NEXT LAST)
        (SETQ M (CAR LIS))
        (COND ((ATOM M) (RETURN NIL))
              ((SIMILAR-TOKENP DATA (CAR M))
               (SETQ CURRENT-TOKEN* (1- CURRENT-TOKEN*))
               (RPLACA LIS (CDDR M))
               (RETURN (CAR M))))
        (SETQ NEXT M)
   LOC-LOOP (SETQ LAST NEXT)
        (SETQ NEXT (CDDR NEXT))
        (COND ((ATOM NEXT) (RETURN NIL))
              ((SIMILAR-TOKENP DATA (CAR NEXT))
               (RPLACD (CDR LAST) (CDDR NEXT))
               (SETQ CURRENT-TOKEN* (1- CURRENT-TOKEN*))
               (RETURN (CAR NEXT)))
              (T (GO LOC-LOOP))))) 

(DEFUN REMOVE-OLD-NO-NUM (LIS DATA)
  (PROG (M NEXT LAST)
        (SETQ M (CAR LIS))
        (COND ((ATOM M) (RETURN NIL))
              ((SIMILAR-TOKENP DATA (CAR M))
               (SETQ CURRENT-TOKEN* (1- CURRENT-TOKEN*))
               (RPLACA LIS (CDR M))
               (RETURN (CAR M))))
        (SETQ NEXT M)
   LOC-LOOP (SETQ LAST NEXT)
        (SETQ NEXT (CDR NEXT))
        (COND ((ATOM NEXT) (RETURN NIL))
              ((SIMILAR-TOKENP DATA (CAR NEXT))
               (RPLACD LAST (CDR NEXT))
               (SETQ CURRENT-TOKEN* (1- CURRENT-TOKEN*))
               (RETURN (CAR NEXT)))
              (T (GO LOC-LOOP))))) 

; SIMILAR-TOKENP was made faster by adding first clause in COND.
; That clause helps because many tokens share common tails.

(DEFUN SIMILAR-TOKENP (LA LB)
  (PROG NIL
   LX   (COND ((EQ LA LB) (RETURN T))
              ((NULL LA) (RETURN NIL))
              ((NULL LB) (RETURN NIL))
              ((NOT (EQ (CAR LA) (CAR LB))) (RETURN NIL)))
        (SETQ LA (CDR LA))
        (SETQ LB (CDR LB))
        (GO LX))) 

(DEFUN NEXT (MEMORY NUMBER)
  (COND (NUMBER (CDR MEMORY))
        (T (CDDR MEMORY)))) 

; FIRST-ATOM places some restrictions on the form of WMEs
; FIND-EQUAL-WME & REMOVE-FROM-WM make similar assumptions

(DEFUN FIRST-ATOM (X)
  (COND ((NOT X) (MYERR X '|ILLEGAL WM ELEMENT|))
        ((SYMBOLP X) X)
        ((ATOM X) '<NUMBER>)
        (T (FIRST-ATOM (CAR X))))) 

(DEFUN DELETE-OLDS (WMENTRY)
  (COND ((< MAXIMUM-AGE* (- ACTION-COUNT* (CDR WMENTRY)))
         (DENY (CAR WMENTRY))))) 


;;; Functions to interact with the user

(DEFUN VARIABLE FEXPR (L)
  (PROG (X A B R)
        (OR (EQUAL (LENGTH L) 3.)
            (EQUAL (LENGTH L) 2.)
            (MYERR L '|Wrong number of arguments|))
        (SETQ X (CAR L))
        (SETQ B (SETQ A (CADR L)))
        (AND (EQUAL (LENGTH L) 3.) (SETQ B (CADDR L)))
        (OR (AND (ATOM X) (EQUAL 1. (FLATSIZE X)))
            (MYERR X '|Must be a single character|))
        (OR (ATOM A) (MYERR A '|Must be an atom|))
        (OR (ATOM B) (MYERR B '|Must be an atom|))
        (SETQ R (LIST X A B))
        (AND (ASSOC X VAR-FNS*)
             (PRINC '|Warning: Variable type is being redefined|))
        (SETQ VAR-FNS* (CONS R VAR-FNS*))
        (RETURN X))) 

(DEFUN LEVEL1 (NAME DATA ADDS DELETES)
  (COND ((TRACEP NAME)
         (COND ((= CYCLE-COUNT* (* 10. (// CYCLE-COUNT* 10.)))
                (TERPRI))
               (T (PRINC '|	|)))
         (OR (ATOM NAME) (SETQ NAME '|(anon)|))
         (PRINC CYCLE-COUNT*)
         (PRINC '|. |)
         (PRINC NAME)))) 

(DEFUN LEVEL2 (P DATA ADDS DELS)
  (PROG (X POS LEN)
        (OR (TRACEP P) (RETURN NIL))
        (TERPRI)
        (OR (ATOM P) (SETQ P '|(anon)|))
        (PRINC P)
        (SETQ POS 99.)
   L2   (COND ((NOT DATA) (GO L3)))
        (SETQ X (CAR DATA))
        (SETQ DATA (CDR DATA))
        (SETQ LEN (FLATC X))
        (SETQ POS (+ 1. LEN POS))
        (COND ((> POS 77.)
               (TERPRI)
               (PRINC '| |)
               (SETQ POS (+ 2. LEN))))
        (PRINC '| |)
        (PRINC X)
        (GO L2)
   L3   (TERPRI)
        (PRINC '|  -->|)
        (SETQ POS 99.)
   L4   (COND ((NOT ADDS) (GO L5)))
        (SETQ X (CAR ADDS))
        (SETQ ADDS (CDR ADDS))
        (SETQ LEN (FLATC X))
        (SETQ POS (+ 1. LEN POS))
        (COND ((> POS 77.)
               (TERPRI)
               (PRINC '|  |)
               (SETQ POS (+ 3. LEN))))
        (PRINC '| |)
        (PRINC X)
        (GO L4)
   L5   (COND ((NOT DELS) (TERPRI) (TERPRI) (RETURN NIL)))
        (TERPRI)
        (PRINC '|  Deleted:|)
        (SETQ POS 99.)
   L6   (COND ((NOT DELS) (TERPRI) (TERPRI) (RETURN NIL)))
        (SETQ X (CAR DELS))
        (SETQ DELS (CDR DELS))
        (SETQ LEN (FLATC X))
        (SETQ POS (+ 1. LEN POS))
        (COND ((> POS 77.)
               (TERPRI)
               (PRINC '|  |)
               (SETQ POS (+ 3. LEN))))
        (PRINC '| |)
        (PRINC X)
        (GO L6))) 

(DEFUN TRACEP (X) (OR (NOT TRACED-RULES*) (MEMQ X TRACED-RULES*))) 

(DEFUN TRACER FEXPR (L) (MAPC (FUNCTION TRACER*) L)) 

(DEFUN TRACER* (R)
  (COND ((NOT (MEMQ R TRACED-RULES*))
         (SETQ TRACED-RULES* (CONS R TRACED-RULES*))))) 

(DEFUN UNTRACER FEXPR (L)
  (COND ((ATOM L) (SETQ TRACED-RULES* NIL))
        (T
         (MAPC (FUNCTION (LAMBDA (R)
                           (SETQ TRACED-RULES*
                                 (DELQ R TRACED-RULES*))))
               L)))) 

(DEFUN START-OPTIONS (|W M I|)
  (COND ((> (LENGTH |W M I|) 1.) |W M I|)
        ((ATOM |W M I|) |W M I|)
        ((ATOM (CAR |W M I|)) (EVAL (CAR |W M I|)))
        (T (CAR |W M I|)))) 

(DEFUN START FEXPR (|W M I|)
  (SETQ |W M I| (START-OPTIONS |W M I|))
  (AND RUNNING*
       (PRINC '|Warning: WM and the network memory may be inconsistent|
              ))
  (DO-START |W M I|)) 

(DEFUN DO-START (WM-LIST)
  (SETQ TOTAL-TIME* 0.)
  (SETQ ACTION-COUNT* 0.)
  (SETQ CYCLE-COUNT* 0.)
  (SETQ TOTAL-CS* 0.)
  (SETQ MAX-CS* 0.)
  (SETQ TOTAL-TOKEN* (SETQ MAX-TOKEN* 0.))
  (SETQ TOTAL-WM* 0.)
  (SETQ MAX-WM* 0.)
  (SETQ NEXT-DELETE-TIME* (IFIX (*$ 1.1 (FLOAT MAXIMUM-AGE*))))
  (SETQ DELETE-LIST* NIL)
  (SETQ ADD-LIST* NIL)
  (SETQ REASSERT-LIST* NIL)
  (SETQ REFRESHED-WMES* NIL)
  (MAPC (FUNCTION REASSERT) WM-LIST)
  (MAPC (FUNCTION DENY) (WM))
  (MAIN)) 

(DEFUN CONTINUE FEXPR (|W M|)
  (SETQ |W M| (START-OPTIONS |W M|))
  (AND RUNNING*
       (PRINC '|Warning: WM and the network memory may be inconsistent|
              ))
  (COND ((NOT (WM)) (DO-START |W M|))
        (T
         (SETQ ADD-LIST* (SETQ DELETE-LIST* NIL))
         (SETQ REASSERT-LIST* (SETQ REFRESHED-WMES* NIL))
         (MAPC (FUNCTION REASSERT) |W M|)
         (MAIN)))) 

(DEFUN SWITCHES FEXPR (B)
  (PROG (X WHAT)
   TOP  (AND (ATOM B) (RETURN 'SET))
        (AND (ATOM (CDR B)) (RETURN '(ODD NUMBER OF ARGUMENTS)))
        (SETQ X (CAR B))
        (SETQ WHAT (CADR B))
        (SETQ B (CDDR B))
        (COND ((EQ X 'TRACE) (SETQ TRACE-FUNCTION* WHAT))
              ((EQ X 'BUILD-TRACE) (SETQ BUILD-FUNCTION* WHAT))
              ((EQ X 'RETIRE-AT)
               (SETQ MAXIMUM-AGE* (SWNUMBER WHAT MAXIMUM-AGE*)))
              ((EQ X 'RESTART)
               (SETQ RESTART*
                     (SWASSOC WHAT '(ON T OFF NIL) RESTART*)))
              ((EQ X 'KEEP-LHS)
               (SETQ KEEP-LHS*
                     (SWASSOC WHAT '(ON T OFF NIL) KEEP-LHS*)))
              ((EQ X 'LHS-REFRESH)
               (SETQ REFRESH-LHS-FLAG*
                     (SWASSOC WHAT
                              '(ON T OFF NIL)
                              REFRESH-LHS-FLAG*)))
              ((EQ X 'COMPILE-PRIORITY)
               (SETQ ATOM-PRIORITY*
                     (SWASSOC WHAT
                              '(ORDER 0. SYMBOLS 1. LENGTH 0.)
                              ATOM-PRIORITY*))
               (SETQ LENGTH-PRIORITY*
                     (SWASSOC WHAT
                              '(ORDER 0. SYMBOLS 0. LENGTH 1.)
                              LENGTH-PRIORITY*)))
              (T (PRINC (CONS X '(NOT A SWITCH)))))
        (GO TOP))) 

(DEFUN SWASSOC (X LIST DEFAULT)
  (PROG NIL
   TOP  (COND ((ATOM LIST)
               (PRINC (CONS X '(NOT A VALID OPTION)))
               (RETURN DEFAULT))
              ((EQUAL X (CAR LIST)) (RETURN (CADR LIST))))
        (SETQ LIST (CDDR LIST))
        (GO TOP))) 

(DEFUN SWNUMBER (N DEFAULT)
  (COND ((NUMBERP N) N)
        (T (PRINC (CONS N '(NOT A NUMBER))) DEFAULT))) 

(DEFUN CYCLE-COUNT NIL CYCLE-COUNT*) 

(DEFUN ACTION-COUNT NIL ACTION-COUNT*) 

;* The following function has to know the form of an instantiation
;* if the compiler changes, this function must change too

(DEFUN RESTART-P NIL
  (COND ((NOT RESTART*) NIL)
        ((PRESENTP 'RESTART) NIL)
        (T '((NIL RESTART))))) 


;;; Top-level interpreter routines

(DEFUN MAIN NIL
  (PROG (START-TIME)
        (SETQ RUNNING* T)
        (SETQ HALT-FLAG* NIL)
        (SETQ INSTANCE* NIL)
        (SETQ START-TIME (TIME-GCTIME))
   DIL  (SETQ PHASE* 'AUTO-DELETE)
        (AUTOMATIC-DELETE)
        (SETQ PHASE* 'MATCH)
        (MAPC (FUNCTION REAL-DENY) DELETE-LIST*)
        (AND REFRESH-LHS-FLAG*
             INSTANCE*
             (MAPC (FUNCTION REFRESH) (CDR INSTANCE*)))
        (MAPC (FUNCTION REAL-ASSERT) ADD-LIST*)
        (MAPC (FUNCTION REMOVE-FROM-WM) DELETE-LIST*)
        (MAPC (FUNCTION UPDATE-RECENCY) CONFLICT-SET*)
        (SETQ PHASE* 'CONFICT-RESOLUTION)
        (COND (HALT-FLAG*
               (TERPRI)
               (PRINC '|END -- EXPLICIT HALT|)
               (GO FINIS)))
        (SETQ INSTANCE* (CONFLICT-RESOLUTION))
        (OR INSTANCE* (SETQ INSTANCE* (RESTART-P)))
        (COND ((NOT INSTANCE*)
               (TERPRI)
               (PRINC '|END -- NO PRODUCTION TRUE|)
               (GO FINIS)))
        (SETQ PHASE* 'ACT)
        (EVAL-RHS (EVAL-RHS-INIT (CAR INSTANCE*) (CDR INSTANCE*)))
        (SETQ PHASE* 'TRACE)
        (COND (TRACE-FUNCTION*
               (FUNCALL TRACE-FUNCTION*
                        (CAR INSTANCE*)
                        (CDR INSTANCE*)
                        ADD-LIST*
                        DELETE-LIST*)))
        (GO DIL)
   FINIS (SETQ RUNNING* NIL)
        (SETQ TOTAL-TIME*
              (+ TOTAL-TIME* (- (TIME-GCTIME) START-TIME)))
        (RETURN (PRINT-TIMES TOTAL-TIME*)))) 

(DEFUN PRINT-TIMES (TOTALTIME)
  (PROG (MSEC CC AC)
        (SETQ MSEC (//$ (FLOAT TOTALTIME) 1000.0))
        (SETQ CC (+$ (FLOAT CYCLE-COUNT*) 1.0E-20))
        (SETQ AC (+$ (FLOAT ACTION-COUNT*) 1.0E-20))
        (PM-SIZE)
        (PRINTLINEC (LIST CYCLE-COUNT*
                          '|firings|
                          (LIST ACTION-COUNT* '|RHS actions|)))
        (TERPRI)
        (PRINTLINEC (LIST (//$ (FLOAT TOTAL-WM*) CC)
                          '|mean working memory size|
                          (LIST MAX-WM* '|maximum|)))
        (TERPRI)
        (PRINTLINEC (LIST (//$ (FLOAT TOTAL-CS*) CC)
                          '|mean conflict set size|
                          (LIST MAX-CS* '|maximum|)))
        (TERPRI)
        (PRINTLINEC (LIST (//$ (FLOAT TOTAL-TOKEN*) CC)
                          '|mean token memory size|
                          (LIST MAX-TOKEN* '|maximum|)))
        (TERPRI)
        (PRINTLINEC (LIST (//$ MSEC 1000.0)
                          '|seconds|
                          (LIST (//$ MSEC CC) '|msec per firing|)
                          (LIST (//$ MSEC AC) '|msec per action|)))
        (TERPRI))) 

(DEFUN PM-SIZE NIL
  (TERPRI)
  (PRINTLINEC (LIST PCOUNT*
                    '|productions|
                    (LIST REAL-NODE-COUNT*
                          '//
                          VIRTUAL-NODE-COUNT*
                          '|nodes|)
                    (LIST REAL-FEATURES* '// FEATURES* '|features|)))
  (TERPRI)) 

(DEFUN AUTOMATIC-DELETE NIL
  (COND ((> ACTION-COUNT* NEXT-DELETE-TIME*)
         (MAPWM (FUNCTION DELETE-OLDS))
         (SETQ NEXT-DELETE-TIME*
               (+ ACTION-COUNT* (// MAXIMUM-AGE* 10.)))))) 


;;; Network Interpreter

(DEFUN MATCH (FLAG WME)
  (SENDTO FLAG (LIST WME) 'LEFT (LIST FIRST-NODE*))) 

(DEFUN &BUS (OUTS)
  (PROG (X)
        (SETQ ALPHA-FLAG-PART* FLAG-PART*)
        (SETQ ALPHA-DATA-PART* DATA-PART*)
        (SETQ X (CAR ALPHA-DATA-PART*))
        (SETQ REG0* X)
        (SETQ REG1*
              (SETQ REG2*
                    (SETQ REG3* (SETQ REG4* (SETQ REG5* NIL)))))
        (COND ((ATOM X) (GO LAB)))
        (SETQ REG1* (CAR X))
        (SETQ X (CDR X))
        (COND ((NOT X) (GO LAB)))
        (SETQ REG2* (CAR X))
        (SETQ X (CDR X))
        (COND ((NOT X) (GO LAB)))
        (SETQ REG3* (CAR X))
        (SETQ X (CDR X))
        (COND ((NOT X) (GO LAB)))
        (SETQ REG4* (CAR X))
        (SETQ X (CDR X))
        (COND ((NOT X) (GO LAB)))
        (SETQ REG5* (CAR X))
   LAB  (EVAL-NODELIST OUTS))) 

(DEFUN &ATOM (OUTS LOCATION PARM)
  (AND (EQUAL PARM (GELM LOCATION ALPHA-DATA-PART*))
       (EVAL-NODELIST OUTS))) 

(DEFUN &LEN (OUTS LOCATION LENGTH)
  (PROG (Z)
        (SETQ Z (GELM LOCATION ALPHA-DATA-PART*))
        (COND ((ATOM Z) (RETURN NIL))
              ((= (LENGTH Z) LENGTH) (EVAL-NODELIST OUTS))))) 

(DEFUN &LEN+ (OUTS LOCATION LENGTH)
  (PROG (Z)
        (SETQ Z (GELM LOCATION ALPHA-DATA-PART*))
        (COND ((ATOM Z) (RETURN NIL))
              ((NOT (< (LENGTH Z) LENGTH)) (EVAL-NODELIST OUTS))))) 

(DEFUN &USER (OUTS LOCATION PRED% ARGUMENTS)
  (AND (FUNCALL PRED% ARGUMENTS (GELM LOCATION ALPHA-DATA-PART*))
       (EVAL-NODELIST OUTS))) 

(DEFUN &VIN (OUTS LOCATION1 LOCATION2)
  (COND ((DO-TEST (FIND-PREDICATE LOCATION1 LOCATION2)
                  (GELM LOCATION1 ALPHA-DATA-PART*)
                  (GELM LOCATION2 ALPHA-DATA-PART*))
         (EVAL-NODELIST OUTS)))) 

(DEFUN &P (RATING NAME)
  (PROG (FP DP)
        (COND (SENDTOCALL*
               (SETQ FP FLAG-PART*)
               (SETQ DP DATA-PART*))
              (T
               (SETQ FP ALPHA-FLAG-PART*)
               (SETQ DP ALPHA-DATA-PART*)))
        (AND (MEMQ FP '(NIL OLD)) (REMOVECS NAME DP))
        (AND FP (INSERTCS NAME DP RATING)))) 

(DEFUN &OLD (A B) NIL) 

(DEFUN &TWO (RIGHT-OUTS LEFT-OUTS)
  (PROG (FP DP)
        (COND (SENDTOCALL*
               (SETQ FP FLAG-PART*)
               (SETQ DP DATA-PART*))
              (T
               (SETQ FP ALPHA-FLAG-PART*)
               (SETQ DP ALPHA-DATA-PART*)))
        (SENDTO FP DP 'LEFT LEFT-OUTS)
        (SENDTO FP DP 'RIGHT RIGHT-OUTS))) 

(DEFUN &MEM (RIGHT-OUTS LEFT-OUTS MEMORY-LIST)
  (PROG (FP DP)
        (COND (SENDTOCALL*
               (SETQ FP FLAG-PART*)
               (SETQ DP DATA-PART*))
              (T
               (SETQ FP ALPHA-FLAG-PART*)
               (SETQ DP ALPHA-DATA-PART*)))
        (SENDTO FP DP 'LEFT LEFT-OUTS)
        (ADD-TOKEN MEMORY-LIST FP DP NIL)
        (SENDTO FP DP 'RIGHT RIGHT-OUTS))) 

(DEFUN FIND-PREDICATE (X Y)
  (PROG (XV YV)
        (SETQ XV (CAR (LOCVEC X)))
        (SETQ YV (CAR (LOCVEC Y)))
        (RETURN (COND ((EQ XV '=) (CADR (ASSOC YV VAR-FNS*)))
                      (T (CADDR (ASSOC XV VAR-FNS*))))))) 

(DEFUN DO-TEST (P A B)
  (COND ((EQ P 'EQUAL) (EQUAL A B))
        ((EQ P 'NOT-EQUAL) (NOT (EQUAL A B)))
        (T (FUNCALL P A B)))) 

(DEFUN &VNO (A B C) (&VEX A B C NIL NIL)) 

(DEFUN &VEX (RIGHT-OUTS RT-PRED LEF-PRED LOCATION1 LOCATION2)
  (PROG (MEM)
        (COND ((EQ SIDE* 'RIGHT)
               (SETQ MEM (MEMORY-PART LEF-PRED)))
              (T (SETQ MEM (MEMORY-PART RT-PRED))))
        (COND (MEM (DO&VEX RIGHT-OUTS MEM LOCATION1 LOCATION2))))) 

(DEFUN DO&VEX (RIGHT-OUTS MEMORY LOCATION1 LOCATION2)
  (PROG (SIDE FLAG-PART DATA-PART MEMPART TOKPART T1 T2 T3 T4 T5
         T6 X1 X2 X3 X4 X5 X6 RMEM-ELEM LMEM-ELEM)
        (SETQ SIDE SIDE*)
        (SETQ FLAG-PART FLAG-PART*)
        (SETQ DATA-PART DATA-PART*)
        (COND ((EQ SIDE 'LEFT)
               (SETQ TOKPART LOCATION1)
               (SETQ MEMPART LOCATION2))
              (T (SETQ TOKPART LOCATION2) (SETQ MEMPART LOCATION1)))
        (COND ((NOT TOKPART) (GO LAB3)))
        (SETQ T1 (FIND-PREDICATE (CAR TOKPART) (CAR MEMPART)))
        (SETQ X1 (GELM (CAR TOKPART) DATA-PART))
        (SETQ TOKPART (CDR TOKPART))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT TOKPART) (GO LAB3)))
        (SETQ T2 (FIND-PREDICATE (CAR TOKPART) (CAR MEMPART)))
        (SETQ X2 (GELM (CAR TOKPART) DATA-PART))
        (SETQ TOKPART (CDR TOKPART))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT TOKPART) (GO LAB3)))
        (SETQ T3 (FIND-PREDICATE (CAR TOKPART) (CAR MEMPART)))
        (SETQ X3 (GELM (CAR TOKPART) DATA-PART))
        (SETQ TOKPART (CDR TOKPART))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT TOKPART) (GO LAB3)))
        (SETQ T4 (FIND-PREDICATE (CAR TOKPART) (CAR MEMPART)))
        (SETQ X4 (GELM (CAR TOKPART) DATA-PART))
        (SETQ TOKPART (CDR TOKPART))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT TOKPART) (GO LAB3)))
        (SETQ T5 (FIND-PREDICATE (CAR TOKPART) (CAR MEMPART)))
        (SETQ X5 (GELM (CAR TOKPART) DATA-PART))
        (SETQ TOKPART (CDR TOKPART))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT TOKPART) (GO LAB3)))
        (SETQ T6 (FIND-PREDICATE (CAR TOKPART) (CAR MEMPART)))
        (SETQ X6 (GELM (CAR TOKPART) DATA-PART))
   LAB3 (COND ((EQ SIDE 'RIGHT) (GO LAB2)))
   LAB1 (COND ((NOT MEMORY) (RETURN NIL)))
        (SETQ RMEM-ELEM (CAR MEMORY))
        (SETQ MEMORY (CDR MEMORY))
        (SETQ MEMPART LOCATION2)
        (COND ((NOT MEMPART) (GO SUCC1))
              ((NOT (DO-TEST T1 X1 (GELM (CAR MEMPART) RMEM-ELEM)))
               (GO LAB1)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC1))
              ((NOT (DO-TEST T2 X2 (GELM (CAR MEMPART) RMEM-ELEM)))
               (GO LAB1)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC1))
              ((NOT (DO-TEST T3 X3 (GELM (CAR MEMPART) RMEM-ELEM)))
               (GO LAB1)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC1))
              ((NOT (DO-TEST T4 X4 (GELM (CAR MEMPART) RMEM-ELEM)))
               (GO LAB1)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC1))
              ((NOT (DO-TEST T5 X5 (GELM (CAR MEMPART) RMEM-ELEM)))
               (GO LAB1)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC1))
              ((NOT (DO-TEST T6 X6 (GELM (CAR MEMPART) RMEM-ELEM)))
               (GO LAB1)))
   SUCC1 (SENDTO FLAG-PART
                 (CONS (CAR RMEM-ELEM) DATA-PART)
                 'RIGHT
                 RIGHT-OUTS)
        (GO LAB1)
   LAB2 (COND ((NOT MEMORY) (RETURN NIL)))
        (SETQ LMEM-ELEM (CAR MEMORY))
        (SETQ MEMORY (CDR MEMORY))
        (SETQ MEMPART LOCATION1)
        (COND ((NOT MEMPART) (GO SUCC2))
              ((NOT (DO-TEST T1 X1 (GELM (CAR MEMPART) LMEM-ELEM)))
               (GO LAB2)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC2))
              ((NOT (DO-TEST T2 X2 (GELM (CAR MEMPART) LMEM-ELEM)))
               (GO LAB2)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC2))
              ((NOT (DO-TEST T3 X3 (GELM (CAR MEMPART) LMEM-ELEM)))
               (GO LAB2)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC2))
              ((NOT (DO-TEST T4 X4 (GELM (CAR MEMPART) LMEM-ELEM)))
               (GO LAB2)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC2))
              ((NOT (DO-TEST T5 X5 (GELM (CAR MEMPART) LMEM-ELEM)))
               (GO LAB2)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC2))
              ((NOT (DO-TEST T6 X6 (GELM (CAR MEMPART) LMEM-ELEM)))
               (GO LAB2)))
   SUCC2 (SENDTO FLAG-PART
                 (CONS (CAR DATA-PART) LMEM-ELEM)
                 'RIGHT
                 RIGHT-OUTS)
        (GO LAB2))) 

(DEFUN &NOT (RIGHT-OUTS RT-PRED LEF-MEM LOCATION1 LOCATION2)
  (PROG (MEM)
        (COND ((AND (EQ SIDE* 'RIGHT) (EQ FLAG-PART* 'OLD))
               (RETURN NIL)))
        (COND ((EQ SIDE* 'RIGHT) (SETQ MEM (CAR LEF-MEM)))
              (T (SETQ MEM (MEMORY-PART RT-PRED))))
        (COND ((OR MEM (EQ SIDE* 'LEFT))
               (DO&NOT RIGHT-OUTS MEM LEF-MEM LOCATION1 LOCATION2))))) 

(DEFUN DO&NOT (RIGHT-OUTS MEMORY LEF-MEM LOCATION1 LOCATION2)
  (PROG (SIDE FLAG-PART DATA-PART NUMBER-DENIALS MEMPART TOKPART
         T1 T2 T3 T4 T5 T6 X1 X2 X3 X4 X5 X6 RMEM-ELEM LMEM-ELEM
         REST-LMEM)
        (SETQ SIDE SIDE*)
        (SETQ FLAG-PART FLAG-PART*)
        (SETQ DATA-PART DATA-PART*)
        (COND ((EQ SIDE 'LEFT)
               (SETQ TOKPART LOCATION1)
               (SETQ MEMPART LOCATION2))
              (T (SETQ TOKPART LOCATION2) (SETQ MEMPART LOCATION1)))
        (COND ((NOT TOKPART) (GO LAB3)))
        (SETQ T1 (FIND-PREDICATE (CAR TOKPART) (CAR MEMPART)))
        (SETQ X1 (GELM (CAR TOKPART) DATA-PART))
        (SETQ TOKPART (CDR TOKPART))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT TOKPART) (GO LAB3)))
        (SETQ T2 (FIND-PREDICATE (CAR TOKPART) (CAR MEMPART)))
        (SETQ X2 (GELM (CAR TOKPART) DATA-PART))
        (SETQ TOKPART (CDR TOKPART))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT TOKPART) (GO LAB3)))
        (SETQ T3 (FIND-PREDICATE (CAR TOKPART) (CAR MEMPART)))
        (SETQ X3 (GELM (CAR TOKPART) DATA-PART))
        (SETQ TOKPART (CDR TOKPART))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT TOKPART) (GO LAB3)))
        (SETQ T4 (FIND-PREDICATE (CAR TOKPART) (CAR MEMPART)))
        (SETQ X4 (GELM (CAR TOKPART) DATA-PART))
        (SETQ TOKPART (CDR TOKPART))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT TOKPART) (GO LAB3)))
        (SETQ T5 (FIND-PREDICATE (CAR TOKPART) (CAR MEMPART)))
        (SETQ X5 (GELM (CAR TOKPART) DATA-PART))
        (SETQ TOKPART (CDR TOKPART))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT TOKPART) (GO LAB3)))
        (SETQ T6 (FIND-PREDICATE (CAR TOKPART) (CAR MEMPART)))
        (SETQ X6 (GELM (CAR TOKPART) DATA-PART))
   LAB3 (COND ((EQ SIDE 'RIGHT) (GO RNEW)))
        (SETQ NUMBER-DENIALS 0.)
   LNEW (COND ((NOT MEMORY) (GO LBL)))
        (SETQ RMEM-ELEM (CAR MEMORY))
        (SETQ MEMORY (CDR MEMORY))
        (SETQ MEMPART LOCATION2)
        (COND ((NOT MEMPART) (GO SUCC1))
              ((NOT (DO-TEST T1 X1 (GELM (CAR MEMPART) RMEM-ELEM)))
               (GO LNEW)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC1))
              ((NOT (DO-TEST T2 X2 (GELM (CAR MEMPART) RMEM-ELEM)))
               (GO LNEW)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC1))
              ((NOT (DO-TEST T3 X3 (GELM (CAR MEMPART) RMEM-ELEM)))
               (GO LNEW)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC1))
              ((NOT (DO-TEST T4 X4 (GELM (CAR MEMPART) RMEM-ELEM)))
               (GO LNEW)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC1))
              ((NOT (DO-TEST T5 X5 (GELM (CAR MEMPART) RMEM-ELEM)))
               (GO LNEW)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC1))
              ((NOT (DO-TEST T6 X6 (GELM (CAR MEMPART) RMEM-ELEM)))
               (GO LNEW)))
   SUCC1 (SETQ NUMBER-DENIALS (1+ NUMBER-DENIALS))
        (GO LNEW)
   LBL  (ADD-TOKEN LEF-MEM FLAG-PART DATA-PART NUMBER-DENIALS)
        (COND ((= NUMBER-DENIALS 0.)
               (SENDTO FLAG-PART DATA-PART 'RIGHT RIGHT-OUTS)))
        (RETURN NIL)
   RNEW (SETQ REST-LMEM MEMORY)
   LOC-LOOP (COND ((ATOM REST-LMEM) (RETURN NIL)))
        (SETQ NUMBER-DENIALS (CADR REST-LMEM))
        (SETQ LMEM-ELEM (CAR REST-LMEM))
        (SETQ MEMPART LOCATION1)
        (COND ((NOT MEMPART) (GO SUCC2))
              ((NOT (DO-TEST T1 X1 (GELM (CAR MEMPART) LMEM-ELEM)))
               (GO LAB2)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC2))
              ((NOT (DO-TEST T2 X2 (GELM (CAR MEMPART) LMEM-ELEM)))
               (GO LAB2)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC2))
              ((NOT (DO-TEST T3 X3 (GELM (CAR MEMPART) LMEM-ELEM)))
               (GO LAB2)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC2))
              ((NOT (DO-TEST T4 X4 (GELM (CAR MEMPART) LMEM-ELEM)))
               (GO LAB2)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC2))
              ((NOT (DO-TEST T5 X5 (GELM (CAR MEMPART) LMEM-ELEM)))
               (GO LAB2)))
        (SETQ MEMPART (CDR MEMPART))
        (COND ((NOT MEMPART) (GO SUCC2))
              ((NOT (DO-TEST T6 X6 (GELM (CAR MEMPART) LMEM-ELEM)))
               (GO LAB2)))
   SUCC2 (COND (FLAG-PART
                (SETQ NUMBER-DENIALS (1+ NUMBER-DENIALS))
                (RPLACA (CDR REST-LMEM) NUMBER-DENIALS)
                (AND (= NUMBER-DENIALS 1.)
                     (SENDTO NIL LMEM-ELEM 'RIGHT RIGHT-OUTS)))
               (T
                (SETQ NUMBER-DENIALS (1- NUMBER-DENIALS))
                (RPLACA (CDR REST-LMEM) NUMBER-DENIALS)
                (AND (= NUMBER-DENIALS 0.)
                     (SENDTO 'NEW LMEM-ELEM 'RIGHT RIGHT-OUTS))))
   LAB2 (SETQ REST-LMEM (CDDR REST-LMEM))
        (GO LOC-LOOP))) 

(DEFUN SENDTO (FLAG DATA SIDE NODELIST)
  (PROG (F AL NODE)
   L1   (OR NODELIST (RETURN NIL))
        (SETQ NODE (CAR NODELIST))
        (SETQ NODELIST (CDR NODELIST))
        (AND BUILD-FLAG* (NOT (MEMQ NODE BUILD-FLAG*)) (GO L1))
        (SETQ SIDE* SIDE)
        (SETQ FLAG-PART* FLAG)
        (SETQ DATA-PART* DATA)
        (SETQ SENDTOCALL* T)
        (SETQ F (CAR NODE))
        (SETQ AL (CDR NODE))
        (COND ((EQ F '&VEX)
               (&VEX (CXR 2. NODE)
                     (CXR 3. NODE)
                     (CXR 4. NODE)
                     (CXR 5. NODE)
                     (CXR 0. NODE)))
              ((EQ F '&MEM) (&MEM (CAR AL) (CADR AL) (CADDR AL)))
              ((EQ F '&VNO)
               (&VNO (CXR 2. NODE) (CXR 3. NODE) (CXR 0. NODE)))
              ((EQ F '&NOT)
               (&NOT (CXR 2. NODE)
                     (CXR 3. NODE)
                     (CXR 4. NODE)
                     (CXR 5. NODE)
                     (CXR 0. NODE)))
              ((EQ F '&TWO) (&TWO (CAR AL) (CADR AL)))
              ((EQ F '&P) (&P (CAR AL) (CADR AL)))
              ((EQ F '&BUS) (&BUS (CAR AL)))
              ((EQ F '&OLD) (&OLD (CAR AL) (CADR AL))))
        (GO L1))) 

(DEFUN EVAL-NODELIST (NL)
  (PROG (N F AL)
   LAB  (COND ((NOT NL) (RETURN NIL)))
        (SETQ N (CAR NL))
        (SETQ NL (CDR NL))
        (SETQ F (CAR N))
        (SETQ AL (CDR N))
        (SETQ SENDTOCALL* NIL)
        (COND ((AND BUILD-FLAG* (NOT (MEMQ N BUILD-FLAG*))))
              ((EQ F '&LEN)
               (&LEN (CXR 2. N) (CXR 3. N) (CXR 0. N)))
              ((EQ F '&ATOM)
               (&ATOM (CXR 2. N) (CXR 3. N) (CXR 0. N)))
              ((EQ F '&LEN+)
               (&LEN+ (CXR 2. N) (CXR 3. N) (CXR 0. N)))
              ((EQ F '&MEM) (&MEM (CAR AL) (CADR AL) (CADDR AL)))
              ((EQ F '&TWO) (&TWO (CAR AL) (CADR AL)))
              ((EQ F '&USER)
               (&USER (CAR AL) (CADR AL) (CADDR AL) (CADDDR AL)))
              ((EQ F '&P) (&P (CAR AL) (CADR AL)))
              ((EQ F '&VIN)
               (&VIN (CXR 2. N) (CXR 3. N) (CXR 0. N)))
              ((EQ F '&OLD) (&OLD (CAR AL) (CADR AL))))
        (GO LAB))) 


;;; Conflict Resolution
; Each conflict set element is a list of the following form:
; ((p-name . data-part) (sorted wm-recency) special-case-number)

(DEFMACRO PNAME-INSTANTIATION (CONFLICT-ELEM) `(CAR ,CONFLICT-ELEM)) 

(DEFMACRO INSTANTIATION (CONFLICT-ELEM) `(CDAR ,CONFLICT-ELEM))

(DEFMACRO ORDER-PART (CONFLICT-ELEM) `(CDR ,CONFLICT-ELEM)) 

(DEFUN REMOVECS (NAME DATA)
  (PROG (CR-DATA INST)
        (SETQ CR-DATA (CONS NAME DATA))
        (SETQ INST (ASSOC CR-DATA CONFLICT-SET*))
        (AND INST (SETQ CONFLICT-SET* (DELQ INST CONFLICT-SET*))))) 

(DEFUN INSERTCS (NAME DATA RATING)
  (PROG (INSTAN)
        (SETQ INSTAN
              (LIST (CONS NAME DATA)
                    (DSORT (MAPCAR (FUNCTION CREATION-TIME) DATA))
                    RATING))
        (COND ((ATOM CONFLICT-SET*)
               (RETURN (SETQ CONFLICT-SET* (NCONS INSTAN))))
              (T
               (RETURN (SETQ CONFLICT-SET*
                             (CONS INSTAN CONFLICT-SET*))))))) 

; Destructively sort X into descending order

(DEFUN DSORT (X)
  (PROG (SORTED CUR NEXT CVAL NVAL)
        (AND (ATOM (CDR X)) (RETURN X))
   LOC-LOOP (SETQ SORTED T)
        (SETQ CUR X)
        (SETQ NEXT (CDR X))
   CHEK (SETQ CVAL (CAR CUR))
        (SETQ NVAL (CAR NEXT))
        (COND ((> NVAL CVAL)
               (SETQ SORTED NIL)
               (RPLACA CUR NVAL)
               (RPLACA NEXT CVAL)))
        (SETQ CUR NEXT)
        (SETQ NEXT (CDR CUR))
        (COND ((NOT (NULL NEXT)) (GO CHEK))
              (SORTED (RETURN X))
              (T (GO LOC-LOOP))))) 

(DEFUN CONFLICT-RESOLUTION NIL
  (PROG (BEST LEN)
        (SETQ LEN (LENGTH CONFLICT-SET*))
        (COND ((> LEN MAX-CS*) (SETQ MAX-CS* LEN)))
        (SETQ TOTAL-CS* (+ TOTAL-CS* LEN))
        (COND (CONFLICT-SET*
               (SETQ BEST (BEST-OF CONFLICT-SET*))
               (SETQ CONFLICT-SET* (DELQ BEST CONFLICT-SET*))
               (RETURN (PNAME-INSTANTIATION BEST)))
              (T (RETURN NIL))))) 

(DEFUN BEST-OF (SET) (BEST-OF* (CAR SET) (CDR SET))) 

(DEFUN BEST-OF* (BEST REM)
  (COND ((NOT REM) BEST)
        ((CONFLICT-SET-COMPARE BEST (CAR REM))
         (BEST-OF* BEST (CDR REM)))
        (T (BEST-OF* (CAR REM) (CDR REM))))) 

(DEFUN REMOVE-FROM-CONFLICT-SET (NAME)
  (PROG (CS ENTRY)
   L1   (SETQ CS CONFLICT-SET*)
   L2   (COND ((ATOM CS) (RETURN NIL)))
        (SETQ ENTRY (CAR CS))
        (SETQ CS (CDR CS))
        (COND ((EQ NAME (CAAR ENTRY))
               (SETQ CONFLICT-SET* (DELQ ENTRY CONFLICT-SET*))
               (GO L1))
              (T (GO L2))))) 

; conflict-set-compare was made faster and simpler by replacing the
; two mapc's by explicit LOC-LOOPs

(defun conflict-set-compare (x y)
  (prog (x-order y-order xl yl xv yv)
        (setq x-order (order-part x))
        (setq y-order (order-part y))
        (setq xl (car x-order))
        (setq yl (car y-order))
   data (cond ((and (null xl) (null yl)) (go ps))
              ((null yl) (return t))
              ((null xl) (return nil)))
        (setq xv (car xl))
        (setq yv (car yl))
        (cond ((> xv yv) (return t))
              ((> yv xv) (return nil)))
        (setq xl (cdr xl))
        (setq yl (cdr yl))
        (go data)
   ps   (setq xl (cdr x-order))
        (setq yl (cdr y-order))
   psl  (cond ((null xl) (return t)))
        (setq xv (car xl))
        (setq yv (car yl))
        (cond ((> xv yv) (return t))
              ((> yv xv) (return nil)))
        (setq xl (cdr xl))
        (setq yl (cdr yl))
        (go psl))) 

(DEFUN UPDATE-RECENCY (ENTRY)
  (PROG (DATA TIMES)
        (SETQ DATA (INSTANTIATION ENTRY))
        (OR (INTERSECTQ DATA REFRESHED-WMES*) (RETURN ENTRY))
        (SETQ TIMES (DSORT (MAPCAR (FUNCTION CREATION-TIME) DATA)))
        (RPLACA (ORDER-PART ENTRY) TIMES)
        (RETURN ENTRY))) 

(DEFUN INTERSECTQ (SHORT LONG)
  (DO ((X SHORT (CDR X)))
      ((NOT X) NIL)
      (AND (MEMQ (CAR X) LONG) (RETURN (CAR X))))) 


;;; RHS interpreter

(DEFPROP <READ> T RHS-FN)

(DEFUN <READ> FEXPR (L)
  (COND ((NULL L) (OPS-READ))
        (T
         (TERPRI)
         (TERPRI)
         (PRINTLINEC '(ACTION ERROR))
         (TERPRI)
         (TERPRI)
         (PRINTLINEC '(<READ> SHOULD NOT HAVE ARGUMENTS))
         (TERPRI)
         (PRINTLINEC L)
         (TERPRI)
         NIL))) 

(DEFPROP <WRITE> T RHS-FN)

(DEFUN <WRITE> FEXPR (L)
  (TERPRI)
  (COND ((NOT (ATOM L)) (PRINTLINEC (APPLY 'EVAL-LIST L))))
  NIL) 

(DEFPROP <WRITE&> T RHS-FN)

(DEFUN <WRITE&> FEXPR (L)
  (COND ((NOT (ATOM L)) (PRINTLINEC (APPLY 'EVAL-LIST L))))
  NIL) 

(DEFPROP <ADD> T RHS-FN)

(DEFUN <ADD> FEXPR (L)
  (MAPC (FUNCTION ASSERT) (APPLY 'EVAL-LIST L))
  NIL) 

(DEFPROP <DELETE> T RHS-FN)

(DEFUN <DELETE> FEXPR (L)
  (MAPC (FUNCTION DENY) (APPLY 'EVAL-LIST L))
  NIL) 

(DEFPROP <REASSERT> T RHS-FN)

(DEFUN <REASSERT> FEXPR (L)
  (MAPC (FUNCTION REASSERT) (APPLY 'EVAL-LIST L))
  NIL) 

(DEFPROP <NULL> T RHS-FN)

(DEFUN <NULL> FEXPR (L) (APPLY 'EVAL-LIST L) NIL) 

(DEFPROP <EXCISE> T RHS-FN)

(DEFUN <EXCISE> FEXPR (L)
  (PROG (ARGS)
        (SETQ ARGS (APPLY 'EVAL-LIST L))
        (MAPC (FUNCTION EXCISE-P) ARGS)
        (RETURN NIL))) 

(DEFPROP <BUILD> T RHS-FN)

(DEFUN <BUILD> FEXPR (L)
  (PROG (ARGLIST Z LEN)
        (SETQ ARGLIST (APPLY 'EVAL-LIST L))
        (SETQ LEN (LENGTH ARGLIST))
        (COND ((= LEN 0.)
               (TERPRI)
               (TERPRI)
               (PRINTLINEC '(ACTION ERROR))
               (TERPRI)
               (TERPRI)
               (PRINTLINEC '(NO ARGUMENT SUPPLIED TO <BUILD>))
               (TERPRI)
               (RETURN NIL))
              ((= LEN 1.)
               (BUILDIT (SETQ Z (MAKE-NEW-P-NAME)) (CAR ARGLIST))
               (RETURN (LIST Z)))
              ((= LEN 2.)
               (BUILDIT (CAR ARGLIST) (CADR ARGLIST))
               (COND ((CAR ARGLIST) (RETURN (LIST (CAR ARGLIST))))
                     (T (RETURN NIL))))
              (T
               (TERPRI)
               (TERPRI)
               (PRINTLINEC '(ACTION ERROR))
               (TERPRI)
               (TERPRI)
               (PRINTLINEC '(TOO MANY ARGUMENTS TO <BUILD>))
               (TERPRI)
               (PRINTLINEC ARGLIST)
               (TERPRI)
               (RETURN NIL))))) 

(DEFUN MAKE-NEW-P-NAME NIL
  (PROG (X)
   LOC-LOOP (SETQ X (GENSYM))
        (INTERN X)
        (COND ((GET X 'RHS) (GO LOC-LOOP)))
        (RETURN X))) 

(DEFPROP <READP> T RHS-FN)

(DEFUN <READP> FEXPR (L)
  (PROG (ARGLIST Z LEN)
        (SETQ ARGLIST (APPLY 'EVAL-LIST L))
        (SETQ LEN (LENGTH ARGLIST))
        (COND ((= LEN 0.)
               (TERPRI)
               (TERPRI)
               (PRINTLINEC '(ACTION ERROR))
               (TERPRI)
               (TERPRI)
               (PRINTLINEC '(NO ARGUMENT SUPPLIED TO <READP>))
               (TERPRI)
               (RETURN NIL))
              ((= LEN 1.)
               (COND ((SYMBOLP (CAR ARGLIST))
                      (SETQ Z (GET (CAR ARGLIST) 'PRODUCTION))
                      (COND (Z (RETURN (LIST Z)))))
                     (T
                      (TERPRI)
                      (TERPRI)
                      (PRINTLINEC '(ACTION ERROR))
                      (TERPRI)
                      (TERPRI)
                      (PRINTLINEC '(ARGUMENT TO
                                             <READP>
                                             NOT
                                             A
                                             LITERAL
                                             ATOM))
                      (PRINC (CAR ARGLIST))
                      (TERPRI)
                      (RETURN NIL))))
              (T
               (TERPRI)
               (TERPRI)
               (PRINTLINEC '(ACTION ERROR))
               (TERPRI)
               (TERPRI)
               (PRINTLINEC '(TOO MANY ARGUMENTS TO <READP>))
               (TERPRI)
               (PRINTLINEC ARGLIST)
               (TERPRI)
               (RETURN NIL))))) 

(DEFUN BUILDIT (NAME MATRIX)
  (COMPILE-AND-UPDATE NAME (COPY MATRIX))
  (COND (BUILD-FUNCTION* (FUNCALL BUILD-FUNCTION* NAME)))) 

(DEFPROP <BIND> T RHS-FN)

(DEFUN <BIND> FEXPR (L)
  (PROG (ARGUMENTS LEN)
        (SETQ ARGUMENTS (APPLY 'EVAL-LIST L))
        (SETQ LEN (LENGTH ARGUMENTS))
        (COND ((= LEN 0.)
               (SETQ LAST-GENBIND* (ADD1 LAST-GENBIND*)))
              ((= LEN 1.)
               (COND ((SYMBOLP (CAR ARGUMENTS))
                      (SETQ LAST-GENBIND* (ADD1 LAST-GENBIND*))
                      (SETQ VARIABLE-MEMORY*
                            (CONS (CONS (CAR ARGUMENTS)
                                        LAST-GENBIND*)
                                  VARIABLE-MEMORY*)))
                     (T
                      (TERPRI)
                      (TERPRI)
                      (PRINTLINEC '(ACTION ERROR))
                      (TERPRI)
                      (TERPRI)
                      (PRINTLINEC '(OBJECT TO
                                           BE
                                           BOUND
                                           NOT
                                           A
                                           LITERAL
                                           ATOM))
                      (PRINC (CAR ARGUMENTS))
                      (TERPRI)
                      (RETURN NIL))))
              ((= LEN 2.)
               (COND ((SYMBOLP (CAR ARGUMENTS))
                      (SETQ VARIABLE-MEMORY*
                            (CONS (CONS (CAR ARGUMENTS)
                                        (CADR ARGUMENTS))
                                  VARIABLE-MEMORY*))
                      (RETURN (NCONS (CADR ARGUMENTS))))
                     (T
                      (TERPRI)
                      (TERPRI)
                      (PRINTLINEC '(ACTION ERROR))
                      (TERPRI)
                      (TERPRI)
                      (PRINTLINEC '(OBJECT TO
                                           BE
                                           BOUND
                                           NOT
                                           A
                                           LITERAL
                                           ATOM))
                      (PRINC (CAR ARGUMENTS))
                      (TERPRI)
                      (RETURN NIL))))
              (T
               (TERPRI)
               (TERPRI)
               (PRINTLINEC '(ACTION ERROR))
               (TERPRI)
               (TERPRI)
               (PRINTLINEC '(TOO MANY ARGUMENTS TO <BIND>))
               (TERPRI)
               (PRINTLINEC ARGUMENTS)
               (TERPRI)
               (RETURN NIL)))
        (RETURN (NCONS LAST-GENBIND*)))) 

(DEFPROP <QUOTE> T RHS-FN)

(DEFUN <QUOTE> FEXPR (L) L) 

(DEFPROP <HALT> T RHS-FN)

(DEFUN <HALT> FEXPR (L) (SETQ HALT-FLAG* T) L) 

(DEFPROP <EVAL> T RHS-FN)

(DEFUN <EVAL> FEXPR (L) (APPLY 'EVAL-LIST (APPLY 'EVAL-LIST L))) 

(DEFUN EVAL-RHS (RHS)
  (AND (READP)
       (SETQ RHS (CONS '(<REASSERT> (ATTEND (<READ>))) RHS)))
  (MAPC (FUNCTION (LAMBDA (X)
                    (MAPC (FUNCTION ASSERT) (EVAL-ELEM X))))
        RHS)) 

(DEFUN EVAL-RHS-INIT (PNAME DATA)
  (PROG (R)
        (SETQ SEGMENT* NIL)
        (SETQ CYCLE-COUNT* (1+ CYCLE-COUNT*))
        (SETQ TOTAL-TOKEN* (+ TOTAL-TOKEN* CURRENT-TOKEN*))
        (COND ((> CURRENT-TOKEN* MAX-TOKEN*)
               (SETQ MAX-TOKEN* CURRENT-TOKEN*)))
        (SETQ TOTAL-WM* (+ TOTAL-WM* CURRENT-WM*))
        (COND ((> CURRENT-WM* MAX-WM*) (SETQ MAX-WM* CURRENT-WM*)))
        (SETQ ADD-LIST* (SETQ DELETE-LIST* NIL))
        (SETQ REASSERT-LIST* (SETQ REFRESHED-WMES* NIL))
        (SETQ VARIABLE-MEMORY* NIL)
        (SETQ DATA-MATCHED* DATA)
        (COND ((ATOM PNAME)
               (SETQ VARIABLE-DOPE* (GET PNAME 'VARIABLE-DOPE))
               (SETQ R (GET PNAME 'RHS)))
              (T
               (SETQ VARIABLE-DOPE* (DOPE-PART PNAME))
               (SETQ R (RHS-PART PNAME))))
        (RETURN R))) 

(DEFUN EVAL-LIST FEXPR (ELEMS)
  (MAPCAN (FUNCTION (LAMBDA (LIST-ELEM) (EVAL-ELEM LIST-ELEM)))
          ELEMS)) 

(DEFUN OPS-VARIABLE-VALUE (VAR)
  (PROG (BIND VB VALUE)
        (SETQ FOUND-BINDING* NIL)
        (SETQ BIND (ASSQ VAR VARIABLE-MEMORY*))
        (COND (BIND (SETQ FOUND-BINDING* T) (RETURN (CDR BIND))))
        (SETQ VB (ASSQ VAR VARIABLE-DOPE*))
        (COND ((NOT VB) (RETURN NIL)))
        (SETQ VALUE (GELM (CDR VB) DATA-MATCHED*))
        (SETQ VARIABLE-MEMORY*
              (CONS (CONS VAR VALUE) VARIABLE-MEMORY*))
        (SETQ FOUND-BINDING* T)
        (RETURN VALUE))) 

(DEFUN EVAL-ELEM (ELEM)
  (PROG (BINDING ELEM-VALUE SFLAG R)
        (SETQ SFLAG SEGMENT*)
        (SETQ SEGMENT* NIL)
        (SETQ R NIL)
        (COND ((EQ '! ELEM) (SETQ SEGMENT* T))
              ((NUMBERP ELEM) (SETQ R (FLATTEN ELEM SFLAG)))
              ((ATOM ELEM)
               (SETQ BINDING (OPS-VARIABLE-VALUE ELEM))
               (SETQ ELEM-VALUE
                     (COND (FOUND-BINDING* BINDING)
                           (T ELEM)))
               (SETQ R (FLATTEN ELEM-VALUE SFLAG)))
              ((AND (CONSP ELEM)
                    (SYMBOLP (CAR ELEM))
                    (GET (CAR ELEM) 'RHS-FN))
               (SETQ ELEM-VALUE (EVAL ELEM))
               (SETQ R
                     (COND (SFLAG
                            (MAPCAN (FUNCTION (LAMBDA (SUB-ELEM)
                                                (FLATTEN SUB-ELEM
                  T)))
                                    ELEM-VALUE))
                           (T (COPY1L ELEM-VALUE)))))
              (T (SETQ R (FLATTEN (APPLY 'EVAL-LIST ELEM) SFLAG))))
        (RETURN R))) 

; FLATTEN was changed so that ! before an atom is ignored

(DEFUN FLATTEN (Z FLAG)
  (COND ((NOT FLAG) (NCONS Z))
        ((NOT Z) NIL)
        ((CONSP Z) (COPY1L Z))
        (T (NCONS Z)))) 

(DEFUN COPY1L (X)
  (COND ((ATOM X) X)
        (T (CONS (CAR X) (COPY1L (CDR X)))))) 

(DEFUN RHS-FUNCTION FEXPR (L)
  (MAPC (FUNCTION (LAMBDA (FNAME) (PUTPROP FNAME T 'RHS-FN))) L)) 

; PASSIVATE undoes the effect of PREDICATE and ACTIVATE
; (DEFUN PASSIVATE FEXPR (L)
;     (MAPC (FUNCTION (LAMBDA (FNAME) (REMPROP FNAME 'RHS-FN) 
; 				    (REMPROP FNAME 'LHS-FN)))
; 	  L))

(DEFUN OPS-READ NIL
  (PROG (R)
        (TERPRI)
        (SETQ <READ>-LINE* NIL)
        (SETQ R (OPS-READ*))
        (RETURN R))) 

(DEFUN OPS-READ* NIL
  (PROG (CHAR LAST-CHAR IDENT RESULT)
        (SETQ RESULT NIL)
        (SETQ CHAR 0.)
        (SETQ IDENT NIL)
   TOP  (OR <READ>-LINE* (SETQ <READ>-LINE* (OPS-READ**)))
        (SETQ LAST-CHAR CHAR)
        (SETQ CHAR (CAR <READ>-LINE*))
        (SETQ <READ>-LINE* (CDR <READ>-LINE*))
        (COND ((AND (= CHAR 46.)
                    (MEMBER LAST-CHAR
                            '(48.
                              49.
                              50.
                              51.
                              52.
                              53.
                              54.
                              55.
                              56.
                              57.)))
               (SETQ IDENT (CONS (ASCII CHAR) IDENT))
               (GO TOP))
              ((MEMBER CHAR '(32. 9. 10. 11. 12. 13.))
               (COND (IDENT
                      (SETQ RESULT
                            (CONS (READLIST (NREVERSE IDENT))
                                  RESULT))
                      (SETQ IDENT NIL)))
               (GO TOP))
              ((MEMBER CHAR
                       '(33. 34. 44. 46. 47. 58. 59. 63. 91. 93.))
               (COND (IDENT
                      (SETQ RESULT
                            (CONS (READLIST (NREVERSE IDENT))
                                  RESULT))
                      (SETQ IDENT NIL)))
               (SETQ RESULT (CONS (INTERN (ASCII CHAR)) RESULT))
               (GO TOP))
              ((= CHAR 40.)
               (COND (IDENT
                      (SETQ RESULT
                            (CONS (READLIST (NREVERSE IDENT))
                                  RESULT))
                      (SETQ IDENT NIL)))
               (SETQ RESULT (CONS (OPS-READ*) RESULT))
               (GO TOP))
              ((MEMBER CHAR '(26. 41.))
               (COND (IDENT
                      (SETQ RESULT
                            (CONS (READLIST (NREVERSE IDENT))
                                  RESULT))
                      (SETQ IDENT NIL)))
               (RETURN (NREVERSE RESULT)))
              (T (SETQ IDENT (CONS (ASCII CHAR) IDENT)) (GO TOP))))) 

(DEFUN OPS-READ** NIL
  (PROG (IAL INL IC)
   TOP  (PRINC '*)
        (AND (= (TYIPEEK) 10.) (TYI))
        (SETQ INL NIL)
   L    (SETQ IC (TYI))
        (SETQ INL (CONS IC INL))
        (COND ((= IC 27.)
               (SETQ IAL
                     (MAPCAN (FUNCTION (LAMBDA (Z)
                                         (NCONS (ASCII Z))))
                             (CDR INL)))
               (SETQ IAL
                     (READLIST (CONS '|(|
                                     (NREVERSE (CONS '|)| IAL)))))
               (AND IAL (PRINT (APPLY (CAR IAL) (CDR IAL))))
               (GO TOP))
              ((MEMBER IC '(10. 13.)) (RETURN (NREVERSE INL)))
              ((MEMBER IC '(127. 8.))
               (SETQ INL (CDDR INL))
               (TYO 8.)
               (PRINC '| |)
               (TYO 8.))
              ((= IC 21.) (PRINC '^U) (TERPRI) (GO TOP))
              ((< IC 8.) (SETQ INL (CDR INL)))
              ((AND (> IC 13.) (< IC 27.)) (SETQ INL (CDR INL))))
        (GO L))) 


;;; Manipulating productions

(DEFUN PR FEXPR (L)
  (PROG (X)
   TOP  (COND ((ATOM L) (RETURN NIL)))
        (TERPRI)
        (PRINT (CAR L))
        (SETQ X (GET (CAR L) 'PRODUCTION))
        (COND (X (PRINT X))
              (T (PRINTLINE '(NOTHING STORED))))
        (SETQ L (CDR L))
        (GO TOP))) 

(DEFUN EXCISER FEXPR (L) (MAPC (FUNCTION EXCISE-P) L)) 

(DEFUN EDITR FEXPR (NAME-LIST)
  (PROG (MATRIX NEW NAME OLD)
   LBL  (COND ((ATOM NAME-LIST) (RETURN NIL)))
        (SETQ NAME (CAR NAME-LIST))
        (SETQ NAME-LIST (CDR NAME-LIST))
        (SETQ MATRIX (GET NAME 'PRODUCTION))
        (COND ((NOT MATRIX)
               (TERPRI)
               (PRINTLINE '(NO LHS STORED))
               (GO LBL)))
        (SETQ OLD (COPY MATRIX))
        (SETQ NEW (EDITE MATRIX NIL NAME))
        (COND ((NOT (EQUAL-LHS NEW OLD))
               (COMPILE-AND-UPDATE NAME NEW)))
        (GO LBL))) 

(DEFUN EQUAL-LHS (A B)
  (COND ((NOT (EQUAL (CAR A) (CAR B))) NIL)
        ((EQ (CAR A) '-->) T)
        (T (EQUAL-LHS (CDR A) (CDR B))))) 


;;; Initialize and save the system

(DEFUN INITIALIZE-GLOBAL-VARIABLES NIL
  (SETQ REAL-FEATURES* (SETQ FEATURES* 0.))
  (SETQ KEEP-LHS* NIL)
  (SETQ RESTART* NIL)
  (SETQ REFRESH-LHS-FLAG* NIL)
  (SETQ CURRENT-TOKEN* 0.)
  (SETQ CURRENT-WM* 0.)
  (SETQ LAST-GENBIND* 0.)
  (SETQ PCOUNT* 0.)
  (SETQ CREATION-TIME* 0.)
  (SETQ REAL-NODE-COUNT* 0.)
  (SETQ VIRTUAL-NODE-COUNT* 0.)
  (SETQ CONFLICT-SET* NIL)
  (SETQ WMPART-LIST* NIL)
  (SETQ RUNNING* NIL)
  (SETQ TRACED-RULES* NIL)
  (SETQ TRACE-FUNCTION* 'LEVEL1)
  (SETQ BUILD-FLAG* NIL)
  (SETQ VAR-FNS* NIL)
;  (VARIABLE # NOT-EQUAL)
  (VARIABLE = EQUAL)
  (MAKE-BOTTOM-NODE)
  (SETQ NEXT-DELETE-TIME* (SETQ MAXIMUM-AGE* 999999999.))
  (SETQ BUILD-FUNCTION* NIL)
  (COMMENT |For the next entry: number given is size of array LOCVEC|)
  (SETQ MAX-LOCVEC* 500.)
  (SETQ NEXT-LOCVEC* 1.)
  (NOUUO NIL)
  (SETQ ATOM-PRIORITY* (SETQ LENGTH-PRIORITY* 0.))) 

(DEFUN SAVEIT NIL
  (PROG (Z)
        (SETQ Z (STATUS DATE))
        (SSTATUS FLUSH NIL)
        (SSTATUS GCTIME 0.)
        (SUSPEND)
        (INITIALIZE-GLOBAL-VARIABLES)
        (PRINC 'OPS4)
        (TERPRI)
        (RETURN (LIST 'CREATED (CADR Z) '- (CADDR Z) '- (CAR Z))))) 

 