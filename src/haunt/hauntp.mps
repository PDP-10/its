
(SYSTEM 
 (READ (TIME IS =X) 
  & =A --> (<DELETE> =A)
  (<WRITE> | |)  (INPUT (<READ>)) 
  (TIME IS (<TIME-INCR> =X 2)) READ))

(SYSTEM 
 ((INPUT ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> (<wrong> =X))))

(SYSTEM 
 ((INPUT =A =X)
  & =B (PLACE ! =Y)
  (IN =X ! /#Y)
  --> (<DELETE> =B)
  (<WRITE> |The| (<CAPTOSM> =X) |is not here.|)))

(SYSTEM 
((INPUT news) & =A --> (<DELETE> =A) 
(<WRITE> |Version 4.6, 6-21-82|)
(<WRITE> |As always, a few more bugs have been fixed.|)
(<WRITE> |Send gripes to John.Laird@CMUA.|)
(<WRITE> |Or John Laird, Computer Science Department, Carnegie-Mellon University|)
(<WRITE> |	Pittsburgh, Pa. 15213|)
(<WRITE> |The max score is 440.|)
(<WRITE> |Copyright (C) 1979,1980,1981,1982 John E. Laird|)))

(SYSTEM
 ((INPUT XSTAT) & =A --> (<DELETE> =A) (<HALT>)))

(SYSTEM 
 ((PLACE ! =X)
  (WASAT ! =X)
  --> (<WRITE> |You are in|  (<CAPTOSM> ! =X) |.|)))

(SYSTEM 
 ((INPUT)
  & =A --> (<DELETE> =A)
  (<WRITE> (<SENTENCE> NO-INPUT-ATN))))

(SYSTEM 
 ((INPUT =X =Y ON) & =A --> (INPUT =X ON =Y) (<DELETE> =A)))

(SYSTEM 
 ((INPUT =X =Y OFF) & =A --> (INPUT =X OFF =Y) (<DELETE> =A)))

(SYSTEM 
  ((PLACE ! =X) & =A (INPUT GAMMA ! =Y) & =B --> 
  (<DELETE> =A)
  (<DELETE> =B)
  (PLACE ! =Y)))

(SYSTEM 
 ((INPUT =X THE ! =Y) & =A --> (<DELETE> =A) (INPUT =X ! =Y)))

(SYSTEM 
 ((INPUT =X =Y THE ! =Z)
  & =A --> (<DELETE> =A)
  (INPUT =X =Y ! =Z)))

(SYSTEM 
 ((INPUT =X A ! =Y) & =A --> (<DELETE> =A) (INPUT =X ! =Y)))

(SYSTEM 
 ((INPUT =X THEN ! =Y)
  (Input =X THEN ! =Y)
  (INPUT =X THEN ! =Y) & =Z (TIME IS =Q) -->
  (<DELETE> =Z)
  (INPUT =X)
  (TIME IS =Q)
  (INPUT THEN ! =Y)))

(SYSTEM 
 ((INPUT =X =Y THEN ! =Z)
  (INPUT =X =Y THEN ! =Z)
  (INPUT =X =Y THEN ! =Z)
  & =Q (TIME IS =W) --> 
  (<DELETE> =Q)
  (INPUT =X =Y)
  (TIME IS =W)
  (INPUT THEN ! =Z)))

(SYSTEM 
 ((INPUT =X =Y THEN =W IT ! =Z)
  (INPUT =X =Y THEN =W IT ! =Z)
  (INPUT =X =Y THEN =W IT ! =Z) & =Q 
  (TIME IS =T) --> 
  (<DELETE> =Q)
  (INPUT =X =Y)
  (TIME IS =T)
  (INPUT THEN =W =Y ! =Z)))

(SYSTEM 
  ((INPUT =X =Y =N THEN ! =Z)
  (INPUT =X =Y =N THEN ! =Z)
 (<not> (INPUT =X  then =N THEN ! =Z))
  & =Q (TIME IS =W) --> 
  (<DELETE> =Q)
  (INPUT =X =Y =N)
  (TIME IS =W)
  (INPUT THEN ! =Z)))

(SYSTEM 
 ((INPUT THEN ! =Z) 
  (INPUT THEN ! =Z)
  (INPUT THEN ! =Z)
  (INPUT THEN ! =Z) & =A 
  (TIME IS =Y) & =B --> (<DELETE> =B) (<DELETE> =A)
  (INPUT ! =Z) (time is (<time-incr> =Y 2))))

(SYSTEM 
 ((INPUT =X it ! =W) (INPUT =X IT ! =W)  & =A (HOLDS  =Y)
  --> (<DELETE> =A)
  (INPUT =X =Y ! =W)))

(SYSTEM 
((PLACE ! =Z)
 (INPUT =X IT ! =W)
 (INPUT =X it ! =W)
  & =A (IN =Y ! =Z)
  --> (<DELETE> =A)
  (INPUT =X =Y ! =W)))

(SYSTEM 
((INPUT N) & =A --> (<DELETE> =A) (GOING N) (WENT N)))

(SYSTEM 
((INPUT S) & =A --> (<DELETE> =A) (GOING S) (WENT S)))

(SYSTEM 
((INPUT E) & =A --> (<DELETE> =A) (GOING E) (WENT E)))

(SYSTEM 
((INPUT W) & =A --> (<DELETE> =A) (GOING W) (WENT W)))

(SYSTEM 
((INPUT U) & =A --> (<DELETE> =A) (GOING U) (WENT U)))

(SYSTEM 
((INPUT D) & =A --> (<DELETE> =A) (GOING D) (WENT D)))

(SYSTEM 
 ((INPUT (<any> OUT LEAVE)  ! =X) & =A --> (INPUT EXIT ! =X) (<DELETE> =A)))

(SYSTEM 
 ((INPUT get in ! =X) & =A --> (<DELETE> =A)  (INPUT enter ! =X)))

(SYSTEM 
 ((INPUT (<ANY> WALKIN IN INSIDE) ! =X) & =A --> (<DELETE> =A) (INPUT ENTER ! =X)))

(SYSTEM 
 ((INPUT GO ! =X) & =A --> (<DELETE> =A) (INPUT ! =X)))

(SYSTEM 
((INPUT WEST) & =A --> (<DELETE> =A) (GOING W) (WENT W)))

(SYSTEM 
((INPUT EAST) & =A --> (<DELETE> =A) (GOING E) (WENT E)))

(SYSTEM 
((INPUT NORTH) & =A --> (<DELETE> =A) (GOING N) (WENT N)))

(SYSTEM 
((INPUT SOUTH) & =A --> (<DELETE> =A) (GOING S) (WENT S)))

(SYSTEM 
((INPUT UP) & =A --> (<DELETE> =A) (GOING U) (WENT U)))

(SYSTEM 
((INPUT DOWN) & =A --> (<DELETE> =A) (GOING D) (WENT D)))

(SYSTEM 
((GOING N) --> NOWAY))

(SYSTEM 
((GOING S) --> NOWAY))

(SYSTEM 
((GOING W) --> NOWAY))

(SYSTEM 
((GOING E) --> NOWAY))

(SYSTEM 
((GOING D) & =A --> (<DELETE> =A) (<WRITE> |You can't go down from here.|)))

(SYSTEM 
((GOING U) & =A --> (<DELETE> =A) (<WRITE> |There is nothing to go up on.|)))

(SYSTEM 
 (NOWAY
  & =A (GOING =N)
  & =C --> (<WRITE> (<SENTENCE> BAD-DIRECTION-ATN))
  (<DELETE> =C)
  (<DELETE> =A)))

(SYSTEM 
 ((WENT W) (INPUT RIGHT) & =B --> (GOING N) (WENT N) (<DELETE> =B)))

(SYSTEM 
 ((WENT W) (INPUT FORWARD) & =B --> (GOING W) (WENT W) (<DELETE> =B)))

(SYSTEM 
 ((WENT S) (INPUT LEFT) & =B --> (GOING E) (WENT E) (<DELETE> =B)))

(SYSTEM 
 ((WENT E) (INPUT LEFT) & =B --> (GOING N) (WENT N) (<DELETE> =B)))

(SYSTEM 
 ((WENT E) (INPUT RIGHT) & =B --> (GOING S) (WENT S) (<DELETE> =B)))

(SYSTEM 
 ((WENT E) (INPUT FORWARD) & =B --> (GOING E) (WENT E) (<DELETE> =B)))

(SYSTEM 
 ((WENT E) (INPUT BACK) & =B --> (GOING W) (WENT W) (<DELETE> =B)))

(SYSTEM 
 ((WENT S) (INPUT RIGHT) & =B --> (GOING W) (WENT W) (<DELETE> =B)))

(SYSTEM 
 ((WENT S) (INPUT FORWARD) & =B --> (GOING S) (WENT S) (<DELETE> =B)))

(SYSTEM 
 ((WENT S) (INPUT BACK) & =B --> (GOING N) (WENT N) (<DELETE> =B)))

(SYSTEM 
 ((WENT N) (INPUT LEFT) & =B --> (GOING W) (WENT W) (<DELETE> =B)))

(SYSTEM 
 ((WENT N) (INPUT RIGHT) & =B --> (GOING E) (WENT E) (<DELETE> =B)))

(SYSTEM 
 ((WENT N) (INPUT FORWARD) & =B --> (GOING N) (WENT N) (<DELETE> =B)))

(SYSTEM 
 ((WENT N) (INPUT BACK) & =B --> (GOING S) (WENT S) (<DELETE> =B)))

(SYSTEM 
 ((WENT W) (INPUT LEFT) & =B --> (GOING S) (WENT S) (<DELETE> =B)))

(SYSTEM 
 ((WENT U) (INPUT FORWARD) & =B --> (GOING U) (WENT U) (<DELETE> =B)))

(SYSTEM 
 ((WENT D) (INPUT FORWARD) & =B --> (GOING D) (WENT D) (<DELETE> =B)))

(SYSTEM 
 ((WENT U) (INPUT BACK) & =B --> (GOING D) (WENT D) (<DELETE> =B)))

(SYSTEM 
 ((WENT D) (INPUT BACK) & =B --> (GOING U) (WENT U) (<DELETE> =B)))

(SYSTEM 
 ((WENT W) (INPUT BACK) & =B --> (GOING E) (WENT E) (<DELETE> =B)))

(SYSTEM 
 ((INPUT AHEAD) & =A --> (<DELETE> =A) (INPUT FORWARD)))

(SYSTEM 
 ((INPUT DIRECTION ! =X)
  & =A (WENT =Y)
  --> (<DELETE> =A)
  (<WRITE> |You are facing | =Y)))

(SYSTEM 
 ((INPUT EXIT ! =X) & =A --> (<DELETE> =A) (INPUT BACK)))

(SYSTEM 
 ((INPUT ENTER ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |I don't know how to enter| (<captosm> ! =X)|.|)))

(SYSTEM 
((INPUT GO) & =A --> (INPUT FORWARD) (<DELETE> =A)))

(SYSTEM 
 ((INPUT get all) (PLACE ! =x) (in =n ! =X) -->
  (<DELETE> =A) (INPUT get =n)))

(SYSTEM 
  ((INPUT get all) & =A --> (<DELETE> =A) (<WRITE> |OK, all done.|)))

(SYSTEM 
 ((INPUT GET =P ! =x)
  & =A (HOLDS =P)
  --> (<DELETE> =A)
  (<WRITE> |You already have| (<CAPTOSM> =P))
  (HOLDS =P)))

(SYSTEM 
 ((INPUT GET =P ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |I don't know how to get| (<CAPTOSM> =P))))

(SYSTEM 
 ((INPUT GET =n ! =X)
  & =A (PLACE ! =p)
  (IN =n ! =p)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (HOLDS =n)
  (<WRITE> (<SENTENCE> HAVE-ATN) (<CAPTOSM> =n) |.|)))

(SYSTEM
 ((INPUT get monster) & =A
  (PLACE laboratory)
  (IN monster laboratory) -->
  (<DELETE> =A)
  (<WRITE> |That would be a big mistake.|)))

(SYSTEM 
((INPUT get cecil) & =A (PLACE ! =X) (in cecil ! =X) --> (<DELETE> =A)
(<WRITE> |Cecil is a free spirit.  He doesn't come with you.|)))

(SYSTEM 
 ((INPUT (<any> pull pickup grab pry lift take carry)  ! =X) & =A -->
 (<DELETE> =A) (INPUT GET ! =X)))

(SYSTEM 
 ((INPUT PICK UP ! =X) & =A --> (INPUT GET ! =X) (<DELETE> =A)))

(SYSTEM 
((INPUT drop all) & =A --> (<DELETE> =A) (<WRITE> |All dropped.|)))

(SYSTEM 
((INPUT drop all) (PLACE ! =p) (HOLDS =n)  -->
 (INPUT drop =n)))

(SYSTEM 
 ((INPUT DROP =X)
  & =B (PLACE ! =Y)
  (HOLDS =X)
  & =A --> (<DELETE> =B)
  (<DELETE> =A)
  (IN =X ! =Y)))

(SYSTEM 
 ((INPUT RELEASE =X) & =A --> (<DELETE> =A) (INPUT DROP =X)))

(SYSTEM 
 ((INPUT DISCARD =X) & =A --> (<DELETE> =A) (INPUT DROP =X)))

(SYSTEM 
 ((INPUT DROP =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |You don't have| (<CAPTOSM> =X))))

(SYSTEM 
 ((INPUT PUT DOWN =X) & =A --> (<DELETE> =A) (INPUT DROP =X)))

(SYSTEM 
 ((INPUT TAKE OFF ! =X)
  & =A --> (<DELETE> =A)
  (INPUT REMOVE ! =X)))

(system
 ((input who is bzm ! =x) & =a --> 
  (<delete> =a) (<write> |A famous graduate of CMU CSD|)))

(SYSTEM 
 ((INPUT INVEN) (HOLDS =P) --> (<WRITE> (<CAPTOSM> =P))))

(SYSTEM 
((INPUT INVEN) & =A --> (<DELETE> =A)))

(SYSTEM 
 ((INPUT INVEN)
  (INPUT INVEN)
  --> (<WRITE> |You have the following/:|)))

(SYSTEM 
 ((INPUT INVENTORY) & =A --> (<DELETE> =A) (INPUT INVEN)))

(SYSTEM 
 ((INPUT INVEN)
  (HOLDS =P)
  (INSIDE =C =P)
  --> (<WRITE> (<CAPTOSM> =C))))

(SYSTEM
((INPUT INVEN) (INPUT INVEN) & =A (<not> (HOLDS ! =X)) --> (<DELETE> =A)
(<WRITE> |You're empty handed.|)))

(SYSTEM 
((INPUT run ! =X)  & =A --> (<DELETE> =A) 
 (<WRITE> |I'm going as fast as I can.|)))

(SYSTEM
((INPUT run =X) & =A --> (<DELETE> =A) (INPUT =X)
 (<WRITE> |I can't go any faster.|)))

(SYSTEM 
((INPUT listen) & =A --> (<DELETE> =A) (<WRITE> |Silence!|)))

(system
((INPUT listen) & =A (sound is on) --> (<DELETE> =A)
(<reassert> (sound is on))))

(system
((PLACE stairs) (sound is on) --> (<WRITE> |The sound is coming from above you.|)))


(SYSTEM 
((INPUT whistle) & =A --> (<DELETE> =A) (<WRITE> 
|What, without an accompanying orchestra?|)))

(SYSTEM 
((INPUT hum) & =A --> (<DELETE> =A) (<WRITE> 
|Hum de dum de dum, hum hum dum dum de dum.|)))

(SYSTEM 
((INPUT sing ! =k) & =A --> (<DELETE> =A) (<WRITE> |In-A-Gadda-Da-Vida Baby, don't you know that I love you.|)))

(SYSTEM 
((INPUT mumble) & =A --> (<DELETE> =A) (<WRITE> (<sentence> MUM-ATN))))

(SYSTEM 
 ((INPUT STOP) --> (<WRITE> |The party's over.|) HALT))

(SYSTEM 
 ((INPUT quit) --> (<WRITE> |See you later.|) HALT))

(SYSTEM 
 ((INPUT halt) --> (<WRITE> |Bye now.|) HALT))

(SYSTEM 
(DIE DIE (<NOT> DIED)(HOLDS =x) & =A --> (<DELETE> =A) (IN =X closet)))

(SYSTEM
(DIE DIE (INPUT ! =X) & =A --> (<DELETE> =A)))

(SYSTEM 
(DIE DIE DIED -->  HALT))

(SYSTEM 
(DIE & =b  (PLACE ! =x) & =A (score =Q) & =C --> (<DELETE> =B)  
(<DELETE> =C) (PLACE foyer) (<DELETE> =A) (score (<-> =Q 20))
DIED (<WRITE> |Well, looks like you're dead.|)
(<WRITE> |But before the last neuron in your brain was destroyed, a|)
(<WRITE> |10th level Cleric came by and waved his hand.|)))

(SYSTEM 
 ((INPUT (<any> examine describe)  ! =X) & =A -->
 (<DELETE> =A) (INPUT LOOK ! =X)))

(SYSTEM 
 ((INPUT LOOK ! =X)
  & =A (PLACE ! =Y)
  --> (<DELETE> (WASAT ! =Y))
  (<DELETE> =A)
(<REASSERT>   (PLACE ! =Y))))

(SYSTEM 
 ((INPUT KILL ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |With what? Your bare hands?|)))

(SYSTEM
 ((PLACE ! =z) (In =x ! =z) (INPUT KILL =X WITH ! =Y) & =A -->
  (<DELETE> =A) (<WRITE> |Even with that you can't kill it.|)))

(SYSTEM 
  ((INPUT throw football ! =X) & =A --> 
   (<DELETE> =A) (<WRITE> |You don't have a football Dummy!|)))

(SYSTEM 
 ((INPUT THROW ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |I don't throw anything but a regulation NFL football.|)))

(SYSTEM 
((INPUT throw up) & =A --> (<DELETE> =a) (<WRITE> |I don't have the stomach for that.|)))

(SYSTEM 
 ((INPUT CUT ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |There is nothing to cut with.|)))

(system
 ((INPUT cut =x with  =Y) & =A
--> (<DELETE> =A) (<WRITE> |The| (<captosm>  =Y) |won't cut the|
  (<captosm> =X) |.|)))

(SYSTEM 
 ((INPUT CUT CHEESE)
  & =A --> (<DELETE> =A)
  (<WRITE> |Look, this room is smelly enough already without that.|)))

(SYSTEM 
 ((INPUT BREAK ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |You hurt your hand.|)))

(SYSTEM 
 ((INPUT BUST BUST)(INPUT bust bust)
$   =A --> (<DELETE> =A)
  (<WRITE> |Homer looks hurt.|)))

(SYSTEM 
 ((INPUT KICK =X ! =Y)
  & =A --> (<DELETE> =A)
  (<WRITE> |Ouch! The| (<captosm> =X) |kicks back.|)))

(system
((INPUT kick =X) & =A (HOLDS =x) & =B (PLACE ! =Y) --> (<DELETE> =A)
(<DELETE> =B)
(<WRITE> |Thud!  Not much of a kicker I see.|)
(in =x ! =Y)))

(system
((INPUT kick football) & =A --> (<DELETE> =A) 
(<WRITE> |I see no football here.|)))

(SYSTEM 
((INPUT punt ! =X) & =A --> (<DELETE> =A) (INPUT kick ! =X)))

(SYSTEM 
 ((INPUT JUMP ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |Up you go, down you come.|)))

(SYSTEM 
 ((INPUT BURN ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |You can't burn|  (<CAPTOSM> ! =X) |without matches.|)))

(SYSTEM 
 ((INPUT BURN ! =X)
  & =A (HOLDS MATCHES)
  --> (<DELETE> =A)
  (<WRITE> |You may have matches, but you didn't light one.|)))

(SYSTEM 
 ((INPUT OPEN ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> (<SENTENCE> NOTCLOSED-ATN))))

(SYSTEM 
((INPUT open chest) & =A --> (<DELETE> =A)
 (<WRITE> |The chest can't be opened, but it is worth mucho closed.|)))

(SYSTEM 
 ((INPUT HELP ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> (<SENTENCE> HELP-ATN))))

(SYSTEM 
 ((INPUT YES ! =X)
  & =A --> (<DELETE> =A)
  (said YES)
(<WRITE> |Cute, but lets get on with the show.|)))

(system
((input no ! =x) & =a -->
(<delete> =a) (<write> |That was rhetorical you fool.|)))

(system
((Input spit ! =x) & =a -->
(<delete> =a) (<write> |Your throat is too dry.|)))

(SYSTEM 
 ((INPUT WHERE ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |I don't know where| ! =X |. I hope we aren't lost!!|)))

(SYSTEM 
 ((INPUT FIND ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |That would be cheating if I did it.|)))

(SYSTEM 
 ((INPUT DRINK ! =A)
  & =B --> (<DELETE> =B)
  (<WRITE> |The| (<CAPTOSM> ! =A) |is not drinkable.|)))

(SYSTEM
((INPUT DRINK) & =A
--> (<DELETE> =A)
(<WRITE> |I don't know what to drink.|)))

(SYSTEM 
 ((INPUT SCREW ! =A)
  & =B --> (<DELETE> =B)
  (<WRITE> |Sorry, but i don't have a screw driver.|)))

(SYSTEM 
 ((INPUT FUCK ! =A)
  & =B --> (<DELETE> =B)
  (<WRITE> |That would be pretty kinky.|)))

(SYSTEM 
 ((INPUT FUCK BUST)
  & =A --> (<DELETE> =A)
  (<WRITE> |Homer is harder than you are.|)))

(SYSTEM 
 ((INPUT COPULATE ! =X) & =A --> (<DELETE> =A) (INPUT FUCK ! =X)))

(SYSTEM 
 ((INPUT FUCK ! =X)
  & =A (wears wetsuit)
  --> (<DELETE> =A)
  (<WRITE> |You can't do that with a wetsuit on!|)))

(SYSTEM 
 ((INPUT UP YOURS ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |Up your own.|)))

(SYSTEM 
 ((INPUT OH ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |Isn't life a pisser?|)))

(system
((INPUT oh) & =A --> (<DELETE> =A)  (<WRITE> |Mais oui.|)))

(SYSTEM 
((INPUT shit ! =X) & =A --> (<DELETE> =A)  (<WRITE> |Hey, let's not mess up the PLACE!|)))


(SYSTEM 
 ((INPUT RAPE ! =X) & =A --> (<DELETE> =A) (INPUT TORTURE ! =X)))

(SYSTEM 
 ((INPUT KISS ! =X) & =A --> (<DELETE> =A) (<WRITE> |SMACK!|)))

(SYSTEM 
((INPUT ball ! =X) & =A --> (<DELETE> =A) (INPUT fuck ! =X)))

(SYSTEM 
((INPUT hump ! =x) & =A --> (<DELETE> =A) (INput fuck ! =X)))

(SYSTEM 
((INPUT Make love) & =A (likes ! =X) --> (<DELETE> =A) (Input fuck ! =X)))

(SYSTEM 
((INPUT GOD DAMN) & =A --> (<DELETE> =A) (INPUT pray)))

(system
((INPUT DAMn ! =X) & =A --> (<DELETE> =A) (<WRITE> |Clean up your act.|)))

(system 
((INPUT masturbate ! =X) & =A --> (<DELETE> =A)
(<WRITE> |You're too scared to get aroused at all.|)))

(system
((PLACE torture chamber) (INPUT masturbate ! =X) & =A DAMSEL-FREE 
--> (<DELETE> =A) (<WRITE> |I think you can get some help from your friend.|)))

(SYSTEM 
((INPUT mount ! =X) & =A --> (<DELETE> =A) (going u) (WENT U)))

(SYSTEM 
((INPUT stand on ! =X) & =A --> (<DELETE> =A) (INPUT mount ! =X)))

(SYSTEM 
 ((INPUT GET ON ! =X) & =A --> (<DELETE> =A) (INPUT MOUNT ! =X)))

(SYSTEM 
 ((INPUT CLIMB ON ! =X) & =A --> (<DELETE> =A) (INPUT MOUNT ! =X)))

(SYSTEM 
 ((INPUT climb ! =X) & =A --> (<DELETE> =A) (going u) (WENT U)))

(SYSTEM 
 ((INPUT GET OFF ! =X) & =A --> (<DELETE> =A) (GOING D) (WENT U)))

(SYSTEM 
 ((INPUT GET DOWN ! =X) & =A --> (<DELETE> =A) (GOING D) (WENT D)))

(SYSTEM 
 ((INPUT DISMOUNT ! =X)
  & =A 
  --> (<DELETE> =A)
  (GOING D) (WENT D)))

(SYSTEM 
 ((INPUT TINGLE)
  & =A --> (<DELETE> =A)
  (<WRITE> |Nothing happens.|)))

(SYSTEM 
 ((INPUT BLOW ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |Whoooooosh!|)))

(SYSTEM 
((INPUT knock ! =X) & =A --> (<DELETE> =A) (<WRITE> |Thud, thud.|)))

(SYSTEM 
 ((INPUT EAT ! =X)
  & =A --> (<DELETE> =A)
(<WRITE> |That is not part of a balanced diet.|)))

(SYSTEM 
 ((INPUT EAT =X ! =Y)
  & =A (IN =X ! =Z)
  --> (<DELETE> =A)
  (<WRITE> |You don't have| (<CAPTOSM> =X) |on you.|)))

(SYSTEM 
((INPUT eat shit) & =A --> (<DELETE> =A) (<WRITE> |YEACH! Fuck OFF!|)))

(SYSTEM 
((INPUT go to hell) & =A --> (<DELETE> =A) (<WRITE> |Oh yeah!  I'm fed up with you!!|)
HALT))

(SYSTEM 
((INPUT =x moose) & =A --> (<DELETE> =A) (<Write> |I see no moose.|)))

(SYSTEM 
((INPUT go blue) & =A --> (<DELETE> =A) (<Write> |Beat State.|)))

(SYSTEM 
((INPUT pray ! =X) & =A --> (<DELETE> =A) 
(<WRITE> |GOD responds/:|) (INPUT help)))

(SYSTEM 
 ((INPUT (<any> fondle cuddle hug rub tap FEEL)  ! =X) & =A 
--> (<DELETE> =A) (INPUT TOUCH ! =X)))

(SYSTEM 
 ((INPUT TOUCH =X)
  & =A (HOLDS =X)
  --> (<DELETE> =A)
  (<WRITE> |It is in your hands, and it feels like a| (<CAPTOSM> =X)	   |.|)))

(SYSTEM 
 ((INPUT TOUCH WALL)
  & =A --> (<DELETE> =A)
  (<WRITE> |Surprize!  The wall is flat and cold.|)))

(SYSTEM 
 ((INPUT TOUCH PAINTING)
  & =A (HOLDS PAINTING)
  --> (<DELETE> =A)
  (<WRITE> |The painting is still wet!!|)))

(SYSTEM 
 ((INPUT TOUCH ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |You should get it first.|)))

(SYSTEM 
((INPUT touch ! =X) & =A (likes ! =X) (PLACE torture chamber)
DAMSEL-FREE --> (<DELETE> =A)
(<WRITE> |That's a start.  Your friend is enjoying it.|)))

(system
((INPUT touch her) & =A (likes ! =X) (PlACE torture chamber) --> 
(<DELETE> =A)
(<WRITE> |Hmm.  She likes that.|)))

(system
((INPUT touch him) & =A (likes ! =X) (PLACE torture chamber) 
DAMSEL-FREE --> (<DELETE> =A )
(<WRITE> |Hmm.  He likes that.|)))

(SYSTEM 
((INPUT sit in ! =X) & =A --> (<DELETE> =A) (INPUT sit on ! =X)))

(SYSTEM 
((INPUT sit ! =X) & =A --> (<DELETE> =A) (<WRITE> |I don't know how to sit on it.|)))

(SYSTEM 
 ((ONTOP =Q) 
  & =A (GOING D) (GOING D)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (<WRITE> |You are back on Terra Firma.|)))

(SYSTEM 
 ((ONTOP =Q) & =A
(going =x)  (GOING =X)
  & =Y --> (<DELETE> =Y)
(<DELETE> =A) (<WRite> |You just fell to the ground.|)(input look)))

(SYSTEM 
((siton =q) & =A (going =X) (going =X) --> (<DELETE> =A)))

(SYSTEM 
((siton =q) & =A (INPUT get up) & =B --> (<DELETE> =A)
(<DELETE> =B) (<WRITE> |You are now standing.|)))

(SYSTEM 
((siton =Q) & =A (INPUT stand ! =X) & =B --> (<DELETE> =A)
(<DELETE> =B) (<WRITE> |You are no longer sitting.|)))

(SYSTEM 
((siton =Q) (INPUT get =Q) & =A -->
 (<DELETE> =A) (<WRITE> |You'll have to stand up first.|)))

(SYSTEM 
((ontop =Q) (Input get =Q) & =A --> 
 (<DELETE> =A) (<WRITE> |Cute, why don't you get off it first.|)))

(SYSTEM 
((HOLDS =X) (INPUT mount =X) & =A --> (<DELETE> =A)
(<WRITE> |Why don't you drop it first.|)))

(SYSTEM 
((INPUT open sesame) & =A -->(<DELETE> =A) (<WRITE> |No says me!|)))

(SYSTEM 
((INPUT I ! =X) & =A --> (<DELETE> =A)
(<WRITE> |Quit talking about yourself and give me a command.|)))

(SYSTEM 
((INPUT give =X to ! =Y) & =A --> (<DELETE> =A)
(<WRITE> |The| (<captosm> ! =Y) |doesn't take| (<captosm> =X))))

(SYSTEM 
((INPUT give =x =y) & =A --> (<DELETE> =A)
(<WRITE> |The| (<captosm> =x) |doesn't want| (<captosm> =y))))

(SYSTEM 
((INPUT give =x) & =A (Holds =x) --> (<DELETE> =A) 
(<WRITE> |Hey, after we went through all the trouble to get |)
(<WRITE> (<captosm> =x) |I ain't gonna let you give it away.|)))

(SYSTEM 
((INPUT give ! =x) & =A --> (<delete> =a) 
(<write> |First we should get it.|)))

(SYSTEM 
((INPUT follow moose) & =A (time /00/:02) --> (<DELETE> =A)
(<WRITE> |Crash!! Into the wall you go.|)))

(system
((INPUT follow moose) & =A (time /00/:02) (PLACE bus stop) -->
(<DELETE> =A) (<WRITE> |Last I saw he went west, so away we go.|)
(INPUT west)))

(system
((INPUT follow moose) & =A --> (<DELETE> =A) (<WRITE> |I see no moose here.|)))

(SYSTEM 
((INPUT swim) & =A --> (<DELETE> =A) 
(<WRITE> |Why don't you wait until we are in the water.|)))


(System
((PLACE LAWN ISIDE 8 8) (HOLDS BOTTLE) (GRAVE OIL) 
 (INPUT FILL BOTTLE ! =X) & =A --> (<DELETE> =A)
(<WRITE> |The oil won't go into the bottle, sorry.|)))

(SYSTEM
((PLACE LAWN ISIDE 8 8) (HOLDS BOTTLE) (GRAVE OIL)
 (INPUT GET OIL ! =X) & =A --> (<DELETE> =A)
(<WRITE> |The oil is too thick to go into the bottle.|)))

(System
((PLACE ! =X) (in bottle ! =X) (<not> (inside =q bottle))
--> (<WRITE> |There is an empty bottle here.|)))

(System
((PLACE ! =X) (In bottle ! =X) (inside =q bottle)
--> (<WRITE> |There is a bottle of| (<captosm> =q) |here.|)))

(System
((PLACE ! =X) (In bottle ! =X) & =B (inside =q bottle) (INPUT get =q) & =A
--> (<DELETE> =A) (<DELETE> =B) (HOLDS bottle)
(<WRITE> |You are now holding the bottle.|)))

(system
((HOLDS bottle) (<not> (inside =q bottle))
(INPUT fill bottle ! =g) & =A (PLACE bathroom) -->
(<DELETE> =A) (inside bathwater bottle) (<WRITE> |The bottle is full of bathwater.|)))

(system
((HOLDS bottle) (<not> (inside =q bottle))
(INPUT fill bottle ! =g) & =A (PLACE beach 3) -->
(<DELETE> =A) (inside water bottle) (<WRITE> |The bottle is full of sparkling water.|)))

(system
((PLACE beach 3) (INPUT pour ! =X) & =A 
 (HOLDS bottle) (inside =Q bottle) & =B
--> (<DELETE> =a) (<DELETE> =b) (<WRITE> |The bottle is empty.|)))

(system
((PLACE bathroom) (INPUT pour ! =X) & =A 
 (HOLDS bottle) (inside =Q bottle) & =B
--> (<DELETE> =a) (<DELETE> =b) (<WRITE> |The bottle is empty.|)))

(system 
((HOLDS bottle) (<not> (inside =Q bottle))
(INPUT fill bottle ! =g) & =A UNDERWATER -->
(<DELETE> =A) (inside seawater bottle) (<WRITE> |The bottle is full of seawater.|)))

(system
((INPUT get water ! =x) & =A --> (<DELETE> =A) 
(INPUT fill bottle )))

(system
((INPUT get seawater ! =X) & =A --> (<DELETE> =A)
(INPUT fill bottle )))

(system
((INPUT get bathwater ! =X) & =A --> (<DELETE> =A)
(INPUT fill bottle )))

(system
((INPUT fill up ! =X) & =A --> (<DELETE> =A)
(INPUT fill bottle)))

(system
((HOLDS bottle) (<not> (iside =q bottle))
(INPUT fill bottle ! =g) & =A --> (<DELETE> =A)
(<WRITE> |There is nothing to fill the bottle with.|)))

(system 
((HOLDS bottle) (iside =q bottle) (INPUT fill bottle ! =g) & =A
--> (<DELETE> =A) (<WRITE> |The bottle is already full.|)))

(system
((INPUT fill bottle ! =g) & =A --> (<DELETE> =A)
(<WRITE> |You don't have a bottle to fill.|)))

(system
((INPUT pour ! =X) & =A (INPUT pour ! =X) UNDERWATER -->
(<DELETE> =A) (<WRITE> |Hmm, you want me to empty a bottle underwater.|)
(<WRITE> |I'm afraid that is out of my league.|)))

(SYSTEM 
((ON water ! =x) (PLACE ! =X) -->
(<WRITE> |There is a wet spot here.|)))

(SYSTEM 
((ON seawater ! =X) (PLACE ! =X) -->
(<WRITE> |There is a salty wet spot here.|)))

(SYSTEM 
((Place ! =X) (ON BATHWATER ! =X) -->
(<WRITE> |There is a bit of a wet spot here.|)))

(system
((PLACE ! =X) (on turpentine ! =X) & =A --> (<DELETE> =A)
(<WRITE> |The turpentine evaporates as it leaves the bottle.|)))


(System
((HOLDS bottle) & =B  (inside =q bottle) (INPUT drop =Q ! =X) & =A
 (PLACE ! =y) --> (<DELETE> =A) (<DELETE> =b)
(in bottle ! =Y)))

(system
((HOLDS bottle) (inside =q bottle) & =A (Input pour ! =X) & =b
(PLACE ! =Y)
--> (<DELETE> =a) (<DELETE> =B) (<reassert> (on =q ! =Y))))

(system
((PLACE ! =X) (on =q ! =X) (INPUT fill bottle ! =g) & =A --> (<DELETE> =A)
(<WRITE> |Sorry, I don't have a mop!|)))

(system
((INPUT empty ! =x) & =A --> (<DELETE> =A) (INPUT pour)))

(system
((INPUT water ! =X) & =A --> (<DELETE> =A) (Input pour)))

(system
((INPUT pour ! =X) & =A --> (<DELETE> =A)
(<WRITE> |You don't have a bottle full of anything.|)))

(system
((INPUT drink ! =X) & =A (HOLDS bottle) (inside =Q bottle) & =B
--> (<DELETE> =A) (<DELETE> =B) (<WRITE> |I love that|
(<captosm> ! =X) |for breakfast every morning.|)))

(system
((PLACE beach =u) (HOLDS bottle) (INPUT get sand ! =X) & =A
--> (<DELETE> =A) (<WRITE> |The sand clogs in the neck of the bottle.|)
(<WRITE> |For all practical purposes you can't get any sand.|)))

(system
((PLACE beach =u) (HOLDS bottle) (INPUT fill bottle ! =X) & =A
--> (<DELETE> =A) (INPUT get sand)))

(SYSTEM 
((PLACE cheese room) (INPUT eat cheese) & =A -->
 (<DELETE> =a) (<WRITE> |The only cheese here is the walls.|)))

(SYSTEM 
((PLACE ! =X)
(in corkscrew ! =X)
--> (<WRITE> |There is a diamond studded corkscrew here!|)))

(SYSTEM 
((HOLDS corkscrew) (INPUT screw ! =X) & =A --> (<WRITE> 
|Cork screwing is a little out of my league.|) (<DELETE> =A)))

(SYSTEM 
 ((PLACE ! =X) (IN RING ! =X)
  --> (<WRITE> |There is a huge diamond ring here.|)))

(SYSTEM 
 ((PLACE ! =X)
  (IN CANDY ! =X)
  --> (<WRITE> |There is a bowl of candy on the ground.|)))

(SYSTEM 
 ((INPUT =X BOWL) & =A --> (<DELETE> =A) (INPUT =X CANDY)))

(SYSTEM 
 ((PLACE ! =X)
  (IN CANDY ! =x)
  & =A (INPUT EAT CANDY)
  & =B --> (<WRITE> |Candy tastes good; uhm!|)
  (<WRITE> |Of course the pins in the Snickers take a little chewing.|)
  (<DELETE> =A)
  (<DELETE> =B)))

(SYSTEM 
 ((HOLDS CANDY)
  & =B (INPUT EAT CANDY)
  & =A --> (<WRITE> |You eat the candy; and get cavities.|)
  (<DELETE> =A)
  (<DELETE> =B)))

(SYSTEM 
 ((PLACE ! =X) (IN MARIJUANA ! =X)
  --> (<WRITE> |There is some fine marijuana here!  Good stuff.|)))

(system
((INPUT burn ! =X) & =A
(HOLDS matches) (PLACE lawn ! =Y) --> (<DELETE> =A)
(<WRITE> |The matches go out before you can burn| (<captosm> ! =X))))

(SYSTEM 
 ((HOLDS MARIJUANA) & =d
(INPUT SMOKE MARIJUANA) & =B
 (HOLDS MATCHES) & =C
  (PLACE LAWN ! =X)
-->
  (<DELETE> =B)
  (<DELETE> =C)
 (<DELETE> =D)
  (HUNGRY) 
  (<WRITE> |You manage to light up,|)
  (<WRITE> |the matches haved dried out here, this very expensive stuff.|)
  (<WRITE> |Its very smooth, you begin to think you really don't|)
  (<WRITE> |need to adventure anymore.  You are hungry.|)))

(SYSTEM 
 ((HOLDS MARIJUANA)
  (INPUT SMOKE MARIJUANA)
  & =C --> (<DELETE> =C)
  (<WRITE> |You don't have any matches.|)))

(system
 ((input smoke marijuana) & =a -->
  (<delete> =a) (<write> |You don't have any.|)))

(SYSTEM 
((HOLDS marijuana) (INPUT smoke marijuana) & =A (HOLDS matches)
--> (<DELETE> =A) (<WRITE> |The matches are wet.|)))

(SYSTEM 
((hungry) (HOLDS =X) --> (<WRITE> |Let's eat| (<captosm> =x)) (INPUT eat =X)))

(SYSTEM 
((hungry) & =A --> (<DELETE> =A)))

(SYSTEM 
((PLACE ! =X) (INPUT =Y (<any> maryjane Marihuana dope grass pot)) & =A --> 
(<DELETE> =A)
(INPUT  =Y marijuana)))

(system
((PLACE ! =X) (INPUT (<any> smoke light burn) marijuana ! =y) & =A -->
(<DELETE> =A) (INPUT smoke marijuana)))

(SYSTEM 
 ((PLACE ! =X) (IN CUBE ! =X)
  --> (<WRITE> |There is a small white cube here.|)))

(SYSTEM 
 ((HOLDS CUBE)
  (INPUT LICK CUBE)
  & =A --> (<DELETE> =A)
  (<WRITE> |UHM!  That tasted good!!!|)))

(system 
	((HOLDS CUBE) (INPUT TASTE CUBE) & =A -->
(<WRITE> |To taste it you should really eat the cube.|) (<DELETE> =A)))

(SYSTEM 
 ((HOLDS CUBE) & =c
  (HOLDS WATCH)
  (INPUT EAT CUBE)
  & =A 
-->  (<DELETE> =A) (<DELETE> =c)
  (<WRITE> |The cube tastes like sugar. You are suddenly surrounded by|)
  (<WRITE> |a herd of moose.  They start talking to you about a moose-load of things.|)
(<WRITE> |One walks over to you and whispers, 'Fa Lowe, why her?'|)
(<WRITE> |You look at your watch , but the hands suddenly spin!|)
  (<WRITE> |You find yourself staring at the|)
  (<WRITE> |m|)
(<WRITE> | o|)
(<WRITE> |  o|)
(<WRITE> |   s|)
(<WRITE> |    e|)
(<WRITE> |     ?|)
(<WRITE> |        for a long time, and enjoying it.|)))

(SYSTEM 
 ((HOLDS CUBE) & =c
  (INPUT EAT CUBE)
  & =A 
-->  (<DELETE> =A) (<DELETE> =c)
  (<WRITE> |The cube tastes like sugar. You are suddenly surrounded by|)
  (<WRITE> |a herd of moose.  They start talking to you about a moose-load of things.|)
(<WRITE> |One walks over to you and whispers, 'Fa Lowe, why her?'|)
  (<WRITE> |You find yourself staring at your toes|)
(<WRITE> |        for a long time, and enjoying it.|)))

(SYSTEM 
 ((HOLDS CUBE) & =B
  (INPUT EAT CUBE)
  & =A 
  (PLACE KITCHEN)
  --> (<DELETE> =A) (<DELETE> =B)
  (<WRITE> |That was sweet!|)
  (<WRITE> |This kitchen is a real deary PLACE!!  A bad PLACE to take acid.|)
(<WRITE> |You have to get out of here!!|)
(<WRITE> |You feel on fire, you need water to cool off.|)
  (INPUT
   W THEN PUSH BUTTON THEN N THEN PUSH B THEN EXIT THEN PUSH RED BUTTON)))

(SYSTEM 
((INPUT =X WHITE CUBE) & =A --> (<DELETE> =A) (INPUT =X CUBE)))

(SYSTEM 
((INPUT =X ACID) & =A --> (<DELETE> =A) (INPUT =X cube)))

(system
((INPUT =x sugar ) & =A --> (<DELETE> =A) (INPUT =x cube)))

(SYSTEM 
 ((PLACE ! =X) (CANCERTIME IS =TIME) & =A 
  (TIME IS =TIME)
  (TIME IS =TIME)
 (LIKES ! =B)
  -->
(<DELETE> =A) 
  (<WRITE> |Your wicked and lusty life has finally caught up with you.|)
  (<WRITE> |That cigarette you had with the| (<CAPTOSM> ! =B) |has caused cancer to|)
  (<WRITE> |spread throughout your lungs. COUGH!! COUGH!!  You are|)
  (<WRITE> |weakening. Hack!  You're down on your knees. COUGH COUGH!!|)
  (<WRITE> |You keel over and die....|)
  HALT))

(SYSTEM 
 ((PLACE ! =X) (IN MATCHES ! =X)
  --> (<WRITE> |There are matches here.|)))

(SYSTEM 
 ((HOLDS MATCHES)
  (INPUT =x  MATCH)
  & =A --> (<DELETE> =A)
  (INPUT =x matches)))

(system
((HOLDS matches)
(INPUT (<any> light strike dry) matches) &  =A
--> (<DELETE> =A) (<WRITE> |This house is to damp to light the matches in.|)))

(system
((PLACE lawn ! =X) (HOLDS matches) (INPUT dry matches) & =A
--> (<DELETE> =A) (<WRITE> |The matches dry out.|)))

(system
((PLACE lawn ! =X) (HOLDS matches) (INPUT (<any> light strike) matches)
& =A --> (<DELETE> =A) (<WRITE> |The match lights but goes out quickly.|)))

(system
((INPUT smoke =x) & =a (in =x ! =y) --> (<DELETE> =A)
 (<WRITE> |You're not holding it.|)))

(system
((INPUT light Marijuana ! =X) & =A --> (<DELETE> =A)
(INPUT smoke marijuana)))

(SYSTEM 
 ((PLACE ! =X) (IN FOOTBALL ! =X)
  --> (<WRITE> |There is an official NFL football here!|)))

(SYSTEM 
 ((PLACE ! =X) (HOLDS FOOTBALL)
  & =A (INPUT KICK FOOTBALL ! =z)
  & =B 
  --> (<DELETE> =B)
  (<DELETE> =A)
  (<WRITE> |Oh wow! You kick it around,|)
  (<WRITE> |luckily nothing breaks.|)
  (IN FOOTBALL ! =X)))

(SYSTEM 
 ((HOLDS FOOTBALL)
  & =A (INPUT THROW FOOTBALL ! =X)
  & =B (PLACE ! =Y)
  --> (<DELETE> =A)
  (<DELETE> =B)
  (<WRITE> |Throw is short.  Incomplete pass.  Fourth down, 10 to go.|)
  (IN FOOTBALL ! =Y)))

(SYSTEM 
 ((INPUT =X BALL) & =Z --> (<DELETE> =Z) (INPUT =X FOOTBALL)))

(SYSTEM 
 ((HOLDS WATCH)
  (INPUT WHAT TIME ! =W) & =A 
  (TIME IS =X) --> 
  (<DELETE> =A)
  (<WRITE> |The time is|  =X)))

(SYSTEM 
 ((PLACE ! =X) (IN WATCH ! =X)
  -->
  (<WRITE> |There's a watch here, it even has a luminous dial.|)))

(SYSTEM 
 ((INPUT TIME)
  & =A 
  --> (<DELETE> =A)
(INPUT WHAT TIME)))

(system
((INPUT read watch) & =A --> (<DELETE> =a) (INPUT what time)))

(system
((INPUT tell time) & =A --> (<DELETE> =A) (INPUt what time)))

(SYSTEM 
 ((INPUT WHAT TIME)
  & =A --> (<DELETE> =A)
  (<WRITE> |I have no watch.|)))

(SYSTEM 
((INPUT look at watch) & =A --> (<DELETE> =A)
(INPUT what time)))

(SYSTEM 
((INPUT put on watch) & =A --> (<DELETE> =A) (INPUT get watch)))

(SYSTEM 
((INPUT wind watch) & =A --> (<DELETE> =A) (<WRITE> |The watch is electric!|)))

(SYSTEM 
((INPUT open watch) & =A --> (<DELETE> =A) (<WRITE> |The watch is sealed shut.|)))

(SYSTEM 
((INPUT break watch) & =A --> (<DELETE> =A) 
(<WRITE> |The watch is shock resistent too.  It still works.|)))

(SYSTEM 
((INPUT =X art ! =Y) & =A --> (<DELETE> =A) (INPUT =X Painting ! =Y)))

(SYSTEM 
 ((PLACE ! =X) (IN PAINTING ! =X)
  (PAINTING IS COVERED)
  --> (<WRITE> |There is a work of ugly modern art on the ground.|)))

(SYSTEM 
 ((PLACE ! =X) (IN PAINTING ! =X)
  (<NOT> (PAINTING IS COVERED))
  --> (<WRITE> |There is a valuable Rembrandt here.|)))

(SYSTEM 
 ((HOLDS PAINTING)
  (HOLDS BOTTLE)
  (INSIDE TURPENTINE BOTTLE)
  & =C (INPUT CLEAN ! =X)
  & =A (PAINTING IS COVERED)
  & =B (SCORE =Y) & =D
  --> (<DELETE> =A)
  (<DELETE> =B)
  (<DELETE> =C)
  (<DELETE> =D)
  (SCORE (<+> =Y 15))
  (<WRITE> |The ugly paint comes off! Underneath is a Rembrandt|)
  (<Write> |This will be very valuable.|)
  (<WRITE> |It is a person and a bust in the painting.|)))

(SYSTEM 
((PLACE ! =X) (IN PAINTING ! =X) (HOLDS BOTTLE) 
(INSIDE TURPENTINE BOTTLE) & =A
(PAINTING IS COVERED) & =B (INPUT POUR ! =Z) & =C (score =Y) & =D
--> (<DELETE> =A) (<DELETE> =B) (<DELETE> =C) (<DELETE> =D)
(<reassert> (INPUT painting ! =X))
(score (<+> =Y 15))
(<WRITE> |The turpentine hits the painting and causes the paint to come off.|)
(<WRITE> |The painting has a person contemplating a bust.|)))

(SYSTEM 
 ((INPUT REMOVE PAINT) & =A --> (<DELETE> =A) (INPUT CLEAN)))

(SYSTEM 
 ((HOLDS PAINTING)
  (PAINTING IS COVERED)
  --> (<WRITE> |Upon closer look, this is worthless!|)))

(SYSTEM 
((inside turpentine bottle) (PLACE ! =e)
(HOLDS bottle) (HOLDS painting) (INPUT pour ! =w) & =a -->
(<DELETE> =A) (INPUT CLEAN)))

(SYSTEM 
((PLACE ! =X) (In money ! =X) --> (<WRITE> |The Money is here!|)))

(SYSTEM 
 ((HOLDS STEREO)
  (SOUND IS ON)
  & =B (PLACE SMELLY ROOM)
  --> (<DELETE> =B)))

(SYSTEM 
 ((IN STEREO SMELLY ROOM)
  (PLACE SMELLY ROOM)
  (SOUND IS ON)
  & =A (INPUT TURN OFF ! =K)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (<WRITE> |The stereo is off. But you broke it, so it doesn't turn on.|)))

(SYSTEM 
 ((PLACE ! =X) (IN STEREO ! =X)
  -->
  (<WRITE> |There is an expensive stereo here, worth many megabucks!!|)))

(SYSTEM 
 ((PLACE ! =X)
  (IN BOOK ! =X)
  --> (<WRITE> |There is a book on the ground.|)))

(SYSTEM 
 ((HOLDS BOOK)
  (INPUT READ BOOK)
  & =A --> (<DELETE> =A)
  (<WRITE> |Vampires can only be destroyed by a stake through the heart,|)
  (<WRITE> |or by the light of day.   They are invunerable to all other|)
  (<WRITE> |attacks.  They dislike garlic and fear crosses.  They are known|)
  (<WRITE> | to frequent dark rooms.|)))

(SYSTEM 
 ((TIME IS /06/:00)
  (TIME IS /06/:00)
  --> (MORNING IS HERE)
  (<WRITE> |You hear a rooster crow!|)))

(SYSTEM 
  ((TIME IS /20/:00) (TIME IS /20/:00) 
  (MORNING IS HERE) & =A
--> (<DELETE> =A)))

(SYSTEM 
 ((TIME IS /00/:00)
  (TIME IS /00/:00)
  --> (MIDNIGHT)))

(SYSTEM 
 ((MIDNIGHT)
  & =A --> (<DELETE> =A)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |A moose comes running out of a wall at full speed straight at you!!!|)
  (<WRITE> |He is right on top of you!!! He runs right through you and disappears.|)))

(SYSTEM 
 ((MIDNIGHT)
  & =A (PLACE LAWN ! =Z) --> (<DELETE> =A)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |BONG!|)
  (<WRITE> |A moose comes running across the lawn at full speed straight at you!!!|)
  (<WRITE> |He is right on top of you. He runs right through you and disappears.|)))

(SYSTEM 
 ((PLACE ! =X) (IN GOLD ! =X)
  --> (<WRITE> |There is gold here!!!!|)))

(SYSTEM 
 ((PLACE ! =X)
  (IN HORN ! =X)
  --> (<WRITE> |There is a magic unicorn horn here.|)))

(System
 ((PLACE ! =X) (in horn ! =X) (HOLDS horn) & =A (INPUT DROP HORN) & =B
--> (<DELETE> =A) (<DELETE> =B)
(<WRITE> |When you drop the horn, it and the one on the ground merge together.|)))

(SYSTEM
((PLACE Dining room) (ontop stool) (HOLDS horn) (INPUT get horn) & =A
--> (<DELETE> =A) (<WRITE> |The horn won't come off.|)))

(SYSTEM 
 ((HOLDS HORN)
  & =D (INPUT BLOW HORN) (INPUT BLOW HORN)
  & =A 
   --> (<DELETE> =A)
  (<DELETE> =D)
  (<WRITE> |A terrific noise comes from the horn. BLAT!!!|)
  (<WRITE> |The horn disappears from your hands.|)
  (<WRITE> |Your body shakes and you black out ......|) (CLUE)))

(SYSTEM 
((CLUE) & =A (GRAVE UNDUG) --> (<WRITE> |A spirit appears to you in your sleep.|)
(<WRITE> |Your mind is filled with the following phrase/:|)
(<WRITE> |'As your family is sheep, the gold that is YOUR color must be found|)
(<WRITE> |before you can escape this estate.' |) (<DELETE> =A)))

(SYSTEM 
((clue) & =a --> (<DELETE> =A) (<WRITE> |When you wake you see smoke form the word/:|)
(<WRITE> |EVERY OPTION ON A MACHINE HAS A PURPOSE.  The smoke then dissapates.|)))

(SYSTEM 
((clue) & =A (in orchid lawn ! =X) --> (<WRITE> 
|You dream of a garden of flowers.|) (<DELETE> =A)))

(SYSTEM
((INPUT =X THEM) & =A --> (<DELETE> =A) (INPUT =X CANDLESTICKS)))

(SYSTEM 
 ((PLACE ! =X) (IN CANDLESTICKS ! =X)
  -->
  (<WRITE> |There is a pair of silver candlesticks here!!  No candles though.|)))

(SYSTEM 
 ((HOLDS CANDLESTICKS)
  (INPUT FORM CROSS)
  (INPUT FORM CROSS)
  & =X --> (<DELETE> =X)
  (<WRITE> |The candlesticks are in a cross.|)
  (CANDLESTICKS ARE CROSSED)))

(SYSTEM 
 ((HOLDS CANDLESTICKS)
  (INPUT MAKE CROSS)
  (INPUT MAKE CROSS)
  & =X --> (<DELETE> =X)
  (<WRITE> |The candlesticks are in a cross.|)
  (CANDLESTICKS ARE CROSSED)))

(SYSTEM 
 ((HOLDS CANDLESTICKS)
   & =A
  (CANDLESTICKS ARE CROSSED)
  & =Z (INPUT DROP CANDLESTICKS)
  & =B (PLACE ! =X)
  --> (<DELETE> =Z)
(<DELETE> =A)
  (<DELETE> =B)
  (IN CANDLESTICKS ! =X)))

(SYSTEM 
 ((INPUT FORM CROSS)
  & =A --> (<DELETE> =A)
  (<WRITE> |You have nothing to form a cross with, arms don't work.|)))

(SYSTEM 
 ((INPUT MAKE CROSS)
  & =A --> (<DELETE> =A)
  (<WRITE> |You have nothing to make a cross with, arms don't work.|)))

(SYSTEM 
((INPUT cross candlesticks) & =A --> (<DELETE> =A) (INPUT make cross)))

(SYSTEM 
 ((PLACE ! =X) (IN CHAIR ! =X)
  --> (<WRITE> |There is an old style chair on the ground.|)))

(SYSTEM 
 ((HOLDS CHAIR)
  -->
  (<WRITE> |The plate of the back of the chair says 'MADE BY LOUIS XIV'|)))

(SYSTEM 
 ((PLACE ! =X) (IN CHAIR ! =X) & =A
  (INPUT MOUNT CHAIR)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (<WRITE> |The priceless chair breaks under your weight.|)
  (<WRITE> |It then disappears.|)))

(SYSTEM 
 ((PLACE ! =X) (IN CHAIR ! =X)  & =A
  (INPUT SIT ON CHAIR)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (<WRITE> |You sat on the chair and it broke!|)
  (<WRITE> |It disappears.|)))


(SYSTEM 
 ((PLACE ! =X) (IN STOOL ! =X)
  --> (<WRITE> |There is a sturdy stool here.|)))

(SYSTEM 
 ((PLACE ! =X) (IN STOOL ! =X) (INPUT SIT = STOOL) & =A
  --> (<DELETE> =A) (SITON STOOL)  (<WRITE> |You're sitting on the stool.|)))

(system
 ((HOLDS STOOL) (INPUT SIT = STOOL) & =A -->
 (<DELETE> =A) (<WRITE> |I suggest you drop the stool first.|)))

(SYSTEM 
 ((PLACE ! =X) (IN STOOL ! =X)
  (INPUT MOUNT STOOL)
  & =B --> (<DELETE> =B)
  (<WRITE> |You are on the stool.|)
  (ONTOP STOOL)))

(SYSTEM 
((INPUT climb stool) & =A (place ! =x) --> (<DELETE> =A) (INPUT mount stool)))


(SYSTEM 
((INPUT (<any> DON wear) ! =X) & =A --> (<DELETE> =A) (INPUT PUT ON ! =X)))

(SYSTEM 
((IN chest ! =x) (PLACE ! =X) -->
(<WRITE> |There is a chest of treasure!!!|)))

(SYSTEM 
((HOLDS chest) (open chest) & =A --> (<DELETE> =A) 
(<Write> |Give up, the chest doesn't open, but is worth  gigabucks the way it is.|)))

(SYSTEM 
((HOLDS conch) (INPUT blow conch) & =A --> (<DELETE> =A)
(<WRITE> |Hoooonk!!|)))

(SYSTEM 
((IN conch ! =X) (PLACE ! =x) -->
(<WRITE> |There is a large conch shell here.|)))

(SYSTEM 
((INPUT =x shell) & =A --> (<DELETE> =A) (INPUT =x conch)))

(SYSTEM 
((HOLDS conch) (INPUT listen conch) & =A -->
(<DELETE> =A)  (<WRITE> |You hear the ocean 'rumble'.|)))

(SYSTEM 
((INPUT =X to ! =Y) & =A --> (<DELETE> =A) (INPUT =x ! =y)))

(SYSTEM 
((INSIDE water bottle) & =A (INPUT drink water) & =B 
(PLACE ! =X) & =C
(HOLDS bottle)--> (<DELETE> =A)
(<DELETE> =A) (<DELETE> =B) (<WRITE>
|You have changed into a baby, the adventure must end.|)
HALT))

(SYSTEM 
((INSIDE seawater bottle) & =A (INPUT drink ! =) & =B 
(HOLDS bottle) -->
(<DELETE> =A) (<DELETE> =B) (<WRITE> |Yech!  It tastes salty!!|)))

(SYSTEM 
((PLACE ! =x) (in token ! =x) --> (<WRITE> |There is a token here.|)))

(SYSTEM 
((PLACE ! =X) (in tokens ! =x) --> (<WRITE> |There are tokens here.|)))

(SYSTEM 
((INPUT bite =x ! =Y) & =A (HOLDS =x) --> (<DELETE> =A)
(<WRITE> |The| (<captosm> =X) |bites back, Chomp!!|)))

(system
((INPUT bite =x ! =Y) & =A --> (<DELETE> =A)
(<WRITE> |You must be holding what you are trying to bite.|)))

(SYSTEM 
((HOLDS gem) (score =Y) & =A (<not> (scored gem)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored gem)))

(SYSTEM 
  ((INPUT score) & =A (score =x) --> (<WRITE> |Score =| =X) (<DELETE> =A)))

(SYSTEM 
(HALT (score =x) --> (<WRITE> |Your final score is| =X)
(<WRITE> |The total possible is 440|) (turnoff)))

(SYSTEM 
((turnoff) (score (<LT> 20)) --> (<WRite> |Hmm... I don't think you tried very hard.|)))

(SYSTEM 
((turnoff) --> (<exit>)))

(SYSTEM 
((turnoff) (score (<LT> 50) & (<GT> 21)) -->
(<WRITE> |Rank Novice!  Are you scared of your own shadow?|)))

(SYSTEM 
((turnoff) (score (<GT> 51) & (<LT> 80)) -->
(<WRITE> |Beginning Ghost Hunter|)))

(SYSTEM 
((turnoff) (score (<GT> 81) & (<LT> 140)) -->
(<WRITE> |Reasonable Spirit Fighter|)))

(SYSTEM 
((turnoff) (score (<GT> 141) & (<LT> 220)) -->
(<WRITE> |Intermediate Haunt Hacker|)))

(SYSTEM 
((turnoff) (score (<GT> 221) & (<LT> 290)) -->
(<WRITE> |Advanced Monster Killer|)))

(SYSTEM 
((turnoff) (score (<GT> 291) & (<LT> 360)) -->
(<WRITE> |Master Haunter!!|)))

(SYSTEM 
((turnoff)(turnoff) (score (<GT> 361)) -->
(<WRITE> |Fearless Vampire Killer|)))

(SYSTEM 
((likes ! =X) (turnoff) (score (<GT> 435)) --> 
(<WRITE> |and waster of many cycles.|)))

(SYSTEM 
((PLACE ! =X) (IN pearls ! =X) -->
(<WRITE> |There are huge pearls here!!!|)))

(SYSTEM 
((PLACE ! =X) (IN diamonds ! =X) -->
(<WRITE> |There are diamonds here!|)))

(SYSTEM 
((PLACE ! =x) (in orchid  ! =X) --> 
(<WRITE> |There is a beautiful black orchid here.|)))

(SYSTEM 
((PLACE ! =X) (in orchid ! =X) (INput smell ! =Y) & =A -->
(<DELETE> =A) (<WRITE> |Yum! The orchid smells delicious!|)))

(SYSTEM 
((HOLDS orchid) (INPUT smell orchid) & =A --> (<DELETE> =A)
(<WRITE> |I like the odor!  Sniff. Sniff.|)))

(SYSTEM 
((INPUT pick orchid) & =A --> (<DELETE> =A) (INPUT get orchid)))

(SYSTEM 
((INPUT smell ! =X) & =A --> 
(<DELETE> =A) (<WRITE> |Ah CHOOOO!  There is alot of dust around here.|)))

(SYSTEM 
((INPUT sniff ! =X) & =A --> (<DELETE> =A) (INPUT smell ! =X)))

(SYSTEM 
((PLACE ! =X) (IN rope ! =X) 
(rope noose) --> (<Write> |There is rope in a noose here.|)))

(SYSTEM 
((PLACE ! =X) (IN rope ! =X) (rope untied) 
--> (<WRITE> |There is some loose rope here.|)))

(system
((PLACE ! =X) (in =y ! =X) (rope tied  =Y) (in rope ! /#x) --> 
(<WRITE> |A rope is tied to the| (<captosm> =Y))))

(system
((PLACE ! =X) (in rope ! =x) (rope tied =Y) (in =Y ! /#X)
--> (<WRITE> |An end of a rope is here.|)))

(system
((PLACE ! =X) (in rope ! =X) (rope tied =Y) (In =y ! =X)
--> (<WRITE> |An end of the rope is here, tied to the |
    (<captosm> =y))))

(system 
((PLACE ! =X) (in rope ! =X) (rope tied =Y) (HOLDS =Y)
--> (<WRITE> |A rope tied to the| (<captosm> =Y)
|is here.|)))

(SYSTEM 
((HOLDS rope) (rope noose) & =A
(INPUT untie rope) & =b --> (<DELETE> =A) (<DELETE> =B) 
(<WRITE> |The rope is now untied.|)
(rope untied)))

(SYSTEM 
((rope noose) (INPUT hang ! =x) & =a -->
(<DELETE> =A) (<WRITE> |No hanging around here.|)))

(SYSTEM 
((HOLDS rope) (rope noose) 
(INPUT TIE ROPE ! =X) (INPUT tie rope ! =X) & =A --> (<DELETE> =A)
(<WRITE> |The rope is already in knots.|)))

(SYSTEM 
((HOLDS rope) (INPUT tie  ! =x) & =y
--> (<DELETE> =Y) (<WRITE> |Look, don't tie| (<captosm> ! =x)
|, tie rope to something you have on you.|)))

(system
((HOLDS rope) (INPUT tieup ! =X) & =A -->
(<DELETE> =A) (INPUT tie rope to ! =X)))

(SYSTEM 
((HOLDS rope) (INPUT tie rope to =X) & =Y (rope untied) & =A
(HOLDS =X) --> (<DELETE> =A) (<DELETE> =Y) (rope tied =x)
(<WRITE> |The rope is tied to| (<captosm> =X) |.|)))

(system
((HOLDS rope) (INPUT tie rope to =X) & =A
(rope tied =z) -->
(<DELETE> =A) (<WRITE> |The rope is already tied to the| (<captosm> =z))
(<WRITE> |I can tie the rope to only one object at a time.|)))

(system
((INPUT get =X ! =L) (PLACE ! =Y) (in =X ! =Y) (rope tied =X) 
 (in rope ! =W) & =A --> (<DELETE> =A) 
(HOLDS rope) (<WRITE> |You get the rope first and then ...|)))

(system
((INPUT get rope ! =L) & =B (PLACE ! =Y) (in =x ! =y) (rope tied =x)
 (in rope ! /#y) & =A --> (<DELETE> =A) (<DELETE> =B)
 (HOLDS rope) (<WRITE> |You have gotten the rope.|)))

(system
((INPUT get rope ! =L) & =A (PLACE ! =Y) (HOLDS =X) (rope tied =X)
 (in rope ! =Z) & =B --> (<DELETE> =A) (<DELETE> =B)
(HOLDS rope) (<WRITE> |You just pulled in the rest of the rope.|)))

(SYSTEM 
((HOLDS rope) (INPUT tie rope to cecil) & =A
(PLACE ! =Z) (IN cecil ! =Z) --> (<DELETE> =A)
(<WRITE> |You can't tie cecil down!|)))

(system
((HOLDS rope) (PLACE laboratory) (INPUT tie rope to monster) & =A
(rope untied)
--> (<DELETE> =A) (<WRITE> |That would be very foolish.|)))

(SYSTEM
((HOLDS rope) (INPUT tie rope to dracula) & =A (rope untied)
(PLACE ! =Z) (in dracula ! =Z) --> (<DELETE> =A)
(<WRITE> |You can't get Dracula, not to mention tie him up.|)))

(System
((holds rope) (input tie rope to (<any> candy marijuana cube orchid ) & =X )
& =A (holds =x) (place ! =z) (rope untied) --> (<delete> =a) 
(<write> |That is too small for the rope to be tied to.|)))

(system
((INPUT lasso ! =X) & =A --> (<DELETE> =A) (INPUT tie rope to ! =X)))

(system
((HOLDS rope) (HOLDS rope) (INPUT tie rope to rope) & =A (rope untied) & =B
--> (<DELETE> =A) (<DELETE> =B) 
 (<WRITE> |The rope is tied in knots.|) (rope noose)))

(SYSTEM 
((HOLDS rope) (INPUT tie rope to ! =X) & =A
(likes ! =X)
(PLACE torture chamber) DAMSEL-FREE -->
(<DELETE> =A) (torture damsel)))

(SYSTEM 
((HOLDS rope) (INPUT tie rope to chest) & =A
(PLACE ! =X) (in chest ! =X) (octopus is alive) -->
(<DELETE> =a)
(<WRITE> |The octopus blocks your way.|)))

(SYSTEM 
((HOLDS rope) (INPUT tie rope to ! =X) & =A -->
(<DELETE> =A) (<WRITE> |Either you aren't holding | (<captosm> ! =X) |, or I can't tie the rope to it.|)))

(system
((INPUT tie rope to ! =z) & =A --> (<DELETE> =A) (<WRITE> |You don't have the rope.|)))

(SYSTEM 
((INPUT untie rope) & =a
(rope tied =X)  & =b (HOLDS =x)
--> (<DELETE> =A)  (<DELETE> =b) (rope untied) 
 (<WRITE> |The rope is no longer tied to|    (<captosm> =x) |.|)))

(SYSTEM 
((HOLDS rope) (INPUT pull rope) & =A
(rope tied =X) (IN =x ! =y) & =B
--> (<WRITE> |Umph!!  You just pulled in the| (<captosm> =x) |.|)
(<DELETE> =a) (<DELETE> =B) (HOLDS =x)))

(system
((INPUT pull rope) & =A (rope tied =X) (HOLDS =X) (in rope ! =Z) & =B
--> (<DELETE> =A) (<DELETE> =B) (<WRITE> |You now have all the rope.|)
(HOLDS rope)))

(system
((INPUT untie rope ) & =A (rope untied) --> (<DELETE> =A)
(<WRITE> |The rope isn't tied to anything.|)))

(system
((INPUT untie rope) & =A (rope tied =X) (in =X ! =Y) -->
(<DELETE> =A) (<WRITE> |The rope is tied to the| (<captosm> =X)
|, which you aren't holding.|)))

(system 
((INPUT pull rope) & =A (rope tied =X) (PLACE bathysphere)
 (in =x ocean ! =Y) (wdoor closed) --> (<DELETE> =A)
 (<WRITE> |The airlock door is closed on the rope.|)))

(SYSTEM 
((PLACE ! =X) (IN wetsuit  ! =x) -->
(<WRITE> |There is a wetsuit, with everything needed to survive underwater.|)))

(SYSTEM 
((PLACE ! =X) (IN wetsuit ! =x) & =a
(INPUT put on wetsuit) -->
(<DELETE> =A) (HOLDS wetsuit)))

(SYSTEM 
((HOLDS wetsuit)
(INPUT put on wetsuit) & =a --> (<DELETE> =A)
(<WRITE> |You are wearing a wetsuit.|)
(wears wetsuit)))

(SYSTEM 
((wears wetsuit) & =A (INPUT (<any> remove doff) WETSUIT) & =B
--> (<DELETE> =A) (<DELETE> =B) (<WRITE> |Your wetsuit is in your arms.|)))

(SYSTEM 
((INPUT drop wetsuit) & =A (HOLDS wetsuit) & =B
(PLACE ! =X) --> (<DELETE> =A) (<DELETE> =B)
(in wetsuit ! =X)))

(SYSTEM 
((INPUT drop wetsuit) & =A (HOLDS wetsuit) & =B (wears wetsuit) & =C
(PLACE ! =X) --> (<DELETE> =A) (<Delete> =B) (<DELETE> =C)
(in wetsuit ! =X)))

(SYSTEM 
((PLACE ! =X) (Place ! =X) (IN speargun ! =x) -->
(<WRITE> |There is a speargun around here, the type for shooting underwater.|)))

(SYSTEM 
((PLACE ! =X) (IN speargun ! =x) (speargun IS loaded)
--> (<WRITE> |The speargun is loaded, ready to fire.|)))

(SYSTEM 
((PLACE ! =X)  & =C (HOLDS speargun) (speargun IS loaded) & =a 
(<not> UNDERWATER) (INPUT shoot ! =f) & =B
--> (<DELETE> =A) (<DELETE> =b) (<DELETE> =c) (in ! =X spear)
 (<WRITE> |The gun goes off.  BRRRANG!!!|)
(<WRITE> |The backlash from the speargun snaps your neck!|)
HALT))

(SYSTEM 
((HOLDS speargun) (speargun IS unloaded)
(INPUT shoot speargun) & =A --> (<DELETE> =A)
(<WRITE> |The gun isn't loaded with a spear!!|)))

(SYSTEM 
((HOLDS speargun) (speargun IS unloaded) & =b
(HOLDS spear) & =C (INPUT load ! =q) & =A -->
(<WRITE> |The gun is now loaded.|)
(<DELETE> =A) (<DELETE> =B) (<DELETE> =c) (speargun IS loaded)))

(SYSTEM 
((PLACE ! =X) (IN spear ! =x) -->
(<WRITE> |There is a speargun spear here.|)))

(SYSTEM 
((INPUT =x gun) & =A --> (<DELETE> =A) (INPUT =x speargun)))

(SYSTEM 
((INPUT (<any> pres p depress push) ! =X) & =B --> (<DELETE> =b) (INPUT press ! =X)))

(SYSTEM 
((Place ! =X) (IN COiNS ! =X) --> (<WRITE> |You see many coins here!!|)))

(SYSTEM 
((PLACE ! =X) (in bone ! =X) --> (<WRITE> |There is a bone here that you identify as from the MISSING LINK!|)))

(SYSTEM 
((PLACE ! =X) (in soap ! =X) --> (<WRITE> |There is a bar of soap here.|)))

(SYSTEM 
((PLACE ! =X) (in gem ! =X)  --> (<WRITE> |There is a valuable gem here.|)))

(SYSTEM 
((oil =X) & =A (time is =X) (time is =X) (input ! =z) --> (<DELETE> =A) 
(enter (<time-incr> =X 10))))

(SYSTEM 
((enter =X) & =A (time is =X) (time is =X) (input ! =z) -->
 (in truck lawn iside 7 5) (<DELETE> =A) (walk (<time-incr> =X 10))))

(SYSTEM 
((walk =X) & =a (time is =X) (time is =X) (grave undug) & =b (input ! =z) --> 
(<DELETE> =A) (<DELETE> =B)
(walk (<time-incr> =X 4)) (grave dug)))

(SYSTEM 
((walk =X) & =B (time is =X) (time is =X) (grave dug) & =A (input ! =z) --> 
(<DELETE> =A)
(<DELETE> =B)(walk (<time-incr> =X 4)) (grave deep)))

(SYSTEM 
((walk =X) & =A (time is =X) (time is =X) (grave deep) (grave oil) & =b 
(input ! =z) --> 
(<DELETE> =A)
(<DELETE> =B) (fixit (<time-incr> =X 8))))

(SYSTEM 
((fixit =x) & =A (time is =X) (time is =X) (input ! =z) --> 
 (<DELETE> =A) (fixed) (return (<time-incr> =X 10))))

(SYSTEM 
((return =x) & =A (time is =X) (time is =X) (in truck ! =Y) & =B (input ! =z)
 --> (<DELETE> =a)
(<DELETE> =B)))

(SYSTEM 
((PLACE ! =X) (in jade ! =X) --> (<WRITE> |There is a piece of valuable jade here.|)))

(SYSTEM 
((INPUT why ! =X) & =A --> (<DELETE> =A) (<WRITE> |Hey, I don't know.|)
(<WRITE> |Send mail to Laird@cmua if you have questions.|)))

(SYSTEM 
((INPUT eat orchid) & =A (HOLDS orchid) & =B --> (<DELETE> =A) (<DELETE> =B) 
(<Write> |Chomp! chomp. I don't think your real family had a taste for orchids.|)
(<WRITE> |It looks like you aren't one of those that knows how to digest orchids.|)))

(SYSTEM 
((name =x St |.| John) (INPUT eat orchid) & =B
(HOLDS orchid) & =A --> (<DELETE> =A) (<DELETE> =B) 
(<WRITE> |An orchid a day keeps the crazies away!|) 
EATIT))

(SYSTEM 
((INPUT eat orchid)  (INPUT eat orchid) (in orchid ! =X) 
(PLACE ! =X) --> (INPUT get orchid)))

(SYSTEM 
((INPUT say ! =x) & =a --> (<DELETE> =A) (INPUT ! =X)
(<WRITE> |You can just type| (<captosm> ! =X))
(<WRITE> |and I'll try and understand| (<captosm> ! =X) |right now.|)))

(SYSTEM 
((INPUT (<any> scream shout yell) ! =X) & =A --> (<WRITE> |'| ! =X |!!!!'|)
(<DELETE> =A) (<WRITE> |I don't think anybody is listening.|)))

(SYSTEM 
((INPUT hello ! =X) & =A --> (<DELETE> =A) 
(<WRITE> |Your greeting is met with silence.|)))

(SYSTEM 
((INPUT fly) & =A --> 
(<DELETE> =A) (<WRITE> |You flap your arms, but nothing happens.|)))

(SYSTEM 
((INPUT afihywn ! =X) & =A --> (<DELETE> =A) (<WRITE> |Hmm, is that Australian?|)))

(SYSTEM 
((orc sweat =x) & =A (time is =X) (time is =X) --> (<DELETE> =A)
(orc dizzy (<time-incr> =X 120)) 
(<WRITE> | |)
(<WRITE> |You're starting to sweat, I think this PLACE is getting to you.|)))

(SYSTEM 
((orc dizzy =x) & =A (time is =X) (time is =X) 
--> (<DELETE> =A) 
(<WRITE> | |)
(<WRITE> |Your getting a little dizzy.|)
(<WRITE> |The area around seems to swim a little when you move.|)
(orc mad (<time-incr> =X 60))))

(SYSTEM 
((orc mad =X) & =A (time is =X) (time is =X) --> (<DELETE> =A)
(<WRITE> | |)
(<WRITE> |I think you are definitely going MAD.  The sweaty palms and dizziness were the|)
(<WRITE> |first signs.  If you don't do something quick, you'll commit suicide!|) 
(orc suicide (<time-incr> =X 30))))

(SYSTEM 
((orc suicide =X) & =A (time is =X) (time is =X) --> (<DELETE> =A) DIE 
(<WRITE> | |)
(<wRITE> |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|)
(<WRITE> |You can't stand it anymore, you are now totally crazy!|)
(<WRITE> |You start laughing uncontrollably, but choke on your tongue.|)
(<WRITE> |Ugh! Well at least you died happy!|)))


(system
(DIE DIE DIE (ontop ! =X) & =A --> (<DELETE> =A)))

(system
(DIE DIE DIE (siton ! =X) & =A --> (<DELETE> =A)))

(SYSTEM 
((orc ! =X) & =A EATIT & =B --> (<DELETE> =A) (<DELETE> =B)
(<WRITE> |You feel much saner.|)
(<WRITE> |You've managed to avoid the St. John curse!|)))

(SYSTEM 
((orc suicide =x) & =A EATIT & =B --> (<DELETE> =A) (<DELETE> =B)
(<WRITE> |You've done it!  The orchid returns you to sanity.|)))

