;;;  LSETS    				-*-Mode:Lisp;Package:SI;Lowercase:T-*-
;;;  *************************************************************************
;;;  ***** NIL/MACLISP ****** SET Operations on Lists ************************
;;;  *************************************************************************
;;;  ** (c) Copyright 1981 Massachusetts Institute of Technology *************
;;;  *************************************************************************


(herald LSETS /7)

;;; Utility operations on sets: 
;;;    ADJOIN, UNION, INTERSECTION, SETDIFF, SETREMQ
;;; Where possible, preserve the ordering of elements.


#-NIL (include ((lisp) subload lsp))

#-NIL 
(eval-when (eval compile)
  (subload SHARPCONDITIONALS)
  (subload LOOP)
  (subload UMLMAC)
  )

#+(or LISPM (and NIL (not MacLISP)))
(progn (globalize "ADJOIN")
       (globalize "SETDIFF")
       (globalize "UNION")
       (globalize "INTERSECTION")
       (globalize "SETREMQ")
       )



(defun ADJOIN (x s) 
   "Add an element X to a set S."
   (if (memq x s)
       s
       (cons x s)))

(defun SI:Y-X+Z (y x z &aux y-x)
    "Append the set-difference Y-X to Z"
   (mapc #'(lambda (xx) (or (memq xx x) (push xx y-x))) y)
   (nreconc y-x z))

(defun SETDIFF (x y)  
    "Set difference: all in X but not in Y."
   (if (LOOP FOR xx IN y THEREIS (memq xx x))
       (SI:Y-X+Z x y () )
       x))

(defun UNION (x y)
    "Union of two sets."
   (if (< (length x) (length y))	  ;Interchange X and Y if that will
       (psetq x y y x))			  ;  lead to less CONSing
   (si:y-x+z y x x))


(defun INTERSECTION (x y)  
    "Intersection of two sets."
  (LOOP FOR xx IN x 
	WHEN (memq xx y) COLLECT xx))
 
(defun SETREMQ (x s)
    "Remove an element X from a set S, non-destructively."
   (when (LOOP UNTIL (null s) 
	       WHEN (eq x (car s)) DO (return 'T)
	       DO (pop s))
	   ;;Strip off any leading losers;  Fall thru to return () if  
	   ;;  whole list is "leading losers"
	 (if (not (memq x s))
	     s 
	      ;; If there are 'interior' losers, the copy remainder of list
	      ;;  but omitting elements EQ to the element X.
	     (LOOP FOR y IN s 
		   UNLESS (eq y x) COLLECT y))))

