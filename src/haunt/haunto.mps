(system 
(XYZZY & =A --> (<DELETE> =A) (<Write> |This is HAUNT. Version 4.6|) 
(<WRITE> |See NEWS for news.|)
(<WRITE> |Have you played before?[yes]|)
(FIRST (<read>)) (<WRITE> | |) READ))

(system 
((first ! =X) & =A -->
 (<DELETE> =A) (first n) (<WRITE> |I assume that was NO!|)))

(system 
((first) & =A --> (<DELETE> =A) 
(PLACE bus stop) READ))

(system 
((first y) & =A --> (<DELETE> =A) (first)))

(system 
((first yes) & =a --> (<DELETE> =A) (first)))

(system 
((first no) & =A --> (<DELETE> =A) (first n)))

(system 
((first n) & =A --> (<DELETE> =A) (first) 
(<WRITE> |Welcome novice.  You are playing on one of the world's largest production|)
(<WRITE> |systems.  The purpose of this game is to find|)
(<WRITE> |treasure in a haunted house and then escape from the house.|)
(<WRITE> | |)
(<WRITE> |The program will give descriptions of locations and accept|)
(<WRITE> |commands to perform actions.|)
(<WRITE> |Give it directives on what to do with simple 1-5 word commands|)
(<Write> |Its knowledge of English is limited but imaginative.|)
(<WRITE> |The directions are north, south, east, west,|)
(<WRITE> |up and down.  Directions can be one letter (n,s,e,w,u,d).|)
(<WRITE> |Forward, back, left and right also work.|)
(<WRITE> |To string commands together use 'then'. (eg. west then s)|)
(<WRITE> |It will describe things to you, and a phrase enclosed in '   ' |)
(<WRITE> |is something it hears.|)
(<WRITE> | |)
(<WRITE> |Special commands: INVEN tells you what you hold.|)
(<WRITE> |                  SCORE gives your current score. |)
(<WRITE> |                  STOP ends the adventure.  |)
(<WRITE> |                  LOOK describes your current position.|)
(<WRITE> |                  NEWS describes new features.|)
(<WRITE> | |)
(<WRITE> |*******************************************************************|)
(<WRITE> |You get 15 points for finding a treasure and 5 points for|)
(<WRITE> |getting it to the lawn outside the house.  You get an extra|)
(<WRITE> |bonus of 20 points for getting your body off the estate.|)
(<WRITE> |The maximum number of points is 440|)
(<WRITE> |Good luck, you'll need it.  Ask for help if you want.|)
(<WRITE> |*******************************************************************|)
(<WRITE> |Copyright (C) 1979, 1980, 1981, 1982 John Laird|)
(<WRITE> |*******************************************************************|)
(<WRITE> | |)
(<WRITE> |On with the adventure!!!|)
(<WRITE> | |)
(<WRITE> | |)
(<WRITE> | |)
(<WRITE> | |)
(<WRITE> | |)
(<WRITE> | |)
(<WRITE> | |)
(<WRITE> | |)
(<WRITE> | |)
(<WRITE> | |)
(<WRITE> |Along time ago, a young couple was picnicing near the woods|)
(<WRITE> |on the outskirts of town.  They were celebrating the birth|)
(<WRITE> |of their first child.  Unfortunately, a crazed moose inhabited that|)
(<WRITE> |area and attacked them.   The child and husband were|)
(<WRITE> |unharmed, but the wife was gored to death by the moose.|)
(<WRITE> | |)
(<WRITE> |After the funeral, the man bought the land where the incident occurred|)
(<WRITE> |and constructed a large mansion: CHEZ MOOSE.  He filled it with|)
(<WRITE> |the treasures of his family and claimed that his wife's|)
(<WRITE> |soul was still in the area.  He vowed to remain in the|)
(<WRITE> |mansion until he had returned her soul to human flesh.|)
(<WRITE> |He tried to bridge the gap between life and death to reclaim her.|)
(<WRITE> |Some say he was insane with grief, but others claimed that the madness was|)
(<WRITE> |in his blood, and his wife's death brought it to the surface.|)
(<WRITE> |After he entered the house, he never returned, and was declared dead |)
(<WRITE> |seven years later.  Several people have entered the mansion|)
(<WRITE> |looking for him but none of them have ever returned.|)
(<WRITE> |There were rumors that he and his wife now haunt the house.|)
(<WRITE> | |)
(<WRITE> |That would be the end of the story except that the house|)
(<WRITE> |still stands and is filled with priceless treasures.|)
(<WRITE> |The house and all its contents are willed to his only descendant.|)
(<WRITE> |Oh yes, I forgot to tell you, the day the mother was killed,|)
(<WRITE> |the child was stolen by Gypsies.|)
(<WRITE> |The Will claims that only the descendant will know|)
(<WRITE> |how to avoid going crazy and committing suicide|)
(<WRITE> |while spending a night in the mansion.|)
(<WRITE> |An obscure hereditary disease, Orkhisnoires sakioannes,|)
(<WRITE> |is supposed to play some part in this.|)
(<WRITE> | |)
(<WRITE> |So if your heritage is in doubt, you may be the descendant that|)
(<WRITE> |can claim the treasure in the mansion.|)
(<WRITE> |Many people, claiming to be descendants have died trying...|)
(<WRITE> | or at least never returned.|)
(<WRITE> | |)
(<WRITE> |The terms of the Will say you get to keep any treasure|)
(<WRITE> |you get to the lawn, but of course you must also get off the premises alive.|)
(<WRITE> |Because the house is haunted it must be destroyed, and nobody|)
(<WRITE> |would be crazy enough to try and recover the rest of the treasure.|)
(<WRITE> |If you do get out, the government has agreed to|)
(<WRITE> |buy the land and destroy the house.|)
(<WRITE> | |)
(<WRITE> |If you are insane enough to try, your adventure starts at a bus stop.|)
(<WRITE> |Remember, type STOP to end the adventure.|)
(<WRITE> | |)))

(system 
 (START & =A --> (<DELETE> =A) (SCORE 0)  (WENT N) (WENT S) (WENT W)
  (WENT E)
	(IN CANDLESTICKS DINING ROOM) 
	(IN GHOST CHEESE ROOM) 
	(IN CANDY FOYER)
	(IN JADE BACKROOM)
	(IN SOAP BATHROOM)
	(IN MATTRESS BEDROOM)
	(IN CHEST OCEAN 2 2 1) 
	(IN MARIJUANA SECRET ROOM)
	(IN BOTTLE BAR) 
	(IN PAINTING SMELLY ROOM) 
	(IN CHAIR MAIN HALL) 
	(IN STOOL BAR) 
	(IN GOLD SMALL CLOSET) 
	
	(IN DRACULA DARK ROOM) 
	(IN MONSTER LABORATORY)
	(IN COINS BATHYSPHERE)
	(IN CORKSCREW WINE CELLAR)
	(IN WETSUIT CLOSET)
	(IN SPEARGUN BATHYSPHERE)
	(IN DIAMONDS CAVE)
     (MORAY EEL IS ALIVE)
     (SEAMONSTER IS ALIVE)
     (OCTOPUS IS ALIVE)
     (ELEVATOR AT H)
     (CASKET CLOSED)
     (GRILL CLOSED)
     (ELEVATOR CLOSED)
     (LARGE-DOOR CLOSED)
     (SAFE CLOSED)
     (RDOOR CLOSED)
     (WDOOR CLOSED)
     CLOSET-OPENED
     SECRET-PANEL-CLOSED
     (WATER IS OUT)
     (CUBE FRIG)
     (BTIME /22/:14)
     (GRAVE UNDUG)
     (HOLDS TOKENS)
     (ON ORCHID LAWN ISIDE 3 7)
     (SPEARGUN IS LOADED)
     (ROPE NOOSE)
     (HOLDS WATCH)
     (INSIDE TURPENTINE BOTTLE)
     (PAINTING IS COVERED)
     (FOYER IS VIRGIN)
     (TIME IS /22/:00)
     (SOUND IS ON)
     (STAIRS ARE WHOLE)
     (DAMSEL AROUND)
     (DRACULA IS ASLEEP)
     DAMSEL-TIED-UP))

(system 
(ODIE ODIE (HOLDS =x) & =A --> (<DELETE> =A) (IN =X lawn iside 5 3)))

(system 
(ODIE ODIE ODIE DIED --> 
(<WRITE> |Well, you're one more that didn't get the treasure and live.|)
HALT))

(system 
(ODIE & =b  (PLACE ! =x) & =A (score =Q) & =C --> (<DELETE> =B)  
(<DELETE> =C) (PLACE lawn oside 2 2) (<DELETE> =A) (score (<-> =Q 20))
DIED (<WRITE> |Hmm... you went and got yourself killed.|)
(<WRITE> |But before the last neuron in your brain was destroyed, a|)
(<WRITE> |10th level Bus driver came by and conjured up a Lazurus spell!!!|)))
(system 
((PLACE bus stop) (PLACE bus stop) -->
(<WRITE> |We are at an intersection of two streets going n-s and e-w.|)
(<WRITE> |There is a bus stop here.|)
(<WRITE> |To the west a bus is pulling away from the next bus stop.|)))

(system 
((PLACE bus stop) (going =z) & =A (TIME is =x) (BTIME =y) & =B -->
(<DELETE> =A) (<DELETE> =B)  (<reassert> (PLACE bus stop)) (BTIME (<time-incr> =x 16))))


(system 
((PLACE bus stop) (time is =X) (time is =x) (BTIME =x) --> 
bus-stopped))

(system 
((Place bus stop) bus-stopped --> (<Write> |A bus has stopped in front of us.|)))

(system 
((INPUT wait ! =x) & =A --> (<WRITE> |La dee da.|) (<DELETE> =A)))

(system 
((PLACE bus stop) (INPUT wait ! =X) & =A --> (<DELETE> =A)
 bus-stopped (<Write> |Yawn!|)))

(system 
((PLACE bus stop) (INPUT mount ! =y) & =a --> (<DELETE> =A)
(INPUT enter bus)))

(system 
((INPUT board ! =X) & =A --> (<DELETE> =A)
(INPUT enter bus)))

(system 
((PLACE bus stop) bus-stopped & =C  (INPUT enter ! =X) & =A (holds tokens) & =b -->
(<DELETE> =A) (<DELETE> =b) (<DELETE> =C)  (holds token) ride-bus))

(system 
((PLACE bus stop) (INPUT take ride ! =X) & =A --> (<DELETE> =A) (INPUT enter bus)))

(system 
((PLACE bus stop) bus-stopped & =c (INPUT enter ! =x) & =a (holds token) & =b -->
(<DELETE> =A) (<DELETE> =B) (<DELETE> =C)  ride-bus))

(system 
((PLACE bus stop) bus-stopped (INPUT enter ! =x) & =A --> (<DELETE> =A)
(<WRITE> |You don't have any tokens.  You sit on the corner and starve to death.|)
HALT))

(system
((PLACE bus stop) bus-stopped (INPUT enter ! =X) & =A (in token bus stop)
--> (<DELETE> =A) (<WRITE> |The bus doors remain closed.|)))

(system
((PLACE bus stop) bus-stopped (INPUT enter ! =X) & =A (in tokens bus stop)
--> (<DELETE> =A )
 (<WRITE> |You stumble over some tokens and bang your head on the bus.|)))


(system 
((PLACE bus stop) & =A ride-bus & =B -->
(<DELETE> =A) (<DELETE> =B)
(PLACE a bus) (WASAT a bus) 
(<WRITE> |As you find your seat, you notice the bus is empty.|)
(<Write> |There isn't even a driver.  But before you can change your mind,|)
(<WRITE> |the bus starts up and drives away from the intersection.|)
(<Write> |Va Vooooom!|)
(<Write> |Looking out the window you see many intersections flash by.|)
(<WRITE> | |)
(<WRITE> |After a while the intersections get farther apart.|)
(<Write> |The bus is now in the outskirts of town.|)
(<Write> |The bus comes up to an old mansion with a high gate surrounding it and stops.|)
(<WRITE> |A voice comes over the speaker: 'ALL OUT, END OF THE LINE.'|)))

(system 
((PLACE a bus) (<NOT> (WASAT a bus)) --> (<Write> | |)
(<Write> |You are in a bus.  There isn't a driver and the exit doors are open.|)))

(system 
((PLACE a bus) (INPUT get off ! =X) & =A --> (<DELETE> =A) (INPUT exit)))

(system 
((PLACE a bus) (INPUT leave ! =X) & =A --> (<DELETE> =A) (INPUT exit)))

(system 
((PLACE a bus) (INPUT depart ! =X) & =A --> (<DELETE> =A) (INPUT exit)))

(system 
((PLACE a bus) & =A (INPUT exit ! =X) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE lawn oside 5 2)  
(<WRITE> |The bus drives off as you get off.|)))

(system 
((PLACE a bus) (INPUT get out ! =X) & =A --> (<DELETE> =A) (INPUT exit)))

(system 
((PLACE bus stop) (INPUT (<any> Chase follow catch) bus ! =X) & =A --> (<DELETE> =A) 
(<WRITE> |I'm assuming that means GO WEST.|) (going w) (went w)))

(system 
((PLACE bus stop) (time is /22/:26) --> 
(<WRITE> |Hint: patience is a virtue.|)))

(system 
((PLACE a bus) (INPUT hijack bus ! =) & =A --> (<DELETE> =A)
(<WRITE> |Sorry, this bus doesn't go to Cuba, that's another line.|)))

(system 
((PLACE a bus) (INPUT = driver) & =A --> (<DELETE> =A)
(<WRITE> |There isn't a driver on this bus.|)))

(system 
((PLACE a bus) (INPUT drive bus ! =X) & =A --> (<DELETE> =A)
(<WRITE> |I'm sorry but you don't have a chauffeur's license.|)))

(system 
((PLACE a bus) (INPUT = bus) & =A --> (<DELETE> =A)
(<WRITE> |Give up and get off the bus.|)))

(system 
((PLACE bus stop) (INPUT hail bus) & =a --> (<DELETE> =A)
(<WRITE> |The bus does not stop for you.|)))

(system 
((PLACE lawn =side (<gt> 0) & =C  =D) & =A (going e) & =b -->
 (<DELETE> =A) (<DELETE> =B) (PLACE lawn =side (<+> 1 =C) =D)))

(system 
((PLACE lawn =side =e (<gt> 0) & =N) & =A (going n) & =B -->
 (<DELETE> =A) (<DELETE> =B) (PLACE lawn =side =E (<+> 1 =N))))

(system 
((PLACE lawn =side =E (<gt> 1) & =N) & =A (going s) & =B -->
 (<DELETE> =A) (<DELETE> =B) (PLACE lawn =side =E (<-> =N 1))))

(system 
((PLACE lawn =side (<gt> 1) & =E =N) & =A (going w) & =B -->
 (<DELETE> =A) (<DELETE> =B) (PLACE lawn =side (<-> =E 1) =N)))

(system 
((PLACE lawn oside 1 =N) (going w) & =B -->
(<DELETE> =B) (<write> |The woods is too dense to penetrate.|)))

(SYSTEM
((PLACE lawn oside 1 1) & =A (going w) & =B -->
(<DELETE> =a) (<DELETE> =B) (PLACE BUS STOP)))

(system
((place lawn oside 1 1) (going n) & =b -->
(<delete> =b) (<write> |The woods to the north is too dense to penetrate.|)))

(SYSTEM
((PLACE lawn oside 8 1) & =A (going e) & =B -->
(<DELETE> =a) (<DELETE> =B) (PLACE BUS STOP)))

(system 
((PLACE lawn oside 8 =N) (going e) & =B -->
(<DELETE> =B) (<write> |You are unable to penetrate into the woods.|)))

(system 
((PLACE lawn oside =e 1) (going s) & =B -->
(<DELETE> =B) (<WRITE> |The forest can not be penetrated.|)))

(system 
((PLACE lawn oside =e 8) (going n) & =B -->
(<DELETE> =B) (<WRITE> |Penetration into the forest is impossible|)))

(system 
((PLACE lawn oside (<gt> 2) 2)  (going n) & =A  -->
(<DELETE> =A) (<WRITE> |The wall prevents passage to the north.|)))

(system 
((PLACE lawn iside (<gt> 1) 2) (going s) & =A  -->
(<DELETE> =A) (<WRITE> |The wall won't let you go south.|)))

(system 
((PLACE lawn oside (<gt> 2) 8)  (going s) & =A 
--> (<DELETE> =A) (<WRITE> |The wall is in the way.|)))

(system 
((PLACE lawn iside (<gt> 1) 8) (going n) & =A 
--> (<DELETE> =A) (<WRITE> |Hey, the wall is north.|)))

(system 
((PLACE lawn oside (<gt> 2) 8) 
(<not> (PLACE lawn oside 8 8)) -->
(<WRITE> |You're on the north border of a wall, on the outside.|)))

(system 
((PLACE lawn iside (<gt> 1) 8)  -->
(<WRITE> |You're on the inside of the north border of a wall.|)))

(system 
((PLACE lawn oside (<gt> 2) 2)  -->
(<WRITE> |To the north is the wall that surrounds CHEZ MOOSE.|)
(<WRITE> |To the south is a road.|)))

(system 
((PLACE lawn iside (<gt> 1) 2)  --> 
(<WRITE> |A wall is to the south.|)))

(system 
((PLACE lawn oside 2 (<gt> 2)) -->
(<WRITE> |To the west is a thick forest, and to the east is a wall.|)))

(system 
((PLACE lawn oside 8 (<gt> 2))
(<not> (PLACE lawn oside 8 8)) -->
(<WRITE> |To the east is a dark forest, and to the west is a high wall.|)))

(system 
((PLACE lawn iside 8 (<gt> 1))  -->
(<WRITE> |To the east is a wall.|)))

(system 
((PLACE lawn iside 2 (<gt> 1))  --> 
(<WRITE> |To the west is a wall.|)))

(system 
((PLACE lawn iside 2 (<gt> 1))  (going w) & =A --> (<DELETE> =A)
(<WRITE> |The wall blocks your way.|)))

(system 
((PLACE lawn oside 2 (<gt> 2))  (going e) & =A -->
(<DELETE> =A) (<Write> |Ahh, there is the big wall in the way.|)))

(system 
((PLACE lawn oside 8 (<gt> 2)) (going w) & =A -->
(<DELETE> =A) (<WRITE> |The wall is in the way.|)))

(system 
((PLACE lawn iside 8 (<gt> 1))  (going e) & =A
--> (<DELETE> =A) (<WRITE> |The wall is in the way.|)))

(system 
((PLACE lawn iside 4 4) --> (<WRITE> |You are at the sw corner of the house.|)))


(system 
((PLACE lawn iside 6 4) -->
(<WRITE> |You are at the se corner of the house.|)))

(system 
((PLACE lawn iside 4 5) -->
(<WRITE> |You are on the west side of the house.|)))

(system 
((PLACE lawn iside 4 6) --> 
(<WRITE> |This is the north-west corner of the house.|)))

(system 
((PLACE lawn iside 5 6) --> 
(<WRITE> |This is the north side of the house.|)))

(system 
((PLACE lawn iside 6 6) -->
(<WRITE> |This is the north east corner of the mansion.|)))

(system 
((PLACE lawn iside 6 5) -->
(<WRITE> |This is the east side of the house.|)))

(system 
((PLACE lawn iside 6 5) (going w) & =A -->
(<DELETE> =A) (<WRITE> |The house is in the way.|)))

(system 
((PLACE lawn iside 4 5) (going e) & =A -->
(<DELETE> =A) (<WRITE> |The house is in the way.|)))

(system 
((PLACE lawn iside 5 4) (going n) & =A -->
(<DELETE> =A) (<WRITE> |The house is in the way.|)))

(system 
((PLACE lawn iside 5 6) (going s) & =A -->
(<DELETE> =A) (<WRITE> |The house is in the way.|)))

(system 
((PLACE lawn oside =e 1) -->
 (<WRITE> |You are on the road, to the south is a forest.|)))

(system 
((PLACE lawn oside 1 (<gt> 2)) --> (<WRITE> |You are in a forest.|)))

(system 
((PLACE lawn iside 3 3) --> lawns))

(system 
((PLACE lawn iside 4 3) --> lawns))

(system 
((PLACE lawn iside 6 3) --> lawns))

(system 
((PLACE lawn iside 7 3) --> lawns))

(system 
((PLACE lawn iside 7 4) --> lawns))

(system 
((PLACE lawn iside 7 7) --> lawns))

(system 
((PLACE lawn iside 6 7) --> lawns))

(system 
((PLACE lawn iside 5 7) --> lawns))

(system 
((PLACE lawn iside 4 7) --> lawns))

(system 
((PLACE lawn iside 3 6) --> lawns))

(system 
((PLACE lawn iside 3 7) --> (<WRITE> 
|This looks like an old garden, but the land is all dried and hard.|)))

(system
((on bathwater lawn iside 3 7) (on orchid lawn iside 3 7) & =A
--> (<DELETE> =A) (<WRITE> |The ground shakes...|)
(<WRITE> |An orchid sprouts from the ground.|)
(in orchid lawn iside 3 7)))

(system
((on water lawn iside 3 7) (in orchid lawn iside 3 7) 
(on bathwater lawn iside 3 7) & =B --> (<DELETE> =B)
(<WRITE> |The orchid shinks and disappears underground.|)))

(system
((on water lawn iside 3 7) (on orchid lawn iside 3 7) 
--> (<WRITE> |Nothing happens.  That must be strange water.|)))

(system 
((on water lawn iside 3 7) & = A (inside bathwater bottle) 
(PLACE bathroom)
--> (<DELETE> =A)))

(system
((on seawater lawn iside 3 7) (on orchid lawn iside 3 7) & =A
--> (<WRITE> |I think you killed what ever was planted.|)))

(system
((on bathwater ! =X) & =a (on water ! =X) & =b
--> (<DELETE> =A) (<DELETE> =B) (<WRITE> |The two types of water evaporate.|)))

(system 
((PLACE lawn iside 3 5) --> lawns))

(system 
((PLACE lawn iside 3 4) --> lawns))

(system 
(lawns & =A --> (<DELETE> =A) (<WRITE> |You're on the lawn of the mansion.|)))

(system 
((PLACE lawn iside 5 3) --> (<Write> |You're on the front walk.|)))

(system 
((PLACE lawn iside 5 2) -->
(<WRITE> |You're at the front gate, which can't be opened.|)))

(system 
((PLACE lawn =side 5 2) (INPUT climb ! =X) & =A -->
(<DELETE> =A) (<WRITE> |Nice try, but the upper part of the gate is electrified!|)
(<WRITE> |I suggest you try somewhere else.|)))

(system 
((PLACE lawn oside 5 2)  -->
(<WRITE> |To the north is a gate in a wall.|)
(<WRITE> |Further north a huge mansion looms.|)
(<WRITE> | |)
(<WRITE> |Lights from inside illuminate the surrounding estate.|)
(<WRITE> |The gate is inoperable, and you won't be able to open it.|)))


(system 
((PLACE lawn iside 8 6) 
(going w) & =A --> (<DELETE> =A) (<WRITE> |The garage is in the way.|)))

(system 
((PLACE lawn iside 8 6) -->
(<WRITE> |There is a garage to the west.|)))

(system 
((PLACE lawn iside 7 7) -->
(<WRITE> |There is a garage to the south.|)))

(system 
((PLACE lawn iside 7 7) (going s) & =A -->
(<DELETE> =A)(<WRITE> |The garage is in the way.|)))

(system 
((PLACE lawn iside 6 6) -->
(<WRITE> |There is a garage to the east.|)))


(system 
((PLACE lawn iside 6 6) (going e) & =A -->
(<DELETE> =A) (<WRITE> |The garage is in the way.|)))

(system 
((PLACE lawn iside 7 5) -->
(<WRITE> |The entrance to a garage is to the north.|)
(<WRITE> |You are on the drive way.|)
(<WRITE> |The drive has a gate in the wall to the east.|)))

(system 
((PLACE lawn iside 7 6) -->
(<WRITE> |You are in an old garage.  It opens to the south.|)))

(system 
((PLACE lawn iside 7 6) (going n) & =A -->
(<DELETE> =A) (<WRITE> |There is a wall in the way.|)))

(system 
((PLACE lawn iside 7 6) (going e) & =A -->
(<DELETE> =a) (<WRITE> |There is a wall in the way.|)))

(system 
((PLACE lawn iside 7 6) (going w) & =A -->
(<DELETE> =A) (<WRITE> |There is a wall in the way.|)))

(system 
((PLACE lawn oside 8 8) & =A 
(going s) & =B --> (<DELETE> =A) (<DELETE> =B) (PLACE lawn oside 8 7)))

(system 
((PLACE lawn oside 8 8) & =A 
(going w) & =b --> (<DELETE> =A) (<DELETE> =B)
(PLACE lawn oside 7 8)))

(system 
((PLACE lawn oside 2 8) & =A 
(going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE lawn oside 3 8)))

(system 
((PLACE lawn oside 8 2) & =A  (going n) & =B
--> (<DELETE> =A) (<DELETE> =B) (PLACE lawn oside 8 3)))

(system 
((PLACE lawn oside 2 2) --> (<WRITE> |This is the sw corner of the wall.|)))

(system 
((PLACE lawn oside 8 2) --> 
(<WRITE> |This is the se corner of the wall. You can go n, s, e or w.|)))

(system 
((PLACE lawn oside 8 8) -->
(<WRITE> |This is the ne corner of the wall.|)))

(system 
((PLACE lawn oside 2 8) -->
(<WRITE> |This is the nw corner of the wall.|)))



(system 
((PLACE lawn =side ! =n) (Input (<any> scale climb) ! =Z) & =A --> (<DELETE> =A)
(<WRITE> |The wall is too slick to climb up.  You can't get a grip.|)))

(system 
((PLACE lawn =side ! =n) 
(INPUT (<any> burrow tunnel dig) ! =x) & =A --> (<DELETE> =A)
(<WRITE> |The ground is too hard to dig here.|)))

(system  
((PLACE lawn =side ! =N) (Holds =X)  (INPUT THROW =x AT WALL) & =A --> (<DELETE> =A)
(<WRITE> |The| (<CAPTOSM> =x) |bounces off the wall.|) (INPUT drop =X)))

(system 
((PLACE lawn =side ! =n) (Input jump wall) & =A --> (<DELETE> =A)
(<WRITE> |You aren't the HULK or Dwight Stones.|)))

(system 
((PLACE lawn =side ! =n) (Input jump wall) & =A (name Dwight Stones)
--> (<DELETE> =A) (<WRITE> |You approach the wall.  Up, up you go.|)
(<WRITE> |SPLAT!!! You hit the wall right at 8". That would|)
(<WRITE> |be a new world's record.  Too bad the wall is ten feet tall.|)))

(system 
((PLACE lawn =side ! =n) (Input jump wall) & =A 
 (name the Hulk) --> (<DELETE> =A)
(<WRITE> |Ha! You aren't the Hulk, you're just a little green|)
(<WRITE> |from the bus ride.|)))

(system 
((PLACE lawn =side ! =n) (Input jump over wall) & =A --> (<DELETE> =A)
(<WRITE> |You watched Superman too many times!!|)))

(system 
((PLACE lawn ! =X) (INPUT throw =y over ! =Z) & =A --> 
(<DELETE> =A) (<WRITE> |The wall is too high for you to throw anything over it.|)))

(system 
((INPUT let me in) & =A --> (<DELETE> =A) 
(<WRITE> |I'm afraid you aren't getting anyone's attention.|)))

(system 
((INPUT open gate) & =A --> (<DELETE> =A) (<WRITE> |The gate can't be opened by you.|)))

(system 
((notreasure) (in ! =x) & =A --> (<DELETE> =A)))

(system 
((PLACE lawn iside 5 6) -->
(<WRITE> |There is ivy on the walls of the house.|)))

(system 
((PLACE lawn iside 5 6) (INPUT get ivy) & =A -->
(<DELETE> =A) (<WRITE> |The ivy is stuck to the wall.|)))

(system 
((PLACE lawn iside 5 6) & =B  (INPUT (<any> u up climb scale) ! =z) &  =A -->
(<DELETE> =A) (<DELETE> =B)
(<WRITE> |The ivy allows you to get a grip.  You climb up the wall.|)
(<WRITE> |The ivy starts to thin out and you haven't found anywhere to stop.|)
(<WRITE> |To the right you spy a balcony. Using your great skill as a|)
(<WRITE> |world class haunted house climber, you JRST over to the balcony.|)
(PLACE balcony)))

(system 
((PLACE balcony) (PLACE balcony) (<not> (wasat balcony)) 
--> (<WRITE> |You are on the balcony.  The doors to the inside|)
(<WRITE> |are missing leaving a large doorway to the inside.|)))

(system 
((PLACE balcony) (going u) & =a --> (<DELETE> =A) (<WRITE> |You can't climb any higher.|)))

(system 
((PLACE balcony) (INPUT climb up ! =X) & =A --> (<DELETE> =A) 
(going u) (went u)))

(system 
((PLACE balcony) (INPUT climb) & =A --> (<DELETE> =A) (<WRITE> |Climb up or climb down?|)))

(system 
((PLACE balcony) (INPUT climb down) & =A --> (<DELETE> =A)
(<WRITE> |I warned you that the ivy gave out up here!|)
(<WRITE> |When you tried to leap over to get a grip, you missed!!!!|)
(<WRITE> |Down you go|)
(<WRITE> |           o|)
(<WRITE> |            o|)
(<WRITE> |             o|)
(<WRITE> |              o.|)
(<WRITE> |Your foot gets caught in some ivy near the bottom and you land|)
(<WRITE> |on your head. |) ODIE))

(system 
((PLACE balcony) (going d) & =A --> (<DELETE> =A) 
(<WRITE> |Is that climb down or jump?|)))

(system 
((PLACE balcony)  (INPUT jump ! =D) & =b --> 
(<WRITE> |Paratrooper training comes in helpful sometimes.|)
(<WRITE> |Unfortunately you never had it.  You break your neck when you hit.|)
(<DELETE> =B) ODIE))

(system 
((PLACE balcony) (INPUT jump ! =D) & =B (holds mattress) -->
ODIE (<WRITE> |You flip over in mid-air and land on your back! 'CRUNCH'|)
 (<DELETE> =b)))

(system 
((PLACE balcony) & =a (INPUT jump ! =D) & =B (in mattress lawn ! =X) -->
(<DELETE> =A) (<DELETE> =B) (PLACE lawn iside 5 6)
(<WRITE> |Luckily you land on the mattress.|)))

(system 
((PLACE balcony) (holds mattress) & =A (INPUT drop mattress ! =X) & =b
--> (<DELETE> =A) (<DELETE> =B) (in mattress lawn iside 5 6)
(<WRITE> |The mattress floats to the ground.|)))

(system 
((PLACE balcony) (INPUT throw mattress ! =x) & =A --> (<DELETE> =A)
(INPUT drop mattress)))

(system 
((PLACE balcony)  (INPUT enter ! =X) & =A --> (going s) (WENT S)
 (<DELETE> =A)))

(system 
((PLACE balcony) & =A (going s) & =b --> (<DELETE> =A)
(<DELETE> =B) (wasat balcony)
(PLACE bedroom)))

(system 
((PLACE bedroom) (PLACE bedroom)(<not> (wasat bedroom)) -->
(<WRITE> |You are in what looks like the master bedroom of the mansion.|)
(<WRITE> |A large doorway opens to the balcony to the north.|)
(<WRITE> |To the east is a opening to the bathroom.|)
(<WRITE> |The main doorway to the rest of the house is boarded up and impassable.|)))

(system 
((PLACE bedroom) (INPUT enter ! =X) & =A -->
 (<DELETE> =A) (going e) (WENT E)))

(system 
((PLACE bedroom) (INPUT exit ! =X) & =a --> (<DELETE> =A) (going n) (WENT N)))

(system 
((PLACE bedroom) (holds mattress) (going e) & =A --> (<DELETE> =A)
(<WRITE> |The mattress won't fit through the door.|)))

(system 
((PLACE bedroom) (holds mattress) (going n)  --> 
(<WRITE> |The mattress just clears the door.|)))

(system 
((PLACE bedroom) & =A (going n) & =b --> (<DELETE> =a)
(<DELETE> =B) (wasat bedroom) (PLACE balcony)))

(system 
((PLACE bedroom) & =A (going e) & =B --> (<DELETE> =A)
(<DELETE> =B) (wasat bedroom) (PLACE bathroom)))

(system 
((PLACE bedroom) (sound is on) --> (<WRITE> |Some noise can be heard through the boarded up door.|)))

(system 
((PLACE bedroom) (in mattress bedroom) --> 
(<WRITE> |There is a king-size bed in the middle of the room.|)))

(system 
((PLACE bedroom) (<not> (in mattress bedroom)) --> 
(<WRITE> |There is the frame and springs of a king-size bed in the room.|)))

(system 
((PLACE bedroom) (INPUT get bed) & =A --> (<DELETE> =A) (<WRITE> 
|All you can get is the mattress, the rest is too heavy.|)
(INPUT get mattress)))

(system
((PLACE ! =X) (in mattress ! =X) & =A 
(INPUT cut  mattress ! =Y) & =B
--> (<DELETE> =A) (<DELETE> =B) 
(<WRITE> |The mattress is poorly made and you rip it to shreds.|)
(<WRITE> |In fact it is in a million pieces that float away.|)))

(system
((INPUT cut mattress) & =A (holds mattress) & =B -->
(<DELETE> =A) (<DELETE> =B)
(<WRITE> |The mattress falls to pieces in your hands and they all float away.|)))

(system
((INPUT (<any> chop rip tear) ! =Y) & =A --> (<DELETE> =A)
(INPUT cut ! =Y)))

(system 
((PLACE bedroom) (INPUT look under bed) & =A --> (<DELETE> =A)
(<WRITE> |'Ahhh Chooo!'  There is dust under the bed.|)))

(system 
((PLACE bedroom) (INPUT =x under bed) & =A --> (<DELETE> =A)
(<WRITE> |The bed is too low to go under.|)))

(system 
((PLACE bedroom) (INPUT mount bed) & =A --> (<DELETE> =A)
(ontop bed) (<WRITE> |You are on the bed.|)))

(system 
((PLACE bedroom) (ontop bed) (in mattress bedroom) (INPUT jump ! =X) & =A
(<not> (mirror broke)) --> (<DELETE> =A) (<WRITE> |You bounce up and hit the mirror.  It shatters into many small pieces.|) (mirror broke)))

(system 
((INPUT bounce ! =X) & =A --> (<DELETE> =A) (INPUT jump)))

(system 
((PLACE bedroom) (ontop =) (INPUT jump ! =X) & =A -->
(<DELETE> =A) (<WRITE> |Without the mattress on you don't get any cheap thrills.|)))

(system 
((PLACE bedroom) (ontop =Q) (INPUT get mirror) & =A --> (<DELETE> =A)  (<WRITE> 
|The mirror is still out of reach.|)))

(system 
((PLACE bedroom) (INPUT get mirror) & =A --> (<DELETE> =A)
(<WRITE> |The mirror is much too high to reach.|)))

(system 
((PLACE bedroom) (<not> (mirror broke)) --> (<WRITE> |There is a mirror on the ceiling above the bed.|)))

(system 
((PLACE bedroom) (mirror broke) (INPUT get mirror ! =X) & =A -->
(<DELETE> =A) CUT (<WRITE> |The glass is too sharp to carry, you cut yourself. 'Ouch!'|)))

(system
((PLACE bedroom) (mirror broke) (ontop bed) (INPUT get mirror ! =X) & =A
--> (<DELETE> =A) CUT
(<WRITE> |The glass cuts you when you try to pick it up.|)))

(system 
((PLACE bedroom) (mirror broke) (INPUT get glass ! =X) & =A -->
(<DELETE> =A) CUT (<WRITE> |'Ouch!'  The glass cuts you, you can't carry it.|)))

(system 
((PLACE bedroom) (mirror broke) --> (<WRITE> |There is glass from a broken mirror on the floor.|)))

(system 
((PLACE bedroom) (ontop bed) (INPUT sleep ! =X) & =A  -->
(<WRITE> |Snooze...
        .
	.
	.
	.
	.
	... snort.  Ah that was refreshing, but useless, you're still ugly.|)
(<DELETE> =A)))

(system 
((PLACE bedroom) (INPUT get in bed) & =A --> 
(<DELETE> =A) (INPUT mount bed)))

(system 
((PLACE bedroom) (INPUT sit on bed) & =A --> (<DELETE> =A)
(INPUT mount bed)))

(system 
((INPUT sleep ! =X) & =A --> (<DELETE> =A) (<WRITE> |Let's wait until we are on a bed.|)))

(system 
((PLACE ! =X) (<not> (PLACE bedroom)) (in mattress ! =X) --> 
(<WRITE> |There is a king-size mattress here.|)))

(system 
((PLACE bathroom) (PLACE bathroom) (<not> (wasat bathroom)) -->
(<WRITE> |You are in the master bathroom.|)
(<WRITE> |The exciting features around are the bathtub and the toilet.|)))

(system 
((PLACE bathroom) & =A (going w) & =B --> (<DELETE> =A)
(<DELETE> =B) (wasat bathroom) (PLACE bedroom)))

(system 
((PLACE bathroom) (Input Urinate ! =X) & =A --> (<DELETE> =A)  (<WRITE> |That was a relief!|)))

(system 
((PLACE bathroom) (INPUT urinate ! =X) (likes prince) --> (siton toilet)))

(system
((INPUT urinate into bottle ! =X) & =A --> (<DELETE> =A)
(<WRITE> |The adventure has frighten you so much that your|)
(<WRITE> |urethra won't relax|)
(<WRITE> |and you are unable to even expel a drop.|)))

(system
((INPUT get urine ! =X) & =A --> (<DELETE> =A)
(INPUT urinate into bottle)))

(system 
((INPUT urinate in bottle ! =X) & =A --> (<DELETE> =A)
(INPUT urinate into bottle)))

(system 
((PLACE bathroom) (INPUT shit ! =X) & =A --> (<DELETE> =A) (siton toilet)
(<WRITE> |Too bad there isn't any tissue!|)))

(system 
((INPUT piss ! =X) & =A --> (<DELETE> =A) (INPUT urinate ! =X)))

(system 
((INPUT take a leak ! =X) & =A --> (<DELETE> =A) (INPUT urinate ! =X)))

(system 
((PLACE bathroom) (INPUT take  a crap) & =A --> (<DELETE> =A) (INPUT shit)))

(system 
((PLACE bathroom) (INPUT mount toilet) & =A --> (<DELETE> =A)
(<WRITE> |Sitting on a toilet is lots of fun!!|) (siton toilet)))

(system 
((PLACE bathroom) (INPUT sit on toilet) & =A --> (<DELETE> =A)
(siton toilet) (<WRITE> |Duly sat.|)))

(system 
((PLACE bathroom) (INPUT flush ! =XX) & =S --> (<DELETE> =S)
ODIE (<WRITE> |When you flush the toilet it spins around, knocking you off your feet!|)
(<WRITE> |You crack your head on the bathtub and die!!!|)))

(system 
((PLACE bathroom) (going w) (siton =x) & =A --> (<DELETE> =A)))

(system 
((PLACE bathroom) & =A (siton toilet)  (INPUT flush ! =X) & =c
--> (<DELETE> =A)  (<DELETE> =C) (wasat bathroom)
(PLACE backroom)))

(system 
((PLACE bathroom) (get toilet) & =A --> (<DELETE> =A)  (<WRITE> |Give me a break!  The toilet stays here!|)))

(system 
((PLACE bathroom) (get bathtub) & =A --> (<WRITE> |The bathtub doesn't move.|) (<DELETE> =A)))

(system 
((PLACE bathroom) (INPUT (<any> enter mount) bathtub) & =A --> (siton bathtub) (<DELETE> =A)
(<WRITE> |Ok.|)))

(system 
((PLACE bathroom) (INPUT sit in bathtub) & =A --> (siton bathrub)
(<DELETE> =A) (<WRITE> |Ok.|)))

(system 
((PLACE bathroom) (INPUT turn on water) & =A --> (<DELETE> =A)
WATER-ON))

(system 
((PLACE bathroom) WATER-ON --> (<WRITE> |The water is on in the bathtub.|)))

(system 
((PLACE bathroom) (INPUT turn off water) & =A --> (<DELETE> =A)
(<WRITE> |The water is already off.|)))

(system 
((PLACE bathroom) WATER-ON & =A (INPUT turn off water) & =b -->
(<DELETE> =A) (<DELETE> =B) (<WRITE> |The water is turned off.|)
(<WRITE> |All the water drains out.|)))

(system 
((Place bathroom) (INPUT turn on shower) & =A --> (<DELETE> =A)
(<WRITE> |There isn't a shower head, just a bathtub.|)))

(system 
((PLACE bathroom) (INPUT take shower) & =A --> (<DELETE> =A)
(<WRITE> |I thought I said there was only a BATHTUB!|)))

(system 
((PLACE bathroom) (INPUT take bath) & =A --> (<DELETE> =A) WASH))

(system 
((PLACE bathroom) (INPUT wash ! =A) & =B --> (<DELETE> =B) WASH))

(system 
((Place Bathroom) WASH (<not> WATER-ON) -->
 (<WRITE> |Well, I must turn on the water.|) WATER-ON))

(system 
((PLACE bathroom) WASH (<not> (siton bathtub)) -->
(<WRITE> |Let's get in the bathtub.|)
(siton bathtub)))

(system 
((PLACE bathroom) WASH (<not> (holds soap)) --> 
(<WRITE> |Hmmm... now where was that soap.|) (INPUT get soap)))

(system 
((PLACE bathroom) WASH & =B (holds soap) & =a (siton bathtub) WATER-ON -->
(<DELETE> =A) (<DELETE> =B)
(<WRITE> |Luckily we don't worry about clothes in this adventure!|)
(<WRITE> |The water is nice and warm.  Too bad I don't have a rubber duckie!|)
(<WRITE> |Well let's use the soap to get clean.|)
(<WRITE> |There is so much dirt here it takes alot of soap.|)
(<WRITE> |As the soap wears away, we are left with a GEM!!!.|)
(holds gem)))

(system 
(WASH & =A --> (<DELETE> =A)
(<WRITE> |Ahh, can't wash without any soap and water.|)))

(system 
((holds soap) (siton bathtub) WATER-ON -->
 (<WRITE> |As long as we're here, we might as well wash.|) WASH))

(system 
((PLACE bathroom) (holds soap) & =B  (INPUT drop soap in bathtub) & =A
 WATER-ON --> (<DELETE> =A) (<DELETE> =B)
(<WRITE> |The soap dissolves and a gem remains!|) (in gem bathroom)))

(system 
((holds soap) & =B (PLACE bathroom) WATER-ON   (INPUT drop soap in water) & =A --> (<DELETE> =A)
(<WRITE> |The soap dissolves in the water!!|) (in gem bathroom)
(<DELETE> =a) (<DELETE> =B)))

(system 
((siton bathtub) (wears =X) & =A --> (<DELETE> =A) 
(<WRITE> |If we're getting in the bathtub I'm going to take off the|
(<captosm> =X) |.|)))

(system 
((PLACE bathroom) (INPUT lather ! =X) & =A --> (<DELETE> =A) (INPUT wash)))

(system 
((PLACE bathroom) (INPUT drop soap in water) & =A --> (<DELETE> =A)
(INPUT wash)))

(system 
((PLACE bathroom) (INPUT drop soap in bathtub) & =A --> (<DELETE> =A)
(INPUT wash) (<WRITE> |Let's jump in after it and take a bath.|)))

(system 
((PLACE bathroom) (INPUT drink water) & =A --> (<DELETE> =A)
(<WRITE> |Gross! I'm not that thirsty!|)))


(system 
((INPUT urinate ! =X) (INPUT urinate ! =X) (wears =X) --> (INPUT take off =X)
(<WRITE> |Well, I think it is best to undress a little first.|)))

(system 
((PLACE bathroom) (INPUT shit ! =Z) (wears =X) --> (INPUT take off =X)
(<WRITE> |I'll take off the suit first.|)))

(system 
((INPUT pee ! =X) & =A --> (<DELETE> =A) (INPUT urinate ! =X)))

(system 
((PLACE bathroom) (INPUT =x DRAIN) & =A --> (<DELETE> =A)
(<WRITE> |The drain is open, even shoving the bed down it won't close it|)))

(system 
((PLACE bathroom) (INPUT plug ! =X) & =A --> (<DELETE> =A)
(<WRITE> |You can't plug it.|)))

(system 
((PLACE bathroom) (INPUT =x plug ! =Y) & =A --> (<DELETE> =A)
(<WRITE> |I see no plug here.|)))

(system 
((PLACE bathroom) WATER-ON (INPUT splash ! =X) & =A
--> (<DELETE> =A) (<WRITE> |Hey, watch it!  No splashing around here.|)))

(system 
((PLACE bathroom) (siton bathtub) & =A WATER-ON (INPUT drown ! =X) & =B
--> (<DELETE> =A) (<DELETE> =B) ODIE (<WRITE> |Adventure a little to tough for you eh?|)
(<WRITE> |Well you did look a little blue, especially after you held your head under|)
(<WRITE> |for ten minutes!|)))

(system 
((PLACE backroom) (PLACE backroom) (<not> (wasat backroom)) -->
(<WRITE> |The toilet and the wall have swivled around 180 degrees.|)
(<WRITE> |You are now in a backroom.|)
(<WRITE> |I assume this was for when grand-dad wanted to ... in private.|)
(<WRITE> |There are no doors or windows.  Just the toilet.|)))

(system 
((PLACE backroom) & =A (INPUT flush ! =X) & =B -->
(<DELETE> =A) (<DELETE> =B) (wasat backroom)
(PLACE bathroom) (<WRITE> |Around you go again.|)))

(system 
((PLACE backroom) (INPUT urinate ! =X) & =A --> (<DELETE> =A)
(<WRITE> |Your bladder is empty.|)))

(system 
((PLACE backroom) (INPUT shit ! =z) & =A --> (<DELETE> =A)
(<wrIte> |Plop!|)))

(system
((PLACE backroom) (INPUT stand ! =X) & =A --> (<DELETE> =A)
(<WRITE> |There isn't enough room to stand.|)))

(system
((PLACE backroom) (Input get up) & =A --> (<DELETE> =A)
(<WRITE> |I see no up here.  Ha ha, only kidding.  There isn't room to stand in here.|)))
(system 
((PLACE lawn iside 8 5)(PLACE lawn iside 8 5) -->
(<WRITE> |You are on the driveway.  The gate to the outside|)
(<WRITE> |is to the east, but is locked electronically.|)))

(system 
((PLACE lawn iside 8 5) (going e) & =A -->
(<DELETE> =A) (<WRITE> |The gate is locked, and you can't open it.|)))

(system 
((PLACE lawn oside 8 5)  -->
(<WRITE> |There is a gate in the wall that spans the|)
(<WRITE> |driveway that leads into the inner grounds of the mansion.|)
(<WRITE> |By the left hand side of the gate is a 'Jack-in-the-box'|)
(<WRITE> | speaker with a button.|)))

(system 
((PLACE lawn oside 8 5) (INPUT press ! =X) & =A
 (<not> (wasat gate)) 
-->  (<DELETE> =a) (<WRITE> |'ZZZZZZZ CracKLe ZZZZZZZZZ'|) (one)
(wasat gate)))

(system 
((PLACE lawn oside 8 5) (INPUT press ! =x) & =A
(one) & =B --> (<DELETE> =A) (<DELETE> =B) (<WRITE> |'ZZZZZZZZ, snort snort ZZZZZZZ'|) (two)))

(system 
((PLACE lawn oside 8 5) (INPUT press ! =X) & =A
 (two) & =B --> (<DELETE> =A) (<DELETE> =B) (three)
(<WRITE> |'Meep, ZZzz, Go AWAY!!  Leave me alone!, ZZZT'|)))

(system 
((PLACE lawn oside 8 5) (INPUT press ! =X) & =A
(three) & =B --> (<DELETE> =A) (<DELETE> =B) 
(<WRITE> |'Alright, alright.  Stop pressing that damn buzzer!'|)
(<WRITE> |'There is a microphone there so I can hear anything you say.'|)
(<WRITE> |'How did you get here, on that stupid bus?'|) 
(INPUT con four (<read>))))

(system 
((INPUT con =y ! =x) & =A --> (<DELETE> =A) 
(<WRITE> |'Answer the question!'|)
(INPUT con =y (<read>))))

(system 
((PLACE lawn oside 8 5) & =b (INPUT con =y go ! =x) & =A --> (<DELETE> =A)
(<DELETE> =B)  (<WRITE> |'Well, if you don't like it here, maybe you'll like the bus stop'|)
(PLACE bus stop)))

(system 
((INPUT con =y e) & =A --> (<DELETE> =a) (INPUT con =y go)))

(system 
((INPUT con =y s) & =A --> (<DELETE> =A) (INPUT con =y go)))

(system 
((INPUT con =y y) & =A --> (<DELETE> =A) (INPUT con =y yes)))

(system 
((INPUT con =y certainly) & =A --> (<DELETE> =A) (Input con =y yes)))

(system 
((INPUT con =y of course) & =a --> (<DELETE> =A) (INPUT con =y yes)))

(system 
((INPUT con =y definately) & =a --> (<DELETE> =A) (INPUT con =y yes)))

(system 
((INPUT con =y n) & =A --> (<DELETE> =A) (INPUT con =y no)))

(system 
((INPUT con =y maybe) & =A --> (<DELETE> =A) 
(<WRITE> |'Answer yes or no'|) (INPUT con =Y (<read>))))

(system 
((INPUT con =y) & =A --> (<DELETE> =A)
(<WRITE> |'Speak up I didn't hear you.'|) (INPUT con =Y (<read>))))

(system 
((PLACE lawn oside  8 5) & =B (INPUT con =y press ! =X) & =A -->
(wasat gate)
(<DELETE> =A) (<DELETE> =B) 
(<WRITE> |'That's it!! You've pressed my buzzer once too often.'|)
(<WRITE> |'I guess you must love that bus stop.'|) (PLACE bus stop)))

(system 
((PLACE lawn oside 8 5) (wasat gate)
(INPUT press ! =X) & =A --> (<WRITE> |'So it's you again, I think I'll go back to sleep and think about|)
(<WRITE> |whether to talk to you.'|) (tryagain) (<DELETE> =A)))

(system 
((PLACE lawn oside 8 5) (wasat gate) (INPUT press ! =X) & =A
(tryagain) & =b --> (<DELETE> =A) (<DELETE> =B)
(<WRITE> |'Alright, I'll let you in if you answer three questions.'|)
(<WRITE> |'First, what is your name?'|) (name (<read>))
findsex))

(system 
((PLACE lawn oside 8 5) (INPUT hello ! =X) & =A 
--> (<DELETE> =A) (<WRITE> |'ZZzzzzz'|)))

(system 
((PLACE lawn oside 8 5) & =B (INPUT con four no) & =A --> (wasat gate)
(<DELETE> =A) (<DELETE> =B) (Place bus stop)
(<WRITE> |'Well this time you will.'|)))

(system 
((INPUT con four yes) & =A --> (<DELETE> =A)
(<WRITE> |'I thought so. Mumble. I suppose you think you can survive|)
(<WRITE> |in Chez Moose for a night without going crazy and find mucho treasure?'|)
(INPUT con five (<read>))))

(system 
((INPUT con five no) & =A --> (<DELETE> =A) (NOTREASURE)
(<Write> |'Then I guess you won't be disappointed when you don't find any treasure.'|)
(INPUT con five yes)))

(system 
((INPUT con five yes) & =A --> (<DELETE> =A) (<WRITE>
|'So I guess you want to come in the gate, don't you?'|)
(INPUT con six (<read>))))

(system 
((INPUT con six no) & =A (PLACE ! =y) & =B --> (<DELETE> =A) 
(<DELETE> =B) (wasat gate) (<WRITE>
|'Then leave me alone, you turkey.  Good night!!  Enjoy the bus stop.'|)
(PLACE bus stop)))

(system 
((INPUT con six yes) & =A --> (<DELETE> =A)
(<WRITE> |'In order for you to enter you must first answer three questions!'|)
(<WRITE> |'First, what is your name?'|)
(name (<read>)) findsex))

(system 
((name =x st |.| john) findsex & =A --> (<DELETE> =A)
(<WRITE> |'Oh, so you're one of my descendants.   Come in.'|)
(<WRITE> |'You don't have to answer any more questions.'|)
(<WRITE> |'Good luck in your quest.  Maybe you'll do better than your father.'|)
(likes redhead) (answer correct)))

(system 
((name =x st john) & =A --> (<DELETE> =A) (name =X st |.| john)))

(system 
(findsex & =A (likes ! =X) --> (<DELETE> =A)
(<WRITE> |'Second, what is your quest?'|) (quest (<read>))))

(system 
((quest ! =X) & =A --> (<DELETE> =A) 
(<WRITE> |'I always wanted to do that.  I hope you don't go insane trying.'|)
(<WRITE> | |)  (eight (<ran>))))

(system 
((quest Holy Grail ) & =A --> (<DELETE> =A)
(<WRITE> |'Well, I can assure you that you won't find it here.'|)
(<WRITE> |'But you're welcome to try, if you don't go insane first.'|)
 (<WRITE> | |) (eight (<ran>))))

(system 
((quest (<any> GOLD MONEY JEWELS treasure)) & =A --> 
(<DELETE> =A) (eight (<ran>))
(<WRITE> |'There's lots of that around, all you have to do is find it.'|)
(<WRITE> | |)))

(system 
((quest phd ! =X) & =A --> (<DELETE> =A) (eight (<ran>))
(<WRITE> |'Sorry, I can't perform miracles.'|)
(<WRITE> | |)))

(system 
((quest To find ! =X) & =A --> (<DELETE> =A) (quest ! =X)))

(system 
((quest (<any> a stanford cmu my the) ! =X) & =A
 --> (<DELETE> =A) (quest ! =X)))

(system 
((quest (<any> mom ma mother dad father)) & =A --> (<DELETE> =A) (eight (<ran>))
(<WRITE> |'That brings tears to my eyes.  Sniffle.'|)
(<WRITE> | |)))

(system 
((quest (<any> love romance sex)) & =A (likes  ! =X) -->
(<DELETE> =A) (eight (<ran>))
(<WRITE> |'I think there will be a| (<captosm> ! =X) |dying to meet you.'|)
(<WRITE> | |)))

(system 
((quest moose) & =a --> (<DELETE> =A) (eight (<ran>))
(<WRITE> |'I guarantee that one will run into you.'|) 
(<WRITE> | |)))

(system 
(findsex & =A --> (<DELETE> =A)
(<WRITE> |'Second, which sex (male, female, ...) interests you sexually'|)
(sex (<read>))))

(system 
((wants ! =x) & =A --> (<DELETE> =A) (LIKES ! =X) (eight (<ran>))))

(system 
((Answer correct) & =B  (PLACE lawn oside 8 5) & =A 
--> (<DELETE> =A) (<DELETE> =B)
(<WRITE> |The gate opens.  You rush in and then it closes behind you.|)
(<WRITE> |Out of the speaker you hear, 'Now you are in, but will you ever get out?'|)
(PLACE lawn iside 8 5)))

(system 
((holds token) & =A (PLACE lawn iside 8 5) --> (<DELETE> =A)
(<WRITE> | |)
(<WRITE> |'I'll take that gold token you've got there.'|)
(<WRITE> |'CHOMP!  Yep these old teeth left a mark in it.'|)
(<WRITE> |'Maybe next time you'll be smart enough to test it yourself.'|)
(<WRITE> | |)))

(system 
(ATETOKEN & =A (Wants ! =X) & =B --> (<DELETE> =A) (<DELETE> =B)
(<WRITE> |'POOF!'|) (Place lawn iside 8 5) (likes ! =X)))

(system 
(ATETOKEN & =A (Likes ! =X) findsex & =B 
--> (<DELETE> =A) (<DELETE> =B)
(<WRITE> |'POOF!'|) (Place lawn iside 8 5) ))

(system 
((NAME =X St |.| John) findsex & =B ATETOKEN & =A
--> (<DELETE> =A) (<Delete> =B)
(likes redhead) (<WRITE> |'POOF!'|) (PLACE lawn iside 8 5)))

(system 
((INPUT (<any> Bite Chew eat taste gum) token) & =A 
(holds tokens) & =B (PLACE ! =X) & =C -->
(<DELETE> =A) (<DELETE> =B) (<DELETE> =C)
ATETOKEN 
(<WRITE> |The token disolves in your mouth.|)
(<WRITE> |Your mind fills with a question you MUST answer.|)
(<WRITE> |'What is your name?'|) (name (<read>)) findsex))

(system 
((INPUT (<any> Bite Chew eat taste gum) tokens) & =A 
(holds tokens) & =B (PLACE ! =X) & =C -->
(<DELETE> =A) (<DELETE> =B) (<DELETE> =C)
ATETOKEN 
(<WRITE> |The tokens disolve in your mouth.|)
(<WRITE> |Your mind fills with a question you MUST answer.|)
(<WRITE> |'What is your name?'|) (name (<read>)) findsex))

(system 
((INPUT =x tokens) & =A 
--> (<DELETE> =A) (INPUT =x token)))

(system
((PLACE ! =X) (in tokens ! =X) (INPUT get token) (INPUT get token) & =A -->
(<DELETE> =A) (INput get tokens)))

(system
((INPUT drop token) (INPUT drop token) & =A 
(holds tokens) --> (<DELETE> =A) (INPUT drop tokens)))

(system 
((INPUT (<any> Bite chew eat taste gum) token) (holds token) & =A
--> (<DELETE> =A) (holds tokens)))

(system 
((INPUT get microphone) & =A (PLACE lawn oside ! =Y) & =b 
--> (<DELETE> =A) (<DELETE> =B)
(<WRITE> |'I heard that!  There is no way you gonna find that microphone at the bus stop.'|) (PLACE bus stop)))

(system 
((INPUT find microphone) & =A --> (INPUT get microphone) (<DELETE> =A)))

(system 
((INPUT get speaker) & =A --> (<DELETE> =A) (<WRITE> |'Hey, leave the speaker alone!'|) (three)))

(system 
((eight =a) & =B (user-an ! =x) & =C (my-an ! =x) & =d -->
(<DELETE> =B) (<DELETE> =C) (<DELETE> =D) (<WRITE> |Correct!!|)
(answer correct)))

(system 
((eight =A) & =B (user-an ! =x) & =C (my-an ! /#x) & =D 
(PLACE lawn ! =y) & =E --> (<DELETE> =E)
(<DELETE> =B) (<DELETE> =C) (<DELETE> =D) (<WRITE>
|Wrong!! Buzzzzz.  Don't come back til you know the answer!|)
(wasat gate)(PLACE bus stop)))

(system 
((likes ! =x) & =A (likes ! /#x) & =B (PLACE ! =Y) & =C (eight  =Q) & =D
-->  (<DELETE> =d)
(<DELETE> =A) (<DELETE> =B) (<DELETE> =C)
(PLACE bus stop) (<WRITE> |Wrong!!  Make up your mind!|)))

(system 
((name ! =X) & =A (name ! /#x) & =B (PLACE ! =Y) & =C findsex & =D 
--> (<DELETE> =D)
(<DELETE> =A) (<DELETE> =B) (<DELETE> =C)
(PLACE bus stop) (<WRITE> |Wrong!!  Make up your mind!|)))

(system 
((eight 1) --> (<WRITE> |'What is your favorite color?'|)
(my-an blue) (user-an (<read>))))

(system 
((eight 2) --> (<WRITE> |'What U.S. University has the largest number of living alumni?'|)
(my-an MICHIGAN) (user-an (<read>))))

(system 
((eight 3) --> 
(<WRITE> |'What is the number of hairs in a bristle dartboard, in millions: 1, 2, ...?'|)
(my-an 16) (user-an (<read>))))

(system 
((eight 4) --> (<WRITE> |'What shipping lines owned the Titanic?'|) 
(my-an White STAR) (user-an (<read>))))

(system 
((eight 0) --> (<WRITE> |'What was the first production system with more than 1500 productions?'|)
(user-an haunt) (my-an (<read>))))

(system 
((eight 5) --> (<WRITE> |'What will permanently rob Superman of his powers?'|)
(my-an gold kryptonite) (user-an (<read>))))

(system 
((eight 6) --> 
(<WRITE> |'What is the full name (first middle and last) of the first test-tube baby?'|)
(my-an louise joy brown) (user-an (<read>))))

(system 
((eight 8) --> 
(<WRITE> |'What is the capital of Assyria?'|)
(my-an Nineveh) (user-an (<read>))))

(system 
((eight 7) --> (<WRITE> |'What is the air speed (in mph) of an unladen swallow?'|)
(my-an 95) (user-an (<read>))))

(system 
((eight 7) & =b  (my-an 95) & =c (user-an is that ! =x) & =A (PLACE lawn ! = ) 
--> 
(<DELETE> =a) (<DELETE> =b) (<DELETE> =c) (answer correct)
(<WRITE> |'Hmm.. let me see.  I used to know that.'|)
(<WRITE> |'Mumble  ... Oops, darn, I hit the wrong switch!'|)))

(system 
((eight 7) & =b  (my-an 95) & =c (user-an European or ! =x) & =A 
(PLACE lawn ! = ) --> 
(<DELETE> =a) (<DELETE> =b) (<DELETE> =c) (answer correct)
(<WRITE> |'Hmm.. let me see.  I used to know that.'|)
(<WRITE> |'Mumble  ... Oops, darn, I hit the wrong switch!'|)))

(system 
((eight 7) & =b  (my-an 95) & =c (user-an African or ! =x) & =A 
(PLACE lawn ! = ) --> 
(<DELETE> =a) (<DELETE> =b) (<DELETE> =c) (answer correct)
(<WRITE> |'Hmm.. let me see.  I used to know that.'|)
(<WRITE> |'Mumble  ... Oops, darn, I hit the wrong switch!'|)))

(system 
((eight 7) & =b  (my-an 95) & =c (user-an DO ! =x) & =A 
(PLACE lawn ! = ) --> 
(<DELETE> =a) (<DELETE> =b) (<DELETE> =c) (answer correct)
(<WRITE> |'Hmm.. let me see.  I used to know that.'|)
(<WRITE> |'Mumble  ... Oops, darn, I hit the wrong switch!'|)))

(system 
((eight 7) & =b  (my-an 95) & =c (user-an What ! =x) & =A 
(PLACE lawn ! = ) --> 
(<DELETE> =a) (<DELETE> =b) (<DELETE> =c) (answer correct)
(<WRITE> |'Hmm.. let me see.  I used to know that.'|)
(<WRITE> |'Mumble  ... Oops, darn, I hit the wrong switch!'|)))

(system 
 ((PLACE LAWN ISIDE 5 4)
  (INPUT OUVRE ! =Z)
  & =C (LARGE-DOOR CLOSED)
  & =B (LIKES ! =F)
  --> (<DELETE> =C)
  (<DELETE> =B)
  (LARGE-DOOR opened)
  (<WRITE> |The door creaks open.|)
  (<WRITE> |A voice from within says: 'Welcome,| (<CAPTOSM> ! =F) |lover.'|)))

(system 
((PLACE lawn iside 5 4) (INPUT ouvre ! =Z) & =A
(large-door opened) --> (<DELETE> =A) (<WRITE> |The door stays open.|)))

(system 
 ((PLACE LAWN ISIDE 5 4)
  (GOING N)
  & =A -->
  (<DELETE> =A)
  (<WRITE> |The door is closed, you bump your nose!|)))

(system 
 ((PLACE LAWN ISIDE 5 4)
  & =B (GOING N)
  & =A (LARGE-DOOR opened)
  -->   (PLACE FOYER)
  (<DELETE> =A)
  (<DELETE> =B)))

(system 
((PLACE lawn iside 5 4) (going n) & =A
(large-door opened) (holds mattress) --> (<DELETE> =A)
(<WRITE> |The mattress won't fit throught the door.|)))

(system
((PLACE lawn iside 5 4) (going n) 
 (large-door opened) (holds cube) & =B
--> (<DELETE> =B) (in cube lawn iside 5 4)
  (<WRITE> |You stumble over the threshold and drop the cube outside.|)))

(system
((PLACE lawn iside 5 4) (going n) (large-door opened) (holds marijuana)
& =A --> (<DELETE> =A)
(<WRITE> |The dope slips from your hand.|)
(in marijuana lawn iside 5 4)))

(system 
 ((PLACE LAWN ISIDE 5 4)
  (INPUT ENTER ! =X)
  & =A --> (<DELETE> =A)
  (GOING N) (WENT N)))

(system 
 ((PLACE LAWN ISIDE 5 4) (PLACE LAWN ISIDE 5 4)
  -->
  (<WRITE> |You are outside a large door in the front of an old mansion.|)))

(system 
 ((PLACE LAWN ISIDE 5 4)
  (INPUT KNOCK ! =X)
  & =A --> (<DELETE> =A) (<WRITE> |'Knock! Knock!'|)
  (INPUT OUVRE ! =X)))

(system 
 ((PLACE LAWN ISIDE 5 4)
  (INPUT RING ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |Ding dong!!|)
  (INPUT OUVRE)))

(system 
((INPUT ring ! =X) & =A --> (<DELETE> =A) (<WRITE> |I see no bell here.|)))

(system 
 ((PLACE LAWN ISIDE 5 4)
  (INPUT OPEN ! =X)
  & =A (LARGE-DOOR CLOSED)
  --> (<DELETE> =A)
  (<WRITE> |Didn't your mother teach you any manners?|)
  (<WRITE> |You shouldn't open someones door without their permission!|)))

(system 
 ((PLACE LAWN ISIDE 5 4)
  (LARGE-DOOR opened)
  & =B (INPUT CLOSE ! =X)
  & =A --> (<DELETE> =A)
  (<DELETE> =B)
  (LARGE-DOOR CLOSED)
  (<WRITE> |The door closes.|)))

(system 
 ((PLACE LAWN ISIDE 5 4)
  (SOUND IS ON)
  --> (<WRITE> |Muffled sounds can be heard inside.|)))

(system 
((PLACE lawn iside 8 8) (grave undug)
--> (<Write> |There is a fresh grave here.|)))

(system 
((PLACE lawn iside 8 8) (grave undug) & =A
(INPUT dig ! =X) & =B --> (<DELETE> =A) (<DELETE> =B)
(grave dug) (<WRITE> |Luckily, the dirt is soft.|)))

(system 
((PLACE lawn iside 8 8) (grave dug)
--> (<WRITE> |There is a open grave.|)))

(system 
((PLACE lawn iside 8 8) (grave dug)
& =A (INPUT dig ! =x) & =B --> (<DELETE> =A)  (<DELETE> =B)
(grave deep)))

(system 
((PLACE lawn iside 8 8) (grave deep)
--> (<WRITE> |There is a large pipe that goes through the grave.|)
(<WRITE> |There is a lever on the pipe labelled 'Emergency Release.'|)))

(system 
((PLACE lawn iside 8 8) 
(INPUT =x dirt ! =Y) & =A --> (<DELETE> =A) 
(<WRITE> |Hmmm.. I didn't understand that. I can only dig holes and fill in holes.|)))

(system 
((PLACE lawn iside 8 8)
(INPUT get dirt) & =A --> (<DELETE> =A)
(<WRITE> |Sorry, that won't wash.  I can only dig holes and fill in holes.|)
(<WRITE> |You can't get the dirt.|)))

(system 
((PLACE lawn iside 8 8) (INPUT
pull lever) & =A (grave deep) (time is =X) (<not> (fixed)) 
(<not> (grave oil)) --> (<DELETE> =A) 
(<WRITE> |Ummph!|)
(grave oil)(oil (<time-incr> =x 30))))

(system 
((PLACE lawn iside 8 8) (grave oil) 
--> (<WRITE> |There is oil seeping out of the pipe.|)))

(system 
((INPUT turn lever) & =A --> (<DELETE> =A) (INPUT pull lever)))

(system 
((INPUT throw lever) & =A --> (<DELETE> =A) (Input pull lever)))

(system 
((INPUT get lever) & =A --> (<DELETE> =A) (INPUT pull lever)))

(system 
((INPUT =x lever) & =A --> (<DELETE> =A) (<WRITE> |I don't understand the word| (<captosm> =x) |as a verb for lever.|)))

(system 
((INPUT push lever) & =A --> (INPUT pull lever) (<DELETE> =A)))

(system 
((INPUT close lever) & =A --> (<DELETE> =A) (INPUT pull lever)))

(system 
((grave oil) (INPUT pull lever) & =A --> (<DELETE> =A) (<WRITE> 
|The lever won't close, a special tool is needed!  
The oil continues to seep out.|)))

(system 
((PLACE lawn iside 8 8)
(INPUT =x oil) & =a --> 
(<DELETE> =A) (<WRITE> |The oil is too slippery to do anything with it.|)))

(system
((PLACE lawn iside 8 8)
(INPUT refill) & =A (walk =x) (grave =y) --> (<DELETE> =A)
(<WRITE> |You are unable to affect the driver's digging.|)))

(system
((PLACE lawn iside 8 8)
(INPUT refill) & =A (fixit =x) (grave =y) --> (<DELETE> =A)
(<WRITE> |You are unable to affect the driver's work.|)))

(system 
((PLACE lawn iside 8 8) 
(INPUT refill) & =A (grave oil) (grave deep) & =b -->
(<DELETE> =A) (<DELETE> =b) (grave dug) (<WRITE> |The oil still seeps out.|)))

(system 
((PLACE lawn iside 8 8) (grave deep) & =A
(INPUT refill) & =B --> (<DELETE> =A) (<DELETE> =B) 
(grave dug)))

(system 
((PLACE lawn iside 8 8) (grave dug) & =A
(INPUT refill) & =B --> (<DELETE> =A) (<DELETE> =B)
(grave undug)))

(system 
((INPUT oil ! =x) & =A (PLACE lawn iside 8 8)
--> (<DELETE> =A) (<WRITE> |The oil is too slippery to use.|)))

(system 
((INPUT fill in ! =X) & =A --> (<DELETE> =A) (INPUT refill)))

(system 
((INPUT fillin ! =X) & =A --> (<DELETE> =A) (Input refill)))

(system 
((INPUT cover ! =x) & =A --> (<DELETE> =A) (Input refill)))

(system 
((INPUT shovel ! =X) & =A --> (<DELETE> =A) (INPUT dig)))

(system 
((INPUT scoop ! =X) & =A --> (<DELETE> =A) (Input dig)))

(system 
((INPUT dig ! =X) & =A (PLACE lawn iside 8 8)
--> (<DELETE> =A) (<WRITE> |The ground is too hard to dig anymore.|)))

(system 
((INPUT refill ! =X) & =A (PLACE lawn iside 8 8)
--> (<DELETE> =A) (<WRITE> |The grave is filled.|)))

(system 
((grave dug) (<not> (got bone))
--> (got bone) (in bone lawn iside 8 8)))

(system 
((fixed) (PLACE lawn iside 8 8) -->
(<WRITE> |The oil is not seeping out, the lever has been fixed but can not be pulled.|)))

(system 
((fixed) (PLACE lawn iside 8 8) (INPUT pull ! =X) & =A
--> (<DELETE> =A) (<WRITE> |The lever won't budge.|)))
(system 
((sex male) & =A  --> (<DELETE> =A) (<WRITE> |'I assume that is a human male.'|) 
 (MALE)))

(system 
((sex (<any> men m man)) & =A --> (<DELETE> =A) (male)))

(system 
((sex little boy) & =A --> (<DELETE> =A) (male) (<WRITE> |'Hmm, so you go for the cute action.'|)))

(system 
((sex (<any> woman women f girl girls female)) & =A --> (<DELETE> =A) (female)))

(system 
((sex girl) & =A --> (<DELETE> =A) (female) (<WRITE> |'Can't handle a woman!'|)))

(system 
((sex boy) & =A --> (<DELETE> =A) (male) (<WRITE> |'Can't handle a man I guess.'|)))

(system 
((sex cunt) & =A --> (<DELETE> =A) (female) (<WRITE> |'I assume that is French for female.'|)))

(system 
((sex) &  =A --> (<DELETE> =A) (wants eunuch) (<WRITE>  |'Well, I assume you are asexual, you poor dear.'|)))

(system 
((sex yes) & =A --> (<DELETE> =A) (<WRITE> |'Cute, but seriously ....'|)
findsex))

(system 
((sex (<any> neither no none))  & =A --> (<DELETE> =A) (sex)))


(system 
((sex both) & =A --> (<DELETE> =A) (<WRITE> |'A little AC-DC huh?  OK, but for this adventure pick one.'|) findsex))

(system 
((name dracula) findsex --> (likes damsel) (<WRITE> |'You won't drink my blood.'|)))

(system 
((sex moose) & =A  --> (<DELETE> =A) (wants moose)
 (<WRITE> |'Hmm, so you like a mate with a good rack.'|)))

(system
((sex sheep) & =A --> (<delete> =a) (wants sheep)
(<write> |'They might be nice to cuddle up to on a winter's night,|)
(<write> | but I've never found them to be good conversationalists.'|)))

(system 
((sex dead ! =X) & =A --> (<DELETE> =A) (wants dead ! =X) 
(<WRITE> |'So you're a NECRO.'|)))

(system 
((female) & =A --> (<DELETE> =A) (wants damsel)))

(system 
((male) & =A --> (<DELETE> =A) (wants prince)))

(system 
((sex me) & =X (name ! =Y) --> (<DELETE> =x) (wants ! =Y) 
(<WRITE> |'In this game you might even get to play with yourself.'|)))

(system 
((sex myself) & =X --> (<DELETE> =X) (sex me)))

(system 
((name skins) -->  (<WRITE> |'Hey Dave'|)))

(system 
((name hook) -->  (<WRITE> |'Go for it Jon'|)))

(system 
((sex ! =X) & =A --> (<DELETE> =A) (WANTS ! =X)
(<WRITE> |'Your mother would faint if she knew that.'|)))

(system 
((name (<any>
adam al alan allan allen albert alex alfred andrew andy arnold art
arthur basil ben benjamin bert bill billy bob bobby brian bruce burt
carl cecil charles charlie chris chuck craig dan danny david dave dean
dick don donald douglas doug drew dwight ed edward elliot ernie frank
fred gary gene george gerry glen gordon gregory greg gus guy hal hank
harold harry harvey henry howard hugh jack james jay jeff jerry jim joe
john jon joseph kenneth ken kirk larry leroy lester lou louis lyle mack
mark marvin matt mathew max michael mickey mike miles mitchell mitch
morris nat nathaniel ned nick paul pete peter phil philip phillip ralph
raoul ray raymond richard rich rick rob robert robin rodney roger ross
roy russell rusty sam samuel sandy scott steve steven stuart ted thomas
tim timothy tod tom tommy tommie tony victor vincent wally walter will
william Hook skins bzm predeep anoop pedro satish hans
) ! =X) 
findsex -->
(likes damsel)))

(system 
((name (<any>
abby
amy anita ann anne annie april audrey babs barbara becky bess beth
betsy betty bonnie brenda bridget bunny candy carol carole karol carrie
cathy kathy cheryl christine cindy claudine cleopatra connie cynthia
dawn debby deborah denise diana diane dolly dinah donna doris dorothy
dotty dot edith elaine elizabeth emily eunice eve gail
gloria heather helen jackie jacqueline jan jane janet janice jean
jennifer jenny jessica jessie jill joan jody josephine joy joyce judith
judy julie karen kate katherine kathy kay kitty laura laverne linda
liza lisa lois loretta lucille lynn lynne mable mae maggie marcia marge
margaret marie marilyn marjorie mary maud may meg melissa michelle
mildred mindy molly monica nancy pamela pam pat patricia patty paula
pauline peggy penny rachel rebecca roberta rosie roxanne ruth sally
sandra sandy sarah sharon sheila sherry sheryl shirley sylvia stephanie
sue susan suzanne trudy vicky violet virginia vivian wanda wendy 
 ) ! =X) 
findsex --> (likes prince)))

(system 
((PLACE lawn iside 8 5) (enter =X) -->
(<WRITE> |You see a truck outside at the gate.|)))

(system 
((PLACE lawn iside (<gt> 6) 5) (enter =X) 
(time is =X)(time is =X) (time is =X) (input ! =z) -->
(<WRITE> |The gates open and the truck enters.  The gate closes before you can escape.|)
(<WRITE> |The truck says 'Oil line fixit' on the side.|)
(<WRITE> |The truck pulls in and parks on the drive.|)
(<WRITE> |The driver gets out and heads north east.|)))

(system 
((enter =x) (enter =x) (enter =X) (time is =X) (time is =X) (time is =X) 
(<not> (PLACE lawn iside (<gt> 6) 5)) (input ! =z) --> 
(<WRITE> |You hear a truck pull into the driveway and stop.|)))

(system 
((walk =X) (PLACE lawn iside 8 8) -->
(<WRITE> |The driver is digging to get a better angle on the pipe.|)))

(system 
((fixit =X) (PLACE lawn iside 8 8) -->
(<WRITE> |The driver is fixing the pipe.|)))

(system 
((fixit =x) (time is =X) (time is =X) (PLACE lawn iside 8 8) (input ! =z) -->
(<WRITE> |The driver is finished with the work, and heads back to the truck.|)))

(system 
((return =x)  (return =X) (time is =X) (time is =X) (input ! =z)
(PLACE lawn iside (<gt> 6) 5) -->
(<WRITE> |The man gets in the truck and backs out as the gate opens.|)
(<WRITE> |You are unable to escape as it leaves.|)))

(system 
((INPUT =X driver ! =Y) & =A --> (<DELETE> =A)
(<WRITE> |You are unable to contact or make contact with the driver.|)
(<WRITE> |It is as if he doesn't know you are there.|)))

(system 
((INPUT get truck) (INPUT get truck) & =A -->
(<DELETE> =A) (<WRITE> |The truck is a little heavy to get.|)))

(system 
((PLACE lawn iside 7 5) (in truck lawn iside 7 5) --> 
(<WRITE> |There is a panel truck here.|)))

(system 
((PLACE lawn iside 7 5) (in truck lawn iside 7 5) (INPUT mount truck) & =A -->
(<DELETE> =A) (<WRITE> |The truck is too tall to climb up on.|)))

(system 
((PLACE lawn iside 7 5) (in truck lawn iside 7 5) (INPUT open ! =Y) & =A -->
(<DELETE> =A) (<WRITE> |The front doors are locked, but you were able to open the back.|)
(truck open)))

(system 
((inside truck)(in truck lawn iside 7 5) (INPUT open ! =Y) & =A -->
(<write> |The back doors are now open.|)
(<DELETE> =A) (truck open)))

(system 
((PLACE lawn iside 7 5) (in truck lawn iside 7 5) (INPUT (<any> mount enter) ! =Y) & =A -->
(<DELETE> =A) (<WRITE> |None of the doors are open.|)))

(system 
((in truck lawn iside 7 5) (truck open) & =B  (INPUT close ! =Y) & =A
--> (<DELETE> =A) (<DELETE> =B) (<WRITE> |Ok.|)))

(system 
((PLACE lawn iside 7 5) & =B (in truck lawn iside 7 5) 
(truck open) (INPUT (<any> mount enter) ! =h) & =A
--> (<DELETE> =B)  (<DELETE> =A) (inside truck) 
    (<WRITE> |You are in the back of the truck.|)))

(system
((inside truck) (INPUT look ! =X) & =A --> (<DELETE> =A)
(<WRITE> |You are inside the panel truck.  It is empty.|)))

(system 
((in truck lawn iside 7 5)  (truck open) (inside truck) & =B 
(return =y) (return =Y) (time is =Y) (time is =Y) (input ! =z) --> 
(<WRITE> |As the truck starts up, it accelerates so fast that you fall out the back.|)
 (<DELETE> =B) (PLACE Lawn iside 7 5)))

(system 
((in truck lawn iside 7 5)  (inside truck) & =b (return =y) & =a
(return =Y) (time is =Y) (time is =Y)  (input ! =z) --> 
(<delete> =a) (<delete> =b)
(<WRITE> |VaVoom!  The truck has started up.|)
(<WRITE> |Bump bump! You feel yourself being driven out of the yard.|)
(going out)))

(system 
((PLACE lawn iside 7 5) (in truck lawn iside 7 5) (truck open) (INPUT (<any> mount enter) ! =R) & =A
(holds =Y) --> (<DELETE> =A) 
(<WRITE> |The| (<captosm> =Y) |won't fit through the door!|)))

(system 
((going out) & =B --> (<DELETE> =B) 
(<WRITE> |As you drive by the gate you hear from the speaker:|)
(<WRITE> |'Good job son!'|)
(<WRITE> ||)
(<WRITE> |The truck drives on for a while then stops.|)
(<WRITE> |Your open the truck door and find that you are outside the walls.|)
(<WRITE> |You've escaped!|)
(<WRITE> ||)
(<write> |In the distance you here the trumpeting of a bull moose.|)
(<WRITE> ||)
(<WRITE> |James Watt is here with a check for $10,000,000 to buy the land|)
(<WRITE> |for the Department of the Interior.|)
(<WRITE> |He assures you that the government will not sell the land, but admits|)
(<WRITE> |that he may allow some leasing of mineral rights.  You have the option|)
(<write> |of selling it and making big bucks, or you can donate, with the|)
(<write> |restriction that it be perserved in its current state.|)
(<write> |What is your choice?  Sell, or donate?|)
(Selldonate (<read>))))

(system
((Selldonate sell) & =a (score =x) & =b --> (<Delete> =a) (<delete> =b)
(<Write> |Hmm.  I don't think your father would have approved.|)
(<write> |Oh my god!  Out of the forest a moose comes charging at you.|)
(<write> |He is coming right at you.  You can't escape. |)
(<write> |ARGHH!  He gored you, but missed James Watt.|)
(<write> |You're dead, what a bummer after what you have been through.|)
(input stop)
(score (<-> =x 20))))

(system
((selldonate =x) & =a --> (<delete> =a)
(<write> |Make up your mind, Sell or donate.|)
(selldonate (<read>))))

(system 
((selldonate donate) & =a (score =x) & =b --> (<delete> =a) (<delete> =b)
(<write> |James Watt accuses you of being a reactionary idiot.|)
(<write> |He stomps off, mumbling, 'Those strip miners are going|)
(<write> |to be real disappointed', and walks right through a pile of moose turds.|)
(<write> |I think you made the right decision.|)
(gone) (score (<+> =X 20))))

(system 
((gone) --> (INPUT stop)))

(system 
((gone) & =A (score =X) & =B (in cube lawn ! =Y) -->
(<DELETE> =A) (<DELETE> =B) (score (<-> =X 50))
(INPUT stop) (<WRITE> |The police bust into the yard of the house to collect|)
(<WRITE> |your treasure for you.|)
(<WRITE> |Unfortunately they find the sugar cube with the LSD in it.|)
(<WRITE> |You are arrested and thrown in jail for 50 years!!!!!|)
(<WRITE> |What a loser!|)))

(system 
((gone) & =A (score =X) & =B (in marijuana lawn ! =Y) --> 
(<DELETE> =A) (<DELETE> =B) (score (<-> =X 20))
(INPUT stop) 
(<WRITE> |The police bust into the yard of the house to collect your treasure for you.|)
(<WRITE> |They find the marijuana!!  Luckily you are in the state of confusion|)
(<WRITE> |and you get a $5 fine, but lose the $300 worth of pot.|)
(<WRITE> |Oh well, maybe next time you'll enjoy it first.|)))

(system 
((inside truck) & =A (INPUT get out) & =B (truck open) --> 
(<DELETE> =B) (<DELETE> =A) (PLACE lawn iside 7 5)))

(system 
((holds jade) (score =Y) & =A (<not> (scored jade)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored jade)))

(system 
((holds bone) (score =Y) & =A (<not> (scored bone)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored bone)))

(system 
((holds gem) (score =Y) & =A (<not> (scored gem))  -->
(<DELETE> =A) (score (<+> =y 15)) (scored gem)))


(system 
((in corkscrew lawn ! =X)  -->
 (yscored corkscrew)))

(system 
((in diamonds lawn ! =X)  -->
 (yscored diamond)))

(system 
((in jade lawn ! =X)  -->
 (yscored jade)))

(system 
((in bone lawn ! =X)  -->
 (yscored bone)))

(system 
((in gem  lawn ! =X)  -->
 (yscored gem)))

(system 
((in chest lawn ! =X)  -->
 (yscored chest)))

(system 
((in horn lawn ! =X)  -->
 (yscored horn)))

(system 
((in gold lawn ! =X)  -->
 (yscored gold)))

(system 
((in football lawn ! =X)  -->
 (yscored football)))

(system 
((in stereo lawn ! =X)  -->
 (yscored stereo)))

(system 
((in ring lawn ! =X)  -->
 (yscored ring)))

(system 
((in candlesticks lawn ! =X)  -->
 (yscored candlesticks)))

(system 
((in marijuana lawn ! =X)  -->
 (yscored marijuana)))

(system 
((in cube lawn ! =X)  -->
 (yscored cube)))

(system 
((in conch lawn ! =x)  -->
 (yscored conch)))

(system 
((in money lawn ! =X)  -->
 (yscored money)))

(system 
((in painting lawn ! =X)  -->
 (yscored painting)))

(system 
((in bottle lawn ! =X) (inside water bottle) 
 -->  (yscored bottle)))

(system 
((in pearls lawn ! =X)  -->
 (yscored pearls)))

(system 
((in chair lawn ! =X)  -->
 (yscored chair)))

(system 
((in coins lawn ! =X)  --> 
 (Yscored coins)))

(system 
((yscored =X) & =A (xscore =X) (score =z) --> (<DELETE> =A)))

(system 
((yscored =X) & =A (score =y) & =B --> (<DELETE> =A) (<DELETE> =B)
(score (<+> 5 =Y)) (xscore =X)))

(system
((INPUT pour ! =X) (holds bottle) (PLACE ! =Y) (xscore yth) & =A
(score =z) & =b --> (<DELETE> =A) (<DELETE> =B)
(score (<-> =z 5))))

(system
((PLACE foyer) (xscore =X) & =A (holds =X) (score =Y) & =B -->
(<DELETE> =A) (<DELETE> =B) (score (<-> =y 5))))
