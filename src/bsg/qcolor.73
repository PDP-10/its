;; -*-package:cube;  mode:lisp; lowercase:true-*-
;; see lmio;color >
;; bsg & dpc 4/5/80 and thereafter
;; flavorized bsg 1/26/81
;; verminization at cube faces 1/29/81 by bsg & L. Hazelton,
;; John Bongiovanni gets credit for compute-bongiovanni-matrices etc.

(defvar tv:alu-and 1)  ;beats me why this isnt global

(defvar ctheta 30.)
(defvar cphi 20.)
(defvar known-cubes nil)

(defflavor cube-graphics-mixin
   ((rdis-opt-array (make-array nil 'art-q '(3 3 3)))	;redisplay data
    working-array					;used at bitblt time
    (display-cube-templates (make-array nil 'art-q '(3)))  ;second-level index
    (display-coefficients (make-array nil 'art-q '(3 6))) ;cube coord => graphics
    front-templates					;bitblt parallelogramata
    side-templates					;""
    top-templates
    (border-templates (make-array nil 'art-q '(3)))	;2nd lev array
    bordered-front-template
    bordered-side-template
    bordered-top-template
    (corner-origins (make-array nil 'art-q '(3 2)))	;for bongiovanni hack
    (bongiovanni-matrices (make-array nil 'art-q '(3))) ;
    cubie-width						;3-space pixel edge
    color-p						;of this instance
    art							;array type
    bit
    prop						;prop for colors/patrns
	)
   (tv:list-mouse-buttons-mixin)
  (:gettable-instance-variables color-p))

(defvar colorp (color:color-exists-p))		;global state as to color or not running
(defvar bwp (not colorp))			;update bw display or not

(defvar pattern-colors)
(defvar border-thickness 3)
(defvar cubie-unit-vectors (make-array nil 'art-q '(3 3)))
(defvar new-cubie-unit-vectors (make-array nil 'art-q '(3 3)))
(defvar phi-matrix (make-array nil 'art-q '(3 3)))
(defvar theta-matrix (make-array nil 'art-q '(3 3)))

;;zwei:(set-comtab *standard-comtab* '("i" com-indent-for-lisp))


;;;
;;;   Externally-callable non-method interfaces
;;;


(defun color-cube ()
  (dolist (cube known-cubes)
    (cond ((funcall cube ':cubes-of-this-coloritude-wantedp)
	   (tv:sheet-force-access (cube :no-prepare)
	     (funcall cube ':redisplay-cube))))))

(defun redimension-all-cubes ()
  (dolist (cube known-cubes)
	  (funcall cube ':cube-dims-generate)
	  (tv:sheet-force-access (cube :no-prepare)
	    (funcall cube ':refresh))))

;display the face on the screen.

(defmethod (cube-graphics-mixin :display-cube-face)
     (faceno vert horiz color &aux ink template acolor)
  (prog ()
    (setq template (aref display-cube-templates faceno))
    (setq acolor (cond ((numberp color) color) (t (get color prop))))
    (setq ink
	  (cond (color-p
		 (do ((i 0 (1+ i))) (( i 8.)) (aset acolor color:bitblt-array i 0))
		 color:bitblt-array)
		(t (aref pattern-colors acolor))))

    (let ((screen-hor
	   (fix
	    (plus -64.
		  (times horiz (aref display-coefficients faceno 0))
		  (times vert (aref display-coefficients faceno 1))
		  (aref display-coefficients faceno 2))))
	(screen-vert
	  (fix
	    (plus -64.
		  (times horiz (aref display-coefficients faceno 3))
		  (times vert (aref display-coefficients faceno 4))
		  (aref display-coefficients faceno 5)))))
    (cond ((equal color (aref rdis-opt-array faceno vert horiz))(return nil))
	  (t (aset color rdis-opt-array faceno vert horiz)))

;;; Fill in workarray with stipple/color  (this version is gosper's idea, 22 july 1981

    (bitblt tv:alu-seta 128. 128. ink 0 0 working-array 0. 0.)

;;; Get logical-difference from-screen

    (funcall-self ':bitblt-from-sheet tv:alu-xor 128. 128. screen-hor screen-vert
		  working-array 0 0)

;;; Mask the difference by the right shape

    (bitblt tv:alu-and 128. 128. template 0. 0. working-array 0 0)

;;; And xor to screen.

    (funcall-self ':bitblt tv:alu-xor 128. 128. working-array 0 0 screen-hor screen-vert))))



;;;
;;;   Creation-time hackage for a cubish window
;;;

(defmethod (cube-graphics-mixin :after :init) (&rest ignore)
  (fillarray rdis-opt-array '(nil))
  (setq color-p (eq (get-toplev-auxl self) color:color-screen))
  (cond (color-p (setq art 'art-4b bit #o17 prop 'cube-color))
	(t (setq art 'art-1b bit #o1 prop 'cube-pattern)))

  (setq working-array (make-array nil art '(128. 128.)))

  (dotimes (i 3)(aset (make-array nil 'art-q '(2 2)) bongiovanni-matrices i))
  (fillarray display-cube-templates
	     `(,(setq front-templates (make-array nil art '(128. 128.)))
	       ,(setq top-templates (make-array nil art '(128. 128.)))
	       ,(setq side-templates (make-array nil art '(128. 128.)))))
  (fillarray border-templates
	     `(,(setq bordered-front-template (make-array nil art '(128. 128.)))
	       ,(setq bordered-top-template (make-array nil art '(128. 128.)))
	       ,(setq bordered-side-template (make-array nil art '(128. 128.)))))
  (or (memq self known-cubes)(push self known-cubes))
  (funcall-self ':cube-dims-generate))

(defun get-toplev-auxl (window)
  (let ((superior (funcall window ':superior)))
    (cond ((null superior) window)
	  (t (get-toplev-auxl superior)))))
;;;
;;;    Color cubes set color map before expose
;;;

(defmethod (cube-graphics-mixin :before :expose) (&rest ignore)
	   (if color-p (set-cube-color-map)))


;; For the Barco monitors, 
;;   color:color-map-on = 377 (maximum value for a given gun)
;;   color:color-map-off = 0  (minimum value)
;; Make sure these numbers are read in octal.

(defun set-cube-color-map ()
  (color:spectrum-color-map)
  color: (write-color-map 0 color-map-off color-map-on color-map-on) ;pretty blue (cyan)
  (color:write-color-map 5 #o320 #o100 #o70)	;red
  (color:write-color-map 4 0 #o140 color:color-map-on)	;blue
  (color:write-color-map 9. 0 0 0)		;border black
  (color:write-color-map 1 color:color-map-on #o150 0))	;orange

;;;
;;; Compute hirsute arrays at change size/margins time or init.
;;;

(defmethod (cube-graphics-mixin :after :change-of-size-or-margins) (&rest ignore)
  (funcall-self ':cube-dims-generate))

(defmethod (cube-graphics-mixin :cubes-of-this-coloritude-wantedp) ()
  (or (and colorp color-p)
      (and (not color-p) bwp)))

(defmethod (cube-graphics-mixin :after :refresh) (&optional type)
  (cond ((or (not tv:restored-bits-p)		;if no save-bits array
	     (eq type ':size-changed))		;or size has changed
	 (fillarray rdis-opt-array '(nil))
	 (if (funcall-self ':cubes-of-this-coloritude-wantedp)
	     (progn (funcall-self ':draw-cube-borders)
		    (funcall-self ':redisplay-cube))))))

(defmethod (cube-graphics-mixin :update-thyself) ()
  (tv:sheet-force-access (self :no-prepare)
    (funcall-self ':draw-cube-borders)
    (funcall-self ':redisplay-cube)))

(defmethod (cube-graphics-mixin :cube-dims-generate) ()
  (fillarray rdis-opt-array '(nil))
  (multiple-value-bind (xdim ydim)(funcall-self ':inside-size)
    (setq cubie-width (// (min xdim ydim) 10.))
    (set-up-cube-display-coefficients
      ctheta
      cphi
      (// ydim					;allow legending space
	  (cond ((funcall-self ':get-handler-for ':cube-legending) 3)
		(t 2)))
      (// xdim 2)
      display-coefficients
      display-cube-templates
      border-templates
      cubie-width
      bit))
  (compute-face-corner-lists))

;;;  Features for interpreting mousings at the cube pictures
;;;  1/29/81 bsg & lrh


;;;           1/ \
;;;           /   \
;;;       0 /       \ 2
;;;        <          >
;;;        |\        /|
;;;        |  \ 3  /  |
;;;        |    \/    |
;;;       6\     |    /4
;;;          \   |  /
;;;            \ |/
;;;              5
;;;

(declare-flavor-instance-variables (cube-graphics-mixin)
(defun compute-face-corner-lists ()		;0 = front, 1 = top, 2 = side
  (let* ((x0 (difference (aref display-coefficients 0 2)
			 (times 0.5 (aref cubie-unit-vectors 0 0))
			 (times 0.5 (aref cubie-unit-vectors 0 1))))
	 (y0 (difference (aref display-coefficients 0 5)
			 (times 0.5 (aref cubie-unit-vectors 1 0))
			 (times 0.5 (aref cubie-unit-vectors 1 1))))
	 (x1 (plus x0 (times 3. (aref cubie-unit-vectors 0 2))))
	 (y1 (plus y0 (times 3. (aref cubie-unit-vectors 1 2))))
	 (x2 (plus x1 (times 3. (aref cubie-unit-vectors 0 0))))
	 (y2 (plus y1 (times 3. (aref cubie-unit-vectors 1 0))))
	 (x3 (plus x0 (times 3. (aref cubie-unit-vectors 0 0))))
	 (y3 (plus y0 (times 3. (aref cubie-unit-vectors 1 0))))
	 (x5 (plus x3 (times 3. (aref cubie-unit-vectors 0 1))))
	 (y5 (plus y3 (times 3. (aref cubie-unit-vectors 1 1))))
	 (x6 (plus x0 (times 3. (aref cubie-unit-vectors 0 1))))
	 (y6 (plus y0 (times 3. (aref cubie-unit-vectors 1 1)))))

    (aset x0 corner-origins 0 0)		;FRONT
    (aset y0 corner-origins 0 1)

    (aset x0 corner-origins 1 0)		;TOP
    (aset y0 corner-origins 1 1)

    (aset x3 corner-origins 2 0)		;SIDE
    (aset y3 corner-origins 2 1)

    (compute-bongiovanni-matrix 0 x3 y3 x6 y6)  ;FRONT
    (compute-bongiovanni-matrix 1 x1 y1 x3 y3)  ;TOP
    (compute-bongiovanni-matrix 2 x2 y2 x5 y5))) ;SIDE
)

(declare-flavor-instance-variables (cube-graphics-mixin)
(defun compute-bongiovanni-matrix (faceno e f c d)
  (let ((a (aref corner-origins faceno 0))
	(b (aref corner-origins faceno 1)))
    (let ((a (- e a))
	  (b (- c a))
	  (c (- f b))
	  (d (- d b)))
      (let ((delta (- (* a d)(* b c)))
	    (bongo (aref bongiovanni-matrices faceno)))
	(cond ((< delta .001)
	       (fillarray bongo '(-20.)))	;singular, make big numbers
	      (t 
	       (aset (quotient d delta) bongo 0 0)
	       (aset (quotient (- b) delta) bongo 0 1)
	       (aset (quotient (- c) delta) bongo 1 0)
	       (aset (quotient a delta) bongo 1 1)))))))
)


;;;
;;;   Runtime of mouse interpreter
;;;

(declare-flavor-instance-variables (cube-graphics-mixin)
(defun point-in-face-p (x y faceno)
  (setq x (- x (aref corner-origins faceno 0)))
  (setq y (- y (aref corner-origins faceno 1)))
  (let ((bongo (aref bongiovanni-matrices faceno)))
    (let ((normal-x (+ (* (aref bongo 0 0) x)
		       (* (aref bongo 0 1) y)))
	  (normal-y (+ (* (aref bongo 1 0) x)
		       (* (aref bongo 1 1) y))))
      (and (> normal-x 0.0)(< normal-x 1.0)
	   (> normal-y 0.0)(< normal-y 1.0)))))
)

(defmethod (cube-graphics-mixin :coordinates-in-face-p) (x y)
  (cond ((point-in-face-p x y 0) 'FRONT)
	((point-in-face-p x y 1) 'TOP)
	((point-in-face-p x y 2) 'SIDE)
	(t nil)))


;;; Update Cube display


(defmethod (cube-graphics-mixin :redisplay-cube) ()
  (1to3 x (1to3 y (funcall-self ':display-cube-face
				0 (1- x)(1- y) (fetch-cube-in-orientation x y FRONT TOP))))
  (1to3 x (1to3 y (funcall-self ':display-cube-face
				1 (1- x)(1- y) (fetch-cube-in-orientation x y TOP BACK))))
  (1to3 x (1to3 y (funcall-self ':display-cube-face
				2 (1- x)(1- y) (fetch-cube-in-orientation x y RHS TOP)))))



;set up variables for displaying the cube

(defun cube-graphics-init ()
  (defprop red 0 cube-pattern)
  (defprop white 1 cube-pattern)
  (defprop blue 2 cube-pattern)
  (defprop green 3 cube-pattern)
  (defprop yellow 4 cube-pattern)
  (defprop orange 5 cube-pattern)
  (defprop orange 1 cube-color)
  (defprop green 2 cube-color)
  (defprop yellow 3 cube-color)
  (defprop blue 4 cube-color)
  (defprop red 5 cube-color)
  (defprop white 7 cube-color)
  (pattern-init))


(defvar pattern-colors (make-array nil 'art-q '(6)))
(defvar pattern-on (make-array nil 'art-1b '(128. 128.)))
(defvar pattern-pignose (make-array nil 'art-1b '(128. 128.)))
(defvar pattern-dots (make-array nil 'art-1b '(128. 128.)))
(defvar pattern-lines (make-array nil 'art-1b '(128. 128.)))
(defvar pattern-circles (make-array nil 'art-1b '(128. 128.)))
(defvar pattern-checkers (make-array nil 'art-1b '(128. 128.)))
(defvar pignose-workarray (make-array nil 'art-1b '(32. 8.)))


;set up the patters for the black and white monitor

(defun pattern-init ()
  (aset pattern-on pattern-colors 0)
  (aset pattern-pignose pattern-colors 1)
  (aset pattern-dots pattern-colors 2)
  (aset pattern-lines pattern-colors 3)
  (aset pattern-circles pattern-colors 4)
  (aset pattern-checkers pattern-colors 5)
  (fillarray pattern-on '(0))
  (pattern-fill pattern-pignose '((1 1)(2 1)(3 1)(4 1)(5 1)
				  (0 2)(6 2)(0 3)(2 3)(4 3)(6 3)(0 4)(6 4)
				  (1 5)(2 5)(3 5)(4 5)(5 5)))
  (pattern-fill pattern-dots '((3 2)(4 2)(2 3)(3 3)(4 3)(5 3)(2 4)(3 4)(4 4)(5 4)(3 5)
			       (4 5)))
  (pattern-fill pattern-lines '((3 0)(4 0)(3 1)(4 1)(3 2)(4 2)(3 3)(4 3)(3 4)(4 4)(3 5)(4 5)
				(3 6)(4 6)(3 7)(4 7)))
  (pattern-fill pattern-circles '((3 0)(4 0)(1 1)(2 1)(5 1)(6 1)(1 2)(6 2)(0 3)(7 3)(0 4)
				  (7 4)(1 5)(6 5)(1 6)(6 6)(2 6)(5 6)(3 7)(4 7)))
  (pattern-fill pattern-checkers '((0 0)(1 0)(4 0)(5 0)(0 1)(1 1)(4 1)(5 1)(2 2)(3 2)(6 2)
				  (7 2)(2 3)(3 3)(6 3)(7 3)(0 4)(1 4)(4 4)(5 4)(0 5)(2 5)(4 5)
				  (5 5)(2 6)(3 6)(6 6)(7 6)(2 7)(3 7)(6 7)(7 7))))

(defun pattern-fill (array list)		
  (dotimes (lx 4)
    (dotimes (x 8.)
      (dotimes (y 8.)
	(aset 0 pignose-workarray (+ (* 8. lx) x) y)))
    (mapc #'(lambda (pair)
	      (aset 1 pignose-workarray (+ (* 8 lx) (car pair))(cadr pair)))
	  list))
  (bitblt tv:alu-seta 128. 128. pignose-workarray 0 0 array 0 0))

(cube-graphics-init)				;LOAD TIME HACK


;;;;  Cubesys graphics support...
;;;;  Stuff that used to be in QPROJC > ......

(defun mat-multiply (left right giving)		;may not share storage!!!!!
  (dotimes (x 3)
    (dotimes (y 3)
      (let ((element 0.0))
	(dotimes (i 3)
	  (setq element (plus element
			      (times (aref left x i)(aref right i y)))))
	(aset element giving x y)))))

(defunp draw-line-in-array (array x0 y0 x1 y1 what-to-store)
  (cond ((= y0 y1)
	 (let ((lessx (min x0 x1))(morex (max x0 x1)))
	   (do ((x lessx (1+ x)))
	       ((> x morex))
	     (aset what-to-store array x y0)))
	 (return nil))
	((> y0 y1)
	 (let ((xx0 x0)(yy0 y0))
	   (setq x0 x1 y0 y1 x1 xx0 y1 yy0))))	;exchange to make y1 not less than y0
  (do ((y y0 (1+ y))
       (slope (quotient (float (- x1 x0))(float (- y1 y0)))))
      ((> y y1))
    (let ((curx (fix (plus 0.8 x0 (times (float (- y y0)) slope))))
	  (fslope (fix (cond ((> slope 0)(plus 0.8 slope))
			     (t (difference slope 0.8))))))
      (cond ((and (> (abs fslope) 1)(not (= y y1)))
	     (cond ((> x1 x0)(do ((x curx (1+ x)))((> x (+ curx 1 fslope)))
			       (aset what-to-store array x y)))
		   (t (setq fslope (- 0 fslope))
		      (do ((x (- curx fslope 1)(1+ x)))((> x curx))
			(aset what-to-store array x y)))))
	    (t
	      (aset what-to-store array curx y))))))


(defun draw-line-with-thickness-in-array (array x0 y0 x1 y1 what-to-store thickness)
  (let ((half (// thickness 2) 1))
    (cond ((> (abs (- x1 x0))(abs (- y1 y0)))
	   (do ((delta (- 0 half)(1+ delta)))
	       ((> delta half))
	     (draw-line-in-array array x0 (+ y0 delta) x1 (+ y1 delta) what-to-store)))
	  (t (do ((delta (- 0 half)(1+ delta)))
		 ((> delta half))
	       (draw-line-in-array array (+ x0 delta) y0 (+ x1 delta) y1 what-to-store))))))

(defvar zeroness-17-array (make-array nil 'art-4b '(128. 128.)))
(defvar zeroness-1-array (make-array nil 'art-1b '(128. 128.)))
(fillarray zeroness-1-array '(0))
(fillarray zeroness-17-array '(0))

(defun draw-parallelogram-in-array
       (array what-to-store xorigin yorigin s1i s1j s2i s2j thickness)
  (bitblt tv:alu-seta 128. 128. (cond ((= what-to-store 1) zeroness-1-array)
				      (t zeroness-17-array))
	  0 0 array 0 0)
  (draw-line-with-thickness-in-array
    array xorigin yorigin (+ xorigin s1i)(+ yorigin s1j) what-to-store thickness)
  (draw-line-with-thickness-in-array
    array xorigin yorigin (+ xorigin s2i)(+ yorigin s2j) what-to-store thickness)
  (draw-line-with-thickness-in-array
    array (+ xorigin s1i)(+ yorigin s1j)(+ xorigin s1i s2i)(+ yorigin s1j s2j) what-to-store thickness)
  (draw-line-with-thickness-in-array
    array (+ xorigin s2i)(+ yorigin s2j)(+ xorigin s1i s2i)(+ yorigin s1j s2j) what-to-store thickness))

(defun fill-in-convex-shape (array what-to-store line-what-to-store)
  (let ((array-x-dim (array-dimension-n 1 array))
	(array-y-dim (array-dimension-n 2 array)))
    (do ((y 0 (1+ y)))
	((= y array-y-dim))
      (do ((xstart 0 (1+ xstart)))
	  ((= xstart array-x-dim))
	(cond ((not (= 0 (aref array xstart y)))
	       (do ((xend (1- array-x-dim)(1- xend)))
		   ((not (= 0 (aref array xend y)))
		    (do ((x xstart (1+ x)))
			((> x xend))
		      (cond ((= 0 (aref array x y))
			     (aset what-to-store array x y))
			    (t (aset line-what-to-store array x y))))))
	       (return nil)))))))



(defun set-up-cube-display-coefficients
       (theta phi vert-ctr horiz-ctr coeffs templates bordered-templates width bit
	      &aux horiz vert)

  (fillarray cubie-unit-vectors
	     `(,width 0 0
	       0 ,width 0
	       0 0 ,width))
  (let ((theta-radians (quotient (times 3.14159265358 theta) 180.0))
	(phi-radians (quotient (times 3.14159265358 phi) 180.0))
	(front-templates (aref templates 0))
	(top-templates (aref templates 1))
	(side-templates (aref templates 2))
	(bordered-front-template (aref bordered-templates 0))
	(bordered-top-template (aref bordered-templates 1))
	(bordered-side-template (aref bordered-templates 2)))
    
    (let ((sin-phi (sin phi-radians))
	  (sin-theta (sin theta-radians))
	  (cos-phi (cos phi-radians))
	  (cos-theta (cos theta-radians)))
      (fillarray theta-matrix
		 `(,cos-theta 0 ,sin-theta
		   0          1  0
		   ,(minus sin-theta) 0 ,cos-theta))
      (fillarray phi-matrix
		 `(,1  0        0
		   0 ,cos-phi ,(- sin-phi)
		   0 ,sin-phi ,cos-phi))
      (mat-multiply theta-matrix cubie-unit-vectors new-cubie-unit-vectors)
      (mat-multiply phi-matrix new-cubie-unit-vectors cubie-unit-vectors)

      ;;; Compute centering coordinates

      (let ((howhigh (times 3 (plus (aref cubie-unit-vectors 1 0)
				    (aref cubie-unit-vectors 1 1)
				    (minus (aref cubie-unit-vectors 1 2)))))
	    (howwide (times 3 (plus (aref cubie-unit-vectors 0 0)
				    (aref cubie-unit-vectors 0 1)
				    (aref cubie-unit-vectors 0 2)))))
	(setq horiz (fix (difference horiz-ctr (times 0.5 howwide)))
	      vert (fix (difference vert-ctr (times 0.5 howhigh)
				    (times 3 (aref cubie-unit-vectors 1 2))))))



      ;;FRONT
       ;; feeding into x positioning

      (aset (aref cubie-unit-vectors 0 0) coeffs 0 0)
      (aset (aref cubie-unit-vectors 0 1) coeffs 0 1)
      (aset (plus horiz (quotient (plus (aref cubie-unit-vectors 0 0)
					(aref cubie-unit-vectors 0 1)) 2))
	    coeffs 0 2)

      ;; feeding into y positioning

      (aset (aref cubie-unit-vectors 1 0) coeffs 0 3)
      (aset (aref cubie-unit-vectors 1 1) coeffs 0 4)
      (aset (plus vert (quotient (plus (aref cubie-unit-vectors 1 1)
				       (aref cubie-unit-vectors 1 0)) 2))
	    coeffs 0 5)

      ;;TOP
       ;; feeding into x positioning

      (aset (aref cubie-unit-vectors 0 0) coeffs 1 0)
      (aset (- (aref cubie-unit-vectors 0 2)) coeffs 1 1)
      (aset (plus horiz
		  (times 2.5 (aref cubie-unit-vectors 0 2))
		  (times 0.5 (aref cubie-unit-vectors 0 0)))
	    coeffs 1 2)

       ;; feeding into y positioning

      (aset (aref cubie-unit-vectors 1 0) coeffs 1 3)
      (aset (- (aref cubie-unit-vectors 1 2)) coeffs 1 4)
      (aset (plus vert
		  (times 2.5 (aref cubie-unit-vectors 1 2))
		  (times 0.5 (aref cubie-unit-vectors 1 0)))
	    coeffs 1 5)

      ;; RHS
       ;;feeding into x positioning

      (aset (aref cubie-unit-vectors 0 2) coeffs 2 0)
      (aset (aref cubie-unit-vectors 0 1) coeffs 2 1)
      (aset (plus horiz
		  (times 3 (aref cubie-unit-vectors 0 0))
		  (times 0.5 (aref cubie-unit-vectors 0 1))
		  (times 0.5 (aref cubie-unit-vectors 0 2)))
	    coeffs 2 2)

       ;; feeding  into y positioning

      (aset (aref cubie-unit-vectors 1 2) coeffs 2 3)
      (aset (aref cubie-unit-vectors 1 1) coeffs 2 4)
      (aset (plus vert
		  (times 3.0 (aref cubie-unit-vectors 1 0))
		  (times 0.5 (aref cubie-unit-vectors 1 2))
		  (times 0.5 (aref cubie-unit-vectors 1 1)))
	    coeffs 2 5)


      (draw-trueproj-parallelogram bordered-front-template bit 0 1 border-thickness)
      (draw-trueproj-parallelogram bordered-top-template bit 0 2 border-thickness)
      (draw-trueproj-parallelogram bordered-side-template bit 1 2 border-thickness)

      (bitblt tv:alu-seta 128. 128. bordered-front-template 0 0 front-templates 0 0)
      (bitblt tv:alu-seta 128. 128. bordered-top-template 0 0 top-templates 0 0)
      (bitblt tv:alu-seta 128. 128. bordered-side-template 0 0 side-templates 0 0)

      (fill-in-convex-shape front-templates bit 0)
      (fill-in-convex-shape top-templates bit 0)
      (fill-in-convex-shape side-templates bit 0))))


(defun draw-trueproj-parallelogram
       (array bit c1 c2 thick)
  (draw-parallelogram-in-array
    array bit
    (fix (plus 64. (minus (times 0.5
				 (plus (aref cubie-unit-vectors 0 c1)
				       (aref cubie-unit-vectors 0 c2))))))
    (fix (plus 64. (minus (times 0.5
				 (plus (aref cubie-unit-vectors 1 c1)
				       (aref cubie-unit-vectors 1 c2))))))
    (fix (aref cubie-unit-vectors 0 c1))
    (fix (aref cubie-unit-vectors 1 c1))
    (fix (aref cubie-unit-vectors 0 c2))
    (fix (aref cubie-unit-vectors 1 c2))
    thick))



(defmethod (cube-graphics-mixin :draw-cube-borders) ()
  (cond (color-p
	 (do ((i 0 (1+ i))) (( i 8.)) (aset 9. color:bitblt-array i 0))
	 (let ((black color:bitblt-array))
	      (bitblt tv:alu-and 128. 128. black 0 0 bordered-front-template 0 0)
	      (bitblt tv:alu-and 128. 128. black 0 0 bordered-top-template 0 0)
	      (bitblt tv:alu-and 128. 128. black 0 0 bordered-side-template 0 0))))

  (dotimes (faceno 3)
    (dotimes (x 3)
      (dotimes (y 3)
	(let ((bordaray (aref border-templates faceno)))
	  (let ((screen-hor
		  (fix
		    (plus -64.
			  (times x (aref display-coefficients faceno 0))
			  (times y (aref display-coefficients faceno 1))
			  (aref display-coefficients faceno 2))))
		(screen-vert
		  (fix
		    (plus -64.
			  (times x (aref display-coefficients faceno 3))
			  (times y (aref display-coefficients faceno 4))
			  (aref display-coefficients faceno 5)))))
	    (funcall-self ':bitblt tv:alu-ior 128. 128. bordaray 0 0
			  screen-hor screen-vert)))))))

