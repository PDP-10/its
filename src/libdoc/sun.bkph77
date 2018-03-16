
;;; COPYRIGHT Berthold K. P. Horn, 1977
;;; 
;;; Program to calculate sun-elevation and sun-azimuth.
;;; Given observers geographical position and time of observation.
;;;
;;; T = time in days since 1975/01/01 GMT 00:00:00
;;;
;;; MEAN ANOMALY (M) = Geometric Mean Longitude - Mean Longitude of Perigee
;;; M = -2.4834 + .98560026 * T 
;;; 
;;; Mean Eccentricity e = .0l67343
;;; SQRT((1+e)/(1-e)) = 1.016877 in the mean
;;;
;;; ECCENTRIC ANOMALY (E) = Anomaly measured from focus of ellipse
;;; E + e sin(E) = M. Transcendental equation.
;;;
;;; TRUE ANOMALY (N):  tan (N/2) = SQRT((1+e)/(1-e)) tan(E/2)
;;;
;;; LONGITUDE OF EARTH PERIGEE (G) = 282.5103 + .00004707 * T
;;; (Includes precession of earth's pole AND precession of orbit)
;;;
;;; TRUE LONGITUDE = LONGITUDE OF PERIGEE + TRUE ANOMALY
;;;
;;; (PRECESSION 50".47 per year, added to celestial longitude)
;;; (ABBERATION -20".47 taken off celestial longitude)
;;; 
;;;  Position of MOON'S NODE (O) = 248.58 - .052955 * T
;;;  NUTATION in celestial longitude = -17".234 * sin(O)
;;;  NUTATION in obliquity = 9".210 * cos(O)
;;;  
;;;  SEMI-DIAMETER .267 * (1 + e * cos(N) )
;;;  OBLIQUITY OF ECLIPTIC PLANE (X)= 23.4425 + .0025575 * cos(O)
;;;
;;;  DECLINATION (celestial latitude) of sun         PHI = asin(sin(L) * sin(X))
;;;  RIGHT ASCENSION (celestial longitude) of sun    THETA = asin(sin(L) * cos(X)/cos(PHI))
;;;  If cos(L)<0 use (180 - THETA)
;;;
;;;  GHA(ARIES) = 100.025 + 360.9856473 * T
;;; 
;;;  GHA(SUN) = GHA(ARIES) + R.A.(SUN)
;;;  LONGITUDE(SUB-SOLAR POINT) = 360.0 - GHA(SUN)
;;;  LATITUDE(SUB-SOLAR POINT)  = DECLINATION(SUN)
;;;

;;;  Calculate GHA and Declination AND Semi-Diameter of sun.
;;;  Given time (T) in days since 1975/01/01 GMT 00:00:00
;;;  Result is list, (GHA DEC SD), numbers in decimal degrees.
;;;
(DEFUN SUN-POSITION (TIME) 
       (PROG (MEANA GUESA ECCEA TRUEA LAMBD OMEGA OBLIQ PHI THETA
	      GHAGAM) 
	     (SETQ MEANA (-$ (*$ TIME 0.9856) 2.4832) 
		   GUESA (TRUEANOM MEANA) 
		   GUESA (ECCENANOM GUESA MEANA) 
		   ECCEA (ECCENANOM GUESA MEANA) 
		   TRUEA (TRUEANOM ECCEA))
	     (SETQ LAMBD (+$ TRUEA 282.5104 (//$ TIME 21120.0)) 
		   OMEGA (-$ 248.6 (//$ TIME 18.884)) 
		   OBLIQ (+$ 23.4425 (//$ (COSD OMEGA) 391.0)) 
		   LAMBD (-$ LAMBD (//$ (SIND OMEGA) 209.0)))
	     (SETQ SEMID (*$ 0.267 (+$ 1.0 (//$ (COSD TRUEA) 60.0))) 
		   PHI (ASIND (*$ (SIND LAMBD) (SIND OBLIQ))) 
		   THETA (-$ 0.0
			     (ASIND (//$ (*$ (SIND LAMBD)
					     (COSD OBLIQ))
					 (COSD PHI)))))
	     (COND ((< (COSD LAMBD) 0.0)
		    (SETQ THETA (-$ 180.0 THETA))))
	     (SETQ GHAGAM (+$ (*$ TIME 0.9856473)
			      (*$ (FRACTION TIME) 360.0)
			      100.025) 
		   THETA (RANGE (+$ THETA GHAGAM)))
	     (RETURN (LIST THETA PHI SEMID)))) 

;;;  CALCULATES ELEVATION AND AZIMUTH AT OBSERVERS LOCATION.
;;;  THETA1 PHI1 OBSERVERS LONGITUDE AND LATITUDE (decimal degrees).
;;;  THETA2 PHI2 CELESTIAL OBJECTS LONGITUDE AND LATITUDE (decimal degrees).
;;;  Result is list, (ELEV AZIM), numbers are decimal degrees.

(DEFUN SKY-ANGLES (THETA1 PHI1 THETA2 PHI2) 
       (PROG (DTH ELEV AZIM) 
	     (SETQ DTH (-$ THETA2 THETA1) 
		   ELEV (ASIND (+$ (*$ (SIND PHI1) (SIND PHI2))
				   (*$ (COSD PHI1)
				       (COSD PHI2)
				       (COSD DTH)))) 
		   AZIM (ACOSD (//$ (-$ (SIND PHI2)
					(*$ (SIND PHI1) (SIND ELEV)))
				    (*$ (COSD PHI1) (COSD ELEV)))))
	     (COND ((< (SIND DTH) 0.0) (SETQ AZIM (-$ 360.0 AZIM))))
	     (RETURN (LIST ELEV AZIM)))) 

;;; Calculate sun-elevation and sun-aximuth and semi-diameter.
;;; Given observer longitude and latitude, date and time.
;;; Input format: (A DD MM SS), (A DD MM SS), (YYYY MM DD), (HH MM SS).
;;; EAST IS POSITIVE for longitude, NORTH IS POSITIVE for latitude.
;;; RETURNS (ELEVATION AZIMUTH), format ((A DD MM SS) (A DD MM SS) (A DD MM SS))
;;; AZIMUTH MEASURED CLOCKWISE FROM NORTH
(DEFUN SUN (LONG LATI DATE HOURS) 
       (PROG (SUNPOS SKYANG) 
	     (SETQ SUNPOS (SUN-POSITION (+$ (JULIAN DATE)
					    (HHMMSS HOURS))) 
		   SKYANG (SKY-ANGLES (DDMMSS LONG)
				      (DDMMSS LATI)
				      (-$ 360.0 (CAR SUNPOS))
				      (CADR SUNPOS)))
	     (RETURN (LIST (ANGLED (CAR SKYANG))
			   (ANGLED (CADR SKYANG))
			   (ANGLED (CADDR SUNPOS)))))) 

;;;  CALCULATE DAYS SINCE 1975/01/01 -- INPUT format (YY MM DD)
;;;  JULIAN DATE EQUALS RESULT PLUS 2442414.

(DEFUN JULIAN (DATED) 
       (PROG (YEAR MONTH DAY DYR YRS) 
	     (SETQ YEAR (CAR DATED) 
		   MONTH (CADR DATED) 
		   DAY (CADDR DATED))
	     (SETQ DYR (- 0. (// (- 14. MONTH) 12.)) 
		   YRS (+ DYR YEAR 4800.))
	     (RETURN (FLOAT (+ (- (// (* 367.
					 (- (- MONTH 2.) (* DYR 12.)))
				      12.)
				  (// (* 3. (1+ (// YRS 100.))) 4.))
			       (+ (// (* 1461. YRS) 4.)
				  (- DAY (+ 32075. 2442414.)))))))) 

;;; CALCULATE DATE, GIVEN DAYS SINCE 1975/01/01  -- OUTPUT format (YY MM DD)
;;; ARGUMENT IS (JULIAN DATE - 2442414.)

(DEFUN DATED (JULIAN) 
       (PROG (LOFF NOFF IOFF JOFF KOFF) 
	     (SETQ LOFF (+ (FIX JULIAN) 68569. 2442414.) 
		   NOFF (// (* LOFF 4.) 146097.) 
		   LOFF (- LOFF (// (+ (* 146097. NOFF) 3.) 4.)) 
		   IOFF (// (* 4000. (1+ LOFF)) 1461001.) 
		   LOFF (- LOFF (- (// (* 1461. IOFF) 4.) 31.)) 
		   JOFF (// (* 80. LOFF) 2447.) 
		   KOFF (- LOFF (// (* 2447. JOFF) 80.)) 
		   LOFF (// JOFF 11.) 
		   JOFF (- JOFF (- (* 12. LOFF) 2.)) 
		   IOFF (+ IOFF (* 100. (- NOFF 49.)) LOFF))
	     (RETURN (LIST IOFF JOFF KOFF)))) 

;;; NEGATE ANGLE IN FUNNY FORMAT

(DEFUN INVERT (L) 
       (COND ((EQUAL (CAR L) '+) (CONS '- (CDR L)))
	     ((EQUAL (CAR L) '-) (CONS '+ (CDR L)))
	     (T (PRINT 'ERROR-IN-ANGLE-FORMAT)))) 

;;; CONVERT FROM HOURS -- format (HH MM SS) -- TO DECIMAL DAYS.
(DEFUN HHMMSS (TIMED) 
       (//$ (+$ (FLOAT (CAR TIMED))
		(//$ (+$ (FLOAT (CADR TIMED))
			 (//$ (FLOAT (CADDR TIMED)) 60.0))
		     60.0))
	    24.0)) 

;;; CONVERT FROM DECIMAL DAYS TO HOURS -- format (HH MM SS).

(DEFUN TIMED (HHMMSS) 
       (PROG (HH MM SS TMP) 
	     (SETQ HHMMSS (*$ 24.0 HHMMSS) 
		   HH (FIX HHMMSS) 
		   TMP (*$ 60.0 (-$ HHMMSS (FLOAT HH))) 
		   MM (FIX TMP) 
		   TMP (*$ 60.0 (-$ TMP (FLOAT MM))) 
		   SS (FIX (+$ 0.5 TMP)))
	     (RETURN (LIST HH MM SS)))) 

;;; CONVERT FROM ANGLE -- format (A DD MM SS) -- TO DECIMAL DEGREES.

(DEFUN DDMMSS (ANGLED) 
       (COND ((EQUAL (CAR ANGLED) '-)
	      (-$ 0.0 (DDMMSS (INVERT ANGLED))))
	     (T (+$ (FLOAT (CADR ANGLED))
		    (//$ (+$ (FLOAT (CADDR ANGLED))
			     (//$ (FLOAT (CADDDR ANGLED)) 60.0))
			 60.0))))) 

;;; CONVERT FROM DECIMAL DEGREES TO ANGLE -- format (A DD MM SS).

(DEFUN ANGLED (DDMMSS) 
       (PROG (DD MM SS TMP) 
	     (COND ((< DDMMSS 0.0)
		    (RETURN (INVERT (ANGLED (-$ 0.0 DDMMSS))))))
	     (SETQ DD (FIX DDMMSS) 
		   TMP (*$ 60.0 (-$ DDMMSS (FLOAT DD))) 
		   MM (FIX TMP) 
		   TMP (*$ 60.0 (-$ TMP (FLOAT MM))) 
		   SS (FIX (+$ 0.5 TMP)))
	     (RETURN (LIST '+ DD MM SS)))) 

;;; Calculate true anomaly, given eccentric anomaly.
;;; Also gives first approximation of eccentric anomaly from mean anomaly.
;;; (Provided eccentricty is small)

(DEFUN TRUEANOM (THETA) 
       (*$ 2.0 (ATAND (*$ 1.01686 (TAND (//$ THETA 2.0))) 1.0))) 

;;; Calculate eccentric anomaly from mean anomaly.
;;; Iterative approximation to Kepler's transcendental equation.

(DEFUN ECCENANOM (THETA MEAN) (+$ MEAN (*$ 0.958 (SIND THETA)))) 

;;; Restrict angle to 0.0 to 360.0 degree range.
(DEFUN RANGE (THETA) 
       (COND ((< THETA 0.0) (RANGE (+$ THETA 360.0)))
	     ((> THETA 360.0) (RANGE (-$ THETA 360.0)))
	     (T THETA))) 

(DEFUN SIND (X) (SIN (//$ (*$ 3.14159265 X) 180.0))) 

(DEFUN COSD (X) (COS (//$ (*$ 3.14159265 X) 180.0))) 

(DEFUN ATAND (Y X) 
       (*$ (-$ (//$ (ATAN (-$ 0.0 Y) (-$ 0.0 X)) 3.14159265) 1.0)
	   180.0)) 

(DEFUN TAND (X) (//$ (SIND X) (COSD X))) 

;;; RETURNS RESULT IN RANGE -90 TO +90 DEGREES

(DEFUN ASIND (X) (ATAND X (SQRT (-$ 1.0 (*$ X X))))) 

;;; RETURN RESULT IN RANGE 0 TO 180 DEGREES

(DEFUN ACOSD (X) (ATAND (SQRT (-$ 1.0 (*$ X X))) X)) 

(DEFUN FRACTION (X) (-$ X (FLOAT (FIX X)))) 

;;; ADD OFFSETS TO FIRST COMPONENT OF THREE-LIST.

(DEFUN UPDATE (L OFFSET) (LIST (+ (CAR L) OFFSET) (CADR L) (CADDR L))) 

;;; CALCULATE POSITION OF SUN AT PRESENT TIME, HERE.

(DEFUN SUN-NOW-HERE NIL 
       (SUN LONGITUDE
	    LATITUDE
	    (UPDATE (STATUS DATE) 1900.)
	    (UPDATE (STATUS DAYTIME) GMT-OFFSET))) 

;;; CALCULATE DAY OF WEEK FROM DAYS SINCE 1975/01/01
;;; MONDAY IS 1, TUESDAY IS 2, ... SUNDAY IS 7.

(DEFUN DAY-OF-WEEK (JULIAN) (1+ (REMAINDER (+ JULIAN 2.) 7.))) 

;;; CALCULATE DATE OF LAST SUNDAY IN PRESENT MONTH (WITH N DAYS)

(DEFUN LAST-SUNDAY (DATE N) 
       (- N (PREMUTE (DAY-OF-WEEK (FIX (JULIAN (CONSTRUCT DATE N))))))) 

(DEFUN PREMUTE (N) (COND ((= N 7.) 0.) (T N))) 

(DEFUN CONSTRUCT (DATE N) 
       (CONS (CAR DATE) (CONS (CADR DATE) (CONS N NIL)))) 

;;; TO ADJUST FOR THAT CROCK CALLED DAY-LIGHT-SAVINGS TIME.
;;; SWITCH LAST SUNDAY OF APRIL AND LAST SUNDAY OF OCTOBER (?)
(DEFUN DAY-SAVE-CROCK (DATE) 
       (COND ((OR (< (CADR DATE) 4.)
		  (> (CADR DATE) 10.)
		  (AND (= (CADR DATE) 4.)
		       (< (CADDR DATE) (LAST-SUNDAY DATE 30.)))
		  (AND (= (CADR DATE) 10.)
		       (> (1- (CADDR DATE)) (LAST-SUNDAY DATE 31.))))
	      0.)
	     (T -1.))) 

;;; GEOGRAPHICAL POSITION OF M.I.T. - A.I. LAB AND OFFSET FROM G.M.T.
;;; MODIFY TO YOUR OWN CONVENIENCE AND YOUR OWN LOCATION AND TIME SYSTEM.

(SETQ LONGITUDE '(- 71. 5. 20.)) 

(SETQ LATITUDE '(+ 42. 21. 50.)) 

;;; GIVE NORMAL OFFSET FROM G.M.T. IN HOURS AS SECOND ARGUMENT

(SETQ GMT-OFFSET (+ (DAY-SAVE-CROCK (UPDATE (STATUS DATE) 1900.)) 5.)) 
