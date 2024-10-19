(SYSTEM 
 ((PLACE FOYER)
  (PLACE FOYER)
  (Time is =)
  (<NOT> (WASAT FOYER))
  --> (<WRITE> |You are inside the house in the inner foyer.|)
  (<WRITE> |There is a walk-in closet to the west, an entrance to a hall to the north.|)))

(SYSTEM 
 ((PLACE FOYER)
  (GOING S)
  & =A (LARGE-DOOR opened)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (LARGE-DOOR closed)
  (<WRITE> |Before you can get out the large door slams shut; BOOM!|)
  (<WRITE> |Laughter can be heard in the upper floors of the house.|)))

(SYSTEM 
 ((PLACE FOYER)
  (LARGE-DOOR closed)
  (INPUT OPEN ! =Z)
  & =A --> (<DELETE> =A)
  (<WRITE> |The large door is locked impossible to open.|)))

(SYSTEM 
 ((PLACE FOYER)
  & =A (GOING N)
  & =B --> (<DELETE> =A)
  (WASAT FOYER)
  (PLACE MAIN HALL)
  (<DELETE> =B)))

(SYSTEM 
 ((PLACE FOYER)
  (LARGE-DOOR closed)
  (GOING S)
  & =A --> (<DELETE> =A)
  (<WRITE> |The door is shut.|)))

(SYSTEM 
 ((PLACE FOYER)
  (INPUT ENTER CLOSET)
  & =A --> (<DELETE> =A)
  (GOING W)(WENT W)))

(SYSTEM 
 ((PLACE FOYER)
  (INPUT ENTER HALL)
  & =A --> (GOING N) (WENT N)
  (<DELETE> =A)))

(SYSTEM 
 ((PLACE FOYER)
  & =A (GOING W)
  & =B --> (WASAT FOYER)
  (<DELETE> =A)
  (PLACE CLOSET)
  (<DELETE> =B)))

(SYSTEM 
 ((PLACE FOYER)
  (LARGE-DOOR opened)
  & =B (INPUT CLOSE ! =X)
  & =A --> (<DELETE> =A)
  (<DELETE> =B)
  (LARGE-DOOR closed)
  (<WRITE> |The door closes.|)))


(SYSTEM 
 ((PLACE FOYER)
  (FOYER IS VIRGIN)
  & =X (time is =Y)  --> (<DELETE> =X) 
  (orc sweat (<time-incr> =Y 160))
  (<WRITE> |You feel a chill run down your spine, and you doubt your own sanity.|)
(<WRITE> | |)
  (<WRITE> |A booming voice proclaims:|)
  (<WRITE> |'YOU WON'T GET OUT BY A DOOR.'|)
  (<WRITE> |'... at least alive!'|)
  (<WRITE> | |)
  (<WRITE> |The house is very damp and musty.|)))

(system
((PLACE foyer) (time is =y)  (orced =z =q) & =A --> (<DELETE> =A)
(orc =Z  (<time-incr> =y 20)) (<WRITE> |A booming voice proclaims:|)
(<WRITE> |'You must be mad to return.  If you're not, you will be soon.'|)))

(system
((PLACE foyer) (time is =y) (orced =z =q) & =A EATIT & =b -->
(<DELETE> =A) (<DELETE> =B)))

(SYSTEM 
 ((PLACE FOYER)
  (SOUND IS ON)
  --> (<WRITE> |Some noise is coming from the hall.|)))

(SYSTEM 
 ((PLACE MAIN HALL)
  & =A (GOING S)
  & =B --> (<DELETE> =A)
  (WASAT MAIN HALL)
  (PLACE FOYER)
  (<DELETE> =B)))

(SYSTEM 
 ((PLACE MAIN HALL)
  (PLACE MAIN HALL)
  (<NOT> (WASAT MAIN HALL))
  --> (<WRITE> |You are in the main hall.|)
  (<WRITE> |The foyer is south.|)
  (<WRITE> |The hall extends west and darkens.|)
  (<WRITE> |A large room is to the east.|)))

(SYSTEM 
 ((PLACE MAIN HALL)
  & =A (GOING W)
  & =B --> (<DELETE> =A)
  (PLACE DARK HALL)
  (<DELETE> =B)))

(SYSTEM 
 ((PLACE MAIN HALL)
  & =A (GOING E)
  & =B --> (<DELETE> =A)
  (WASAT MAIN HALL)
  (PLACE LIBRARY)
  (<DELETE> =B)))

(SYSTEM 
 ((PLACE MAIN HALL)
  & =A (GOING U)
  & =B (STAIRS ARE WHOLE)
  --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT MAIN HALL)
  (PLACE STAIRS)
  (<DELETE> =B)))

(SYSTEM 
 ((PLACE MAIN HALL)
  & =A (GOING N)
  & =B (STAIRS ARE WHOLE)
  --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT MAIN HALL)
  (PLACE STAIRS)
  (<DELETE> =B)))

(SYSTEM 
 ((PLACE MAIN HALL)
  & =A (GOING N)
  & =B (STAIRS ARE COLLAPSED)
  --> (<DELETE> =A)
  (WASAT MAIN HALL)
  (PLACE STAIRS DEBRIS)
  (<DELETE> =B)))

(SYSTEM 
 ((PLACE MAIN HALL)
  (SOUND IS ON)
  --> (<WRITE> |Weird noises are coming from above.|)))

(SYSTEM 
 ((PLACE CLOSET)
  & =A (GOING E)
  & =B --> (<DELETE> =A)
  (WASAT CLOSET)
  (PLACE FOYER)
  (<DELETE> =B)))

(SYSTEM 
 ((PLACE CLOSET)
  (PLACE CLOSET)
  (<NOT> (WASAT CLOSET))
  -->
  (<WRITE> |You are in a large closet, you can see all its contents|)
  (<WRITE> | by the light from the foyer.|)))


(SYSTEM 
 ((PLACE DARK HALL)
  (<NOT> (WASAT DARK HALL))
  -->
  (<WRITE> |You are in a poorly lit hall. There is a faint scent of fresh paint.|)))

(SYSTEM 
 ((PLACE DARK HALL)
  & =A (GOING W)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT DARK HALL)
  (PLACE SMELLY ROOM)))

(SYSTEM 
 ((PLACE DARK HALL)
  & =A (GOING E)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT DARK HALL)
  (PLACE MAIN HALL)))

(SYSTEM 
 ((PLACE STAIRS)
  (<NOT> (WASAT STAIRS))
  -->
  (<WRITE> |You are on the landing of the stair case.|)
  (<WRITE> |Stairs go up and down.|)
  (<WRITE> | |)
  (<WRITE> |The stairs are squeeky! They seem about to collapse.|)))

(SYSTEM 
 ((PLACE STAIRS)
  & =C (GOING U)
  & =A --> (<DELETE> =A)
  (<DELETE> =C)
  (WASAT STAIRS)
  (PLACE UPPER HALL)))

(SYSTEM 
 ((PLACE STAIRS)
  & =A (GOING D)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT STAIRS)
  (PLACE MAIN HALL)))

(SYSTEM 
 ((PLACE STAIRS)
(WASAT STAIRS)
 --> 
  (<WRITE> |SQUEEK!  These stairs are delicate!|)))

(SYSTEM 
 ((PLACE STAIRS)
  (INPUT JUMP ! =X)
  & =A --> (<DELETE> =A)
  (BREAK STAIRS)))

(SYSTEM 
((PLACE stairs) & =a
(stairs are Whole) & =B
(break stairs) & =C
--> (<DELETE> =A) (<DELETE> =B) (<DELETE> =C)
(<WRITE> |CRASH! You've collapsed the stairs.|)
(Stairs are collapsed) (PLACE stairs debris)))

(SYSTEM 
 ((PLACE SMELLY ROOM)
  (PLACE SMELLY ROOM)
  (<NOT> (WASAT SMELLY ROOM))
  --> (<WRITE> |You are in a room that smells of paint.|)
  (<WRITE> |There are no windows or door except the one you came through.|)
  (<WRITE> |The walls are wood panel.|)))

(SYSTEM 
 ((PLACE SMELLY ROOM)
  & =A (GOING E)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT SMELLY ROOM)
  (PLACE DARK HALL)))

(SYSTEM 
 ((PLACE LIBRARY)
  (<NOT> (WASAT LIBRARY))
  -->
  (<WRITE> |You are in the library. All the walls are lined with books.|)
  (<WRITE> |There is a bust of Homer within reach.|)))

(SYSTEM 
 ((PLACE LIBRARY)
  & =A (GOING W)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT LIBRARY)
  (PLACE MAIN HALL)))

(SYSTEM 
 ((PLACE LIBRARY)
  (INPUT GET BUST)
  & =A --> (<DELETE> =A)
  (<WRITE> |The bust is too heavy to carry.|)))

(SYSTEM 
 ((PLACE LIBRARY)
  (INPUT TURN BUST)
  & =A --> (<DELETE> =A)
  OpenedStacks
  (STACKS WERE OPEN)))

(SYSTEM 
 ((PLACE LIBRARY)
  (INPUT ENTER ! =X)
  & =A OpenedStacks
  --> (<DELETE> =A)
  (GOING E)(WENT E)))

(SYSTEM 
 ((PLACE LIBRARY)
   OpenedStacks
  (wears WETSUIT)
  (GOING E)
  & =A --> (<DELETE> =A)
  (<WRITE> |You can't fit into the opening.|)))

(SYSTEM
 ((PLACE LIBRARY)
  OpenedStacks
  (holds wetsuit)
  (going e) & =A
  --> (<DELETE> =A)
  (<Write> |Something you're carrying is to big to fit through the door.|)))

(SYSTEM 
 ((PLACE LIBRARY) & =A OpenedStacks
  (GOING E) & =B --> 
  (<DELETE> =A)
  (<DELETE> =B)
  (WASAT LIBRARY)
  (PLACE SECRET STAIRS)))

(SYSTEM 
 ((PLACE LIBRARY)
  (INPUT TURN BUST)
  & =A OpenedStacks
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (<WRITE> |The shelves close.|)))

(SYSTEM 
 ((PLACE LIBRARY)
  OpenedStacks
  --> (<WRITE> |The east wall of books is open!|)))

(SYSTEM 
 ((PLACE LIBRARY)
  (INPUT =X BUST)
  & =A --> (<DELETE> =A)
  (<WRITE> (<SENTENCE> HOMER-ATN))))

(system
((PLACE library)
(INPUT rub bust) & =A --> (<DELETE> =A)
(<WRITE> |That isn't very rewarding, nothing happens.|)))

(system
((PLACE library)
(INPUT kiss bust) & =A --> (<DELETE> =A)
(<WRITE> |That might turn on a frog, but homer is unmoved.|)))

(SYSTEM 
 ((PLACE LIBRARY)
  (INPUT GET BOOK)
  & =X --> (<DELETE> =X)
  (<WRITE> |You get a book but discover it has only virtual pages.|)
  GOTBOOK
  (<WRITE> |The book disappears.|)))

(SYSTEM 
 ((PLACE LIBRARY)
  (INPUT GET BOOK)
  & =X GOTBOOK
  (<NOT> GOTBOOK2)
  --> (<WRITE> |The title of the book is 'Vampires I have known'|)
  (<DELETE> =X)
  GOTBOOK2
  (HOLDS BOOK)))

(SYSTEM 
 ((PLACE LIBRARY)
  (INPUT GET BOOK)
  (INPUT GET BOOK)
  & =A GOTBOOK
  GOTBOOK2
  --> (<DELETE> =A)
  (<WRITE> |All the rest of the books are fake.|)
  (<WRITE> |They seem to be wood.|)))

(SYSTEM 
 ((PLACE SECRET STAIRS)
  (<NOT> (WASAT SECRET STAIRS))
  --> (<WRITE> |You are in the head of a secret staircase.|)
  (<WRITE> |The stairs go down.  A pole in the room goes through a hole in the ceiling.|)))

(SYSTEM 
 ((PLACE SECRET STAIRS)
  & =B (GOING W)
  & =A OpenedStacks
  --> (<DELETE> =B)
  (WASAT SECRET STAIRS)
  (PLACE LIBRARY)
  (<DELETE> =A)))

(SYSTEM 
 ((PLACE SECRET STAIRS)
  & =B (GOING D)
  & =A --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT SECRET STAIRS)
  (PLACE WINE CELLAR)))

(SYSTEM 
 ((PLACE SECRET STAIRS)
  (<NOT> OpenedStacks)
  (INPUT OPEN ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |The stacks can't be opened from here.|)))

(SYSTEM 
 ((PLACE SECRET STAIRS)
  OpenedStacks
  --> (<WRITE> |The west wall is open.|)))

(SYSTEM 
 ((PLACE SECRET STAIRS)
  (GOING U)
  & =A --> (<DELETE> =A)
  (<WRITE> |That isn't a bat pole, ROBIN. You can only come down.|)))

(SYSTEM 
 ((PLACE STAIRS DEBRIS)
  (<NOT> (WASAT STAIRS DEBRIS))
  --> (<WRITE> |You are on wreckage of the stairs.|)
  (<WRITE> |To the south is the main hall, north is a small opening.|)))

(SYSTEM 
 ((PLACE STAIRS DEBRIS)
  & =A (GOING S)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT STAIRS DEBRIS)
  (PLACE MAIN HALL)))

(SYSTEM 
 ((PLACE STAIRS DEBRIS)
  & =A (GOING N)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT STAIRS DEBRIS)
  (PLACE BACK HALL)))

(SYSTEM 
 ((PLACE BACK HALL)
  (PLACE BACK HALL)
  (<NOT> (WASAT BACK HALL))
  -->
  (<WRITE> |This is the back hall. It connects the kitchen and|)
  (<WRITE> |dining room. The kitchen is east and the dining room is west.|)))

(system
((PLACE back hall) (stairs are collapsed) -->
(<WRITE> |To the south is the wreckage of the stairs.|)))

(SYSTEM 
 ((PLACE BACK HALL)
  & =A (going E)
  & =B --> (WASAT BACK HALL)
  (<DELETE> =A)
  (<DELETE> =B)
  (PLACE KITCHEN)))

(SYSTEM 
 ((PLACE BACK HALL)
  & =A (GOING W)
  & =B --> (WASAT BACK HALL)
  (<DELETE> =A)
  (<DELETE> =B)
  (PLACE DINING ROOM)))

(SYSTEM 
 ((PLACE BACK HALL)
  & =A (STAIRS ARE COLLAPSED) (GOING S)
  & =B --> (WASAT BACK HALL)
  (<DELETE> =A)
  (<DELETE> =B)
  (PLACE STAIRS DEBRIS)))

(SYSTEM 
 ((PLACE KITCHEN)
  (PLACE KITCHEN)
  (<NOT> (WASAT KITCHEN))
  --> (<WRITE> |You are in a old kitchen. All the windows are|)
  (<WRITE> |boarded up. The only exit is west.|)
  (<WRITE> | |)
  (<WRITE> |There is a refrigerator in the corner.|)
  (<WRITE> |A ventilation duct is open over the refrigerator.|)))

(SYSTEM 
 ((PLACE KITCHEN)
  & =A (GOING W)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT KITCHEN)
  (PLACE BACK HALL)))

(SYSTEM 
 ((PLACE KITCHEN)
  (INPUT EXIT)
  & =A --> (<DELETE> =A)
  (GOING W) (WENT W)))

(SYSTEM 
 ((PLACE KITCHEN)
  (RDOOR closed)
  --> (<WRITE> |The refrigirator door is closed.|)))

(SYSTEM 
 ((PLACE KITCHEN)
  (RDOOR opened)
  --> (<WRITE> |The door of the ice box is open.|)))

(SYSTEM 
 ((PLACE KITCHEN)
  (RDOOR closed)
  & =A (INPUT OPEN ! =X)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (RDOOR opened)))

(SYSTEM 
((PLACE kitchen)
  (rdoor opened) & =A (INPUT close ! =X) & =B
--> (<DELETE> =A) (<DELETE> =B) (rdoor closed)))


(SYSTEM 
 ((PLACE KITCHEN)
  (RDOOR opened)
  (cube frig)
  --> (<WRITE> |There is a small white cube in the refrigirator.|)))

(SYSTEM 
 ((PLACE KITCHEN)
  (RDOOR opened)
  (cube frig)
  & =A (INPUT GET CUBE)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (<WRITE> |You have a cube.|)
  (HOLDS CUBE)))

(SYSTEM 
((PLACE kitchen) (going u) & =A --> (<DELETE> =A) (ontop FRIG)))

(SYSTEM 
((PLACE kitchen) (ontop FRIG) --> (<WRITE> |You are ontop the refrigirator.|)
(<WRITE> |Going down will put you on the floor, going south will put you in the duct.|)))

(SYSTEM 
((PLACE kitchen) (INPUT mount) & =A --> (<DELETE> =A) (ontop FRIG)))

(SYSTEM 
((PLACE kitchen) & =A (ontop FRIG) & =C 
(GOING S) (GOING s) & =B --> (<DELETE> =A) (<DELETE> =B)
(<DELETE> =C) (wasat kitchen) (PLACE ductf2)))

(SYSTEM 
 ((PLACE DINING ROOM)
  (PLACE DINING ROOM)
  (<NOT> (WASAT DINING ROOM))
  -->
  (<WRITE> |You are in a large dining room. The ceiling is very high.|)
  (<WRITE> |The hall is east.|)))

(SYSTEM 
 ((PLACE DINING ROOM)
  & =A (GOING E)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT DINING ROOM)
  (PLACE BACK HALL)))

(SYSTEM 
 ((PLACE UPPER HALL) (PLACE UPPer HALL)
  (<NOT> (WASAT UPPER HALL))
  --> (<WRITE> |You are at the upper hall. You can see down the|)
  (<WRITE> |first steps of some stairs. A circular staircase|)
  (<WRITE> |continues up.|)
  (<WRITE> | |) 
  (<WRITE> |There is a dark room to the south,|)
  (<WRITE> |a hall to the west, a stone wall to the east,|)
  (<WRITE> |and another room to the north.|)))

(SYSTEM 
 ((PLACE UPPER HALL)
  (STAIRS ARE COLLAPSED)
  (GOING D)
  & =A --> (<DELETE> =A)
  (<WRITE> |The stairs are collapsed.|)))

(SYSTEM 
 ((PLACE UPPER HALL)
  & =A (STAIRS ARE WHOLE)
  (GOING D)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT UPPER HALL)
  (PLACE STAIRS)))

(SYSTEM 
 ((PLACE UPPER HALL)
  & =A (GOING S)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT UPPER HALL)
  (PLACE DARK ROOM)))

(SYSTEM 
 ((PLACE UPPER HALL)
  & =A (GOING W)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT UPPER HALL)
  (PLACE LONG HALL)))

(SYSTEM 
 ((PLACE UPPER HALL)
  & =A (GOING N)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT UPPER HALL)
  (PLACE dull room)))

(SYSTEM 
 ((PLACE UPPER HALL)
  & =A (GOING E)
  & =B (SECRET PANEL OPEN)
  --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT UPPER HALL)
  (PLACE SECRET ROOM)))

(SYSTEM 
 ((PLACE UPPER HALL)
  SECRET-PANEL-CLOSED & =B
  (INPUT (<any> move pull GET) BRICK)
  & =A --> (<DELETE> =A)
  (<DELETE> =B)
  (<WRITE> |The brick moves, but can't be removed from the wall.|)
  (<WRITE> |A secret panel in the wall opens!|)
  (<WRITE> |There is a room ahead.|)
  (SECRET PANEL OPEN)))

(SYSTEM 
 ((PLACE UPPER HALL)
  (INPUT CLOSE WALL)
  & =A (SECRET PANEL OPEN)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (<WRITE> |The wall closes.|)))

(SYSTEM 
 ((PLACE UPPER HALL)
  & =A (GOING U)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT UPPER HALL)
  (PLACE LABORATORY)))

(SYSTEM 
 ((PLACE UPPER HALL)
  (SOUND IS ON)
  -->
  (<WRITE> |You hear clanking and screams coming from the hall.|)))

(SYSTEM 
 ((PLACE LABORATORY)
  (PLACE LABORATORY)
  (<NOT> (WASAT LABORATORY))
  -->
  (<WRITE> |You are in the Laboratory.  The most notable feature is a huge |)
  (<WRITE> |slab in the middle of the room.  There is a large |)
  (<WRITE> |lever switch.  The stairs are the only obvious exit. The ceiling|)
  (<WRITE> |is a glass dome painted black, much too high to reach.|)))

(SYSTEM 
 ((PLACE LABORATORY)
  & =A (GOING D)
  & =B --> (WASAT LABORATORY)
  (<DELETE> =A)
  (<DELETE> =B)
  (PLACE UPPER HALL)))

(SYSTEM 
 ((PLACE LABORATORY)
  & =A (GOING W)
  & =B (WALL IS DOWN)
  --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT LABORATORY)
  (PLACE BAR)))

(SYSTEM 
 ((PLACE LABORATORY)
  (WALL IS DOWN)
  -->
  (<WRITE> |The west wall has the shape of a running figure in it.|)))

(SYSTEM 
 ((PLACE LABORATORY)
  (INPUT =B LEVER)
  & =A --> (<DELETE> =A)
  (MONSTER LIVE)))

(SYSTEM 
 ((PLACE LABORATORY)
  (INPUT =B SWITCH)
  & =A --> (<DELETE> =A)
  (INPUT =X lever)))

(SYSTEM 
((PLACE laboratory)
(INPUT =x lever) & =A (lever thrown) --> (<DELETE> =A)
(<WRITE> |The lever is stuck.|)))

(SYSTEM 
 ((PLACE LABORATORY)
  (MONSTER LIVE)
  & =A (IN MONSTER LABORATORY)
  (<NOT> (LEVER THROWN))

  --> (<DELETE> =A)
  (<WRITE> |The lights dim.  A massive door on the east wall|)
  (<WRITE> |opens revealing a bank of computers, generators, and misc.|)
  (<WRITE> |electronic gear.  The generators start to scream.|)
  (<WRITE> |The lights dim more.  Suddenly sparks start to fly from the|)
  (<WRITE> |equipment.   The body on the table starts to jerk around.|)
  (<WRITE> | |)
  (<WRITE> |As suddenly as it started, the generators turn off, the|)
  (<WRITE> |wall closes.  And everything returns to normal.....|)
  (<WRITE> |Then the body rises, removes its sheet and it is a monster.|)
  (<WRITE> | |)
  (<WRITE> |The monster approaches you and says 'Trick or Treat'|)  (LEVER THROWN)))

(SYSTEM 
 ((PLACE LABORATORY)
  (IN MONSTER LABORATORY)
  (<NOT> (LEVER THROWN))
  -->
  (<WRITE> |There is the shape of a body on the slab, covered with a sheet.|)))

(SYSTEM 
 ((PLACE LABORATORY)
  (IN MONSTER LABORATORY)
  & =B (HOLDS CANDY)
  & =C (LEVER THROWN)
  (INPUT GIVE CANDY ! =X)
  & =A --> (<DELETE> =C)
  (<DELETE> =A)
  (<DELETE> =B)
  (<WRITE> |The monster is pleased.|
	   |He eats the candy, walks through the west wall|)
  (<WRITE> |and disappears.|)
  (WALL IS DOWN)))

(SYSTEM 
 ((PLACE LABORATORY)
  (IN MONSTER LABORATORY)
  & =A (LEVER THROWN)
  (INPUT =X MONSTER)
  & =Z --> (<DELETE> =A)
  (<DELETE> =Z)
  (<WRITE> |The monster is frightened and holds his breath until he turns|)
  (<WRITE> |blue.  He then disappears.|)))

(SYSTEM 
 ((PLACE LABORATORY)
  (LEVER THROWN)
  -->
  (<WRITE> |The lever has been thrown, and is stuck in that position.|)))

(SYSTEM 
 ((PLACE LABORATORY)
  (HOLDS FOOTBALL)
  & =A (INPUT KICK FOOTBALL ! =p)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (<WRITE> |The football goes crashing through the glass dome.|)
  (IN FOOTBALL LAWN ISIDE 7 4)
  (DOME IS BROKEN)))

(SYSTEM 
 ((PLACE LABORATORY)
  (HOLDS FOOTBALL) & =A
  (ROPE TIED FOOTBALL) & =C
  (INPUT KICK FOOTBALL ! =p) & =B --> 
  (<DELETE> =A)
  (<DELETE> =B)
  (<DELETE> =C)
  (<WRITE> |Kicking the football tears the rope off of it.|)
  (<WRITE> |The football goes crashing through the glass dome.|)
  (ROPE UNTIED)
  (IN FOOTBALL LAWN ISIDE 7 4)
  (DOME IS BROKEN)))

(SYSTEM 
 ((PLACE LABORATORY)
  (IN DRACULA LABORATORY)
  & =A (DOME IS BROKEN)
  --> (<DELETE> =A)
  (<WRITE> |The bat flies through the hole in the dome and escapes.|)))

(SYSTEM 
 ((PLACE LABORATORY)
  (IN DRACULA LABORATORY)
  -->
  (<WRITE> |There is a bat flying around in the dome, too high to reach.|)))

(System 
((PLACE LABORATORY) (IN DRACULA LABORATORY) (INPUT GET DRACULA) & =A -->
 (<DELETE> =A)
 (<WRITE> |I said the bat was too high to reach, even on a stool.|)))

(SYSTEM
((PLACE LABORATORY) (IN DRACULA LABORATORY)
(INPUT GET BAT) & =A --> (<DELETE> =A)
(<WRITE> |The bat is much too high for you to get.|)))

(SYSTEM 
 ((PLACE LABORATORY)
  (IN DRACULA LABORATORY)
  & =A (DOME IS BROKEN)
  (MORNING IS HERE)
  --> (<DELETE> =A)
  (IN RING LABORATORY)
  (<WRITE> |The sun's rays cause the bat to shrivel.  Something falls to the floor.|)))

(system
((in dracula laboratory) & =A
(dome is broken)
(morning is here) --> (<DELETE> =A)
(in ring laboratory)))

(SYSTEM 
 ((PLACE LABORATORY)
  (IN MONSTER LABORATORY)
  (LEVER THROWN)
  (WASAT LABORATORY)
  -->
  (<WRITE> |The monster is drooling on himself, saying 'Trick or Treat'|)))

(SYSTEM 
 ((PLACE LABORATORY)
  (IN MONSTER LABORATORY)
  (LEVER THROWN)
  (INPUT GIVE ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |The monster doesn't like | (<CAPTOSM> ! =X) |. |)
  (<WRITE> |He is getting very angry.|)))

(SYSTEM 
((PLACE LABORATORY)
(IN MONSTER LABORATORY)
(LEVER THROWN)
(INPUT GIVE MONSTER ! =X) & =A --> (<DELETE> =A) (INPUT GIVE ! =X)))

(SYSTEM
((PLACE LABORATORY)
(IN MONSTER LABORATORY)
(LEVER THROWN)
(INPUT GIVE =X TO MONSTER) & =A --> (<DELETE> =A)
(INPUT GIVE =X)))

(SYSTEM 
 ((PLACE LABORATORY)
  (IN MONSTER LABORATORY)
  (LEVER THROWN)
  (INPUT THROW ! =X)
  & =A --> (<DELETE> =A)
  (INPUT GIVE ! =X)))

(SYSTEM 
 ((PLACE LABORATORY)
  (DOME IS BROKEN)
  (MORNING IS HERE)
  --> (<WRITE> |Light shows throught the hole.|)))

(system 
((PLACE laboratory) (in matches laboratory) (morning is here) -->
(<WRITE> |Even in the sun light the matches don't dry.|)
(<WRITE> |Even the laboratory is damp and musty.|)))

(system
((PLACE laboratory) (INPUT dry matches) & =A --> 
(<DELETE> =A) (<WRITE> |The laboratory is very damp.|)))

(SYSTEM 
 ((PLACE LABORATORY)
  (DOME IS BROKEN)
  (<NOT> (MORNING IS HERE))
  --> (<WRITE> |You can see the moon through the dome.|)))

(SYSTEM 
 ((PLACE LABORATORY)
  (IN MONSTER LABORATORY)
  & =A (HOLDS CUBE)
  & =B (LEVER THROWN)
  (INPUT GIVE CUBE)
  & =C --> (<DELETE> =A)
  (<DELETE> =B)
  (<DELETE> =C)
  (<WRITE> |The monster eats the cube.  He then starts saying 'ohhh, ahhhh'.|)
  (<WRITE> |'Out of sight man.'  Then he jumps straight up through the dome.|)
  (DOME IS BROKEN)))

(SYSTEM 
 ((PLACE BAR)
  (PLACE BAR)
  (<NOT> (WASAT BAR))
  -->
  (<WRITE> |You are in a bar. There isn't any booze.|)))

(SYSTEM 
 ((PLACE BAR)
  & =A (GOING E)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT BAR)
  (PLACE LABORATORY)))

(SYSTEM 
 ((PLACE WINE RACKS ! =X)
  -->
  (<WRITE> |You are in rows of wine racks that stretch out of sight in all directions.|)))

(SYSTEM 
((PLACE wine racks (e ! =e) (n ! =n)) & =A 
(going e) & =B -->
(<DELETE> =A) (<DELETE> =B) (PLACE wine racks (e e ! =e) (n ! =n))))

(SYSTEM 
((PLACE wine racks (e ! =E) (n ! =N)) & =A (going n) & =B -->
 (<DELETE> =A) (<DELETE> =B) (PLACE wine racks (e ! =E) (N N ! =N))))

(SYSTEM 
((PLACE wine racks (e e ! =e) =n) & =A (going w) & =B -->
 (<DELETE> =A) (<DELETE> =B) (PLACE wine racks (e ! =E) =N)) )

(SYSTEM 
((PLACE wine racks =E (N N ! =N)) & =A (going s) & =b -->
 (<DELETE> =A) (<DELETE> =B) (PLACE wine racks =E (N ! =N))))

(SYSTEM 
((PLACE wine racks (e) (n)) (<not> (wasat winec)) -->
(wasat winec) (<Write> |You've lost track of where you came from.|)))

(SYSTEM 
((PLACE wine racks (e) (n)) (wast winec) -->
(<Write> |Retracing your steps doesn't help in here.|)))

(SYSTEM 
((PLACE wine racks (e e e e) (n n n n)) -->
 (<WRITE> |There is a trap door on the floor, stuck open.|)
 (<Write> |Written on it is 'Only way out, Cantor'|)))

(SYSTEM 
((PLACE wine racks (e e e e) (n n n n)) & =A (going d) & =b -->
 (<DELETE> =A) (<DELETE> =B) (Place cheese room)))

(SYSTEM 
 ((PLACE WINE RACKS ! =X)
  (INPUT GET WINE)
  & =A --> (<DELETE> =A)
  (<WRITE> |Have't you noticed? There isn't any wine in the racks.|)))

(SYSTEM 
((PLACE wine racks ! =x) (Input DOVETAIL) & =A --> (<DELETE> =A) 
(<WRITE> |Good idea, go with that thought!|)))

(SYSTEM 
((PLACE wine racks =E  (n n n n n n n n n n n)) (<not> NORTHPOLE) --> 
NORTHPOLE
(<WRITE> |Heh, where are you going, the north pole?|)))

(SYSTEM 
((PLACE wine racks =E (n n n n n n n n n n n n)) (<not> FOREVER) -->
FOREVER
(<WRITE> |You know, it is possible this thing goes on forever.|)))

(SYSTEM 
((PLACE wine racks  (e e e e e e e e e e e e e) =n) -->
(<WRITE> |Look, the wine racks are infinitely long, think up a smart way to search!|)))

(SYSTEM 
((PLACE wine racks (e e) (n n))  --> (<WRITE> |Scrawled on a rack is 'Cantor was here'.|)))

(SYSTEM 
((PLACE wine racks =N =E) (INPUT climb ! =X) & =A -->
(<DELETE> =A) (<Write> |You can't climb the wine racks.|)))

(SYSTEM 
((INPUT push ! =X) & =A (PLACE wine racks ! =Y) -->
(<DELETE> =A) (<WRITE> |The wine racks don't move.|)))

(SYSTEM 
 ((PLACE CHEESE ROOM)
  (PLACE CHEESE ROOM)
  (<NOT> (WASAT CHEESE ROOM))
  -->
  (<WRITE> |This is the cheese room.  The only opening is a trap door|)
  (<WRITE> |above, too high to reach.   The walls are made of cheese.|)))

(SYSTEM 
 ((PLACE CHEESE ROOM)
  & =A (WALLS ARE EATEN)
  (GOING W)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT CHEESE ROOM)
  (PLACE TORTURE CHAMBER)))

(SYSTEM 
 ((PLACE CHEESE ROOM)
  (WALLS ARE EATEN)
  -->
  (<WRITE> |There is a hole in the west wall, with teeth marks around the edges.|)))

(SYSTEM 
 ((PLACE CHEESE ROOM)
  (<NOT> (WALLS ARE EATEN))
  (INPUT EAT WALL ! =o)
  & =A --> (<DELETE> =A)
  (<WRITE> |I really prefer my cheese in smaller pieces,|)
(<WRITE> |but we can give it a try. CHOMP CHOMP..|)
  (WALLS ARE EATEN)))

(SYSTEM 
 ((PLACE CHEESE ROOM)
  (<NOT> (WALLS ARE EATEN))
  (INPUT EAT WEST WALL ! =o)
  & =A --> (<DELETE> =A)
  (<WRITE> |It would be nice to have some wine,|)
(<WRITE> |but sometimes you have to rough it.  CHOMP! CHOMP!|)
  (WALLS ARE EATEN)))

(SYSTEM 
 ((PLACE CHEESE ROOM)
  (<NOT> (WALLS ARE EATEN))
  (INPUT EAT WALLS ! =o)
  & =A --> (<DELETE> =A)
  (<WRITE> |I really liked the west one.|)
  (WALLS ARE EATEN)))

(SYSTEM 
 ((PLACE CHEESE ROOM)
  (IN GHOST CHEESE ROOM)
  (INPUT ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> (<SENTENCE> GHOST-ATN) (<CAPTOSM> ! =X))))

(SYSTEM 
 ((PLACE CHEESE ROOM)
  (IN GHOST CHEESE ROOM)
  (INPUT (<ANY> QUIT STOP))
  & =A --> (<DELETE> =A)
  (<WRITE> |You shouldn't give up so easily.|)
  (<WRITE> |I think the ghost was really scared of you.|) HALT))

(SYSTEM 
 ((PLACE CHEESE ROOM)
  (IN GHOST CHEESE ROOM)
  --> (<WRITE> |There is a ghost in the room.|)
  (<WRITE> |Its nose is pink, I believe it has been drinking too much.|)))

(SYSTEM 
 ((PLACE CHEESE ROOM)
  (IN GHOST CHEESE ROOM)
  & =A (INPUT BOO ! =X)
  & =Y --> (<DELETE> =A)
  (<DELETE> =Y)
  (<WRITE> |The ghost is scared to death and disappears.|)))

(SYSTEM 
((PLACE CHEESE ROOM) (IN GHOST CHEESE ROOM)
(INPUT say boo ! =x) & =A --> (<DELETE> =A) (Input boo) (<WRITE> |BOO!|)))

(SYSTEM 
 ((PLACE CHEESE ROOM)
  (IN GHOST CHEESE ROOM)
  (INPUT =X GHOST ! =Y)
  & =A --> (<DELETE> =A)
  (<WRITE> (<SENTENCE> GHOST-ATN) (<CAPTOSM> =X) |it.|)))

(SYSTEM 
 ((PLACE CHEESE ROOM)
  (IN GHOST CHEESE ROOM)
  (INPUT SCARE GHOST)
  & =Y --> (<DELETE> =Y)
  (<WRITE> |What do you say to scare a Ghost?|)))

(SYSTEM 
 ((PLACE TORTURE CHAMBER)
  (PLACE TORTURE CHAMBER)
  --> (<WRITE> |You are in the torture chamber.|)
  (<WRITE> |A steel door slammed shut when you entered.|)
  (<WRITE> |There are no other doors or windows.|)))

(SYSTEM 
 ((PLACE TORTURE CHAMBER)
 DAMSEL-TIED-UP
 (likes ! =X)
  --> (<WRITE> |There is a good looking| (<captosm> ! =X) |entrapped.|)))

(system
((PLACE TORTURE CHAMBER)
 DAMSEL-FREE
 (LIKES ! =X)
--> (<WRITE> |There is a sexy looking| (<captosm> ! =x) |in here with you.|)))

(SYSTEM 
 ((PLACE TORTURE CHAMBER)
  (LIKES ! =Y)
  DAMSEL-TIED-UP & =A
  (INPUT (<ANY> RESCUE UNTIE SAVE FREE RELEASE) ! =P) & =C -->
  (<DELETE> =A)
  (<DELETE> =C)
  DAMSEL-FREE
  (IN ROPE TORTURE CHAMBER)
  (<WRITE> |The| (<captosm> ! =Y) |is free, and gives you a kiss.|)))

(SYSTEM 
((PLACE TORTURE CHAMBER)
 (INPUT RELEASE ! =Y) & =A -->
 (<DELETE> =A)
 (<WRITE> |I don't see an entrapped| (<Captosm> ! =Y) |around here.|)))

(SYSTEM 
 ((PLACE TORTURE CHAMBER)
  (LIKES ! =X)
  DAMSEL-TIED-UP & =A
  (INPUT FUCK ! =O) & =B -->
  (<DELETE> =A)
  (<DELETE> =B)
  (<WRITE> YOU BRUTE! |That was a big mistake.|)
  (<WRITE> |The| (<captosm> ! =X) |is not as defenseless as you think,|)
  (<WRITE> |and suddenly you're missing your genitalia, and your life.|)
  DIE))

(SYSTEM 
 ((PLACE TORTURE CHAMBER)
  (LIKES ! =Y)
  DAMSEL-FREE
  (INPUT GET ! =Y)
  & =A --> (<DELETE> =A)
  (<WRITE> |You can't get the| (<captosm> ! =Y) | But you get a wink when you try.|)))

(SYSTEM
  ((PLACE TORTURE CHAMBER)
   (LIKES ! =Y)
   DAMSEL-TIED-UP
   (INPUT GET ! =Y) & =A -->
   (<DELETE> =A)
   (<WRITE> |The| (<captosm> ! =Y) |is all tied up right now.|)))

(SYSTEM 
((PLACE torture chamber)
 (LIKES ! =X)
 DAMSEL-FREE
 (INPUT give cube ! =Z) & =A
 (HOLDS CUBE) & =b
--> (<DELETE> =A) (<DELETE> =B) 
(<WRITE> |The| (<captosm> ! =X) |has a great trip.|)
(<WRITE> |You wish you had eaten the cube.|) 
(<WRITE> |The| (<captosm> ! =X) |starts taking off your clothes.|)))


(SYSTEM 
 ((PLACE TORTURE CHAMBER)
  (INPUT FUCK ! =z) & =B
  (TIME IS =TIME)
  DAMSEL-FREE & =A
  (LIKES ! =X) -->
  (<DELETE> =A)
  (<DELETE> =B)
  (<WRITE> |The| (<captosm> ! =X) |likes you. You make love, talk a little,|)
  (<WRITE> |smoke a cigarette, take a nap, make love, talk,|)
  (<WRITE> |make love, take a nap, make love, etc.|)
  (<WRITE> | |)
  (<WRITE> |You get a gift and then you make love, talk, etc.|)
  (<WRITE> | |)
  (<WRITE> |Finally the| (<captosm> ! =X) |tells you good bye and turns to smoke and|)
  (<WRITE> |disappears through the cold air return duct, overhead.|)
  (IN MATCHES TORTURE CHAMBER)
  (CANCERTIME IS (<TIME-INCR> =TIME 480))
  (HOLDS FOOTBALL)))


(SYSTEM 
 ((PLACE TORTURE CHAMBER)
  (INPUT FOLLOW ! =X)
  & =A --> (<DELETE> =A)
  (GOING U) (WENT U)))

(SYSTEM 
 ((PLACE TORTURE CHAMBER)
  (WEARS WETSUIT)
  (LIKES ! =X) 
  (TIME IS =TIME)
  DAMSEL-FREE
  (INPUT FUCK ! =Y) & =A --> (<DELETE> =A)
  (<WRITE> |The| (<captosm> ! =X) |laughs at your approaches.|)
  (<WRITE> |You are confused until you realize you still have on your|)
  (<WRITE> |wetsuit. HINT: TAKE IT OFF!!!|)))

(SYSTEM 
 ((PLACE TORTURE CHAMBER)
  DAMSEL-FREE
  (INPUT KISS ! =X) & =A (<not> (scored damsel)) -->
  (<DELETE> =A) 
  (scored damsel)
  (<WRITE> |You score!  Go for it!|)))

(SYSTEM 
 ((PLACE TORTURE CHAMBER)
  DAMSEL-TIED-UP
  (INPUT KISS ! =X) & =A -->
  (<DELETE> =A)
  (<WRITE> |Your friend isn't very interested.|)))

(SYSTEM 
((SCORED DAMSEL)
 (INPUT kiss ! =X) & =A 
 DAMSEL-FREE --> (<DELETE> =a)
 (<WRITE> |You scored once trying this, but it looks like |)
 (<WRITE> |some more intimate action (MIA) would be effective.|)))

(SYSTEM
((PLACE TORTURE CHAMBER)
 DAMSEL-FREE
 (INPUT MIA) & =A -->
 (<DELETE> =A) (<WRITE> |Could you be a little more explicit?|)))

(SYSTEM
((PLACE TORTURE CHAMBER)
DAMSEL-FREE
(INPUT GIVE (<any> MASSAGE BACKRUB HEAD)) & =A
--> (<DELETE> =A) 
(<WRITE> |'Ummmmm, I like that very much'|)
(<WRITE> |'Why don't we try something you'll like too.'|)))

(SYSTEM
((PLACE TORTURE CHAMBER)
DAMSEL-TIED-UP
(INPUT GIVE (<any> MASSAGE BACKRUB HEAD)) & =A
--> (<DELETE> =A) 
(<WRITE> |I think your friend would like to be untied first.|)))

(SYSTEM 
 ((PLACE TORTURE CHAMBER)
  (INPUT TORTURE ! =X) & =A -->
  (<DELETE> =a)
  (<WRITE> |You're a nasty one.  I won't put up with any S & M, bye!|)
  HALT))
(SYSTEM 
 ((PLACE DARK ROOM)
  (Place dark room)
  (<NOT> (WASAT DARK ROOM))
  -->
  (<WRITE> |You have entered a room without lights. From the hall|)
  (<WRITE> |light you can see that there are no windows.|)
  (<WRITE> | |)
  (<WRITE> |In the middle of the room is a large casket.|)
  (<WRITE> |The only exit is north, to the hall.|)))

(SYSTEM 
 ((PLACE DARK ROOM)
  & =A (GOING N)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT DARK ROOM)
  (PLACE UPPER HALL)))

(SYSTEM 
 ((PLACE DARK ROOM)
  (CASKET closed)
  --> (<WRITE> |The casket is closed.|)))

(SYSTEM 
 ((PLACE DARK ROOM)
  (CASKET opened)
  --> (<WRITE> |The casket is open.|)))

(SYSTEM 
 ((PLACE DARK ROOM)
  (CASKET closed)
  & =A (INPUT OPEN ! =U)
  & =B (DRACULA IS ASLEEP)
  & =C --> (<DELETE> =A)
  (<DELETE> =B)
  (<DELETE> =C)
  (CASKET opened)
  (<WRITE> |When you open the casket you notice that a well dressed man|)
  (<WRITE> |with pale skin is inside.  He appears dead. |)
  (<WRITE> | |)
  (<WRITE> |There is a huge diamond ring on his left hand.|)
  (<WRITE> | |)
  (<WRITE> |Suddenly his eyes blink open, you notice the irises are red.|)
  (<WRITE> |It is Dracula.  Oops.|)
  (DRACULA IS AWAKE)))

(SYSTEM 
((PLACE DARK ROOM) (DRACULA IS AWAKE) (IN DRACULA DARK ROOM) -->
(<WRITE> | |)
(<WRITE> |Dracula has left his casket and is approaching you.|)))

(SYSTEM 
((PLACE DARK ROOM)
 CUT 
 (CASKET opened) & =A
 (DRACULA IS AWAKE) (in Dracula dark room) 
--> (<DELETE> =a)
(INPUT scare dracula)
(CASKET closed) 
 (<WRITE> |Dracula sees the cut on your hand and Snarls!|)
 (<WRITE> |You continue to stare into his eyes, and you can't move!|)
 (<WRITE> |Closer and closer he comes.|)))

(SYSTEM 
 ((PLACE DARK ROOM)
  (CASKET closed)
  & =A (INPUT OPEN CASKET)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (CASKET opened)))

(SYSTEM 
 ((PLACE DARK ROOM)
  (CASKET opened)
  & =A (INPUT CLOSE CASKET)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (CASKET closed)))

(SYSTEM 
((PLACE DARK ROOM)
(IN DRACULA DARK ROOM)
  (DRACULA IS AWAKE)
  (INPUT KILL DRACULA ! =X)
  (INPUT KILL DRACULA ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |Look turkey breath, this guy isn't the jolly green giant.|)
  (<WRITE> |You'll never kill him in this room.|)))

(SYSTEM 
((PLACE dark room) (in dracula dark room) (dracula is awake)
(INPUT give cube) & =A --> (<DELETE> =A)
(<WRITE> |Dracula doesn't have a sweet tooth, although he does have a blood tooth!|)))

(SYSTEM 
 ((PLACE DARK ROOM) 
  (IN DRACULA DARK ROOM)
  (CASKET =D) & =C
  (DRACULA IS AWAKE) & =B
  (INPUT =X DRACULA) & =A
  -->
(<DELETE> =A)
  (<DELETE> =B)
  (<DELETE> =C)
  (Casket closed)
  (<WRITE> |Dracula grabs you around the neck, sinks his teeth in, and ...|)
  DIE 
  (dracula is asleep)))

(SYSTEM 
 ((PLACE DARK ROOM) 
  (IN DRACULA DARK ROOM)
  (DRACULA IS AWAKE)
  (INPUT =X DRACULA) & =A
  (wears ! =Z) & =B
  -->
(<DELETE> =A) (<DELETE> =B)
  (<WRITE> |Dracula attacks you!|)
  (<WRITE> |He overpowers you and rips off your suit.|)
  (<WRITE> |You feel his teeth sink in and you hear him mutter, |)
  (<WRITE> |'You just can't find vir...'|)
  DIE))

(SYSTEM 
 ((PLACE DARK ROOM) & =X
  (DRACULA IS AWAKE) & =W
  (IN DRACULA DARK ROOM)
  (CASKET opened) & =Y
  (GOING N) & =Z -->
  (<DELETE> =W)
  (<DELETE> =X)
  (<DELETE> =Y)
  (<DELETE> =Z)
  (WASAT DARK ROOM)
  (PLACE UPPER HALL)
  (<WRITE> |Dracula stays in the dark room.|)
  (DRACULA IS ASLEEP)
  (CASKET closed)))

(SYSTEM 
 ((CANDLESTICKS ARE CROSSED)
  (IN DRACULA DARK ROOM)
  & =A (DRACULA IS AWAKE)
  (PLACE DARK ROOM)
  --> (<DELETE> =A)
  (IN DRACULA LABORATORY)
  (<WRITE> |Dracula sees the cross and becomes frightened.  He turns into|)
  (<WRITE> |a bat and flys toward the highest point he can find.|)))

(SYSTEM
((PLACE LABORATORY)
 (IN DRACULA LABORATORY)
 (<NOT> (CANDLESTICKS ARE CROSSED)) -->
 (<WRITE> |The bat flies down and lands in front of you.|)
 (<WRITE> | |)
 (<WRITE> |Poof!|)
 (<WRITE> | |)
 (<WRITE> |Dracula now stands in front of you and snarls.|)
 (<WRITE> |He takes a step forward and grabs your neck.|)
 (<WRITE> |You have no will of your own and you relax as you feel|)
 (<WRITE> |his fangs sink into your jugular.|)
 DIE))

(SYSTEM 
((PLACE dark room) (INPUT give blood) & =a -->
(<DELETE> =A) (<WRITE> |I'm sure dracula will be glad to accept the donation.|)
(INPUT tickle dracula)))

(SYSTEM 
((PLACE dark room) (INPUT get ring) & =A --> (<DELETE> =A)
(<WRITE> |Dracula won't give it to you.|)))

(SYSTEM 
 ((PLACE dull room)
 (Place dull room)
 (<NOT> (WASAT dull room))
  --> (<WRITE> |You have entered a non-descript room.|)
  (<WRITE> |There is a closet to the west.  A door exits to the south.|)
  (<WRITE> |There are no other windows or doors.|)))

(SYSTEM 
 ((PLACE dull room)
  Closet-closed
  --> (<WRITE> |The closet door is closed.|)))


(SYSTEM 
 ((PLACE dull room)
  & =A (GOING S)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT dull room)
  (PLACE UPPER HALL)))

(SYSTEM 
 ((PLACE dull room)
  (INPUT OPEN ! =X) & =Y 
  CLOSET-CLOSED & =A
  --> (<DELETE> =A) (<DELETE> =Y)
  (<WRITE> |Opening closet.|)
  CLOSET-opened))
  
(SYSTEM 
 ((PLACE dull room)
  CLOSET-opened
  & =A (INPUT CLOSE ! =X)
  & =B --> (<DELETE> =A)
  CLOSET-CLOSED
  (<WRITE> |Thud.|)
  (<DELETE> =B)))

(SYSTEM 
 ((PLACE dull room)
  CLOSET-opened
  -->
  (<WRITE> |The closet is open.  It is too far to see in, you'll have to|)
  (<WRITE> |enter it. |)))

(SYSTEM 
 ((PLACE dull room)
  & =A (GOING W)
  & =B CLOSET-opened
  --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT dull room)
  (PLACE SMALL CLOSET)))

(SYSTEM 
 ((PLACE dull room)
  (INPUT ENTER ! =X) & =A -->
  (GOING W)
  (WENT W)
  (<DELETE> =A)))

(SYSTEM 
 ((PLACE SMALL CLOSET) & =B 
  (GOING E) & =A
  CLOSET-opened -->
  (<DELETE> =A)
  (<DELETE> =B)
  (WASAT SMALL CLOSET)
  (PLACE dull room)))

(SYSTEM 
 ((PLACE SMALL CLOSET)
  (PLACE small closet)
  (<NOT> (WASAT SMALL CLOSET))
  (NAME =P ! =X)
  -->
  (<WRITE> |This is a tiny closet.  Against the wall is a skeleton.|)
  (<WRITE> |Scrawled on the wall, next to the skeleton is:|)
  (<WRITE> | |)
  (<WRITE> |Dear Bas,|)
  (<WRITE> |So the mystery man finally decides to come home.|)
  (<WRITE> |Well you're a little late.|)
  (<Write> |I was never able to resurrect your mother, |)
  (<WRITE> |but I saw in the paper that you have a beautiful|)
  (<WRITE> |redheaded wife, and a lovely child.  I only hope|)
  (<WRITE> |she hasn't inherited our disease.|)
  (<WRITE> |I finally succumbed to the illness when I was unable|)
  (<WRITE> |to take care of the crop.|)
  (<WRITE> |Good luck,|)
  (<WRITE> |           Dad|)
  (<WRITE> | |)
  (<WRITE> |To the south is a ventilation duct.|)
  (<WRITE> |To the east is a room.|)))

(SYSTEM 
 ((PLACE SMALL CLOSET)
  (INPUT =X SKELETON)
  & =A --> (<DELETE> =A)
  (<WRITE> |Come on now, let your father rest in peace.|)))

(SYSTEM 
 ((PLACE SMALL CLOSET)
  (INPUT GET DAD)
  & =A --> (<DELETE> =A)
  (<WRITE> |This is the skeleton's final resting place.|)))

(SYSTEM 
((PLACE small closet) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducte0) (wasat small closet)))

(SYSTEM 
 ((PLACE SECRET ROOM)
  (PLACE SECRET ROOM)
  (<NOT> (WASAT SECRET ROOM))
  --> (<WRITE> |You are in the secret room.|)
  (<WRITE> |You can go out past the wall, or there is a fireman's pole |)
  (<WRITE> |that goes down.|)))

(SYSTEM 
 ((PLACE SECRET ROOM)
  & =A (GOING D)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT SECRET ROOM)
  (PLACE SECRET STAIRS)))

(SYSTEM 
 ((PLACE SECRET ROOM)
  & =A (GOING W)
  & =B (SECRET PANEL OPEN)
  --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT SECRET ROOM)
  (PLACE UPPER HALL)))

(SYSTEM 
 ((PLACE SECRET ROOM)
  (SECRET PANEL OPEN)
  & =C (INPUT CLOSE ! =X)
  & =B --> (<DELETE> =B)
  (<DELETE> =C)
 (<WRITE> |The wall closes and locks.|)))

(SYSTEM 
 ((PLACE LONG HALL)
  (<NOT> (WASAT LONG HALL))
  --> (<WRITE> |This hall runs east-west.|)))

(SYSTEM 
 ((PLACE LONG HALL)
  & =A (GOING E)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT LONG HALL)
  (PLACE UPPER HALL)))

(SYSTEM 
 ((PLACE LONG HALL)
  & =A (GOING W)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT LONG HALL)
  (PLACE DEAD END)))

(SYSTEM 
 ((PLACE LONG HALL)
  (SOUND IS ON)
  -->
  (<WRITE> |The noise is very loud, it sounds like someone is being flogged with chains!|)))

(SYSTEM 
 ((PLACE DEAD END)
  (<NOT> (WASAT DEAD END))
  -->
  (<WRITE> |You are at a dead end.|)
  (<WRITE> | |)
  (<WRITE>  |A wire can be seen along the wall. It is just visible above the carpet.|)))

(SYSTEM 
 ((PLACE DEAD END)
  & =A (GOING E)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT DEAD END)
  (PLACE LONG HALL)))

(SYSTEM 
 ((PLACE DEAD END)
  (SOUND IS ON)
  (INPUT GET WIRE)
  & =A --> (<DELETE> =A)
  (<WRITE> |You can't get it, but you can see it above the carpet.|)))

(SYSTEM 
 ((PLACE DEAD END)
  (INPUT FOLLOW WIRE)
  & =A --> (<WRITE> |The wire goes east.|)
  (<DELETE> =A)))

(SYSTEM 
 ((PLACE DEAD END)
  (SOUND IS ON)
  -->
  (<WRITE> |I can hardly hear myself think.|)
  (<WRITE> |You now recognize the noise as being an ALICE COOPER GREATEST HITS 
ALBUM.|)))

(SYSTEM 
 ((PLACE WINE CELLAR)
  (PLACE WINE CELLAR)
  (<NOT> (WASAT WINE CELLAR))
  --> (<WRITE> |You are in the wine cellar entrance.|)
  (<WRITE> |A staircase leads up, to the south are racks for wine bottles.|)))

(SYSTEM 
 ((PLACE WINE CELLAR)
  & =A (GOING U)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT WINE CELLAR)
  (PLACE SECRET STAIRS)))

(SYSTEM 
 ((PLACE WINE CELLAR)
  & =A (GOING S)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (WASAT WINE CELLAR)
  (PLACE WINE RACKS (E) (N))))

(SYSTEM 
 ((PLACE WINE CELLAR)
  (INPUT GET WINE)
  & =A --> (<DELETE> =A)
  (<WRITE> |That reminds me, there isn't any wine in sight.|)))


(SYSTEM 
 ((PLACE MAIN HALL)
  (STAIRS ARE COLLAPSED)
  --> (<WRITE> |There is rubble from the stairs to the north.|)))

(SYSTEM 
 ((PLACE MAIN HALL)
  (STAIRS ARE WHOLE)
  --> (<WRITE> |There are stairs that lead up.|)))

(SYSTEM 
 ((PLACE DARK HALL)
  --> (<WRITE> |There is a safe on the wall.|)))

(SYSTEM 
 ((PLACE DARK HALL)
  (INPUT GET SAFE ! =X)
  & =A --> (<DELETE> =A)
  (<WRITE> |The safe is embedded in the wall.|)))

(SYSTEM 
 ((PLACE DARK HALL)
  (INPUT OPEN ! =X)
  & =A (SAFE closed)
  --> (<DELETE> =A)
  (<WRITE> |It is locked.  It is a combination lock.|)
  (<Write> |To open it you should tell me some numbers, all on the same line.|)
  (<WRITE> |eg.  '10 - 10 - 10'|)))

(SYSTEM 
 ((PLACE DARK HALL)
  (SAFE opened)
  (INPUT REACH ! =X)
  & =B (<not> (scored money))--> (<DELETE> =B)
 (<WRITE> |You just got the money in the safe.|)
  (HOLDS MONEY)))

(SYSTEM 
((PLACE dark hall)
(scored money) (INPUT reach ! =X) & =A --> (<DELETE> =A)
(<WRITE> |You are a greedy SOB. No more for you.|)))

(SYSTEM 
 ((PLACE DARK HALL)
  (SAFE opened)
  & =B (INPUT CLOSE ! =X)
  & =C --> (SAFE closed)
  (<DELETE> =B)
  (<DELETE> =C)
  (<WRITE> |The safe closes.|)))

(SYSTEM 
 ((PLACE DARK HALL)
  (SAFE closed)
  & =A (INPUT 6 - 21 - 82)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (SAFE opened)
  (<WRITE> |You sure have a mind for numbers!|)))

(SYSTEM 
 ((PLACE DARK HALL)
  (SAFE closed)
  & =A (INPUT 6-21-82)
  & =B --> (<DELETE> =A)
  (<DELETE> =B)
  (SAFE opened)
  (<WRITE> |You sure have a mind for numbers!|)))

(SYSTEM 
 ((PLACE DARK HALL)
  (SAFE opened)
  --> (<WRITE> |The safe is open.|)
(<WRITE> |You'll have to reach in to get anything.|)))

(SYSTEM 
((PLACE dark hall) (INPUT =x - =y - =z) & =A -->
(<DELETE> =A)
(<Write> |Well, I'll try it.|) (<WRITE> =X) (<WRITE> =Y) (<WRITE> =Z)
(<WRITE> |That didn't work.|)
(<WRITE> |  The safe must be a new version.|)))

(system
((PLACE dark hall) (INPUT 10 - 10 - 10) & =A -->
(<DELETE> =A)
(<WRITE> |That wasn't very original, and it didn't work either.|)))

(SYSTEM 
 ((INPUT FOLLOW WIRE)
  & =A (PLACE LONG HALL)
  --> (<DELETE> =A)
  (<WRITE> |The wire goes east.|)))

(SYSTEM 
 ((INPUT FOLLOW WIRE)
  & =A (PLACE UPPER HALL)
  --> (<DELETE> =A)
  (<WRITE> |The wire goes behind a brick in the stone wall.|)))

(SYSTEM 
 ((INPUT FOLLOW WIRE)
  & =A (PLACE SECRET ROOM)
  --> (<DELETE> =A)
  (<WRITE> |The wire goes through the hole, down.|)))

(SYSTEM 
 ((INPUT FOLLOW WIRE)
  & =A (PLACE SECRET STAIRS)
  --> (<DELETE> =A)
  (<WRITE> |The wire goes out under the west wall.|)))

(SYSTEM 
 ((INPUT FOLLOW WIRE)
  & =A (PLACE LIBRARY)
  --> (<DELETE> =A)
  (<WRITE> |The wire goes west.|)))

(SYSTEM 
 ((INPUT FOLLOW WIRE)
  & =A (PLACE MAIN HALL)
  --> (<DELETE> =A)
  (<WRITE> |The wire goes into the dark hall.|)))

(SYSTEM 
 ((INPUT FOLLOW WIRE)
  & =A (PLACE DARK HALL)
  --> (<DELETE> =A)
   (<WRITE> |The wire goes west.|)))

(SYSTEM 
 ((INPUT FOLLOW WIRE)
  & =A (PLACE SMELLY ROOM)
  (<not> (SCORED STEREO))
  --> (<DELETE> =A)
  (<WRITE> |The wire goes behind some wood panel that opens.|)
  (IN STEREO SMELLY ROOM)))

(SYSTEM 
 ((INPUT (<ANY> PULL BREAK RIP) WIRE)
  & =A (SOUND IS ON)
  & =B --> (<WRITE> |The wire SNAPS!|)  (<WRITE> |'Silence!'|)
  (<DELETE> =A)
  (<DELETE> =B)))

(SYSTEM 
 ((INPUT =x homer) (INPUT =X HOMER) & =A -->
  (<DELETE> =A) (INPUT =X BUST)))

(SYSTEM 
 ((PLACE LIBRARY)
  (STACKS WERE OPEN)
  (INPUT CONTEMPLATE BUST)
  & =A --> (<DELETE> =A)
  (<WRITE> |You get divine inspiration. God says I never met a|)
   (<WRITE> |ghost that wasn't chicken.|)))

(SYSTEM 
 ((PLACE LIBRARY)
  (INPUT CONTEMPLATE BUST)
  & =A --> (<DELETE> =A)
  (<WRITE> |While wasting your time contemplating
 Homer, you notice he is off center.|)))

(SYSTEM 
 ((PLACE LIBRARY)
  (INPUT HIT BUST)
  & =A --> (<DELETE> =A)
  (scored homers)
  (<WRITE> |It's going, going, ... gone.  You just hit a Homer.|)))

(SYSTEM 
((PLACE library) (scored homers) (Input hit bust) & =A (score =q)-->
(<DELETE> =A) (<WRITE> |Don't press your luck!  What do you think this is, a baseball game?|)))

(SYSTEM 
 ((INPUT GET BOOKS) & =A --> (<DELETE> =A) (INPUT GET BOOK)))


(SYSTEM 
 ((PLACE DINING ROOM)
  --> (<WRITE> |There is beautiful unicorn head on the wall, horn and all.|)))

(SYSTEM 
 ((PLACE DINING ROOM)
  (INPUT GET UNICORN ! =X)
  & =A (<NOT> (ONTOP STOOL))
  --> (<DELETE> =A)
  (<WRITE> |Unicorn is too high to reach.|)))

(SYSTEM 
 ((PLACE DINING ROOM)
 (INPUT GET UNICORN)
  & =A (ONTOP STOOL)
  -->
  (<DELETE> =A)
  (<WRITE> |The unicorn head is stuck to the wall.  It is a beautiful specimen though.|)))

(SYSTEM 
 ((PLACE DINING ROOM) (ONTOP STOOL)
  (INPUT get HORN)
  (INPUT get HORN)
  & =A (<NOT> (HOLDS HORN))
  --> (<DELETE> =A)
  (HOLDS HORN)
  (<WRITE> |When you get| 
	   | the horn, it comes off and another one appears in its place.|)))
(SYSTEM 
((PLACE back hall) (elevator broke) (INPUT press ! =X)
(INPUT press ! =X) & =A --> (<DELETE> =A)
(<WRITE> |The elevator is broken.|)))

(SYSTEM 
((PLACE elevator) (elevator broke) (INPUT press ! =X)
(Input press ! =X) & =A --> (<DELETE> =A)
(<WRITE> |The elevator is broken, nothing happens.|)))

 (SYSTEM 
((PLACE back hall) --> (<WRITE> |There is a button on the north wall.|)))

(SYSTEM 
((PLACE back hall) (INPUT press ! =Y) & =A  (elevator closed) & =b
--> (<DELETE> =A) (<DELETE> =B) (elevator opened)))

(SYSTEM 
((PLACE back hall) (elevator closed) --> 
(<WRITE> |There is a closed elevator to the north.|)))

(SYSTEM 
((PLACE back hall) (elevator opened) -->
(<WRITE> |The elevator doors are open.|)))

(SYSTEM 
((PLACE back hall) (elevator opened) (INPUT press ! =X)
& =A --> (<DELETE> =A) (<WRITE> |Nothing happens.  The doors stay open.|)))

(SYSTEM 
((PLACE back hall) & =A (elevator opened) (elevator at =u) & =c
(GOING n) & =b --> (<DELETE> =A) (<DELETE> =B) 
(WASAT back hall) (PLACE elevator) (elevator at H)
(<DELETE> =C)))

(SYSTEM 
((PLACE back hall) 
(INPUT enter ! =w) & =A --> (<DELETE> =A) (GOING n) (WENT N)))

(SYSTEM 
((PLACE back hall) (elevator closed)
(GOING N) & =A --> (<DELETE> =A) 
(<WRITE> |Ouch!!  You bumped you nose on the elevator doors!|)))

(SYSTEM 
((PLACE back hall)  (elevator IS stopped) 
--> (<WRITE> |The elevator is stopped between floors.|)
(<WRITE> |Above the elevator compartment is some strange machinery.|)
(<WRITE> |In order to see more clearly, you should climb on.|)))

(SYSTEM 
((PLACE back hall) & =A (elevator IS stopped)
(INPUT climb ! =X) & =B --> (<DELETE> =A) (<DELETE> =B)
(WASAT back hall) (PLACE top of elevator)
(<WRITE> |BZM would be proud.|)))

(SYSTEM 
((PLACE top of elevator) & =A (going d) & =B --> (<DELETE> =A) (<DELETE> =B)
(wasat top of elevator) (PLACE back hall)))

(SYSTEM 
((PLACE back hall) (elevator is stopped) (INPUT climb ! =X) & =B
(holds =Y) --> (<DELETE> =B) (<WRITE> |The opening is to small for you to fit carrying| (<captosm> =Y))))


(SYSTEM 
((PLACE top of elevator) (PLACE top of elevator) (<not> (WASAT top of
elevator)) -->  (<WRITE>
|You are atop the elevator.  The machinery is of alien creation.|)
(<WRITE> |On the side of it is a small decal.|)
(<WRITE> |The decal reads 'afihYwn Matter Transmission, Inc'|)
(<WRITE> |There are two buttons on the machine, one says NORMAL.|)
(<WRITE> |The other says WAY OUT.|)))

(SYSTEM 
((PLACE top of elevator)  (INPUT press normal) & =A
-->  (<DELETE> =A) (<WRITE> |The elevator shaft starts to shake.|)
(<WRITE> |The machine starts to change color.  Steam spews out!!|)
(<WRITE> |The light goes out on the NORMAL button.|)
(<WRITE> |The shaking stops.  (I think you broke it)|)
(elevator broke)))

(SYSTEM 
((PLACE top of elevator) (INPUT press way out)  & =b
-->  (<DELETE> =B) (orc out)
WAYOUT))

(system
((orc out) (orc out) & =B (orc ! =Z) & =A --> (<DELETE> =A) (<DELETE> =B)
(orced ! =Z)))

(system
((orc out) & =A --> (<DELETE> =A)))

(SYSTEM 
((elevator at p) & =A WAYOUT & =b (PLACE elevator) & =C --> 
(<DELETE> =A) (<DELETE> =B) (<DELETE> =C)
(elevator at h)
transfer
(PLACE lawn iside 5 3) (<WRITE> POOF!!!)))

(system
((elevator at p) WAYOUT (PLACE elevator) (holds =X) -->
(<WRITE> |You suddenly feel very ill.  Your body seems to be dematerializing.|)
(<WRITE> |You can't hold on to the stuff you were carrying.|) (INPUT drop all)))

(SYSTEM 
((PLACE top of elevator) (INPUT press ! =X) & =A (elevator broke)
--> (<DELETE> =A) (<WRITE> |Nothing happens, you did break it.|)))

(SYSTEM 
((PLACE top of elevator) WAYOUT --> (<WRITE> |The WAY OUT light is lit.|)))

(SYSTEM 
((PLACE top of elvator) (<not> WAYOUT) -->
(<WRITE> |The Normal light is lit.|)))

(SYSTEM 
(transfer (in =x elevator) & =A   --> 
(<Write> |Poof!|) (<DELETE> =A) (In =X lawn iside 5 4)))

(system
(transfer (in =x elevator) (rope tied =X) & =A -->
(<DELETE> =A) (<WRITE> |Poof! The rope around the| (<captosm> =X)
|is burned off.|)))

(SYSTEM
(transfer (in rope elevator) & =A -->
(<WRITE> |The rope burns and disappears as it hits the outside air.|)
(<DELETE> =A)))

(system
(transfer (in rope elevator) (rope tied =X) & =A --> 
(<DELETE> =A)))

(SYSTEM 
((PLACE elevator) (PLACE elevator) (<not> (WASAT elevator))
--> (<WRITE> |You are in the elevator.|)
(<WRITE> |There are a bunch of buttons on the wall.|)
(<WRITE> |They are labeled:  P, H, B, HALT, OPEN DOOR.|)
(<WRITE> |Scrawled on a wall is 'Homer kisses dead goats'|)
(<WRITE> |and 'Homer turns my head'|)
(<Write> |On the floor it says, 'L__t g_e_ _ere!'|)))


(SYSTEM 
((PLACE elevator) (elevator at h) -->
(<WRITE> |The H is lit.|)))

(SYSTEM 
((PLACE elevator) (elevator at b) -->
(<WRITE> |The B is lit.|)))

(SYSTEM 
((PLACE elevator) (elevator at p) -->
(<WRITE> |The P is lit.|)))

(SYSTEM 
((PLACE elevator) & =B  (elevator at h)
(elevator opened)
(GOING s) & =A --> (<DELETE> =A) (<DELETE> =B) 
(WASAT elevator) (PLACE back hall)))

(SYSTEM 
((PLACE elevator) (INPUT push ! =X) & =A
--> (<DELETE> =A) (INPUT press ! =X)))

(SYSTEM 
((PLACE elevator) (elevator at =X) & =A (INPUT press (<any> H B P) & =y)
& =b --> (<DELETE> =A) (<DELETE> =b) (elevator going =y)))

(SYSTEM 
((PLACE elevator) (elevator at =x)
(INPUT press halt) & =A --> (<DELETE> =A) 
(<WRITE> |The elevator is not moving turkey.|)))

(SYSTEM 
((PLACE elevator) (elevator at =X) (elevator opened)
(INPUT press open door) & =a --> (<DELETE> =A)
(<WRITE> |The elevator door is already open.|)))

(SYSTEM 
((PLACE elevator) (elevator opened) &  =A 
(elevator going =Y) --> (<DELETE> =A) 
(elevator closed) (<WRITE> |The elevator doors close. BOOM!|)))

(SYSTEM 
((PLACE elevator) (elevator closed) (INPUT then push open) & =A
(elevator going =X) --> (<DELETE> =A) 
(<WRITE> |The doors won't open while the elevator is moving.|)))

(SYSTEM 
((PLACE elevator) (elevator closed)
(elevator going =X) & =A (INPUT then push halt) & =B  -->
(<DELETE> =A) (<DELETE> =B)  
(elevator at H) (elevator is stopped)
(<WRITE> |The elevator bounces to a halt. SCREEEECH!|)))

(SYSTEM 
((PLACE elevator) (elevator closed)
(elevator going =X) & =A (INPUT then press halt) & =B  -->
(<DELETE> =A) (<DELETE> =B)  
(elevator at H) (elevator is stopped)
(<WRITE> |The elevator bounces to a halt. SCREEEECH!|)))

(SYSTEM 
((PLACE elevator) (elevator closed) & =A
(elevator IS stopped) (INPUT press open ! =Z) & =B
--> (<DELETE> =A) (<DELETE> =B) (elevator opened)
(<WRITE> |You are between floors.|)
(<WRITE> |You can see out through the top half of the elevator.|)))

(SYSTEM 
((PLACE elevator) (elevator opened)
(elevator at H) & =B
(elevator IS stopped) & =A (INPUT press (<any> H B P) & =Y) & =C
--> (<DELETE> =A) (<DELETE> =B) (<DELETE> =C) (elevator closed)
(<WRITE> |The doors squeek close.|) (elevator going
 =Y)))

(SYSTEM 
((PLACE elevator) & =A (elevator opened)
(elevator IS stopped) (INPUT climb ! =X) & =A -->
(<DELETE> =A) (GOING s) (WENT S)))

(SYSTEM 
((PLACE elevator) (elevator closed) & =A (elevator going =y) & =B 
 --> (<DELETE> =B) (<DELETE> =A) (<WRITE> |The elevator shakes and starts to move down.|)
(<WRITE> |You feel like you are in free fall.|)
(<WRITE> |You hit a bump, and start to slow down.|)
(elevator opened) (elevator at =Y)
(<WRITE> |You made it.  The elevator has stopped.|)
(<WRITE> |The doors open.|)))

(SYSTEM 
((PLACE elevator) (elevator at B) -->

(<WRITE> |You can smell salt air, but your view of the outside|)
(<WRITE> |is obscured.|)))

(SYSTEM 
((PLACE elevator) & =A (elevator at B) (GOING s) & =V
(elevator opened) & =b
--> (<DELETE> =A) (<DELETE> =v) (<DELETE> =B) 
(WASAT elevator)
(elevator closed)
(<WRITE> |The elevator doors close.  Swish...|) (PLACE Bathysphere)))

(SYSTEM 
((PLACE elevator) & =A (elevator at P)
--> (<WRITE> |The doors opened to reveal a brick wall.|)
(<WRITE> |There is writing saying 'UNDER CONSTRUCTION'|)))

(SYSTEM 
((PLACE elevator)  (INPUT press =Y) & =A
--> (<DELETE> =A) (<WRITE> |There is no button labeled| =Y)))
(SYSTEM 
((PLACE torture chamber) (grill closed) (INPUT enter ! =X) & =A -->
(<DELETE> =A) (<WRITE> |There is a grill over the ventilation duct.|)))

(SYSTEM 
((PLACE torture chamber) (grill closed) & =B (INPUT get grill) & =A -->
(<DELETE> =A) (<DELETE> =B) (grill open) 
(<WRITE> 
|The hinges of the grill keep it on the wall, but it swings open.|)))

(SYSTEM 
((PLACE torture chamber) (grill closed) & =A (INPUT open ! =) & =B -->
(<DELETE> =A) (<DELETE> =B) (grill open) 
(<WRITE> |The grill swings away, leaving enough space for you to enter.|)))

(SYSTEM 
((PLACE torture chamber) (grill closed) (INPUT remove grill) & =A -->
(<DELETE> =A) (Input get grill)))

(SYSTEM 
((PLACE torture chamber)  (going u) & =A --> (<DELETE> =A)
(INPUT enter)))

(SYSTEM 
((PLACE torture chamber)  (INPUT climb ! =X) & =A -->
(<DELETE> =a) (INPUT enter)))

(SYSTEM 
((PLACE torture chamber) (INPUT jump) & =A --> (<DELETE> =A) (INPUT enter)))

(SYSTEM 
((PLACE torture chamber) & =A (grill open) (INPUT enter) & =b -->
(<DELETE> =A) (<DELETE> =B)
(PLACE duct)))

(SYSTEM 
((PLACE torture chamber) (grill open) (INPUT close ! =X) & =A -->
(<DELETE> =A)
(<WRITE> |The grill has become stuck in the open position.|)))

(SYSTEM 
((PLACE duct) (PLACE duct) --> (<WRITE> |You're in the ventilation system.|)))

(SYSTEM 
((PLACE duct) & =A (going d) & =B (grill open) --> (<DELETE> =A) (<DELETE> =B) 
(PLACE torture chamber)))

(SYSTEM 
((PLACE duct) (INPUT open ! =r) & =A --> (<DELETE> =A) (<WRITE> 
|The grill mesh is too fine for you to fit your fingers through to open|)
(<WRITE> |the latch that holds the grill closed.|)))

(SYSTEM 
((PLACE duct) (going d) & =A (grill closed) --> (<DELETE> =A)
(<WRITE> |The grill over the duct is closed and you can't reach the|)
(<WRITE> |latch from inside the duct.|)))

(SYSTEM 
((PLACE duct) & =A (going d) & =B (grill open)  --> (<DELETE> =A)
 (<DELETE> =B) 
(<WRITE> |The grill over the duct opens as you tumble out.|)
(PLACE torture chamber)))

(SYSTEM 
((PLACE duct) (INPUT close ! =X) & =B --> (<DELETE> =B) 
(<WRITE> |The grill seems to be stuck open.|)))

(SYSTEM 
((PLACE duct) --> (<WRITE> |You can see down into the torture chamber.|)
(<WRITE> |The ventilation duct goes off to the west into darkness.|)))

(SYSTEM 
((PLACE duct) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B) 
(PLACE ductz0)))

(SYSTEM 
((PLACE ductz0) --> (<WRITE> |You are in an east-west shaft.|)))

(SYSTEM 
((PLACE ductz0) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE duct)))

(SYSTEM 
((PLACE ductz0) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductA10)))

(SYSTEM 
((PLACE ductA10) --> (<WRITE> |The duct work goes east, north, and west.|)))

(SYSTEM 
((PLACE ductA10) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductA20)))

(SYSTEM 
((PLACE ductA10) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductz0)))

(SYSTEM 
((PLACE ductA10) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductB30)))

(SYSTEM 
((PLACE ductA20) --> (<WRITE> |The duct work goes east, north, and west.|)))

(SYSTEM 
((PLACE ductA20) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductA10)))

(SYSTEM 
((PLACE ductA20) & =A (going w) & =B --> (<DELETE> =a) (<DELETE> =B)
(PLACE ductA30)))

(SYSTEM 
((PLACE ductA20) & =A (going n) & =B --> (<DELETE> =a) (<DELETE> =B)
(PLACE ductC10)))

(SYSTEM 
((PLACE ductA30) --> (<WRITE> |The duct work goes east, north, and west.|)))

(SYSTEM 
((PLACE ducta30) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta20)))

(SYSTEM 
((PLACE ducta30) &  =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb10)))

(SYSTEM 
((PLACE ducta30) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductD0)))

(SYSTEM 
((PLACE ductb10) --> (<WRITE> |The duct work goes east, north, and south.|)))

(SYSTEM 
((PLACE ductb10) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta30)))

(SYSTEM 
((PLACE ductb10) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc10)))

(SYSTEM 
((PLACE ductb10) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb20)))

(SYSTEM 
((PLACE ductb20) --> (<WRITE> |The duct work goes east, north, and south.|)))

(SYSTEM 
((PLACE ductb20) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb10)))

(SYSTEM 
((PLACE ductb20) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta40)))

(SYSTEM 
((PLACE ductb20) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducte0)))

(SYSTEM 
((PLACE ducta40) --> (<WRITE> |The duct work goes east, north, and west.|)))

(SYSTEM 
((PLACE ducta40) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb20)))

(SYSTEM 
((PLACE ducta40) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc21)))

(SYSTEM 
((PLACE ducta40) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductf0)))

(SYSTEM 
((PLACE ductc10) --> (<WRITE> |The duct work goes up, down, west and south.|)))

(SYSTEM 
((PLACE ductc10) & =A (going w) & =b --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb10)))

(SYSTEM 
((PLACE ductc10) & =a (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta20)))

(SYSTEM 
((PLACE ductc10) & =A (going d) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc12)))

(SYSTEM 
((PLACE ductc10) & =A (going u) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc11)))

(SYSTEM 
((PLACE ductb30) --> (<Write> |The duct work goes east, north, and south.|)))

(SYSTEM 
((PLACE ductb30) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc20)))

(SYSTEM 
((PLACE ductb30) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta10)))

(SYSTEM 
((PLACE ductb30) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductg0)))

(SYSTEM 
((PLACE ductd0) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta30)))

(SYSTEM 
((PLACE ductd0) --> (<WRITE> |DEAD END!|)))

(SYSTEM 
((PLACE ducte0) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb20)))

(SYSTEM 
((PLACE ducte0) --> (<WRITE> |You are in a north-south shaft.|)))

(SYSTEM 
((PLACE ducte0) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(<WRITE> |You tumble out of the ventilation system.|)
(PLACE small closet)))

(SYSTEM 
((PLACE ductf0) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta40)) )

(SYSTEM 
((PLACE ductf0) --> (<WRITE> |DEAD END|)))

(SYSTEM 
((PLACE ductg0) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb30)))

(SYSTEM 
((PLACE ductg0) --> (<WRITE> |DEAD END|)))

(SYSTEM 
((PLACE ductc20) --> (<WRITE> |The duct work goes up, down, west and south.|)))

(SYSTEM 
((PLACE ductc20) & =A (going u) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc21)))

(SYSTEM 
((PLACE ductc20) & =A (going d) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc22)))

(SYSTEM 
((PLACE ductc20) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta42)))

(SYSTEM 
((PLACE ductc20) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb30)))

(SYSTEM 
((PLACE ductA11) --> (<WRITE> |The duct work goes east, north, and west.|)))

(SYSTEM 
((PLACE ductA11) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductA21)))

(SYSTEM 
((PLACE ductA11) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductZ1)))

(SYSTEM 
((PLACE ductA11) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductB31)))

(SYSTEM 
((PLACE ductA21) --> (<WRITE> |The duct work goes east, north, and west.|)))

(SYSTEM 
((PLACE ductA21) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductA11)))

(SYSTEM 
((PLACE ductA21) & =A (going w) & =B --> (<DELETE> =a) (<DELETE> =B)
(PLACE ductA31)))

(SYSTEM 
((PLACE ductA21) & =A (going n) & =B --> (<DELETE> =a) (<DELETE> =B)
(PLACE ductC11)))

(SYSTEM 
((PLACE ductA31) --> (<WRITE> |The duct work goes east, north, and west.|)))

(SYSTEM 
((PLACE ducta31) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta21)))

(SYSTEM 
((PLACE ducta31) &  =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb11)))

(SYSTEM 
((PLACE ducta31) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductD1)))

(SYSTEM 
((PLACE ductb11) --> (<WRITE> |The duct work goes east, north, and south.|)))

(SYSTEM 
((PLACE ductb11) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta31)))

(SYSTEM 
((PLACE ductb11) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc11)))

(SYSTEM 
((PLACE ductb11) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb21)))

(SYSTEM 
((PLACE ductb21) --> (<WRITE> |The duct work goes east, north, and south.|)))

(SYSTEM 
((PLACE ductb21) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb11)))

(SYSTEM 
((PLACE ductb21) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta41)))

(SYSTEM 
((PLACE ductb21) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducte1)))

(SYSTEM 
((PLACE ducta41) --> (<WRITE> |The duct work goes east, north, and west.|)))

(SYSTEM 
((PLACE ducta41) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb21)))

(SYSTEM 
((PLACE ducta41) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc22)))

(SYSTEM 
((PLACE ducta41) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductf1)))

(SYSTEM 
((PLACE ductc11) --> (<WRITE> |The duct work goes up, down, west and south.|)))

(SYSTEM 
((PLACE ductc11) & =A (going w) & =b --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb11)))

(SYSTEM 
((PLACE ductc11) & =a (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta21)))

(SYSTEM 
((PLACE ductc11) & =A (going d) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc10)))

(SYSTEM 
((PLACE ductc11) & =A (going u) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc12)))

(SYSTEM 
((PLACE ductb31) --> (<Write> |The duct work goes east, north and south.|)))

(SYSTEM 
((PLACE ductb31) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc21)))

(SYSTEM 
((PLACE ductb31) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta11)))

(SYSTEM 
((PLACE ductb31) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductg1)))

(SYSTEM 
((PLACE ductd1) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta31)))

(SYSTEM 
((PLACE ductd1) --> (<WRITE> |DEAD END|)))

(SYSTEM 
((PLACE ducte1) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb21)))

(SYSTEM 
((PLACE ducte1) --> (<WRITE> |DEAD END|)))

(SYSTEM 
((PLACE ductf1) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta41)) )

(SYSTEM 
((PLACE ductf1) --> (<WRITE> |DEAD END|)))

(SYSTEM 
((PLACE ductg1) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb31)))

(SYSTEM 
((PLACE ductg1) --> (<WRITE> |DEAD END|)))

(SYSTEM 
((PLACE ductz1) --> (<WRITE> |DEAD END|)))

(SYSTEM 
((PLACE ductz1) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta11)))

(SYSTEM 
((PLACE ductc21) --> (<WRITE> |The duct work goes up, down, west and south.|)))

(SYSTEM 
((PLACE ductc21) & =A (going u) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc22)))

(SYSTEM 
((PLACE ductc21) & =A (going d) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc20)))

(SYSTEM 
((PLACE ductc21) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta40)))

(SYSTEM 
((PLACE ductc21) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb31)))

(SYSTEM 
((PLACE ductA12) --> (<WRITE> |The duct work goes east, north, and west.|)))

(SYSTEM 
((PLACE ductA12) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductA22)))

(SYSTEM 
((PLACE ductA12) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductZ2)))


(SYSTEM 
((PLACE ductA12) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductB32)))

(SYSTEM 
((PLACE ductA22) --> (<WRITE> |The duct work goes east, north, and west.|)))

(SYSTEM 
((PLACE ductA22) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductA12)))

(SYSTEM 
((PLACE ductA22) & =A (going w) & =B --> (<DELETE> =a) (<DELETE> =B)
(PLACE ductA32)))

(SYSTEM 
((PLACE ductA22) & =A (going n) & =B --> (<DELETE> =a) (<DELETE> =B)
(PLACE ductC12)))

(SYSTEM 
((PLACE ductA32) --> (<WRITE> |The duct work goes east, north, and west.|)))

(SYSTEM 
((PLACE ducta32) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta22)))

(SYSTEM 
((PLACE ducta32) &  =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb12)))

(SYSTEM 
((PLACE ducta32) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductD2)))

(SYSTEM 
((PLACE ductb12) --> (<WRITE> |The duct work goes east, north, and south.|)))

(SYSTEM 
((PLACE ductb12) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta32)))

(SYSTEM 
((PLACE ductb12) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc12)))

(SYSTEM 
((PLACE ductb12) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb22)))

(SYSTEM 
((PLACE ductb22) --> (<WRITE> |The duct work goes east, north, and south.|)))

(SYSTEM 
((PLACE ductb22) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb12)))

(SYSTEM 
((PLACE ductb22) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta42)))

(SYSTEM 
((PLACE ductb22) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducte2)))

(SYSTEM 
((PLACE ducta42) --> (<WRITE> |The duct work goes east, north, and west.|)))

(SYSTEM 
((PLACE ducta42) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb22)))

(SYSTEM 
((PLACE ducta42) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc20)))

(SYSTEM 
((PLACE ducta42) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductf2)))

(SYSTEM 
((PLACE ductc12) --> (<WRITE> |The duct work goes up, down, west and south.|)))

(SYSTEM 
((PLACE ductc12) & =A (going w) & =b --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb12)))

(SYSTEM 
((PLACE ductc12) & =a (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta22)))

(SYSTEM 
((PLACE ductc12) & =A (going d) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc11)))

(SYSTEM 
((PLACE ductc12) & =A (going u) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc10)))

(SYSTEM 
((PLACE ductb32) --> (<Write> |The duct work goes east, north, and south.|)))

(SYSTEM 
((PLACE ductb32) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc22)))

(SYSTEM 
((PLACE ductb32) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta12)))

(SYSTEM 
((PLACE ductb32) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductg2)))

(SYSTEM 
((PLACE ductd2) & =A (going e) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta32)))

(SYSTEM 
((PLACE ductd2) --> (<WRITE> |DEAD END|)))

(SYSTEM 
((PLACE ducte2) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb22)))

(SYSTEM 
((PLACE ducte2) --> (<WRITE> |DEAD END|)))

(SYSTEM 
((PLACE ductf2) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta42)))

(SYSTEM 
((PLACE ductf2) --> (<WRITE> |You are in a north-south shaft.|)))

(SYSTEM 
((Place ductf2) & =A (going n) & =B --> (<DELETE> =A) (<DELETE> =B)
(<WRITE> |You tumble out of the ventilation system.|)
(PLACE kitchen) (ontop FRIG) ))

(SYSTEM 
((PLACE ductg2) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb32)))

(SYSTEM 
((PLACE ductg2) --> (<WRITE> |DEAD END|)))

(SYSTEM 
((PLACE ductz2) --> (<WRITE> |DEAD END|)))

(SYSTEM 
((PLACE ductz2) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta12)))


(SYSTEM 
((PLACE ductc22) --> (<WRITE> |The duct work goes up, down, west and south.|)))

(SYSTEM 
((PLACE ductc22) & =A (going u) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc20)))

(SYSTEM 
((PLACE ductc22) & =A (going d) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductc21)))

(SYSTEM 
((PLACE ductc22) & =A (going w) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ducta41)))

(SYSTEM 
((PLACE ductc22) & =A (going s) & =B --> (<DELETE> =A) (<DELETE> =B)
(PLACE ductb32)))

(SYSTEM 
((enter =z) (time is =Z) (time is =Z) (PLACE ! =X)  -->
(<WRITE> |You hear a truck pull into the yard.|)))

(SYSTEM 
((return =X) (time is =X) (time =X) --> (<WRITE> |You hear a truck drive off.|)))

(SYSTEM 
((holds corkscrew) (<not> (scored screw)) (score =Q) & =A -->
(<DELETE> =A) (scored screw) (score (<+> 15 =Q))))

(SYSTEM 
((holds horn) (score =Y) & =A (<not> (scored horn)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored horn)))

(SYSTEM 
((holds gold) (score =Y) & =A (<not> (scored gold)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored gold)))

(SYSTEM 
((holds football) (score =Y) & =A (<not> (scored football)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored football)))

(SYSTEM 
((holds stereo) (score =Y) & =A (<not> (scored stereo)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored stereo)))

(SYSTEM 
((holds ring) (score =Y) & =A (<not> (scored ring)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored ring)))

(SYSTEM 
((holds candlesticks) (score =Y) & =A (<not> (scored candlesticks)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored candlesticks)))

(SYSTEM 
((holds marijuana) (score =Y) & =A (<not> (scored marijuana)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored marijuana)))

(SYSTEM 
((holds cube) (score =Y) & =A (<not> (scored cube)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored cube)))

(SYSTEM 
((holds money) (score =Y) & =A (<not> (scored money)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored money)))

(SYSTEM 
((holds chair) (score =Y) & =A (<not> (scored chair)) -->
(<DELETE> =A) (score (<+> =y 15)) (scored chair)))
