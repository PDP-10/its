;;;;;;;;;;;;;;;;;;; -*- mode: lisp; package: macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) copyright 1981 massachusetts institute of technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module defint)

;;;          this is the definite integration package. 
;	defint does definite integration by trying to find an
;appropriate method for the integral in question.  the first thing that
;is looked at is the endpoints of the problem. 
;
;	i(grand,var,a,b) will be used for integrate(grand,var,a,b)

;;references are to evaluation of definite integrals by symbolic
;;manipulation by paul s. wang.
;;
;;	nointegrate is a macsyma level flag which inhibits indefinite
;integration.
;	abconv is a macsyma level flag which inhibits the absolute
;convergence test.
;
;	$defint is the top level function that takes the user input
;and does minor changes to make the integrand ready for the package.
;
;	next comes defint, which is the function that does the
;integration.  it is often called recursively from the bowels of the
;package.  defint does some of the easy cases and dispatches to:
;
;	dintegrate.  this program first sees if the limits of
;integration are 0,inf or minf,inf.  if so it sends the problem to
;ztoinf or mtoinf, respectivly.
;	else, dintegrate tries:
;
;	intsc1 - does integrals of sin's or cos's or exp(%i var)'s
;		 when the interval is 0,2 %pi or 0,%pi.
;		 method is conversion to rational function and find
;		 residues in the unit circle. [wang, pp 107-109]
;
;	ratfnt - does rational functions over finite interval by
;		 doing polynomial part directly, and converting
;		 the rational part to an integral on 0,inf and finding
;		 the answer by residues.
;
;	zto1   - i(x^(k-1)*(1-x)^(l-1),x,0,1) = beta(k,l)  or
;		 i(log(x)*x^(x-1)*(1-x)^(l-1),x,0,1) = psi...
;		 [wang, pp 116,117]
;
;	dintrad- i(x^m/(a*x^2+b*x+c)^(n+3/2),x,0,inf) [wang, p 74]
;
;	dintlog- i(log(g(x))*f(x),x,0,inf) = 0 (by symetry) or
;		 tries an integration by parts.  (only routine to
;		 try integration by parts) [wang, pp 93-95]
;
;	dintexp- i(f(exp(x)),x,a,b) = i(f(x+1),x,a',b')
;
;dintegrate also tries indefinite integration based on certain 
;predicates (such as abconv) and tries breaking up the integrand
;over a sum or tries a change of variable.
;
;	ztoinf is the routine for doing integrals over the range 0,inf.
;          it goes over a series of routines and sees if any will work:
;
;	   scaxn  - sc(b*x^n) (sc stands for sin or cos) [wang, pp 81-83]
;
;	   ssp    - a*sc^n(r*x)/x^m  [wang, pp 83,84]
;
;	   zmtorat- rational function. done by multiplication by plog(-x)
;		    and finding the residues over the keyhole contour
;		    [wang, pp 59-61]
;
;	   log*rat- r(x)*log^n(x) [wang, pp 89-92]
;
;	   logquad0 log(x)/(a*x^2+b*x+c) uses formula
;		    i(log(x)/(x^2+2*x*a*cos(t)+a^2),x,0,inf) =
;		    t*log(a)/sin(t).  a better formula might be
;		    i(log(x)/(x+b)/(x+c),x,0,inf) = 
;		    (log^2(b)-log^2(c))/(2*(b-c))
;
;	   batapp - x^(p-1)/(b*x^n+a)^m uses formula related to the beta
;		    function [wang, p 71]
;		    there is also a special case when m=1 and a*b<0
;		    see [wang, p 65]
;
;          sinnu  - x^-a*n(x)/d(x) [wang, pp 69-70]
;
;	   ggr    - x^r*exp(a*x^n+b) 
;
;	   dintexp- see dintegrate
;
;     ztoinf also tries 1/2*mtoinf if the integrand is an even function
;
; mtoinf is the routine for doing integrals on minf,inf.  
;        it too tries a series of routines and sees if any succeed.
;
;	 scaxn  - when the integrand is an even function, see ztoinf
;
;	 mtosc  - exp(%i*m*x)*r(x) by residues on either the upper half
;		  plane or the lower half plane, depending on whether
;		  m is positive or negative.
;
;	 zmtorat- does rational function by finding residues in upper
;	          half plane
;
;	 dintexp- see dintegrate
;
;	 rectzto%pi2 - poly(x)*rat(exp(x)) by finding residues in
;		       rectangle [wang, pp98-100]
;
;	 ggrm   - x^r*exp((x+a)^n+b)
;
;   mtoinf also tries 2*ztoinf if the integrand is an even function.

(load-macsyma-macros rzmac)

(DECLARE (*lexpr $DIFF $LIMIT $SUBSTITUTE $EZGCD $RATSIMP context)
	 (*expr subfunmake $coeff $logcontract $radcan $makegamma
		$constantp $subvarp substitute freeof ith
		$oddp $hipow $multthru $xthru $num $denom 
		stripdollar find sdiff partition
		constant free mapatom

		$ratdisrep ratdisrep $ratp ratp ratnumerator 
		sratsimp ratdenominator $ratsubst ratnump ratcoef
		pterm rdis pdis ratrep newvar pdivide pointergp
		      
		$factor factor $sqfr oddelm zerop1

		$asksign asksign $sign ask-integer assume forget
		      
		$residue residue res res1 polelist partnum

		solve solvex sinint
		      
		$rectform $realpart $imagpart trisplit cabs
		      
		among involve notinvolve  
		numden* ratgreaterp
		subin polyinx genfind xor fmt polyp numden andmapcar
		abless1 even1 rddeg tansc radicalp deg simplerd
		no-err-sub oscip %einvolve sin-sq-cos-sq-sub)
		      
;;;rsn* is in comdenom. does a ratsimp of numerator.
	 (SPECIAL *DEF2* PCPRNTD MTOINF* RSN* SEMIRAT*
		  SN* SD* LEADCOEF CHECKFACTORS 
		  *NODIVERG RD* EXP1
		  UL1 LL1 *DFLAG BPTU BPTD PLM* ZN ZD
		  *UPDN UL LL EXP PE* PL* RL* PL*1 RL*1
		  LOOPSTOP* VAR NN* ND* DN* p*
		  IND* FACTORS RLM*
		  PLOGABS *ZEXPTSIMP? SCFLAG
		  sin-cos-recur rad-poly-recur dintlog-recur
		  dintexp-recur defintdebug defint-assumptions
		  current-assumptions
		  global-defint-assumptions)
	 
	 (ARRAY* (NOTYPE I 1 J 1))
	 (GENPREFIX DEF)
	 (muzzled t)
	 ;expvar
	 (special $intanalysis $abconvtest $noprincipal $nointegrate)
	 ;impvar
	 (special $solveradcan $solvetrigwarn *roots *failures 
		 $logabs $tlimswitch $maxposex $maxnegex
		 $trigsign $savefactors $radexpand $breakup $%emode
		 $float $exptsubst dosimp context rp-polylogp
		 %P%I HALF%PI %PI2 HALF%PI3 VARLIST genvar
		 $domain $m1pbranch errorsw errrjfflag raterr
		 limitp $algebraic
		 ;;LIMITP T Causes $ASKSIGN to do special things
		 ;;For DEFINT like eliminate epsilon look for prin-inf
		 ;;take realpart and imagpart.
		 integer-info
		 ;;If LIMITP is non-null ask-integer conses 
		 ;;its assumptions onto this list.
		 generate-atan2))
		           ;If this switch is () then RPART returns ATAN's
                           ;instead of ATAN2's

(declare (special infinities real-infinities infinitesimals))
(cond ;These are really defined in LIMIT but DEFINT uses them also.
 ((not (boundp 'infinities))
  (setq INFINITIES '($INF $MINF $INFINITY))
  (setq REAL-INFINITIES '($INF $MINF))
  (setq INFINITESIMALS '($ZEROA $ZEROB))))

(defmvar defintdebug () "If true Defint prints out debugging information")

(DEFUN $DEFINT (EXP VAR LL UL)
 (let ((global-defint-assumptions ())
       (integer-info ()))
 (with-new-context (context)
 (unwind-protect
       (let ((defint-assumptions ())  (*def2* ())  (rad-poly-recur ())
	     (sin-cos-recur ())  (dintexp-recur ())  (dintlog-recur 0.)
             (ans nil)  (orig-exp exp)  (orig-var var)
	     (orig-ll ll)  (orig-ul ul) 
	     (pcprntd nil)  (*NODIVerg nil)  ($logabs t)  (limitp t)
	     (rp-polylogp ())
	     ($domain '$real) ($m1pbranch ())) ;Try this out.

	    (FIND-FUNCTION '$LIMIT)
	    (make-global-assumptions) ;sets global-defint-assumptions
	    (FIND-FUNCTION '$RESIDUE)
	    (SETQ EXP (RATDISREP EXP))
	    (SETQ VAR (RATDISREP VAR))
	    (SETQ LL (RATDISREP LL))
	    (SETQ UL (RATDISREP UL))
	    (COND (($CONSTANTP VAR)
		   (merror "Variable of integration not a variable: ~M"
			   VAR))
		  (($SUBVARP VAR)  (SETQ VAR (STRIPDOLLAR (CAAR VAR)))
				   (SETQ EXP (SUBST VAR orig-VAR EXP))))
	    (COND ((NOT (ATOM VAR))
		   (merror "Improper variable of integration: ~M" VAR))
		  ((OR (AMONG VAR UL)
		       (AMONG VAR LL)) 
		   (SETQ VAR (STRIPDOLLAR VAR))
		   (SETQ EXP (SUBST VAR orig-VAR EXP))))
	    (cond ((not (equal ($ratsimp ($imagpart ll)) 0))
		   (merror "Defint: Lower limit of integration must be real."))
		  ((not (equal ($ratsimp ($imagpart ul)) 0))
		   (merror
		    "Defint: Upper limit of integration must be real.")))

	    (COND ((SETQ ANS (DEFINT EXP VAR LL UL))
		   (SETQ ANS (SUBST orig-VAR VAR ANS))
		   (COND ((atom ans)  ans)
			 ((and (free ans '%limit)
			       (free ans '%integrate)
			       (OR (not (free ans '$INF))
				   (not (free ans '$MINF))
				   (not (free ans '$INFINITY))))
			  (diverg))
			 ((not (free ans '$und))
			 `((%integrate) ,orig-exp ,orig-var ,orig-ll ,orig-ul))
			      (t ANS)))
		  (t `((%integrate) ,orig-exp ,orig-var ,orig-ll ,orig-ul))))
       (forget-global-assumptions)))))

(DEFUN EEZZ (EXP LL UL)
       (COND ((OR (polyinx EXP VAR nil)
		  (*CATCH 'PIN%EX (PIN%EX EXP)))
	      (SETQ EXP (ANTIDERIV EXP))
;;;If antideriv can't do it, returns nil
;;;use limit to evaluate every answer returned by antideriv.
	      (COND ((NULL EXP) NIL)
		    (t (INTSUBS EXP LL UL))))))
;;;Hack the expression up for exponentials.

(defun sinintp (expr var)
;;; Is this expr a candidate for SININT ?
       (let ((expr (factor expr))
	     (numer nil)
	     (denom nil))
	    (setq numer ($num expr))
	    (setq denom ($denom expr))
	    (cond ((polyinx numer var nil)
		   (cond ((and (polyinx denom var nil)
			       (deg-lessp denom var 2))
			  t)))
;;;ERF type things go here.
		  ((let ((exponent (%einvolve numer)))
			(and (polyinx exponent var nil)
			     (deg-lessp exponent var 2)))
		   (cond ((free denom var)
			  t))))))

(defun deg-lessp (expr var power)
       (cond  ((or (atom expr) 
		   (mnump expr)) t)
	      ((or (mtimesp expr) 
		   (mplusp expr))
	       (do ((ops (cdr expr) (cdr ops)))
		   ((null ops) t)
		   (cond ((not (deg-lessp (car ops) var power))
			  (return ())))))
	      ((mexptp expr)
	       (and (or (not (alike1 (cadr expr) var))
			(and (numberp (caddr expr))
			     (not (eq (asksign (m+ power (m- (caddr expr))))
				      '$negative))))
		    (deg-lessp (cadr expr) var power)))))

(DEFUN ANTIDERIV (A)
       (let ((limitp ())
	     (Ans ())
	     (generate-atan2 ()))
	 (setq ans (SININT A VAR))
	 (COND ((AMONG '%INTEGRATE Ans)  NIL) 
	       (T (SIMPLIFY Ans)))))

;;;This routine tries to take a limit a couple of ways.
(defun get-limit nargs
  (let ((ans (apply 'limit-no-err (listify nargs)))
	(val ()) (var ()) (exp ()) (dir ()))
    (cond ((and ans (not (among '%limit ans)))  ans)
	  (t (cond ((and (or (equal nargs 3) (equal nargs 4))
			 (memq (setq val (arg 3)) '($inf $minf)))
		    (setq var (arg 2))
		    (setq exp (substitute (m^t var -1) var (arg 1)))
		    (cond ((eq val '$inf)  (setq dir '$plus))
			  (t (setq dir '$minus)))
		    (setq ans (apply 'limit-no-err `(,exp ,var 0 ,dir)))
		    (cond ((not (among '%limit ans))  ans)
			  (t ()))))))))

(defun limit-no-err nargs
  (let ((errorsw t)  (ans ()))
    (setq ans (*catch 'errorsw (apply '$limit (listify nargs))))
    (cond ((not (eq ans t))  ans)
	  (t nil))))

(DEFUN INTCV (NV IND FLAG)
  (let ((D (bx**n+a nv))
	(*ROOTS ())  (*FAILURES ())  ($BREAKUP ()))
    (cond ((AND (EQ UL '$INF)
		(EQUAL LL 0)
		(EQUAL (CADR D) 1)) ())
	  (t (SOLVE (m+t 'YX (m*t -1. NV)) VAR 1.)
	     (COND (*ROOTS (SETQ D (SUBST VAR 'YX (CADDAR *ROOTS)))
			   (COND (FLAG (INTCV2 D IND NV))
				 (T (INTCV1 D IND NV))))
		   (t ()))))))

(DEFUN INTCV1 (D IND NV) 
       (COND ((AND (INTCV2 D IND NV)
		   (NOT (alike1 LL1 UL1)))
	      (let ((*DEF2* t))
		   (DEFINT EXP1 VAR LL1 UL1)))))

(DEFUN INTCV2 (D IND NV)
       (INTCV3 D IND NV)
       (AND (COND ((AND (ZEROP1 (m+ LL UL))
			(EVENFN NV VAR))
		   (SETQ EXP1 (m* 2 EXP1)
			 LL1 (LIMCP NV VAR 0 '$PLUS)))
		  (T (SETQ LL1 (LIMCP NV VAR LL '$PLUS))))
	    (SETQ UL1 (LIMCP NV VAR UL '$MINUS))))

(DEFUN LIMCP (A B C D) 
       (let ((Ans ($LIMIT A B C D)))
	    (COND ((NOT (OR (null ans)
			    (among '%limit ans)
			    (AMONG '$IND Ans)
			    (AMONG '$UND Ans)))
		   Ans))))

(DEFUN INTCV3 (D IND NV)
       (SETQ NN* ($RATSIMP (SDIFF D VAR)))
       (SETQ EXP1 (SUBST 'YX NV EXP))
       (SETQ EXP1 (m* NN* (COND (IND EXP)
				(T (SUBST D VAR EXP1)))))
       (SETQ EXP1 (sRATSIMP (SUBST VAR 'YX EXP1))))

(DEFUN DEFINT (EXP VAR LL UL)
 (let ((old-assumptions defint-assumptions)  (current-assumptions ()))
  (unwind-protect
   (prog ()
      (setq current-assumptions (make-defint-assumptions 'noask))
      (let ((exp (resimplify exp))            
	    (var (resimplify var))
	    ($exptsubst t)
	    (loopstop* 0)
	    ;; D (not used? -- cwh)
	    ANS NN* DN* ND* $NOPRINCIPAL)
	   (cond ((setq ans (defint-list exp var ll ul))
		  (return ans))
		 ((OR (ZEROP1 EXP)
		      (ALIKE1 UL LL))
		  (RETURN 0.))
		 ((NOT (AMONG VAR EXP))
		  (COND ((OR (MEMQ UL '($INF $MINF))
			     (MEMQ LL '($INF $MINF)))
			 (Diverg))
			(T (SETQ ANS (m* EXP (m+ UL (m- LL))))
			   (return ANS)))))
	   (let* ((EXP (RMCONST1 EXP))
		  (C (CAR EXP))
		  (EXP (%i-out-of-denom (CDR EXP))))
	     (COND ((AND (NOT $NOINTEGRATE)
			 (NOT (ATOM EXP))
			 (or (among 'mqapply exp)
			     (NOT (MEMQ (CAAR EXP)
					'(MEXPT MPLUS MTIMES %SIN %COS
						%TAN %SINH %COSH %TANH
						%LOG %ASIN %ACOS %ATAN
						%COT %ACOT %SEC 
						%ASEC %CSC %ACSC 
						%DERIVATIVE)))))
		    (COND ((SETQ ANS (ANTIDERIV EXP))
			   (SETQ ANS (INTSUBS ANS LL UL))
			   (return (m* C ANS)))
			  (t (return nil)))))
	     (SETQ EXP (TANSC EXP))
	     (cond ((setq  ans (initial-analysis exp var ll ul))
		    (return (m* c ans))))
	     (return nil))))
   (restore-defint-assumptions old-assumptions current-assumptions))))

(defun defint-list (exp var ll ul)
       (COND ((AND (NOT (ATOM EXP)) 
		   (MEMQ (CAAR EXP)
			 '(MEQUAL MLIST $MATRIX)))
	      (let ((ANS (CONS (CAR EXP)
			       (MAPCAR
				#'(LAMBDA (SUB-EXP)
				    (DEFINT SUB-EXP VAR LL UL))
				(CDR EXP)))))
		   (COND (ANS (simplify ANS))
			 (T NIL))))
	     (t nil)))

(defun initial-analysis (exp var ll ul)
       (let ((pole (cond ((not $intanalysis)
			  '$no)          ;don't do any checking.
			 (t (poles-in-interval exp var ll ul)))))
	    (cond ((eq pole '$no)
		   (cond ((and (oddfn exp var)
			       (or (and (eq ll '$minf)
					(eq ul '$inf))
				   (eq ($sign (m+ ll ul))
				       '$zero)))  0)
			 (t (parse-integrand exp var ll ul))))
		  ((eq pole '$unknown)  ())
		  (t (principal-value-integral exp var ll ul pole)))))

(defun parse-integrand (exp var ll ul)
  (let (ans)
       (COND ((SETQ ANS (EEZZ EXP LL UL))  ans)
	     ((and (RATP EXP VAR)
		   (setq ans (method-by-limits EXP VAR LL UL)))  ans)
	     ((and (mplusp EXP)
		   (setq ans (INTBYTERM EXP T)))  ans)
	     ((setq ans (method-by-limits EXP VAR LL UL))  ans)
	     (t ()))))

(DEFUN RMCONST1 (E)
  (COND ((AMONG VAR E) 
	 (PARTITION E VAR 1))
	(T (CONS E 1))))


(defun method-by-limits (exp var ll ul)
 (let ((old-assumptions defint-assumptions))
   (setq current-assumptions (make-defint-assumptions 'noask))
;;Should be a PROG inside of unwind-protect, but Multics has a compiler
;;bug wrt. and I want to test this code now.
   (unwind-protect
       (COND ((and (and (EQ UL '$INF)
			(eq ll '$minf))  (mtoinf exp var)))
	     ((and (and (eq ul '$inf)
			(equal ll 0.))  (ztoinf exp var)))
;;;This seems((and (and (eq ul '$inf)
;;;fairly losing	(setq exp (subin (m+ ll var) exp))
;;;			(setq ll 0.))
;;;		   (ztoinf exp var)))
	     ((and (and (equal ul 1.)
			(equal ll 0.))  (zto1 exp)))
	     (t (dintegrate exp var ll ul)))
       (restore-defint-assumptions old-assumptions defint-assumptions))))
       

(DEFUN DINTEGRATE (EXP VAR LL UL)
   (let ((ans nil) (arg nil) (scflag nil) 
	 (*dflag nil) ($%emode t))
;;;NOT COMPLETE for sin's and cos's.
	(cond ((and (not sin-cos-recur)
		    (oscip exp)
		    (SETQ SCFLAG T)
		    (INTSC1 ll ul exp)))
	      ((and (not rad-poly-recur)
		    (notinvolve exp '(%log))
		    (not (%einvolve exp))
		    (method-radical-poly exp var ll ul)))
	      ((and (not (equal dintlog-recur 2.))
		    (SETQ arg (INVOLVE EXP '(%log)))
		    (DINTLOG EXP arg)))
	      ((and (not dintexp-recur)
		    (SETQ arg (%EINVOLVE exp))
		    (DINTEXP EXP var)))
	      ((and (NOT (RATP EXP VAR)) 
		    (SETQ ANS ($EXPAND EXP))
		    (NOT (ALIKE1 ANS EXP))
		    (INTBYTERM ANS T)))
	      ((setq ans (antideriv exp))
	       (intsubs ans ll ul))
	      (t nil))))

(defun method-radical-poly (exp var ll ul)
;;;Recursion stopper
  (let ((rad-poly-recur t)   ;recursion stopper
	(result ()))
    (cond ((and (sinintp EXP VAR) 
		(setq result (antideriv exp))
		(intsubs result ll ul)))
	  ((and (RATP EXP VAR)
		(setq result (RATFNT EXP))))
	  ((and (setq result (antideriv exp))
		(intsubs result ll ul)))
	  ((AND (NOT SCFLAG)
		(NOT (EQ UL '$INF))
		(radic exp var)
		(KINDP34)
		(setq result (CV EXP))))
	  (t ()))))

;;; LIMIT loss can't set logabs to true for these cases.
(defun principal-value-integral (exp var ll ul poles)
  (let (($logabs ())  (anti-deriv ()))
    (cond ((not (null (setq anti-deriv (antideriv exp))))
	   (cond ((not (null poles))
		  (order-limits 'ask)
		  (cond ((take-principal anti-deriv ll ul poles))
			(t ()))))))))

(defun take-principal (anti-deriv ll ul poles &aux ans merged-list)
  (setq anti-deriv (cond ((involve anti-deriv '(%log))
			  ($logcontract anti-deriv))
			 (t anti-deriv)))
  (setq ans 0.)
  (setq merged-list (interval-list poles ll ul))
  (do ((current-pole (cdr merged-list) (cdr current-pole))
       (previous-pole merged-list (cdr previous-pole)))
      ((null current-pole)  t)
    (setq ans (m+ ans	    
		  (intsubs anti-deriv (m+ (caar previous-pole) 'epsilon)
			   (m+ (caar current-pole) (m- 'epsilon))))))
			   
;;;Hack answer to simplify "Correctly".
    (cond ((not (freeof '%log ans)) 
	   (setq ans ($logcontract ans))))
    (setq ans (get-limit (get-limit ans 'epsilon 0 '$plus) 'prin-inf '$inf))
;;;Return setion.
    (cond ((or (null ans)
	       (not (free ans '$infinity)) 
	       (not (free ans '$ind)))  ())
	  ((or (among '$minf ans)
	       (among '$inf ans)
	       (among '$und ans))
	   (diverg))
	  (t (principal) ans)))

(defun interval-list (pole-list ll ul)
  (let ((first (car (first pole-list)))
	(last (caar (last pole-list))))
    (cond ((eq ul last)  
	   (if (eq ul '$inf)
	       (setq pole-list (subst 'prin-inf '$inf pole-list))))
	  (t (if (eq ul '$inf) 
		 (setq ul 'prin-inf))
	     (setq pole-list (append pole-list (list (cons ul 'ignored))))))
    (cond ((eq ll first) 
	   (if (eq ll '$minf)
	       (setq pole-list (subst (m- 'prin-inf) '$minf pole-list))))
	  (t (if (eq ll '$minf)
		 (setq ll (m- 'prin-inf)))
	     (setq pole-list (append (list (cons ll 'ignored)) pole-list)))))
  pole-list)

(DEFUN CV (EXP)
  (if (not (or (real-infinityp ll) (real-infinityp ul)))
      (method-by-limits (INTCV3 (M// (m+t LL (m*t UL VAR))
				     (m+t 1. VAR)) NIL 'YX)
			VAR 0. '$INF)
      ()))

(DEFUN RATFNT (EXP)
   (let ((e (pqr exp)))
     (COND ((EQUAL 0. (CAR E))  (CV EXP))
	   ((EQUAL 0. (CDR E))  (EEZZ (CAR E) LL UL))
	   (T (m+t (EEZZ (CAR E) LL UL)
		   (CV (M// (CDR E) DN*)))))))

(DEFUN PQR (E)
  (let ((VARLIST (list var)))
       (NEWVAR E)
       (SETQ E (CDR (RATREP* E)))
       (SETQ DN* (PDIS (RATDENOMINATOR E)))
       (SETQ E (PDIVIDE (RATNUMERATOR E) (RATDENOMINATOR E)))
       (CONS (SIMPLIFY (RDIS (CAR E))) (SIMPLIFY (RDIS (CADR E))))))


(DEFUN INTBYTERM (EXP *NODIVERG)
  (let ((saved-exp exp))
    (COND ((mplusp EXP)
	   (let ((ans (*CATCH 'Divergent 
			      (ANDMAPCAR #'(LAMBDA (new-exp) 
					     (let ((*def2* t))
					       (DEFINT new-exp VAR LL UL)))
					 (CDR EXP)))))
		(COND ((NULL ans) NIL)
		      ((EQ ans 'Divergent)
		       (let ((*NODIVerg nil))
			 (cond ((setq ans (ANTIDERIV saved-EXP))
				(intsubs ans ll ul))
			       (t nil))))
		      (T (sRATSIMP (m+l ans))))))
;;;If leadop isn't plus don't do anything.
	  (t nil))))

(DEFUN KINDP34 NIL
  (NUMDEN EXP)
  (let* ((d dn*)
	 (a (COND ((and (ZEROP1 ($LIMIT D VAR LL '$PLUS))
			(eq (limit-pole (m+ exp (m+ (m- LL) VAR)) var LL '$PLUS) '$yes))
		   t)
		  (t nil)))
	 (b (COND ((and (ZEROP1 ($LIMIT D VAR UL '$MINUS))
			(eq (limit-pole (m+ exp (m+ UL (m- VAR))) var UL '$MINUS) '$yes))
		   t)
		  (t nil))))
    (or a b)))

(DEFUN Diverg NIL
  (COND (*NODIVERG (*THROW 'Divergent 'Divergent))
	(T (MERROR "Integral is divergent"))))

(defun make-defint-assumptions (ask-or-not)
  (cond ((null (order-limits ask-or-not))  ())
	(t (mapc 'forget defint-assumptions)
	   (setq defint-assumptions ())
	   (let ((sign-ll (cond ((eq ll '$inf)  '$pos)
				((eq ll '$minf) '$neg)
				(t ($sign ($limit ll)))))
		 (sign-ul (cond ((eq ul '$inf)  '$pos)
				((eq ul '$minf)  '$neg)
				(t ($sign ($limit ul)))))
		 (sign-ul-ll (cond ((and (eq ul '$inf)
					 (not (eq ll '$inf)))  '$pos)
				   ((and (eq ul '$minf)
					 (not (eq ll '$minf)))  '$neg)
				   (t ($sign ($limit (m+ ul (m- ll))))))))
		(cond ((eq sign-ul-ll '$pos)
		       (setq defint-assumptions
			     `(,(assume `((mgreaterp) ,var ,ll))
			       ,(assume `((mgreaterp) ,ul ,var)))))
		      ((eq sign-ul-ll '$neg)
		       (setq defint-assumptions
			     `(,(assume `((mgreaterp) ,var ,ul))
			       ,(assume `((mgreaterp) ,ll ,var))))))
		(cond ((and (eq sign-ll '$pos)
			    (eq sign-ul '$pos))
		       (setq defint-assumptions
			     `(,(assume `((mgreaterp) ,var 0))
			       ,@defint-assumptions)))
		      ((and (eq sign-ll '$neg)
			    (eq sign-ul '$neg))
		       (setq defint-assumptions
			     `(,(assume `((mgreaterp) 0 ,var))
			       ,@defint-assumptions)))
		      (t defint-assumptions))))))

(defun restore-defint-assumptions (old-assumptions assumptions)
  (do ((list assumptions (cdr list)))
      ((null list) t)
      (forget (car list)))
  (do ((list old-assumptions (cdr list)))
      ((null list) t)
      (assume (car list))))

(defun make-global-assumptions ()
	    (setq global-defint-assumptions
		  (cons (assume '((mgreaterp) *z* 0.))
			global-defint-assumptions))
;;; *Z* is a "zero parameter" for this package.
;;; Its also used to transform.
;;  limit(exp,var,val,dir) -- limit(exp,tvar,0,dir)
	    (setq global-defint-assumptions
		  (cons (assume '((mgreaterp) epsilon 0.))
			global-defint-assumptions))	   
	    (setq global-defint-assumptions
		  (cons (assume '((mlessp) epsilon 1.0e-8))
			global-defint-assumptions)) 
;;; EPSILON is used in principal vaule code to denote the familiar
;;; mathematical entity.
	    (setq global-defint-assumptions
		  (cons (assume '((mgreaterp) prin-inf 1.0e+8))
			global-defint-assumptions)))
;;; PRIN-INF Is a special symbol in the principal value code used to
;;; denote an end-point which is proceeding to infinity.

(defun forget-global-assumptions ()
       (do ((list global-defint-assumptions (cdr list)))
	   ((null list) t)
	   (forget (car list)))
       (cond ((not (null integer-info))
	      (do ((list integer-info (cdr list)))
		  ((null list) t)
		  (I-$remove `(,(cadar list) ,(caddar list)))))))

(DEFUN order-limits (ask-or-not)
       (cond ((or (not (equal ($imagpart ll) 0))
		  (not (equal ($imagpart ul) 0)))  ())
	     (t (COND ((ALIKE1 LL (m*t -1 '$INF))
		       (SETQ LL '$MINF)))
		(COND ((ALIKE1 UL (m*t -1 '$INF))
		       (SETQ UL '$MINF)))
		(cond ((alike1 ll (m*t -1 '$minf))
		       (setq ll '$inf)))
		(cond ((alike1 ul (m*t -1 '$minf))
		       (setq ul '$inf)))
		(COND ((EQ UL '$INF) NIL)
		      ((EQ LL '$MINF)
		       (SETQ EXP (SUBIN (m- VAR) EXP))
		       (SETQ LL (m- ul))
		       (SETQ UL '$INF))
		      ((eq ll '$inf)
		       (setq ll ul)
		       (setq ul '$inf)
		       (setq exp (m- exp))))
;;;Fix limits so that ll < ul. 
		(let ((D (COMPLM ask-or-not)))
		     (COND ((EQUAL D -1.)
			    (SETQ exp (m- exp))
			    (SETQ D LL)
			    (SETQ LL UL)
			    (SETQ UL D))
			   (T T))))))

(DEFUN COMPLM (ask-or-not)
  (let ((askflag (cond ((eq ask-or-not 'ask)  t)
		       (t nil)))
	(A ()))
    (COND ((ALIKE1 UL LL)  0.)
	  ((EQ (SETQ A (cond (askflag ($asksign ($limit (m+t UL (m- LL)))))
			     (t ($sign ($limit (m+t UL (m- LL)))))))
	       '$pos)  1.)
	  ((EQ A '$neg)  -1.)
	  (T 1.))))


(DEFUN INTSUBS (E A B)
  (cond ((easy-subs e a b))
	(t (setq current-assumptions
		 (make-defint-assumptions 'ask)) ;get forceful!
	   (let ((generate-atan2 ())  ($algebraic t)
		 (rpart ())  (ipart ()))
	     (desetq (rpart . ipart) (cond ((not (free e '$%i))
					    (trisplit e))
					   (t (cons e 0))))
	     (cond ((not (equal (sratsimp ipart) 0))  
		    (let ((rans (cond ((limit-subs rpart a b))
				      (t (m-
					  `((%limit) ,rpart ,var ,b $minus)
					  `((%limit) ,rpart ,var ,a $plus)))))
			  (ians (cond ((limit-subs ipart a b))
				      (t (m-
					  `((%limit) ,ipart ,var ,b $minus)
					  `((%limit) ,ipart ,var ,a $plus))))))
		      (m+ rans (m* '$%i ians))))
		   (t (setq rpart (sratsimp rpart))
		      (cond ((limit-subs rpart a b))
			    (t (same-sheet-subs rpart a b)))))))))

(defun easy-subs (e ll ul)
    (cond ((or (infinityp ll) (infinityp ul)) ())
	  (t (cond ((polyinx e var ())
		    (let ((ll-val (no-err-sub ll e))
			  (ul-val (no-err-sub ul e)))
		      (cond ((and ll-val ul-val)  (m- ul-val ll-val))
			    (t ()))))
		   (t ())))))

(defun limit-subs (e ll ul)
  (cond ((not (free e '%atan))  ())
	(t (setq e ($multthru e))
	   (let ((a1 ($limit e var ll '$plus))	
		 (a2 ($limit e var ul '$minus)))
	     (cond ((MEMQ A1 '($INF $MINF $INFINITY ))
		    (COND ((MEMQ A2 '($INF $MINF $INFINITY))
			   (COND ((EQ A2 A1)  (Diverg))
				 (T ())))
			  (T (Diverg))))
		   ((MEMQ A2 '($INF $MINF $INFINITY))  (Diverg))
		   ((OR (MEMQ A1 '($UND $IND))
			(MEMQ A2 '($UND $IND)))  ())
		   (T (m- A2 A1)))))))

;;;This function works only on things with ATAN's in them now.
(defun same-sheet-subs (exp ll ul &aux ans)
  (let ((poles (atan-poles exp ll ul)))
;POLES -> ((mlist) ((mequal) ((%atan) foo) replacement) ......) 
;We can then use $SUBSTITUTE
    (setq ans ($limit exp var ll '$plus))
    (setq exp (sratsimp ($substitute poles exp)))
    (m- ($limit exp var ul '$minus) ans)))

(defun atan-poles (exp ll ul)
  `((mlist) ,@(atan-pole1 exp ll ul)))

(defun atan-pole1 (exp ll ul &aux ipart)
  (cond 
   ((mapatom exp)  ())
   ((matanp exp) ;neglect multiplicity and '$unknowns for now.
    (desetq (exp . ipart) (trisplit exp))
    (cond 
     ((not (equal (sratsimp ipart) 0))  ())
     (t (let ((pole (poles-in-interval (let (($algebraic t))
					 (sratsimp (cadr exp)))
				       var ll ul)))
	  (cond ((and pole (not (or (eq pole '$unknown)
				    (eq pole '$no))))
		 (do ((l pole (cdr l)) (list ()))
		     ((null l)  list)
		   (cond 
		    ((eq (caar l) ll)  t) ;Skip this one by definition.
		    (t (let ((low-lim ($limit (cadr exp) var (caar l) '$minus))
			     (up-lim ($limit (cadr exp) var (caar l) '$plus)))
			 (cond ((and (not (eq low-lim up-lim))
				     (real-infinityp low-lim)
				     (real-infinityp up-lim))
				(let ((change (if (eq low-lim '$minf)
						  (m- '$%pi)
						   '$%pi)))
				  (setq list (cons `((mequal simp) ,exp  ,(m+ exp change))
						   list)))))))))))))))
   (t (do ((l (cdr exp) (cdr l))
	   (list ()))
	  ((null l)  list)
	(setq list (append list (atan-pole1 (car l) ll ul)))))))

(DEFUN DIFAPPLY (N D S FN1)
  (PROG (K M R $NOPRINCIPAL) 
	(COND ((eq ($asksign (m+ (DEG D) (m- S) (m- 2.)))  '$neg)
	       (RETURN NIL)))
	(SETQ $NOPRINCIPAL T)
	(COND ((OR (NOT (mexptp D))
		   (NOT (NUMBERP (SETQ R (CADDR D)))))
	       (RETURN NIL))
	      ((AND (EQUAL N 1.)
		    (EQ FN1 'MTORAT)
		    (EQUAL 1. (DEG (CADR D))))
	       (RETURN 0.)))
	(SETQ M (DEG (SETQ D (CADR D))))
	(SETQ K (m// (m+ S 2.) M))
	(COND ((eq (ask-integer (m// (m+ S 2.) M) '$any)  '$yes)
	       NIL)
	      (T (SETQ K (M+ 1 K))))
	(COND ((eq ($sign (m+ r (m- k))) '$pos)
	       (RETURN (DIFFHK FN1 N D K (m+ R (m- K)))))))) 

(DEFUN DIFFHK (FN1 N D R M)
  (PROG (D1 *DFLAG) 
	(SETQ *DFLAG T)
	(SETQ D1 (FUNCALL FN1 N
			  (m^ (m+t '*Z* D) R)
			  (m* R (DEG D))))
	(COND (D1 (RETURN (DIFAP1 D1 R '*Z* M 0.)))))) 

(DEFUN PRINCIPAL NIL
       (COND ($NOPRINCIPAL (Diverg))
	     ((NOT PCPRNTD)
	      (PRINC "Principal Value")
	      (SETQ PCPRNTD T))))

(DEFUN RIB (E S)
  (let (*UPDN C) 
    (COND ((OR (MNUMP E) (CONSTANT E))
	   (SETQ BPTU (CONS E BPTU)))
	  (t (SETQ E (RMCONST1 E))
	     (SETQ C (CAR E))
	     (SETQ NN* (CDR E))
	     (SETQ ND* S)
	     (SETQ E (*CATCH 'PTIMES%E (PTIMES%E NN* ND*)))
	     (COND ((NULL E) NIL)
		   (T (SETQ E (m* C E))
		      (COND (*UPDN (SETQ BPTU (CONS E BPTU)))
			    (T (SETQ BPTD (CONS E BPTD))))))))))

(DEFUN PTIMES%E (TERM N)
       (COND ((POLYINX TERM VAR NIL) TERM)
	     ((AND (mexptp TERM)
		   (EQ (CADR TERM) '$%E)
		   (POLYINX (CADDR TERM) VAR NIL)
		   (eq ($sign (m+ (DEG ($realpart (CADDR TERM))) -1.))
		       '$neg)
		   (eq ($sign (m+ (DEG (SETQ NN* ($imagpart (CADDR TERM)))) 
				     -2.))
		       '$neg))
	      (COND ((EQ ($askSIGN (RATCOEF NN* VAR)) '$pos) 
		     (SETQ *UPDN T))
		    (T (SETQ *UPDN NIL)))
	      TERM)
	     ((AND (mtimesp TERM)
		   (SETQ NN* (POLFACTORS TERM))
		   (OR (NULL (CAR NN*))
		       (eq ($sign (m+ n (m- (deg (car nn*)))))
			   '$pos))
		   (PTIMES%E (CADR NN*) N)
		   TERM))
	     (T (*THROW 'PTIMES%E NIL))))

(DEFUN CSEMIDOWN (N D VAR)
  (let ((pcprntd t)) ;Not sure what to do about PRINCIPAL values here.
    (PRINCIP (RES N D #'LOWERHALF #'(lambda (X)
	        		      (cond ((equal ($imagpart x) 0)  t)
					    (t ())))))))

(DEFUN LOWERHALF (J) (EQ ($askSIGN ($imagpart J)) '$neg)) 

(DEFUN UPPERHALF (J) (EQ ($askSIGN ($imagpart J)) '$pos)) 


(DEFUN CSEMIUP (N D VAR)
  (let ((pcprntd t)) ;I'm not sure what to do about PRINCIPAL values here.
    (PRINCIP (RES N D #'UPPERHALF #'(lambda (X)
				      (cond ((equal ($imagpart x) 0)  t)
					    (t ())))))))

(DEFUN PRINCIP (N)
       (cond ((null n) nil)
	     (t (m*t '$%I ($RECTFORM (m+ (COND ((CAR N)
						(m*t 2. (CAR N)))
					       (T 0.))
					 (COND ((CADR N)
						(PRINCIPAL)
						(CADR N))
					       (T 0.))))))))


(DEFUN SCONVERT (E)
       (COND ((ATOM E) E)
	     ((POLYINX E VAR NIL) E)
	     ((EQ (CAAR E) '%SIN)
	      (m* '((RAT) -1. 2.)
		  '$%I
		  (m+t (m^t '$%E (m*t '$%I (CADR E)))
		       (m- (m^t '$%E (m*t (m- '$%I) (CADR E)))))))
	     ((EQ (CAAR E) '%COS)
	      (mul* '((RAT) 1. 2.)
		    (m+t (m^t '$%E (m*t '$%I (CADR E)))
			 (m^t '$%E (m*t (m- '$%I) (CADR E))))))
	     (T (simplify
		 (CONS (LIST (CAAR E)) (MAPCAR #'SCONVERT (CDR E)))))))

(DEFUN POLFACTORS (EXP)
  (let (poly rest)
       (COND ((mplusp exp)  nil)
	     (t (cond ((mtimesp EXP)
		       (SETQ EXP (REVERSE (CDR EXP))))
		      (T (SETQ EXP (LIST EXP))))
		(mapc '(lambda (term)
			 (cond ((polyinx term var nil)
				(push term poly))
			       (t (push term rest))))
		      exp)
		(list (m*l poly) (m*l rest))))))

(DEFUN ESAP (E)
       (PROG (D) 
	     (COND ((ATOM E) (RETURN E))
		   ((NOT (AMONG '$%E E)) (RETURN E))
		   ((AND (mexptp E)
			 (EQ (CADR E) '$%E))
		    (SETQ D ($imagpart (CADDR E)))
		    (RETURN (m* (m^t '$%E ($realpART (CADDR E)))
				   (m+ `((%COS) ,D)
					  (m*t '$%I `((%SIN) ,D))))))
		   (T (RETURN (simplify (CONS (LIST (CAAR E))
					      (MAPCAR #'ESAP (CDR E)))))))))

(DEFUN MTOSC (GRAND)
  (NUMDEN GRAND)
  (let ((n nn*)
	(d dn*)
	plf bptu bptd s upans downans)
    (COND ((not (or (POLYINX D VAR NIL)
		    (AND (SETQ GRAND (%EINVOLVE D))
			 (AMONG '$%I GRAND)
			 (POLYINX (SETQ D ($RATSIMP (M// D (m^t '$%E GRAND))))
				  VAR
				  NIL)
			 (SETQ N (M// N (m^t '$%E GRAND))))))  nil)
	  ((EQUAL (SETQ S (DEG D)) 0)  NIL)
;;;Above tests for applicability of this method.
	  ((and (or (SETQ PLF (POLFACTORS N))  t)
		(SETQ N ($EXPAND (COND ((CAR PLF)
					(m*t 'X* (SCONVERT (CADR PLF))))
				       (T (SCONVERT N)))))
		(COND ((mplusp N)  (SETQ N (CDR N)))
		      (T (SETQ N (LIST N))))
		(do ((do-var n (cdr do-var)))
		    ((null do-var) t)
		  (cond ((rib (car do-var) s))
			(t (return nil))))
;;;Function RIB sets up the values of BPTU and BPTD
		(COND ((CAR PLF)
		       (SETQ BPTU (SUBST (CAR PLF) 'X* BPTU))
		       (SETQ BPTD (SUBST (CAR PLF) 'X* BPTD))
		       t) ;CROCK, CROCK. This is TERRIBLE code.
		      (t t))
;;;If there is BPTU then CSEMIUP must succeed.
;;;Likewise for BPTD.
		(cond (bptu (cond ((setq upans (csemiup (m+l bptu) d var)))
				  (t nil)))
		      (t (setq upans 0)))
		(cond (bptd (cond ((setq downans (csemidown (m+l bptd) d var)))
				  (t nil)))
		      (t (setq downans 0))))
	   (sratsimp (m* '$%pi (m+ upans (m- downans))))))))


(DEFUN EVENFN (E var)
       (let ((temp (m+ (m- E) (cond ((atom var)
				     ($substitute (m- var) var e))
				    (t ($ratsubst (m- var) var E))))))
	    (cond ((zerop1 temp)
		   t)
		  ((zerop1 ($ratsimp temp))
		   t)
		  (t nil))))
		
(DEFUN ODDFN (E VAR)       
       (let ((temp (m+ e (cond ((atom var)
				($SUBSTITUTE (m- VAR) var E))
			       (t ($ratsubst (m- var) var e))))))
	    (cond ((zerop1 temp)
		   t)
		  ((zerop1 ($ratsimp temp))
		   t)
		  (t nil))))

(DEFUN ZTOINF (GRAND VAR)
       (PROG (N D SN* SD* VARLIST
		S NC DC
		ANS R $SAVEFACTORS CHECKFACTORS temp test-var)
	     (SETQ $SAVEFACTORS T SN* (SETQ SD* (LIST 1.)))
	     (COND ((eq ($sign (m+ LOOPSTOP* -1))
			'$pos)
		    (RETURN NIL))
		   ((SETQ temp (OR (SCAXN GRAND)
				   (SSP GRAND))) 
		    (RETURN temp))
		   ((INVOLVE GRAND '(%SIN %COS %TAN))
		    (SETQ GRAND (SCONVERT GRAND))
		    (GO ON)))

	     (COND ((POLYINX GRAND VAR NIL)
		    (Diverg))
		   ((AND (RATP GRAND VAR)
			 (mtimesp GRAND)
			 (ANDMAPCAR #'SNUMDEN (CDR GRAND)))
		    (SETQ NN* (M*L SN*)
			  SN* NIL)
		    (SETQ DN* (M*L SD*)
			  SD* NIL))
		   (t (NUMDEN GRAND)))
;;;
;;;New section.
    (SETQ N (RMCONST1 NN*))
    (SETQ D (RMCONST1 DN*))
    (SETQ NC (CAR N))
    (SETQ N (CDR N))
    (SETQ DC (CAR D))
    (SETQ D (CDR D))
    (COND ((POLYINX D VAR NIL) 
	   (SETQ S (DEG D)))
	  (T (GO FINDOUT)))
    (COND ((AND (SETQ R (FINDP N))
		(eq (ask-integer R '$integer) '$yes)
		(SETQ test-var (BXM D S))
		(SETQ ans (APPLY 'FAN (CONS (m+ 1. R) test-var))))
	   (RETURN (m* (M// NC DC) ($RATSIMP ans))))
	  ((and (RATP GRAND VAR)
		(SETQ ANS (ZMTORAT N (COND ((mtimesp d) d)
					   (T ($SQFR d)))
				   S #'ZTORAT)))
	   (RETURN (m* (M// NC DC) ANS)))
	  ((AND (EVENFN D VAR) 
		(SETQ NN* (P*LOGNXP N S)))
	   (SETQ ANS (LOG*RAT (CAR NN*) D (CADR NN*)))
	   (RETURN (m* (M// NC DC) ANS)))
	  ((INVOLVE GRAND '(%LOG))
	   (COND ((SETQ ANS (LOGQUAD0 GRAND))
		  (RETURN (m* (M// NC DC) ANS)))
		 (T (RETURN NIL)))))
 FINDOUT
    (COND ((SETQ temp (BATAPP GRAND)) 
	   (RETURN temp))
	  (T nil))
  ON
    (COND ((let ((MTOINF* nil))
		(SETQ temp (GGR GRAND T)))
	   (RETURN temp))
	  ((mplusp GRAND)
	   (COND ((let ((*NODIVERG t))
		       (SETQ ANS (*CATCH 'Divergent
					 (ANDMAPCAR #'(LAMBDA (G)
							(ZTOINF G VAR))
						    (CDR GRAND)))))
		  (COND ((EQ ANS 'Divergent) NIL)
			(T (RETURN (sRATSIMP (m+l ANS)))))))))

    (COND ((AND (EVENFN GRAND VAR)
		(SETQ LOOPSTOP* (M+ 1 LOOPSTOP*))
		(SETQ ANS (method-by-limits grand var '$minf '$inf)))
	   (return (m*t '((RAT) 1. 2.) ANS)))
	  (T (RETURN NIL)))))
   
(DEFUN ZTORAT (N D S)
       (COND ((AND (NULL *DFLAG)
		   (SETQ S (DIFAPPLY N D NN* #'ZTORAT)))
	      S)
	     ((SETQ N (let ((PLOGABS ()))
			(KEYHOLE (m* `((%PLOG) ,(m- VAR)) N) D VAR)))
	      (m- N))
	     (T (MERROR "Keyhole failed"))))

(SETQ *DFLAG NIL) 

(DEFUN LOGQUAD0 (EXP)
  (let ((a ()) (b ())  (c ()))
    (COND ((SETQ EXP (LOGQUAD EXP))
	   (SETQ A (CAR EXP) B (CADR EXP) C (CADDR EXP))
	   ($asksign b) ;let the data base know about the sign of B.
	   (COND ((EQ ($askSIGN C) '$pos)
		  (SETQ C (m^ (M// C A) '((RAT) 1. 2.)))
		  (setq b (simplify 
			   `((%ACOS) ,(add* 'epsilon (M// B (mul* 2. A C))))))
		  (setq a (M// (m* B `((%LOG) ,C))
			       (mul* A (Simplify `((%SIN) ,B)) C)))
		  (get-limit a 'epsilon 0 '$plus))))
	  (t ()))))
	
(DEFUN LOGQUAD (EXP)
  (let ((VARLIST (list var)))
    (NEWVAR EXP)
    (SETQ EXP (CDR (RATREP* EXP)))
    (COND ((AND (ALIKE1 (PDIS (CAR EXP))
			`((%LOG) ,VAR))
		(NOT (ATOM (CDR EXP)))
		(EQUAL (CADR (CDR EXP)) 2.)
		(not (equal (pterm (cddr exp) 0.) 0.)))
	   (SETQ EXP (MAPCAR 'PDIS (CDR (ODDELM (CDR EXP)))))))))

(DEFUN MTOINF (GRAND VAR) 
  (PROG (ANS SD* SN* P* PE* N D S NC DC $SAVEFACTORS CHECKFACTORS temp)
    (SETQ $SAVEFACTORS T)
    (SETQ SN* (SETQ SD* (LIST 1.)))
    (COND ((eq ($sign (m+ LOOPSTOP* -1)) '$pos)
	   (RETURN NIL))
	  ((INVOLVE GRAND '(%SIN %COS))
	   (COND ((AND (EVENFN GRAND VAR)
		       (or (SETQ temp (SCAXN GRAND))
			   (setq temp (ssp grand))))
		  (RETURN (m*t 2. temp)))
		 ((SETQ temp (MTOSC GRAND))
		  (RETURN temp))
		 (T (GO EN))))
	  ((among '$%i (%EINVOLVE GRAND))
	   (COND ((SETQ temp (MTOSC GRAND))
		  (RETURN temp))
		 (T (GO EN)))))
    (COND ((POLYINX GRAND VAR NIL)
	   (Diverg))
	  ((AND (RATP GRAND VAR)
		(mtimesp GRAND)
		(ANDMAPCAR #'SNUMDEN (CDR GRAND)))
	   (SETQ NN* (M*L SN*) SN* NIL)
	   (SETQ DN* (M*L SD*) SD* NIL))
	  (t (numden grand)))
    (SETQ N (RMCONST1 NN*))
    (SETQ D (RMCONST1 DN*))
    (SETQ NC (CAR N))
    (SETQ N (CDR N))
    (SETQ DC (CAR D))
    (SETQ D (CDR D))
    (COND ((POLYINX D VAR NIL)
	   (SETQ S (DEG D))))
    (COND ((AND (NOT (%einvolve grand))
		(NOTINVOLVE EXP '(%SINH %COSH %TANH))
		(SETQ P* (FINDP N))
		(eq (ask-integer P* '$integer) '$yes)
		(SETQ PE* (BXM D S)))
	   (COND ((AND (eq (ask-integer (CADDR PE*) '$even) '$yes)
		       (eq (ask-integer P* '$even) '$yes))
		  (COND ((SETQ ANS (APPLY 'FAN (CONS (m+ 1. P*) PE*)))
			 (SETQ ANS (m*t 2. ANS))
			 (RETURN (m* (M// NC DC) ANS)))))
		 ((EQUAL (CAR PE*) 1.)
		  (COND ((AND (SETQ ANS (APPLY 'FAN (CONS (m+ 1. P*) PE*)))
			      (SETQ NN* (FAN (m+ 1. P*)
					     (CAR PE*)
					     (m* -1.(CADR PE*))
					     (CADDR PE*)
					     (CADDDR PE*))))
			 (SETQ ANS (m+ ANS (m*t (m^ -1. P*) NN*)))
			 (RETURN (m* (M// NC DC) ANS))))))))
    (COND ((RATP GRAND VAR)
	   (SETQ ANS (m*t '$%PI (ZMTORAT N (COND ((mtimesp d) d)
						 (T ($SQFR d)))
					 S
					 #'MTORAT)))
	   (RETURN (m* (M// NC DC) ANS)))
	  ((AND (OR (%einvolve grand)
		    (INVOLVE GRAND '(%SINH %COSH %TANH)))
		(P*PIN%EX N) ;setq's P* and PE*...Barf again.
		(SETQ ANS (*CATCH 'PIN%EX (PIN%EX D))))
	   (COND ((NULL P*)
		  (RETURN (DINTEXP GRAND VAR)))
		 ((AND (ZEROP1 (get-LIMIT GRAND VAR '$INF))
		       (ZEROP1 (get-LIMIT GRAND VAR '$MINF))
		       (SETQ ANS (RECTZTO%PI2 (M*L P*) (M*L PE*) D)))
		  (RETURN (m* (M// NC DC) ANS)))
		 (T (Diverg)))))
    EN
    (COND ((SETQ ANS (GGRM GRAND)) 
	   (RETURN ANS))
	  ((AND (EVENFN GRAND VAR)
		(SETQ LOOPSTOP* (M+ 1 LOOPSTOP*))
		(SETQ ANS (method-by-limits grand var 0 '$inf)))
	   (RETURN (m*t 2. ANS)))
	  (T (RETURN NIL)))))

(DEFUN LINPOWER0 (EXP VAR)
       (COND ((AND (SETQ EXP (LINPOWER EXP VAR))
		   (eq (ask-integer (CADDR EXP) '$even)
		       '$yes)
		   (RATGREATERP 0. (CAR EXP)))
	      EXP))) 

;;; given (b*x+a)^n+c returns  (a b n c)
(DEFUN LINPOWER (EXP VAR)
 (let (LINPART DEG LC C VARLIST) 
      (COND ((NOT (POLYP EXP))   NIL)
	    (t (let ((varlist (list var)))
		 (NEWVAR EXP)
		 (SETQ LINPART (CADR (RATREP* EXP)))
		 (COND ((ATOM LINPART)
			NIL)
		       (t (SETQ DEG (CADR LINPART)) 
;;;get high degree of poly
			  (SETQ LINPART ($DIFF EXP VAR (m+ deg -1))) 
;;;diff down to linear.
			  (SETQ LC (SDIFF LINPART VAR))	
;;;all the way to constant.
			  (SETQ LINPART ($RATSIMP (M// LINPART lc))) 
			  (SETQ LC ($RATSIMP (M// LC `((MFACTORIAL) ,DEG))))
;;;get rid of factorial from differentiation.
			  (SETQ C ($RATSIMP (m+ EXP (m* (m- LC)
							(m^ LINPART DEG)))))))
;;;Sees if can be expressed as (a*x+b)^n + part freeof x.
		 (COND ((NOT (AMONG VAR c))
			`(,LC ,LINPART ,DEG ,C))
		       (t nil)))))))

(DEFUN MTORAT (N D S)
  (let ((SEMIRAT* t)) 
       (COND ((AND (NULL *DFLAG)
		   (SETQ S (DIFAPPLY N D s #'MTORAT)))
	      S)
	     (T (CSEMIUP N D VAR)))))

(DEFUN ZMTORAT (N D S FN1)
 (PROG (C) 
   (COND ((eq ($sign (m+ S (M+ 1 (SETQ NN* (DEG N))))) 
	      '$neg)
	  (Diverg))
	 ((eq ($sign (m+ s -4))
	      '$neg)
	  (GO ON)))
   (SETQ D ($FACTOR D))
   (SETQ C (RMCONST1 D))
   (SETQ D (CDR C))
   (SETQ C (CAR C))
   (COND
    ((mtimesp D)
     (SETQ D (CDR D))
     (SETQ N (PARTNUM N D))
     (let ((RSN* t))
	  (SETQ N ($XTHRU (M+L
			   (MAPCAR #'(LAMBDA (A B) 
					(M// (FUNCALL FN1 (CAR A) B (DEG B)) 
					     (CADR A)))
				   N
				   D)))))
     (RETURN (COND (C (M// N C)) 
		   (T N)))))
   ON

   (SETQ N (FUNCALL FN1 N D S))
   (RETURN  (sRATSIMP (COND (C  (M// N C))
			       (T N))))))

(DEFUN PFRNUM (F G N N2 VAR)
  (let ((VARLIST (list var))  GENVAR)
       (SETQ F (POLYFORM F)
	     G (POLYFORM G)
	     N (POLYFORM N)
	     N2 (POLYFORM N2))
       (SETQ VAR (CAADR (RATREP* VAR)))
       (SETQ F (RESPROG0 F G N N2))
       (LIST (LIST (PDIS (CADR F)) (PDIS (CDDR F)))
	     (LIST (PDIS (CAAR F)) (PDIS (CDAR F))))))

(DEFUN POLYFORM (E)
       (PROG (F D)
	     (NEWVAR E)
	     (SETQ F (RATREP* E))
	     (AND (EQUAL (CDDR F) 1)
		  (RETURN (CADR F)))
	     (AND (EQUAL (LENGTH (SETQ D (CDDR F))) 3)
		  (NOT (AMONG (CAR D)
			      (CADR F)))
		  (RETURN (LIST (CAR D)
				(* -1 (CADR D))
				(PTIMES (CADR F) (CADDR D)))))
	     (MERROR "Bug from PFRNUM in RESIDU")))

(DEFUN PARTNUM (N DL)
  (let ((n2 1)  ANS NL)
       (do ((dl dl (cdr dl)))
	   ((null (cdr dl))
	    (nconc ans (ncons (list n n2))))
	   (SETQ NL (PFRNUM (CAR DL) (M*L (CDR DL)) N N2 VAR))
	   (SETQ ANS (NCONC ANS (NCONS (CAR NL))))
	   (SETQ N2 (CADADR NL) N (CAADR NL) NL NIL))))

(DEFUN GGRM (E)
  (PROG (POLY EXPO MTOINF* MB  VARLIST  GENVAR L C GVAR) 
    (SETQ VARLIST (LIST VAR))
    (SETQ MTOINF* T)
    (COND ((AND (SETQ EXPO (%EINVOLVE E))
		(POLYP (SETQ POLY ($RATSIMP (M// E (m^t '$%E EXPO)))))
		(SETQ L (*CATCH 'GGRM (GGR (m^t '$%E EXPO) NIL))))
	   (SETQ MTOINF* NIL)
	   (SETQ MB (m- (SUBIN 0. (CADR L))))
	   (SETQ POLY (m+ (SUBIN (m+t MB VAR) POLY)
			  (SUBIN (m+t MB (m*t -1. VAR)) POLY))))
	  (T (RETURN NIL)))
    (SETQ EXPO (CADDR L)
	  C (CADDDR L)
	  L (m* -1. (CAR L))
	  E NIL)
    (NEWVAR POLY)
    (SETQ POLY (CDR (RATREP* POLY)))
    (SETQ MB (m^ (PDIS (CDR POLY)) -1.) 
	  POLY (CAR POLY))
    (SETQ GVAR (CAADR (RATREP* VAR)))
    (COND ((OR (ATOM POLY)
	       (POINTERGP GVAR (CAR POLY))) 
	   (SETQ POLY (LIST 0. POLY)))
	  (T (SETQ POLY (CDR POLY))))
    (return (do ((poly poly (cddr poly)))
		((null poly)
		 (mul* (m^t '$%E C) (m^t EXPO -1.) MB (M+L E)))
		(SETQ E (CONS (GGRM1 (CAR POLY) (PDIS (CADR POLY)) L EXPO)
			      E))))))

(DEFUN GGRM1 (D K A B)
       (SETQ B (M// (m+t 1. D) B))
       (m* K `((%GAMMA) ,B) (m^ A (m- B)))) 

(DEFUN RADIC (E V) 
;;;If rd* is t the m^ts must just be free of var.
;;;If rd* is () the m^ts must be mnump's.
       (let ((rd* ())) 
	    (RADICALP E V)))

(DEFUN KEYHOLE (N D VAR)
       (let ((SEMIRAT* ()))
	 (SETQ N (RES N D #'(LAMBDA (J) 
			      (OR (NOT (equal ($imagpart j) 0))
				  (EQ ($askSIGN J) '$neg)))
		          #'(LAMBDA (J)
			      (COND ((EQ ($askSIGN J) '$pos)
				     T)
				    (T (Diverg))))))
	 (let ((RSN* t))
	   ($rectform ($multthru (m+ (COND ((CAR N) (CAR N))
					   (T 0.))
				     (COND ((CADR N) (CADR N))
					   (T 0.))))))))

(DEFUN SKR (E)
       (PROG (M R K) 
	     (COND ((ATOM E) (RETURN NIL)))
	     (SETQ E (PARTITION E VAR 1))
	     (SETQ M (CAR E))
	     (SETQ E (CDR E))
	     (COND ((SETQ R (SINRX E)) (RETURN (LIST M R 1)))
		   ((AND (mexptp E)
			 (eq (ask-integer (SETQ K (CADDR E)) '$integer) '$yes)
			 (SETQ R (SINRX (CADR E))))
		    (RETURN (LIST M R K)))))) 

(DEFUN SINRX (E)
       (COND ((EQ (CAAR E) '%SIN)
	      (COND ((EQ (CADR E) VAR) 1.)
		    ((AND (SETQ E (PARTITION (CADR E) VAR 1)) (EQ (CDR E) VAR))
		     (CAR E)))))) 

(DECLARE (SPECIAL N)) 


(DEFUN SSP (EXP)
 (PROG (U N C) 
       (setq exp ($substitute (m^t `((%sin) ,var) 2.)
			      (m+t 1. (m- (m^t `((%cos) ,var) 2.)))
			      exp))
       (numden exp)
       (setq u nn*)
       (COND ((AND (SETQ N (FINDP DN*))
		   (eq (ask-integer N '$integer) '$yes))
	      (COND ((SETQ C (SKR U)) 
		     (RETURN (SCMP C N)))
		    ((AND (mplusp U)
			  (SETQ C (ANDMAPCAR #'SKR (CDR U))))
		     (RETURN (m+l (MAPCAR #'(LAMBDA (J) (SCMP J N))
					  C)))))))))

(DECLARE (UNSPECIAL N)) 

(DEFUN SCMP (C N)
       (m* (CAR C) (m^ (CADR C) (m+ N -1)) `((%SIGNUM) ,(CADR C))
	   (SINSP (CADDR C) N)))

(DEFUN SEVN (N)
       (m* HALF%PI ($MAKEGAMMA `((%BINOMIAL) ,(m+t (m+ N -1) '((RAT) -1. 2.))
					     ,(m+ N -1)))))


(DEFUN SFORX (N)
  (COND ((EQUAL N 1.) 
	 HALF%PI) 
	(T (BYGAMMA (m+ N -1) 0.)))) 

(DEFUN SINSP (L K)
  (let ((I ())
	(J ()))
    (COND ((eq ($sign (m+ L (m- (m+ K -1))))
	       '$neg)
	   (Diverg))
	  ((NOT (EVEN1 (m+ L K)))
	   NIL)
	  ((EQUAL K 2.)
	   (SEVN (m// L 2.)))
	  ((EQUAL K 1.) 
	   (SFORX L))
	  ((eq ($sign  (m+ K -2.))
	       '$pos)
	   (SETQ I (m* (m+ K -1) (SETQ J (m+ K -2.))))
	   (m+ (m* L (m+ L -1) (m^t I -1.) (SINSP (m+ L -2.) J))
	       (m* (m- (m^ L 2)) (m^t I -1.)
		   (SINSP L J)))))))

(DEFUN FPART (A)
  (COND ((NULL A) 0.)
	((NUMBERP A) 0.)
	((MNUMP A)
	 (LIST (CAR A) (REMAINDER (CADR A) (CADDR A)) (CADDR A)))
	((AND (ATOM A) (ABLESS1 A)) A)
	((AND (mplusp A)
	      (NULL (CDDDR A))
	      (ABLESS1 (CADDR A)))
	 (CADDR A)))) 

(DEFUN THRAD (E)
       (COND ((POLYINX E VAR NIL) 0.)
	     ((AND (mexptp E) 
		   (EQ (CADR E) VAR)
		   (MNUMP (CADDR E)))
	      (FPART (CADDR E)))
	     ((mtimesp E)
	      (m+l (MAPCAR #'THRAD E)))))


;;; THE FOLLOWING FUNCTION IS FOR TRIG FUNCTIONS OF THE FOLLOWING TYPE:
;;; LOWER LIMIT=0 B A MULTIPLE OF %PI SCA FUNCTION OF SIN (X) COS (X)
;;; B<=%PI2

(DEFUN PERIOD (P E VAR)
       (ALIKE1 E (NO-ERR-SUB (m+ P VAR) E))) 

(DEFUN INFR (A)
  (let ((var '$%i)
	(r (subin 0. a))
	c)
       (SETQ C (SUBIN 1. (m+ A (m*t -1. R))))
       (SETQ A (IGPRT (m* '((RAT) 1. 2.) C)))
       (CONS A (m+ R (m*t (M+ C (m* -2. A)) '$%PI)))))

(DEFUN IGPRT (R) 
       (M+ R (m* -1. (FPART R)))) 


;;;Try making exp(%i*var) --> yy, if result is rational then do integral
;;;around unit circle. Make corrections for limits of integration if possible.
(DEFUN SCRAT (SC B)
  (let* ((exp-form (sconvert sc)) ;Exponentialize
	 (rat-form (substitute 'yy (m^t '$%e (m*t '$%i var))
			       exp-form))) ;Try to make Rational fun.
	(COND ((AND (RATP rat-form 'YY)
		    (NOT (AMONG VAR rat-form)))
	       (COND ((ALIKE1 B %PI2) 
		      (let ((ans (ZTO%PI2 rat-form 'YY)))
			   (cond (ans ans)
				 (t nil))))
		     ((AND (EQ B '$%PI)
			   (EVENFN exp-form VAR))
		      (let ((ans (ZTO%PI2 rat-form 'YY)))
			   (cond (ans (m*t '((RAT) 1. 2.) ans))
				 (t nil))))
		     ((AND (ALIKE1 B HALF%PI)
			   (EVENFN exp-form VAR)
			   (ALIKE1 rat-form 
				   (NO-ERR-SUB (m+t '$%PI (m*t -1. VAR))
						    rat-form)))
			   (let ((ans (ZTO%PI2 rat-form 'yy)))
				(cond (ans (m*t '((RAT) 1. 4.) ans))
				      (t nil)))))))))

;;; Do integrals of sin and cos. this routine makes sure lower limit
;;; is zero.
(defun INTSC1 (A B E)
  (let ((limit-diff (m+ b (m* -1 a)))
	($%emode t)
	($trigsign t)
	(sin-cos-recur t)) ;recursion stopper
     (PROG (ANS D NZP2 L) 
	   (COND ((OR (NOT (MNUMP (M// limit-diff '$%PI)))
		      (NOT (PERIOD %PI2 E VAR)))
		  (RETURN NIL))
		 ((not (equal a 0.))
		  (setq e (substitute (m+ a var) var e))
		  (setq a 0.)
		  (setq b limit-diff)))
;;;Multiples of 2*%pi in limits.
	   (COND ((eq (ask-integer (SETQ D (let (($float nil))
					     (m// limit-diff %pi2))) '$integer)
		      '$yes)
		  (SETQ ANS (m* D (COND ((SETQ ANS (INTSC E %PI2 VAR))
					 (RETURN ans))
					(T (RETURN NIL)))))))
		  (COND ((RATGREATERP %PI2 B)
			 (RETURN (INTSC E B VAR)))
			(T (SETQ L A) 
			   (SETQ A 0.)))
		  (SETQ B (INFR B))
		  (COND ((NULL L) 
			 (SETQ NZP2 (CAR B))
			 (SETQ limit-diff 0.)
			 (GO OUT)))
		  (SETQ L (INFR L))
		  (SETQ limit-diff
			(m*t -1. (COND ((SETQ ANS (INTSC E (CDR L) VAR)) 
					ANS)
				       (T (RETURN NIL)))))
		  (SETQ NZP2 (m+ (CAR B) (m- (CAR L))))
             OUT  (SETQ ANS (add* (COND ((ZEROP1 NZP2) 0.)
					((SETQ ANS (INTSC E %PI2 VAR))
					 (m*t NZP2 ANS))
					(T (RETURN NIL)))
				  (COND ((ZEROP1 (CDR B)) 0.)
					((SETQ ANS (INTSC E (CDR B) VAR))
					 ANS)
					(T (RETURN NIL)))
				  limit-diff))
	     (RETURN ANS))))

(DEFUN INTSC (SC B VAR)
       (COND ((EQ ($sign B) '$neg)
	      (SETQ B (m*t -1. B))
	      (SETQ SC (m* -1. (SUBIN (m*t -1. VAR) SC)))))
       (SETQ SC (PARTITION SC VAR 1))
       (COND ((SETQ B (INTSC0 (CDR SC) B VAR))
	      (m* (resimplify (CAR SC)) B))))

(DEFUN INTSC0 (SC B VAR)
  (let ((nn* (scprod sc))
	(dn* ()))
       (COND (NN* (COND ((ALIKE1 B HALF%PI)
			 (BYGAMMA (CAR NN*) (CADR NN*)))
			((EQ B '$%PI)
			 (cond ((eq (real-branch (cadr nn*) -1.) '$yes)
				 (m* (m+ 1. (m^ -1 (CADR NN*)))
				     (BYGAMMA (car nn*) (cadr nn*))))))
			((ALIKE1 B %PI2)
			 (COND ((or (AND (eq (ask-integer (CAR NN*) '$even)
					     '$yes)
					 (eq (ask-integer (CADR NN*) '$even)
					     '$yes))
				     (and (ratnump (car nn*))
					  (eq (real-branch (car nn*) -1.)
					      '$yes)
					  (ratnump (cadr nn*))
					  (eq (real-branch (cadr nn*) -1.)
					      '$yes)))
				 (m* 4.	(BYGAMMA (car nn*) (cadr nn*))))
				((or (eq (ask-integer (car nn*) '$odd) '$yes)
				     (eq (ask-integer (cadr nn*) '$odd) '$yes))
				 0.)
				(t nil)))
			 ((ALIKE1 B HALF%PI3)
			  (m* (m+ 1. (m^ -1 (CADR NN*)) (m^ -1 (m+l NN*)))
			      (bygamma (car nn*) (cadr nn*))))))
	     (t (cond ((AND (OR (EQ B '$%PI)
				(ALIKE1 B %PI2)
				(ALIKE1 B HALF%PI))
			    (SETQ DN* (SCRAT SC B)))
		       DN*)
		      ((SETQ NN* (ANTIDERIV SC))
		       (sin-cos-intsubs nn* var 0. b))
		      (t ()))))))

;;;Is careful about substitution of limits where the denominator may be zero
;;;because of various assumptions made.
(defun sin-cos-intsubs (exp var ll ul)
  (cond ((mplusp exp)
	 (m+l (mapcar #'sin-cos-intsubs1 (cdr exp))))
	(t (sin-cos-intsubs1 exp))))

(defun sin-cos-intsubs1 (exp)	 
  (let* ((rat-exp ($rat exp))
	 (num (pdis (cadr rat-exp)))
	 (denom (pdis (cddr rat-exp))))
    (cond ((not (equal (intsubs num ll ul) 0.))
	   (intsubs exp ll ul))
	  ((not (equal ($asksign denom) '$zero))
	   0.)
	  (t (let (($%piargs ()))
	       (intsubs exp ll ul))))))

(DEFUN SCPROD (E)
 (let ((great-minus-1 #'(lambda (temp)
			  (ratgreaterp temp -1)))
       m n)
   (COND
    ((SETQ M (Powerofx E `((%SIN) ,VAR) great-minus-1 VAR))
     (list m 0.))
    ((SETQ N (Powerofx E `((%COS) ,VAR) great-minus-1 VAR))
     (SETQ M 0.)
     (list 0. n))
    ((AND (mtimesp E)
	  (OR (SETQ M (Powerofx (CADR E) `((%SIN) ,VAR) great-minus-1 VAR))
	      (SETQ N (Powerofx (CADR E) `((%COS) ,VAR) great-minus-1 VAR)))
	  (COND
	   ((NULL M)
	    (SETQ M (Powerofx (CADDR E) `((%SIN) ,VAR) great-minus-1 VAR)))
	   (T (SETQ N (Powerofx (CADDR E) `((%COS) ,VAR) great-minus-1 VAR))))
	  (NULL (CDDDR E)))
     (list m n))
    (T ()))))

(defun real-branch (exponent value)
;;;Says wether (m^t value exponent) has at least one real branch.
;;;Only works for values of 1 and -1 now.
;;;Returns $yes $no $unknown.
       (cond ((equal value 1.)
	      '$yes)
	     ((eq (ask-integer exponent '$integer) '$yes)
	      '$yes)
	     ((ratnump exponent)
	      (cond ((eq ($oddp (caddr exponent)) t)
		     '$yes)
		    (t '$no)))
	     (t '$unknown)))

(DEFUN BYGAMMA (M N)
       (let ((one-half (m//t 1. 2.)))
       (m* one-half `(($BETA) ,(m* one-half (m+t 1. M))
			      ,(m* one-half (m+t 1. N))))))

;Seems like Guys who call this don't agree on what it should return.
(DEFUN Powerofx (E X P VAR)
       (SETQ E (COND ((NOT (AMONG VAR E)) NIL)
		     ((ALIKE1 E X) 1.)
		     ((ATOM E) NIL)
		     ((AND (mexptp E)
			   (ALIKE1 (CADR E) X)
			   (NOT (AMONG VAR (CADDR E))))
		      (CADDR E))))
       (COND ((NULL E) NIL)
	     ((FUNCALL P E) E))) 

(DECLARE (SPECIAL L C K)) 

(COMMENT (THE FOLLOWING FUNC IS NOT COMPLETE)) 

(DEFUN ZTO1 (E)
  (prog (ans k l)
    (COND ((NOTINVOLVE E '(%SIN %COS %TAN %LOG))
	   (cond ((SETQ ANS (BATAP E))
		  (return ans)))))
    (cond ((AND (NOTINVOLVE E '(%SIN %COS %TAN))
		(AMONG '%LOG E))
	   (COND ((SETQ ANS (BATAP (M// E `((%LOG) ,VAR))))
		  (SETQ K NN* L DN*)
		  (SETQ ANS (m* ANS
				(m+ (subfunmake '$PSI '(0) (list K))
				    (m* -1. (subfunmake '$PSI
							'(0)
							(ncons (m+ K
								   L)))))))
		  (return ans)))))))

(DEFUN BATA0 (E)
  (COND ((ATOM E) NIL)
	((AND (mtimesp E)
	      (NULL (CDDDR E))
	      (OR (AND (SETQ K (FINDP (CADR E)))
		       (SETQ C (BXM (CADDR E) (POLYINX (CADDR E) VAR NIL))))
		  (AND (SETQ K (FINDP (CADDR E)))
		       (SETQ C (BXM (CADR E) (POLYINX (CADR E) VAR NIL))))))
	 T)
	((SETQ C (BXM E (POLYINX E VAR NIL)))
	 (SETQ K 0.)))) 

(DEFUN BATAP (E) 
  (PROG (K C L) 
    (COND ((NOT (BATA0 E)) (RETURN NIL))
	  ((AND (EQUAL -1. (CADDDR C))
		(EQ ($askSIGN (SETQ K (m+ 1. K)))
		    '$pos)
		(EQ ($askSIGN (SETQ L (m+ 1. (CAR C))))
		    '$pos)
		(ALIKE1 (CADR C)
			(m^ UL (CADDR C)))
		(SETQ E (CADR C))
		(EQ ($askSIGN (SETQ C (CADDR C))) '$pos))
	   (RETURN (M// (m* (m^ UL (m+t K (m* C (m+t -1. L))))
			    `(($BETA) ,(SETQ NN* (M// K C))
				      ,(SETQ DN* L)))
			C))))))

(DEFUN BATAPP (E)
       (PROG (K C D L AL) 
	     (COND ((NOT (OR (EQUAL LL 0) (EQ LL '$MINF)))
		    (SETQ E (SUBIN (m+ LL VAR) E))))
	     (COND ((NOT (BATA0 E)) (RETURN NIL))
		   ((AND (RATGREATERP (SETQ AL (CADDR C)) 0.)
			 (EQ ($askSIGN (SETQ K (M// (m+ 1. K)
						       AL)))
			     '$pos)
			 (RATGREATERP (SETQ L (m* -1. (CAR C)))
				      K)
			 (EQ ($askSIGN (m* (SETQ D (CADR C))
					   (SETQ C (CADDDR C))))
			     '$pos))
		    (SETQ L (m+ L (m*t -1. K)))
		    (RETURN (M// `(($BETA) ,K ,L)
				  (mul* AL (m^ C K) (m^ D L)))))))) 

(DECLARE (UNSPECIAL L C K)) 

(DEFUN GAMMA1 (C A B D)
       (m* (m^t '$%E D)
	   (m^ (m* B (m^ A (SETQ C (M// (m+t C 1.) B))))
	       -1.)
	   `((%GAMMA) ,C)))
       
(DEFUN ZTO%PI2 (GRAND VAR)
       (let ((result (UNITCIR ($RATSIMP (M// GRAND VAR)) VAR)))
	    (cond (result (sratsimp (m* (m- '$%I) result)))
		  (t nil))))

(DEFUN UNITCIR (GRAND VAR)
  (NUMDEN GRAND)
  (let ((result (PRINCIP (RES NN* DN* #'(LAMBDA (PT)
					  (RATGREATERP 1 (CABS PT)))
			              #'(LAMBDA (PT)
					  (ALIKE1 1 (CABS PT)))))))
       (cond (result (m* '$%PI result))
	     (t nil))))


(DEFUN LOGX1 (EXP LL UL)
  (let ((arg nil))
    (COND
     ((AND (NOTINVOLVE EXP '(%SIN %COS %TAN %ATAN %ASIN %ACOS))
	   (SETQ ARG (INVOLVE EXP '(%LOG))))
      (COND ((EQ ARG VAR)
	     (COND ((RATGREATERP 1. LL)
		    (COND ((NOT (EQ UL '$INF))
			   (INTCV1 (m^t '$%E (m- VAR)) () (m- `((%LOG) ,VAR))))
			  (T (INTCV1 (m^t '$%E VAR) () `((%LOG) ,VAR)))))))
	    (t (INTCV ARG NIL nil)))))))


(DEFUN SCAXN (E)
  (let (IND S G) 
       (COND ((ATOM E)  NIL)
	     ((AND (OR (EQ (CAAR E) '%SIN)
		       (EQ (CAAR E) '%COS))
		   (SETQ IND (CAAR E))
		   (SETQ E (BX**N (CADR E))))
	      (COND ((EQUAL (CAR E) 1.)  '$IND)
		    ((ZEROP (SETQ S (let ((sign ($askSIGN (CADR E))))
					 (cond ((eq sign '$pos) 1)
					       ((eq sign '$neg) -1)
					       ((eq sign '$zero) 0)))))
		     NIL)
		    ((not (EQ ($askSIGN (m+ -1 (CAR E)))  '$pos))
		     nil)
		    (t (SETQ G (GAMMA1 0. (m* S (CADR E)) (CAR E) 0.))
		       (SETQ E (m* G `((,IND) ,(M// HALF%PI (CAR E))))) 
		       (m* (COND ((AND (EQ IND '%SIN)
				       (EQUAL S -1.))
				  -1.)
				 (T 1.))
			   E)))))))
		      

(COMMENT THIS IS THE SECOND PART OF THE DEFINITE INTEGRAL PACKAGE) 

(DECLARE (SPECIAL VAR PLM* PL* RL* PL*1 RL*1)) 

(DEFUN P*LOGNXP (A S)
  (let (B) 
    (COND ((NOT (AMONG '%LOG A)) 
	   ())
	  ((AND (POLYINX (SETQ B (SUBSTITUTE 1. `((%LOG) ,VAR) A))
			 VAR T)
		(eq ($sign (m+ S (M+ 1 (DEG B))))
		    '$pos)
		(EVENFN B VAR)
		(SETQ A (LOGNXP ($RATSIMP (M// A B)))))
	   (LIST B A)))))

(DEFUN LOGNXP (A)
   (COND ((ATOM A) NIL)
	 ((AND (EQ (CAAR A) '%LOG) 
	       (EQ (CADR A) VAR)) 1.)
	 ((AND (mexptp A)
	       (NUMBERP (CADDR A))
	       (LOGNXP (CADR A)))
	  (CADDR A)))) 

(COMMENT CHECK THE FOLLOWING FUNCTION FOR UNUSED PROG VAR A) 

(DEFUN LOGCPI0 (N D)
  (PROG (PL DP) 
	(SETQ PL (POLELIST D #'UPPERHALF #'(LAMBDA (J)
					     (COND ((ZEROP1 J) NIL)
						   ((equal ($imagpart j) 0)
						    T)))))
	(cond ((null pl)
	       (return nil)))
	(SETQ FACTORS (CAR PL) 
	      PL (CDR PL))
	(COND ((OR (CADR PL)
		   (CADDR PL))
	       (SETQ DP (SDIFF D VAR))))
	(COND ((SETQ PLM* (CAR PL))
	       (SETQ RLM* (RESIDUE N (COND (LEADCOEF FACTORS)
					   (T D))
				   PLM*))))
	(COND ((SETQ PL* (CADR PL)) 
	       (SETQ RL* (RES1 N DP PL*))))
	(COND ((SETQ PL*1 (CADDR PL))
	       (SETQ RL*1 (RES1 N DP PL*1))))
	(RETURN (m*t (m//t 1. 2.)
		     (m*t '$%PI 
			  (PRINCIP 
			   (LIST (COND ((SETQ NN* (APPEND RL* RLM*))
					(M+L NN*)))
				 (COND (RL*1 (M+L RL*1))))))))))

(DEFUN LOGNX2 (NN DN PL RL)
  (do ((pl pl (cdr pl))
       (rl rl (cdr rl))
       (ans ()))
      ((or (null pl)
	   (null rl))  ans)
    (SETQ ANS (CONS (m* DN (car rl) (m^ `((%PLOG) ,(car pl)) NN))
		    ANS))))

(DEFUN LOGCPJ (N D I)
 (SETQ N (APPEND
	  (COND (PLM* (LIST (mul* (m*t '$%i %pi2)
				  (M+L
				   (RESIDUE (m* (m^ `((%PLOG) ,VAR) I)
						N)
					    D
					    PLM*))))))
	  (LOGNX2 I (m*t '$%i %pi2) PL* RL*)
	  (LOGNX2 I %P%I PL*1 RL*1)))
 (COND ((NULL N) 0)
       (T (SIMPLIFY (M+L N)))))

(DEFUN LOG*RAT (N D M)
  (PROG (LEADCOEF FACTORS C PLM* PL* RL* PL*1 RL*1 RLM*) 
	(ARRAY I T (M+ 1 M))
	(ARRAY J T (M+ 1 M))
	(SETQ C 0.)
	(STORE (J C) 0.)
	(do ((c 0. (m+ 1 c)))
	    ((equal c m)
	     (return (logcpi n d m)))
	 (STORE (I C) (LOGCPI N D C))
	 (STORE (J C) (LOGCPJ N FACTORS C)))))

(DEFUN LOGCPI (N D C)
  (COND ((EQUAL C 0.)
	 (LOGCPI0 N D))
	(T (m* '((RAT) 1. 2.)
	       (m+ (J C) (m* -1. (SUMI C)))))))

(DEFUN SUMI (C)
  (do ((k 1. (m+ 1 k))
       (ans ()))
      ((equal k c)
       (m+l ans))
     (SETQ ANS (CONS (mul* ($MAKEGAMMA `((%BINOMIAL) ,C ,K))
			   (m^t '$%PI K)
			   (m^t '$%I K)
			   (I (m+ C (m- K))))
		     ANS))))

(DEFUN FAN (P M A N B)
  (let ((povern (m// p n))
	(ab (m// a b)))
    (COND
     ((OR (eq (ask-integer POVERN '$integer) '$yes)
	  (NOT (equal ($imagpart ab) 0)))  ())
     (t (let ((IND ($askSIGN AB)))
	  (COND ((eq IND '$zero) NIL)
		((eq ind '$neg) nil)
		((NOT (RATGREATERP M POVERN)) NIL)
		(t (M// (m* '$%pi
			    ($MAKEGAMMA `((%BINOMIAL) ,(m+ -1. M (m- POVERN))
						      ,(m+t -1. M)))
			    `((mabs) ,(m^ A (m+ POVERN (m- m)))))
			(m* (m^ b povern)
			    N
			    `((%SIN) ,(m*t '$%PI POVERN)))))))))))


;;Makes a new poly such that np(x)-np(x+2*%i*%pi)=p(x).
;;Constructs general POLY of degree one higher than P with
;;arbitrary coeff. and then solves for coeffs by equating like powers
;;of the varibale of integration.
;;Can probably be made simpler now.

(DEFUN MAKPOLY (P)
  (let ((n (deg p))  (ans ())  (varlist ())  (gp ())  (cl ())  (zz ()))
    (SETQ ANS (GENPOLY (M+ 1 N))) ;Make poly with gensyms of 1 higher deg.
    (setq cl (cdr ans)) ;Coefficient list
    (SETQ VARLIST (APPEND CL (LIST VAR))) ;Make VAR most important.
    (SETQ GP (CAR ANS)) ;This is the poly with gensym coeffs.
;;;Now, poly(x)-poly(x+2*%i*%pi)=p(x), P is the original poly.
    (SETQ ANS (m+ GP (SUBIN (m+t (m*t '$%i %pi2) VAR) (m- GP)) (m- P)))
    (NEWVAR ANS)
    (SETQ ANS (RATREP* ANS)) ;Rational rep with VAR leading.
    (SETQ ZZ (COEFSOLVE N CL (COND ((NOT (EQ (CAADR ANS) ;What is Lead Var.
					     (GENFIND (CAR ANS) VAR)))
				    (LIST 0 (CADR ANS)));No VAR in ans.
				   ((CDADR ANS)))));The real Poly.
    (if (or (null zz) (null gp)) 
      -1
      ($SUBSTITUTE ZZ GP))));Substitute Values for gensyms.

(DEFUN COEFSOLVE (N CL E)    
  (DO (($BREAKUP)
       (EQL (NCONS (PDIS (PTERM E N))) (CONS (PDIS (PTERM E M)) EQL))
       (M (m+ N -1) (m+ M -1)))
      ((SIGNP L M) (SOLVEX EQL CL NIL NIL))))

(DEFUN RECTZTO%PI2 (P PE D)
(PROG (DP N PL A B C denom-exponential)
(if (not (and (SETQ denom-exponential (*CATCH 'PIN%EX (PIN%EX D)))
	      (%e-integer-coeff pe)
	      (%e-integer-coeff d)))
  (return ()))
(SETQ N (m* (COND ((NULL P) -1.)
		  (T ($EXPAND (m*t '$%i %pi2 (MAKPOLY P)))))
	    PE))
  (let ((var 'z*)
	(leadcoef ()))
    (SETQ PL (CDR (POLELIST DENOM-EXPONENTIAL #'(LAMBDA (J) 
				    (OR (NOT (equal ($imagpart J) 0))
					(EQ ($askSIGN ($realpart J)) '$neg)))
			    #'(LAMBDA (J)
			        (NOT (EQ ($askSIGN ($realpart J)) '$zero)))))))
  (COND ((NULL PL)  (RETURN NIL))
	((OR (CADR PL)
	     (CADDR PL))  (SETQ DP (SDIFF D VAR))))
  (COND ((CADR PL)  (SETQ B (MAPCAR #'log-imag-0-2%pi (CADR PL)))
		    (SETQ B (RES1 N DP B))
		    (setq b (m+l b)))
	(t (setq b 0.)))
   (COND ((CADDR PL)
	  (let ((temp (MAPCAR #'log-imag-0-2%pi (CADDR PL))))
	    (setq c (append temp (mapcar #'(lambda (j) 
					     (m+ (m*t '$%i %pi2) j))
					 temp)))
	    (SETQ C (RES1 N DP C))
	    (setq c (m+l c))))
	 (t (setq c 0.)))
   (COND ((CAR PL)
	  (let ((poles (mapcar #'log-imag-0-2%pi (caar pl)))
		(exp (m// n (subst (m^t '$%e var) 'z* denom-exponential))))
	       (SETQ A (mapcar #'(lambda (j) 
				   ($RESIDUE exp var j))
			       poles))
	       (setq a (m+l a))))
	 (t (setq a 0.)))
   (RETURN (sRATSIMP (m+ a b (m* '((rat) 1. 2.) c))))))

(DEFUN GENPOLY (I)
  (do ((i i (m+ i -1))
       (c (gensym) (gensym))
       (cl ())
       (ans ()))
      ((zerop i)
       (cons (m+l ans) cl))
    (SETQ ANS (CONS (m* C (m^t VAR I)) ANS))
    (SETQ CL (CONS C CL))))

(DECLARE (SPECIAL *FAILFLAG *LHFLAG LHV *INDICATOR CNT *DISCONFLAG)) 

(defun %e-integer-coeff (exp)
  (cond ((mapatom exp) t)
	((and (mexptp exp)
	      (eq (cadr exp) '$%e)
	      (eq (ask-integer ($coeff (caddr exp) var) '$integer)
		  '$yes))  t)
	(t (andmapc '%e-integer-coeff (cdr exp)))))

(DEFUN WLINEARPOLY (E VAR)
       (COND ((AND (SETQ E (POLYINX E VAR T))
		   (EQUAL (DEG E) 1.))
	      (SUBIN 1. E)))) 

(DECLARE (SPECIAL E $EXPONENTIALIZE))

(DEFUN PIN%EX (EXP)
  (PIN%EX0 (COND ((NOTINVOLVE EXP '(%SINH %COSH %TANH)) EXP)
		 (T (SETQ EXP (let (($EXPONENTIALIZE t))
				($expand EXP)))))))

(DEFUN PIN%EX0 (E)
  (COND ((NOT (AMONG VAR E))  E)
	((ATOM E)  (*THROW 'PIN%EX NIL))
	((AND (mexptp E)
	      (EQ (CADR E)  '$%E))
	 (COND ((EQ (CADDR E) VAR)  'Z*)
	       ((let ((linterm (wlinearpoly (caddr e) var)))
		  (and linterm
		       (m* (subin 0 e) (m^t 'z* linterm)))))
	       (T (*THROW 'PIN%EX NIL))))
	((mtimesp E)  (m*l (MAPCAR #'PIN%EX0 (CDR E))))
	((mplusp E)  (m+l (MAPCAR #'PIN%EX0 (CDR E))))
	(T (*THROW 'PIN%EX NIL))))

(DECLARE (UNSPECIAL E $EXPONENTIALIZE)) 

(DEFUN P*PIN%EX (ND*)
       (SETQ ND* ($FACTOR ND*))
       (COND ((POLYINX ND* VAR NIL) (SETQ P* (CONS ND* P*)) T)
	     ((*CATCH 'PIN%EX (PIN%EX ND*)) (SETQ PE* (CONS ND* PE*)) T)
	     ((mtimesp ND*)
	      (andMAPCAR #'P*PIN%EX (CDR ND*)))))

(DEFUN FINDSUB (P)
       (COND ((FINDP P) NIL)
	     ((SETQ ND* (BX**N P)) 
	      (m^t VAR (CAR ND*)))
	     ((SETQ P (BX**N+A P))
	      (m* (CADDR P) (m^t VAR (CADR P)))))) 

(DEFUN FUNCLOGOR%E (E)
  (PROG (ANS ARG NVAR R) 
    (COND ((OR (RATP E VAR)
	       (INVOLVE E '(%SIN %COS %TAN))
	       (NOT (SETQ ARG (XOR (AND (SETQ ARG (INVOLVE E '(%LOG)))
					(SETQ R '%LOG))
				   (%EINVOLVE E)))))
	   (RETURN NIL)))
AG (SETQ NVAR (COND ((EQ R '%LOG) `((%LOG) ,ARG))
		    (T (m^t '$%E ARG))))
   (SETQ ANS (SUBSTITUTE (m^t 'YX -1.) (m^t NVAR -1.) (SUBSTITUTE 'YX nvar E)))
   (COND ((NOT (AMONG VAR ANS))  (RETURN (LIST (SUBST VAR 'YX ANS) NVAR)))
	 ((AND (NULL R) 
	       (SETQ ARG (FINDSUB ARG)))
	  (GO AG)))))

(DEFUN DINTBYPART (U V A B)
;;;SINCE ONLY CALLED FROM DINTLOG TO get RID OF LOGS - IF LOG REMAINS, QUIT
       (let ((ad (antideriv v)))
	    (COND ((or (NULL AD)
		       (INVOLVE AD '(%LOG)))
		   NIL)
		  (t (let ((P1 (m* U AD))
			   (P2 (m* AD (SDIFF U VAR))))
			  (let ((P1-part1 (get-LIMit P1 VAR B '$MINUS))
				(p1-part2 (get-LIMIT P1 VAR A '$PLUS)))
			       (cond ((or (null p1-part1)
					  (null p1-part2))
				      nil)
				     (t (let ((P2 (Let ((*DEF2* t))
						       (DEFINT P2 VAR A B))))
					     (COND (P2 (add* p1-part1 
							     (m- p1-part2)
							     (m- P2)))
						   (t nil)))))))))))

(DEFUN DINTEXP (EXP arg &aux ans)
  (let ((dintexp-recur t))    ;recursion stopper
    (COND ((and (sinintp exp var) ;To be moved higher in the code.
		(setq ans (antideriv exp))
		(setq ans (intsubs ans ll ul))))
	  ((setq ANS (FUNCLOGOR%E EXP))
	   (COND ((AND (EQUAL LL 0.) (EQ UL '$INF))
		  (SETQ EXP (SUBIN (m+t 1. arg) (CAR ANS)))
		  (SETQ ANS (m+t -1. (CADR ANS))))
		 (T (SETQ EXP (CAR ANS))
		    (SETQ ANS (CADR ANS))))
	     (INTCV ANS T NIL)))))

(DEFUN DINTLOG (EXP ARG)
(let ((dintlog-recur (1+ dintlog-recur))) ;recursion stopper
 (PROG (ANS D) 
       (COND ((AND (EQ UL '$INF)
		   (EQUAL LL 0.)
		   (EQ ARG VAR)
		   (EQUAL 1. ($RATSIMP (M// EXP (m* (m- (SUBIN (m^t VAR -1.)
							       EXP))
						    (m^t VAR -2.))))))
	      (RETURN 0.))
	     ((setq ans (antideriv exp))
	      (return (intsubs ans ll ul)))
	     ((SETQ ANS (LOGX1 EXP LL UL))
	      (RETURN ANS)))
       (SETQ ANS (M// EXP `((%LOG) ,ARG)))
       (COND ((INVOLVE ANS '(%LOG)) (RETURN NIL))
	     ((AND (EQ ARG VAR)
		   (EQUAL 0. (NO-ERR-SUB 0. ANS))
		   (SETQ D (let ((*DEF2* t))
				(DEFINT (m* ANS (m^t VAR '*Z*))
					VAR LL UL))))
	      (RETURN (DERIVAT '*Z* 1. D 0.)))
	     ((SETQ ANS (DINTBYPART `((%LOG) ,ARG) ANS LL UL))
	      (RETURN ANS))))))

(DEFUN DERIVAT (VAR N E PT) (SUBIN PT (APPLY '$DIFF (LIST E VAR N)))) 

;;;MAYBPC RETURNS (COEF EXPO CONST)
(DEFUN MAYBPC (E VAR)
       (COND (MTOINF* (*THROW 'GGRM (LINPOWER0 E VAR)))
	     ((AND (NOT MTOINF*)
		   (NULL (SETQ E (BX**N+A E))))	;bx**n+a --> (a b n) or nil.
	      NIL)				;with var being x.
	     ((AND (AMONG '$%I (CADDR E))
		   (ZEROP1 ($realpart (CADDR E)))
		   (SETQ ZN ($imagPART (CADDR E)))
		   (EQ ($askSIGN (CADR E)) '$pos))
	      (COND ((EQ ($askSIGN ZN) '$neg)
		     (SETQ VAR -1.)
		     (SETQ ZN (m- ZN)))
		    (T (SETQ VAR 1.)))
	      (SETQ ZD (m^t '$%E (M// (mul* VAR '$%I '$%PI (m+t 1. ND*))
				      (m*t 2. (CADR E)))))
	      `(,ZN ,(CADR E) ,(CAR E)))
	     ((AND (OR (EQ (SETQ VAR ($askSIGN ($realPART (CADDR E)))) '$neg)
		       (EQUAL VAR '$zero))
		   (equal ($imagpart (CADR E)) 0)
		   (RATGREATERP (CADR E) 0.))
	      `(,(m- (CADDR E)) ,(CADR E) ,(CAR E)))))

(DEFUN GGR (E IND)
 (PROG (C ZD ZN NN* DN* ND* DOSIMP $%EMODE) 
   (SETQ ND* 0.)
   (COND (IND (SETQ E ($EXPAND E))
	      (COND ((AND (mplusp E)
			  (let ((*NODIVERG t))
			       (SETQ E (*CATCH 'Divergent
					       (ANDMAPCAR
						#'(LAMBDA (J) 
						    (GGR J NIL))
						(CDR E))))))
		     (COND ((EQ E 'Divergent) NIL)
			   (T (RETURN (sRATSIMP (CONS '(MPLUS) E)))))))))
   (SETQ E (RMCONST1 E))
   (SETQ C (CAR E))
   (SETQ E (CDR E))
   (COND ((SETQ E (GGR1 E VAR))
	  (SETQ E (APPLY 'GAMMA1 E))
	  (COND (ZD (SETQ $%EMODE T)
		    (SETQ DOSIMP T)
		    (SETQ E (m* ZD E))))))
   (COND (E (RETURN (m* C E))))))



(DEFUN GGR1 (E VAR) 
       (COND ((ATOM E) NIL)
	     ((AND (mexptp E)
		   (EQ (CADR E) '$%E))
	      (COND ((SETQ E (MAYBPC (CADDR E) VAR)) (CONS 0. E))))
	     ((AND (mtimesp E)
		   (NULL (CDDDR E))
		   (OR (AND (SETQ DN* (XTORTERM (CADR E) VAR))
			    (RATGREATERP (SETQ ND* ($realPART DN*))
					 -1.)
			    (SETQ NN* (GGR1 (CADDR E) VAR)))
		       (AND (SETQ DN* (XTORTERM (CADDR E) VAR))
			    (RATGREATERP (SETQ ND* ($realPART DN*))
					 -1.)
			    (SETQ NN* (GGR1 (CADR E) VAR)))))
	      (RPLACA NN* DN*))))


(DEFUN BX**N+A (E)
;;; returns list of (a b n) or nil.
       (COND ((EQ E VAR) 
	      (LIST 0. 1. 1.))
	     ((OR (ATOM E) 
		  (MNUMP E)) ())
	     (t (let ((a (NO-ERR-SUB 0. E)))
		     (cond ((null a)  ())
			   (t (SETQ E (m+ E (m*t -1. A)))
			      (COND ((SETQ E (BX**N E))
				     (CONS A E))
				    (t ()))))))))

(DEFUN BX**N (E)
;;;returns a list (n e) or nil.
       (let ((N ()))
	    (AND (SETQ N (XEXPONGET E VAR))
		 (NOT (AMONG VAR
			     (SETQ E (let (($maxposex 1)
					   ($maxnegex 1))
				       ($EXPAND (M// E (m^t VAR N)))))))
		 (LIST N E))))

(DEFUN XEXPONGET (E NN*)
       (COND ((ATOM E) (COND ((EQ E VAR) 1.)))
	     ((MNUMP E) NIL)
	     ((AND (mexptp E)
		   (EQ (CADR E) NN*)
		   (NOT (AMONG NN* (CADDR E))))
	      (CADDR E))
	     (T (ORMAPC #'(LAMBDA (J)
			    (XEXPONGET J NN*))
			(CDR E)))))


;;; given (b*x^n+a)^m returns (m a n b)
(DEFUN BXM (E IND)
(let (m r)
  (COND ((OR (ATOM E)
	     (MNUMP E)
	     (INVOLVE E '(%LOG %SIN %COS %TAN))
	     (%EINVOLVE E))  NIL)
	((mtimesp E)  NIL)
	((mexptp E)  (COND ((AMONG VAR (CADDR E))  NIL)
			   ((SETQ R (BX**N+A (CADR E))) 
			    (CONS (caddr e) R))))
	((SETQ R (BX**N+A E))  (CONS 1. R))
	((not (null IND))
;;;Catches Unfactored forms.
	 (SETQ M (M// (SDIFF E VAR) E))
	 (NUMDEN M)
	 (SETQ M NN*)
	 (setq r dn*)
	 (COND 
	  ((AND (SETQ R (BX**N+A ($ratsimp r)))
		(NOT (AMONG VAR (SETQ M (M// M (m* (CADR R) (CADDR R)
						   (m^t VAR (m+t -1.
								(CADR R))))))))
		(SETQ E (M// (SUBIN 0. E) (m^t (CAR R) M))))
	   (COND ((equal E 1.)
		  (CONS M R))
		 (T (SETQ E (m^ E (M// 1. M)))
		    (LIST M (m* E (CAR R)) (CADR R) 
			  (m* E (CADDR R))))))))
	(t ()))))

;;;Is E = VAR raised to some power? If so return power or 0.
(DEFUN FINDP (E) 
       (COND ((NOT (AMONG VAR E)) 0.)
	     (T (XTORTERM E VAR))))

(DEFUN XTORTERM (E VAR1)
;;;Is E = VAR1 raised to some power? If so return power.
       (COND ((ALIKE1 E VAR1) 1.)
	     ((ATOM E) NIL)
	     ((AND (mexptp E)
		   (ALIKE1 (CADR E) VAR1)
		   (NOT (AMONG VAR (CADDR E))))
	      (CADDR E)))) 

(DEFUN TBF (L)
       (m^ (m* (m^ (CADDR L) '((RAT) 1. 2.))
	       (m+ (CADR L) (m^ (m* (CAR L) (CADDR L))
				'((RAT) 1. 2.))))
	   -1.))

(defun radbyterm (d l)
  (do ((l l (cdr l))
       (ans ()))
      ((null l)
       (m+l ans))
    (let (((const . integrand) (rmconst1 (car l))))
	 (setq ans (cons (m* const (dintrad0 integrand d))
			 ans)))))

(DEFUN SQDTC (E IND)
       (PROG (A B C VARLIST) 
	     (SETQ VARLIST (LIST VAR))
	     (NEWVAR E)
	     (SETQ E (CDADR (RATREP* E)))
	     (SETQ C (PDIS (PTERM E 0.)))
	     (SETQ B (m*t (m//t 1. 2.) (PDIS (PTERM E 1.))))
	     (SETQ A (PDIS (PTERM E 2.)))
	     (COND ((AND (EQ ($askSIGN (m+ B (m^ (m* A C)
						 '((RAT) 1. 2.))))
			     '$pos)
			 (OR (AND IND
				  (NOT (EQ ($askSIGN A) '$neg))
				  (EQ ($askSIGN C) '$pos))
			     (AND (EQ ($askSIGN A) '$pos)
				  (NOT (EQ ($askSIGN C) '$neg)))))
		    (RETURN (LIST A B C)))))) 

(DEFUN DIFAP1 (E PWR VAR M PT)
       (M// (mul* (COND ((eq (ask-integer M '$even) '$yes)
			  1.)
			 (T -1.))
		   `((%GAMMA) ,PWR)
		   (DERIVAT VAR M E PT))
	     `((%GAMMA) ,(m+ PWR M)))) 

(DEFUN SQRTINVOLVE (E)
       (COND ((ATOM E) NIL)
	     ((MNUMP E) NIL)
	     ((AND (mexptp E) 
		   (AND (MNUMP (CADDR E))
			(NOT (NUMBERP (CADDR E)))
			(EQUAL (CADDR (CADDR E)) 2.))
		   (AMONG VAR (CADR E)))
	      (CADR E))
	     (T (ORMAPC #'SQRTINVOLVE (CDR E))))) 

(DEFUN BYDIF (R S D)
       (let ((B 1)  p)
	    (SETQ D (m+ (m*t '*Z* VAR) D))
	    (COND ((OR (ZEROP1 (SETQ P (m+ S (m*t -1. R))))
		       (AND (ZEROP1 (m+ 1. P))
			    (SETQ B VAR)))
		   (DIFAP1 (DINTRAD0 B (m^ D '((RAT) 3. 2.)))
				    '((RAT) 3. 2.) '*Z* R 0.))
		   ((EQ ($askSIGN P) '$pos)
		    (DIFAP1 (DIFAP1 (DINTRAD0 1. (m^ (m+t 'Z** D)
						     '((RAT) 3. 2.)))
				    '((RAT) 3. 2.) '*Z* R 0.)
			    '((RAT) 3. 2.) 'Z** P 0.)))))

(DEFUN DINTRAD0 (N D)
       (let (L R S) 
	 (COND ((AND (mexptp D) 
		     (EQUAL (DEG (CADR D)) 2.))
		(COND ((ALIKE1 (CADDR D) '((RAT) 3. 2.))
		       (COND ((AND (EQUAL N 1.)
				   (SETQ L (SQDTC (CADR D) T)))
			      (TBF L))
			     ((AND (EQ N VAR)
				   (SETQ L (SQDTC (CADR D) NIL)))
			      (TBF (REVERSE L)))))
		      ((AND (SETQ R (FINDP N))
			    (OR (EQ ($askSIGN (m+ -1. (m-  R) (m*t 2.
								   (CADDR D))))
				    '$pos)
				(Diverg))
			    (SETQ S (m+ '((RAT) -3. 2.) (CADDR D)))
			    (EQ ($askSIGN S) '$pos)
			    (eq (ask-integer S '$integer) '$yes))
		       (BYDIF R S (CADR D)))
		      ((POLYINX N VAR NIL)
		       (RADBYTERM D (CDR N))))))))


;;;Looks at the IMAGINARY part of a log and puts it in the interval 0 2*%pi.
(defun log-imag-0-2%pi (x)
  (let ((plog (simplify `((%plog) ,x))))
    (cond ((not (free plog '%plog))
	   (subst '%log '%plog plog))
	  (t (let (((real . imag) (trisplit plog)))
	       (cond ((eq ($asksign imag) '$neg)
		      (setq imag (m+ imag %pi2)))
		     ((eq ($asksign (m- imag %pi2)) '$pos)
		      (setq imag (m- imag %pi2)))
		     (t t))
	       (m+ real (m* '$%i imag)))))))

	    
;;; Temporary fix for a lacking in taylor, which loses with %i in denom.
;;; Besides doesn't seem like a bad thing to do in general.
(defun %i-out-of-denom (exp)
       (let ((denom ($denom exp))
	     (den-conj nil))
	    (cond ((among '$%i denom)
		   (setq den-conj (substitute (m- '$%i) '$%i denom))
		   (setq exp (m* den-conj ($ratsimp (m// exp den-conj))))
		   (setq exp (simplify ($multthru  (sratsimp exp)))))
		  (t exp))))

;;; LL and UL must be real otherwise this routine return $UNKNOWN.
;;; Returns $no $unknown or a list of poles in the interval (ll ul)
;;; for exp w.r.t. var.
;;; Form of list ((pole . multiplicity) (pole1 . multiplicity) ....)
(defun poles-in-interval (exp var ll ul)
 (let* ((denom (cond ((mplusp exp)
		      ($denom (sratsimp exp)))
		     ((and (mexptp exp)
			   (free (caddr exp) var)
			   (eq ($asksign (caddr exp)) '$neg))
		      (m^ (cadr exp) (m- (caddr exp))))
		     (t ($denom exp))))
	(roots (real-roots denom var))
	(ll-pole (limit-pole exp var ll '$plus))
	(ul-pole (limit-pole exp var ul '$minus)))
       (cond ((or (eq roots '$failure)
		  (null ll-pole)
		  (null ul-pole))   '$unknown)
	     ((and (eq roots '$no)
		   (eq ll-pole '$no)
		   (eq ul-pole '$no))  '$no)
	     (t (cond ((equal roots '$no)
		       (setq roots ())))
		(do ((dummy roots (cdr dummy))
		     (pole-list (cond ((not (eq ll-pole '$no))
				       `((,ll . 1)))
				      (t nil))))
		    ((null dummy)
		     (cond ((not (eq ul-pole '$no))
			    (sort-poles (push `(,ul . 1) pole-list)))
			   ((not (null pole-list))
			    (sort-poles pole-list))
			   (t '$no)))
		    (let* ((soltn (caar dummy))
			   ;; (multiplicity (cdar dummy)) (not used? -- cwh)
			   (root-in-ll-ul (in-interval soltn ll ul)))
			  (cond ((eq root-in-ll-ul '$no) '$no)
				((eq root-in-ll-ul '$yes)
				 (let ((lim-ans (is-a-pole exp soltn)))
				      (cond ((null lim-ans)
					     (return '$unknown))
					    ((equal lim-ans 0)
					     '$no)
					    (t (push (car dummy)
						     pole-list))))))))))))


;;;Returns $YES if there is no pole and $NO if there is one.
(defun limit-pole (exp var limit direction)
  (let ((ans (cond ((memq limit '($minf $inf))
		    (cond ((eq (special-convergent-formp exp limit) '$yes)
			   '$no)
			  (t (get-limit (m* exp var) var limit direction))))
		   (t '$no))))
       (cond ((eq ans '$no)   '$no)
		  ((null ans)   nil)
		  ((equal ans 0.)   '$no)
		  (t '$yes))))

;;;Takes care of forms that the ratio test fails on.
(defun special-convergent-formp (exp limit)
  (cond ((not (oscip exp))  '$no)
	((or (eq (sc-converg-form exp limit) '$yes)
	     (eq (exp-converg-form exp limit) '$yes))
	 '$yes)
	(t  '$no)))

(defun exp-converg-form (exp limit)
  (let (exparg)
    (setq exparg (%einvolve exp))
    (cond ((or (null exparg)
	       (freeof '$%i exparg))
	   '$no)
	  (t (cond
	      ((and (freeof '$%i 
			    (%einvolve 
			     (setq exp 
				   (sratsimp (m// exp (m^t '$%e exparg))))))
		    (equal (get-limit exp var limit)  0))
	        '$yes)
	      (t '$no))))))

(defun sc-converg-form (exp limit)       
 (prog (scarg trigpow)
  (setq exp ($expand exp))
  (setq scarg (involve (sin-sq-cos-sq-sub exp) '(%sin %cos)))
  (cond ((null scarg) (return '$no))
	((and (polyinx scarg var ())
	      (eq ($asksign (m- ($hipow scarg var) 1)) '$pos)) (return '$yes))
	((not (freeof var (sdiff scarg var)))
	 (return '$no))
	((and (setq trigpow ($hipow exp `((%sin) ,scarg)))
	      (eq (ask-integer trigpow '$odd) '$yes)
	      (equal (get-limit (m// exp `((%sin) ,scarg)) var limit)
		     0))
	 (return '$yes))
	((and (setq trigpow ($hipow exp `((%cos) ,scarg)))
	      (eq (ask-integer trigpow '$odd) '$yes)
	      (equal (get-limit (m// exp `((%cos) ,scarg)) var limit)
		     0))
	 (return '$yes))
	(t (return '$no)))))

(defun is-a-pole (exp soltn)
       (get-limit ($radcan 
		   (m* (substitute (m+ 'epsilon soltn) var exp)
			 'epsilon))
		  'epsilon 0 '$plus))


(defun in-interval (place ll ul)
;;;Real values for ll and ul. place can be imaginary.
       (let ((order (ask-greateq ul ll)))
	    (cond ((eq order '$yes))
		  ((eq order '$no)
		   (let ((temp ul))
			(setq ul ll)
			(setq ll temp)))
		  (t 
		     (merror "DEFINT: Internal ERROR, Please report this.")
		     
		     )))
       (cond ((not (equal ($imagpart place)
			  0))
	      '$no)
	     (t (let ((lesseq-ul (ask-greateq ul place))
		      (greateq-ll (ask-greateq place ll)))
		     (cond ((and (eq lesseq-ul '$yes)
				 (eq greateq-ll '$yes))
			    '$yes)
			   (t '$no))))))

(defun real-roots (exp var)
  (let (($solvetrigwarn (cond (defintdebug t) ;Rest of the code for
			      (t ())))           ;TRIGS in denom needed.
	($solveradcan (cond ((or (among '$%i exp)
				 (among '$%e exp)) t)
			    (t nil)))
	*roots *failures) ;special vars for solve.
       (cond ((not (among var exp))   '$no)
	     (t (solve exp var 1)
		(cond (*failures '$failure)
		      (t (do ((dummy *roots (cddr dummy))
			      (rootlist))
			     ((null dummy)
			      (cond ((not (null rootlist))
				     rootlist)
				    (t '$no)))
			   (cond ((equal ($imagpart (caddar dummy)) 0)
				  (setq rootlist 
					(cons (cons 
					       ($rectform (caddar dummy))
					       (cadr dummy))
					      rootlist)))))))))))

(defun ask-greateq (x y)
;;; Is x > y. X or Y can be $MINF or $INF, zeroA or zeroB.
       (let ((x (cond ((among 'zeroa x)
		       (subst 0 'zeroa x))
		      ((among 'zerob x)
		       (subst 0 'zerob x))
		      ((among 'epsilon x)
		       (subst 0 'epsilon x))
		      ((or (among '$inf x)
			   (among '$minf x))
		       ($limit x))
		      (t x)))
	     (y (cond ((among 'zeroa y)
		       (subst 0 'zeroa y))
		      ((among 'zerob y)
		       (subst 0 'zerob y))
		      ((among 'epsilon y)
		       (subst 0 'epsilon y))
		      ((or (among '$inf y)
			   (among '$minf y))
		       ($limit y))
		      (t y))))
	    (cond ((eq x '$inf)
		   '$yes)
		  ((eq x '$minf)
		   '$no)
		  ((eq y '$inf)
		   '$no)
		  ((eq y '$minf)
		   '$yes)
		  (t (let ((ans ($asksign (m+ x (m- y)))))
			  (cond ((memq ans '($zero $pos))
				 '$yes)
				((eq ans '$neg)
				 '$no)
				(t '$unknown)))))))

(defun sort-poles (pole-list)
       (sort pole-list '(lambda (x y)
				(cond ((eq (ask-greateq (car x) (car y))
					   '$yes)
				       nil)
				      (t t)))))

(declare (unspecial exp factors ll ll1 ul ul1 var zn zd
		    dn* ind* nn* nd* p* pe* pl* rl* pl*1 rl*1 sd* sn*))
