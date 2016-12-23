;;;  SHARPC 	   -*-mode:lisp;package:si;lowercase:T-*-	     -*-LISP-*-
;;;  **************************************************************************
;;;  ***** NIL ****** NIL/MACLISP/LISPM  # Conditionalizations ****************
;;;  **************************************************************************
;;;  ******** (c) Copyright 1981 Massachusetts Institute of Technology ********
;;;  ************ this is a read-only file! (all writes reserved) *************
;;;  **************************************************************************

;;;; FEATUREP and Sharpsign conditionalization.

#M (include ((lisp) subload lsp))

(herald SHARPCONDITIONALS /74)


(defvar FEATURE-NAMES () 
  "A list of all names representing feature sets currently defined.")

(defvar TARGET-FEATURES 'LOCAL
  "Features to assume objects read are for.")

(defvar MACROEXPAND-FEATURES 'TARGET
  "Features to assume when macroexpanding.")

(defvar SI:FEATUREP? () 
  "Used to communicate caller's function name to function SI:FEATUREP?")


#M (progn 'compile

(eval-when (eval compile load)
     (if (fboundp '*LEXPR) (*lexpr FEATUREP SET-FEATURE))
     (if (fboundp '*EXPR) (*expr SI:FEATUREP?))
     )

(eval-when (eval compile)
  (subload ERRCK)
  (subload LOOP)
  (subload UMLMAC)
  (subload DEFVST)
  (subload SHARPAUX))

(def-or-autoloadable DEF-FEATURE-SET SHARPA)
(def-or-autoloadable DEF-EQUIVALENCE-FEATURE-SET SHARPA)
(def-or-autoloadable DEF-INDIRECT-FEATURE-SET  SHARPA)
(def-or-autoloadable WHEN-FEATURE SHARPA)
(def-or-autoloadable WHEN-FEATURES SHARPA)

(let ((x (get 'SHARPM 'VERSION))
	(FASLOAD))
    (cond ((or (null x) 			;Not yet loaded, or
	       (alphalessp x '/75))		;Obsolete version alread loaded
	    (LOAD (autoload-filename SHARPM)))))

#+(and PDP10 (not NIL))
  (SSTATUS UUOLI)

(defvar QUERY-IO 'T 
  "Make sure this isn't unbound in MacLISP.")

) 	;end of #M




(defun SI:FEATURE-SET-NAME-P (arg)
    "Return the (non-null) feature set if arg is a feature set name."
  (and (symbolp arg)
       (get arg 'FEATURE-SET)))

(defun SI:GET-FEATURE-SET (feature-set-name using-fun)
  "Returns the FEATURE-SET struct that this name refers to, following
   indirections."
  (do ((set (SI:feature-set-name-p feature-set-name) 
	    (SI:feature-set-name-p feature-set-name)))
      ((not (null set))
       (if (symbolp set) 
	   (si:get-feature-set (symeval set) using-fun)	;Indirect set
	   set))
    (setq feature-set-name
	  (cerror t () ':WRONG-TYPE-ARGUMENT
		  "~*~S, an arg to ~S, is not the name of a feature set."
		  'FEATURE-SET feature-set-name using-fun))))


(defun FEATUREP (feature &optional (feature-set-name TARGET-FEATURES) 
			 &aux      (SI:FEATUREP? 'FEATUREP))
  "Returns non-() if the feature is known to be a feature in the 
   feature-set.  Otherwise returns ()."
  (SI:FEATUREP? feature
		(si:get-feature-set feature-set-name 'FEATUREP)
		'T))

(defun NOFEATUREP (feature &optional (feature-set-name TARGET-FEATURES) 
			   &aux      (SI:FEATUREP? 'NOFEATUREP))
  "Returns non-() if the feature is known NOT to be a feature in the 
   feature-set.  Otherwise returns ()."
  (SI:FEATUREP? feature
		(si:get-feature-set feature-set-name 'NOFEATUREP)
		() ))


(defun SI:FEATUREP? (feature feature-set featurep)
   "Return non-() if the feature is known to be a feature in the feature set. 
    Return () if it is known NOT to be a feature.  Otherwise query, error, or 
    assume, depending on the query-mode of the feature-set.  The 'featurep'
    argument being () inverts the sense of the return value."
   (cond ((atom feature) (si:featurep-symbol feature feature-set featurep))
	 ((eq (car feature) 'NOT)
	  (si:featurep? (cadr feature) feature-set (not featurep)))
	 ((eq (car feature) 'AND)
	  (si:feature-and (cdr feature) feature-set featurep))
	 ((eq (car feature) 'OR)
	  (si:feature-or (cdr feature) feature-set featurep))
	 ((SI:feature-set-name-p (car feature))
	    ;; Programmable case -- a "feature" like (MUMBLE HOT) means
	    ;;  that "MUMBLE" should be the name of a feature set, and the
	    ;;  "HOT" feature should be in it.    (MUMBLE HOT COLD) means that
	    ;;  both "HOT" and "COLD" should be in it, namely it is synonymous
	    ;;  with (MUMBLE (AND HOT COLD))
	  (si:feature-and (cdr feature)
			  (si:get-feature-set (car feature) 'SI:FEATUPREP?)
			  featurep))
	 ('T (setq feature (cerror 'T () ':INCONSISTENT-ARGS 
			       "~S is not a legal feature specification -- ~S"
			       (list feature)
			       SI:FEATUREP?))
	     (si:featurep? feature feature-set featurep))))




(defun SI:FEATURE-AND (feature-list feature-set featurep)
  "FEATUREP for the (AND f1 f2 f3 ... fn) case of a feature-spec"
  (if (loop for feature in feature-list 
	    always (si:featurep? feature feature-set 'T))
      featurep 
      (not featurep)))

(defun SI:FEATURE-OR (feature-list feature-set featurep)
  "FEATUREP for the (OR f1 f2 ... fn) case of a feature-spec"
  (if (loop for feature in feature-list 
	    thereis (si:featurep? feature feature-set 'T))
      featurep 
      (not featurep)))


(defun SI:FEATUREP-SYMBOL (feature feature-set featurep)
   "FEATUREP for the symbol case of a feature-spec"
  (struct-let (FEATURE-SET feature-set) (features nofeatures)
     (or (and featurep
	      (memq feature features)
	      'T)
	 (and (not featurep)
	      (memq feature nofeatures)
	      'T)
;; A MACLISP compatibility crock
#M	 (when (and (eq (feature-set-target feature-set) 'LOCAL)
		    (memq feature (status FEATURES))
		    featurep)
	       (set-feature feature 'LOCAL)	;Uncrockify
	       'T)
	 (if (and (not (memq feature nofeatures))
		  (not (and (not featurep)
			    (memq feature features))))
	     (caseq (FEATURE-SET-query-mode feature-set)
	       (:QUERY
		(if (y-or-n-p query-io 
			      "~&Is ~A a feature in ~A"
			      feature 
			      (FEATURE-SET-target feature-set))
		    (push feature (FEATURE-SET-features feature-set))
		    (push feature
			  (FEATURE-SET-nofeatures feature-set)))
		(si:featurep? feature feature-set featurep))
	       (:ERROR
		(FERROR ()
			"~S is not a known feature in ~S"
			feature 
			(FEATURE-SET-target feature-set)))
	       ((T) featurep)
	       (T (not featurep) )))	;Else assume nofeature
	 )))



(defun SET-FEATURE (feature &optional (feature-set-name TARGET-FEATURES))
  "Say that a feature is a feature in the feature-set.  FEATUREP will then
   return non-() when called with that feature on that feature-set."
  (si:feature-set-update feature feature-set-name 'T () 'SET-FEATURE))

(defun SET-NOFEATURE (feature &optional (feature-set-name TARGET-FEATURES))
  "Say that a feature is NOT a feature in the feature set.  FEATUREP will
   return ()."
  (si:feature-set-update feature feature-set-name () 'T 'SET-NOFEATURE))


(defun SET-FEATURE-UNKNOWN 
	(feature &optional (feature-set-name TARGET-FEATURES))
  "Make a feature-name be unknown in a feature set."
  (si:feature-set-update feature feature-set-name () () 'SET-FEATURE-UNKNOWN))


(defun SI:FEATURE-SET-UPDATE (feature feature-set-name featurep nofeaturep fun)
   "Update the lists of known features and known non-features in a 
    'feature-set'."
   (let ((feature-set (si:get-feature-set feature-set-name fun))
	 (noclobberp 'T))
     (or (symbolp feature) (check-type feature #'SYMBOLP fun))
     (struct-let (FEATURE-SET feature-set) (features nofeatures)
;; A MACLISP compatibility crock
#M     (when (eq feature-set-name 'LOCAL)
	 (if featurep
	     (apply 'SSTATUS `(FEATURE ,feature))
	     (apply 'SSTATUS `(NOFEATURE ,feature))))
       (when (not featurep)
	     (setq features (delq feature features) noclobberp () ))
       (when (not nofeaturep)
	     (setq nofeatures (delq feature nofeatures) noclobberp () ))
       (when (and featurep (not (memq feature features)))
	     (push feature features)
	     (setq noclobberp () ))
       (when (and nofeaturep (not (memq feature nofeatures)))
	     (push feature nofeatures)
	     (setq noclobberp () ))
       (when (not noclobberp) 
	     (struct-setf (FEATURE-SET feature-set)
			  (features features)
			  (nofeatures nofeatures)))))
     feature)



(defun SET-FEATURE-QUERY-MODE (feature-set-name mode)
   "Set the feature-set's query-mode.  :QUERY (the mode they're created in by 
    DEF-FEATURE-SET) means to ask about unknown features, :ERROR means signal
    an error, T means assume it's a feature, () means to assume it's not."
   (let ((feature-set (si:get-feature-set feature-set-name 'SET-FEATURE-QUERY-MODE)))
     (or (si:feature-modep mode)
	 (check-type mode #'SI:FEATURE-MODEP 'SET-FEATURE-QUERY-MODE))
     (setf (FEATURE-SET-query-mode feature-set) mode)))

(defun SI:FEATURE-MODEP (mode)
  (memq mode '(:QUERY :ERROR T () )))


(defun COPY-FEATURE-SET (feature-set-name new)
   "Build a new feature-set from a previously existing one, with same 
    features and non-features"
  (let ((feature-set (si:get-feature-set feature-set-name 'COPY-FEATURE-SET)))
    (or (symbolp new)
	(check-type new #'SYMBOLP 'COPY-FEATURE-SET))
    (putprop new 
	     (cons-a-FEATURE-SET 
	       TARGET     new
	       FEATURES   (append (FEATURE-SET-features feature-set) () )
	       NOFEATURES (append (FEATURE-SET-nofeatures feature-set) () )
	       QUERY-MODE (FEATURE-SET-query-mode feature-set))
	     'FEATURE-SET)
    (setq FEATURE-NAMES (cons new (delq new FEATURE-NAMES)))
    new))



(def-feature-set MACLISP
   :FEATURES   (MACLISP FOR-MACLISP HUNK SENDI BIGNUM FASLOAD PAGING ROMAN)
   :NOFEATURES (NIL FOR-NIL LISPM FOR-LISPM FRANZ VAX UNIX VMS )
   )

(def-feature-set LISPM 
   :FEATURES   (LISPM FOR-LISPM BIGNUM PAGING STRING)
   :NOFEATURES (MACLISP FOR-MACLISP NIL FOR-NIL FRANZ SFA NOLDMSG VECTOR
		VAX UNIX VMS MULTICS PDP10 ITS TOPS-20 TOPS-10 )
   )

(def-feature-set NIL
   :FEATURES (NIL FOR-NIL BIGNUM PAGING SFA STRING VECTOR)
   :NOFEATURES (MACLISP FOR-MACLISP LISPM FOR-LISPM FRANZ NOLDMSG )
   )

;; The following must be done first, because STATUS FEATURE requires FEATUREP
;; in NIL.

(copy-feature-set 
      (cond ((or (fboundp 'LAPSETUP/|) (fboundp '|ItoC|))
	       ;; or something MacLISP-specific
	      'MACLISP)	
	    ((fboundp 'SI:COMPARE-BAND) 'LISPM)	;or something LISPM-specific  
	    ('T 	      'NIL ))
      'LOCAL)

;;Remember TARGET-FEATURES was set to 'LOCAL


#-NIL (progn 'COMPILE 
;;The NILAID feature set is for any MacLISP with a sufficiently large
;;  subset of NIL features to be usable for cross-compilation.
(copy-feature-set #-LISPM 'MACLISP #+LISPM 'LISPM 'NILAID)
(mapc #'(lambda (x) (set-nofeature x 'NILAID))
      '(For-MacLISP For-LISPM))
(mapc #'(lambda (x) (set-feature x 'NILAID))
      '(NILAID NIL FOR-NIL SFA STRING VECTOR #+PDP10 PDP10 ))

)

;;TARGET-FEATURES now back to 'LOCAL 
(progn (set-feature (status OPSYSTEM))
       (set-feature (status FILESYSTEM))
  )


;; A MACLISP compatibility crock
#M (let ((y (status features)))
      ;; Set the features that are present in our environment now, in LOCAL
     (mapc #'SET-FEATURE y)
      ;; The following are either present or not initially
     (mapc #'(lambda (x) (or (memq x y) (set-nofeature x)))
	   '(SFA STRING VECTOR COMPLR NOLDMSG 
		 VAX UNIX VMS MULTICS PDP10 ITS TOPS-20 TOPS-10))
     )


;; INITIAL-LOCAL is useful for creating, by COPY-FEATURE-SET, other targets 
;;  which are variations of the default environment, where initial environment
;;  is whatever is present at the time LISP is started.

(COPY-FEATURE-SET 'LOCAL 'INITIAL-LOCAL)





(DEF-EQUIVALENCE-FEATURE-SET LOCAL-FEATURES LOCAL)
(DEF-EQUIVALENCE-FEATURE-SET MACLISP-FEATURES MACLISP)
(DEF-EQUIVALENCE-FEATURE-SET NIL-FEATURES NIL)

(DEF-INDIRECT-FEATURE-SET TARGET TARGET-FEATURES)
(DEF-INDIRECT-FEATURE-SET MACROEXPAND MACROEXPAND-FEATURES)
