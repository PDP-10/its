;; -*- Mode: Lisp; Package: Macsyma; Ibase: 8 -*-

(macsyma-module edexp)

;; Macsyma display-oriented expression editor
;; Expression Manipulation functions
;; See EMAXIM;ED > and EMAXIM;EDCOM > for more information.
;; Written:	Feb 17, 1979 By RZ, based on a version by CWH and BEE
;; Rewritten:   June 2, 1979 by CWH for Macsyma Users' Conference

;; Global variables and structure definitions.

(load-macsyma-macros edmac)

;; Expression manipulation primitives

(defun region-as-mexp (exp)
       (if (= (region-length exp) 1)
	   (cadr (region exp))
	   (cons (list (operator exp))
		 (firstn (region-length exp) (cdr (region exp))))))

;  Modify the current level of the expression so that the region is boxed.
;  Needed for dimensioning and displaying the current expression.
(defun box-region (exp)
       (rplacd (region exp)
	       (cons ($box (region-as-mexp exp))
		     (nthcdr (1+ (region-length exp)) (region exp)))))

;  Undo the effects of the above.
(defun unbox-region (exp)
       (let ((boxed-exp (cadr (cadr (region exp)))))
	    (cond ((= 1 (region-length exp))
		   (rplaca (cdr (region exp)) boxed-exp))
		  (t (rplacd (last boxed-exp) (cddr (region exp)))
		     (rplacd (region exp) (cdr boxed-exp))))))

;  Note:  Save pdl format has been changed.  For CDR transitions, it is
;  (CDR . <previous region>).  For CAR transitions, it is
;  (CAR <previous region> . <previous operand>).

(defun pop-save-pdl ()
  (if (null (save-pdl current-exp))
      (ed-internal-error 'pop-save-pdl "Attempt to pop save pdl when empty.")
      (let ((top-of-pdl (pop (save-pdl current-exp))))
	   (caseq (car top-of-pdl)
		  (CDR (setf (region current-exp) (cdr top-of-pdl)))
		  (CAR (setf (region current-exp) (cadr top-of-pdl))
		       (setf (operand current-exp) (cddr top-of-pdl))
		       (setf (operator current-exp) (caar (cddr top-of-pdl))))
		  (t (ed-internal-error 'pop-save-pdl "Garbage on save pdl" top-of-pdl))))))


;; Movement commands -- modifying the expression region.

;; Later, check iteration count and do the first two checks only
;; the first time around.  Make empty expression-list check be option
;; to defcom?

(set-key 'forward-branch '("C-f" |/|))
(defcom forward-branch ()
"Move the region forward a single branch at this level.
The width of the region does not change.  If the region
contains the last branch of this level, no action is taken."

    (if (null (expression-list current-buffer))
	(ed-error "Current Buffer is empty."))
    (if (region-contains-top-node?)
	(ed-error "Region contains the entire expression."))
    (if (region-contains-last-branch?)
	(ed-error "Region contains the last branch of this level."))
    (push `(CDR . ,(region current-exp))
	  (save-pdl current-exp))
    (pop (region current-exp)))

(set-key 'backward-branch '("C-b" |/|))
(defcom backward-branch ()
"Move the region backward a single branch at this level.
The width of the region does not change.  If the region
contains the first branch of this level, no action is taken."

    (if (null (expression-list current-buffer))
	(ed-error "Current Buffer is empty."))
    (if (region-contains-top-node?)
	(ed-error "Region contains the entire expression."))
    (if (region-contains-first-branch?)
	(ed-error "Region contains the first branch of this level."))
    (pop-save-pdl))

(set-key 'previous-level '("C-p" |/|))
(defcom previous-level ()
"Move the region up to the previous level.
The width of the region becomes a single branch.  If the region already
is at the top level of the current expression, no action is taken."

    (if (null (expression-list current-buffer))
	(ed-error "Current Buffer is empty."))
    (if (region-contains-top-node?)
	(ed-error "Region contains the entire expression."))
    (do ()
	((eq (caar (save-pdl current-exp)) 'CAR))
	(pop-save-pdl))
    (pop-save-pdl)
    (setf (region-length current-exp) 1))

(set-key 'next-level '("C-n" |/|))
(defcom next-level ()
"Move the region down to the next level.
The region becomes a single branch wide.  If the region
is at a terminal node of the current expression, i.e. contains
a single symbol, no action is taken."

    (if (null (expression-list current-buffer))
	(ed-error "Current Buffer is empty."))
    (if (region-contains-terminal-node?)
	(ed-error "Region contains a terminal branch."))
    (push `(CAR ,(region current-exp) . ,(operand current-exp))
	  (save-pdl current-exp))
    (setf (region current-exp) (cadr (region current-exp)))
    (setf (operand current-exp) (region current-exp))
    (setf (operator current-exp) (caar (operand current-exp)))
    (setf (region-length current-exp) 1)
    )

(set-key 'top-level '("<" |/|))
(defcom top-level ((discard-argument))
"Move the region up to the top level.
The region becomes a single branch wide, and contains the entire expession."

    (if (null (expression-list current-buffer))
	(ed-error "Current Buffer is empty."))
    (if (region-contains-top-node?)
	(ed-error "Region contains the entire expression."))
    (do ()
	((region-contains-top-node?))
	(previous-level)))

(set-key 'grow-region "M-f")
(defcom grow-region ()
"Increase the width of the region by one.
Extend the region forward to include the next branch at this level.  If the
region would then include the entire expression, then the region is moved up
a level.  If the region already contains the entire expression, no action is
taken."

    (if (null (expression-list current-buffer))
	(ed-error "Current Buffer is empty."))
    (if (region-contains-top-node?)
	(ed-error "Region contains the entire expression."))
    ;;Wrong kind of operator.
    (if (not (memq (operator current-exp) '(MPLUS MTIMES MNCTIMES MLIST)))
	(ed-error "Cannot grow the region at this node."))
    ;;Region at far right end of the expression, but doesn't contain
    ;;the first branch.
    (if (region-contains-last-branch?)
	(ed-error "Region contains the last branch of this level."))
    (cond
     ;;Extension would make region include every branch at this level,
     ;;so move up a level.
     ((= (length (cdr (operand current-exp)))
	 (1+ (region-length current-exp)))
      (previous-level))
     (t (setf (region-length current-exp)
	      (1+ (region-length current-exp))))))

(set-key 'shrink-region "M-b")
(defcom shrink-region ()
"Decrease the size of the region by one.
Shrink the region to contain one less branch at this level.  If the width of
the region is one, and the branch it contains is not terminal, then the
region is moved down a level and then extended to include all but the last
branch."

    (if (null (expression-list current-buffer))
	(ed-error "Current Buffer is empty."))
    (cond ((= (region-length current-exp) 1)
	   ;;Region includes an entire node.  Step down and extend to include
	   ;;all but last branch.
	   (cond ((region-contains-terminal-node?)
		  (ed-error "Region contains a terminal node."))
		 ((not (memq (caar (cadr (region current-exp)))
			     '(MPLUS MTIMES MNCTIMES MLIST)))
		  (ed-error "Cannot shrink the region at this node."))
		 (t (next-level)
		    (setf (region-length current-exp)
			  (length (cddr (operand current-exp)))))))
	  (t (setf (region-length current-exp) (1- (region-length current-exp))))))

(set-key 'first-branch "C-a")
(defcom first-branch ((discard-argument))
"Move the region to the first branch at this level.
The width of the region stays the same.  If the region contains the entire
expression, no action is taken."

    (if (null (expression-list current-buffer))
	(ed-error "Current Buffer is empty."))
    (if (region-contains-top-node?)
	(ed-error "Region contains the entire expression."))
    (if (region-contains-first-branch?)
	(ed-error "Region contains the first branch of this level."))
    (do ()
	((region-contains-first-branch?))
	(backward-branch)))

(set-key 'last-branch "C-e")
(defcom last-branch ((discard-argument))
"Move the region to the last branch at this level.
The width of the region stays the same.  If the region contains the entire
expression, no action is taken."

    (if (null (expression-list current-buffer))
	(ed-error "Current Buffer is empty."))
    (if (region-contains-top-node?)
	(ed-error "Region contains the entire expression."))
    (if (region-contains-last-branch?)
	(ed-error "Region contains the last branch of this level."))
    (do ()
	((region-contains-last-branch?))
	(forward-branch)))


;; Expression modification -- deleting portions of expressions

(set-key 'delete-region "C-d")
(defcom delete-region ()
"Delete the subexpression contained in the region from this level.
If the region contains the entire expression, then the expression
itself is removed from the buffer.  If the region contains all but one
term of a sum or product, then the region is replaced with that term
alone."

    (if (null (expression-list current-buffer))
	(ed-error "Current Buffer is empty."))
    (cond
     ;;The region is the same as the body of the expression, so delete
     ;;the entire expression.
     ((region-contains-top-node?) (delete-expression))
     (t (cond ((equal (region-length current-exp) 1)
	       (push (cadr (region current-exp)) kill-pdl))
	      (t (push (cons (list (operator current-exp)
				   'spread
				   (region-length current-exp))
			     (firstn (region-length current-exp)
				     (cdr (region current-exp))))
		       kill-pdl)))
	(rplacd (region current-exp)
		(nthcdr (region-length current-exp) (cdr (region current-exp))))
	(setf (region-length current-exp) 1)

	;;Normally, when a branch is deleted, the region is moved to
	;;the following branch and its width is made 1.
	;;If we delete all branches to the end
	;;of this level, then move the region to the previous branch.
	(if (null (cdr (region current-exp)))
	    (pop-save-pdl))
	;;If there were only two branches at this level when we started,
	;;then we now have an operator applied to one term.
	;;If the operator applied to one expression is the expression
	;;itself, or not meaningful with a single operand, (such as
	;;MQUOTIENT), then just leave the expression.  Use "replace-region"
	;;rather than rplaca so that (A + B) + C --> A + B + C merging happens
	;;correctly and so that assignment of the label takes place if
	;;the region is the top node in the structure.
	(cond ((and (region-contains-entire-level?)
		    (memq (operator current-exp)
			  '(MPLUS MTIMES MNCTIMES MEXPT MNCEXPT MQUOTIENT MEQUAL)))
	       (previous-level)
	       (replace-region t (cadr (cadr (region current-exp)))))))))

;  This command isn't too winning.
;  Also, redisplay can't handle it since it doesn't modify the region.

;  (set-key 'rubout-expression "RUBOUT")
;  (defcom rubout-expression ()
;  "Delete the branch just before the region from this level."
;      (if (region-contains-top-node?)
;  	(ed-error "Region contains the entire expression."))
;      (if (region-contains-first-branch?)
;  	(ed-error "Region contains the first branch of this level."))
;      (if (not (memq (operator current-exp)
;  		   '(MPLUS MTIMES MNCTIMES MLIST)))
;  	(ed-error "Cannot delete a branch at this level."))
;      (let ((save-region-length (region-length current-exp)))
;  	 (setf (region-length current-exp) 1)
;  	 (backward-branch)
;  	 (delete-region)
;  	 (setf (region-length current-exp) save-region-length)))

;  Rewrite this in terms of delete-region and movement functions.

(set-key 'kill-following-branches "C-k")
(defcom kill-following-branches ((argument n))
"Delete the branches following the last branch in the region.
Those branches at the current level following the last branch contained in the
region are deleted from the level.  With a negative argument, those branches
preceding the first branch contained in the region are deleted from the level.
If the region is at the top level of the current expression or at the far right
or left end of the current level respectively, no action is taken."

    (if (null (expression-list current-buffer))
	(ed-error "Current Buffer is empty."))
    (if (region-contains-top-node?)
	(ed-error "Region contains the entire expression."))
    (if (not (memq (operator current-exp) '(MPLUS MTIMES MNCTIMES MLIST)))
	(ed-error "Cannot delete branches at this level."))
    (if (not n) (setq n 1))
    (cond ((= n 0))
	  (t (cond ((> n 0)
		    (if (region-contains-last-branch?)
			(ed-error "Region contains the last branch at this level."))
		    ;;Splice out stuff from region to end of level.
		    (rplacd (nthcdr (region-length current-exp)
				    (region current-exp)) nil))
		   ((< n 0)
		    (if (region-contains-first-branch?)
			(ed-error "Region contains the first branch at this level."))
		    ;;Splice out stuff between operator and region.
		    (rplacd (operand current-exp) (cdr (region current-exp)))
		    ;;Move region to far left edge of level.
		    (do ()
			((region-contains-first-branch?))
		      (pop-save-pdl))))
	     ;;If the region is the only thing that's left, move up one level.
	     (cond ((region-contains-entire-level?)
		    (previous-level)
		    ;;If there's only one term left at the old level, pull it
		    ;;up a level.
		    (if (null (cddr (cadr (region current-exp))))
			(replace-region t (cadr (cadr (region current-exp))))))))))

;  Another way of writing this.  Nearly independent of representation.
;  (defun kill-following-branches ()
;      (let ((save-region-length (region-length current-exp)))
;        (dotimes (i (1- save-region-length)) (shrink-region))
;        (dotimes (i save-region-length) (forward-branch))
;        (do ()
;  	  ((region-contains-last-branch?))
;  	(grow-region))
;        (delete-region)
;        (dotimes (i (1- save-region-length)) (backward-branch))
;        (dotimes (i (1- save-region-length)) (grow-region))))

;  And yet another.  But far less efficient.
;  (defun kill-preceding-branches ()
;      (let ((save-region-length (region-length current-exp)))
;        (dotimes (i (1- save-region-length)) (shrink-region))
;        (backward-branch)
;        (do ()
;  	  ((region-contains-first-branch?))
;  	(backward-branch)
;  	(grow-region))
;        (delete-region)
;        (dotimes (i (1- save-region-length)) (grow-region))))


;; Modifying expressions -- Inserting and replacing expressions

;; If you're ever clobbering anything into the region, you should
;; be calling this function.

(set-key 'replace-region "C-r")
(defcom replace-region ((argument n)
			(read-expression exp
					 "Replace region: ~A"
					 (if n "(no evaluation) " "")))
"Replace the region with an expression read from the minibuffer.
If a numeric argument is given, don't evaluate the entered expression."

    (if (null (expression-list current-buffer))
	(ed-error "Current Buffer is empty."))
    ;; Should we be rebinding % instead?  Of course.  We would
    ;; have to simplify the region before binding, though.
    (setq exp (subst (region-as-mexp current-exp) '$% exp))
    (if (null n) (setq exp (meval exp)))
    ;; Operator must be associative to merge levels.  Structural
    ;; simplification being made here.  (A + (B + C) + D) --> (A + B + C + D)
    ;; Maybe we should always be simplifying the body, i.e. letting the
    ;; simplifier do this.  (Redundant knowledge)
    (cond ((and (memq (operator current-exp) '(MPLUS MTIMES MNCTIMES))
		(not (atom exp))
		(eq (caar exp) (operator current-exp)))
	   ;; The region will soon contain this new expression
	   ;; so its length should be the same as that of the
	   ;; expression.
	   (let ((new-region-length (length (cdr exp))))
		(rplacd (last exp)
			(nthcdr (1+ (region-length current-exp))
				(region current-exp)))
		(rplacd (region current-exp) (cdr exp))
		(setf (region-length current-exp) new-region-length)))
	  (t (rplacd (region current-exp)
		     (cons (nformat-all exp)
			   (nthcdr (1+ (region-length current-exp))
				   (region current-exp))))
	     (setf (region-length current-exp) 1)))
    ;; Make sure the expression label is bound to the expression
    ;; body.  Not necessary if inner part of expression clobbered.
    (if (eq (body current-exp) (region current-exp))
	(mset (expression-label current-exp) (cadr (body current-exp)))))

;; (defcom replace-region-operator ((discard-argument)
;; 				 (read-line function-name "Replace function: "))
;; "Replace the region operator."
;;    (cond ((null operator)
;; 	  (ed-error))
;; 	 ((let ((temp (cvt-name function-name)))
;; 	       (setq operator temp)
;; 	       (rplaca operand (list temp))))))

;; (defun cvt-name (nm)
;;        (setq nm (implode (nreverse nm)))
;;        (setq nm (or (cdr (assq nm '((+ . MPLUS) (* . MTIMES) (^ . MEXPT)
;; 				     (** . MEXPT) (|.| . MNCTIMES) (^^ . MNCEXPT))))
;; 		    nm)))  

;; (defun insert-from-echo ()
;;   (insert-by-cursor (nformat-all (read-from-echo-area '|Insert:|))))

;; (defun insert-from-echo-eval ()
;;    (insert-by-cursor
;;     (nformat-all
;;      (meval (read-from-echo-area '|Insert:|)))))

;; (defun insert-by-cursor (temp)
;;    (let ((temp (subst (cadr region) '$% temp)))
;; 	(cond ((and (null (atom temp))
;; 		    (eq (caar temp) operator)
;; 		    (eq 'spread (cadar temp)))
;; 	       (rplacd region
;; 		       (append (cdr temp) (cdr region)))
;; 	       (setq region-length (caddar temp)))
;; 	      (t (rplacd region
;; 			 (cons temp (cdr region)))))
;;        (setq redisplay t)))

;; Modifying expressions -- using marks and kill-pdls

;; (defun top-kill-pdl ()
;;        (cond ((null kill-pdl) (ed-error))
;; 	     (t (insert-by-cursor (car kill-pdl)))))

;; (defun pop-kill-pdl ()
;;        (cond ((null kill-pdl) (ed-error))
;; 	     (t (insert-by-cursor (car kill-pdl))
;; 		(setq kill-pdl (cdr kill-pdl)))))

;; (defun mark-point ()
;;        (cond ((> argument 1)
;; 	      (pop-mark-into-point))
;; 	     (t
;; 	      (setq mark-pdl (cons (list operator operand region
;; 					 (displayed current-exp))
;; 				   mark-pdl)))))

;; (defun full-memq (a e)
;;        (cond ((eq a e))
;; 	     ((atom e) nil)
;; 	     ((or (full-memq a (car e))
;; 		  (full-memq a (cdr e))))))

;; (defun pop-mark-into-point ()
;;        (cond ((null mark-pdl) (ed-error))
;; 	     ((and (full-memq (cadddr (car mark-pdl)) (body current-exp))
;; 		   (full-memq (caddar mark-pdl) (cadddr (car mark-pdl))))
;; 	      (setq operator (caar mark-pdl)
;; 		    operand (cadar mark-pdl)
;; 		    region (caddar mark-pdl))
;; 	      (setf (displayed current-exp) (cadddr (car mark-pdl)))))
;; 	     (t (setq mark-pdl (cdr mark-pdl))
;; 		(ed-error)))

;  (defun exchange-mark-point ()
;         (mark-point)
;         (rplaca (cdr mark-pdl)
;  	       (prog2 0 (car mark-pdl)
;  		      (rplaca mark-pdl (cadr mark-pdl))))
;         (pop-mark-into-point))


;  Make this work with negative args for moving stuff backwards.
(set-key 'transpose-branch "C-t")
(defcom transpose-branch ((argument n))
"Transpose the region with the branch immediately following it.
The domain and width of the region remains the same.  If given a negative
argument, then transpose the region with the branch at the same level
immediately preceding it."

    (if (null (expression-list current-buffer))
	(ed-error "Current Buffer is empty."))
    (if (region-contains-top-node?)
	(ed-error "Region contains the entire expression."))
    (if (null n) (setq n 1))
    (cond ((> n 0)
	   (if (region-contains-last-branch?)
	       (ed-error "Region contains the last branch of this level."))
	   (transpose-branch-forward n))
	  ((< n 0)
	   (if (region-contains-first-branch?)
	       (ed-error "Region contains the last branch of this level."))
	   (transpose-branch-backward (- n)))))
    
(defun transpose-branch-forward (n)
       (do ((i 0 (1+ i)))
	   ((or (= i n) (region-contains-last-branch?)))
	   (let ((next-branch
		  (nthcdr (1+ (region-length current-exp)) (region current-exp))))
		(rplacd (nthcdr (region-length current-exp) (region current-exp))
			(cdr next-branch))
		(rplacd next-branch (cdr (region current-exp)))
		(rplacd (region current-exp) next-branch)
		(forward-branch))))

(defun transpose-branch-backward (n)
  (do ((i 0 (1+ i)))
      ((or (= i n) (region-contains-first-branch?)))
      (let ((current-branch (cdr (region current-exp))))
	   (rplacd (region current-exp)
		   (nthcdr (1+ (region-length current-exp)) (region current-exp)))
	   (rplacd (nthcdr (1- (region-length current-exp)) current-branch)
		   (region current-exp))
	   (backward-branch)
	   (rplacd (region current-exp) current-branch))))


;; Manipulating expressions with standard macsyma commands

;; There is some lossage here.  Expressions are stored internally
;; in "nformat" form, i.e. in the form in which they are displayed.
;; Generally, they will be stripped of simp flags since only the
;; displayer looks at them.  When passing them back to Macsyma, though,
;; any remaining simp flags must be ignored.  Simp flags are left on
;; %LOG, %SIN, and others, while taken off of MPLUS, MTIMES, etc.
;; So this is done by binding DOSIMP to T, and calling SIMPLIFY.
;; This is what the SSIMPLIFYA function does.  (Name sucks)
;; If MEVAL is being called, we don't need to do this, since it ignores
;; simp flags anyway.

;; If the first argument to REPLACE-REGION is NIL, the expression
;; is evaluated and simplified before being formatted.

(set-key 'simplify-region '("C-s" "s"))
(defcom simplify-region ((discard-argument))
"Simplifies the expression in the region.
No evaluation of the expression takes place."
	(minibuffer-clear)
	(minibuffer-print "Simplify region.")
	(replace-region t (ssimplifya (region-as-mexp current-exp))))

(set-key 'evaluate-region "v")
(defcom evaluate-region ((discard-argument))
"Evaluates and simplifies the expression in the region."
	(minibuffer-clear)
	(minibuffer-print "Evaluate region.")
	(replace-region nil (region-as-mexp current-exp)))

(set-key 'add-to-region "+")
(defcom add-to-region ((argument n)
		       (read-expression term
					"Add to region: ~A"
					(if n "(no evaluation) " "")))
"Add the expression contained in the region to one read from the minibuffer.
If a numeric argument is given, don't evaluate the entered expression."
    (replace-region n `((mplus) ,(region-as-mexp current-exp) ,term)))

(set-key 'multiply-to-region "*")
(defcom multiply-to-region ((argument n)
			    (read-expression factor
					     "Multiply to region: ~A"
					     (if n "(no evaluation) " "")))
"Multiply the expression in the region to one read from the minibuffer.
If a numeric argument is given, don't evaluate the entered expression."
    (replace-region n `((mtimes) ,(region-as-mexp current-exp) ,factor)))

(set-key 'divide-region "//")
(defcom divide-region ((argument n)
		       (read-expression factor
					"Divide region by: ~A"
					(if n "(no evaluation) " "")))
"Divide the expression in the region by one read from the minibuffer.
If a numeric argument is given, don't evaluate the entered expression."
    (replace-region n `((mquotient) ,(region-as-mexp current-exp) ,factor)))

(set-key 'exponentiate-region "^")
(defcom exponentiate-region ((argument n)
			     (read-expression exponent
					      "Exponentiate region: ~A"
					      (if n "(no evaluation) " "")))
"Exponentiate the expression contained in the region.
If a numeric argument is given, don't evaluate the entered expression."
    (replace-region n `((mexpt) ,(region-as-mexp current-exp) ,exponent)))

;  Do we need to simplify the values returned by $expand, $factor, etc?
(set-key 'expand-region "e")
(defcom expand-region ((discard-argument))
"Expand the expression contained in the region.
The expression is first simplified before being given to EXPAND."
    (minibuffer-clear)
    (minibuffer-print "Expand region.")
    (replace-region t ($expand (ssimplifya (region-as-mexp current-exp)))))

(set-key 'factor-region "f")
(defcom factor-region ((discard-argument))
"Factor the expression contained in the region.
The expression is first simplified before being given to FACTOR."
    (minibuffer-clear)
    (minibuffer-print "Factor region.")
    (replace-region t ($factor (ssimplifya (region-as-mexp current-exp)))))

(set-key 'differentiate-region "d")
(defcom differentiate-region ((discard-argument)
	    (read-expression var "Differentiate with respect to: "))
"Differentiate the expression contained in the region.
The expression is first simplified before being given to DIFF."
    (replace-region t ($diff (ssimplifya (region-as-mexp current-exp)) var)))

(set-key 'integrate-region "i")
(defcom integrate-region ((discard-argument)
			  (read-expression var "Integrate with respect to: "))
"Integrate the expression contained in the region.
The expression is first simplified before being given to INTEGRATE."
   (replace-region t ($integrate (ssimplifya (region-as-mexp current-exp)) var)))

(set-key 'multthru-region "m")
(defcom multthru-region ((discard-argument))
"Invoke MULTTHRU on the region."
    (minibuffer-clear)
    (minibuffer-print "Multthru region.  (distribute products over sums)")
    (replace-region t ($multthru (region-as-mexp current-exp))))

(set-key 'partfrac-region "p")
(defcom partfrac-region ((discard-argument)
	  (read-expression var "Partial fraction decomposition with respect to:"))
"Expand the region in partial fractions.
The expansion is performed with respect to the specified main variable, and
the expression is simplified before the expansion is done."
    (replace-region t ($partfrac (ssimplifya (region-as-mexp current-exp)) var)))

(set-key 'ratsimp-region "r")
(defcom ratsimp-region ((discard-argument))
"Invoke RATSIMP on the region."
    (minibuffer-clear)
    (minibuffer-print "Ratsimp region.")
    (replace-region t ($ratsimp (region-as-mexp current-exp))))

;; Changing an expression's label and the binding of the label.
;; Better to use read-expression than read-line since user could insert random
;; characters like space or : into label and not be able to reference it.

(set-key 'assign-expression ":")
(defcom assign-expression ((discard-argument)
			  (read-expression label "Assign region to: "))
"Change the label of the current expression.
The label also represents a macsyma variable, and this variable gets bound
to the current expression."
    (label-exp current-exp label))

