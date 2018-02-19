(load 'lisp:gcdemn)
(sstatus ttyint '/~ (function (lambda (a b) (conn-term))))
(defun dungeon ()
  (crlf)
  (princ "Welcome to dungeon version 0.1 (lisp)") (crlf)
  (setq room 1)        ; start off in room one
  (setq state looking) ; player is looking now.
  (setq nobj 6)       ; 5 objects
  (do ((turns 0 (1+ turns)))
      ((eq state dying) ())
    (cond
      ((eq state looking)      ;person is looking or in new room.
	  (printrm) (setq state input)) ;print room and put in input.
      ((eq state input)         ;person is in input.
      (crlf)
       (princ ">")              ;print prompt.
       (setq cmd nil)
       (setq line (readline))
       (setq long-cmd (list-words line))
       (do ((foo 0 (1+ foo)))
	   ((eq foo (count long-cmd)))
	 (setq cmd (append (nreverse 
			    (list (parse (nth foo long-cmd)))) cmd)))
      (setq cmd (reverse cmd))
       (setq words (count cmd))
       (setq verb (car cmd))
	 (listen)))))




 
(defun crlf ()
  (princ "
"))

(defun printrm ()
  (setq specials '(1 13 22 23))
  (cond ((and (not (member room light-rooms)) (eq lamp 'off))
	 (princ "It is now pitch dark, but that is okay since the grues here are friendly."))
	(t
	 (cond (
		(or (member room visited) (eq mode 'superb))
		(princ (disp 13 (disp room moveto)))
		(cond
		 ((eq mode 'superb)
		  (cond ((not (member room visited))
			 (setq visited (add room visited)))))))
	       
	       (t (princ (disp room rooms)) 
		  (cond ((not (member room visited))
			 (setq visited (add room visited))))))
	 (cond ((member room specials)
		(cond (
		       (eq room 1)
		       (cond (
			      (member 6 visited)
			      (crlf)
			      (princ "There is a secret passage to the south."))))
		      ((eq room 13)
		       (cond (
			      (eq breaking-beam 3)
			      (crlf)
			      (princ "There is a passage to the north."))))
		      ((eq room 22)
		       (cond (
			      (eq top-of-stairs-wall 'open)
			      (crlf)
			      (princ "The wall has been pushed aside and there is a passage to the east."))))
		      ((eq room 23)
		       (cond (
			      (eq top-of-stairs-wall 'open)
			      (crlf) (princ "The wall closes behind you.")
			      (setq top-of-stairs-wall 'closed)))))))
	 
	 (cond (
		(not (eq (disp room items) 0))
		(do ((foo 1 (1+ foo)))
		    ((= foo (1+ (count (disp room items)))) ())
		  (cond ((not (greaterp (disp foo (disp room items)) 200))
			 (crlf)
			 (princ (disp (disp foo (disp room items)) objdes))))))))))

(defun disp (x l)
  (cond
   ((zerop
     (sub1 x))
    (car l))
   (t
    (disp (sub1 x)
	 (cdr l)))))
(defun add (data list)
(setq list (cons data list)))
(setq rooms (quote (
;room one
"You are standing in front of a fork in a dirt path. The paths lead
to the northeast and northwest, and the northwest one seems much more
used. On the northeast path you can barely make out the tracks of
an unknown animal. "
;Room two
"You are midway along the northeast path. As you travel further you
notice that the footprints get more and more detailed and eventually
you realize that they are not footprints at all. It looks like something
long and stringy was dragged along. The passage continues northeast
and southwest."
;Room three
"You have come to the end of the northeast path. The only way out
is to the southwest. To the north there is what appears to be an
electric fence."
;Room four
"You are midway down the northwest passage. The path continues to the
northwest and southeast."
;room five
"You have reached the end of the northwest passage. There is a sign
here that reads: ``Over yonder, unless you say a special phrase, you
will probably be fried.''"
;room six {computer room}
"You are in what appears to be a computer room at the Massachusetts
Institute of Technology. There are wires all over the place and
traces of once winning lisp machines. Nearby, there is a small
cabinet which contains some organized wires. Also nearby, there is
a Decscope console and a sign above it reads:
                 To type on the console, issue the
                 command CONSOLE." 
                 ;Room seven, Welcome to the dungeon!
"You are in a large room which seems to have only a stairway in it.
The stairway leads up."

;Room eight, where Chaosnet is found!
"You have entered a wall!"



;Room nine, cave entrance.
"You are standing on a strange cement structure with a stairway
leading down. To the north is the entrance to a cave."

;room ten, Cave
"You are standing in the entrance to a cave. A passage leads further
into the cave to the north, while there is a path leading back to
a cement structure to the south."
;room 11, Solar room
"You have entered a large brick-lined room with a very bright lamp lit
on the ceiling. The beam strikes the ground in the middle of the floor
onto some kind of symbol that you can't make out in the brightness.
Also, on the wall there is a large circular piece of silicon."
;room 12, gold room
"You are in a room with nothing in it except a sign that says ``Gold Room''
and there is a passage leading out to the north."
;room 13, junction.
"You are at the junction of north and east passages."
;room 14, north passage.
"You are in a N//S passage."
;room 15, dead end
"Dead end."
;room 16 East passage
"You are in an E//W passage. A small hole leads to the north."
;room 17 stairs 
"You are at the foot of a stairway leading upwards."
;room 18 brick wall
"You are at the top of the stairs. The stairs apparently didn't lead
into anything except a brick wall."
;room 19 Kitchen
"You have emerged into the kitchen of a house. Everything in the
room (the cupboards and the fridge) seems to be empty. There is
a door leading out to the east."
;room 20 under dev.
"Under development at this time...go back!")))

(setq objdes (quote ("There is a chaosnet connection here."
		     "There is a battery-powered lamp here."
		     "There is a hand-held mirror here."
                     "There is a shovel here."
		     "There is a sparkling nugget of gold here!"
		     "There is some food here.")))
(setq objshd (quote ("chaosnet" "lamp" "mirror" "shovel" "gold" "food")))
(setq filest '("chaos.obj" "lamp.obj" "mirror.obj" "shovel.obj" "food.obj"))
(setq looking (quote looking))
(setq input (quote input))
(setq dying (quote dying))
(defun count (x)
  (cond
   ((null x) 0) ((atom x) 1) (t (apply 'plus (mapcar 'count x)))))	

(setq funlst '((n . north) (s . south) (e . east) (w . west) (ne .ne)
			  (se . se) (nw . nw) (u . up) (d . down) (up .up)
			  (down . down) (north .north) (south .south)
			  (east . east) (west .west) (l . look) (sw . sw)  
		      (look . look) (score .score) (quit . quit) (get.take)
		      (take . take) (i . i) (invent . i) (drop . drop)
		      (throw . drop) (a . a) (consol . console) (off . off)
		      (superb . superb) (brief . brief) (on . on)
		      (put . put) (light . light) (exting . exting)
		      (dig . dig) (read . examin) (examin . examin)
		      (wave . wave) (eat . eat)))

(defun listen ()
  (setq func (cdr (assq verb funlst)))
(cond (
       (eq nil func) (princ "I don't know that word!"))
      (t
  (apply func ()))))
(setq inventory NIL)
(defun n () (north))
(defun s () (south))
(defun e () (east))
(defun w () (west))
(defun u () (up))
(defun d () (down))
(defun l () (look))
(defun north () (move 1))
(defun south () (move 2))
(defun east () (move 3))
(defun west () (move 4))
(defun ne () (move 5))
(defun se () (move 6))
(defun nw () (move 7))
(defun sw () (move 10))
(defun up () (move 11))
(defun down () (move 12))
(defun move (ndir)
  (cond ((and (not (member room light-rooms)) (not (eq lamp 'on)))
	 (princ "You trip over a friendly grue and fall into a large pit and
break every bone in your body.") (quit))
	(t
	 (setq nroom (nth (- ndir 1) (nth (- room 1) moveto)))
	 (cond
	  ((eq nroom 0)
	   (princ "There is a wall there.")
	   (setq state input))
	  ((eq nroom 77)
	   (cond (
		  (= room 3)
		  (cond (
			 (eq gate 'open)
			 (setq room 6) 
			 (setq state looking))
			(t (princ "You bumb into the electric gate and are electricuted.")
			   (quit))))
		 (
		  (= room 1)
		  (cond (
			 (eq gate 'open)
			 (setq room 10)
			 (setq state looking))
			(t (princ "There is a wall there."))))
		 (
		  (= room 13)
		  (cond (
			 (eq breaking-beam 3) (setq room 14)
			 (setq state looking))
			(t (princ "There is a wall there."))))
		 (
		  (= room 22)
		  (cond ((eq top-of-stairs-wall 'open)
			 (setq room 23)
			 (setq state looking))
			(t (princ "There is a wall there."))))))
	  
	 (t
	  (setq room nroom)
	  (setq state looking))))))

(setq moveto (quote (
		     (0 77 0 0 2 0 4 0 0 0 "Fork")       ;1
		     (0 0 0 0 3 0 0 1 0 0 "Ne passage")  ;2
		     (77 0 0 0 0 0 0 2 0 0 "End of Ne passage") ;3
		     (0 0 0 0 0 1 5 0 0 0 "Nw passage")        ;4
		     (0 0 0 0 0 4 0 0 0 0 "End of Se passage");5
		     (0 3 0 0 0 0 0 0 0 0 "Computer room");6
		     (0 0 0 0 0 0 0 0 11 0 "Dungeon");7
		     (1 0 0 0 0 0 0 0 0 0 "Wall");10
		     (12 0 0 0 0 0 0 0 0 7 "Top of structure");11
		     (13 11 0 0 0 0 0 0 0 0 "Cave entrance");12
		     (77 12 0 0 0 0 0 0 0 0 "Light room");13
		     (15 13 0 0 0 0 0 0 0 0 "Gold room");14
		     (16 14 20 0 0 0 0 0 0 0 "N-E junction");15
		     (17 15 0 0 0 0 0 0 0 0 "N-S passage");16
		     (0 16 0 0 0 0 0 0 0 0 "Dead end");17
		     (0 0 21 15 0 0 0 0 0 0 "E-W passage");20
		     (0 0 0 20 0 0 0 0 22 0 "Foot of stairs");21
		     (0 0 77 0 0 0 0 0 0 21 "Top of stairs");22
		     (0 0 24 0 0 0 0 0 0 0 "Kitchen");23
		     (0 0 0 23 0 0 0 0 0 0 "Under development"))));24

(defun look ()
  (setq visited (rem room visited))
  (setq omode mode) 
  (setq mode 'brief) (printrm) (setq mode omode))

(defun score ()
  (crlf) (princ "You have scored ") (princ score)
		(princ " points out of a possible ")(princ max-score)
		(princ " using ")
  (princ turns)
  (princ " turns."))

(defun quit ()
  (score) (crlf) 
  (cond ((greaterp room 6)
	 (princ "Connection closed by foreign host
TELNET>")
	 (crlf) (princ "Suddenly you realize that you can no longer take the
agony of defeat. You grab on to one of the losing lisp machines, rip out the
power supply and calmly put your hand where the AC cord meets the device.")))

  (setq state dying))

(defun take ()
  
  (setq obj (disp 2 cmd))
  
  (cond (
	 (eq obj nil)
	 (princ verb) (princ " what?"))
	(
	 (eq obj 'all)
	 (setq cmd '(foo bar))
	 (cond (
		(eq (disp room items) 0)
		(princ "I found nothing.") (crlf))
	       (t
		(do ((foo 1 (1+ foo)))
		    ((eq (disp room items) 0))
		  (princ (disp (disp 1 (disp room items)) objshd))
		  (princ "  ")
		  (setq all (disp 1 (disp room items)))
		  (take) (crlf)))))
	 (t
  (setq objnum (objref obj))
  (cond (
	 (not (eq all nil))
	 (setq objnum all)
	 (setq all nil)))
  (cond
   ((member objnum inventory) (princ "You already have it, wedge!")
				  (setq foo 1))
   ((atom (disp room items)) (princ "I can't see anything here, let alone a ") (princ obj))

  
   ((member objnum (disp room items))
    (cond (
	   (greaterp objnum 200)
	   (cond (
		  (eq objnum 201) (princ "The piece of silicon is stuck to the wall"))
		 (
		  (eq objnum 202) (princ "You can't remove a piece of the floor!"))))
	  (t
	   (princ "Taken.") 
	   (cond
	    ((eq breaking-beam objnum)
	     (setq breaking-beam nil)
	     (setq beam 'shining) (crlf)
	     (cond ((eq objnum 3)
		    (princ "The beam now hits the floor and the passage disappears"))
		   (t
		    (princ "The beam once again hits the floor")))))
	   (cond
	    ((not (eq (car (assq objnum treasure-items)) nil))
	     (cond (
		    (not (member objnum scored))
		    (setq scored (add objnum scored))
		    (setq score (+ score (cdr (assq objnum treasure-items))))))))
	   (rid objnum) (setq inventory (add objnum inventory)))))
   (t
    (princ "I can't see that here."))))))

(defun objref (obj)
  (setq foo 200)
  (cond
   ((or (eq obj (quote chaos)) (eq obj (quote net)) (eq obj 'connection))
	(setq foo 1))
   ((or (eq obj 'light) (eq obj 'lamp) (eq obj 'battery))
    (setq foo 2))
   ((or (eq obj 'silico) (eq obj 'chip) (eq obj 'solar))
    (setq foo 201))
   ((eq obj 'mirror) (setq foo 3))
   ((eq obj 'shovel) (setq foo 4))
   ((or (eq obj 'gold) (eq obj 'nugget)) (setq foo 5))
   ((or (eq obj 'symbol) (eq obj 'floor)) (setq foo 202))
   ((eq obj 'food) (setq foo 6))
   (t 200)))

(defun locobj (objnum)
  (setq foo 200)
  (cond
   ((not (= objnum 200)) (setq foo (disp objnum objloc)))))


(defun invent () (i))
(defun throw () (drop))
(defun i ()
  (cond
   ((eq inventory nil)
    (princ "You have nothing."))
    ((not (eq inventory nil))
  (do ((foo 1 (1+ foo)))
      ((= foo (1+ (count inventory))))
    (princ (disp (disp foo inventory) objshd)(crlf))))))
   
(defun drop ()
  (setq obj (disp 2 cmd))
  (setq objnum (objref obj))
  (cond (
	 (eq obj nil)
	 (princ verb) (princ " what?"))
	(t
	 (cond (
	  (member objnum inventory)
	  (setq inventory (rem objnum inventory))
	  (place objnum) (princ "Dropped."))
	       (t
		(Princ "You don't have that."))))))
   
(setq items                              
 '((2) 0 0 0 0 0 0 (1) 0 (3) (201 202) 0 0 0 (4) 0 0 0 (6)))
(defun rem (a l)
  (cond
   ((null l) ())
   ((eq (car l) a)
    (cdr l))
   (t
    (cons (car l)
	  (rem a (cdr l))))))
  

 (defun rid (objnum)
   (setq spare-list nil)
   (setq foofl 1)
   (do ((foo 1 (1+ foo)))
       ((= foo room) ())
       (setq spare-list (add (disp foo items) spare-list)))
   (setq foob (rem objnum (disp room items)))
   (cond ((eq foob nil) (setq foob 0)))
   (setq spare-list (add foob spare-list))
     (do ((foo (1+ room) (1+ foo)))
       ((= foo (1+ (count items))) ())
     (setq spare-list (add (disp foo items) spare-list)))
   (setq items (reverse spare-list)))

(setq visited nil)

(defun place (objnum)
   (setq spare-list nil)
   (do ((foo 1 (1+ foo)))
       ((= foo room) ())
     (setq spare-list (add (disp foo items) spare-list)))
   (setq foob (disp room items)) (cond ((eq foob 0) (setq foob nil)))
   (setq spare-list (add (add objnum foob) spare-list))
   (do ((foo (1+ room) (1+ foo)))
       ((= foo (1+ (count items))) ())
     (setq spare-list (add (disp foo items) spare-list)))
      (setq items (reverse spare-list)))



(setq foofl 0)

(setq gate 'closed)

(defun a ()
  
  (cond
   ((eq (disp 2 cmd) 'specia)
   (setq gate 'open)
(princ "In the distance, a humming noise that you hadn't noticed before, stops."))
   (t
    (princ "I don't understand that!"))))

(defun console ()
  (cond (
	 (= room 6)
	 (cond (
		(eq inventory nil)
		(setq foo nil))
	       ((member 1 inventory)
		(setq foo T))
	       (t
		(setq f nil)))
	 (readch)
	 (cond (
		(greaterp room 7)
		(setq sys 'dungeon))
	       (t
		(setq sys 'sally)))
	 (tops20 sys foo))))

(load "<nessus.s.lisp.lib>plib")
(valret "define comred: isis:
define isisdev: isis:
continue
")



(load "isis:comred")
(load "isis:macros")
(defspec command nil "Command" 
"Unrecognized command - does not match switch or keyword")
(defspec info nil "Info keyword" "Does not match switch or keyword ")
(defspec tnet nil "Command" 
"Unrecognized command - does not match switch or keyword")
(defspec connect nil "Network name" "Network not found")
(defspec chaos nil "Chaosnet host" "No chaosnet host matches that input")
(defspec arpa  nil "Arpanet host" "Not an arpanet host")
(defspec ftp nil "Ftp command" "?Not a valid FTP command")
(comspec-add-items 'ftp '(connect bye login send) t)
(comspec-add-items 'info '(directory arpanet chaosnet) t)
(comspec-add-items 'command '(tn telnet ftp directory return information) t)
(comspec-add-items 'tnet '(connect exit) t)
(comspec-add-items 'connect '(arpanet chaosnet) t)
(comspec-add-items 'chaos '(dungeon dragon) t)
(comspec-add-items 'arpa '(endgame mit-sally) t)

(defun tops20 (sys imp)
  
  (setq comm nil)
  (terpri) (princ "Tops-20 Command Processor 0(a1)")
  (terpri) (princ "[Command RETURN defined]")
    (do ((foo ()))
      ((eq comm 'return))
      
      (let-comred "@"
			     (return (prog1 
				      (setq comm (comred 'command)
			       )
	
    (cond (
	   (eq comm 'directory)
	   (comred-force-guideword "Of files")
	   (comred 'confirm)
	   (princ
"
ps:<luser>
")
	   (do ((foo 1 (1+ foo)))
	       ((= foo (1+ (count inventory))) ())
	       (princ (nth (1- (nth (1- foo) inventory)) objshd))
	       (princ ".obj.1")
	       (setq files foo)
	     (crlf))
	   (crlf) (princ "Total of ") (princ files) (princ " files"))

(
           (eq comm 'ftp)
	   (cond (
		  (eq sys 'bally)
		  (princ "Ftp not available on Mit-Sally")
		  (princ ", sorry.") (crlf))
		 (t
		  (princ "MIT-") (princ sys)
		  (princ " FTP service") (crlf)
		  (let-comred "*" (return (prog1 
				      (setq fomm (comred 'ftp))
	   (cond (
		  (eq fomm 'connect)
		  (comred-force-guideword "To host")
		  (setq concmd (comred 'ftpcon))
		  (cond (
			 (eq concmd sys)
			 (princ "Cannot connect to your own system, silly"))
			(t
			 (princ "Connection opened. Assuming Object-file-transfer")
			 (setq connected t)
			 (princ "-> ") (princ concmd) (princ " ftp service"))))
		 (
		  (eq fomm 'login)
		  (comred-force-guideword "Username")
		  (setq name (comred 'text-string))
		  (comred-force-guideword "Password")
		  (setq pass (comred 'text-string))
		  (cond (
			 (neq name 'luser)
			 (princ "-> Does not match directory or username"))
			(t
			 (cond (
			  (neq pass 'resul)
			  (princ "-> ?Invalid Password"))
			       (t
				(Princ "-> User LUSER Logged in")
				(setq login t))))))
		 (					
		  (eq fomm 'send)
		  (comred-force-guideword "From local file")
		  (defspec files nil "File name" "File not found")
		  (do ((foo 1 (1+ foo)))
		      ((eq foo (1+ (count inventory))))
		    (setq ob (nth (1- (nth (1- foo) inventory)) objshd))
		    (setq barf (implode (nconc (exploden ob)
					       (exploden ".obj"))))
		    (comspec-add-items 'files (list barf) t))
		  (setq file (comred 'files))
		  (setq ob (cdr (plib:sassoc file filest)))
		  (setq frob room)
		  (setq room (cdr (assq concmd hostroom)))
		  (place (objref ob))
		  (setq room frob)))))))))

	   ((eq comm 'information)
	   (comred-force-guideword "About")
	   (setq sinfo (comred 'info))
	   (comred 'confirm)
	   (cond (
		  (eq sinfo 'directory)
		  (princ 
"Name Ps:<Luser>
Password - RESUL
Working disk storage page limit - 0
Perminant disk storage page limit - 0
Chaos-net-user
Absolute-arpanet-sockets
Account default set for LOGIN players
Last login - Never logged in
"))
		 (
		  (eq sinfo 'arpanet)
		  (princ "%No arpanet"))
		 (
		  (eq sinfo 'chaosnet)
		  (cond (
			(not (eq imp t))
			(princ "The imp is down."))
			(t
		  (princ "The imp is up"))))))

	  ((or (eq comm 'tn) (eq comm 'telnet))
	   (comred 'confirm)
	   (setq cmd nil)
	   (do ((loop-var 0 ()))
	       ((eq cmd 'exit) ())
	  (setq telnet-mode
		(let-comred "TELNET>"
			    (setq cmd (comred 'tnet))
			    (cond (
				   (and (not (eq cmd nil)) 
					(not (eq cmd 'exit)))

			    (comred-force-guideword "Network")
			    (setq ccom (comred 'connect))
			    (cond (
				   (eq ccom 'arpanet)
				    (comred-force-guideword "host")
				    (setq foo (comred 'arpa))
				    (comred 'confirm)
				    (princ "Trying...")
				    (sleep 2) (princ "Refused"))
				  (t
				   (comred-force-guideword "host")
				   (setq foo (comred 'chaos))
				   (comred 'confirm)
				   (cond ((eq foo 'dungeon)
					 (princ "Trying...")
					 (sleep 2)
					 (cond (
						(eq imp t)
						(princ "open")
     			(setq room 7) (setq cmd 'exit) (setq comm 'return)
			(setq state looking) (terpri))
					       (t
						(princ "no chaosnet"))))
					 (t
					  (princ "Trying...")
					  (sleep 2)
					  (princ "Refused")))))))))))))))))

(load "isis:chars")
(load "<maclisp>let")
(load "<maclisp>format")
(load "isis:misc")
(comred-initialize)
(setq all nil)
(setq mode 'brief)
(defun superb ()
  (setq mode 'superb) (princ "Short descriptions only."))
(defun brief ()
  (setq mode 'brief) (Princ "Full descriptions first time, short descriptions after."))
(defun put ()
  (setq obj (disp 2 cmd))
  (setq prep (disp 3 cmd))
  (setq where (disp 4 cmd))
  (cond (
	 (eq obj nil)
	 (princ "I need a direct object."))
	(
	 (eq prep nil)
	 (princ "I need a preposition."))
	(
	 (eq where nil)
	 (princ "You didn't tell me where to put it."))
	(t
	 (setq objnum (objref obj))
	 (cond (
		(not (member objnum inventory))
		(princ "You don't have that."))
	       (t
		(cond (
		       (eq where 'beam)
		       (cond (
			      (eq room 13)
			      (place objnum) 
			      (setq inventory (rem objnum inventory))
			      (setq breaking-beam objnum)
			      (setq beam 'broken)
			      (cond (
				     (eq objnum 3)
				     (princ
 "The beam hits the mirror, reflects off, hits the solar cell and a door
opens to the north.")
				     (setq beam 'broken))
				    (t
				     (setq beam 'broken)
				     (princ "The beam is now blocked."))))
			      (t
			       (princ "I see no beam here."))))
		       (t
			(princ "You can't put that there...dropping")
			(place objnum) (setq inventory (rem objnum inventory))
			)))))))


(setq beam nil)
(setq light-rooms '(1 2 3 4 5 6 8))
(defun light ()
  (setq obj (disp 2 cmd))
  (setq objnum (objref obj))
  (cond (
	 (not (member objnum inventory))
	 (princ "You don't have that."))
        (
	 (not (eq obj 'lamp))
	 (princ "You can't light that."))
	(t
	 (princ "Your lamp is now on.") (crlf) 
	 (setq lamp 'on)
	 (cond (
		(not (member room light-rooms))
		(look))))))


(defun exting ()
  (setq obj (disp 2 cmd))
  (setq objnum (objref obj))
  (cond (
	 (not (member objnum inventory))
	 (princ "You don't have that."))
	(
	 (not (eq obj 'lamp))
	 (princ "You can't extinguish that."))
	(t
	 (princ "Your lamp is now off.")
	 (crlf)
	 (setq lamp 'off)
	 (cond (
		(not (member room light-rooms))
		(printrm))))))

(setq lamp 'off)
(defun dig ()
  (cond (
   (not (member 4 inventory))
   (princ "You have nothing to dig with."))
	(t
	 (cond (
		(and (eq room 14) (not (eq dug 'dug)))
		(princ "I think you found something!")
		(place 5) (setq dug 'dug))
	       (t
		(princ "The ground is too hard to dig here."))))))

(setq score 0)
(setq max-score 10)
(setq treasure-items '((5 . 10)))
(setq scored nil) 
(setq dug nil)
(defun parse (word)
  (let (a b) 
    (setq a (explode word))
    (setq b nil)
    (do ((foo 0 (1+ foo)))
	((or (eq (nth foo a) nil) (eq foo 6)) ())
      (setq b (add (nth foo a) b)))
    (implode (reverse b))))

(defun on ()
  (setq cmd '(light lamp))
  (light))

(defun off ()
  (setq cmd '(exting lamp))
  (exting))

(defun examin ()
  (let (objnum obj)
    (setq obj (disp 2 cmd))
    (setq objnum (objref obj))
    (cond (
	   (and (not (member objnum inventory)) (not (member objnum
						     (disp room items))))
	   (princ "I don't see that here."))
	  (t
	   (cond (
		  (eq objnum 202)
		  (cond (
			 (eq beam 'broken)
			 (princ "The insciption says: The shovel has more than one purpose"))
			(t
			 (princ "It is too bright in here."))))
		  (t
		   (princ "I don't see anything peculiar about it.")))))))

(defun wave ()
  (let (obj objnum)
    (setq obj (disp 2 cmd))
    (setq objnum (objref obj))
    (cond (
	   (not (member objnum inventory))
	   (princ "You don't have that."))
	  (t
	   (cond (
		  (or (not (eq room 22)) (not (eq objnum 4)))
		  (princ "As you wave the ") (princ (disp objnum objshd))
		  (princ " the air seems to move with it!"))
		 (t
		  (cond (
			 (eq objnum 4)
			 (setq top-of-stairs-wall 'open)
			 (princ "The wall opens to the east.")))))))))
(setq beam 'shining)
(setq breaking-beam nil)
(setq top-of-stairs-wall 'food)

(defun int (char)
  (cond (
	 (greaterp room 6)
	 (setq ch (readch))
	 (cond (
		(eq ch '/c)
		(setq room 6)
		(crlf)
		(princ "Connection closed by foreign host")
		(crlf)
		(tops20 'back))))))

(defun list-words (line)
  (cond ((not (eq (count (explode line)) 2))
  (readlist (nreverse (cons ")" 
			    (cdr (nreverse (cons "(" 
						 (cdr (explode line)))))))))
	(t
	 (cond (
		(not (member '/| (explode line)))
	 (readlist (reverse (cons ")" (reverse (cons "(" (cdr (explode line))))))))))))
(defun eat ()
  (let (obj objnum troom)
    (setq obj (disp 2 cmd))
    (setq objnum (objref obj))
    (cond (
	   (eq objnum 6)
	   (princ "MMmmmmm... That tastes good!!!!!")
	   (setq troom room)
	   (setq inventory (rem 6 inventory)))
	  (t
	   (princ "You try desperately to shove the ")
	   (princ (disp objnum objshd))
	   (princ " down your throat, but it just won't go.")))))
(defun conn-term ()
  (cond (
	 (not (member room light-rooms))
	 (setq chr (readchr))
	 (cond (
		(and (not (eq chr '/c)) (not (eq chr '/C)))
		(princ ""))
	       (t
		(crlf) (crlf)
		(princ "Connection closed.")
		(setq room 6)
		(crlf)
		(princ "Some force throws you off the console"))))))