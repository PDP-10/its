(SYSTEM 
(BDIE & =A (PLACE ! =X) & =B (score =Y) & =C (<not> DIED) -->
(score (<-> =Y 20)) (PLACE dark hall) (<DELETE> =A) (<DELETE> =B)
(<DELETE> =C) (<WRITE> | |)
(<WRITE> |Neptune appears and blows new life in your body!|)
(<WRITE> |You return to life but neptune doesn't want you back in his world again.|)
 (elevator broke) DIED))

(SYSTEM 
(BDIE & =A DIED & =B --> (<DELETE> =A) (<DELETE> =B)
HALT))

(SYSTEM 
((orc suicide =X) & =A (time is =X) (time is =X) UNDERWATER & =B 
--> (<DELETE> =B) (<DELETE> =A) BDIE 
(<WRITE> |You can't stand it anymore, you are now totally crazy.|)
(<WRITE> |You start laughing uncontrollably, but you|)
(<WRITE> |lose the regulator on your wetsuit and can't get any air.|)
(<WRITE> |Ugh! Well at least you died happy!|)))
 
(SYSTEM 
(UNDERWATER (<not> (wears wetsuit)) --> DROWN))

(SYSTEM
((PLACE ocean =y =x 6) DROWN & =A --> (<DELETE> =a)))

(SYSTEM
(BDIE BDIE BDIE UNDERWATER & =A --> (<DELETE> =A)))

(SYSTEM
(BDIE BDIE BDIE (wears wetsuit) & =A --> (<DELETE> =A)))

(SYSTEM 
(DROWN & =A --> (<DELETE> =A) 
(<WRITE> |The water fills your lungs, choke, cough!|) 
(<WRITE> |Your life passes before your eyes.|)
(<WRITE> |Maybe next time you'll remember to get a wetsuit.|)
BDIE))

(SYSTEM 
((PLACE bathysphere) (PLACE bathysphere) (<not> (WASAT bathysphere)) -->
(<WRITE> |You are in the airlock of a bathysphere.  To the south is a|)
(<WRITE> |large water tight door.  There are a green and red buttons near the door.|)
(<WRITE> |There is the elevator to the north, with its white button.|)
(<WRITE> | |) 
(<WRITE> |Through a window you can see the murky depths.|)))

(SYSTEM 
((PLACE bathysphere) (wdoor closed) (water IS out)
(INPUT open door) & =A --> (<DELETE> =A) (<WRITE> |The door won't open.|)))

(SYSTEM 
((PLACE bathysphere) (wdoor closed) & =A UNDERWATER
(INPUT open ! =Q) & =B --> (<DELETE> =A) (<DELETE> =B) (wdoor opened)
(<WRITE> |The water tight door opens.|)))

(SYSTEM 
((PLACE bathysphere) UNDERWATER
(INPUT press red ! =X) & =A --> 
(<DELETE> =A) (<WRITE> |Nothing happens.|)))

(SYSTEM 
((PLACE bathysphere) (wdoor closed) UNDERWATER
& =A (INPUT press green ! =Y) & =B --> (<DELETE> =A) (<DELETE> =B)
(water IS out) (<WRITE> |The water drains out, it is now dry.|)))

(SYSTEM 
((PLACE bathysphere) (wdoor closed) (water IS out) 
(INPUT press green ! =Y) & =B --> 
(<DELETE> =B) (<WRITE> |Nothing happens.|)))

(SYSTEM 
((PLACE bathysphere) (wdoor closed) (water IS out) & =A 
(INPUT press red ! =Y) & =B --> (<DELETE> =A) (<DELETE> =B) 
UNDERWATER (<WRITE> |Water rushes in and fills the chamber.|)))

(SYSTEM 
((PLACE bathysphere) (elevator closed) & =B
(INPUT press white ! =Y) & =A --> (<DELETE> =A) (<DELETE> =B)
(elevator opened) (<WRITE> |The elevator door opens.|)))

(SYSTEM 
((PLACE bathysphere) & =A (elevator opened)
(GOING n) & =B --> (<DELETE> =A) (<DELETE> =B)
(WASAT bathysphere) (PLACE elevator)))

(SYSTEM
((PLACE BATHSYPHERE) (INPUT ENTER ! =X) & =A --> (<DELETE> =A)
(GOING N) (WENT N)))

(SYSTEM 
((PLACE bathysphere)  (elevator opened) & =A
UNDERWATER & =c --> (<DELETE> =C) (<DELETE> =A) 
(<WRITE> |The water rushes into the elevator.|)
(<WRITE> |As it fills with water, the elevator begins to shake.|)
(<WRITE> |Suddenly the elevator car disappears down the shaft and the|)
(<WRITE> |rushing water pushes you down the shaft to your death.|)
BDIE))

(SYSTEM 
((PLACE bathysphere) & =A (wdoor opened) 
(GOING S) & =B --> (<DELETE> =A) (<DELETE> =B) 
(WASAT bathysphere) (PLACE ocean 5 3 5)))

(SYSTEM 
((PLACE bathysphere) (wdoor opened) & =A
(INPUT close ! =x) & =B --> (<DELETE> =A) (<DELETE> =B) 
(wdoor closed) (<WRITE> |The water tight door is closed.|)))

(SYSTEM 
((PLACE bathysphere) (wdoor opened) (INPUT press green ! =X) & =A -->
(<DELETE> =A) (<WRITE> |Nothing happens.|)))

(SYSTEM 
((PLACE bathysphere) UNDERWATER (HOLDS cube) & =A --> (<DELETE> =A) 
(<WRITE> |The water dissolves the sugar cube.|)))

(SYSTEM 
((PLACE bathysphere) UNDERWATER 
(HOLDS candy) & =A --> (<DELETE> =A)
(<WRITE> |The water dissolves the candy.|)))

(SYSTEM 
((in candy bathysphere) & =A UNDERWATER
--> (<DELETE> =A) (<WRITE> |The water dissolves the candy.|)))

(SYSTEM 
((PLACE bathysphere) UNDERWATER
(HOLDS painting) & =A --> (<DELETE> =A)
(<WRITE> |The water destroys the painting.  It disappears.|)))

(SYSTEM 
((IN painting bathysphere) & =A UNDERWATER --> (<DELETE> =A) 
(<WRITE> |The water destroys the painting, it disappears.|)))

(SYSTEM 
((IN cube bathysphere) & =A UNDERWATER 
--> (<DELETE> =A) (< write> |The water dissolves the sugar cube.|)))

(SYSTEM 
((PLACE bathysphere) UNDERWATER (holds marijuana) & =A --> 
(<DELETE> =A)
(<WRITE> |The water ruins the marijuana and it is lost in the water.|)))

(SYSTEM 
((in marijuana bathysphere) & =A UNDERWATER -->
(<DELETE> =A) (<WRITE> |The incoming water destroys the marijuana.|)))
(SYSTEM 
((PLACE ocean (<GT> 1) & =C ! =REST) & =A (GOING N) & =B --> 
(<DELETE> =A) (<DELETE> =B)  (PLACE OCEAN (<-> =C 1) ! =REST)))

(SYSTEM 
((PLACE ocean (<GT> 0) & =S ! =rest) & =A (GOING s) & =B
--> (<DELETE> =A) (<DELETE> =B) 
(PLACE ocean (<+> 1 =S) ! =rest)))

(SYSTEM 
((PLACE ocean =s (<GT> 1) & =E =u) & =A (GOING w) & =B
--> (<DELETE> =A) (<DELETE> =B) 
(PLACE ocean =s (<-> =E 1) =U)))

(SYSTEM 
((PLACE ocean =S (<GT> 0) & =E =U) & =A (GOING E) & =B
--> (<DELETE> =A) (<DELETE> =B) 
(PLACE ocean =s (<+> 1 =e) =U)))

(SYSTEM 
((PLACE ocean =S =E (<GT> 0) & =U) & =A (GOING U) & =B
--> (<DELETE> =A) (<DELETE> =B)
(PLACE ocean =S =E (<+> 1 =U))))

(SYSTEM 
((PLACE ocean =s =e (<GT> 1) & =U) & =A (GOING D) & =B
--> (<DELETE> =a) (<DELETE> =B)
(PLACE ocean =S =E (<-> =U 1))))

(SYSTEM 
((PLACE ocean 1 =E =U) (GOING n) & =A --> (<DELETE> =A) 
(<WRITE> |You'd run into a sandy wall if you go that way.|)))

(SYSTEM 
((PLACE ocean 1 =e =u) --> 
(<WRITE> |There is an underwater sandy cliff to the north.|)))

(SYSTEM 
((PLACE ocean 1 =E 6) -->
(<WRITE> |There is a sandy beach that rises from the sandy cliff.|)))

(SYSTEM 
((PLACE ocean 1 =e 6) & =A
UNDERWATER & =Q
(GOING n) & =B --> (<DELETE> =A) (<DELETE> =B) 
(<DELETE> =Q) (PLACE beach =E)))

(SYSTEM 
((PLACE ocean =s =e 6) (<not> (hiwater)) -->
(hiwater) 
(<WRITE> |The waves are very choppy, making it difficult to see very far.|)
(<WRITE> |Looking overhead you see that you are still underground.|)
(<WRITE> |There is a rock ceiling 500 feet above.|)))

(SYSTEM 
((PLACE ocean =s =e 6) -->
(<WRITE> |You are on the surface.|)))

(SYSTEM 
((PLACE ocean =S =E 6)
(GOING u) & =A --> (<DELETE> =A) 
(<WRITE> |You are as high as you'll get.|)))

(SYSTEM 
((PLACE ocean 5 3 5) -->
(<WRITE> |You are outside the bathysphere.  The door is to the north.|)))

(SYSTEM 
((PLACE ocean 5 3 5) (INPUT close ! =X) & =A --> (<DELETE> =A) 
(<WRITE> |The door can only be closed from the inside.|)))

(SYSTEM 
((PLACE ocean 5 3 5) & =A (GOING N) & =B -->
(<DELETE> =A) (<DELETE> =B) (PLACE bathysphere)))

(SYSTEM 
((PLACE ocean ! =rest) (INPUT enter ! =X) & =A
--> (<DELETE> =A) (GOING N) (WENT N)))

(SYSTEM 
((PLACE ocean ! =rest) --> (<WRITE> |You are in sea water.|)))

(SYSTEM 
((PLACE ocean =S =E 1) -->
(<WRITE> |You are at the bottom of the ocean.|)))

(SYSTEM 
((PLACE ocean =s =e 1) (GOING d) & =A
--> (<DELETE> =A) (<WRITE> |You can't go through the sea floor.|)))

(SYSTEM 
((PLACE ocean =s =E 1) (INPUT dig ! =X) & =A
--> (<DELETE> =A) (<WRITE> |The sea bed is too hard.|)))

(SYSTEM 
((PLACE ocean 5 =e =U) -->
(<WRITE> |There is seaweed around here.|)))

(SYSTEM 
((PLACE ocean 6 =e =U) -->
(<WRITE> |The seaweed is very thick now.|)))

(SYSTEM 
((PLACE ocean 6 =e =u) 
(GOING s) & =B --> (<DELETE> =B) 
(<WRITE> |The seaweed is too thick to penetrate.|)))

(SYSTEM 
((PLACE ocean =s =e =U) (HOLDS speargun)
(speargun IS loaded) & =A (INPUT shoot ! =X) & =B
--> (<DELETE> =A) (<DELETE> =B) (IN spear ocean =s =e 1)
(speargun IS unloaded) (<WRITE> |You missed whatever you shot at.|)))

(SYSTEM 
((PLACE ocean =s 1 =U) -->
(<WRITE> |To the west is a wall of ice, you can't get through it.|)))

(SYSTEM 
((PLACE ocean =s 1 =U) (GOING w) & =A -->
(<DELETE> =A) (<WRITE> |You bump into the ice wall.|)))

(SYSTEM 
((PLACE ocean =s 2 6) -->
(<WRITE> |There is a misty fog to the west that you can't see through.|)))

(SYSTEM 
((PLACE ocean =s 2 =U) --> (<WRITE> |The water is very cold.|)))

(SYSTEM 
((PLACE ocean =s 6 =U) -->
(<WRITE> |There is a rock cliff to the east.|)))

(SYSTEM 
((PLACE ocean =s 6 =U)(GOING e) & =A --> (<DELETE> =A) 
(<WRITE> |Ouch, you ran into the rock wall.|)))

(SYSTEM 
((PLACE ocean 4 3 5) (Went =x) -->
(<WRITE> |You bumped into the bathysphere I think.|)
(INPUT back)))

(SYSTEM 
((PLACE ocean (<GT> 4) (<GT> 4) 6) 
--> (<WRITE> |You seem to be in a warm current of water.|)))

(SYSTEM 
((PLACE ocean (<GT> 5) (<GT> 5) 5) --> 
(<WRITE> |The water is very warm here.|)))

(SYSTEM 
((PLACE ocean 5 6 4) --> (<WRITE> |The water is hot is this area.  |)
(<WRITE> |There is a hole in the east wall.|)))

(SYSTEM 
((PLACE ocean 5 6 4) & =A (GOING e) & =B --> (<DELETE> =A) (<DELETE> =B)
 (PLACE hot water)))

(SYSTEM 
((HOLDS gold) (PLACE ocean ! =X) -->
(sinks)))

(SYSTEM 
((HOLDS chest) (PLACE ocean ! =X) -->
(sinks)))

(SYSTEM 
((HOLDS stereo) (PLACE ocean ! =x) -->
(sinks)))

(SYSTEM 
((HOLDS candlesticks) (PLACE ocean ! =x) -->
(sinks)))

(SYSTEM 
((holds coins) (PLACE ocean ! =X) --> (sinks)))

(SYSTEM 
((sinks) & =A (PLACE ocean =S =E 1) --> (<DELETE> =A)))

(SYSTEM 
((sinks) & =A (PLACE ocean =s =E =U) & =B 
--> (<DELETE> =A) (<DELETE> =B) (PLACE ocean =s =E 1)
(<WRITE> |The weight of something you're carrying has pulled you to the bottom.|)))

(SYSTEM 
((IN =x ocean ! =rest) --> (Sink or float =X)))

(SYSTEM 
((sink or float =x) & =A (IN =x ocean =S =E =U)
& =B --> (<WRITE> |It sinks out of sight.|)
 (<DELETE> =A) (<DELETE> =B) (IN =x ocean =S =E 1)))

(SYSTEM 
((sink or float =x) & =A (IN =X ocean =S =e 1) --> (<DELETE> =A)))

(SYSTEM 
((sink or float stool) & =A (IN stool ocean =S =E =U) & =B 
--> (<DELETE> =A) (<DELETE> =B) 
(<WRITE> |The stool floats up and away.|)
(IN stool ocean =S =E 6)))

(SYSTEM 
((sink or float stool) & =A (IN stool ocean =S =E 6) --> 
(<DELETE> =A)))

(SYSTEM 
((sink or float football) & =A (IN football ocean =S =E =U) & =B 
--> (<DELETE> =A) (<DELETE> =B)
(<WRITE> |The football disappears as it floats away.|)
(IN football ocean =s =E 6)))

(SYSTEM 
((sink or float football) & =A 
(IN football ocean =S =E 6) --> (<DELETE> =A)))

(SYSTEM 
((sink or float bottle) & =A (IN bottle ocean =S =E
=U) & =B (<not> (INSIDE =z bottle)) --> (<DELETE> =A) (<DELETE> =B)
(<WRITE> |The bottle disappears as it floats away.|)
(IN bottle ocean =s =E 6)))

(SYSTEM 
((sink or float bottle) & =A (<not> (INSIDE =z bottle))
(IN bottle ocean =S =E 6)--> (<DELETE> =A)))

(SYSTEM 
((PLACE ocean 2 2 1) 
(octopus IS alive) --> 
(<WRITE> |There is a huge octopus huddling in the shadows.|)))

(SYSTEM 
((PLACE ocean 2 2 1)
(octopus IS alive) (INPUT get chest) (INPUT get chest) & =A
--> (<DELETE> =A) 
(<WRITE> |The octopus prevents you from getting the chest.|)))

(SYSTEM
((PLACE ocean 2 2 1) (octopus is alive) (in cecil ocean 2 2 1) & =A
--> (<DELETE> =A) (<WRITE> |Cecil doesn't mess with octopus, you're going to have handle it yourself.|)))

(SYSTEM 
((PLACE ocean 2 2 1)
(octopus IS alive) & =A (IN chest ocean 2 2 1) & =B
(INPUT shoot =X) & =A -->
(<DELETE> =A) (<DELETE> =B) (<DELETE> =C) (INPUT shoot speargun)
(<WRITE> |The octopus emits a cloud of black ink|)
(<WRITE> |and disappears forever with the treasure.|)))


(SYSTEM 
((PLACE ocean 2 2 1)
(octopus IS alive) (INPUT kill octopus) & =a -->
(<DELETE> =A) (<WRITE> |You'd be the kind to try and wrestle an octopus.|)))

(SYSTEM 
((PLACE ocean 2 2 1)
(octopus IS alive) & =A (INPUT wrestle ! =x) & =B -->
(<DELETE> =A) (<DELETE> =B)  (<WRITE>
|You grab arm 1.  He gets you in a body hold.  You grab arm2.|)
(<WRITE> |He gets you in a head hold.  You tie arm1 to arm2.|)
(<WRITE> |With his remaining SIX arms he throws you straight up.|)
(<WRITE> |You clear the water and notice the fine bathing beach to|)
(<WRITE> |the north.  But you don't give up.  Down you go, deeper, deeper.|)
(<WRITE> |You sight him again and sneak up while he is attemping to untie his legs.|)
(<WRITE> |Quickly you try the Vulcan death grip.  Unfortunately, there is no|)
(<WRITE> |Vulcan death grip, but that does not stop you.|)
(<Write> |He is about to turn on you and squeeze you to death when you|)
(<WRITE> |remember the overhand octopus knot, and tie up arms 3 4 5 6 7 and 8.|)
(<WRITE> |He appears disgruntled and swims away.|)))


(SYSTEM 
((PLACE beach =E) (<not> (WASAT beach)) -->
(WASAT beach) (<WRITE> 
|You are on the white sands of a beautiful beach that runs east west.|)
(<WRITE> |To the north are unclimbable cliffs.|)))

(SYSTEM 
((PLACE beach =e) --> (<WRITE> |There is cool sand beneath your feet.|)))

(SYSTEM 
((PLACE beach =e) & =A (GOING s) & =B
--> UNDERWATER (<DELETE> =A) (<DELETE> =B)
(PLACE ocean 1 =E 6)))

(SYSTEM 
((PLACE beach (<GT> 1) & =E) & =A (GOING w) & =B
--> (<DELETE> =a) (<DELETE> =B) (PLACE beach (<-> =E 1))))

(SYSTEM 
((PLACE beach (<GT> 0) & =E) & =A (GOING E) & =B
--> (<DELETE> =A) (<DELETE> =B) (PLACE beach (<+> 1 =E))))

(SYSTEM 
((PLACE beach 6) --> (<WRITE> |You have come to a hard stone cliff.|)))

(SYSTEM 
((PLACE beach 1)-->
(<WRITE> |You have reach a wall of ice! Brrrr!|)))

(SYSTEM 
((PLACE beach =E) (INPUT dig ! =X) & =A -->
(<DELETE> =a) (<WRITE> |You don't find anything under the sand.|)))

(SYSTEM 
((PLACE beach 3) --> (<WRITE> 
|You have come across a pool of water.|)
(<WRITE> |There are words saying 'unta  o  out' on the side.|)))

(SYSTEM 
((PLACE beach 5) (INPUT dig ! =X) & =A
(<not> (scored conch)) --> (<DELETE> =A) 
(IN conch beach 5)))

(SYSTEM 
((HOLDS conch) (PLACE beach ! =X) (INPUT blow conch) & =A -->
(<DELETE> =A) (<WRITE>
|'Toot!! Toot!!' The water near the beach begins to bubble.|)
(<WRITE> |A large form emerges from the foam.|)
(IN cecil beach ! =X)))

(SYSTEM 
((HOLDS conch) UNDERWATER (INPUT blow conch) & =B
--> (<DELETE> =B) (<WRITE> |Blaaat! You are in the ocean, and can't blow it well.|)))

(SYSTEM 
((IN cecil ! =X) (PLACE ! =X) -->
(<WRITE> |There is a large sea serpent here.  He looks friendly|)
(<WRITE> |and he 'slurp!' licks your face.|)))

(SYSTEM
((in cecil ! =x) (PLACE ! =x) (INPUT =z loch ness ! =o) & =a
--> (<DELETE> =A) (<WRITE> |This isn't Scotland, and that isn't Nessie.|)))

(SYSTEM 
((INPUT =z ness ! =o) & =a
--> (<DELETE> =a) (INPUT =z loch ness)))

(SYSTEM
((INPUT =z nessie ! =o) & =a --> (<DELETE> =a)
(INPUT =z loch ness)))
(SYSTEM 
((IN cecil ! =X) (PLACE ! =X) (INPUT Hi cecil) & =A
--> (<DELETE> =A) (<WRITE> |The sea serpent replys: 'Hi Beanie Boy.'|)
(<WRITE> |If you ever need help, you know what to say.|)))

(SYSTEM 
((INPUT Hello cecil) & =A --> (<DELETE> =A) (INPUT hi cecil)))

(SYSTEM 
((INPUT pet ! =X) & =A --> (<DELETE> =A) (INPUT hi cecil)))

(SYSTEM 
((IN cecil ! =x) & =A (PLACE ! =x)
(INPUT shoot ! =y) --> (<DELETE> =A) 
(<WRITE> |The sea serpent is upset and leaves.|)))

(SYSTEM 
((IN cecil ! =X) (PLACE ! =x) (INPUT kill serpent) & =A
--> (<DELETE> =A) (INPUT shoot serpent)))

(SYSTEM 
((IN cecil ! =X) (PLACE ! =x) (INPUT =y serpent) & =A
--> (<DELETE> =A) (<WRITE> |The sea serpent should be address by its real name.|)))

(SYSTEM 
((IN cecil ! =x) (PLACE ! =X) (INPUT =y sea serpent) & =A
--> (<DELETE> =A) (Input =y serpent)))

(SYSTEM 
((IN cecil ! =W) & =A (GOING =X) (GOING =x) --> (<DELETE> =A)))


(SYSTEM 
((PLACE beach =E) (INPUT build sandcastle) & =A
--> (<DELETE> =A) (sandcastle beach =E) 
(INPUT dig hole)))

(SYSTEM 
((PLACE beach =E) (sandcastle beach =E)
--> (<WRITE> |There is an elegant sandcastle on the beach.|)))

(SYSTEM 
((INPUT make sandcastle) & =A --> (<DELETE> =A) (INPUT build sandcastle)))

(SYSTEM 
((PLACE beach =E) (sandcastle beach =E) & =A
(INPUT =x sandcastle) & =B --> (<DELETE> =A) (<DELETE> =B)
(<WRITE> |The sandcastle is destroyed.  There is only sand.|)))

(SYSTEM 
((INPUT =x sand castle) & =A --> (<DELETE> =a) (Input =X sandcastle)))

(SYSTEM 
((INPUT =x castle) & =A --> (<DELETE> =A) (INPUt =X sandcastle)))

(SYSTEM
((INPUT Get Sand) & =A --> (<DELETE> =A) 
(<WRITE> |The sand falls through your fingers.|)))

(SYSTEM 
((PLACE beach 3)  (INPUT drink ! =X) & =A
--> (<DELETE> =A) (<WRITE> |The water tastes cool and refreshing.|)
(<WRITE> |I like to drink wa wa.  Um Um.  goo goo poo touh goo moo.|)
(<Write> |(I think you're a little too young to continue this adventure.)|)
BDIE))

(SYSTEM 
((PLACE beach 1) (GOING w) & =A --> (<DELETE> =A)
(<WRITE> |You can't go there.|)))

(SYSTEM 
((PLACE beach 6) (GOING e) & =A --> (<DELETE> =A)
(<WRITE> |You lose, the way is blocked.|)))

(SYSTEM 
((PLACE ocean (<GT> 1) (<GT> 1) 6)
(seamonster IS alive) --> (<WRITE> |There is a angry ugly sea monster trying|)
(<WRITE> |to eat you.|) (seamonster IS near)))

(SYSTEM 
((seamonster IS alive) & =A (seamonster IS near) & =B (Holds speargun)
(INPUT shoot ! =x) & =D (speargun IS loaded) & =c -->
(<DELETE> =A) (<DELETE> =B) (<DELETE> =C) (<DELETE> =D) (speargun IS unloaded)
(IN spear ocean 4 1 1)
(<WRITE> |You slay the monster.|)))

(SYSTEM 
((seamonster IS alive) (seamonster IS near) & =a
(GOING =X) & =B --> (<DELETE> =A) (<DELETE> =B) 
(<WRITE> |As you try and flee, you chicken, the sea monster eats you.  Yum yum.|) BDIE))

(SYSTEM
((INPUT =x sea monster ! =Y) & =A --> (<DELETE> =A)
(Input =x seamonster)))

(SYSTEM
((INPUT =X monster ! =Y) & =A (seamonster is near) -->
(<DELETE> =A) (INPUT =X seamonster ! =Y)))

(SYSTEM 
((seamonster IS alive) & =A (seamonster IS near) & =B
(IN cecil ocean ! =X) (PLACE ocean ! =x) -->
(<DELETE> =A) (<DELETE> =B) 
(<WRITE> |The sea serpent licks the monster to death.|)))


(SYSTEM 
((seamonster is near) (holds =y) & =A (INPUT =q seamonster) & =B
--> (<DELETE> =A) (<DELETE> =B)
(<WRITE> |While you were wasting your time trying to| (<captosm> =q))
(<WRITE> |the seamonster, he attacked! You avoided him, but he ate your|)
(<WRITE> (<captosm> =y) |.  You better come up with another idea.|)))

(SYSTEM 
((PLACE ocean ! =x) (INPUT help cecil help) (INPUT help cecil help) 
(INPUT HELP CECIL HELP) & =A -->
(<DELETE> =A) (IN cecil ocean ! =X)))

(SYSTEM 
((PLACE ! =X) (IN CECIL ! =X) (INPUT HELP CECIL HELP) & =A
--> (<DELETE> =A) (<WRITE> |Cecil is already here.|)))


(SYSTEM 
((PLACE hot water) 
--> (<WRITE> |You are in a small tunnel in the rock wall.|)
(<WRITE> |It is very hot, but you are protected by your magic wetsuit.|)
(<WRITE> |It is too dark to see, so you must guess at directions.|)))

(SYSTEM 
((PLACE hot water) & =A (GOING w) & =B -->
(<DELETE> =A) (<DELETE> =B)
(PLACE ocean 5 6 4)))

(SYSTEM 
((PLACE hot water) & =A (GOING d) & =B -->
(<DELETE> =A) (<DELETE> =B)
(PLACE black water)))

(SYSTEM 
((PLACE black water) -->
 (<WRITE> |You are in water that is completely black.|)))

(SYSTEM 
((PLACE black water) & =A (GOING u) & =B -->
(<DELETE> =A) (<DELETE> =B) (PLACE hot water)))

(SYSTEM 
((PLACE black water) & =A (GOING e) & =B -->
 (<DELETE> =A) (<DELETE> =B) (PLACE end dead)))

(SYSTEM 
((PLACE end dead) (PLACE end dead) -->
(<WRITE> |The water is a little cooler here.|)))

(SYSTEM 
((PLACE end dead) & =A (GOING w) & =B -->
(<DELETE> =A) (<DELETE> =B) 
(PLACE black water)))

(SYSTEM 
((PLACE end dead) (moray eel is alive) -->
(<WRITE> |There is a vicious eel here.  He grabs you and starts squeezing.|)
(<WRITE> |You have time for one last request.|)
(IN pearls end dead)
(person will die)))

(SYSTEM 
((PLACE end dead) (moray eel is alive)
(HOLDS speargun) & =A --> (<DELETE> =A)
(IN speargun black water) (<WRITE> |Something grabs the speargun from you and tosses it away.|)))

(SYSTEM 
((person will die) & =B (INPUT pray ! =X) & =A (PLACE end dead) -->
(<DELETE> =A) (<DELETE> =B) 
(<WRITE> |You are struck down by a lightening bolt.|)
BDIE))

(SYSTEM 
((person will die) & =A (INPUT ! =X) & =B (PLACE end dead) -->
 (<DELETE> =A) (<DELETE> =B) 
(<WRITE> |Wrong request! BUZZZ|)
BDIE))

(SYSTEM 
((person will die) & =A (moray eel is alive) & =B
(PLACE end dead)
(INPUT help cecil help) & =C --> (<DELETE> =A) (<DELETE> =B)
(<DELETE> =C) (IN cecil end dead) (<WRITE> |'I'm coming Beanie boy!'|) 
(<WRITE> |Cecil grabs the eel by the neck and hurls it away.|)))

(SYSTEM 
((PLACE black water) & =A (GOING w) & =B -->
(<DELETE> =A) (<DELETE> =B) (PLACE hotter water)))

(SYSTEM 
((PLACE hotter water) --> (<WRITE> |It's quite toasty here.|)))

(SYSTEM 
((PLACE hotter water) & =A (GOING e) & =B -->
(<DELETE> =A) (<DELETE> =B) (PLACE black water)))

(SYSTEM 
((PLACE hotter water) & =A (GOING n) & =B -->
(<DELETE> =A) (<DELETE> =B) (PLACE hot spring)))

(SYSTEM 
((PLACE hot spring) 
--> (<WRITE> |You are in the middle of a hot spring.  |)
(<WRITE> |Above you is light.|)))

(SYSTEM 
((PLACE hot spring) & =A (GOING s) & =B -->
(<DELETE> =A) (<DELETE> =B) 
(PLACE hotter water)))

(SYSTEM 
((PLACE hot spring) & =A (GOING u) & =B UNDERWATER & =C -->
(<DELETE> =C) (<DELETE> =B) (<DELETE> =A) 
(PLACE cave) (<WRITE> |As you go up, you come out of the water and are on dry ground.|)))

(SYSTEM 
((PLACE cave) (PLACE cave) 
--> (<WRITE> |You are in a warm cave.  There is a hot spring down below.|)
(<WRITE> |The PLACE is lit with luminous moss.  The only way out is by|)
(<WRITE> |the spring.  There is a rusted old diving helmet on the ground|)
(<WRITE> |that is immovable.  Next to it is a skeleton and a note scrawled|)
(<WRITE> |on the wall.|)
(<WRITE> |Dear B___ie,|)
 (<WRITE> |   I ran out of air and had to come here.  The moss isn't|)
(<WRITE> |nutritious enough to survive on.  I hope you can use the diamonds.|)
(<WRITE> |Take care of _ec_l and he will take care up you.|)
(<WRITE> |              Diver Dan|)))

(system
((PLACE cave) & =A (INPUT ENTER (<any> spring water pool)) & =B -->
(<delete> =a) (<delete> =b) UNDERWATER (PLACE hot spring)))

(SYSTEM 
((PLACE cave) & =A (GOING D) & =B -->
(<DELETE> =A) (<DELETE> =B) UNDERWATER
(PLACE hot spring)))

(SYSTEM 
((PLACE ocean =S =E 2) 
 (IN =x ocean =S =E 1) --> (<WRITE> |Below you is an object.|)))

(SYSTEM 
((INPUT follow moose) & =A UNDERWATER (time is /00/:02) -->
(<DELETE> =A) (<WRITE> |The moose is too fast for you, you get tossed around in its wake.|) (INPUT w then n then u)))

(SYSTEM 
((INPUT get seaweed) & =A UNDERWATER --> (<DELETE> =A)
(<WRITE> |The seaweed is too strong, and you can't break off a piece.|)))

(SYSTEM 
((INPUT eat seaweed) & =A UNDERWATER -->
(<DELETE> =A) (<WRITE> |Chomp! Blaaachk! The seaweed is terrible.|)))

(SYSTEM 
((holds chest) (score =Y) & =A (<not> (scored chest)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored chest)))

(SYSTEM 
((holds diamonds) (score =Y) & =A (<not> (scored diamonds)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored diamonds)))

(SYSTEM 
((holds conch) (score =Y) & =A (<not> (scored conch)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored conch)))

(SYSTEM 
((holds bottle) (inside water bottle) (score =Y) & =A (<not> (scored youth)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored youth)))

(SYSTEM 
((holds pearls) (score =Y) & =A (<not> (scored pearls)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored pearls)))

(SYSTEM 
((holds coins) (score =Y) & =A (<not> (scored coins)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored coins)))

(SYSTEM 
((INPUT swim) & =A UNDERWATER -->
(<DELETE> =A) (<WRITE> |Just give me a direction and we will swim that way.|)))

(SYSTEM 
 ((MIDNIGHT) & =A UNDERWATER -->
 (<DELETE> =A)
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
 (<WRITE> |A moose comes swimming out of the darkness, at full speed straight at you.|)
 (<WRITE> |He has on full scuba gear, and is really moving.|)
 (<WRITE> |He is right on top of you.  He runs right through you and disappears.|)))

(SYSTEM 
(UNDERWATER (wears wetsuit) (INPUT take off ! =X) --> DROWN))

(SYSTEM 
((holds soap) & =A UNDERWATER --> (<DELETE> =A)
(<WRITE> |The soap dissolves in the water.  You are left with a gem.|)
(holds gem)))

(SYSTEM 
((PLACE ! =X) (in soap ! =X) & =A UNDERWATER -->
(<DELETE> =A) (in gem ! =X) (<WRITE> |The soap dissolves.|)))
