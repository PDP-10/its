;;; --------------------SET PACKAGE-----------------------
;;;  		V.R.Pratt.  Nov. 24, 1978
;;;		Revised Dec. 15, 1979

;;; The following operations are provided for manipulating finite
;;; sets of arbitrary objects represented as bit vectors.
;;; The package keeps track
;;; of a universe U of objects, which are added to as needed by GATHER.
;;; GATHER considers objects distinct just when EQUAL, rather than EQ,
;;; pronounces them so.  M denotes objects, A,B,... sets.

;;; (UNION A1 ... An)		union of A1 ... An
;;; (INTERSECT A1 ... An)	intersection of A1 ... An
;;; (GATHER M1 ... Mn)		{M1,...,Mn}
;;; (SETDIFF A1 ... An)		n=0: U.  n=1: U-A.  n>1: A1-A2-...-An.
;;; (SYMDIFF A1 ... An)		elements occurring an odd number of times
;;; (ELEMENTS A)		list of elements of A, in order first met
;;; (ELEMENTOF A)		some element of A
;;; (CARDINAL A)		number of elements of A
;;; (ELEMENTP M A)		tests whether M is an element of A
;;; (SUBSETP A B)		tests whether A is a subset of B

;;; The following are not essential, but the user may find them handy on
;;; occasion.

;;; Examples of use
;;; (GATHER 'XY 55 '(A B))			forms the set {XY,55,(A B)}
;;; (UNION (GATHER 'XY 55) (GATHER 55 '(A B)))  ditto
;;; (ELEMENTS (GATHER 'XY 55 '(A B)))		forms the list (XY 55 (A B))
;;; (SUBSETP X (UNION X Y))			is always T (assuming X bound)
;;; (ELEMENTP A (GATHER A))			is always T (assuming A bound)
;;; (CARDINAL (GATHER 'XY '(A B)))		will be 2

;;; As PRINT will not distinguish between sets and integers, and MAPCAR will
;;; not know how to enumerate set elements, the function ELEMENTS is provided
;;; to convert a set to a list of its elements.

;;; The constant EMPTY may be expressed as 0, or as (GATHER) if you need to
;;; hint that it is of type SET, (CADDDR UNIVERSE) returns the present
;;; universe (everthing that has been GATHERed), SETDIFF will serve as
;;; COMPLEMENT, ZEROP will serve as the predicate EMPTYP.

;;; CGOL users have access to these routines automatically.  The syntax is
;;; {a1,...,an}		(GATHER A1 ... An)
;;; a1a2..an	(UNION A1 ... An)
;;; a1a2..an	(INTERSECT A1 ... An)
;;; a1~a2~...~an	(SETDIFF A1 A2 ... An)
;;; na		(ELEMENTP N A)
;;; ab		(SUBSETP A B)
;;; In addition f{a} (which is (APPLY 'F A)) will have the appropriate effect
;;; for f being any of gather,union,intersect.  Needless to say, f[a1,...,an]
;;; (which is (MAPCAR 'F A1 ... An) ) works correctly with all of the above.

;;; For efficiency, these routines, with the exception of GATHER and ELEMENTS,
;;; far outclass anything possible with methods based on representing sets
;;; as lists, by a factor of hundreds if not thousands.  In the case of
;;; GATHER, there is an overhead associated with the first time a pointer
;;; is encountered, dominated by the cost of doing an SXHASH on the object
;;; pointed to by that pointer.  While pathological cases could give rise to
;;; n**2 behavior, one can expect in general that the overhead from GATHER
;;; will not dominate.  ELEMENTS is not unduly slow, but it has to be done
;;; to get back your elements, unlike a method based on lists, where there
;;; is zero overhead here.

;;; Once a universe has been GATHERed up, the order of gathering will be that
;;; in which elements of sets are listed by ELEMENTS.  Thus to sort a list L
;;; all of whose elements are already in the universe, do
;;; (ELEMENTS (APPLY 'GATHER L)).  Repetitions will be eliminated.  If L
;;; contains elements not yet in the universe, they will retain the order
;;; they had in L, and appear after all other elements of L.

;;; The functions fall into two classes: internal and external.  The internal
;;; functions deal only with bit vectors, for which LISP's unbounded-size
;;; integers are used (bignums, which are lists of 35-bit words, sign unused).
;;; Union is implemented as bitwise or, intersect as and, cardinal as
;;; bit-counting, subsetp as (zerop (bboole 4 x y)), etc.  The external
;;; functions in effect Goedelize external objects to yield an internal
;;; representation.  The Goedelization is defined by GATHER, which tries to
;;; work out whether it has Goedelized its arguments before.  It does this
;;; through the obarray.  For symbols it just uses the OBNUM property of the
;;; symbol, which yields a number giving the bit position for this object.  For
;;; fixnums it first converts the fixnum to a symbol by doing (implode (explode
;;; n)) (somewhat slow - this takes 3 millisecs on AI).  For lists (including
;;; bignums) it first converts the pointer to a fixnum using MAKNUM, which
;;; reduces the problem to that of fixnums.  However, this by itself would only
;;; give EQ and we want EQUAL.  Thus if it has not seen the pointer before it
;;; then does an SXHASH on the object pointed to by the pointer, symbolizes the
;;; result as above, and looks it up.  The result is a list ("bucket") of
;;; objects with SXHASHes that give the same bucket, paired with their internal
;;; number.  It does an ASSOC to extract that number.  When this fails, it
;;; allocates a new number (new bit position) to the object.

;;; The external functions are GATHER, ELEMENTP, ELEMENTS, and ELEMENTOF.

;;; If demand warrants it, I may do something about speeding up the external
;;; functions, which take several milliseconds.  (Note that CONS costs
;;; something like a millisecond once you've charged it for its share of
;;; garbage collection.) My present application for the package is
;;; compute-bound, involving only light use of external functions.




;;; **********************SETS PACKAGE**********************

(DECLARE '(MUZZLED T)
	 (FIXNUM I N X Y Z ARGNO))

(DEFUN UNION ARGNO
       (DO ((I 1 (ADD1 I)) (AC 0))
           ((GREATERP I ARGNO) AC)
           (SETQ AC (BOR AC (ARG I)))))

(DEFUN INTERSECT ARGNO
       (DO ((I 1 (ADD1 I)) (AC (CADDDR UNIVERSE)))
           ((GREATERP I ARGNO) AC)
           (SETQ AC (BAND AC (ARG I)))))

(DEFUN GATHER ARGNO
       (DO ((I 1 (ADD1 I)) (AC 0))
           ((GREATERP I ARGNO) AC)
           (SETQ AC (BOR AC (EXPT 2 (OBNUM (ARG I)))))))

(DEFUN SETDIFF ARGNO
       (COND ((ZEROP ARGNO) (CADDDR UNIVERSE))
 	     ((EQUAL ARGNO 1) (DIFFERENCE (CADDDR UNIVERSE) (ARG 1)))
	     ((DO ((I 2 (ADD1 I)) (AC (ARG 1)))
                  ((GREATERP I ARGNO) AC)
                  (SETQ AC (BDIFF AC (ARG I)))))))

(DEFUN SYMDIFF ARGNO
       (DO ((I 1 (ADD1 I)) (AC 0))
           ((GREATERP I ARGNO) AC)
           (SETQ AC (BSYMDIFF AC (ARG I)))))

(DEFUN ELEMENTS (A)  ;; Make a list of the elements in A
       (COND ((NOT (LESSP -1 A (ADD1 (CADDDR UNIVERSE)))) '|Error in Elements|)
	     ((BIGP A) (LELEMENTS (CDR A) 0))
	     ((FELEMENTS A 0))))

(DEFUN LELEMENTS (L N)  ;; Auxiliary function for Elements, assumes bignum list
       (AND L (APPEND (FELEMENTS (CAR L) N) (LELEMENTS (CDR L) (PLUS N 35.)))))

(DEFUN FELEMENTS (X N)  ;;  Auxiliary function for Elements, assumes fixnum
       (COND ((ZEROP X) NIL)
	     ((ODDP X) (CONS (FUNCALL (CAR UNIVERSE) N)
			     (FELEMENTS (LSH X -1) (ADD1 N))))
	     ((FELEMENTS (LSH X -1) (ADD1 N)))))

(DEFUN ELEMENTOF (A)
       (COND ((PLUSP A) (FUNCALL (CAR UNIVERSE) (SUB1 (HAULONG A))))))

(DEFUN CARDINAL (A)
       (COND ((BIGP A) (APPLY 'PLUS (MAPCAR 'FCARDINAL (CDR A))))
	     ((FCARDINAL A))))

(DEFUN FCARDINAL (X)
       (COND ((ZEROP X) 0)
	     ((ODDP X) (ADD1 (FCARDINAL (LSH X -1))))
	     ((FCARDINAL (LSH X -1)))))

(DEFUN FNORM MACRO (FORM)
       ((LAMBDA (X)
	 `(COND ((NOT (BIGP ,X)) (LIST ,X))
		((CDR ,X))))
	(CADR FORM)))

(DEFUN BOR (A B)  (CONSBIGNUMBER (BFOR (FNORM A) (FNORM B))))

(DEFUN BFOR (A B)
       (COND ((NULL A) B)
	     ((NULL B) A)
	     ((CONS (BOOLE 7 (CAR A) (CAR B)) (BFOR (CDR A) (CDR B))))))

(DEFUN BAND (A B)  (CONSBIGNUMBER (BFAND (FNORM A) (FNORM B))))

(DEFUN BFAND (A B)
       (AND A B (CONS (BOOLE 1 (CAR A) (CAR B)) (BFAND (CDR A) (CDR B)))))

(DEFUN BDIFF (A B)  (CONSBIGNUMBER (BFDIFF (FNORM A) (FNORM B))))

(DEFUN BFDIFF (A B)
       (AND A (CONS (BOOLE 4 (CAR A) (CAR B)) (BFDIFF (CDR A) (CDR B)))))

(DEFUN BSYMDIFF (A B)  (CONSBIGNUMBER (BFSYMDIFF (FNORM A) (FNORM B))))

(DEFUN BFSYMDIFF (A B)
       (COND ((NULL A) B)
	     ((NULL B) A)
	     ((CONS (BOOLE 6 (CAR A) (CAR B)) (BFSYMDIFF (CDR A) (CDR B))))))

(DEFUN BELEMENTP (N L)
       ;;; TEST IF THE N'TH BIT IS ON IN THE LIST OF FIXNUMS L.
       (COND ((NULL L) NIL)
	     ;;; IF BIT IS IN CURRENT WORD, CHECK IT.
	     ((< N 35.) (ODDP (LSH (CAR L) (MINUS N))))
	     ;;; OTHERWISE, TRY NEXT WORD.
	     ((BELEMENTP (- N 35.) (CDR L)))))

(DEFUN ELEMENTP (A L)
       ((LAMBDA (N)
        (COND ((NULL N) NIL)
	      ;;; If L a bignum, run down list of fixnums.
	      ((BIGP L) (BELEMENTP N (CDR L)))
	      ;;; Check if bit on in shifted fixnum.
	      ((ODDP (LSH L (MINUS N))))))
	(OLDOBNUM A)))

(DEFUN SUBSETP (A B) (ZEROP (BDIFF A B)))

(DEFUN CONSBIGNUMBER (A) 
       (COND ((ATOM A) A) ((NULL (CDR A)) (CAR A)) ((CONSBIGNUM A)))) 

(VALRET '//:VP/ ) ;;; GET SYMBOLS FROM DDT.

(LAP CONSBIGNUM SUBR)
	(JRST 0 BNCONS)
NIL 

(DECLARE (SPECIAL AW ASX)) ;;; Communicates between OBNUM, OLDOBNUM

(DEFUN OBNUM (W)
   ;;; Converts object to a small numeric identifier for that object
       (OR (OLDOBNUM W)		;;; If already in universe, use it
	   ((LAMBDA (N)		;;; Otherwise add to universe
		  (STORE (FUNCALL (CAR UNIVERSE) N) W)
		  (STORE (FUNCALL (CADR UNIVERSE) AW)
			 (CONS (CONS W N) (FUNCALL (CADR UNIVERSE) AW)))
		  N)
	    (NEWNUM))))

(DEFUN OLDOBNUM (W)
   ;;; Like OBNUM, but returns NIL if W is not in universe
       (SETQ AW (REMAINDER (ABS (SXHASH W)) 100.))
       (CDR (ASSOC W (FUNCALL (CADR UNIVERSE) AW))))

(DEFUN NEWNUM ()
       (PROG (CARD)
	(RPLACD (CDR UNIVERSE)
		(LIST (SETQ CARD (ADD1 (CADDR UNIVERSE)))
		      (ADD1 (TIMES 2 (CADDDR UNIVERSE)))))
	(COND ((NOT (GREATERP (CADR (ARRAYDIMS (CAR UNIVERSE))) CARD))
	       (*REARRAY (CAR UNIVERSE) T (PLUS CARD 199.))))
	(RETURN (SUB1 CARD))))

(DEFUN GENUNIVERSE ()   ;; Generates a new (empty) universe
	(LIST (ARRAY NIL T 100.) (ARRAY NIL T 100.) 0 0))

(SETQ UNIVERSE (GENUNIVERSE)) (SETQ CAR T CDR T)

