(comment )  ;;; -*-lisp-*-


(progn 
     ;closes init file, if any, or else load file
   (and (filep uread) (close uread))
   (and (filep infile) (not (eq infile tyi)) (close infile))
   (setq infile 't)
   (setq pure t *pure () )
   (load '((liblsp) sharab))
   (fasload (lisp) defmax)
   (setq pure 1 *pure 'T)
   (*rset 'T)
   (pagebporg)
   (setq putprop (purcopy 
		  (append '(STRUCT=INFO SELECTOR CONSTRUCTOR AUTOLOAD VERSION 
			    CARCDR |side-effectsp/|| SETF-X 
			    GRINDFN GRINDPREDICT GRINDMACRO GRINDFLATSIZE)  
			  putprop))
	 pure-putprop putprop)
   (setq SHBDMP (list (cond ((status feature ITS) '(DSK LSPDMP))
			    ('T (+internal-lossage "Not Yet Implemented for Non-ITS systems" 'SHARAB () )
				'(LISP)))
		      'SHBDMP 
		      (implode (nconc (exploden (get 'SHARABLE 'VERSION))
				      (list '|.|)
				      (cdr (exploden (status LISPV)))))))
   (sstatus 
     TOPLEVEL 
     '((lambda () 
	 (sstatus TOPLEVEL () )
	 (setq - () + () )
	 (pure-suspend "SHARABJ:VP " SHBDMP)
	 (announce-&-load-init-file 'SHARABLE (status JCL)) )))
   (sstatus feature SHARABLE)
   (*throw () () ))


