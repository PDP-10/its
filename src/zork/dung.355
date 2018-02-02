<COND (<G? ,MUDDLE 104>
       <PSETG MSG-STRING "Muddle 105 Version/Please report strange occurances.">)>

"Device definitions for save and restore"
<COND (<L? ,MUDDLE 100>
       <PSETG DEVICE-TABLE '["A" "AI" "D" "DM" "C" "ML" "H" "AI" "L" "AI"
			    "M" "ML" "N" "MC" "P" "ML" "U" "MC" "Z" "ML"]>)>

; "SUBTITLE POBLIST DEFINITIONS AND PARSER STRUCTURES"

<MPOBLIST ACTIONS-POBL 17>
<PSETG ACTIONS-POBL ,ACTIONS-POBL>

<MPOBLIST DIRECTIONS-POBL 17>
<PSETG DIRECTIONS-POBL ,DIRECTIONS-POBL>

<MPOBLIST WORDS-POBL 23>
<PSETG WORDS-POBL ,WORDS-POBL>

<MPOBLIST OBJECT-POBL 47>

<MPOBLIST ROOM-POBL 47>

<MOBLIST FLAG 17>

<SETG LAST-IT <GET-OBJ "#####">>
<SETG BUNUVEC <REST <IUVECTOR 8 <GET-OBJ "#####">> 8>>
<SETG BUNCH ,BUNUVEC>
<SETG PREPVEC
      ![<CHTYPE [<FIND-PREP "WITH"> <GET-OBJ "#####">] PHRASE>
        <CHTYPE [<FIND-PREP "WITH"> <GET-OBJ "#####">] PHRASE>
        <CHTYPE [<FIND-PREP "WITH"> <GET-OBJ "#####">] PHRASE>
        <CHTYPE [<FIND-PREP "WITH"> <GET-OBJ "#####">] PHRASE>
        <CHTYPE [<FIND-PREP "WITH"> <GET-OBJ "#####">] PHRASE>]>

<SETG BUNCHER
      <PINSERT "BUNCH" ,WORDS-POBL <CHTYPE [<PSTRING "BUNCH"> BUNCHEM] VERB>>>

<SETG INBUF <ISTRING 100>>
<SETG INBUF1 <ISTRING 100>>

<SETG PRSVEC <FREEZE <VECTOR <FIND-VERB "XX"> <> <>>>>
<SETG 1STR <ISTRING 1>>

<SETG LEXV 
      <PROG ((FOO ,LEXSIZE))
	    <MAPF ,VECTOR
		  <FUNCTION ()
			    <AND <0? <SET FOO <- .FOO 1>>> <MAPSTOP>>
			    <MAPRET <REST <ISTRING 5> 5> ,1STR 0>>>>>

<SETG LEXV1
      <PROG ((FOO ,LEXSIZE))
	    <MAPF ,VECTOR
		  <FUNCTION ()
			    <AND <0? <SET FOO <- .FOO 1>>> <MAPSTOP>>
			    <MAPRET <REST <ISTRING 5> 5> ,1STR 0>>>>>
			    

<SETG UNKNOWN-LEXV ,LEXV>

; "FOR SR"
<SETG OFIXUPS []>

; "SUBTITLE PURE STRUCTURE FROM ROOMS"

<PSETG FLUSHSTR1 

"There appears before you a threatening figure clad all over in heavy
black armor.  His legs seem like the massive trunk of the oak tree.
His broad shoulders and helmeted head loom high over your own puny
frame and you realize that his powerful arms could easily crush the
very life from your body.  There hangs from his belt a veritable
arsenal of deadly weapons: sword, mace, ball and chain, dagger,
lance, and trident. He speaks with a commanding voice:

		     \"YOU SHALL NOT PASS \"

As he grabs you by the neck all grows dim about you.">

<PSETG FLUSHSTR2
"Suddenly, a sinister, wraithlike figure appears before you, seeming
to float in the air.  He glows with an eldritch light.  In a barely
audible voice he says, \"Begone, defiler!  Your presence upsets the
very balance of the System itself!\"  With a sinister chuckle, he
raises his oaken staff, taps you on the head, and fades into the
gloom.  In his place appears a tastefully lettered sign reading:

			DUNGEON CLOSED

At that instant, you disappear, and all your belongings clatter to
the ground.
">

<PSETG END-HERALD-1
"Suddenly a sinister wraithlike figure, cloaked and hooded, appears
seeming to float in the air before you.  In a low, almost inaudible
voice he says, \"I welcome you to the ranks of the chosen of Zork. You
have persisted through many trials and tests, and have overcome them
all, dispelling the darkness of ignorance and danger.  One such as
yourself is fit to join even the Implementers!\"  He then raises his
oaken staff, and chuckling, drifts away like a wisp of smoke, his
laughter fading in the distance.">

'<PSETG END-HERALD-2 "
Unfortunately, as the wraith fades, in his place appears a tastefully
lettered sign reading:

	      \"Soon to be Constructed on this Site
		  A Complete Modern Zork Endgame
		    Designed and Built by the
		  Frobozz Magic Dungeon Company\"

">

FLAG-NAMES

<BLOCK (<OR <GET FLAG OBLIST> <MOBLIST FLAG>> <GET INITIAL OBLIST> <ROOT>)>

<PSETG FLAG-NAMES
      <UVECTOR TROLL-FLAG
	       LOW-TIDE
	       DOME-FLAG
	       GLACIER-FLAG
	       ECHO-FLAG
	       RIDDLE-FLAG
	       LLD-FLAG
	       CYCLOPS-FLAG
	       MAGIC-FLAG
	       RAINBOW
	       GNOME-DOOR
	       CAROUSEL-FLIP
	       CAGE-SOLVE
	       BANK-SOLVE
	       EGG-SOLVE
	       SING-SONG
	       CPSOLVE
	       PALAN-SOLVE
	       SLIDE-SOLVE>>

<ENDBLOCK>

<PSETG VAL-NAMES <UVECTOR LIGHT-SHAFT>>

<PSETG MONTHS
      ["January"
       "February"
       "March"
       "April"
       "May"
       "June"
       "July"
       "August"
       "September"
       "October"
       "November"
       "December"]>

<PSETG SUICIDAL

"You clearly are a suicidal maniac.  We don't allow psychotics in the
cave, since they may harm other adventurers.  Your remains will be
installed in the Land of the Living Dead, where your fellow
adventurers  may gloat over them.">

;<PSETG NO-PATCH

"What?  You don't trust me?  Why, only last week I patched a running
ITS and it survived for over 30 seconds.  Oh, well.">

;<PSETG PATCH 
"Now, let me see...
Well, we weren't quite able to restore your state.  You can't have
everything.">

<PSETG DEATH
"As you take your last breath, you feel relieved of your burdens. The
feeling passes as you find yourself before the gates of Hell, where
the spirits jeer at you and deny you entry.  Your senses are
disturbed.  The objects in the dungeon appear indistinct, bleached of
color, even unreal.">

<PSETG LIFE 
"From the distance the sound of a lone trumpet is heard.  The room
becomes very bright and you feel disembodied.  In a moment, the
brightness fades and you find yourself rising as if from a long
sleep, deep in the woods.  In the distance you can faintly hear a
song bird and the sounds of the forest.">

<PSETG LOSSTR "I can't do everything, because I ran out of room.">

<PSETG BACKSTR
"He who puts his hand to the plow and looks back is not fit for the
kingdom of winners.  In any case, \"back\" doesn't work.">

\

;"SUBTITLE PURE STRUCTURE FROM ACT1"

<PSETG KITCH-DESC
"You are in the kitchen of the white house.  A table seems to have
been used recently for the preparation of food.  A passage leads to
the west and a dark staircase can be seen leading upward.  To the
east is a small window which is ">

<PSETG LROOM-DESC1
"You are in the living room.  There is a door to the east.  To the
west is a cyclops-shaped hole in an old wooden door, above which is
some strange gothic lettering ">

<PSETG LROOM-DESC2
"You are in the living room.  There is a door to the east, a wooden
door with strange gothic lettering to the west, which appears to be
nailed shut, ">

<PSETG LTIDE-DESC
"It appears that the dam has been opened since the water level behind
it is low and the sluice gate has been opened.  Water is rushing
downstream through the gates.">

<PSETG HTIDE-DESC
"The sluice gates on the dam are closed.  Behind the dam, there can be
seen a wide lake.  A small stream is formed by the runoff from the
lake.">

<PSETG RESER-DESC
"You are on the reservoir.  Beaches can be seen north and south.
Upstream a small stream enters the reservoir through a narrow cleft
in the rocks.  The dam can be seen downstream.">

<PSETG DAM-DESC
"You are standing on the top of the Flood Control Dam #3, which was
quite a tourist attraction in times far distant.  There are paths to
the north, south, east, and down.">

<PSETG CELLA-DESC
"You are in a dark and damp cellar with a narrow passageway leading
east, and a crawlway to the south.  On the west is the bottom of a
steep metal ramp which is unclimbable.">

<PSETG MIRR-DESC 
"You are in a large square room with tall ceilings.  On the south wall
is an enormous mirror which fills the entire wall.  There are exits
on the other three sides of the room.">

<PSETG TROLLDESC
"A nasty-looking troll, brandishing a bloody axe, blocks all passages
out of the room.">

<PSETG TROLLOUT
"An unconscious troll is sprawled on the floor.  All passages out of
the room are open.">

<PSETG CYCLOKILL
"The cyclops, tired of all of your games and trickery, eats you.
The cyclops says 'Mmm.  Just like mom used to make 'em.'">

<PSETG CYCLOFOOD
"The cyclops says 'Mmm Mmm.  I love hot peppers!  But oh, could I use
a drink.  Perhaps I could drink the blood of that thing'.  From the
gleam in his eye, it could be surmised that you are 'that thing'.">

<PSETG CYCLOLOOK
"A cyclops, who looks prepared to eat horses (much less mere
adventurers), blocks the staircase.  From his state of health, and
the bloodstains on the walls, you gather that he is not very
friendly, though he likes people.">

<PSETG CYCLOEYE
"The cyclops is standing in the corner, eyeing you closely.  I don't
think he likes you very much.  He looks extremely hungry even for a
cyclops.">

<PSETG ROBBER-C-DESC
"There is a suspicious-looking individual, holding a bag, leaning
against one wall.  He is armed with a vicious-looking stiletto.">

<PSETG ROBBER-U-DESC
"There is a suspicious-looking individual lying unconscious on the
ground.  His bag and stiletto seem to have vanished.">

<PSETG RESDESC
"However, with the water level lowered, there is merely a wide stream
running through the center of the room.">

<PSETG GLADESC
"This is a large room, with giant icicles hanging from the walls
and ceiling.  There are passages to the north and east.">

<PSETG GLACIER-WIN
"The torch hits the glacier and explodes into a great ball of flame,
devouring the glacier.  The water from the melting glacier rushes
downstream, carrying the torch with it.  In the place of the glacier,
there is a passageway leading west.">

<PSETG YUKS
      '["A valiant attempt."
	"You can't be serious."
	"Not a prayer."
	"Not likely."
	"An interesting idea..."
	"What a concept!"]>

<PSETG RUSTY-KNIFE-STR
"As the knife approaches its victim, your mind is submerged by an
overmastering will.  Slowly, your hand turns, until the rusty blade
is an inch from your neck.  The knife seems to sing as it savagely
slits your throat.">

<PSETG CURSESTR
"A ghost appears in the room and is appalled at your having
desecrated the remains of a fellow adventurer.  He casts a curse
on all of your valuables and orders them banished to the Land of
the Living Dead.  The ghost leaves, muttering obscenities.">

<PSETG TORCH-DESC
"This is a large room with a prominent doorway leading to a down
staircase. To the west is a narrow twisting tunnel, covered with
a thin layer of dust.  Above you is a large dome painted with scenes
depicting elfin hacking rites. Up around the edge of the dome
(20 feet up) is a wooden railing. In the center of the room there
is a white marble pedestal.">

<PSETG DOME-DESC
"You are at the periphery of a large dome, which forms the ceiling
of another room below.  Protecting you from a precipitous drop is a
wooden railing which circles the dome.">

<PSETG HELLGATE
"You are outside a large gateway, on which is inscribed 
	\"Abandon every hope, all ye who enter here.\"  
The gate is open; through it you can see a desolation, with a pile of
mangled corpses in one corner.  Thousands of voices, lamenting some
hideous fate, can be heard.">

<PSETG EXOR1
"The bell suddenly becomes red hot and falls to the ground. The
wraiths, as if paralyzed, stop their jeering and slowly turn to face
you.  On their ashen faces, the expression of a long-forgotten terror
takes shape.">

<PSETG EXOR2
"The flames flicker wildly and appear to dance.  The earth beneath
your feet trembles, and your legs nearly buckle beneath you.
The spirits cower at your unearthly power.">

<PSETG EXOR3
"Each word of the prayer reverberates through the hall in a deafening
confusion.  As the last word fades, a voice, loud and commanding,
speaks: 'Begone, fiends!'.  A heart-stopping scream fills the cavern, 
and the spirits, sensing a greater power, flee through the walls.">

<PSETG EXOR4
"The tension of this ceremony is broken, and the wraiths, amused but
shaken at your clumsy attempt, resume their hideous jeering.">

<PSETG XORCST2
"There is a clap of thunder, and a voice echoes through the
cavern: \"Begone, chomper!\"  Apparently, the voice thinks you
are an evil spirit, and dismisses you from the realm of the living.">

<PSETG LLD-DESC
"You have entered the Land of the Living Dead, a large desolate room.
Although it is apparently uninhabited, you can hear the sounds of
thousands of lost souls weeping and moaning.  In the east corner are
stacked the remains of dozens of previous adventurers who were less
fortunate than yourself.  To the east is an ornate passage,
apparently recently constructed.  A passage exits to the west.">

<PSETG LLD-DESC1
"Amid the desolation, you spot what appears to be your head,
at the end of a long pole.">

<PSETG BRO1
       "The mailing label on this glossy brochure from MIT Tech reads:

		">

<PSETG BRO2
       
"
		c/o Local Dungeon Master
		White House, GUE

From the Introduction:

The brochure describes, for the edification of the prospective
student, the stringent but wide-ranging curriculum of MIT Tech.
Required courses are offered in Ambition, Distraction, Uglification
and Derision.  The Humanities are not slighted in this institution,
as the student may register for Reeling and Writhing, Mystery
(Ancient and Modern), Seaography, and Drawling (which includes
Stretching and Fainting in Coils).  Advanced students are expected to
learn Laughing and Grief.

				William Barton Flathead, Fovnder

(The brochure continues in this vein for a few hundred more pages.)">

<PSETG DROWNINGS
      '["up to your ankles."
	"up to your shin."
	"up to your knees."
	"up to your hips."
	"up to your waist."
	"up to your chest."
	"up to your neck."
	"over your head."
	"high in your lungs."]>

<PSETG CYCLOMAD
      '["The cyclops seems somewhat agitated."
	"The cyclops appears to be getting more agitated."
	"The cyclops is moving about the room, looking for something."
	
"The cyclops was looking for salt and pepper.  I think he is gathering
condiments for his upcoming snack."
	"The cyclops is moving toward you in an unfriendly manner."
	"You have two choices: 1. Leave  2. Become dinner."]>

<PSETG HELLOS
      '["Hello."
	"Good day."
	"Nice weather we've been having lately"
	"Goodbye."]>

<PSETG WHEEEEE
      '["Very good.  Now you can go to the second grade."
	"Have you tried hopping around the dungeon, too?"
	"Are you enjoying yourself?"
	"Wheeeeeeeeee!!!!!"
	"Do you expect me to applaud?"]>

<PSETG JUMPLOSS
      '["You should have looked before you leaped."
	"I'm afraid that leap was a bit much for your weak frame."
	"In the movies, your life would be passing in front of your eyes."
	"Geronimo....."]>

<PSETG DUMMY
      '["Look around."
	"You think it isn't?"
	"I think you've already done that."]>

<PSETG OFFENDED 
  '["Such language in a high-class establishment like this!"
    "You ought to be ashamed of yourself."
    "Its not so bad.  You could have been killed already."
    "Tough shit, asshole."
    "Oh, dear.  Such language from a supposed winning adventurer!"]>

<PSETG DOORMUNGS
  '["The door is invulnerable."
    "You cannot damage this door."
    "The door is still under warranty."]>

<PSETG HO-HUM
 '[" does not seem to do anything."
   " is not notably useful."
   " isn't very interesting."
   " doesn't appear worthwhile."
   " has no effect."
   " doesn't do anything."]>




;"SUBTITLE PURE STRUCTURE FROM ACT2"

<PSETG BAT-DROPS
      '["MINE1"
	"MINE2"
	"MINE3"
	"MINE4"
	"MINE5"
	"MINE6"
	"MINE7"
	"TLADD"
	"BLADD"]>

<PSETG MACHINE-DESC
"This is a large room which seems to be air-conditioned.  In one
corner there is a machine (?) which is shaped somewhat like a clothes
dryer.  On the 'panel' there is a switch which is labelled in a
dialect of Swahili.  Fortunately, I know this dialect and the label
translates to START.  The switch does not appear to be manipulable by
any human hand (unless the fingers are about 1/16 by 1/4 inch).  On
the front of the machine is a large lid, which is ">

<PSETG CDIGS
   '["You are digging into a pile of bat guano."
     "You seem to be getting knee deep in guano."
     "You are covered with bat turds, cretin."]>

<PSETG BDIGS
   '["You seem to be digging a hole here."
     "The hole is getting deeper, but that's about it."
     "You are surrounded by a wall of sand on all sides."]>

<PSETG OVER-FALLS-STR
"I didn't think you would REALLY try to go over the falls in a
barrel. It seems that some 450 feet below, you were met by a number
of  unfriendly rocks and boulders, causing your immediate demise.  Is
this what 'over a barrel' means?">

<PSETG OVER-FALLS-STR1
"Unfortunately, a rubber raft doesn't provide much protection from
the unfriendly sorts of rocks and boulders one meets at the bottom of
many waterfalls.  Including this one.">

<PSETG SWIMYUKS
   '["I don't really see how."
     "I think that swimming is best performed in water."
     "Perhaps it is your head that is swimming."]>

<PSETG GRUE-DESC1
"The grue is a sinister, lurking presence in the dark places of the
earth.  Its favorite diet is adventurers, but its insatiable
appetite is tempered by its fear of light.  No grue has ever been
seen by the light of day, and few have survived its fearsome jaws
to tell the tale.">

<PSETG GRUE-DESC2
"There is no grue here, but I'm sure there is at least one lurking
in the darkness nearby.  I wouldn't let my light go out if I were
you!">

<PSETG BRICK-BOOM 
"Now you've done it.  It seems that the brick has other properties
than weight, namely the ability to blow you to smithereens.">

<PSETG HOOK-DESC "There is a small hook attached to the rock here.">

<PSETG GREEK-TO-ME 
"This book is written in a tongue with which I am unfamiliar.">

<PSETG GNOME-DESC
"A volcano gnome seems to walk straight out of the wall and says
'I have a very busy appointment schedule and little time to waste on
tresspassers, but for a small fee, I'll show you the way out.'  You
notice the gnome nervously glancing at his watch.">

\

;"SUBTITLE PURE STRUCTURE FROM ACT3"

<PSETG HEADSTR1
"Although the implementers are dead, they foresaw that some cretin
would tamper with their remains.  Therefore, they took steps to
punish such actions.">

<PSETG HEADSTR
"Unfortunately, we've run out of poles.  Therefore, in punishment for
your most grievous sin, we shall deprive you of all your valuables,
and of your life.">

<PSETG CAGESTR
"As you reach for the sphere, a steel cage falls from the ceiling
to entrap you.  To make matters worse, poisonous gas starts coming
into the room.">

<PSETG ROBOTDIE
"The robot is injured (being of shoddy construction) and falls to the
floor in a pile of garbage, which disintegrates before your eyes.">

<PSETG VAPORS
"Just before you pass out, you notice that the vapors from the
flask's contents are fatal.">

<PSETG CRUSHED
"The room seems to have become too small to hold you.  It seems that
the  walls are not as compressible as your body, which is somewhat
demolished.">

<PSETG ICEMUNG
"The door to the room seems to be blocked by sticky orange rubble
from an explosion.  Probably some careless adventurer was playing
with blasting cakes.">

<PSETG ICEBLAST "You have been blasted to smithereens (wherever they are).">

<PSETG CMACH-DESC
"This is a large room full of assorted heavy machinery.  The room
smells of burned resistors. The room is noisy from the whirring
sounds of the machines. Along one wall of the room are three buttons
which are, respectively, round, triangular, and square.  Naturally,
above these buttons are instructions written in EBCDIC.  A large sign
in English above all the buttons says
		'DANGER -- HIGH VOLTAGE '.
There are exits to the west and the south.">

<PSETG SPINDIZZY
"According to Prof. TAA of MIT Tech, the rapidly changing magnetic
fields in the room are so intense as to cause you to be electrocuted. 
I really don't know, but in any event, something just killed you.">

<PSETG SPINROBOT
"According to Prof. TAA of MIT Tech, the rapidly changing magnetic
fields in the room are so intense as to fry all the delicate innards
of the robot.  I really don't know, but in any event, smoke is coming
out of its ears and it has stopped moving.">

<PSETG ROBOT-CRUSH
"As the robot reaches for the sphere, a steel cage falls from the
ceiling.  The robot attempts to fend it off, but is trapped below it.
Alas, the robot short-circuits in his vain attempt to escape, and
crushes the sphere beneath him as he falls to the floor.">

<PSETG POISON "Time passes...and you die from some obscure poisoning.">

<PSETG ALARM-VOICE 
"A metallic voice says 'Hello, Intruder!  Your unauthorized presence
in the vault area of the Bank of Zork has set off all sorts of nasty
surprises, several of which seem to have been fatal.  This message
brought to you by the Frobozz Magic Alarm Company.">

<PSETG TELLER-DESC
"You are in a small square room, which was used by a bank officer
whose job it was to retrieve safety deposit boxes for the customer.
On the north side of the room is a sign which reads  'Viewing Room'.
On the ">

<PSETG ZGNOME-DESC 
"An epicene gnome of Zurich wearing a three-piece suit and carrying a
safety-deposit box materializes in the room.  'You seem to have
forgotten to deposit your valuables,' he says, tapping the lid of the
box impatiently.  'We don't usually allow customers to use the boxes
here, but we can make this ONE exception, I suppose...'  He looks
askance at you over his wire-rimmed bifocals.">

<PSETG ZGNOME-POP
"'I wouldn't put THAT in a safety deposit box,' remarks the gnome with
disdain, tossing it over his shoulder, where it disappears with an
understated 'pop'.">

<PSETG ZGNOME-POP-1
"'Surely you jest,' he says.  He tosses the brick over his shoulder,
and disappears with an understated 'pop'.">

<PSETG ZGNOME-BYE
"The gnome looks impatient:  'I may have another customer waiting;
you'll just have to fend for yourself, I'm afraid.  He disappears,
leaving you alone in the bare room.">

<PSETG TREE-DESC
"You are about 10 feet above the ground nestled among some large
branches.  The nearest branch above you is above your reach.">

<PSETG OPERA
"The canary chirps, slightly off-key, an aria from a forgotten opera.
From out of the greenery flies a lovely songbird.  It perches on a
limb just over your head and opens its beak to sing.  As it does so
a beautiful brass bauble drops from its mouth, bounces off the top of
your head, and lands glimmering in the grass.  As the canary winds
down, the songbird flies away.">

<PSETG COMPLEX-DESC
"....
The architecture of this region is getting complex, so that further
descriptions will be diagrams of the immediate vicinity in a 3x3
grid. The walls here are rock, but of two different types - sandstone
and marble. The following notations will be used:
			..  = current position (middle of grid)
		        MM  = marble wall
		        SS  = sandstone wall
		        ??  = unknown (blocked by walls)">

<PSETG GIGO
"The item vanishes into the slot.  A moment later, a previously 
unseen sign flashes 'Garbage In, Garbage Out' and spews
the ">

<PSETG CONFISCATE
"The card slides easily into the slot and vanishes and the metal door
slides open revealing a passageway to the west.  A moment later, a
previously unseen sign flashes: 
     'Unauthorized/Illegal Use of Pass Card -- Card Confiscated'">

<PSETG PAL-ROOM 
"This is a small and rather dreary room, which is eerily illuminated
by a red glow emanating from a crack in one of the walls.  The light 
appears to focus on a dusty wooden table in the center of the room.">

<PSETG PAL-DOOR 
" side of the room is a massive wooden door, near
the top of which, in the center, is a window barred with iron.
A formidable bolt lock is set within the door frame.  A keyhole">

<PSETG SLIDE-DESC
"This is a small chamber, which appears to have been part of a
coal mine. On the south wall of the chamber the letters \"Granite
Wall\" are etched in the rock. To the east is a long passage and
there is a steep metal slide twisting downward. To the north is
a small opening.">

<PSETG SLIPPERY
"As you descend, you realize that the rope is slippery from the grime
of the coal chute and that your grasp will not last long.">

\

;"SUBTITLE PURE STRUCTURE FROM ACT4"

<PSETG TOMB-DESC1
"This is the Tomb of the Unknown Implementer.
A hollow voice says:  \"That's not a bug, it's a feature!\"
In the north wall of the room is the Crypt of the Implementers.  It
is made of the finest marble, and apparently large enough for four
headless corpses.  The crypt is ">

<PSETG TOMB-DESC2
					 " Above the entrance is the
cryptic inscription:

		     \"Feel Free.\"
">

<PSETG CRYPT-DESC
"Though large and esthetically pleasing the marble crypt is empty; the
sarcophagi, bodies, and rich treasure to be expected in a tomb of
this magnificence are missing. Inscribed on one wall is the motto of
the implementers, \"Feel Free\".  There is a door leading out of the
crypt to the south.  The door is ">

<PSETG PASS-WORD-INST
"Suddenly, as you wait in the dark, you begin to feel somewhat
disoriented.  The feeling passes, but something seems different.
As you regain your composure, the cloaked figure appears before you,
and says, \"You are now ready to face the ultimate challenge of
Zork.  Should you wish to do this somewhat more quickly in the
future, you will be given a magic phrase which will at any time
transport you by magic to this point.  To select the phrase, say
	INCANT \"<word>\"
and you will be told your own magic phrase to use by saying
	INCANT \"... <phrase> ...\"
Good luck, and choose wisely!\"
">

<PSETG MIROPEN "The mirror is mounted on a panel which has been opened outward.">

<PSETG PANOPEN "The panel has been opened outward.">

<PSETG HALLWAY
      
"This is a part of the long hallway.  The east and west walls are
dressed stone.  In the center of the hall is a shallow stone channel.
In the center of the room the channel widens into a large hole around
which is engraved a compass rose.">

<PSETG GUARDKILL
      
"The Guardians awake, and in perfect unison, utterly destroy you with
their stone bludgeons.  Satisfied, they resume their posts.">

<PSETG GUARDKILL1
"Suddenly the Guardians realize someone is trying to sneak by them in
the structure.  They awake, and in perfect unison, hammer the box and
its contents (including you) to pulp.  They then resume their posts,
satisfied.">

<PSETG GUARD-ATTACK
"Attacking the Guardians is about as useful as attacking a stone wall.
Unfortunately for you, your futile blow attracts their attention, and
they manage to dispatch you effortlessly.">

<PSETG MIRBREAK "The mirror breaks, revealing a wooden panel behind it.">

<PSETG MIRBROKE "The mirror has already been broken.">

<PSETG PANELBREAK "To break the panel you would have to break the mirror first.">

<PSETG PANELBROKE "The panel is not that easily destroyed.">

<PSETG DIRVEC
      <MAPF ,VECTOR
	    <FUNCTION (X Y)
		      <MAPRET <CHTYPE <PSTRING .X> DIRECTION> .Y>>
            ["NORTH" "NE" "EAST" "SE" "SOUTH" "SW" "WEST" "NW"]
            [0 45 90 135 180 225 270 315]>>

<PSETG GUARDSTR
      
", identical stone statues face each other from
pedestals on opposite sides of the corridor.  The statues represent
Guardians of Zork, a military order of ancient lineage.  They are
portrayed as heavily armored warriors standing at ease, hands clasped
around formidable bludgeons.">

<PSETG INSIDE-MIRROR-1
"You are inside a rectangular box of wood whose structure is rather
complicated.  Four sides and the roof are filled in, and the floor is
open.
     As you face the side opposite the entrance, two short sides of
carved and polished wood are to your left and right.  The left panel
is mahogany, the right pine.  The wall you face is red on its left
half and black on its right.  On the entrance side, the wall is white
opposite the red part of the wall it faces, and yellow opposite the
black section.  The painted walls are at least twice the length of
the unpainted ones.  The ceiling is painted blue.
     In the floor is a stone channel about six inches wide and a foot
deep.  The channel is oriented in a north-south direction.  In the
exact center of the room the channel widens into a circular
depression perhaps two feet wide.  Incised in the stone around this
area is a compass rose.
     Running from one short wall to the other at about waist height
is a wooden bar, carefully carved and drilled.  This bar is pierced
in two places.  The first hole is in the center of the bar (and thus
the center of the room).  The second is at the left end of the room
(as you face opposite the entrance).  Through each hole runs a wooden
pole.
     The pole at the left end of the bar is short, extending about a foot
above the bar, and ends in a hand grip.  The pole ">

<PSETG MIRROR-POLE-DESC
"     The long pole at the center of the bar extends from the ceiling
through the bar to the circular area in the stone channel.  This
bottom end of the pole has a T-bar a bit less than two feet long
attached to it, and on the T-bar is carved an arrow.  The arrow and
T-bar are pointing ">

<PSETG LONGDIRS
      '["north"
	"northeast"
	"east"
	"southeast"
	"south"
	"southwest"
	"west"
	"northwest"]>

<PSETG NUMS '["one" "two" "three" "four" "five" "six" "seven" "eight"]>

<PSETG MASTER-ATTACK
"The dungeon master is taken momentarily by surprise.  He dodges your
blow, and then, with a disappointed expression on his face, he raises
his staff, and traces a complicated pattern in the air.  As it
completes you crumble into dust.">

<PSETG INQ-LOSE "\" The dungeon master,
obviously disappointed in your lack of knowledge, shakes his head and
mumbles \"I guess they'll let anyone in the Dungeon these days\".  With
that, he departs.">

<PSETG QUIZ-WIN
"The dungeon master, obviously pleased, says \"You are indeed a
master of lore. I am proud to be at your service.\"  The massive
wooden door swings open, and the master motions for you to enter.">

<PSETG QUIZ-RULES
"The knock reverberates along the hall.  For a time it seems there
will be no answer.  Then you hear someone unlatching the small wooden
panel.  Through the bars of the great door, the wrinkled face of an
old man appears.  He gazes down at you and intones as follows:

     \"I am the Master of the Dungeon, whose task it is to insure
that none but the most scholarly and masterful adventurers are
admitted into the secret realms of the Dungeon.  To ascertain whether
you meet the stringent requirements laid down by the Great
Implementers, I will ask three questions which should be easy for one
of your reputed excellence to answer.  You have undoubtedly
discovered their answers during your travels through the Dungeon. 
Should you answer each of these questions correctly within five
attempts, then I am obliged to acknowledge your skill and daring and
admit you to these regions.
     \"All answers should be in the form 'ANSWER \"<answer>\"'\"">

<PSETG EWC-DESC
"This is a large east-west corridor which opens onto a northern
parapet at its center.  You can see flames and smoke as you peer
towards the parapet.  The corridor turns south at its east and west
ends, and due south is a massive wooden door.  In the door is a small
window barred with iron.  The door is ">

<PSETG PARAPET-DESC
"You are standing behind a stone retaining wall which rims a large
parapet overlooking a fiery pit.  It is difficult to see through the
smoke and flame which fills the pit, but it seems to be more or less
bottomless.  It also extends upward out of sight.  The pit itself is
of roughly dressed stone and circular in shape.  It is about two
hundred feet in diameter.  The flames generate considerable heat, so
it is rather uncomfortable standing here.
There is an object here which looks like a sundial.  On it are an
indicator arrow and (in the center) a large button.  On the face of
the dial are numbers 'one' through 'eight'.  The indicator points to
the number '">

<PSETG WIN-TOTALLY
"     As you gleefully examine your new-found riches, the Dungeon
Master himself materializes beside you, and says, \"Now that you have
solved all the mysteries of the Dungeon, it is time for you to assume
your rightly-earned place in the scheme of things.  Long have I
waited for one capable of releasing me from my burden!\"  He taps you
lightly on the head with his staff, mumbling a few well-chosen spells,
and you feel yourself changing, growing older and more stooped.  For
a moment there are two identical mages staring at each other among
the treasure, then you watch as your counterpart dissolves into a
mist and disappears, a sardonic grin on his face.
">

\

;"SUBTITLE PURE STRUCTURE FROM MELEE"

<PSETG SWORD-MELEE
      '![![["Your swing misses the " D " by an inch."]
	   ["A mighty blow, but it misses the " D " by a mile."]
	   ["You charge, but the " D " jumps nimbly aside."]
	   ["Clang! Crash! The " D " parries."]
	   ["A good stroke, but it's too slow, the " D " dodges."]!]
	 ![["Your sword crashes down, knocking the " D " into dreamland."]
	   ["The " D " is battered into unconsciousness."]
	   ["A furious exchange, and the " D " is knocked out!"]!]
	 ![["It's curtains for the " D " as your sword removes his head."]
	   ["The fatal blow strikes the " D " square in the heart:  He dies."]
	   ["The " D " takes a final blow and slumps to the floor dead."]!]
	 ![["The " D " is struck on the arm, blood begins to trickle down."]
	   ["Your sword pinks the " D " on the wrist, but it's not serious."]
	   ["Your stroke lands, but it was only the flat of the blade."]
	   ["The blow lands, making a shallow gash in the " D "'s arm!"]!]
	 ![["The " D " receives a deep gash in his side."]
	   ["A savage blow on the thigh!  The " D " is stunned but can still fight!"]
	   ["Slash!  Your blow lands!  That one hit an artery, it could be serious!"]!]
	 ![["The " D " is staggered, and drops to his knees."]
	   ["The " D " is momentarily disoriented and can't fight back."]
	   ["The force of your blow knocks the " D " back, stunned."]!]
	 ![["The " D "'s weapon is knocked to the floor, leaving him unarmed."]!]!]>

<PSETG KNIFE-MELEE
      '![![["Your stab misses the " D " by an inch."]
	   ["A good slash, but it misses the " D " by a mile."]
	   ["You charge, but the " D " jumps nimbly aside."]
	   ["A quick stroke, but the " D " is on guard."]
	   ["A good stroke, but it's too slow, the " D " dodges."]!]
	 ![["The haft of your knife knocks out the " D "."]
	   ["The " D " drops to the floor, unconscious."]
	   ["The " D " is knocked out!"]!]
	 ![["The end for the " D " as your knife severs his jugular."]
	   ["The fatal thrust strikes the " D " square in the heart:  He dies."]
	   ["The " D " takes a final blow and slumps to the floor dead."]!]
	 ![["The " D " is slashed on the arm, blood begins to trickle down."]
	   ["Your knife point pinks the " D " on the wrist, but it's not serious."]
	   ["Your stroke lands, but it was only the flat of the blade."]
	   ["The blow lands, making a shallow gash in the " D "'s arm!"]!]
	 ![["The " D " receives a deep gash in his side."]
	   ["A savage cut on the leg stuns the " D ", but he can still fight!"]
	   ["Slash!  Your stroke connects!  The " D " could be in serious trouble!"]!]
	 ![["The " D " drops to his knees, staggered."]
	   ["The " D " is confused and can't fight back."]
	   ["The quickness of your thrust knocks the " D " back, stunned."]!]
	 ![["The " D " is disarmed by a subtle feint past his guard."]!]!]>

<PSETG CYCLOPS-MELEE
      '![![["The Cyclops misses, but the backwash almost knocks you over."]
	   ["The Cyclops rushes you, but runs into the wall."]
	   ["The Cyclops trips over his feet trying to get at you."]
	   ["The Cyclops unleashes a roundhouse punch, but you have time to dodge."]!]
	 ![["The Cyclops knocks you unconscious."]
	   ["The Cyclops sends you crashing to the floor, unconscious."]!]
	 ![["The Cyclops raises his arms and crushes your skull."]
	   ["The Cyclops has just essentially ripped you to shreds."]
	   ["The Cyclops decks you.  In fact, you are dead."]
	   ["The Cyclops breaks your neck with a massive smash."]!]
	 ![["A quick punch, but it was only a glancing blow."]
	   ["The Cyclops grabs but you twist free, leaving part of your cloak."]
	   ["A glancing blow from the Cyclops' fist."]
	   ["The Cyclops chops at you with the side of his hand, and it connects,
but not solidly."]!]
	 ![["The Cyclops gets a good grip and breaks your arm."]
	   ["The monster smashes his huge fist into your chest, breaking several
ribs."]
	   ["The Cyclops almost knocks the wind out of you with a quick punch."]
	   ["A flying drop kick breaks your jaw."]
	   ["The Cyclops breaks your leg with a staggering blow."]!]
	 ![["The Cyclops knocks you silly, and you reel back."]
	   ["The Cyclops lands a punch that knocks the wind out of you."]
	   ["Heedless of your weapons, the Cyclops tosses you against the rock
wall of the room."]
	   ["The Cyclops grabs you, and almost strangles you before you wiggle
free, breathless."]!]
	 ![["The Cyclops grabs you by the arm, and you drop your " W "."]
	   ["The Cyclops kicks your " W " out of your hand."]
	   ["The Cyclops grabs your " W ", tastes it, and throws it to the
ground in disgust."]
	   ["The monster grabs you on the wrist, squeezes, and you drop your
" W " in pain."]!]
	 ![["The Cyclops is so excited by his success that he neglects to kill
you."]
	   ["The Cyclops, momentarily overcome by remorse, holds back."]
	   ["The Cyclops seems unable to decide whether to broil or stew his
dinner."]]
	 ![["The Cyclops, no sportsman, dispatches his unconscious victim."]]!]>

<PSETG TROLL-MELEE
      '![![["The troll swings his axe, but it misses."]
	   ["The troll's axe barely misses your ear."]
	   ["The axe sweeps past as you jump aside."]
	   ["The axe crashes against the rock, throwing sparks!"]!]
	 ![["The flat of the troll's axe hits you delicately on the head, knocking
you out."]!]
	 ![["The troll lands a killing blow.  You are dead."]
	   ["The troll neatly removes your head."]
	   ["The troll's axe stroke cleaves you from the nave to the chops."]
	   ["The troll's axe removes your head."]!]
	 ![["The axe gets you right in the side.  Ouch!"]
	   ["The flat of the troll's axe skins across your forearm."]
	   ["The troll's swing almost knocks you over as you barely parry
in time."]
	   ["The troll swings his axe, and it nicks your arm as you dodge."]!]
	 ![["The troll charges, and his axe slashes you on your " W " arm."]
	   ["An axe stroke makes a deep wound in your leg."]
	   ["The troll's axe swings down, gashing your shoulder."]
	   ["The troll sees a hole in your defense, and a lightning stroke
opens a wound in your left side."]!]
	 ![["The troll hits you with a glancing blow, and you are momentarily
stunned."]
	   ["The troll swings; the blade turns on your armor but crashes
broadside into your head."]
	   ["You stagger back under a hail of axe strokes."]
	   ["The troll's mighty blow drops you to your knees."]!]
	 ![["The axe hits your " W " and knocks it spinning."]
	   ["The troll swings, you parry, but the force of his blow disarms you."]
	   ["The axe knocks your " W " out of your hand.  It falls to the floor."]
	   ["Your " W " is knocked out of your hands, but you parried the blow."]!]
	 ![["The troll strikes at your unconscious form, but misses in his rage."]
	   ["The troll hesitates, fingering his axe."]
	   ["The troll scratches his head ruminatively:  Might you be magically
protected, he wonders?"]
	   ["The troll seems afraid to approach your crumpled form."]]
	 ![["Conquering his fears, the troll puts you to death."]]!]>

<PSETG THIEF-MELEE
      '![![["The thief stabs nonchalantly with his stiletto and misses."]
	   ["You dodge as the thief comes in low."]
	   ["You parry a lightning thrust, and the thief salutes you with
a grim nod."]
	   ["The thief tries to sneak past your guard, but you twist away."]!]
	 ![["Shifting in the midst of a thrust, the thief knocks you unconscious
with the haft of his stiletto."]
	   ["The thief knocks you out."]!]
	 ![["Finishing you off, a lightning throw right to the heart."]
	   ["The stiletto severs your jugular.  It looks like the end."]
	   ["The thief comes in from the side, feints, and inserts the blade
into your ribs."]
	   ["The thief bows formally, raises his stiletto, and with a wry grin,
ends the battle and your life."]!]
	 ![["A quick thrust pinks your left arm, and blood starts to
trickle down."]
	   ["The thief draws blood, raking his stiletto across your arm."]
	   ["The stiletto flashes faster than you can follow, and blood wells
from your leg."]
	   ["The thief slowly approaches, strikes like a snake, and leaves
you wounded."]!]
	 ![["The thief strikes like a snake!  The resulting wound is serious."]
	   ["The thief stabs a deep cut in your upper arm."]
	   ["The stiletto touches your forehead, and the blood obscures your
vision."]
	   ["The thief strikes at your wrist, and suddenly your grip is slippery
with blood."]]
	 ![["The butt of his stiletto cracks you on the skull, and you stagger
back."]
	   ["You are forced back, and trip over your own feet, falling heavily
to the floor."]
	   ["The thief rams the haft of his blade into your stomach, leaving
you out of breath."]
	   ["The thief attacks, and you fall back desperately."]!]
	 ![["A long, theatrical slash.  You catch it on your " W ", but the
thief twists his knife, and the " W " goes flying."]
	   ["The thief neatly flips your " W " out of your hands, and it drops
to the floor."]
	   ["You parry a low thrust, and your " W " slips out of your hand."]
	   ["Avoiding the thief's stiletto, you stumble to the floor, dropping
your " W "."]!]
	 ![["The thief, a man of good breeding, refrains from attacking a helpless
opponent."]
	   ["The thief amuses himself by searching your pockets."]
	   ["The thief entertains himself by rifling your pack."]]
	 ![["The thief, noticing you begin to stir, reluctantly finishes you off."]
	   ["The thief, forgetting his essentially genteel upbringing, cuts your
throat."]
	   ["The thief, who is essentially a pragmatist, dispatches you as a
threat to his livelihood."]]!]>

<PSETG DEF1
       <UVECTOR
	  ,MISSED ,MISSED ,MISSED ,MISSED
	  ,STAGGER ,STAGGER
	  ,UNCONSCIOUS ,UNCONSCIOUS
	  ,KILLED ,KILLED ,KILLED ,KILLED ,KILLED>>

<PSETG DEF2A
       <UVECTOR
	  ,MISSED ,MISSED ,MISSED ,MISSED ,MISSED
	  ,STAGGER ,STAGGER
	  ,LIGHT-WOUND ,LIGHT-WOUND
	  ,UNCONSCIOUS>>

<PSETG DEF2B
       <UVECTOR
	  ,MISSED ,MISSED ,MISSED
	  ,STAGGER ,STAGGER
	  ,LIGHT-WOUND ,LIGHT-WOUND ,LIGHT-WOUND
	  ,UNCONSCIOUS
	  ,KILLED ,KILLED ,KILLED>>

<PSETG DEF3A
       <UVECTOR
	  ,MISSED ,MISSED ,MISSED ,MISSED ,MISSED
	  ,STAGGER ,STAGGER
	  ,LIGHT-WOUND ,LIGHT-WOUND
	  ,SERIOUS-WOUND ,SERIOUS-WOUND>>

<PSETG DEF3B
       <UVECTOR
	  ,MISSED ,MISSED ,MISSED
	  ,STAGGER ,STAGGER
	  ,LIGHT-WOUND ,LIGHT-WOUND ,LIGHT-WOUND
	  ,SERIOUS-WOUND ,SERIOUS-WOUND ,SERIOUS-WOUND>>

<PSETG DEF3C
       <UVECTOR
	  ,MISSED
	  ,STAGGER ,STAGGER
	  ,LIGHT-WOUND ,LIGHT-WOUND ,LIGHT-WOUND ,LIGHT-WOUND
	  ,SERIOUS-WOUND ,SERIOUS-WOUND ,SERIOUS-WOUND>>

<PSETG DEF1-RES <UVECTOR ,DEF1 <REST ,DEF1> <REST ,DEF1 2>>>

<PSETG DEF2-RES <UVECTOR ,DEF2A ,DEF2B <REST ,DEF2B> <REST ,DEF2B 2>>>

<PSETG DEF3-RES <UVECTOR ,DEF3A <REST ,DEF3A> ,DEF3B <REST ,DEF3B> ,DEF3C>>

\

"VOCABULARY"

;"GLOBAL VARIABLES WHICH ARE ROOMS MUST BE HERE!"

<PSETG RMGVALS '![BLOC HERE SCOL-ROOM SCOL-ACTIVE!]>

;"GLOBAL VARIABLES WHICH ARE OBJECTS MUST BE HERE!"

<PSETG OBJGVALS '![MATOBJ TIMBER-TIE!-FLAG!]>

;"GLOBAL VARIABLES WHICH ARE MONADS MUST BE HERE!"

<PSETG MGVALS
      '![TROLL-FLAG!-FLAG
	 CAGE-SOLVE!-FLAG
	 BUCKET-TOP!-FLAG
	 CAROUSEL-FLIP!-FLAG
	 CAROUSEL-ZOOM!-FLAG
	 LOW-TIDE!-FLAG
	 DOME-FLAG!-FLAG
	 GLACIER-FLAG!-FLAG
	 ECHO-FLAG!-FLAG
	 RIDDLE-FLAG!-FLAG
	 LLD-FLAG!-FLAG
	 CYCLOPS-FLAG!-FLAG
	 MAGIC-FLAG!-FLAG
	 LIGHT-LOAD!-FLAG
	 SAFE-FLAG!-FLAG
	 GNOME-FLAG!-FLAG
	 GNOME-DOOR!-FLAG
	 MIRROR-MUNG!-FLAG
	 EGYPT-FLAG!-FLAG
	 ON-POLE!-FLAG
	 BLAB!-FLAG
	 BINF!-FLAG
	 BTIE!-FLAG
	 BUOY-FLAG!-FLAG
	 GRUNLOCK!-FLAG
	 GATE-FLAG!-FLAG
	 RAINBOW!-FLAG
	 CAGE-TOP!-FLAG
	 EMPTY-HANDED!-FLAG
	 DEFLATE!-FLAG
	 LIGHT-SHAFT
	 PLAYED-TIME
	 MOVES
	 BRIEF!-FLAG
	 THEN
	 SUPER-BRIEF!-FLAG
	 RAW-SCORE
	 GLACIER-MELT!-FLAG
	 DEATHS
	 GRATE-REVEALED!-FLAG
	 WATER-LEVEL!-FLAG
	 CYCLOWRATH!-FLAG
	 RUG-MOVED!-FLAG
	 LEAVES-GONE!-FLAG
	 END-GAME!-FLAG
	 EG-SCORE
	 BEACH-DIG!-FLAG
	 ZGNOME-FLAG!-FLAG
	 SING-SONG!-FLAG
	 CPHERE
	 CPPUSH!-FLAG
	 CPOUT!-FLAG
	 CPSOLVE!-FLAG
	 XB!-FLAG
	 XC!-FLAG
	 MUD!-FLAG
	 PUNLOCK!-FLAG
	 PTOUCH!-FLAG
	 BRFLAG1!-FLAG
	 BRFLAG2!-FLAG
	 ]>

\

; "SUBTITLE ACTORS"

<ADD-ACTOR 
     <SETG MASTER
	   <CHTYPE [<GET-ROOM "BDOOR"> () 0 <>
		    <GET-OBJ "MASTE"> MASTER-ACTOR 3 0]
		   ADV>>>

<ADD-ACTOR
     <SETG PLAYER
	   <CHTYPE [<GET-ROOM "WHOUS">
		    () 0 <> <GET-OBJ "#####"> DEAD-FUNCTION 0 0]
		   ADV>>>

<ADD-ACTOR 
     <SETG ROBOT
	   <CHTYPE [<GET-ROOM "MAGNE"> () 0 <>
		    <GET-OBJ "ROBOT"> ROBOT-ACTOR 3 0]
		   ADV>>>

\

; "SUBTITLE GLOBAL OBJECTS"

; "**** THESE MUST COME BEFORE ROOMS! ****"

<SETG STAR-BITS 0>

<SETG GLOHI 1>

<SETG IT-OBJECT
      <GOBJECT <>
	       ["IT" "THAT" "THIS" "HIM"]
	       []
	       "random object"
	       <+ ,OVISON ,NDESCBIT>>>

<GOBJECT <>
	 ["GBROC" "BROCH" "MAIL"]
	 ["FREE"]
	 "free brochure"
	 <+ ,OVISON>
	 BROCHURE>

<GOBJECT <>
	 ["#####" "ME" "CRETI" "MYSEL" "SELF"]
	 []
	 "cretin"
	 <+ ,OVISON ,VILLAIN>
	 CRETIN
	 ()
	 (OGLOBAL 0
	  OACTOR ,PLAYER)>

<GOBJECT <>
	 ["WISH" "BLESS"]
	 []
	 "wish"
	 <+ ,OVISON ,NDESCBIT>>

<GOBJECT <>
	 ["EVERY" "ALL"]
	 []
	 "everything"
	 <+ ,OVISON ,TAKEBIT ,NDESCBIT ,NO-CHECK-BIT ,BUNCHBIT>
	 VALUABLES&C>

<GOBJECT <>
	 ["POSSE"]
	 []
	 "possessions"
	 <+ ,OVISON ,TAKEBIT ,NDESCBIT ,NO-CHECK-BIT ,BUNCHBIT>
	 VALUABLES&C>

<GOBJECT <>
	 ["VALUA" "TREAS"]
	 []
	 "valuables"
	 <+ ,OVISON ,TAKEBIT ,NDESCBIT ,NO-CHECK-BIT ,BUNCHBIT>
	 VALUABLES&C>

<GOBJECT <>
	 ["SAILO"]
	 []
	 "sailor"
	 <+ ,OVISON ,NDESCBIT>>

<GOBJECT <>
	 ["TEETH"]
	 []
	 "set of teeth"
	 <+ ,OVISON ,NDESCBIT>>

<GOBJECT <>
	 ["WALL" "WALLS"]
	 []
	 "wall"
	 <+ ,OVISON>
	 WALL-FUNCTION>

<GOBJECT <>
	 ["GWALL" "WALL"]
	 ["GRANI"]
	 "granite wall"
	 <+ ,OVISON>
	 GRANITE>

<GOBJECT <>
	["GROUN" "EARTH" "SAND"]
	[]
	"ground"
	<+ ,OVISON ,DIGBIT>
	GROUND-FUNCTION>

<GOBJECT <>
	 ["GRUE"]
	 []
	 "lurking grue"
	 <+ ,OVISON>
	 GRUE-FUNCTION>

<GOBJECT <>
	 ["HANDS" "HAND"]
	 ["BARE"]
	 "pair of hands"
	 <+ ,OVISON ,NDESCBIT ,TOOLBIT>>

<GOBJECT <>
	 ["LUNGS" "AIR"]
	 []
	 "breath"
	 <+ ,OVISON ,NDESCBIT ,TOOLBIT>>

<GOBJECT <>
	 ["AVIAT" "FLYER"]
	 []
	 "flyer"
	 <+ ,OVISON ,NDESCBIT>>

<GOBJECT <>
	 ["EXCEP" "BUT"]
	 []
	 "moby lossage"
	 <+ ,OVISON ,NDESCBIT>>

<GOBJECT WELLBIT
	 ["WELL"]
	 ["MAGIC"]
	 "well"
	 <+ ,OVISON ,NDESCBIT>
	 WELL-FUNCTION>

<GOBJECT ROPEBIT
	 ["SROPE" "ROPE" "PIECE"]
	 []
	 "piece of rope"
	 <+ ,OVISON ,CLIMBBIT ,NO-CHECK-BIT>
	 SLIDE-ROPE>

<GOBJECT SLIDEBIT
	 ["SLIDE" "CHUTE"]
	 []
	 "chute"
	 ,OVISON
	 SLIDE-FUNCTION>

<GOBJECT CPWALL
	 ["CPEWL" "WALL"]
	 ["EAST" "EASTE"]
	 "eastern wall"
	 ,OVISON
	 CPWALL-OBJECT>

<GOBJECT CPWALL
	 ["CPWWL" "WALL"]
	 ["WEST" "WESTE"]
	 "western wall"
	 ,OVISON
	 CPWALL-OBJECT>

<GOBJECT CPWALL
	 ["CPSWL" "WALL"]
	 ["SOUTH"]
	 "southern wall"
	 ,OVISON
	 CPWALL-OBJECT>

<GOBJECT CPWALL
	 ["CPNWL" "WALL"]
	 ["NORTH"]
	 "northern wall"
	 ,OVISON
	 CPWALL-OBJECT>

<GOBJECT CPLADDER
	 ["CPLAD" "LADDE"]
	 []
	 "ladder"
	 ,OVISON
	 CPLADDER-OBJECT>

<GOBJECT BIRDBIT
	 ["BIRD" "SONGB"]
	 ["SONG"]
	 "bird"
	 <+ ,OVISON ,NDESCBIT>
	 BIRD-OBJECT>

<GOBJECT HOUSEBIT
	 ["HOUSE"]
	 ["WHITE"]
	 "white house"
	 <+ ,OVISON ,NDESCBIT>
	 HOUSE-FUNCTION>

<GOBJECT TREEBIT
	 ["TREE"]
	 []
	 "tree"
	 <+ ,OVISON ,NDESCBIT>>

<GOBJECT GUARDBIT
	 ["GUARD"]
	 []
	 "Guardian of Zork"
	 <+ ,OVISON ,VICBIT ,VILLAIN>
	 GUARDIANS>

<GOBJECT ROSEBIT
	 ["ROSE" "COMPA"]
	 []
	 "compass rose"
	 <+ ,OVISON>>

<GOBJECT MASTERBIT
	 ["MASTE" "KEEPE" "DUNGE"]
	 ["DUNGE"]
	 "dungeon master"
	 <+ ,OVISON ,VICBIT ,ACTORBIT>
	 MASTER-FUNCTION
	 ()
	 (ODESC1 "The dungeon master is quietly leaning on his staff here."
	  OACTOR ,MASTER
	  OGLOBAL 0)>

<GOBJECT MIRRORBIT
	 ["MIRRO" "STRUC"]
	 []
	 "mirror"
	 <+ ,OVISON>
	 MIRROR-FUNCTION>

<GOBJECT PANELBIT
	 ["PANEL"]
	 []
	 "panel"
	 <+ ,OVISON>
	 PANEL-FUNCTION>

<GOBJECT CHANBIT
	 ["CHANN"]
	 []
	 "stone channel"
	 <+ ,OVISON>>

<GOBJECT WALL-ESWBIT
	 ["WEAST" "WALL"]
	 ["EAST" "EASTE"]
	 "eastern wall"
	 <+ ,OVISON ,NDESCBIT>
	 SCOLWALL>

<GOBJECT WALL-ESWBIT
	 ["WSOUT" "WALL"]
	 ["SOUTH"]
	 "southern wall"
	 <+ ,OVISON ,NDESCBIT>
	 SCOLWALL>

<GOBJECT WALL-ESWBIT
	 ["WWEST" "WALL"]
	 ["WEST" "WESTE"]
	 "western wall"
	 <+ ,OVISON ,NDESCBIT>
	 SCOLWALL>

<GOBJECT WALL-NBIT
	 ["WNORT" "WALL"]
	 ["NORTH"]
	 "northern wall"
	 <+ ,OVISON ,NDESCBIT>
	 SCOLWALL>

<GOBJECT RGWATER
	 ["GWATE" "WATER" "QUANT" "LIQUI" "H2O"]
	 []
	 "water"
	 <+ ,DRINKBIT ,OVISON>
	 WATER-FUNCTION>

<GOBJECT DWINDOW
	 ["WINDO"]
	 []
	 "window"
	 ,OVISON
	 <>>

\

; "SUBTITLE DIRECTIONS"

<ADD-DIRECTIONS "#!#!#" "NORTH" "SOUTH" "EAST" "WEST" "LAUNC" "LAND"
	"SE" "SW" "NE" "NW" "UP" "DOWN" "ENTER" "EXIT" "CROSS">

<DSYNONYM "NORTH" "N">
<DSYNONYM "SOUTH" "S">
<DSYNONYM "EAST" "E">
<DSYNONYM "WEST" "W">
<DSYNONYM "UP" "U">
<DSYNONYM "DOWN" "D">
<DSYNONYM "ENTER" "IN">
<DSYNONYM "EXIT" "OUT" "LEAVE">
<DSYNONYM "CROSS" "TRAVE">

\

; "SUBTITLE CEVENT DEFINITIONS"

<OR <LOOKUP "COMPILE" <ROOT>>
    <PROG ()
	<CEVENT 0 BROCHURE T "BROIN">
	<CEVENT 0 CYCLOPS T "CYCIN" T>
	<CEVENT 0 SLIDE-CINT <> "SLDIN" T>
	<CEVENT 0 XB-CINT <> "XBIN" T>
	<CEVENT 0 XC-CINT <> "XCIN" T>
	<CEVENT 0 XBH-CINT <> "XBHIN" T>
	<CEVENT 0 FOREST-ROOM <> "FORIN">
	<CEVENT 0 CURE-CLOCK <> "CURIN">
        <CEVENT 0 MAINT-ROOM T "MNTIN">
        <CEVENT 0 LANTERN T "LNTIN">
	<CEVENT 0 MATCH-FUNCTION T MATIN>
	<CEVENT 0 CANDLES T "CNDIN">
	<CEVENT 0 BALLOON T "BINT">
	<CEVENT 0 BURNUP T "BRNIN" T>
	<CEVENT 0 FUSE-FUNCTION T "FUSIN" T>
	<CEVENT 0 LEDGE-MUNG T "LEDIN" T>
	<CEVENT 0 SAFE-MUNG T "SAFIN" T>
	<CEVENT 0 VOLGNOME T "VLGIN">
	<CEVENT 0 GNOME-FUNCTION T "GNOIN">
	<CEVENT 0 BUCKET T "BCKIN">
	<CEVENT 0 SPHERE-FUNCTION T "SPHIN">
	<CEVENT 0 SCOL-CLOCK T "SCLIN">
	<CEVENT 0 END-GAME-HERALD <> "EGHER">
	<CEVENT 0 ZGNOME-INIT T "ZGNIN">
	<CEVENT 0 ZGNOME-FUNCTION T "ZGLIN">>>
\

; "SUBTITLE ROOMS"

;"basic useful constants for building rooms"

<PSETG DEADEND "Dead End">

<PSETG SDEADEND "You have come to a dead end in the maze.">

<SETG NULEXIT <EXIT "#!#!#" "!">>

<PSETG INDENTSTR <REST <ISTRING 8 !\ > 8>>

\

; "SUBTITLE HOUSE AND VICINITY"

<ROOM "WHOUS"
"This is an open field west of a white house, with a boarded front door."
       "West of House"
       <EXIT "NORTH" "NHOUS" "SOUTH" "SHOUS" "WEST" "FORE1"
	      "EAST" #NEXIT "The door is locked, and there is evidently no key.">
       (<GET-OBJ "FDOOR"> <GET-OBJ "MAILB"> <GET-OBJ "MAT">)
       <>
       <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL ,HOUSEBIT)>

<ROOM "NHOUS"
       "You are facing the north side of a white house.  There is no door here,
and all the windows are barred."
       "North of House"
       <EXIT "WEST" "WHOUS" "EAST" "EHOUS" "NORTH" "FORE3"
	      "SOUTH" #NEXIT "The windows are all barred.">
       ()
       <>
       <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL <+ ,DWINDOW ,HOUSEBIT>)>

<ROOM "SHOUS"
"You are facing the south side of a white house. There is no door here,
and all the windows are barred."
       "South of House"
       <EXIT "WEST" "WHOUS" "EAST" "EHOUS" "SOUTH" "FORE2"
	      "NORTH" #NEXIT "The windows are all barred.">
       ()
       <>
       <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL <+ ,DWINDOW ,HOUSEBIT>)>

<SETG KITCHEN-WINDOW <DOOR "WINDO" "KITCH" "EHOUS">>

<ROOM "EHOUS"
       ""
       "Behind House"
       <EXIT "NORTH" "NHOUS" "SOUTH" "SHOUS" "EAST" "CLEAR"
	      "WEST" ,KITCHEN-WINDOW
	      "ENTER" ,KITCHEN-WINDOW>
       (<GET-OBJ "WINDO">)
       EAST-HOUSE
       <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL ,HOUSEBIT)>

<ROOM "KITCH"
       ""
       "Kitchen"
       <EXIT "EAST" ,KITCHEN-WINDOW "WEST" "LROOM"
	      "EXIT" ,KITCHEN-WINDOW "UP" "ATTIC"
	      "DOWN" #NEXIT "Only Santa Claus climbs down chimneys.">
       (<GET-OBJ "WINDO"> <GET-OBJ "SBAG"> <GET-OBJ "BOTTL">)
       KITCHEN
       <+ ,RLANDBIT ,RLIGHTBIT ,RHOUSEBIT ,RSACREDBIT>
       (RVAL 10)>

<ROOM "ATTIC"
"This is the attic.  The only exit is stairs that lead down."
	"Attic"
	<EXIT "DOWN" "KITCH">
	(<GET-OBJ "BRICK"> <GET-OBJ "ROPE"> <GET-OBJ "KNIFE">)
	<>
	<+ ,RLANDBIT ,RHOUSEBIT>>

<ROOM "LROOM"
       ""
       "Living Room"
       <EXIT "EAST" "KITCH"
	      "WEST" <CEXIT "MAGIC-FLAG" "BLROO" "The door is nailed shut.">
	      "DOWN" <DOOR "DOOR" "LROOM" "CELLA">>
       (<GET-OBJ "WDOOR"> <GET-OBJ "DOOR"> <GET-OBJ "TCASE"> 
	<GET-OBJ "LAMP"> <GET-OBJ "RUG"> <GET-OBJ "PAPER">
	<GET-OBJ "SWORD">)
       LIVING-ROOM
       <+ ,RLANDBIT ,RLIGHTBIT ,RHOUSEBIT ,RSACREDBIT>>

\

; "SUBTITLE FOREST"

<PSETG STFORE "This is a forest, with trees in all directions around you.">

<PSETG FOREST "Forest">

<PSETG FORDES
"This is a dimly lit forest, with large trees all around.  To the
east, there appears to be sunlight.">

<PSETG FORTREE
"This is a dimly lit forest, with large trees all around.  One
particularly large tree with some low branches stands here.">

<PSETG NOTREE #NEXIT "There is no tree here suitable for climbing.">

<ROOM "FORE1"
       ,STFORE
       ,FOREST
       <EXIT "UP" ,NOTREE
	     "NORTH" "FORE1" "EAST" "FORE3" "SOUTH" "FORE2" "WEST" "FORE1">
       ()
       FOREST-ROOM
       <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL <+ ,TREEBIT ,BIRDBIT ,HOUSEBIT>)>

<ROOM "FORE2"
       ,FORDES
       ,FOREST
       <EXIT "UP" ,NOTREE
	     "NORTH" "SHOUS" "EAST" "CLEAR" "SOUTH" "FORE4" "WEST" "FORE1">
       ()
       FOREST-ROOM
       <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL <+ ,TREEBIT ,BIRDBIT ,HOUSEBIT>)>

<ROOM "FORE3"
       ,FORTREE
       ,FOREST
       <EXIT "UP" "TREE"  
	     "NORTH" "FORE2" "EAST" "CLEAR" "SOUTH" "CLEAR" "WEST" "NHOUS">
       (<GET-OBJ "FTREE">)
       FOREST-ROOM
       <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL <+ ,BIRDBIT ,HOUSEBIT>)>

<ROOM "TREE"
      ""
      "Up a Tree"
      <EXIT "DOWN" "FORE3"
	    "UP" #NEXIT "You cannot climb any higher.">
      (<GET-OBJ "NEST"> <GET-OBJ "TTREE">)
      TREE-ROOM
      <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT>
      (RGLOBAL <+ ,BIRDBIT ,HOUSEBIT>)>

<ROOM "FORE4"
       "This is a large forest, with trees obstructing all views except
to the east, where a small clearing may be seen through the trees."
       ,FOREST
       <EXIT "UP" ,NOTREE
	     "EAST" "CLTOP" "NORTH" "FORE5" "SOUTH" "FORE4" "WEST" "FORE2">
       ()
       FOREST-ROOM
       <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL <+ ,TREEBIT ,BIRDBIT ,HOUSEBIT>)>

<ROOM "FORE5"
       ,STFORE
       ,FOREST
       <EXIT "UP" ,NOTREE
	     "NORTH" "FORE5" "SE" "CLTOP" "SOUTH" "FORE4" "WEST" "FORE2">
       ()
       FOREST-ROOM
       <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL <+ ,TREEBIT ,BIRDBIT ,HOUSEBIT>)>

<ROOM "CLEAR"
       ""
       "Clearing"
       <EXIT "SW" "EHOUS" "SE" "FORE5" "NORTH" "CLEAR" "EAST" "CLEAR"
	      "WEST" "FORE3" "SOUTH" "FORE2"
	      "DOWN" <DOOR "GRATE" "MGRAT" "CLEAR" "You can't go through the closed grating.">>
       (<GET-OBJ "GRATE"> <GET-OBJ "LEAVE">)
       CLEARING
       <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL ,HOUSEBIT)>

\

; "SUBTITLE CELLAR AND VICINITY"

<ROOM "CELLA"
       ""
       "Cellar"
       <EXIT "EAST" "MTROL" "SOUTH" "CHAS2"
	      "UP"
	      <DOOR "DOOR" "LROOM" "CELLA">
	      "WEST"
	      #NEXIT "You try to ascend the ramp, but it is impossible, and you slide back down.">
       (<GET-OBJ "DOOR">)
       CELLAR
       ,RLANDBIT
       (RVAL 25)>

<PSETG TCHOMP "The troll fends you off with a menacing gesture.">

<ROOM "MTROL"

"This is a small room with passages off in all directions. 
Bloodstains and deep scratches (perhaps made by an axe) mar the
walls."
       "The Troll Room"
       <EXIT "WEST" "CELLA"
		  "EAST" <CEXIT "TROLL-FLAG" "CRAW4" ,TCHOMP>
		  "NORTH" <CEXIT "TROLL-FLAG" "PASS1" ,TCHOMP>
		  "SOUTH" <CEXIT "TROLL-FLAG" "MAZE1" ,TCHOMP>>
       (<GET-OBJ "TROLL">)>

<ROOM "STUDI" 

"This is what appears to have been an artist's studio.  The walls
and floors are splattered with paints of 69 different colors. 
Strangely enough, nothing of value is hanging here.  At the north and
northwest of the room are open doors (also covered with paint).  An
extremely dark and narrow chimney leads up from a fireplace; although
you might be able to get up it, it seems unlikely you could get back
down."
       "Studio"
       <EXIT "NORTH" "CRAW4"
		  "NW" "GALLE"
		  "UP"
		  <CEXIT "LIGHT-LOAD"
			  "KITCH"
			  "The chimney is too narrow for you and all of your baggage."
			  <> CHIMNEY-FUNCTION>>>

<ROOM "GALLE"
"This is an art gallery.  Most of the paintings which were here
have been stolen by vandals with exceptional taste.  The vandals
left through either the north, south, or west exits."
       "Gallery"
       <EXIT "NORTH" "CHAS2" "SOUTH" "STUDI" "WEST" "BKENT">
       (<GET-OBJ "PAINT">)
       <>
       <+ ,RLANDBIT ,RLIGHTBIT>>

\

; "SUBTITLE MAZE"

<PSETG MAZEDESC "This is part of a maze of twisty little passages, all alike.">
<PSETG SMAZEDESC "Maze">

<ROOM "MAZE1"
       ,MAZEDESC ,SMAZEDESC
       <EXIT "WEST" "MTROL"
	      "NORTH" "MAZE1"
	      "SOUTH" "MAZE2"
	      "EAST" "MAZE4">>

<ROOM "MAZE2"
       ,MAZEDESC ,SMAZEDESC
       <EXIT "SOUTH" "MAZE1"
	      "NORTH" "MAZE4"
	      "EAST" "MAZE3">>

<ROOM "MAZE3"
       ,MAZEDESC ,SMAZEDESC
       <EXIT "WEST" "MAZE2" "NORTH" "MAZE4" "UP" "MAZE5">>

<ROOM "MAZE4"
       ,MAZEDESC ,SMAZEDESC
       <EXIT "WEST" "MAZE3" "NORTH" "MAZE1" "EAST" "DEAD1">>

<ROOM "DEAD1"
       ,DEADEND ,SDEADEND
       <EXIT "SOUTH" "MAZE4">>

<ROOM "MAZE5"
       ,MAZEDESC ,SMAZEDESC
       <EXIT "EAST" "DEAD2" "NORTH" "MAZE3" "SW" "MAZE6">
       (<GET-OBJ "BONES"> <GET-OBJ "BAGCO"> <GET-OBJ "KEYS">
	<GET-OBJ "BLANT"> <GET-OBJ "RKNIF">)>

<ROOM "DEAD2"
       ,DEADEND ,SDEADEND
       <EXIT "WEST" "MAZE5">>

<ROOM "MAZE6"
       ,MAZEDESC ,SMAZEDESC
       <EXIT "DOWN" "MAZE5" "EAST" "MAZE7" "WEST" "MAZE6" "UP" "MAZE9">>

<ROOM "MAZE7"
       ,MAZEDESC ,SMAZEDESC
       <EXIT "UP" "MAZ14" "WEST" "MAZE6" "NE" "DEAD1" "EAST" "MAZE8" "SOUTH" "MAZ15">>

<ROOM "MAZE8"
       ,MAZEDESC ,SMAZEDESC
       <EXIT "NE" "MAZE7" "WEST" "MAZE8" "SE" "DEAD3">>

<ROOM "DEAD3"
       ,DEADEND ,DEADEND
       <EXIT "NORTH" "MAZE8">>

<ROOM "MAZE9"
       ,MAZEDESC ,SMAZEDESC
       <EXIT "NORTH" "MAZE6" "EAST" "MAZ11" "DOWN" "MAZ10" "SOUTH" "MAZ13"
	      "WEST" "MAZ12" "NW" "MAZE9">>

<ROOM "MAZ10"
       ,MAZEDESC ,SMAZEDESC
       <EXIT "EAST" "MAZE9" "WEST" "MAZ13" "UP" "MAZ11">>

<ROOM "MAZ11"
       ,MAZEDESC
       ,SMAZEDESC
       <EXIT "NE" "MGRAT" "DOWN" "MAZ10" "NW" "MAZ13" "SW" "MAZ12">>
	      
<ROOM "MGRAT"
       ""
       "Grating Room"
       <EXIT "SW" "MAZ11" "UP" <DOOR "GRATE" "MGRAT" "CLEAR" "The grating is locked.">>
       (<GET-OBJ "GRATE">)
       MAZE-11>

<ROOM "MAZ12"
       ,MAZEDESC ,SMAZEDESC
       <EXIT "WEST" "MAZE5" "SW" "MAZ11" "EAST" "MAZ13" "UP" "MAZE9" "NORTH" "DEAD4">>

<ROOM "DEAD4"
       ,DEADEND ,DEADEND
       <EXIT "SOUTH" "MAZ12">>

<ROOM "MAZ13"
       ,MAZEDESC ,SMAZEDESC
       <EXIT "EAST" "MAZE9" "DOWN" "MAZ12" "SOUTH" "MAZ10" "WEST" "MAZ11">>

<ROOM "MAZ14"
       ,MAZEDESC ,SMAZEDESC
       <EXIT "WEST" "MAZ15" "NW" "MAZ14" "NE" "MAZE7" "SOUTH" "MAZE7">>

<ROOM "MAZ15"
       ,MAZEDESC ,SMAZEDESC
       <EXIT "WEST" "MAZ14" "SOUTH" "MAZE7" "NE" "CYCLO">>

\

; "SUBTITLE CYCLOPS AND HIDEAWAY"

<ROOM "CYCLO"
       "" "Cyclops Room"
       <EXIT "WEST" "MAZ15" "NORTH" <CEXIT "MAGIC-FLAG" "BLROO" "The north wall is solid rock.">
		  "UP" <CEXIT "CYCLOPS-FLAG" "TREAS" "The cyclops doesn't look like he'll let you past.">>
       (<GET-OBJ "CYCLO">)
       CYCLOPS-ROOM>

<ROOM "BLROO"
"This is a long passage.  To the south is one entrance.  On the
east there is an old wooden door, with a large hole in it (about
cyclops sized)."
       "Strange Passage"
       <EXIT "SOUTH" "CYCLO" "EAST" "LROOM">
       ()
       TIME
       ,RLANDBIT
       (RVAL 10)>

<ROOM "TREAS"

"This is a large room, whose north wall is solid granite.  A number
of discarded bags, which crumble at your touch, are scattered about
on the floor.  There is an exit down and what appears to be a newly
created passage to the east."
	"Treasure Room"
	<EXIT "DOWN" "CYCLO" "EAST" "CPANT">
	(<GET-OBJ "CHALI">)
	TREASURE-ROOM
	,RLANDBIT
	(RVAL 25)>

\

; "SUBTITLE RESERVOIR AREA"

<ROOM "RAVI1"

"This is a deep ravine at a crossing with an east-west crawlway. 
Some stone steps are at the south of the ravine and a steep staircase
descends."
       "Deep Ravine"
       <EXIT "SOUTH" "PASS1" "DOWN"
	     <CEXIT "EGYPT-FLAG"
		    "RESES"
		    "The stairs are to steep for you with your burden."
		    T
		    COFFIN-CURE> "EAST" "CHAS1" "WEST" "CRAW1">>

<ROOM "CRAW1"

"This is a crawlway with a three-foot high ceiling.  Your footing
is very unsure here due to the assortment of rocks underfoot. 
Passages can be seen in the east, west, and northwest corners of the
passage."
       "Rocky Crawl"
       <EXIT "WEST" "RAVI1" "EAST" "DOME" "NW"
	     <CEXIT "EGYPT-FLAG" "EGYPT"
		    "The passage is too narrow to accomodate coffins."
		    T COFFIN-CURE>>>

<ROOM "RESES"
       ""
       "Reservoir South"
       <EXIT "SOUTH" <CEXIT "EGYPT-FLAG"
			      "RAVI1"
			      "The coffin will not fit through this passage."
			      T
			      COFFIN-CURE>
	      "WEST" "STREA"
	      "CROSS" <CEXIT "LOW-TIDE" "RESER" "You are not equipped for swimming.">
	      "NORTH" <CEXIT "LOW-TIDE" "RESER" "You are not equipped for swimming.">
	      "LAUNC" "RESER"
	      "UP" <CEXIT "EGYPT-FLAG"
			   "CANY1"
			   "The stairs are too steep for carrying the coffin."
			   T
			   COFFIN-CURE>>
       ()
       RESERVOIR-SOUTH
       ,RLANDBIT
       (RGLOBAL ,RGWATER)>

<ROOM "RESER"
       ""
       "Reservoir"
       <EXIT "NORTH" "RESEN" "SOUTH" "RESES"
	      "UP" "INSTR" "DOWN" #NEXIT "The dam blocks your way."
	      "LAND" #NEXIT "You must specify direction.">
       (<GET-OBJ "TRUNK">)
       RESERVOIR
       <+ ,RWATERBIT ,RNWALLBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "RESEN"
       ""
       "Reservoir North"
       <EXIT "NORTH" "ATLAN" "LAUNC" "RESER"
	      "CROSS" <CEXIT "LOW-TIDE" "RESER" "You are not equipped for swimming.">
	      "SOUTH" <CEXIT "LOW-TIDE" "RESER" "You are not equipped for swimming.">>
       (<GET-OBJ "PUMP">)
       RESERVOIR-NORTH
       ,RLANDBIT
       (RGLOBAL ,RGWATER)>

<ROOM "STREA"
"You are standing on a path beside a gently flowing stream.  The path
travels to the north and the east."
       "Stream View"
       <EXIT "LAUNC" "INSTR" "EAST" "RESES" "NORTH" "ICY">
       (<GET-OBJ "FUSE">)
       <>
       ,RLANDBIT
       (RGLOBAL ,RGWATER)>

<ROOM "INSTR"
"You are on the gently flowing stream.  The upstream route is too narrow
to  navigate and the downstream route is invisible due to twisting
walls.  There is a narrow beach to land on."
       "Stream"
       <EXIT "UP" #NEXIT "The way is too narrow."
	      "LAND" "STREA"
	      "DOWN" "RESER">
       ()
       <>
       <+ ,RWATERBIT ,RNWALLBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "EGYPT"
"This is a room which looks like an Egyptian tomb.  There is an
ascending staircase in the room as well as doors, east and south."
       "Egyptian Room"
       <EXIT "UP" "ICY" "SOUTH" "LEDG3"
	      "EAST" <CEXIT "EGYPT-FLAG" "CRAW1"
			     "The passage is too narrow to accomodate coffins." T
			     COFFIN-CURE>>
       (<GET-OBJ "COFFI">)>

<ROOM "ICY"
       ""
       "Glacier Room"
       <EXIT "NORTH" "STREA" "EAST" "EGYPT" "WEST" <CEXIT "GLACIER-FLAG" "RUBYR">>
       (<GET-OBJ "ICE">)
       GLACIER-ROOM>

<ROOM "RUBYR"
"This is a small chamber behind the remains of the Great Glacier.
To the south and west are small passageways."
       "Ruby Room"
       <EXIT "WEST" "LAVA" "SOUTH" "ICY">
       (<GET-OBJ "RUBY">)>

<ROOM "ATLAN"
      "This is an ancient room, long under water.  There are exits here
to the southeast and upward."
       "Atlantis Room"
       <EXIT "SE" "RESEN" "UP" "CAVE1">
       (<GET-OBJ "TRIDE">)>

<ROOM "CANY1"
"You are on the south edge of a deep canyon.  Passages lead off
to the east, south, and northwest.  You can hear the sound of
flowing water below."
       "Deep Canyon"
       <EXIT "NW" <CEXIT "EGYPT-FLAG"
			 "RESES"
			 "The passage is too steep for carrying the coffin."
			 T
			 COFFIN-CURE> "EAST" "DAM" "SOUTH" "CAROU">>

\

; "SUBTITLE ECHO ROOM"

<ROOM "ECHO"
"This is a large room with a ceiling which cannot be detected from
the ground. There is a narrow passage from east to west and a stone
stairway leading upward.  The room is extremely noisy.  In fact, it is
difficult to hear yourself think."
       "Loud Room"
       <EXIT "EAST" "CHAS3" "WEST" "PASS5" "UP" "CAVE3">
       (<GET-OBJ "BAR">)
       ECHO-ROOM>

<ROOM "MIRR1"
       ""
       "Mirror Room"
       <EXIT "WEST" "PASS3" "NORTH" "CRAW2" "EAST" "CAVE1">
       (<GET-OBJ "REFL1">)
       MIRROR-ROOM>

<ROOM "MIRR2"
       ""
       "Mirror Room"
       <EXIT "WEST" "PASS4" "NORTH" "CRAW3" "EAST" "CAVE2">
       (<GET-OBJ "REFL2">)
       MIRROR-ROOM
       <+ ,RLANDBIT ,RLIGHTBIT>>

<ROOM "CAVE1"
"This is a small cave with an entrance to the north and a stairway
leading down."
       "Cave"
       <EXIT "NORTH" "MIRR1" "DOWN" "ATLAN">>

<ROOM "CAVE2"
"This is a tiny cave with entrances west and north, and a dark,
forbidding staircase leading down."
       "Cave"
       <EXIT "NORTH" "CRAW3" "WEST" "MIRR2" "DOWN" "LLD1">
       ()
       CAVE2-ROOM>

<ROOM "CRAW2"
"This is a steep and narrow crawlway.  There are two exits nearby to
the south and southwest."
       "Steep Crawlway"
       <EXIT "SOUTH" "MIRR1" "SW" "PASS3">>

<ROOM "CRAW3"
"This is a narrow crawlway.  The crawlway leads from north to south.
However the south passage divides to the south and southwest."
      "Narrow Crawlway"
       <EXIT "SOUTH" "CAVE2" "SW" "MIRR2" "NORTH" "MGRAI">>

<ROOM "PASS3"
"This is a cold and damp corridor where a long east-west passageway
intersects with a northward path."
       "Cold Passage"
       <EXIT "EAST" "MIRR1" "WEST" "SLIDE" "NORTH" "CRAW2">>

<ROOM "PASS4"

"This is a winding passage.  It seems that there is only an exit
on the east end although the whirring from the round room can be
heard faintly to the north."
       "Winding Passage"
       <EXIT "EAST" "MIRR2" "NORTH"
 #NEXIT "You hear the whir from the round room but can find no entrance.">>

\

; "SUBTITLE COAL MINE AREA"

<ROOM "ENTRA"

"You are standing at the entrance of what might have been a coal
mine. To the northeast and the northwest are entrances to the mine,
and there is another exit on the south end of the room."
       "Mine Entrance"
       <EXIT "SOUTH" "SLIDE" "NW" "SQUEE" "NE" "TSHAF">>

<ROOM "SQUEE"
"You are a small room.  Strange squeaky sounds may be heard coming from
the passage at the west end.  You may also escape to the south."
       "Squeaky Room"
       <EXIT "WEST" "BATS" "SOUTH" "ENTRA">>

<ROOM "TSHAF"
       "This is a large room, in the middle of which is a small shaft
descending through the floor into darkness below.  To the west and
the north are exits from this room.  Constructed over the top of the
shaft is a metal framework to which a heavy iron chain is attached."
       "Shaft Room"
       <EXIT "DOWN" #NEXIT "You wouldn't fit and would die if you could."
	      "WEST" "ENTRA" "NORTH" "TUNNE">
       (<GET-OBJ "TBASK">)>

<ROOM "TUNNE"

"This is a narrow tunnel with large wooden beams running across
the ceiling and around the walls.  A path from the south splits into
paths running west and northeast."
       "Wooden Tunnel"
       <EXIT "SOUTH" "TSHAF" "WEST" "SMELL" "NE" "MINE1">>

<ROOM "SMELL"

"This is a small non-descript room.  However, from the direction
of a small descending staircase a foul odor can be detected.  To the
east is a narrow path."
       "Smelly Room"
       <EXIT "DOWN" "BOOM" "EAST" "TUNNE">>

<ROOM "BOOM"
       "This is a small room which smells strongly of coal gas."
       "Gas Room"
       <EXIT "UP" "SMELL">
       (<GET-OBJ "BRACE">)
       BOOM-ROOM
       <+ ,RLANDBIT ,RSACREDBIT>>

<ROOM "TLADD"

"This is a very small room.  In the corner is a rickety wooden
ladder, leading downward.  It might be safe to descend.  There is
also a staircase leading upward."
       "Ladder Top"
       <EXIT "DOWN" "BLADD" "UP" "MINE7">>

<ROOM "BLADD"

"This is a rather wide room.  On one side is the bottom of a
narrow wooden ladder.  To the northeast and the south are passages
leaving the room."
       "Ladder Bottom"
       <EXIT "NE" "DEAD7" "SOUTH" "TIMBE" "UP" "TLADD">>

<ROOM "DEAD7"
       ,DEADEND
       ,DEADEND
       <EXIT "SOUTH" "BLADD">
       (<GET-OBJ "COAL">)>

<PSETG NOFIT "You cannot fit through this passage with that load.">

<ROOM "TIMBE"
"This is a long and narrow passage, which is cluttered with broken
timbers.  A wide passage comes from the north and turns at the 
southwest corner of the room into a very narrow passageway."
       "Timber Room"
       <EXIT "NORTH" "BLADD"
	      "SW" <SETG DARK-ROOM <CEXIT "EMPTY-HANDED" "BSHAF" ,NOFIT>>>
       (<GET-OBJ "OTIMB">)
       NO-OBJS
       <+ ,RLANDBIT ,RSACREDBIT>>

<ROOM "BSHAF" 

"This is a small square room which is at the bottom of a long
shaft. To the east is a passageway and to the northeast a very narrow
passage. In the shaft can be seen a heavy iron chain."
       "Lower Shaft"
       <EXIT "EAST" "MACHI"
	      "OUT" <CEXIT "EMPTY-HANDED" "TIMBE" ,NOFIT>
	      "NE" <CEXIT "EMPTY-HANDED" "TIMBE" ,NOFIT>
	      "UP" #NEXIT "The chain is not climbable.">
       (<GET-OBJ "FBASK">)
       NO-OBJS
       <+ ,RLANDBIT ,RSACREDBIT>>

<ROOM "MACHI"
       ""
       "Machine Room"
       <EXIT "NW" "BSHAF">
       (<GET-OBJ "MSWIT"> <GET-OBJ "MACHI">)
       MACHINE-ROOM>

<ROOM "BATS"
      ""
      "Bat Room"
      <EXIT "EAST" "SQUEE"> 
      (<GET-OBJ "JADE"> <GET-OBJ "BAT">)
      BATS-ROOM
      <+ ,RLANDBIT ,RSACREDBIT>>

\

; "SUBTITLE COAL MINE"

<PSETG MINDESC "This is a non-descript part of a coal mine.">
<PSETG SMINDESC "Coal mine">

<ROOM "MINE1"
       ,MINDESC
       ,SMINDESC
       <EXIT "NORTH" "MINE4" "SW" "MINE2" "EAST" "TUNNE">>

<ROOM "MINE2"
       ,MINDESC
       ,SMINDESC
       <EXIT "SOUTH" "MINE1" "WEST" "MINE5" "UP" "MINE3" "NE" "MINE4">>

<ROOM "MINE3"
       ,MINDESC
       ,SMINDESC
       <EXIT "WEST" "MINE2" "NE" "MINE5" "EAST" "MINE5">>

<ROOM "MINE4"
       ,MINDESC
       ,SMINDESC
       <EXIT "UP" "MINE5" "NE" "MINE6" "SOUTH" "MINE1" "WEST" "MINE2">>

<ROOM "MINE5"
       ,MINDESC
       ,SMINDESC
       <EXIT "DOWN" "MINE6" "NORTH" "MINE7" "WEST" "MINE2" "SOUTH" "MINE3"
              "UP" "MINE3" "EAST" "MINE4">>

<ROOM "MINE6"
       ,MINDESC
       ,SMINDESC
       <EXIT "SE" "MINE4" "UP" "MINE5" "NW" "MINE7">>

<ROOM "MINE7"
       ,MINDESC
       ,SMINDESC
       <EXIT "EAST" "MINE1" "WEST" "MINE5" "DOWN" "TLADD" "SOUTH" "MINE6">>

\

;"SUBTITLE DOME/TORCH AREA"

<ROOM "DOME"
       ""
       "Dome Room"
       <EXIT "EAST" "CRAW1"
	      "DOWN" <CEXIT "DOME-FLAG"
			     "MTORC"
			     "You cannot go down without fracturing many bones.">>
       (<GET-OBJ "RAILI">)
       DOME-ROOM>

<ROOM "MTORC"
       ""
       "Torch Room"
       <EXIT "UP" #NEXIT "You cannot reach the rope." "WEST" "PRM" "DOWN" "CRAW4">
       (<GET-OBJ "TORCH">)
       TORCH-ROOM>

<ROOM "CRAW4"
"This is a north-south crawlway; a passage goes to the east also.
There is a hole above, but it provides no opportunities for climbing."
       "North-South Crawlway"
       <EXIT "NORTH" "CHAS2" "SOUTH" "STUDI" "EAST" "MTROL"
	      "UP" #NEXIT "Not even a human fly could get up it.">>

<ROOM "CHAS2"

"You are on the west edge of a chasm, the bottom of which cannot be
seen. The east side is sheer rock, providing no exits.  A narrow
passage goes west, and the path you are on continues to the north and
south."
       "West of Chasm"
       <EXIT "WEST" "CELLA" "NORTH" "CRAW4" "SOUTH" "GALLE"
		  "DOWN" #NEXIT "The chasm probably leads straight to the infernal regions.">>

<ROOM "PASS1"
"This is a narrow east-west passageway.  There is a narrow stairway
leading down at the north end of the room."
       "East-West Passage"
       <EXIT "EAST" "CAROU" "WEST" "MTROL" "DOWN" "RAVI1" "NORTH" "RAVI1"> 
       ()
       <>
       ,RLANDBIT
       (RVAL 5)>

<ROOM "CAROU"
       ""
       "Round room"
       <EXIT "NORTH" <CEXIT "CAROUSEL-FLIP" "CAVE4" "" <> CAROUSEL-EXIT>
	      "SOUTH" <CEXIT "CAROUSEL-FLIP" "CAVE4" "" <> CAROUSEL-EXIT>
	      "EAST" <CEXIT "CAROUSEL-FLIP" "MGRAI" "" <> CAROUSEL-EXIT>
	      "WEST" <CEXIT "CAROUSEL-FLIP" "PASS1" "" <> CAROUSEL-EXIT>
	      "NW" <CEXIT "CAROUSEL-FLIP" "CANY1" "" <> CAROUSEL-EXIT>
	      "NE" <CEXIT "CAROUSEL-FLIP" "PASS5" "" <> CAROUSEL-EXIT>
	      "SE" <CEXIT "CAROUSEL-FLIP" "PASS4" "" <> CAROUSEL-EXIT>
	      "SW" <CEXIT "CAROUSEL-FLIP" "MAZE1" "" <> CAROUSEL-EXIT>
	      "EXIT" <CEXIT "CAROUSEL-FLIP" "PASS3" "" <> CAROUSEL-OUT>>
       (<GET-OBJ "IRBOX">)
       CAROUSEL-ROOM>

<ROOM "PASS5"
       "This is a high north-south passage, which forks to the northeast."
       "North-South Passage"
       <EXIT "NORTH" "CHAS1" "NE" "ECHO" "SOUTH" "CAROU">>

<ROOM "CHAS1"
"A chasm runs southwest to northeast.  You are on the south edge; the
path exits to the south and to the east."
       "Chasm"
       <EXIT "SOUTH" "RAVI1" "EAST" "PASS5"
		  "DOWN" #NEXIT "Are you out of your mind?">>

<ROOM "CAVE3"

"This is a cave.  Passages exit to the south and to the east, but
the cave narrows to a crack to the west.  The earth is particularly
damp here."
       "Damp Cave"
       <EXIT "SOUTH" "ECHO" "EAST" "DAM"
		  "WEST" #NEXIT "It is too narrow for most insects.">>

<ROOM "CHAS3"
"A chasm, evidently produced by an ancient river, runs through the
cave here.  Passages lead off in all directions."
       "Ancient Chasm"
       <EXIT "SOUTH" "ECHO" "EAST" "TCAVE" "NORTH" "DEAD5" "WEST" "DEAD6">>

<ROOM "DEAD5"
       ,DEADEND
       ,DEADEND
       <EXIT "SW" "CHAS3">>

<ROOM "DEAD6"
       ,DEADEND
       ,DEADEND
       <EXIT "EAST" "CHAS3">>

<ROOM "CAVE4"
"You have entered a cave with passages leading north and southeast."
       "Engravings Cave"
       <EXIT "NORTH" "CAROU" "SE" "RIDDL">
       (<GET-OBJ "ENGRA">)>

<ROOM "RIDDL"

"This is a room which is bare on all sides.  There is an exit down. 
To the east is a great door made of stone.  Above the stone, the
following words are written: 'No man shall enter this room without
solving this riddle:

  What is tall as a house,
	  round as a cup, 
	  and all the king's horses can't draw it up?'

(Reply via 'ANSWER \"answer\"')"
       "Riddle Room"
       <EXIT "DOWN" "CAVE4"
	      "EAST" <CEXIT "RIDDLE-FLAG" "MPEAR"
			     "Your way is blocked by an invisible force.">>
       (<GET-OBJ "SDOOR">)>

<ROOM "MPEAR"
"This is a former broom closet.  The exits are to the east and west."
       "Pearl Room"
       <EXIT "EAST" "BWELL" "WEST" "RIDDL">
       (<GET-OBJ "PEARL">)>

<ROOM "LLD1"
       ""
       "Entrance to Hades"
       <EXIT "EAST"
		<CEXIT "LLD-FLAG"
			"LLD2"
			"Some invisible force prevents you from passing through the gate.">
		"UP" "CAVE2"
		"ENTER"
		<CEXIT "LLD-FLAG"
			"LLD2"
			"Some invisible force prevents you from passing through the gate.">>
       (<GET-OBJ "CORPS"> <GET-OBJ "GATES"> <GET-OBJ "GHOST">)
       LLD-ROOM
       <+ ,RLANDBIT ,RLIGHTBIT>>

<ROOM "LLD2"
       ""
       "Land of the Living Dead"
       <EXIT "EAST" "TOMB"
		"EXIT" "LLD1" "WEST" "LLD1">
       (<GET-OBJ "BODIE">)
       LLD2-ROOM
       <+ ,RLANDBIT ,RLIGHTBIT>
       (RVAL 30)>

<ROOM "MGRAI"
"You are standing in a small circular room with a pedestal.  A set of
stairs leads up, and passages leave to the east and west."
       "Grail Room"
       <EXIT "WEST" "CAROU" "EAST" "CRAW3" "UP" "TEMP1">
       (<GET-OBJ "GRAIL">)>

<ROOM "TEMP1"

"This is the west end of a large temple.  On the south wall is an 
ancient inscription, probably a prayer in a long-forgotten language. 
The north wall is solid granite.  The entrance at the west end of the
room is through huge marble pillars."
       "Temple"
       <EXIT "WEST" "MGRAI" "EAST" "TEMP2">
       (<GET-OBJ "PRAYE"> <GET-OBJ "BELL">)
       <>
       <+ ,RLANDBIT ,RLIGHTBIT ,RSACREDBIT>>

<ROOM "TEMP2"
"This is the east end of a large temple.  In front of you is what
appears to be an altar."
       "Altar"
       <EXIT "WEST" "TEMP1">
       (<GET-OBJ "BOOK"> <GET-OBJ "CANDL">)
       <>
       <+ ,RLANDBIT ,RLIGHTBIT ,RSACREDBIT>>

\

; "SUBTITLE FLOOD CONTROL DAM #3"

<ROOM "DAM"
       ""
       "Dam"
       <EXIT "SOUTH" "CANY1" "DOWN" "DOCK" "EAST" "CAVE3" "NORTH" "LOBBY">
       (<GET-OBJ "BOLT"> <GET-OBJ "DAM"> <GET-OBJ "BUBBL"> <GET-OBJ "CPANL">)
       DAM-ROOM
       <+ ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "LOBBY"
"This room appears to have been the waiting room for groups touring
the dam.  There are exits here to the north and east marked
'Private', though the doors are open, and an exit to the south."
       "Dam Lobby"
       <EXIT "SOUTH" "DAM"
	      "NORTH" "MAINT"
	      "EAST" "MAINT">
       (<GET-OBJ "MATCH"> <GET-OBJ "GUIDE">)
       <>
       <+ ,RLANDBIT ,RLIGHTBIT>>

<ROOM "MAINT"

"This is what appears to have been the maintenance room for Flood
Control Dam #3, judging by the assortment of tool chests around the
room.  Apparently, this room has been ransacked recently, for most of
the valuable equipment is gone. On the wall in front of you is a
group of buttons, which are labelled in EBCDIC. However, they are of
different colors:  Blue, Yellow, Brown, and Red. The doors to this
room are in the west and south ends."
       "Maintenance Room"
       <EXIT "SOUTH" "LOBBY" "WEST" "LOBBY">
       (<GET-OBJ "LEAK"> <GET-OBJ "TUBE"> <GET-OBJ "WRENC">
	<GET-OBJ "BLBUT"> <GET-OBJ "RBUTT"> <GET-OBJ "BRBUT">
	<GET-OBJ "YBUTT"> <GET-OBJ "SCREW"> <GET-OBJ "TCHST">)
       MAINT-ROOM
       ,RLANDBIT>

\

;"SUBTITLE RIVER AREA"

<PSETG CLIFFS #NEXIT "The White Cliffs prevent your landing here.">

<PSETG RIVERDESC "Frigid River">

<PSETG CURRENT #NEXIT "You cannot go upstream due to strong currents.">

<PSETG NARROW "The path is too narrow.">

<ROOM "DOCK"
"You are at the base of Flood Control Dam #3, which looms above you
and to the north.  The river Frigid is flowing by here.  Across the
river are the White Cliffs which seem to form a giant wall stretching
from north to south along the east shore of the river as it winds its
way downstream."
       "Dam Base"
       <EXIT "NORTH" "DAM" "UP" "DAM" "LAUNC" "RIVR1">
       (<GET-OBJ "IBOAT"> <GET-OBJ "STICK">)
       <>
       <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "RIVR1"
"You are on the River Frigid in the vicinity of the Dam.  The river
flows quietly here.  There is a landing on the west shore."
       ,RIVERDESC
       <EXIT "UP" ,CURRENT "WEST" "DOCK" "LAND" "DOCK" "DOWN" "RIVR2"
	      "EAST" ,CLIFFS>
       ()
       <>
       <+ ,RWATERBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "RIVR2"
"The River turns a corner here making it impossible to see the
Dam.  The White Cliffs loom on the east bank and large rocks prevent
landing on the west."
       ,RIVERDESC
       <EXIT "UP" ,CURRENT "DOWN" "RIVR3" "EAST" ,CLIFFS> () <>
       <+ ,RWATERBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "RIVR3"
"The river descends here into a valley.  There is a narrow beach on
the east below the cliffs and there is some shore on the west which
may be suitable.  In the distance a faint rumbling can be heard."
       ,RIVERDESC
       <EXIT "UP" ,CURRENT "DOWN" "RIVR4" "EAST" "WCLF1" "WEST" "RCAVE"
	      "LAND" #NEXIT "You must specify which direction here.">
       () <> <+ ,RWATERBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "WCLF1"
"You are on a narrow strip of beach which runs along the base of the
White Cliffs. The only path here is a narrow one, heading south
along the Cliffs."
       "White Cliffs Beach"
       <EXIT "SOUTH" <CEXIT "DEFLATE" "WCLF2" ,NARROW> "LAUNC" "RIVR3">
       (<GET-OBJ "WCLIF">) CLIFF-FUNCTION <+ ,RLANDBIT ,RSACREDBIT ,RNWALLBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "WCLF2"

"You are on a rocky, narrow strip of beach beside the Cliffs.  A
narrow path leads north along the shore."
       "White Cliffs Beach"
       <EXIT "NORTH" <CEXIT "DEFLATE" "WCLF1" ,NARROW> "LAUNC" "RIVR4">
       (<GET-OBJ "WCLIF">) CLIFF-FUNCTION <+ ,RNWALLBIT ,RLANDBIT ,RSACREDBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "RIVR4"

"The river is running faster here and the sound ahead appears to be
that of rushing water.  On the west shore is a sandy beach.  A small
area of beach can also be seen below the Cliffs."
       ,RIVERDESC
       <EXIT "UP" ,CURRENT "DOWN" "RIVR5" "EAST" "WCLF2" "WEST" "BEACH"
	      "LAND" #NEXIT "Specify the direction to land.">
       (<GET-OBJ "BUOY">)
       RIVR4-ROOM
       <+ ,RWATERBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "RIVR5"
"The sound of rushing water is nearly unbearable here.  On the west
shore is a large landing area."
       ,RIVERDESC
       <EXIT "UP" ,CURRENT "DOWN" "FCHMP" "LAND" "FANTE">
       () <>
       <+ ,RWATERBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "FCHMP"
       ""
       "Moby lossage" <EXIT "NORTH" #NEXIT ""> () OVER-FALLS>

<ROOM "FANTE"
"You are on the shore of the River.  The river here seems somewhat
treacherous.  A path travels from north to south here, the south end
quickly turning around a sharp corner."
       "Shore"
       <EXIT "LAUNC" "RIVR5" "NORTH" "BEACH"
	      "SOUTH" "FALLS">
       ()
       <>
       <+ ,RNWALLBIT ,RLANDBIT ,RSACREDBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "BEACH"
"You are on a large sandy beach at the shore of the river, which is
flowing quickly by.  A path runs beside the river to the south here."
       "Sandy Beach"
       <EXIT "LAUNC" "RIVR4" "SOUTH" "FANTE">
       (<GET-OBJ "STATU"> <GET-OBJ "SAND">)
       <>
       <+ ,RNWALLBIT ,RLANDBIT ,RSACREDBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "RCAVE"
"You are on the west shore of the river.  An entrance to a cave is
to the northwest.  The shore is very rocky here."
       "Rocky Shore"
       <EXIT "LAUNC" "RIVR3" "NW" "TCAVE">
       () <> <+ ,RNWALLBIT ,RLANDBIT ,RSACREDBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "TCAVE"
"This is a small cave whose exits are on the south and northwest."
       "Small Cave"
       <EXIT "SOUTH" "RCAVE" "NW" "CHAS3">
       (<GET-OBJ "GUANO"> <GET-OBJ "SHOVE">)>

<ROOM "FALLS"
       ""
       "Aragain Falls"
       <EXIT "EAST" <CEXIT "RAINBOW" "RAINB"> 
	     "DOWN" #NEXIT "It's a long way..." "NORTH" "FANTE"
	       "UP" <CEXIT "RAINBOW" "RAINB">>
       (<GET-OBJ "RAINB"> <GET-OBJ "BARRE">)
       FALLS-ROOM
       <+ ,RNWALLBIT ,RLANDBIT ,RSACREDBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "RAINB"
"You are on top of a rainbow (I bet you never thought you would walk
on a rainbow), with a magnificent view of the Falls.  The rainbow
travels east-west here.  There is an NBC Commissary here."
       "Rainbow Room"
       <EXIT "EAST" "POG" "WEST" "FALLS">
       ()
       <>
       <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT ,RSACREDBIT>>

<SETG CRAIN <CEXIT "RAINBOW" "RAINB">>

<ROOM "POG"
"You are on a small, rocky beach on the continuation of the Frigid
River past the Falls.  The beach is narrow due to the presence of the
White Cliffs.  The river canyon opens here and sunlight shines in
from above. A rainbow crosses over the falls to the west and a narrow
path continues to the southeast."
       "End of Rainbow"
       <EXIT "UP" ,CRAIN "NW" ,CRAIN "WEST" ,CRAIN "SE" "CLBOT"
	     "LAUNC" #NEXIT "The sharp rocks endanger your boat.">
       (<GET-OBJ "RAINB"> <GET-OBJ "POT">)
       <>
       <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "CLBOT"
"You are beneath the walls of the river canyon which may be climbable
here.  There is a small stream here, which is the lesser part of the
runoff of Aragain Falls. To the north is a narrow path."
       "Canyon Bottom"
       <EXIT "UP" "CLMID" "NORTH" "POG">
       (<GET-OBJ "CCLIF">)
       <>
       <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT ,RSACREDBIT>
       (RGLOBAL ,RGWATER)>

<ROOM "CLMID"

"You are on a ledge about halfway up the wall of the river canyon.
You can see from here that the main flow from Aragain Falls twists
along a passage which it is impossible to enter.  Below you is the
canyon bottom.  Above you is more cliff, which still appears
climbable."
       "Rocky Ledge"
       <EXIT "UP" "CLTOP" "DOWN" "CLBOT">
       (<GET-OBJ "CCLIF">)
       <>
       <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT ,RSACREDBIT>>

<ROOM "CLTOP"

"You are at the top of the Great Canyon on its south wall.  From here
there is a marvelous view of the Canyon and parts of the Frigid River
upstream.  Across the canyon, the walls of the White Cliffs still
appear to loom far above.  Following the Canyon upstream (north and
northwest), Aragain Falls may be seen, complete with rainbow. 
Fortunately, my vision is better than average and I can discern the
top of the Flood Control Dam #3 far to the distant north.  To the
west and south can be seen an immense forest, stretching for miles
around.  It is possible to climb down into the canyon from here."
       "Canyon View"
       <EXIT "DOWN" "CLMID" "SOUTH" "FORE4" "WEST" "FORE5">
       (<GET-OBJ "CCLIF">)
       <>
       <+ ,RLANDBIT ,RLIGHTBIT ,RNWALLBIT ,RSACREDBIT>>

\

;"SUBTITLE VOLCANO AREA"

<ROOM "VLBOT"
"You are at the bottom of a large dormant volcano.  High above you
light may be seen entering from the cone of the volcano.  The only
exit here is to the north."
       "Volcano Bottom"
       <EXIT "NORTH" "LAVA">
       (<GET-OBJ "BALLO">)>

<ROOM "VAIR1"
"You are about one hundred feet above the bottom of the volcano.  The
top of the volcano is clearly visible here."
       "Volcano Core"
       ,NULEXIT
       ()
       <>
       <+ ,RAIRBIT ,RNWALLBIT ,RSACREDBIT>>

<ROOM "VAIR2"
"You are about two hundred feet above the volcano floor.  Looming
above is the rim of the volcano.  There is a small ledge on the west
side."
       "Volcano near small ledge"
       <EXIT "WEST" "LEDG2" "LAND" "LEDG2">
       ()
       <>
       <+ ,RAIRBIT ,RNWALLBIT ,RSACREDBIT>>

<ROOM "VAIR3"
"You are high above the floor of the volcano.  From here the rim of
the volcano looks very narrow and you are very near it.  To the 
east is what appears to be a viewing ledge, too thin to land on."
       "Volcano near viewing ledge"
       ,NULEXIT
       ()
       <>
       <+ ,RAIRBIT ,RNWALLBIT ,RSACREDBIT>>

<ROOM "VAIR4"
"You are near the rim of the volcano which is only about 15 feet
across.  To the west, there is a place to land on a wide ledge."
       "Volcano near wide ledge"
       <EXIT "LAND" "LEDG4" "EAST" "LEDG4">
       ()
       <>
       <+ ,RAIRBIT ,RNWALLBIT ,RSACREDBIT>>

<SETG CXGNOME <CEXIT "GNOME-DOOR" "VLBOT">>

<ROOM "LEDG2"
"You are on a narrow ledge overlooking the inside of an old dormant
volcano.  This ledge appears to be about in the middle between the
floor below and the rim above. There is an exit here to the south."
       "Narrow Ledge"
       <EXIT "DOWN" #NEXIT "I wouldn't jump from here."
	      "LAUNC" "VAIR2" "WEST" ,CXGNOME "SOUTH" "LIBRA">
       (<GET-OBJ "HOOK1"> <GET-OBJ "COIN">)>

<ROOM "LIBRA"
"This is a room which must have been a large library, probably
for the royal family.  All of the shelves appear to have been gnawed
to pieces by unfriendly gnomes.  To the north is an exit."
       "Library"
       <EXIT "NORTH" "LEDG2" "OUT" "LEDG2">
       (<GET-OBJ "BLBK"> <GET-OBJ "GRBK"> <GET-OBJ "PUBK">
	<GET-OBJ "WHBK">)>

<ROOM "LEDG3"
"You are on a ledge in the middle of a large volcano.  Below you
the volcano bottom can be seen and above is the rim of the volcano.
A couple of ledges can be seen on the other side of the volcano;
it appears that this ledge is intermediate in elevation between
those on the other side.  The exit from this room is to the east."
       "Volcano View"
       <EXIT "DOWN" #NEXIT "I wouldn't try that."
	      "CROSS" #NEXIT "It is impossible to cross this distance."
	      "EAST" "EGYPT">>

<ROOM "LEDG4"
       ""
       "Wide Ledge"
       <EXIT "DOWN" #NEXIT "It's a long way down."
	      "LAUNC" "VAIR4" "WEST" ,CXGNOME "SOUTH" "SAFE">
       (<GET-OBJ "HOOK2">)
       LEDGE-FUNCTION>

<ROOM "SAFE"
       ""
       "Dusty Room"
       <EXIT "NORTH" "LEDG4">
       (<GET-OBJ "SSLOT"> <GET-OBJ "SAFE">)
       SAFE-ROOM
       <+ ,RLANDBIT ,RLIGHTBIT>>

<ROOM "LAVA"
"This is a small room, whose walls are formed by an old lava flow.
There are exits here to the west and the south."
       "Lava Room"
       <EXIT "SOUTH" "VLBOT" "WEST" "RUBYR">>

<SETG BLOC <GET-ROOM "VLBOT">>

\

; "SUBTITLE ALICE IN WONDERLAND"

<SETG BUCKET-TOP!-FLAG <>>

<SETG MAGCMACH <CEXIT "FROBOZZ" "CMACH" "" <> MAGNET-ROOM-EXIT>>

<SETG MAGALICE <CEXIT "FROBOZZ" "ALICE" "" <> MAGNET-ROOM-EXIT>>

<ROOM "MAGNE"
       ""
       "Low Room"
       <EXIT "NORTH" ,MAGCMACH "SOUTH" ,MAGCMACH "WEST" ,MAGCMACH "NE" ,MAGCMACH
	      "NW" ,MAGALICE "SW" ,MAGALICE "SE" ,MAGALICE "EAST" ,MAGCMACH
	      "OUT" ,MAGALICE>
       (<GET-OBJ "RBTLB"> <GET-OBJ "ROBOT">)
       MAGNET-ROOM>

<ROOM "CMACH"
       ""
       "Machine Room"
       <EXIT "WEST" "MAGNE" "SOUTH" "CAGER">
       (<GET-OBJ "SQBUT"> <GET-OBJ "RNBUT"> <GET-OBJ "TRBUT">)
       CMACH-ROOM>

<ROOM "CAGER"
"This is a dingy closet adjacent to the machine room.  On one wall
is a small sticker which says
		Protected by
		  FROBOZZ
	     Magic Alarm Company
	      (Hello, footpad!)
"
       "Dingy Closet"
       <EXIT "NORTH" "CMACH">
       (<GET-OBJ "SPHER">)
       <>
       <+ ,RLIGHTBIT ,RLANDBIT>>

<ROOM "CAGED"
"You are trapped inside a steel cage."
       "Cage"
       <EXIT "NORTH" #NEXIT "">
       (<GET-OBJ "CAGE">) CAGED-ROOM <+ ,RLANDBIT ,RNWALLBIT>>

<ROOM "TWELL"

"You are at the top of the well.  Well done.  There are etchings on
the side of the well. There is a small crack across the floor at the
entrance to a room on the east, but it can be crossed easily."
       "Top of Well"
       <EXIT "EAST" "ALICE" "DOWN" #NEXIT "It's a long way down!">
       (<GET-OBJ "ETCH2">)
       <>
       <+ ,RLANDBIT ,RBUCKBIT>
       (RVAL 10
	RGLOBAL ,WELLBIT)>

<ROOM "BWELL"
       
"This is a damp circular room, whose walls are made of brick and
mortar.  The roof of this room is not visible, but there appear to be
some etchings on the walls.  There is a passageway to the west."
       "Circular Room"
       <EXIT "WEST" "MPEAR" "UP" #NEXIT "The walls cannot be climbed.">
       (<GET-OBJ "BUCKE"> <GET-OBJ "ETCH1">)
       <>
       <+ ,RLANDBIT ,RBUCKBIT>
       (RGLOBAL ,WELLBIT)>

<ROOM "ALICE"

"This is a small square room, in the center of which is a large
oblong table, no doubt set for afternoon tea.  It is clear from the
objects on the table that the users were indeed mad.  In the eastern
corner of the room is a small hole (no more than four inches high). 
There are passageways leading away to the west and the northwest."
       "Tea Room"
       <EXIT "EAST" #NEXIT "Only a mouse could get in there."
	      "WEST" "TWELL" "NW" "MAGNE">
       (<GET-OBJ "ATABL"> <GET-OBJ "ECAKE"> <GET-OBJ "ORICE">
	<GET-OBJ "RDICE"> <GET-OBJ "BLICE">)>

<PSETG SMDROP #NEXIT "There is a chasm too large to jump across.">

<ROOM "ALISM"

"This is an enormous room, in the center of which are four wooden
posts delineating a rectangular area, above which is what appears to
be a wooden roof.  In fact, all objects in this room appear to be
abnormally large. To the east is a passageway.  There is a large
chasm on the west and the northwest."
       "Posts Room"
       <EXIT "NW" ,SMDROP "EAST" "ALITR" "WEST" ,SMDROP "DOWN" ,SMDROP>
       (<GET-OBJ "POSTS">)>

<ROOM "ALITR"

"This is a large room, one half of which is depressed.  There is a
large leak in the ceiling through which brown colored goop is
falling.  The only exit to this room is to the west."
       "Pool Room"
       <EXIT "EXIT" "ALISM" "WEST" "ALISM">
       (<GET-OBJ "FLASK"> <GET-OBJ "POOL"> <GET-OBJ "PLEAK"> <GET-OBJ "SAFFR">)>

\

; "SUBTITLE BANK OF ZORK"

<ROOM "BKENT"
      
"This is the large entrance hall of the Bank of Zork, the largest
banking institution of the Great Underground Empire. A partial
account of its history is in 'The Lives of the Twelve Flatheads' with
the chapter on J. Pierpont Flathead.  A more detailed history (albeit
less objective) may be found in Flathead's outrageous autobiography
'I'm Rich and You Aren't - So There!'.
Most of the furniture has been ravaged by passing scavengers.  All
that remains are two signs at the Northwest and Northeast corners of
the room, which say
  
      <--  WEST VIEWING ROOM        EAST VIEWING ROOM  -->  
"
      "Bank Entrance"
      <EXIT "NW" "BKTW" "NE" "BKTE" "SOUTH" "GALLE">>

<ROOM "BKTW"
      ""
      "West Teller's Room"
      <EXIT "NORTH" "BKVW" "SOUTH" "BKENT" "WEST" "BKBOX">
      ()
      TELLER-ROOM>

<ROOM "BKTE"
      ""
      "East Teller's Room"
      <EXIT "NORTH" "BKVE" "SOUTH" "BKENT" "EAST" "BKBOX">
      ()
      TELLER-ROOM>

<SETG VIEW-ROOM
      
"This is a room used by holders of safety deposit boxes to view
their contents.  On the north side of the room is a sign which says 
	
   REMAIN HERE WHILE THE BANK OFFICER RETRIEVES YOUR DEPOSIT BOX
    WHEN YOU ARE FINISHED, LEAVE THE BOX, AND EXIT TO THE SOUTH  
     AN ADVANCED PROTECTIVE DEVICE PREVENTS ALL CUSTOMERS FROM
      REMOVING ANY SAFETY DEPOSIT BOX FROM THIS VIEWING AREA!
               Thank You for banking at the Zork!
">

<SETG SCOLEXIT <CEXIT "FROBOZZ" "BKENT" "" <> SCOLGO>>

<SETG SCOL-ACTIVE <FIND-ROOM "FCHMP">>

<ROOM "BKVW"
      ,VIEW-ROOM
      "Viewing Room"
      <EXIT "SOUTH" "BKENT">
      ()
      <>
      ,RLANDBIT
      (RGLOBAL <+ ,WALL-ESWBIT ,WALL-NBIT>)>

<ROOM "BKVE"
      ,VIEW-ROOM
      "Viewing Room"
      <EXIT "SOUTH" "BKENT">
      ()
      <>
      ,RLANDBIT
      (RGLOBAL <+ ,WALL-ESWBIT ,WALL-NBIT>)>

<ROOM "BKTWI"
      
"This is a small, bare room with no distinguishing features. There
are no exits from this room."
      "Small Room"
      ,NULEXIT
      ()
      <>
      <+ ,RLANDBIT ,RSACREDBIT>
      (RGLOBAL <+ ,WALL-ESWBIT ,WALL-NBIT>)>

<ROOM "BKVAU"
      "This is the Vault of the Bank of Zork, in which there are no doors."
      "Vault"
      ,NULEXIT
      (<GET-OBJ "BILLS">)
      <>
      <+ ,RSACREDBIT ,RLANDBIT>
      (RGLOBAL <+ ,WALL-ESWBIT ,WALL-NBIT>)>

<SETG BKALARM 
"An alarm rings briefly and an invisible force prevents your leaving.">

<ROOM "BKBOX"
"This is a large rectangular room.  The east and west walls here
were used for storing safety deposit boxes.  As might be expected,
all have been carefully removed by evil persons.  To the east, west,
and south of the room are large doorways. The northern 'wall'
of the room is a shimmering curtain of light.  In the center of the
room is a large stone cube, about 10 feet on a side.  Engraved on 
the side of the cube is some lettering."
      "Safety Depository"
      <EXIT "NORTH"
	    #NEXIT #NEXIT "There is a curtain of light there."
	    "WEST"
	    <CEXIT "FROBOZZ" "BKTW" ,BKALARM <> BKLEAVEW>
	    "EAST"
	    <CEXIT "FROBOZZ" "BKTE" ,BKALARM <> BKLEAVEE>
	    "SOUTH"
	    "BKEXE">
      (<GET-OBJ "VAULT"> <GET-OBJ "SCOL">)
      BKBOX-ROOM
      <+ ,RLANDBIT ,RLIGHTBIT>
      (RGLOBAL ,WALL-NBIT)>

<ROOM "BKEXE"
"This room was the office of the Chairman of the Bank of Zork.
Like the other rooms here, it has been extensively vandalized.
The lone exit is to the north."
      "Chairman's Office"
      <EXIT "NORTH" "BKBOX">
      (<GET-OBJ "PORTR">)>

<SETG SCOL-ROOMS
      [<FIND-DIR "EAST">
       <GET-ROOM "BKVE">
       <FIND-DIR "WEST">
       <GET-ROOM "BKVW">
       <FIND-DIR "NORTH">
       <GET-ROOM "BKTWI">
       <FIND-DIR "SOUTH">
       <GET-ROOM "BKVAU">]>

<SETG SCOL-WALLS
      [<GET-ROOM "BKVW">
       <GET-OBJ "WEAST">
       <GET-ROOM "BKVE">
       <GET-ROOM "BKVE">
       <GET-OBJ "WWEST">
       <GET-ROOM "BKVW">
       <GET-ROOM "BKTWI">
       <GET-OBJ "WSOUT">
       <GET-ROOM "BKVAU">
       <GET-ROOM "BKVAU">
       <GET-OBJ "WNORT">
       <GET-ROOM "BKTWI">]>

<SETG SCOL-ROOM <GET-ROOM "BKVW">>

\

;"SUBTITLE CHINESE PUZZLE ROOMS"

<SETG CPHERE 10>

<SETG CPOBJS <IUVECTOR 64 ()>>

<PUT ,CPOBJS 37 (<GET-OBJ "GCARD">)>

<PUT ,CPOBJS 52 (<GET-OBJ "CPSLT"> <GET-OBJ "CPDOR">)>

<SETG CPUVEC
      <UVECTOR 1
	       1
	       1
	       1
	       1
	       1
	       1
	       1
	       1
	       0
	       -1
	       0
	       0
	       -1
	       0
	       1
	       1
	       -1
	       0
	       1
	       0
	       -2
	       0
	       1
	       1
	       0
	       0
	       0
	       0
	       1
	       0
	       1
	       1
	       -3
	       0
	       0
	       -1
	       -1
	       0
	       1
	       1
	       0
	       0
	       -1
	       0
	       0
	       0
	       1
	       1
	       1
	       1
	       0
	       0
	       0
	       1
	       1
	       1
	       1
	       1
	       1
	       1
	       1
	       1
	       1>>

;" 0 is no wall
    1 is fixed wall
   -1 is movable wall (-2 is good ladder, -3 bad ladder)"

<SETG CPWALLS
      [<GET-OBJ "CPSWL">
       8
       <GET-OBJ "CPNWL">
       -8
       <GET-OBJ "CPEWL">
       1
       <GET-OBJ "CPWWL">
       -1]>

<SETG CPEXITS
      [<FIND-DIR "NORTH">
       -8
       <FIND-DIR "SOUTH">
       8
       <FIND-DIR "EAST">
       1
       <FIND-DIR "WEST">
       -1
       <FIND-DIR "NE">
       -7
       <FIND-DIR "NW">
       -9
       <FIND-DIR "SE">
       9
       <FIND-DIR "SW">
       7]>

<ROOM "CPANT"
      
"This is a small square room, in the middle of which is a recently 
created hole through which you can barely discern the floor some ten
feet below.  It doesn't seem likely you could climb back up.  There
are exits to the west and south."
      "Small Square Room"
      <EXIT "SOUTH" "CPOUT" "WEST" "TREAS"
	    "DOWN" <CEXIT "FROBOZZ" "FCHMP" "" <> CPENTER>>
      (<GET-OBJ "WARNI">)
      <>
      <+ ,RLANDBIT ,RLIGHTBIT>>

<ROOM "CPOUT"
      ""
      "Side Room"
      <EXIT "NORTH" "CPANT" "EAST" <CEXIT "CPOUT" "CP" "The steel door bars the way.">>
      (<GET-OBJ "CPDR2">)
      CPOUT-ROOM>

<ROOM "CP"
      ""
      "Room in a Puzzle"
      <EXIT "NORTH"
	    <CEXIT "FROBOZZ" "FCHMP" "" <> CPEXIT>
	    "SOUTH"
	    <CEXIT "FROBOZZ" "FCHMP" "" <> CPEXIT>
	    "EAST"
	    <CEXIT "FROBOZZ" "FCHMP" "" <> CPEXIT>
	    "WEST"
	    <CEXIT "FROBOZZ" "FCHMP" "" <> CPEXIT>
	    "NE"
	    <CEXIT "FROBOZZ" "FCHMP" "" <> CPEXIT>
	    "NW"
	    <CEXIT "FROBOZZ" "FCHMP" "" <> CPEXIT>
	    "SE"
	    <CEXIT "FROBOZZ" "FCHMP" "" <> CPEXIT>
	    "UP"
	    <CEXIT "FROBOZZ" "FCHMP" "" <> CPEXIT>
	    "SW"
	    <CEXIT "FROBOZZ" "FCHMP" "" <> CPEXIT>>
      ()
      CP-ROOM
      <+ ,RLANDBIT ,RLIGHTBIT>
      (RGLOBAL <+ ,CPLADDER ,CPWALL>)>

\
; "SUBTITLE PALANTIR ROOMS"

<SETG PALANDOOR <DOOR "PDOOR" "PALAN" "PRM">>
<SETG PALANWIND <DOOR "PWIND" "PALAN" "PRM">>

<ROOM "PALAN"
      ""
      "Dreary Room"
      <EXIT "SOUTH" ,PALANDOOR "EXIT" ,PALANDOOR "#!#!#" ,PALANWIND>
      (<GET-OBJ "PDOOR">
       <GET-OBJ "PWIND">
       <GET-OBJ "PLID2">
       <GET-OBJ "PKH2">
       <GET-OBJ "PALAN">
       <GET-OBJ "PTABL">
       <GET-OBJ "PCRAK">)
      PALANTIR-ROOM
      <+ ,RLANDBIT ,RLIGHTBIT ,RSACREDBIT>>

<ROOM "PRM"
      ""
      "Tiny Room"
      <EXIT "NORTH" ,PALANDOOR "ENTER" ,PALANDOOR "#!#!#" ,PALANWIND
	    "EAST" "MTORC">
      (<GET-OBJ "PDOOR"> <GET-OBJ "PWIND"> <GET-OBJ "PLID1"> <GET-OBJ "PKH1">)
      PRM-ROOM>

<ROOM "SLIDE" 
      ""
      "Slide Room"
      <EXIT "EAST" "PASS3" "NORTH" "ENTRA"
	    "DOWN" <CEXIT "FROBOZZ" "CAVE4" "" <> SLIDE-EXIT>>
      ()
      SLIDE-ROOM
      ,RLANDBIT
      (RGLOBAL ,SLIDEBIT)>

<ROOM "SLID1"
"This is an uncomfortable spot within the coal chute.  The rope to
which you are clinging can be seen rising into the darkness above.
There is more rope dangling below you."
      "Slide"
      <EXIT "DOWN" "SLID2" "UP" "SLIDE">
      ()
      INSLIDE
      <+ ,RLANDBIT ,RSACREDBIT>
      (RGLOBAL <+ ,ROPEBIT ,SLIDEBIT>)>

<ROOM "SLID2"
"This is another spot within the coal chute.  Above you the rope
climbs into darkness and the end of the rope is dangling five feet
beneath you."
      "Slide"
      <EXIT "DOWN" "SLID3" "UP" "SLID1">
      ()
      INSLIDE
      <+ ,RLANDBIT ,RSACREDBIT>
      (RGLOBAL <+ ,ROPEBIT ,SLIDEBIT>)>

<ROOM "SLID3"
"You have reached the end of your rope.  Below you is darkness as
the chute makes a sharp turn.  On the east here is a small ledge
which you might be able to stand on."
      "Slide"
      <EXIT "DOWN" "CELLA" "UP" "SLID2" "EAST" "SLEDG">
      ()
      INSLIDE
      <+ ,RLANDBIT ,RSACREDBIT>
      (RGLOBAL <+ ,ROPEBIT ,SLIDEBIT>)>

<ROOM "SLEDG" 

"This is a narrow ledge abutting the coal chute, in which a rope can
be seen passing downward.  Behind you, to the south, is a small room."
      "Slide Ledge"
      <EXIT "DOWN" "CELLA" "UP" "SLID2" "SOUTH" "SPAL">
      ()
      SLEDG-ROOM
      <+ ,RLANDBIT ,RSACREDBIT>
      (RGLOBAL <+ ,ROPEBIT ,SLIDEBIT>)>

<ROOM "SPAL"

"This is a small room with rough walls, and a ceiling which is steeply
sloping from north to south. There is coal dust covering almost
everything, and little bits of coal are scattered around the only exit
(which is a narrow passage to the north). In one corner of the room is
an old coal stove which lights the room with a cheery red glow.  There
is a very narrow crack in the north wall."
      "Sooty Room"
      <EXIT "NORTH" "SLEDG">
      (<GET-OBJ "PAL3"> <GET-OBJ "STOVE">)
      <>
      <+ ,RLANDBIT ,RSACREDBIT ,RLIGHTBIT>>

\
; "SUBTITLE END GAME"

<SETG MR-D <CEXIT "FROBOZZ" "MRD" "" <> MRGO>>
<SETG MR-G <CEXIT "FROBOZZ" "MRG" "" <> MRGO>>
<SETG MR-C <CEXIT "FROBOZZ" "MRC" "" <> MRGO>>
<SETG MR-B <CEXIT "FROBOZZ" "MRB" "" <> MRGO>>
<SETG MR-A <CEXIT "FROBOZZ" "MRA" "" <> MRGO>>
<SETG MOUT <CEXIT "FROBOZZ" "MRA" "" <> MIROUT>>
<SETG MIREX <CEXIT "MIRROR-OPEN" "INMIR" "" <> MIRIN>>

<ROOM "MRD"
       "" "Hallway"
       <EXIT "NORTH" "FDOOR" "NE" "FDOOR" "NW" "FDOOR"
	      "SOUTH" ,MR-G "SE" ,MR-G "SW" ,MR-G>
       ()
       MRDF
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL <+ ,ROSEBIT ,CHANBIT ,GUARDBIT>)> 

<ROOM "MRG"
       "" "Hallway"
       <EXIT "NORTH" ,MR-D "SOUTH" ,MR-C>
       ()
       GUARDIANS
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL ,GUARDBIT)>

<ROOM "MRC"
       "" "Hallway"
       <EXIT "NORTH" ,MR-G "NW" ,MR-G "NE" ,MR-G
	      "ENTER" ,MIREX "SOUTH" ,MR-B "SW" ,MR-B "SE" ,MR-B>
       ()
       MRCF
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL <+ ,MIRRORBIT ,PANELBIT ,ROSEBIT ,CHANBIT ,GUARDBIT>)>

<ROOM "MRB"
       "" "Hallway"
       <EXIT "NORTH" ,MR-C "NW" ,MR-C "NE" ,MR-C
	      "ENTER" ,MIREX "SOUTH" ,MR-A "SW" ,MR-A "SE" ,MR-A>
       ()
       MRBF
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL <+ ,MIRRORBIT ,PANELBIT ,ROSEBIT ,CHANBIT>)>

<ROOM "MRA"
       "" "Hallway"
       <EXIT "NORTH" ,MR-B "NW" ,MR-B "NE" ,MR-B
	      "ENTER" ,MIREX "SOUTH" "MREYE">
       ()
       MRAF
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL <+ ,MIRRORBIT ,PANELBIT ,ROSEBIT ,CHANBIT>)>

<ROOM "MRDE"
       "" "Narrow Room"
       ,NULEXIT
       ()
       GUARDIANS
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL <+ ,MIRRORBIT ,PANELBIT ,GUARDBIT>)>

<ROOM "MRDW"
       "" "Narrow Room"
       ,NULEXIT
       ()
       GUARDIANS
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL <+ ,MIRRORBIT ,PANELBIT ,GUARDBIT>)>

<ROOM "MRGE"
       "" "Narrow Room"
       ,NULEXIT
       ()
       GUARDIANS
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL <+ ,MIRRORBIT ,PANELBIT ,GUARDBIT>)>

<ROOM "MRGW"
       "" "Narrow Room"
       ,NULEXIT
       ()
       GUARDIANS
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL <+ ,MIRRORBIT ,PANELBIT ,GUARDBIT>)>

<ROOM "MRCE"
       "" "Narrow Room"
       <EXIT "ENTER" ,MIREX "WEST" ,MIREX "NORTH" "MRG" "SOUTH" "MRB">
       ()
       MRCEW
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL <+ ,MIRRORBIT ,PANELBIT ,GUARDBIT>)>

<ROOM "MRCW"
       "" "Narrow Room"
       <EXIT "ENTER" ,MIREX "EAST" ,MIREX "NORTH" "MRG" "SOUTH" "MRB">
       ()
       MRCEW
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL <+ ,MIRRORBIT ,PANELBIT ,GUARDBIT>)>

<ROOM "MRBE"
       "" "Narrow Room"
       <EXIT "ENTER" ,MIREX "WEST" ,MIREX "NORTH" "MRC" "SOUTH" "MRA">
       ()
       MRBEW
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL <+ ,MIRRORBIT ,PANELBIT>)>

<ROOM "MRBW"
       "" "Narrow Room"
       <EXIT "ENTER" ,MIREX "EAST" ,MIREX "NORTH" "MRC" "SOUTH" "MRA">
       ()
       MRBEW
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL <+ ,MIRRORBIT ,PANELBIT>)>

<ROOM "MRAE"
       "" "Narrow Room"
       <EXIT "ENTER" ,MIREX "WEST" ,MIREX "NORTH" "MRB" "SOUTH" "MREYE">
       ()
       MRAEW
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL <+ ,MIRRORBIT ,PANELBIT>)>

<ROOM "MRAW"
       "" "Narrow Room"
       <EXIT "ENTER" ,MIREX "EAST" ,MIREX "NORTH" "MRB" "SOUTH" "MREYE">
       ()
       MRAEW
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL <+ ,MIRRORBIT ,PANELBIT>)>

<ROOM "INMIR"
       "" "Inside Mirror"
       <EXIT "NORTH" ,MOUT "SOUTH" ,MOUT "EAST" ,MOUT "WEST" ,MOUT
	      "NE" ,MOUT "NW" ,MOUT "SE" ,MOUT "SW" ,MOUT "EXIT" ,MOUT>
       (<GET-OBJ "YLWAL"> <GET-OBJ "WHWAL">
	<GET-OBJ "RDWAL"> <GET-OBJ "BLWAL">
	<GET-OBJ "OAKND"> <GET-OBJ "PINND">
	<GET-OBJ "WDBAR"> <GET-OBJ "LPOLE">
	<GET-OBJ "SPOLE"> <GET-OBJ "TBAR">
	<GET-OBJ "ARROW">)
       MAGIC-MIRROR
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RVAL 15
	RGLOBAL <+ ,ROSEBIT ,CHANBIT ,GUARDBIT>)>

<ROOM "MRANT"

"You are standing near one end of a long, dimly lit hall.  At the
south stone stairs ascend.  To the north the corridor is illuminated
by torches set high in the walls, out of reach.  On one wall is a red
button."
       "Stone Room"
       <EXIT "SOUTH" "TSTRS" "UP" "TSTRS" "NORTH" "MREYE">
       (<GET-OBJ "RSWIT">)
       <> <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>>

<ROOM "MREYE"
       ""
       "Small Room"
       <EXIT "NORTH" ,MR-A "NW" ,MR-A "NE" ,MR-A "SOUTH" "MRANT">
       (<GET-OBJ "RBEAM">)
       MREYE-ROOM
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>>

<SETG CD <DOOR "TOMB" "TOMB" "CRYPT" <> <>>>

<ROOM "TOMB"
       ""
       "Tomb of the Unknown Implementer"
	<EXIT "WEST" "LLD2" "NORTH" ,CD "ENTER" ,CD>
	(<GET-OBJ "TOMB">
	 <GET-OBJ "HEADS">
	 <GET-OBJ "COKES">
	 <GET-OBJ "LISTS">)
	TOMB-FUNCTION>

<ROOM "CRYPT"
       ""
       "Crypt"
       <EXIT "SOUTH" ,CD "LEAVE" ,CD>
       (<GET-OBJ "TOMB">)
       CRYPT-FUNCTION
       <+ ,RENDGAME ,RLANDBIT>
       (RVAL 5)>

<ROOM "TSTRS"
"You are standing at the top of a flight of stairs that lead down to
a passage below.  Dim light, as from torches, can be seen in the
passage.  Behind you the stairs lead into untouched rock."
       "Top of Stairs"
       <EXIT "NORTH" "MRANT"
	      "DOWN" "MRANT"
	      "SOUTH" #NEXIT "The wall is solid rock.">
       ()
       <>
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RVAL 10)>

<ROOM "ECORR"
"This is a corridor with polished marble walls.  The corridor
widens into larger areas as it turns west at its northern and
southern ends."
      "East Corridor"
      <EXIT "NORTH" "NCORR" "SOUTH" "SCORR">
      () <> <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>>

<ROOM "WCORR"
"This is a corridor with polished marble walls.  The corridor
widens into larger areas as it turns east at its northern and
southern ends."
      "West Corridor"
      <EXIT "NORTH" "NCORR" "SOUTH" "SCORR">
      () <> <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>>

<SETG OD <DOOR "ODOOR" "SCORR" "CELL" "" MAYBE-DOOR>> ; "south cell door"
<SETG WD <DOOR "QDOOR" "BDOOR" "FDOOR">> ; "wooden door, entrance to cell area"
<SETG CD <DOOR "CDOOR" "NCORR" "CELL">> ; "cell door"
<SETG ND <DOOR "ODOOR" "NCELL" "NIRVA">> ; "winnage door"

<ROOM "SCORR"
       ""
       "South Corridor"
       <EXIT "WEST" "WCORR"
	      "EAST" "ECORR"
	      "NORTH" ,OD
	      "SOUTH" "BDOOR">
       (<GET-OBJ "ODOOR">)
       SCORR-ROOM <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>>

<ROOM "BDOOR"
       ""
       "Narrow Corridor"
       <EXIT "NORTH" "SCORR" "SOUTH" ,WD>
       (<GET-OBJ "MASTE">
	<GET-OBJ "QDOOR">)
       BDOOR-FUNCTION
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RVAL 20)>

<ROOM "FDOOR"
       ""
       "Dungeon Entrance"
       <EXIT "NORTH" ,WD "ENTER" ,WD "SOUTH" ,MR-D "SE" ,MR-D "SW" ,MR-D>
       (<GET-OBJ "QDOOR">)
       FDOOR-FUNCTION
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RVAL 15 RGLOBAL ,MASTERBIT)>

<ROOM "NCORR"
       ""
       "North Corridor"
       <EXIT "EAST" "ECORR" "WEST" "WCORR" "NORTH" "PARAP"
	      "SOUTH" ,CD "ENTER" ,CD>
       (<GET-OBJ "CDOOR">)
       NCORR-ROOM
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL ,MASTERBIT)>

<ROOM "PARAP"
       ""
       "Parapet"
       <EXIT "SOUTH" "NCORR"
	      "NORTH" #NEXIT "You would be burned to a crisp in no time.">
       (<GET-OBJ "DBUTT"> <GET-OBJ "DIAL">
	<GET-OBJ "ONE"> <GET-OBJ "TWO">
	<GET-OBJ "THREE"> <GET-OBJ "FOUR">
	<GET-OBJ "FIVE"> <GET-OBJ "SIX">
	<GET-OBJ "SEVEN"> <GET-OBJ "EIGHT">)
       PARAPET
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL ,MASTERBIT)>

<SETG NUMOBJS
     [<GET-OBJ "ONE"> 1 <GET-OBJ "TWO"> 2
      <GET-OBJ "THREE"> 3 <GET-OBJ "FOUR"> 4
      <GET-OBJ "FIVE"> 5 <GET-OBJ "SIX"> 6
      <GET-OBJ "SEVEN"> 7 <GET-OBJ "EIGHT"> 8]>

<ROOM "CELL" 
       ""
       "Prison Cell"
       <EXIT "EXIT" ,CD
	      "NORTH" ,CD
	      "SOUTH" ,OD>
       (<GET-OBJ "CDOOR"> <GET-OBJ "ODOOR">)
       CELL-ROOM
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL ,MASTERBIT)>

<SETG FOUT #NEXIT "The door is securely fastened.">

<ROOM "PCELL"
       ""
       "Prison Cell"
       <EXIT "EXIT" ,FOUT>
       (<GET-OBJ "LDOOR">)
       PCELL-ROOM
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL ,MASTERBIT)>

<ROOM "NCELL"
       ""
       "Prison Cell"
       <EXIT "SOUTH" ,FOUT "EXIT" ,ND "NORTH" ,ND>
       (<GET-OBJ "ODOOR"> <GET-OBJ "MDOOR">)
       NCELL-ROOM
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RGLOBAL ,MASTERBIT)>

<ROOM "NIRVA"

"     This is a room of large size, richly appointed and decorated
in a style that bespeaks exquisite taste.  To judge from its
contents, it is the ultimate storehouse of the treasures of Zork.
     There are chests here containing precious jewels, mountains of
zorkmids, rare paintings, ancient statuary, and beguiling curios.
     In one corner of the room is a bookcase boasting such volumes as
'The History of the Great Underground Empire,' 'The Lives of the
Twelve Flatheads,' 'The Wisdom of the Implementors,' and other
informative and inspiring works.
     On one wall is a completely annotated map of the Great Underground
Empire, showing points of interest, various troves of treasure, and
indicating the locations of several superior scenic views.
     On a desk at the far end of the room may be found stock
certificates representing a controlling interest in FrobozzCo
International, the multinational conglomerate and parent company of
the Frobozz Magic Boat Co., etc."
       "Treasury of Zork"
       ,NULEXIT
       (<GET-OBJ "ODOOR">)
       NIRVANA
       <+ ,RENDGAME ,RLANDBIT ,RLIGHTBIT>
       (RVAL 35)>

\

; "SUBTITLE END GAME GOODIES"

<SETG CELLS <IUVECTOR 8 '()>>		;"contents of cells"

<SETG COBJS (<GET-OBJ "CDOOR"> <GET-OBJ "ODOOR">)>

<SETG NOBJS (<GET-OBJ "MDOOR"> <GET-OBJ "ODOOR">)>

<SETG POBJS (<GET-OBJ "LDOOR">)>

<SETG NORTHEND <GET-ROOM "MRD">>	;"northern limit of mirror"

<SETG STARTROOM <SETG MLOC <GET-ROOM "MRB">>> ;"where mirror begins"

<SETG SOUTHEND <GET-ROOM "MRA">>	;"southern limit of mirror"

\

; "SUBTITLE VOCABULARY"

;"buzz words and preposition"

<ADD-BUZZ "AND" "BY" "IS" "A" "THE" "AN" "TODAY" "HOW" "CHIMN">

<ADD-ZORK PREP "OVER" "WITH" "AT" "TO" "IN" "FOR" "DOWN" "UP" "UNDER" "OF" "FROM">
<SYNONYM "WITH" "USING" "THROU">
<SYNONYM "IN" "INSID" "INTO">

L;"funny verbs"

<SADD-ACTION "C-INT" TIME>	;"funny verb for clock ints"

<SADD-ACTION "DEAD!" TIME>	;"funny verb for killing villains"

<SADD-ACTION "1ST?" TIME>	;"funny verb for surprise by villains"

<SADD-ACTION "FGHT?" TIME>	;"funny verb for deciding whether to fight"

<SADD-ACTION "HACK?" TIME>	;"funny verb for villain fight decisions"

<SADD-ACTION "IN!" TIME>	;"villain regains consciousness"

<SADD-ACTION "OUT!" TIME>	;"villain loses consciousness"

<SADD-ACTION "GO-IN" TIME>	;"funny verb for room actions when entering"

;"ZORK game commands"

<SADD-ACTION "BRIEF" BRIEF>

<SADD-ACTION "BUG" BUGGER>
<VSYNONYM "BUG" "GRITC" "COMPL">

<SADD-ACTION "FEATU" FEECH>
<VSYNONYM "FEATU" "COMME" "SUGGE" "IDEA">

<SADD-ACTION "HELP" HELP>

<SADD-ACTION "INFO" INFO>

<SADD-ACTION "NOOBJ" NO-OBJ-HACK>

<SADD-ACTION "QUIT" FINISH>
<VSYNONYM "QUIT" "Q" "GOODB">

<SADD-ACTION "RESTA" RESTART>

<SADD-ACTION "RESTO" DO-RESTORE>

<SADD-ACTION "RNAME" ROOM-NAME>

<SADD-ACTION "SAVE" DO-SAVE>

<SADD-ACTION "SCORE" SCORE>

<SADD-ACTION "SCRIP" DO-SCRIPT>

<SADD-ACTION "SUPER" SUPER-BRIEF>

<SADD-ACTION "TIME" PLAY-TIME>

<SADD-ACTION "UNSCR" DO-UNSCRIPT>

<SADD-ACTION "VERSI" VERSION>

<SADD-ACTION "VERBO" VERBOSE>



;"real verbs"

<SADD-ACTION "ANSWE" ANSWER>
<VSYNONYM "ANSWE" "RESPO">

<ADD-ACTION "ATTAC"
	    "Attack"
	    [(,VILLAIN ROBJS REACH) "WITH" (,WEAPONBIT AOBJS HAVE)
	     ["ATTAC" ATTACKER]]>
<VSYNONYM "ATTAC" "FIGHT" "HURT" "INJUR" "HIT">

<SADD-ACTION "BACK" BACKER>

<SADD-ACTION "BLAST" BLAST>

<ADD-ACTION "BOARD"
	    "Board"
	    [(,VEHBIT ROBJS REACH) ["BOARD" BOARD]]>

<ADD-ACTION "BRUSH"
	    "Brush"
	    [(-1 AOBJS ROBJS REACH) ["BRUSH" BRUSH] DRIVER]
	    [(-1 AOBJS ROBJS REACH) "WITH" OBJ ["BRUSH" BRUSH]]>
<VSYNONYM "BRUSH" "CLEAN">

<ADD-ACTION "BURN"
	    "Burn"
	    [(,BURNBIT AOBJS ROBJS REACH) "WITH" (,FLAMEBIT AOBJS ROBJS HAVE)
			["BURN" BURNER]]>
<VSYNONYM "BURN" "INCIN" "IGNIT">

<SADD-ACTION "CHOMP" CHOMP>
<VSYNONYM "CHOMP" "LOSE" "BARF">

<ADD-ACTION "CLIMB"
	    "Climb"
	    ["UP" (,CLIMBBIT ROBJS) ["CLUP" CLIMB-UP]]
	    ["DOWN" (,CLIMBBIT ROBJS) ["CLDN" CLIMB-DOWN]]
	    [(,CLIMBBIT ROBJS) ["CLUDG" CLIMB-FOO]]>

<ADD-ACTION "CLOSE"
	    "Close"
	    [(<+ ,DOORBIT ,CONTBIT> REACH AOBJS ROBJS) ["CLOSE" CLOSER]]>
<VSYNONYM "CLOSE">

<1ADD-ACTION "COUNT" "Count" COUNT>
<VSYNONYM "COUNT" "MANY">

<SADD-ACTION "CURSE" CURSES>
<VSYNONYM "CURSE" "SHIT" "FUCK" "DAMN">

<1ADD-ACTION "DEFLA" "Deflate" DEFLATER>

<SADD-ACTION "DIAGN" DIAGNOSE>

<ADD-ACTION "DIG"
	    "Dig"
	    [(,DIGBIT ROBJS) "WITH" (,TOOLBIT AOBJS HAVE) ["DIG" DIGGER] DRIVER]
	    ["INTO" (,DIGBIT ROBJS) "WITH" (,TOOLBIT AOBJS HAVE) ["DIG" DIGGER]]>

<ADD-ACTION "DISEM"
	    "Disembark from"
	    [(,VEHBIT ROBJS) ["DISEM" UNBOARD]]>

<SADD-ACTION "DOC" DOC>

<ADD-ACTION "DRINK"
	    "Drink"
	    [(,DRINKBIT AOBJS ROBJS REACH) ["DRINK" EAT]]>
<VSYNONYM "DRINK" "IMBIB" "SWALL">

<ADD-ACTION "DROP"
	    "Drop"
	    [(-1 AOBJS REACH) ["DROP" DROPPER] DRIVER]
	    [(-1 AOBJS REACH) "DOWN" OBJ ["PUT" PUTTER]]
	    [(-1 AOBJS REACH) "IN" OBJ ["PUT" PUTTER]]>
<VSYNONYM "DROP" "RELEA">

<ADD-ACTION "EAT"
	    "Eat"
	    [(,FOODBIT AOBJS ROBJS REACH TAKE) ["EAT" EAT]]>
<VSYNONYM "EAT" "CONSU" "GOBBL" "MUNCH" "TASTE">

<ADD-ACTION "ENTER"
	    "Enter"
	    [["ENTER" ENTER]]
	    [OBJ ["GTHRO" THROUGH]]>

<1NRADD-ACTION "EXAMI" "Examine" ROOM-INFO>
<VSYNONYM "EXAMI" "DESCR" "WHAT" "WHATS" "WHAT'">

<SADD-ACTION "EXORC" EXORCISE>
<VSYNONYM "EXORC" "XORCI">

<ADD-ACTION "EXTIN"
	    "Turn off"
	    [(,LIGHTBIT REACH AOBJS ROBJS TAKE) ["TRNOF" LAMP-OFF]]>
<VSYNONYM "EXTIN" "DOUSE">

<ADD-ACTION "FILL" "Fill"
	    [(,CONTBIT REACH AOBJS ROBJS)
	     "WITH" OBJ
	     ["FILL" FILL]]
	    [(,CONTBIT REACH AOBJS ROBJS)
	     ["FILL" FILL]]>

<1NRADD-ACTION "FIND" "Find" FIND>
<VSYNONYM "FIND" "WHERE" "SEEK" "SEE">

<ADD-ACTION "FOLLO" "Follow" [["FOLLO" FOLLOW]] [OBJ ["FOLLO" FOLLOW]]>

<SADD-ACTION "FROBO" FROBOZZ>

<SADD-ACTION "GERON" GERONIMO>

<ADD-ACTION "GIVE"
	    "Give"
	    [OBJ "TO" (,VICBIT REACH ROBJS) ["GIVE" DROPPER] DRIVER]
	    [(,VICBIT REACH ROBJS) OBJ ["GIVE" DROPPER] FLIP]>
<VSYNONYM "GIVE" "HAND" "DONAT">

<ADD-ACTION "HELLO"
	    "Hello"
	    [["HELLO" HELLO] DRIVER]
	    [OBJ ["HELLO" HELLO]]>
<VSYNONYM "HELLO" "HI">

<ADD-ACTION "BLOW"
	    "Blow"
	    ["UP" OBJ "WITH" (,TOOLBIT REACH ROBJS AOBJS) ["INFLA" INFLATER] DRIVER]
	    ["UP" OBJ ["BLAST" BLAST]]
	    ["INTO" OBJ ["BLOIN" BREATHE]]>

<SADD-ACTION "INCAN" INCANT>

<ADD-ACTION "INFLA"
	    "Inflate"
	    [OBJ "WITH" (,TOOLBIT REACH ROBJS AOBJS) ["INFLA" INFLATER]]>

<SADD-ACTION "INVEN" INVENT>
<VSYNONYM "INVEN" "LIST" "I">

<SADD-ACTION "FOO" JARGON>
<VSYNONYM "FOO" "BAR" "BLETC">

<ADD-ACTION "JUMP"
	    "Jump"
	    [["JUMP" LEAPER]]
	    ["OVER" OBJ ["JUMP" LEAPER]]>
<VSYNONYM "JUMP" "LEAP">

<1ADD-ACTION "KICK" "Taunt" KICKER>
<VSYNONYM "KICK" "BITE" "TAUNT">

<ADD-ACTION "KILL"
	    "Kill"
	    [(,VILLAIN ROBJS REACH) "WITH" (,WEAPONBIT AOBJS HAVE) ["KILL" KILLER]]>
<VSYNONYM "KILL" "MURDE" "SLAY" "DISPA" "STAB">

<ADD-ACTION "KNOCK"
	    "Knock"
	    ["AT" OBJ ["KNOCK" KNOCK] DRIVER]
	    ["ON" OBJ ["KNOCK" KNOCK]]
	    ["DOWN" (,VICBIT = REACH ROBJS) ["ATTAC" ATTACKER]]>
<VSYNONYM "KNOCK" "RAP">

<ADD-ACTION "LEAVE"
	    "Enter"
	    [["LEAVE" LEAVE]]
	    [OBJ ["DROP" DROPPER]]>

<ADD-ACTION "LIGHT"
	    "Light"
	    [(,LIGHTBIT REACH AOBJS ROBJS TAKE) ["LIGHT" LAMP-ON] DRIVER]
	    [(,LIGHTBIT REACH AOBJS ROBJS) "WITH" (,FLAMEBIT AOBJS TAKE)
					     ["BURN" BURNER]]>

<ADD-ACTION "LOCK"
	    "Lock"
	    [(-1 ROBJS) "WITH" (,TOOLBIT AOBJS ROBJS TAKE) ["LOCK" LOCKER]]>

<ADD-ACTION "LOOK"
	    "Look"
	    [["LOOK" ROOM-DESC]]
	    ["AT" NROBJ ["LKAT" ROOM-DESC]]
	    ["THROU" NROBJ ["LKIN" LOOK-INSIDE]]
	    ["UNDER" OBJ ["LKUND" LOOK-UNDER]]
	    ["IN" NROBJ ["LKIN" LOOK-INSIDE]]
	    ["AT" NROBJ "WITH" OBJ ["READ" READER]]
	    ["AT" NROBJ "THROU" OBJ ["READ" READER]]>
<VSYNONYM "LOOK" "L" "STARE" "GAZE">

<1ADD-ACTION "LOWER" "Lower" R/L>

<1ADD-ACTION "MAKE" "Make" MAKER>
<VSYNONYM "MAKE" "BUILD">

<ADD-ACTION "MELT"
	    "Melt"
	    [OBJ "WITH" (,FLAMEBIT REACH AOBJS ROBJS) ["MELT" MELTER]]>
<VSYNONYM "MELT" "LIQUI">

<ADD-ACTION "MOVE" "Move" [(-1 ROBJS) ["MOVE" MOVE]]>
<VSYNONYM "MOVE">

<SADD-ACTION "NAME" SRNAME>

<SADD-ACTION "OBJEC" ROOM-OBJ>

<ADD-ACTION "PULL"
	    "Pull"
	    [(-1 REACH ROBJS) ["MOVE" MOVE] DRIVER]
	    ["ON" (-1 REACH ROBJS) ["MOVE" MOVE]]>
<SYNONYM "PULL" "TUG">

<SADD-ACTION "MUMBL" MUMBLER>
<VSYNONYM "MUMBL" "SIGH">

<ADD-ACTION "DESTR"
	    "Destroy"
	    [(-1 REACH ROBJS AOBJS) ["MUNG" MUNGER] DRIVER]
	    [(-1 REACH ROBJS AOBJS) "WITH" (-1 AOBJS TAKE) ["MUNG" MUNGER]]>
<VSYNONYM "DESTR" "MUNG" "DAMAG">

<SADD-ACTION "ODYSS" SINBAD>
<VSYNONYM "ODYSS" "ULYSS">

<ADD-ACTION "LUBRI"
	    "Lubricate"
	    [OBJ "WITH" (-1 AOBJS REACH) ["OIL" OIL]]>
<VSYNONYM "LUBRI" "OIL" "GREAS">

<1ADD-ACTION "OOPS" "Oops" OOPS>

<ADD-ACTION "OPEN"
	    "Open"
	    [(<+ ,DOORBIT ,CONTBIT> REACH AOBJS ROBJS) ["OPEN" OPENER] DRIVER]
	    [(<+ ,DOORBIT ,CONTBIT> REACH AOBJS ROBJS)
	     "WITH" (<+ ,WEAPONBIT ,TOOLBIT> ROBJS AOBJS HAVE) ["OPEN" OPENER]]>
<VSYNONYM "OPEN">

<ADD-ACTION "PICK"
	    "Pick"
	    ["UP" (<+ ,TAKEBIT ,TRYTAKEBIT> REACH ROBJS AOBJS) ["TAKE" TAKE]]>

<ADD-ACTION "PLAY"
	    "Play"
	    [OBJ ["PLAY" PLAY] DRIVER]
	    [OBJ "WITH" (,TOOLBIT AOBJS ROBJS REACH TAKE) ["PLAY" PLAY]]>
	     
<ADD-ACTION "PLUG"
	    "Plug"
	    [OBJ "WITH" OBJ ["PLUG" PLUGGER]]>
<VSYNONYM "PLUG" "GLUE" "PATCH">

<SADD-ACTION "PLUGH" ADVENT>
<VSYNONYM "PLUGH" "XYZZY">

<ADD-ACTION "POKE"
	    "Poke"
	    [(,VILLAIN REACH ROBJS) "WITH" (,WEAPONBIT AOBJS HAVE) ["POKE" MUNGER]]>
<VSYNONYM "POKE" "JAB" "BREAK" "BLIND">

<ADD-ACTION "POUR"
	    "Pour"
	    [(-1 AOBJS REACH) ["POUR" DROPPER] DRIVER]
	    [(-1 AOBJS REACH) "IN" OBJ ["POUR" DROPPER]]
	    [(-1 AOBJS REACH) "ON" OBJ ["PORON" POUR-ON]]>
<VSYNONYM "POUR" "SPILL">

<SADD-ACTION "PRAY" PRAYER>

<ADD-ACTION "PUMP"
	    "Pump"
	    ["UP" OBJ ["PMPUP" PUMPER]]>

<ADD-ACTION "PUSH"
	    "Push"
	    [OBJ ["PUSH" PUSHER]]
	    ["ON" OBJ ["PUSH" PUSHER]]
	    [OBJ "UNDER" OBJ ["PTUND" PUT-UNDER]]>
<VSYNONYM "PUSH" "PRESS">

<ADD-ACTION "PUT"
	    "Put"
	    [OBJ "IN" OBJ ["PUT" PUTTER] DRIVER]
	    ["DOWN" OBJ ["DROP" DROPPER]]
	    [OBJ "UNDER" OBJ ["PTUND" PUT-UNDER]]> 
<VSYNONYM "PUT" "STUFF" "PLACE" "INSER">

<ADD-ACTION "RAISE"
	    "Raise"
	    [OBJ ["RAISE" R/L] DRIVER]
	    ["UP" OBJ ["RAISE" R/L]]>
<VSYNONYM "RAISE" "LIFT">

<ADD-ACTION "READ"
	    "Read"
	    [(,READBIT REACH AOBJS ROBJS TRY) ["READ" READER] DRIVER]
	    [(,READBIT REACH AOBJS ROBJS TRY) "WITH" OBJ ["READ" READER]]
	    [(,READBIT REACH AOBJS ROBJS TRY) "THROU" OBJ ["READ" READER]]>
<VSYNONYM "READ" "SKIM">

<SADD-ACTION "REPEN" REPENT>

<ADD-ACTION "RING" "Ring"
	    [OBJ ["RING" RING] DRIVER]
	    [OBJ "WITH" OBJ ["RING" READ]]>
<VSYNONYM "RING" "PEAL">

<SADD-ACTION "ROOM" ROOM-ROOM>

<1ADD-ACTION "RUB" "Rub" RUBBER>
<VSYNONYM "RUB" "CARES" "TOUCH" "FEEL" "FONDL">

<ADD-ACTION "SEND" "Send"
	    ["FOR" OBJ ["SEND" SENDER]]>

<1ADD-ACTION "SHAKE" "Shake" SHAKER>

<ADD-ACTION "SLIDE" "Slide"
	    [OBJ "UNDER" OBJ ["PTUND" PUT-UNDER]]>

<SADD-ACTION "SKIP" SKIPPER>
<VSYNONYM "SKIP" "HOP">

<1ADD-ACTION "SMELL" "Smell" SMELLER>
<VSYNONYM "SMELL" "SNIFF">

<1ADD-ACTION "SQUEE" "Squeeze" SQUEEZER>

<SADD-ACTION "STAY" STAY>

<ADD-ACTION "STRIK"
	    "Strike"
	    [(,VICBIT = REACH ROBJS)
	     "WITH"
	     (,WEAPONBIT AOBJS ROBJS HAVE)
	     ["ATTAC" ATTACKER]]
	    [(,VICBIT = REACH ROBJS) ["ATTAC" ATTACKER] DRIVER]
	    [(-1 REACH ROBJS AOBJS TRY) ["LIGHT" LAMP-ON]]>

<SADD-ACTION "SWIM" SWIMMER>
<VSYNONYM "SWIM" "BATHE" "WADE">

<ADD-ACTION "SWING"
	    "Swing"
	    [(,WEAPONBIT AOBJS HAVE) "AT" (,VILLAIN REACH ROBJS) ["SWING" SWINGER]]>
<VSYNONYM "SWING" "THRUS">

<ADD-ACTION "TAKE"
	    "Take"
	    [(<+ ,TRYTAKEBIT ,TAKEBIT> REACH ROBJS AOBJS) ["TAKE" TAKE] DRIVER]
	    ["IN" (,VEHBIT ROBJS REACH) ["BOARD" BOARD]]
	    ["OUT" (,VEHBIT ROBJS REACH) ["DISEM" UNBOARD]]
	    [(<+ ,TAKEBIT ,TRYTAKEBIT> REACH ROBJS AOBJS) "OUT" OBJ ["TAKE" TAKE]]
	    [(<+ ,TAKEBIT ,TRYTAKEBIT> REACH ROBJS AOBJS) "FROM" OBJ ["TAKE" TAKE]]>
<VSYNONYM "TAKE" "REMOV" "GET" "HOLD" "CARRY">

<ADD-ACTION "TELL"
	    "Tell"
	    [(,ACTORBIT ROBJS) ["TELL" COMMAND]]>
<VSYNONYM "TELL" "COMMA" "REQUE">

<SADD-ACTION "TEMPL" TREAS>

<1ADD-ACTION "GTHRO" "Go through" THROUGH>
<VSYNONYM "GTHRO" "THROU" "INTO">

<ADD-ACTION "THROW"
	    "Throw"
	    [(-1 AOBJS HAVE) "AT" (,VICBIT REACH ROBJS) ["THROW" DROPPER] DRIVER]
	    [(-1 AOBJS HAVE) "THROU" (,VICBIT REACH ROBJS) ["THROW" DROPPER]]
	    [(-1 AOBJS HAVE) "IN" OBJ ["PUT" PUTTER]]>
<VSYNONYM "THROW" "HURL" "CHUCK">

<ADD-ACTION "TIE"
	    "Tie"
	    [OBJ "TO" OBJ ["TIE" TIE]]
	    ["UP" (,VICBIT REACH ROBJS) "WITH" (,TOOLBIT REACH ROBJS AOBJS HAVE) ["TIEUP" TIE-UP]]>
<VSYNONYM "TIE" "FASTE">

<SADD-ACTION "TREAS" TREAS>

<ADD-ACTION "TURN"
	    "Turn"
	    [(,TURNBIT REACH AOBJS ROBJS)
	     "WITH"
	     (,TOOLBIT ROBJS AOBJS HAVE)
	     ["TURN" TURNER]
	     DRIVER]
	    ["ON" (,LIGHTBIT REACH AOBJS ROBJS TAKE) ["TRNON" LAMP-ON]]
	    ["OFF" (,LIGHTBIT REACH AOBJS ROBJS TAKE) ["TRNOF" LAMP-OFF]]
	    [(,TURNBIT REACH AOBJS ROBJS)
	     "TO"
	     (-1 ROBJS)
	     ["TRNTO" TURNTO]]>

<VSYNONYM "TURN" "SET">

<1ADD-ACTION "SPIN" "Spin" TURNTO>

<OR <GASSIGNED? TURNTO> <SETG TURNTO ,TIME>>

<ADD-ACTION "UNLOC"
	    "Unlock"
	    [(-1 REACH ROBJS) "WITH" (,TOOLBIT AOBJS ROBJS TAKE) ["UNLOC" UNLOCKER]]>

<ADD-ACTION "UNTIE"
	    "Untie"
	    [(,TIEBIT REACH ROBJS AOBJS) ["UNTIE" UNTIE] DRIVER]
	    [(,TIEBIT REACH ROBJS AOBJS) "FROM" OBJ ["UTFRM" UNTIE-FROM]]>
<VSYNONYM "UNTIE" "RELEA" "FREE">

<SADD-ACTION "WAIT" WAIT>

<ADD-ACTION "WAKE"
	    "Wake"
	    [(,VICBIT ROBJS) ["WAKE" ALARM] DRIVER]
	    ["UP" (,VICBIT ROBJS) ["WAKE" ALARM]]>
<VSYNONYM "WAKE" "AWAKE" "SURPR" "START">

<ADD-ACTION "WALK"
	    "Walk"
	    [OBJ ["WALK" WALK]]
	    ["IN" OBJ ["GTHRO" THROUGH]]
	    ["THROU" OBJ ["GTHRO" THROUGH]]>
<VSYNONYM "WALK" "GO" "RUN" "PROCE">

<ADD-ACTION "WAVE" "Wave" [(-1 AOBJS) ["WAVE" WAVER]]>
<VSYNONYM "WAVE" "BRAND">

<SADD-ACTION "WIN" WIN>
<VSYNONYM "WIN" "WINNA">

<SADD-ACTION "WISH" WISHER>

<ADD-ACTION "WIND"
	    "Wind"
	    [OBJ ["WIND" WIND]]
	    ["UP" OBJ ["WIND" WIND]]>

<SADD-ACTION "YELL" YELL>
<VSYNONYM "YELL" "SCREA" "SHOUT">

<SADD-ACTION "ZORK" ZORK>

; "SUBTITLE BUNCH VERBS"

<ADD-BUNCHER "TAKE" "DROP" "PUT" "COUNT">

\

; "SUBTITLE ACTOR ABILITIES"

<PSETG ROBOT-ACTIONS 
   <MAPF ,UVECTOR
	 ,FIND-VERB
	 ["WALK" "TAKE" "DROP" "PUT" "JUMP" "PUSH" "THROW" "TURN"]>>

<PSETG MASTER-ACTIONS
   <MAPF ,UVECTOR
	 ,FIND-VERB
	 ["TAKE" "DROP" "PUT" "THROW" "PUSH" "TURN" "TRNTO" "SPIN"
          "FOLLO" "STAY" "OPEN" "CLOSE" "KILL"]>>

\

; "SUBTITLE OBJECTS"

;"this object is here only so Restore of old Save files will work"

<OBJECT ["BUTTO"]
	[]
	""
	0>

<OBJECT ["!!!!!"]
	[]
	""
	0>

<OBJECT ["GHOST" "SPIRI" "FIEND"]
	[]
	"number of ghosts"
	<+ ,OVISON ,VICBIT>
	GHOST-FUNCTION>

<OBJECT ["GATES" "GATE"]
	[]
	"gates"
	0>

<OBJECT ["FBASK" "CAGE" "DUMBW" "BASKE"]
	["LOWER"]
	"lowered basket"
	<+ ,OVISON>
	DUMBWAITER>

<OBJECT ["FOOD" "SANDW" "LUNCH" "DINNE"]
	["HOT" "PEPPE"]
	"lunch"
	<+ ,OVISON ,TAKEBIT ,FOODBIT>
	<>
	()
	(ODESC1 "A hot pepper sandwich is here.")>

<OBJECT ["TBAR" "T-BAR" "BAR"]
	["T"]
	"T-bar"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["GNOME" "TROLL"]
	["VOLCA"]
	"Volcano Gnome"
	<+ ,OVISON ,VICBIT>
	GNOME-FUNCTION
	()
	(ODESC1 "There is a nervous Volcano Gnome here.")>

<OBJECT ["BAGCO" "BAG" "COINS"]
	["OLD" "LEATH"]
	"bag of coins"
	<+ ,OVISON ,TAKEBIT>
	<>
	()
	(ODESC1 "An old leather bag, bulging with coins, is here."
	 OSIZE 15
	 OFVAL 10
	 OTVAL 5)>

<OBJECT ["BARRE"]
	["WOODE" "MAN-S"]
	"wooden barrel"
	<+ ,OVISON ,VEHBIT ,OPENBIT ,BURNBIT>
	BARREL
	()
	(ODESC1
"There is a man-sized barrel here which you might be able to enter."
	 OCAPAC 100
	 OSIZE 70)>

<OBJECT ["BALLO" "BASKE"]
	["WICKE"]
	"basket"
	<+ ,OVISON ,VEHBIT ,OPENBIT>
	BALLOON
	(<GET-OBJ "CBAG"> <GET-OBJ "BROPE"> <GET-OBJ "RECEP">)
	(ODESC1 
"There is a very large and extremely heavy wicker basket with a cloth
bag here. Inside the basket is a metal receptacle of some kind. 
Attached to the basket on the outside is a piece of wire." 
	 OCAPAC 100
	 OSIZE 70
	 OVTYPE ,RAIRBIT)>

<OBJECT ["TBASK" "CAGE" "DUMBW" "BASKE"]
	[]
	"basket"
	<+ ,OVISON ,TRANSBIT ,CONTBIT ,OPENBIT>
	DUMBWAITER
	()
	(ODESC1 "At the end of the chain is a basket."
	 OCAPAC 50)>

<OBJECT ["BAT" "VAMPI"]
	["VAMPI"]
	"bat"
	<+ ,OVISON ,NDESCBIT ,TRYTAKEBIT>
	FLY-ME>

<OBJECT ["BELL"]
	["SMALL" "BRASS"]
	"bell"
	<+ ,OVISON ,TAKEBIT>
	<>
	()
	(ODESCO "Lying in a corner of the room is a small brass bell."
	 ODESC1 "There is a small brass bell here.")>

<OBJECT ["HBELL" "BELL"]
	["BRASS" "HOT" "RED"]
	"red hot brass bell"
	<+ ,OVISON ,TRYTAKEBIT>
	HBELL-FUNCTION
	()
	(ODESC1 "On the ground is a red hot bell.")>

<OBJECT ["BLWAL" "WALL" "PANEL"]
	["BLACK"]
	"black panel"
	<+ ,OVISON ,NDESCBIT>
	MPANELS>

<OBJECT ["AXE"]
	["BLOOD"]
	"bloody axe"
	<+ ,OVISON ,WEAPONBIT>
	AXE-FUNCTION
	()
	(ODESC1 "There is a bloody axe here."
	 OSIZE 25)>

<OBJECT ["BLBK" "BOOK"]
	["BLUE"]
	"blue book"
	<+ ,OVISON ,READBIT ,TAKEBIT ,CONTBIT ,BURNBIT>
	<>
	()
	(ODESC1 "There is a blue book here."
	 OCAPAC 2
	 OSIZE 10
	 OREAD ,GREEK-TO-ME)>

<OBJECT ["BLABE" "LABEL"]
	["BLUE"]
	"blue label"
	<+ ,OVISON ,READBIT ,TAKEBIT ,BURNBIT>
	<>
	()
	(ODESC1 "There is a blue label here."
	 OSIZE 1
	 OREAD 
"
	  !!!!  FROBOZZ MAGIC BALLOON COMPANY !!!!

Hello, Aviator!

Instructions for use:
   
   To get into balloon, say 'Board'
   To leave balloon, say 'Disembark'
   To land, say 'Land'
    
Warranty:
   
   No warranty is expressed or implied.  You're on your own, sport!

					Good Luck.
" )>

<OBJECT ["BOLT" "BOLT" "NUT"]
	["METAL"]
	"bolt"
	<+ ,OVISON ,DOORBIT ,NDESCBIT ,TURNBIT>
	BOLT-FUNCTION>

<OBJECT ["BOOK" "PRAYE" "BIBLE" "GOODB"]
	["LARGE" "BLACK"]
	"book"
	<+ ,OVISON ,READBIT ,TAKEBIT ,CONTBIT ,BURNBIT>
	BLACK-BOOK
	()
	(ODESCO "On the altar is a large black book, open to page 569."
	 ODESC1 "There is a large black book here."
	 OSIZE 10
	 OREAD 
"		COMMANDMENT #12592
Oh ye who go about saying unto each:   \"Hello sailor\":
dost thou know the magnitude of thy sin before the gods?
Yea, verily, thou shalt be ground between two stones.
Shall the angry gods cast thy body into the whirlpool?
Surely, thy eye shall be put out with a sharp stick!
Even unto the ends of the earth shalt thou wander and
unto the land of the dead shalt thou be sent at last.
Surely thou shalt repent of thy cunning." )>

<OBJECT ["SAFE" "BOX"]
	["STEEL"]
	"box"
	<+ ,OVISON ,CONTBIT>
	SAFE-FUNCTION
	(<GET-OBJ "CROWN"> <GET-OBJ "CARD">)
	(OCAPAC 15)>

<OBJECT ["BROPE" "WIRE"]
	["BRAID"]
	"braided wire"
	<+ ,OVISON ,TIEBIT>
	WIRE-FUNCTION>

<OBJECT ["BRICK" "BRICK"]
	["SQUAR" "CLAY"]
	"brick"
	<+ ,OVISON ,TAKEBIT ,BURNBIT ,SEARCHBIT ,OPENBIT>
	BRICK-FUNCTION
	()
	(ODESC1 "There is a square brick here which feels like clay."
	 OCAPAC 2
	 OSIZE 9)>

<OBJECT ["DBALL" "BALLO" "BASKE"]
	["BROKE"]
	"broken balloon"
	<+ ,OVISON ,TAKEBIT>
	<>
	()
	(ODESC1 "There is a balloon here, broken into pieces."
	 OSIZE 40)>

<OBJECT ["BLAMP" "LAMP" "LANTE"]
	["BROKE" "BRASS"]
	"broken lamp"
	<+ ,OVISON ,TAKEBIT>
	<>
	()
	(ODESC1 "There is a broken brass lantern here.")>

<OBJECT ["STICK"]
	["SHARP" "BROKE"]
	"broken sharp stick"
	<+ ,OVISON ,TAKEBIT>
	STICK-FUNCTION
	()
	(ODESCO 
"A sharp stick, which appears to have been broken at one end, is here."
	 ODESC1 "There is a broken sharp stick here."
	 OSIZE 3)>

<SETG TIMBER-UNTIED "There is a wooden timber on the ground here.">
<SETG TIMBER-TIED "The coil of rope is tied to the wooden timber.">

<OBJECT ["OTIMB" "TIMBE" "PILE"]
	["WOODE" "BROKE"]
	"broken timber"
	<+ ,OVISON ,TAKEBIT>
	TIMBERS
	()
	(ODESC1 ,TIMBER-UNTIED
	 OSIZE 50)>

<OBJECT ["ODOOR" "DOOR"]
	["BRONZ"]
	"bronze door"
	<+ ,DOORBIT ,NDESCBIT>
	BRONZE-DOOR>

<OBJECT ["SBAG" "BAG" "SACK"]
	["BROWN" "ELONG"]
	"brown sack"
	<+ ,OVISON ,TAKEBIT ,CONTBIT ,BURNBIT>
	<>
	(<GET-OBJ "GARLI"> <GET-OBJ "FOOD">)
	(ODESCO 
"On the table is an elongated brown sack, smelling of hot peppers."
	 ODESC1 "A brown sack is here."
	 OCAPAC 15
	 OSIZE 3)>

<OBJECT ["BUBBL"]
	["GREEN" "PLAST"]
	"green bubble"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["COKES" "BOTTL" "BUNCH"]
	["COKE"]
	"bunch of Coke bottles"
	<+ ,OVISON ,TAKEBIT>
	COKE-BOTTLES
	()
	(ODESCO 
"There is a large pile of empty Coke bottles here, evidently produced
by the implementers during their long struggle to win totally." 
	 ODESC1 
"Many empty Coke bottles are here.  Alas, they can't hold water."
	 OSIZE 15)>

<OBJECT ["BLANT" "LANTE" "LAMP"]
	["USED" "BURNE" "DEAD" "USELE"]
	"burned-out lantern"
	<+ ,OVISON ,TAKEBIT>
	<>
	()
	(ODESCO "The deceased adventurer's useless lantern is here."
	 ODESC1 "There is a burned-out lantern here."
	 OSIZE 20)>

<OBJECT ["YBUTT" "BUTTO" "SWITC"]
	["YELLO"]
	"yellow button"
	<+ ,OVISON ,NDESCBIT>
	DBUTTONS>

<OBJECT ["BRBUT" "BUTTO" "SWITC"]
	["BROWN"]
	"brown button"
	<+ ,OVISON ,NDESCBIT>
	DBUTTONS>

<OBJECT ["RBUTT" "BUTTO" "SWITC"]
	["RED"]
	"red button"
	<+ ,OVISON ,NDESCBIT>
	DBUTTONS>

<OBJECT ["BLBUT" "BUTTO" "SWITC"]
	["BLUE"]
	"blue button"
	<+ ,OVISON ,NDESCBIT>
	DBUTTONS>

<OBJECT ["RNBUT" "BUTTO"]
	["ROUND"]
	"round button"
	<+ ,OVISON ,NDESCBIT>
	BUTTONS>

<OBJECT ["SQBUT" "BUTTO"]
	["SQUAR"]
	"square button"
	<+ ,OVISON ,NDESCBIT>
	BUTTONS>

<OBJECT ["TRBUT" "BUTTO"]
	["TRIAN"]
	"triangular button"
	<+ ,OVISON ,NDESCBIT>
	BUTTONS>

<OBJECT ["CARD" "NOTE"]
	["PLAIN"]
	"card"
	<+ ,OVISON ,READBIT ,TAKEBIT ,BURNBIT>
	<>
	()
	(ODESC1 "There is a card with writing on it here."
	 OSIZE 1
	 OREAD 
"
Warning:
    This room was constructed over very weak rock strata.  Detonation
of explosives in this room is strictly prohibited!
			Frobozz Magic Cave Company
			per M. Agrippa, foreman
" )>

<OBJECT ["RUG" "CARPE"]
	["ORIEN"]
	"carpet"
	<+ ,OVISON ,NDESCBIT ,TRYTAKEBIT>
	RUG>

<OBJECT ["CDOOR" "DOOR"]
	["WOOD" "WOODE" "CELL"]
	"cell door"
	<+ ,OVISON ,DOORBIT ,NDESCBIT>
	CELL-DOOR>

<OBJECT ["CHALI" "CUP" "GOBLE" "SILVE"]
	["SILVE"]
	"chalice"
	<+ ,OVISON ,TAKEBIT ,CONTBIT>
	CHALICE
	()
	(ODESC1 "There is a silver chalice, intricately engraved, here."
	 OCAPAC 5
	 OSIZE 10
	 OFVAL 10
	 OTVAL 10)>

<OBJECT ["CBAG" "BAG"]
	["CLOTH"]
	"cloth bag"
	<+ ,OVISON>
	BCONTENTS>

<OBJECT ["GARLI" "CLOVE"]
	[]
	"clove of garlic"
	<+ ,OVISON ,TAKEBIT ,FOODBIT>
	<>
	()
	(ODESC1 "There is a clove of garlic here.")>

<OBJECT ["ARROW" "POINT"]
	["COMPA"]
	"compass arrow"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["CROWN"]
	["GAUDY"]
	"crown"
	<+ ,OVISON ,TAKEBIT>
	<>
	()
	(ODESCO "The excessively gaudy crown of Lord Dimwit Flathead is here."
	 ODESC1 "Lord Dimwit's crown is here."
	 OSIZE 10
	 OFVAL 15
	 OTVAL 10)>

<OBJECT ["TOMB" "CRYPT" "GRAVE" "TOMB" "DOOR"]
	["MARBL"]
	"crypt door"
	<+ ,OVISON ,DOORBIT ,NDESCBIT>
	CRYPT-OBJECT
	()
	(OREAD 
"Here lie the implementers, whose heads were placed on poles by the
Keeper of the Dungeon for amazing untastefulness." )>

<OBJECT ["SPHER" "BALL" "PALAN" "STONE"]
	["CRYST" "SEEIN" "GLASS" "WHITE"]
	"white crystal sphere"
	<+ ,OVISON ,SACREDBIT ,TRYTAKEBIT>
	SPHERE-FUNCTION
	()
	(ODESC1 "There is a beautiful white crystal sphere here."
	 OSIZE 10
	 OFVAL 6
	 OTVAL 6)>

<OBJECT ["TRIDE" "FORK"]
	["CRYST"]
	"crystal trident"
	<+ ,OVISON ,TAKEBIT>
	<>
	()
	(ODESCO "On the shore lies Poseidon's own crystal trident."
	 ODESC1 "Poseidon's own crystal trident is here."
	 OSIZE 20
	 OFVAL 4
	 OTVAL 11)>

<OBJECT ["CYCLO" "ONE-E" "MONST"]
	[]
	"cyclops"
	<+ ,OVISON ,VICBIT ,VILLAIN>
	CYCLOPS
	()
	(OSTRENGTH 10000
	 OFMSGS ,CYCLOPS-MELEE)>

<OBJECT ["DAM" "GATE" "GATES" "FCD"]
	[]
	"dam"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["WDOOR" "DOOR"]
	["WOODE" "WEST" "WESTE"]
	"wooden door"
	<+ ,OVISON ,READBIT ,DOORBIT ,NDESCBIT>
	DDOOR-FUNCTION
	()
	(OREAD 
"The engravings translate to 'This space intentionally left blank'")>

<OBJECT ["DOOR" "TRAPD" "TRAP-"]
	["TRAP"]
	"trap door"
	<+ ,DOORBIT ,NDESCBIT>
	TRAP-DOOR>

<OBJECT ["SDOOR" "DOOR"]
	["STONE"]
	"stone door"
	<+ ,OVISON ,DOORBIT ,NDESCBIT>
	DDOOR-FUNCTION>

<OBJECT ["FDOOR" "DOOR"]
	["FRONT"]
	"door"
	<+ ,OVISON ,DOORBIT ,NDESCBIT>
	DDOOR-FUNCTION>

\

<OBJECT ["STRAD" "VIOLI"]
	["FANCY"]
	"fancy violin"
	<+ ,OVISON ,TAKEBIT>
	<>
	()
	(ODESC1 "There is a Stradivarius here."
	 OSIZE 10
	 OFVAL 10
	 OTVAL 10)>

<OBJECT ["ICE" "MASS" "GLACI"]
	[]
	"glacier"
	<+ ,OVISON ,VICBIT>
	GLACIER
	()
	(ODESC1 "A mass of ice fills the western half of the room.")>

<OBJECT ["BOTTL" "CONTA"]
	["CLEAR" "GLASS"]
	"glass bottle"
	<+ ,OVISON ,TAKEBIT ,TRANSBIT ,CONTBIT>
	BOTTLE-FUNCTION
	(<GET-OBJ "WATER">)
	(ODESCO "A bottle is sitting on the table."
	 ODESC1 "A clear glass bottle is here."
	 OCAPAC 4)>

<OBJECT ["FLASK"]
	["GLASS"]
	"glass flask filled with liquid"
	<+ ,OVISON ,TAKEBIT ,TRANSBIT>
	FLASK-FUNCTION
	()
	(ODESC1 
"A stoppered glass flask with a skull-and-crossbones marking is here.
The flask is filled with some clear liquid." 
	 OCAPAC 5
	 OSIZE 10)>

<SETG COFFIN-UNTIED "The solid-gold coffin used for the burial of Ramses II is here.">
<SETG COFFIN-TIED "The coil of rope is tied to Ramses II's gold coffin.">

<OBJECT ["COFFI" "CASKE"]
	["GOLD"]
	"gold coffin"
	<+ ,OVISON ,TAKEBIT ,CONTBIT ,SACREDBIT>
	TIMBERS
	()
	(ODESC1 ,COFFIN-UNTIED
	 OCAPAC 35
	 OSIZE 55
	 OFVAL 3
	 OTVAL 7)>

<OBJECT ["GRAIL"]
	["HOLY"]
	"grail"
	<+ ,OVISON ,TAKEBIT ,CONTBIT>
	<>
	()
	(ODESC1 "There is an extremely valuable (perhaps original) grail here."
	 OCAPAC 5
	 OSIZE 10
	 OFVAL 2
	 OTVAL 5)>

<OBJECT ["GRATE" "GRATI"]
	[]
	"grating"
	<+ ,OVISON ,DOORBIT ,NDESCBIT>
	GRATE-FUNCTION>

<OBJECT ["GRBK" "BOOK"]
	["GREEN"]
	"green book"
	<+ ,OVISON ,READBIT ,TAKEBIT ,CONTBIT ,BURNBIT>
	<>
	()
	(ODESC1 "There is a green book here."
	 OCAPAC 2
	 OSIZE 10
	 OREAD ,GREEK-TO-ME)>

<OBJECT ["RBTLB" "PAPER" "PIECE"]
	["GREEN"]
	"green piece of paper"
	<+ ,OVISON ,READBIT ,TAKEBIT ,BURNBIT>
	<>
	()
	(ODESC1 "There is a green piece of paper here."
	 OSIZE 3
	 OREAD 
"	  !!!! 	FROBOZZ MAGIC ROBOT COMPANY  !!!!

Hello, Master!
   
   I am a late-model robot, trained at MIT Tech to perform various
simple household functions. 

Instructions for use:
   To activate me, use the following formula:
	>TELL ROBOT '<something to do>' <cr>
   The quotation marks are required!
       
Warranty:
   No warranty is expressed or implied.
				
					At your service!
" )>

<OBJECT ["PUMP" "AIR-P" "AIRPU"]
	["SMALL" "HAND-"]
	"hand-held air pump"
	<+ ,OVISON ,TAKEBIT ,TOOLBIT>
	<>
	()
	(ODESC1 "There is a small pump here.")>

<OBJECT ["HPOLE" "HEAD"]
	[]
	"head on a pole"
	<+ ,OVISON>>

<OBJECT ["SSLOT" "SLOT" "HOLE"]
	[]
	"hole"
	<+ ,OVISON ,OPENBIT>
	<>
	()
	(OCAPAC 10)>

<OBJECT ["HOOK2" "HOOK"]
	["SMALL"]
	"hook"
	<+ ,OVISON>
	<>
	()
	(ODESC1 ,HOOK-DESC)>

<OBJECT ["HOOK1" "HOOK"]
	["SMALL"]
	"hook"
	<+ ,OVISON>
	<>
	()
	(ODESC1 ,HOOK-DESC)>

<OBJECT ["DIAMO"]
	["HUGE" "ENORM"]
	"huge diamond"
	<+ ,OVISON ,TAKEBIT>
	<>
	()
	(ODESC1 "There is an enormous diamond (perfectly cut) here."
	 OFVAL 10
	 OTVAL 6)>

<OBJECT ["GUANO" "CRAP" "SHIT" "HUNK"]
	[]
	"hunk of bat guano"
	<+ ,OVISON ,TAKEBIT ,DIGBIT>
	GUANO-FUNCTION
	()
	(ODESC1 "There is a hunk of bat guano here."
	 OSIZE 20)>

<OBJECT ["JADE" "FIGUR"]
	["JADE"]
	"jade figurine"
	<+ ,OVISON ,TAKEBIT>
	<>
	()
	(ODESC1 "There is an exquisite jade figurine here."
	 OSIZE 10
	 OFVAL 5
	 OTVAL 5)>

<OBJECT ["KNIFE" "BLADE"]
	["NASTY" "UNRUS" "PLAIN"]
	"knife"
	<+ ,OVISON ,TAKEBIT ,WEAPONBIT>
	<>
	()
	(ODESCO "On a table is a nasty-looking knife."
	 ODESC1 "There is a nasty-looking knife lying here."
	 OFMSGS ,KNIFE-MELEE)>

<OBJECT ["LAMP" "LANTE" "LIGHT"]
	["BRASS"]
	"lamp"
	<+ ,OVISON ,TAKEBIT ,LIGHTBIT>
	LANTERN
	()
	(ODESCO "A battery-powered brass lantern is on the trophy case."
	 ODESC1 "There is a brass lantern (battery-powered) here."
	 OSIZE 15
	 OLINT [0 <CLOCK-DISABLE <CLOCK-INT ,LNTIN 350>>])>

<OBJECT ["DBUTT" "BUTTO"]
	["LARGE"]
	"large button"
	<+ ,OVISON ,NDESCBIT>
	DIALBUTTON>

<OBJECT ["LCASE" "CASE"]
	["LARGE"]
	"large case"
	<+ ,OVISON ,TRANSBIT>
	<>
	()
	(ODESC1 
"There is a large case here, containing objects which you used to
possess.")>

<OBJECT ["EMERA"]
	["LARGE"]
	"large emerald"
	<+ ,OVISON ,TAKEBIT>
	<>
	()
	(ODESC1 "There is an emerald here."
	 OFVAL 5
	 OTVAL 10)>

<OBJECT ["ATABL" "TABLE"]
	["LARGE" "OBLON"]
	"large oblong table"
	<+ ,OVISON>>

<OBJECT ["ADVER" "PAMPH" "LEAFL" "BOOKL" "MAIL"]
	["SMALL"]
	"leaflet"
	<+ ,OVISON ,READBIT ,TAKEBIT ,BURNBIT>
	<>
	()
	(ODESC1 "There is a small leaflet here."
	 OSIZE 2
	 OREAD 
"			WELCOME TO ZORK

    ZORK is a game of adventure, danger, and low cunning.  In it you
will explore some of the most amazing territory ever seen by mortal
man.  Hardened adventurers have run screaming from the terrors
contained within!

    In ZORK the intrepid explorer delves into the forgotten secrets
of a lost labyrinth deep in the bowels of the earth, searching for
vast treasures long hidden from prying eyes, treasures guarded by
fearsome monsters and diabolical traps!

    No PDP-10 should be without one!

    ZORK was created at the MIT Laboratory for Computer Science, by
Tim Anderson, Marc Blank, Bruce Daniels, and Dave Lebling.  It was
inspired by the ADVENTURE game of Crowther and Woods, and the long
tradition of fantasy and science fiction adventure.  ZORK is written
in MDL (alias MUDDLE).

    On-line information may be available using the HELP and INFO
commands (most systems).

    Direct inquiries, comments, etc. by Net mail to ZORK@MIT-DMS.

    (c) Copyright 1978,1979 Massachusetts Institute of Technology.  
		       All rights reserved.
" )>

<SETG BUNCH-OBJ
<OBJECT ["*BUN*"]
	[]
	""
	<+ ,OVISON ,BUNCHBIT>
	<>
	()
	(OBVERB <>)>>

<OBJECT ["LEAK" "DRIP" "HOLE"]
	[]
	"leak"
	<+ ,NDESCBIT>
	LEAK-FUNCTION>

<OBJECT ["MDOOR" "DOOR"]
	["LOCKE" "WOOD" "WOODE" "CELL"]
	"locked door"
	<+ ,OVISON ,DOORBIT ,NDESCBIT>
	LOCKED-DOOR>

<OBJECT ["LDOOR" "DOOR"]
	["LOCKE" "WOOD" "WOODE" "CELL"]
	"locked door"
	<+ ,OVISON ,DOORBIT ,NDESCBIT>
	LOCKED-DOOR>

<OBJECT ["LPOLE" "POLE" "POST"]
	["LONG" "CENTE"]
	"long pole"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["MACHI" "PDP10" "DRYER" "LID"]
	[]
	"machine"
	<+ ,OVISON ,CONTBIT>
	MACHINE-FUNCTION
	()
	(OCAPAC 50)>

<OBJECT ["RBOAT" "BOAT"]
	["MAGIC" "PLAST" "SEAWO"]
	"magic boat"
	<+ ,OVISON ,TAKEBIT ,BURNBIT ,VEHBIT ,OPENBIT>
	RBOAT-FUNCTION
	(<GET-OBJ "LABEL">)
	(ODESC1 "There is an inflated boat here."
	 OCAPAC 100
	 OSIZE 20
	 OVTYPE ,RWATERBIT)>

<OBJECT ["OAKND" "WALL" "PANEL"]
	["MAHOG"]
	"mahogany wall"
	<+ ,OVISON ,NDESCBIT>
	MENDS>

<OBJECT ["MAILB" "BOX"]
	["SMALL"]
	"mailbox"
	<+ ,OVISON ,CONTBIT>
	<>
	(<GET-OBJ "ADVER">)
	(ODESC1 "There is a small mailbox here."
	 OCAPAC 10)>

<OBJECT ["CAGE"]
	["MANGL" "STEEL"]
	"steel cage"
	<+ ,OVISON ,NDESCBIT>
	<>
	()
	(ODESC1 "There is a mangled steel cage here."
	 OSIZE 60)>

<OBJECT ["MATCH" "FLINT"]
	[]
	"matchbook"
	<+ ,OVISON ,READBIT ,TAKEBIT>
	MATCH-FUNCTION
	()
	(ODESC1 
"There is a matchbook whose cover says 'Visit Beautiful FCD#3' here."
	 OSIZE 2
	 OMATCH 5
	 OREAD 
"	        [close cover before striking BKD]

	YOU too can make BIG MONEY in the exciting field of
		      PAPER SHUFFLING!

Mr. TAA of Muddle, Mass. says: \"Before I took this course I used
to be a lowly bit twiddler.  Now with what I learned at MIT Tech
I feel really important and can obfuscate and confuse with the best.\"

Mr. MARC had this to say: \"Ten short days ago all I could look
forward to was a dead-end job as a doctor.  Now I have a promising
future and make really big Zorkmids.\"

MIT Tech can't promise these fantastic results to everyone.  But when
you earn your MDL degree from MIT Tech your future will be brighter.

	      Send for our free brochure today." )>

<OBJECT ["REFL2" "MIRRO"]
	[]
	"mirror"
	<+ ,OVISON ,VICBIT ,TRYTAKEBIT>
	MIRROR-MIRROR>

<OBJECT ["REFL1" "MIRRO"]
	[]
	"mirror"
	<+ ,OVISON ,VICBIT ,TRYTAKEBIT>
	MIRROR-MIRROR>

<OBJECT ["PAPER" "NEWSP" "ISSUE" "REPOR" "MAGAZ" "NEWS"]
	[]
	"newspaper"
	<+ ,OVISON ,READBIT ,TAKEBIT ,BURNBIT>
	<>
	()
	(ODESC1 
"There is an issue of US NEWS & DUNGEON REPORT dated 7/22/81 here."
	 OSIZE 2
	 OREAD 
"		US NEWS & DUNGEON REPORT
7/22/81  				       Last G.U.E. Edition

This version of ZORK is no longer being supported on this or any other
machine.  In particular, bugs and feature requests will, most likely, be
read and ignored.  There are updated versions of ZORK, including some
altogether new problems, available for PDP-11s and various
microcomputers (TRS-80, APPLE, maybe more later).  For information, send
a SASE to:

                Infocom, Inc.
                P.O. Box 120, Kendall Station
                Cambridge, Ma. 02142
")>

<OBJECT ["EIGHT" "8"]
	[]
	"number eight"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["FIVE" "5"]
	[]
	"number five"
	<+ ,OVISON ,NDESCBIT>
	TAKE-FIVE>

<OBJECT ["FOUR" "4"]
	[]
	"number four"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["ONE" "1"]
	[]
	"number one"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["SEVEN" "7"]
	[]
	"number seven"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["SIX" "6"]
	[]
	"number six"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["THREE" "3"]
	[]
	"number three"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["TWO" "2"]
	[]
	"number two"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["PAINT" "ART" "CANVA" "MASTE" "PICTU" "WORK"]
	[]
	"painting"
	<+ ,OVISON ,TAKEBIT ,BURNBIT>
	PAINTING
	()
	(ODESCO 
"Fortunately, there is still one chance for you to be a vandal, for on
the far wall is a work of unparalleled beauty." 
	 ODESC1 "A masterpiece by a neglected genius is here."
	 OSIZE 15
	 OFVAL 4
	 OTVAL 7)>

<OBJECT ["CANDL" "PAIR"]
	[]
	"pair of candles"
	<+ ,OVISON ,TAKEBIT ,LIGHTBIT ,FLAMEBIT ,ONBIT>
	CANDLES
	()
	(ODESCO "On the two ends of the altar are burning candles."
	 ODESC1 "There are two candles here."
	 OSIZE 10
	 OLINT [0 <CLOCK-DISABLE <CLOCK-INT ,CNDIN 50>>])>

<OBJECT ["PEARL" "NECKL"]
	["PEARL"]
	"pearl necklace"
	<+ ,OVISON ,TAKEBIT>
	<>
	()
	(ODESC1 "There is a pearl necklace here with hundreds of large pearls."
	 OSIZE 10
	 OFVAL 9
	 OTVAL 5)>

<OBJECT ["ECAKE" "CAKE"]
	["EATME" "EAT-M"]
	"piece of 'Eat-Me' cake"
	<+ ,OVISON ,TAKEBIT ,FOODBIT>
	EATME-FUNCTION
	()
	(ODESC1 "There is a piece of cake here with the words 'Eat-Me' on it."
	 OSIZE 10)>

<OBJECT ["BLICE" "CAKE" "ICING"]
	["BLUE" "ECCH"]
	"piece of cake with blue icing"
	<+ ,OVISON ,READBIT ,TAKEBIT ,FOODBIT>
	CAKE-FUNCTION
	()
	(ODESC1 "There is a piece of cake with blue (ecch) icing here."
	 OSIZE 4)>

<OBJECT ["ORICE" "CAKE" "ICING"]
	["ORANG"]
	"piece of cake with orange icing"
	<+ ,OVISON ,READBIT ,TAKEBIT ,FOODBIT>
	CAKE-FUNCTION
	()
	(ODESC1 "There is a piece of cake with orange icing here."
	 OSIZE 4)>

<OBJECT ["RDICE" "CAKE" "ICING"]
	["RED"]
	"piece of cake with red icing"
	<+ ,OVISON ,READBIT ,TAKEBIT ,FOODBIT>
	CAKE-FUNCTION
	()
	(ODESC1 "There is a piece of cake with red icing here."
	 OSIZE 4)>

<OBJECT ["GUNK" "PIECE" "SLAG"]
	["VITRE"]
	"piece of vitreous slag"
	<+ ,OVISON ,TAKEBIT ,TRYTAKEBIT>
	GUNK-FUNCTION
	()
	(ODESC1 "There is a small piece of vitreous slag here."
	 OSIZE 10)>

<OBJECT ["BODIE" "BODY" "CORPS" "PILE"]
	[]
	"pile of bodies"
	<+ ,OVISON ,NDESCBIT ,TRYTAKEBIT>
	BODY-FUNCTION>

<OBJECT ["CORPS" "PILE"]
	["MANGL"]
	"pile of corpses"
	<+ ,OVISON>>

<OBJECT ["LEAVE" "LEAF" "PILE"]
	[]
	"pile of leaves"
	<+ ,OVISON ,TAKEBIT ,BURNBIT>
	LEAF-PILE
	()
	(ODESC1 "There is a pile of leaves on the ground."
	 OSIZE 25)>

<OBJECT ["PINND" "WALL" "PANEL" "DOOR"]
	["PINE"]
	"pine wall"
	<+ ,OVISON ,DOORBIT ,NDESCBIT>
	MENDS>

<OBJECT ["DBOAT" "BOAT" "PILE" "PLAST"]
	["PLAST"]
	"plastic boat (with hole)"
	<+ ,OVISON ,TAKEBIT ,BURNBIT>
	DBOAT-FUNCTION
	()
	(ODESC1 "There is a pile of plastic here with a large hole in it."
	 OSIZE 20)>

<OBJECT ["IBOAT" "BOAT" "PILE" "PLAST"]
	["PLAST"]
	"pile of plastic"
	<+ ,OVISON ,TAKEBIT ,BURNBIT>
	IBOAT-FUNCTION
	()
	(ODESC1 
"There is a folded pile of plastic here which has a small valve
attached." 
	 OSIZE 20)>

<OBJECT ["BAR" "PLATI"]
	["PLATI" "LARGE"]
	"platinum bar"
	<+ ,OVISON ,TAKEBIT ,SACREDBIT>
	<>
	()
	(ODESC1 "There is a large platinum bar here."
	 OSIZE 20
	 OFVAL 12
	 OTVAL 10)>

<OBJECT ["PLEAK" "LEAK"]
	["LARGE"]
	"leak"
	<+ ,OVISON ,NDESCBIT>
	PLEAK>

<OBJECT ["POOL" "SEWAG" "GOOP"]
	["LARGE" "BROWN"]
	"pool of sewage"
	<+ ,OVISON ,VICBIT>
	<>
	()
	(ODESC1 "The leak has submerged the depressed area in a pool of sewage.")>

<OBJECT ["POT" "GOLD"]
	["GOLD"]
	"pot of gold"
	<+ ,TAKEBIT>
	<>
	()
	(ODESCO "At the end of the rainbow is a pot of gold."
	 ODESC1 "There is a pot of gold here."
	 OSIZE 15
	 OFVAL 10
	 OTVAL 10)>

<OBJECT ["PRAYE" "INSCR"]
	["ANCIE" "OLD"]
	"prayer"
	<+ ,OVISON ,READBIT ,SACREDBIT>
	<>
	()
	(OREAD 
"The prayer is inscribed in an ancient script which is hardly
remembered these days, much less understood.  What little of it can
be made out seems to be a philippic against small insects,
absent-mindedness, and the picking up and dropping of small objects. 
The final verse seems to consign trespassers to the land of the
dead.  All evidence indicates that the beliefs of the ancient
Zorkers were obscure." )>

<OBJECT ["COIN" "ZORKM" "GOLD"]
	["GOLD" "PRICE"]
	"priceless zorkmid"
	<+ ,OVISON ,READBIT ,TAKEBIT>
	<>
	()
	(ODESCO 
"On the floor is a gold zorkmid coin (a valuable collector's item)."
	 ODESC1 "There is an engraved zorkmid coin here."
	 OSIZE 10
	 OFVAL 10
	 OTVAL 12
	 OREAD 
"
	       --------------------------
	      /      Gold Zorkmid	 \\
	     /  T e n   T h o u s a n d   \\
	    /        Z O R K M I D S	   \\
	   /				    \\
	  /        ||||||||||||||||||	     \\
	 /        !||||		 ||||!	      \\
	|	   |||   ^^  ^^   |||	       |
	|	   |||	 OO  OO   |||	       |
	| In Frobs  |||	   <<    |||  We Trust |
	|	     || (______) ||	       |
	|	      |          |	       |
	|	      |__________|	       |
	 \\				      /
	  \\    -- Lord Dimwit Flathead --    /
	   \\    -- Beloved of Zorkers --    /
	    \\				   /
	     \\	     * 722 G.U.E. *       /
	      \\				 /
	       --------------------------
" )>

<OBJECT ["PUBK" "BOOK"]
	["PURPL"]
	"purple book"
	<+ ,OVISON ,READBIT ,TAKEBIT ,CONTBIT ,BURNBIT>
	<>
	(<GET-OBJ "STAMP">)
	(ODESC1 "There is a purple book here."
	 OCAPAC 2
	 OSIZE 10
	 OREAD ,GREEK-TO-ME)>

<OBJECT ["WATER" "QUANT" "LIQUI" "H2O"]
	[]
	"quantity of water"
	<+ ,OVISON ,TAKEBIT ,DRINKBIT>
	WATER-FUNCTION
	()
	(ODESC1 "There is some water here"
	 OSIZE 4)>

<OBJECT ["RAILI" "RAIL"]
	["WOODE"]
	"wooden railing"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["RAINB"]
	[]
	"rainbow"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["RECEP"]
	["METAL"]
	"receptacle"
	<+ ,OVISON ,CONTBIT ,SEARCHBIT>
	BCONTENTS
	()
	(OCAPAC 6)>

<OBJECT ["RBEAM" "BEAM" "LIGHT"]
	["RED"]
	"red beam of light"
	<+ ,OVISON ,NDESCBIT ,OPENBIT>
	BEAM-FUNCTION
	()
	(OCAPAC 1000)>

<OBJECT ["BUOY"]
	["RED"]
	"red buoy"
	<+ ,OVISON ,TAKEBIT ,CONTBIT ,FINDMEBIT>
	<>
	(<GET-OBJ "EMERA">)
	(ODESC1 "There is a red buoy here (probably a warning)."
	 OCAPAC 20
	 OSIZE 10)>

<OBJECT ["RSWIT" "SWITC" "BUTTO"]
	["RED"]
	"red button"
	<+ ,OVISON ,NDESCBIT>
	MRSWITCH>

<OBJECT ["RDWAL" "WALL" "PANEL"]
	["RED"]
	"red panel"
	<+ ,OVISON ,NDESCBIT>
	MPANELS>

<OBJECT ["ROBOT" "R2D2" "C3PO" "ROBBY"]
	[]
	"robot"
	<+ ,OVISON ,VICBIT ,SACREDBIT ,ACTORBIT>
	ROBOT-FUNCTION
	()
	(ODESC1 "There is a robot here."
	 OACTOR ,ROBOT)>

<OBJECT ["ROPE" "HEMP" "COIL"]
	["LARGE"]
	"rope"
	<+ ,OVISON ,TAKEBIT ,TIEBIT ,SACREDBIT>
	ROPE-FUNCTION
	()
	(ODESCO "A large coil of rope is lying in the corner."
	 ODESC1 "There is a large coil of rope here."
	 OSIZE 10)>

<OBJECT ["RUBY"]
	["MOBY"]
	"ruby"
	<+ ,OVISON ,TAKEBIT>
	<>
	()
	(ODESCO "On the floor lies a moby ruby."
	 ODESC1 "There is a moby ruby lying here."
	 OFVAL 15
	 OTVAL 8)>

<OBJECT ["RKNIF" "KNIFE"]
	["RUSTY"]
	"rusty knife"
	<+ ,OVISON ,TAKEBIT ,WEAPONBIT>
	RUSTY-KNIFE
	()
	(ODESCO "Beside the skeleton is a rusty knife."
	 ODESC1 "There is a rusty knife here."
	 OSIZE 20
	 OFMSGS ,KNIFE-MELEE)>

<OBJECT ["SAND" "BEACH"]
	["SANDY"]
	"sandy beach"
	<+ ,OVISON ,DIGBIT>
	SAND-FUNCTION>

<OBJECT ["BRACE" "JEWEL" "SAPPH"]
	["SAPPH"]
	"sapphire bracelet"
	<+ ,OVISON ,TAKEBIT>
	<>
	()
	(ODESC1 "There is a sapphire-encrusted bracelet here."
	 OSIZE 10
	 OFVAL 5
	 OTVAL 3)>

<OBJECT ["SCREW"]
	[]
	"screwdriver"
	<+ ,OVISON ,TAKEBIT ,TOOLBIT>
	<>
	()
	(ODESC1 "There is a screwdriver here.")>

<OBJECT ["HEADS" "HEAD" "POLE" "POLES" "PDL" "BKD" "TAA" "MARC" "IMPLE" "LOSER"]

	[]
	"set of poled heads"
	<+ ,OVISON ,SACREDBIT ,TRYTAKEBIT>
	HEAD-FUNCTION
	()
	(ODESC1 "There are four heads here, mounted securely on poles.")>

<OBJECT ["KEYS" "SET" "KEY"]
	[]
	"set of skeleton keys"
	<+ ,OVISON ,TAKEBIT ,TOOLBIT>
	<>
	()
	(ODESC1 "There is a set of skeleton keys here."
	 OSIZE 10)>

<OBJECT ["SPOLE" "POLE" "POST" "HANDG" "GRIP"]
	["SHORT" "SMALL"]
	"short pole"
	<+ ,OVISON ,NDESCBIT>
	SHORT-POLE>

<OBJECT ["SHOVE"]
	["LARGE"]
	"shovel"
	<+ ,OVISON ,TAKEBIT ,TOOLBIT>
	<>
	()
	(ODESC1 "There is a large shovel here."
	 OSIZE 15)>

<OBJECT ["BONES" "SKELE" "BODY"]
	[]
	"skeleton"
	<+ ,OVISON ,TRYTAKEBIT>
	SKELETON
	()
	(ODESC1 
"A skeleton, probably the remains of a luckless adventurer, lies here.")>

<OBJECT ["COAL" "PILE" "HEAP"]
	["SMALL"]
	"small pile of coal"
	<+ ,OVISON ,TAKEBIT ,BURNBIT>
	<>
	()
	(ODESC1 "There is a small heap of coal here."
	 OSIZE 20)>

<OBJECT ["LISTS" "PAPER" "LIST" "PRINT" "LISTI" "STACK" "OUTPU"]
	["GIGAN" "LINE-"]
	"stack of listings"
	<+ ,OVISON ,READBIT ,TAKEBIT ,BURNBIT>
	<>
	()
	(ODESCO 
"There is a gigantic pile of line-printer output here.  Although the
paper once contained useful information, almost nothing can be
distinguished now." 
	 ODESC1 
"There is an enormous stack of line-printer paper here.  It is barely
readable." 
	 OSIZE 70
	 OREAD 
"<DEFINE FEEL-FREE (LOSER)
		   <TELL \"FEEL FREE, CHOMPER!\">>
			...
The rest is, alas, unintelligible (as were the implementers)." )>

<OBJECT ["STAMP"]
	["FLATH"]
	"Flathead stamp"
	<+ ,OVISON ,READBIT ,TAKEBIT ,BURNBIT>
	<>
	()
	(ODESC1 "There is a Flathead stamp here."
	 OSIZE 1
	 OFVAL 4
	 OTVAL 10
	 OREAD 
"
---v----v----v----v----v----v----v----v---
|					 |
|	   ||||||||||	     LORD	 |
>         !||||	     |	    DIMWIT	 <
|	  ||||    ---|	   FLATHEAD	 |
|	  |||C	   CC \\  		 |
>	   ||||	      _\\		 <
|	    ||| (____|			 |
|	     ||      |			 |
>	      |______|	     Our	 <
|		/   \\	  Excessive	 |
|	       /     \\	    Leader	 |
>	      |	      |			 <
|	      |       |			 |
|					 |
>    G.U.E. POSTAGE	   3 Zorkmids    <
|					 |
---^----^----^----^----^----^----^----^---
" )>

<OBJECT ["STATU" "SCULP" "ROCK"]
	["BEAUT"]
	"statue"
	<+ ,TAKEBIT>
	<>
	()
	(ODESC1 "There is a beautiful statue here."
	 OSIZE 8
	 OFVAL 10
	 OTVAL 13)>

<OBJECT ["IRBOX" "BOX"]
	["STEEL" "DENTE"]
	"steel box"
	<+ ,TAKEBIT ,CONTBIT>
	<>
	(<GET-OBJ "STRAD">)
	(ODESC1 "There is a dented steel box here."
	 OCAPAC 20
	 OSIZE 40)>

<OBJECT ["RCAGE" "CAGE"]
	["STEEL"]
	"steel cage"
	<+ ,OVISON>
	<>
	()
	(ODESC1 "There is a steel cage in the middle of the room.")>

<OBJECT ["STILL"]
	["VICIO"]
	"stiletto"
	<+ ,OVISON ,WEAPONBIT>
	<>
	()
	(ODESC1 "There is a vicious-looking stiletto here."
	 OSIZE 10)>

<OBJECT ["DIAL" "SUNDI"]
	["SUN"]
	"sundial"
	<+ ,OVISON ,NDESCBIT ,TURNBIT>
	DIAL>

<OBJECT ["MSWIT" "SWITC"]
	[]
	"switch"
	<+ ,OVISON ,NDESCBIT ,TURNBIT>
	MSWITCH-FUNCTION>

<OBJECT ["SWORD" "ORCRI" "GLAMD" "BLADE"]
	["ELVIS"]
	"sword"
	<+ ,OVISON ,TAKEBIT ,WEAPONBIT>
	SWORD
	()
	(ODESCO 
"On hooks above the mantelpiece hangs an elvish sword of great
antiquity." 
	 ODESC1 "There is an elvish sword here."
	 OSIZE 30
	 OFMSGS ,SWORD-MELEE
	 OTVAL 0)>

<OBJECT ["LABEL" "FINEP" "PRINT"]
	["TAN" "FINE"]
	"tan label"
	<+ ,OVISON ,READBIT ,TAKEBIT ,BURNBIT>
	<>
	()
	(ODESC1 "There is a tan label here."
	 OSIZE 2
	 OREAD 
"	  !!!! 	FROBOZZ MAGIC BOAT COMPANY  !!!!

Hello, Sailor!

Instructions for use:
   
   To get into boat, say 'Board'
   To leave boat, say 'Disembark'

   To get into a body of water, say 'Launch'
   To get to shore, say 'Land'
    
Warranty:

  This boat is guaranteed against all defects in parts and
workmanship for a period of 76 milliseconds from date of purchase or
until first used, whichever comes first.

Warning:
   This boat is made of plastic.		Good Luck!
" )>

<OBJECT ["THIEF" "ROBBE" "CROOK" "CRIMI" "BANDI" "GENT" "GENTL" "MAN" "INDIV"]
	["SHADY" "SUSPI"]
	"thief"
	<+ ,OVISON ,VICBIT ,VILLAIN>
	ROBBER-FUNCTION
	(<GET-OBJ "STILL">)
	(ODESC1 
"There is a suspicious-looking individual, holding a bag, leaning
against one wall.  He is armed with a vicious-looking stiletto." 
	 OSTRENGTH 5
	 OFMSGS ,THIEF-MELEE)>

<OBJECT ["SAFFR" "TIN" "SPICE"]
	["RARE"]
	"tin of spices"
	<+ ,TAKEBIT>
	<>
	()
	(ODESC1 "There is a tin of rare spices here."
	 OSIZE 8
	 OFVAL 5
	 OTVAL 5)>

<OBJECT ["TORCH" "IVORY"]
	["IVORY"]
	"torch"
	<+ ,OVISON ,TAKEBIT ,LIGHTBIT ,FLAMEBIT ,TOOLBIT ,ONBIT>
	TORCH-OBJECT
	()
	(ODESCO "Sitting on the pedestal is a flaming torch, made of ivory."
	 ODESC1 "There is an ivory torch here."
	 OSIZE 20
	 OFVAL 14
	 OTVAL 6)>

<OBJECT ["GUIDE" "BOOK"]
	["TOUR"]
	"tour guidebook"
	<+ ,OVISON ,READBIT ,TAKEBIT ,BURNBIT>
	<>
	()
	(ODESCO 
"Some guidebooks entitled 'Flood Control Dam #3' are on the reception
desk." 
	 ODESC1 "There are tour guidebooks here."
	 OREAD 
"\"		   Guide Book to
		Flood Control Dam #3

  Flood Control Dam #3 (FCD#3) was constructed in year 783 of the
Great Underground Empire to harness the destructive power of the
Frigid River.  This work was supported by a grant of 37 million
zorkmids from the Central Bureaucracy and your omnipotent local
tyrant Lord Dimwit Flathead the Excessive. This impressive
structure is composed of 3.7 cubic feet of concrete, is 256 feet
tall at the center, and 193 feet wide at the top.  The reservoir
created behind the dam has a volume of 37 billion cubic feet, an
area of 12 million square feet, and a shore line of 36 thousand
feet.

  The construction of FCD#3 took 112 days from ground breaking to
the dedication. It required a work force of 384 slaves, 34 slave
drivers, 12 engineers, 2 turtle doves, and a partridge in a pear
tree. The work was managed by a command team composed of 2345
bureaucrats, 2347 secretaries (at least two of whom can type),
12,256 paper shufflers, 52,469 rubber stampers, 245,193 red tape
processors, and nearly one million dead trees.

  We will now point out some of the more interesting features
of FCD#3 as we conduct you on a guided tour of the facilities:
	1) You start your tour here in the Dam Lobby.
	   You will notice on your right that ........." )>

<OBJECT ["TROLL"]
	["NASTY"]
	"troll"
	<+ ,OVISON ,VICBIT ,VILLAIN>
	TROLL
	(<GET-OBJ "AXE">)
	(ODESC1 
"A nasty-looking troll, brandishing a bloody axe, blocks all passages
out of the room." 
	 OSTRENGTH 2
	 OFMSGS ,TROLL-MELEE)>

<OBJECT ["TCASE" "CASE"]
	["TROPH"]
	"trophy case"
	<+ ,OVISON ,TRANSBIT ,CONTBIT>
	TROPHY-CASE
	()
	(ODESC1 "There is a trophy case here."
	 OCAPAC ,BIGFIX)>

<OBJECT ["TRUNK" "CHEST" "JEWEL"]
	["OLD"]
	"trunk of jewels"
	<+ ,TAKEBIT>
	<>
	()
	(ODESCO 
"Lying half buried in the mud is an old trunk, bulging with jewels."
	 ODESC1 "There is an old trunk here, bulging with assorted jewels."
	 OSIZE 35
	 OFVAL 15
	 OTVAL 8)>

<OBJECT ["TUBE" "TOOTH"]
	[]
	"tube"
	<+ ,OVISON ,TAKEBIT ,CONTBIT ,READBIT>
	TUBE-FUNCTION
	(<GET-OBJ "PUTTY">)
	(ODESC1 "There is an object which looks like a tube of toothpaste here."
	 OCAPAC 7
	 OSIZE 10
	 OREAD
"---> Frobozz Magic Gunk Company <---
	  All-Purpose Gunk")>

<OBJECT ["PUTTY" "MATER" "GUNK" "GLUE"]
	["VISCO"]
	"viscous material"
	<+ ,OVISON ,TAKEBIT ,TOOLBIT>
	<>
	()
	(ODESC1 "There is some gunk here"
	 OSIZE 6)>

<OBJECT ["ENGRA" "INSCR"]
	["OLD" "ANCIE"]
	"wall with engravings"
	<+ ,OVISON ,READBIT ,SACREDBIT>
	<>
	()
	(ODESC1 "There are old engravings on the walls here."
	 OREAD 
"The engravings were incised in the living rock of the cave wall by
an unknown hand.  They depict, in symbolic form, the beliefs of the
ancient peoples of Zork.  Skillfully interwoven with the bas reliefs
are excerpts illustrating the major tenets expounded by the sacred
texts of the religion of that time.  Unfortunately a later age seems
to have considered them blasphemous and just as skillfully excised
them." )>

<OBJECT ["ETCH2" "ETCHI" "WALLS" "WALL"]
	[]
	"wall with etchings"
	<+ ,OVISON ,READBIT ,NDESCBIT ,FINDMEBIT>
	<>
	()
	(OREAD 
"		        o  b  o
		    r 		  z
		 f   M  A  G  I  C   z
		 c    W  E   L  L    y
		    o		  n
		        m  p  a
" )>

<OBJECT ["ETCH1" "ETCHI" "WALLS" "WALL"]
	[]
	"wall with etchings"
	<+ ,OVISON ,READBIT ,NDESCBIT ,FINDMEBIT>
	<>
	()
	(OREAD 
"		        o  b  o

		        A  G  I
		         E   L

		        m  p  a
" )>

<OBJECT ["TTREE" "TREE"]
	["LARGE"]
	"large tree"
	<+ ,OVISON ,NDESCBIT ,CLIMBBIT>>

<OBJECT ["FTREE" "TREE"]
	["LARGE"]
	"large tree"
	<+ ,OVISON ,NDESCBIT ,CLIMBBIT>>

<OBJECT ["CCLIF" "CLIFF" "LEDGE"]
	["ROCKY" "SHEER"]
	"cliff"
	<+ ,OVISON ,NDESCBIT ,CLIMBBIT>>

<OBJECT ["WCLIF" "CLIFF"]
	["WHITE"]
	"white cliffs"
	<+ ,OVISON ,NDESCBIT ,CLIMBBIT>
	WCLIF-OBJECT>

<OBJECT ["WHBK" "BOOK"]
	["WHITE"]
	"white book"
	<+ ,OVISON ,READBIT ,TAKEBIT ,CONTBIT ,BURNBIT>
	<>
	()
	(ODESC1 "There is a white book here."
	 OCAPAC 2
	 OSIZE 10
	 OREAD ,GREEK-TO-ME)>

<OBJECT ["WHWAL" "WALL" "PANEL"]
	["WHITE"]
	"white panel"
	<+ ,OVISON ,NDESCBIT>
	MPANELS>

<OBJECT ["WINDO"]
	[]
	"window"
	<+ ,OVISON ,DOORBIT ,NDESCBIT>
	WINDOW-FUNCTION>

<OBJECT ["FUSE" "COIL" "WIRE"]
	["SHINY" "THIN"]
	"wire coil"
	<+ ,OVISON ,TAKEBIT ,BURNBIT>
	FUSE-FUNCTION
	()
	(ODESC1 "There is a coil of thin shiny wire here."
	 OSIZE 1
	 OLINT [0 <CLOCK-DISABLE <CLOCK-INT ,FUSIN 2>>])>

<OBJECT ["WDBAR" "BAR"]
	["WOOD" "WOODE" "CROSS"]
	"wooden bar"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["BUCKE"]
	["WOODE"]
	"wooden bucket"
	<+ ,OVISON ,VEHBIT ,OPENBIT>
	BUCKET
	()
	(ODESC1 
"There is a wooden bucket here, 3 feet in diameter and 3 feet high."
	 OCAPAC 100
	 OSIZE 100
	 OVTYPE ,RBUCKBIT)>

<OBJECT ["QDOOR" "DOOR"]
	["WOOD" "WOODE"]
	"wooden door"
	<+ ,OVISON ,DOORBIT ,NDESCBIT>
	WOOD-DOOR>

<OBJECT ["POSTS" "POST"]
	["WOODE"]
	"group of wooden posts"
	<+ ,OVISON>>

<OBJECT ["WRENC"]
	[]
	"wrench"
	<+ ,OVISON ,TAKEBIT ,TOOLBIT>
	<>
	()
	(ODESC1 "There is a wrench here."
	 OSIZE 10)>

<OBJECT ["YLWAL" "WALL" "PANEL"]
	["YELLO"]
	"yellow panel"
	<+ ,OVISON ,NDESCBIT>
	MPANELS>

<OBJECT ["TCHST" "CHEST"]
	["TOOL"]
	"group of tool chests"
	<+ ,OVISON ,NDESCBIT>
	TOOL-CHEST>

<OBJECT ["CPANL" "PANEL"]
	["CONTR"]
	"control panel"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["BROCH"]
	["FREE"]
	"free brochure"
	<+ ,OVISON ,TAKEBIT ,BURNBIT ,CONTBIT ,OPENBIT ,READBIT>
	BROCHURE
	(<GET-OBJ "DSTMP">)
	(ODESCO "In the mailbox is a large brochure."
	 ODESC1 "There is a large brochure here."
	 OSIZE 30
	 OCAPAC 1)>

<OBJECT ["DSTMP" "STAMP"]
	["DON" "WOODS" "DWOOD"]
	"Don Woods stamp"
	<+ ,OVISON ,TAKEBIT ,BURNBIT ,READBIT>
	BROCHURE
	()
	(ODESC1 "There is a Don Woods Commemorative stamp here."
	 OSIZE 1
	 OTVAL 1
	 OREAD
"
---v----v----v----v----v---
|	  _______	  |
>  One	 /  	 \\     G  <
| Lousy /   	  \\    U  |
> Point	|   ___   |    E  <
|	|  (___)  |	  |
>	<--)___(-->    P  <
|	/ /	\\ \\    o  |
>      / /	 \\ \\   s  <
|     |-|---------|-|  t  |
>     | |  \\ _ /  | |  a  <
|     | | --(_)-- | |  g  |
>     | |  /| |\\  | |  e  <
|     |-|---|_|---|-|	  |
>      \\ \\__/_\\__/ /	  <
|	_/_______\\_	  |
>      |  f.m.l.c. |	  <
|      -------------	  |
>			  <
|   Donald Woods, Editor  |
>     Spelunker Today	  <
|			  |
---^----^----^----^----^---")>
	 
\
; "SUBTITLE BANK OBJECTS"

<OBJECT ["BILLS" "STACK" "PILE"]
	["NEAT" "200" "ZORKM"]
	"stack of zorkmid bills"
	<+ ,OVISON ,READBIT ,TAKEBIT ,BURNBIT>
	BILLS-OBJECT
	()
	(ODESC1
	 "200 neatly stacked zorkmid bills are here."
	 ODESCO
	 "On the floor sit 200 neatly stacked zorkmid bills."
	 OSIZE 10
	 OTVAL 15
	 OFVAL 10
	 OREAD
"
______________________________________________________________
| 1  0   0          GREAT UNDERGROUND EMPIRE         1  0   0 |
| 1 0 0 0 0					     1 0 0 0 0|
| 1 0 0 0 0					     1 0 0 0 0|
| 1  0   0		    DIMWIT		     1  0   0 |
|	               ||||||||||||||||	  		      |
|		       ||   __  __   ||		   B30332744D |
|		       ||  -OO  OO-  ||	  		      |
|	IN  FROBS      \\||    >>    ||/	    WE  TRUST         |
|		        ||  ______  ||	       		      |
| B30332744D	         |  ------  |	       		      |
|                        \\\\________//	       		      |
| 1  0   0    Series	   FLATHEAD	LD Flathead  1  0   0 |
| 1 0 0 0 0   719GUE	   		 Treasurer   1 0 0 0 0|
| 1 0 0 0 0 					     1 0 0 0 0|
| 1  0   0	  One Hundred Royal Zorkmids	     1  0   0 |
|_____________________________________________________________|

")>
	 
<OBJECT ["PORTR" "PAINT" "ART"]
	["FLATH"]
	"portrait of J. Pierpont Flathead"
	<+ ,OVISON ,READBIT ,TAKEBIT ,BURNBIT>
	<>
	()
	(ODESC1
	 "The portrait of J. Pierpont Flathead is here."
	 ODESCO
	 "A portrait of J. Pierpont Flathead hangs on the wall."
	 OSIZE 25
	 OTVAL 5
	 OFVAL 10
	 OREAD
	 
" 		    
	             ||||||||||||||
		    ||   __  __   ||
		    ||	 $$  $$   ||
		    \\||	   >>    ||/
		     ||  ______  ||	       
		      |  -//--   |	       
		      \\\\_//_____//	       
	 	     ___//|  |	
		    /__// |  |
			  |  |
	       __________//  \\\\__________
	      / $ /	  ****	     \\ $ \\
	     /   /	   **	      \\   \\
	    /	/|	   **	      |\\   \\
	   /   / |	   **	      | \\   \\
	  /   /  |         **         |  \\   \\
	  ^   ^__|______$Z$**$Z$______|___^   ^
	  \\   	    *	$Z$**$Z$   *	     /
	   \\________*___$Z$**$Z$___*________/
		 |	$Z$**$Z$      |

 	 	 J.  PIERPONT  FLATHEAD
			CHAIRMAN
")>

<OBJECT ["VAULT" "CUBE" "LETTE"]
	["STONE" "LARGE"]
	"large stone cube"
	<+ ,OVISON ,READBIT>
	<>
	()
	(OREAD
	 
"	        Bank of Zork
		   VAULT
         	 *722 GUE*
          Frobozz Magic Vault Company
")>

<OBJECT ["SCOL" "CURTA" "LIGHT"]
	["SHIMM"]
	"shimmering curtain of light"
	,OVISON
	SCOL-OBJECT>

<OBJECT ["ZGNOM" "GNOME"]
	["ZURIC"]
	"Gnome of Zurich"
	<+ ,OVISON ,VICBIT ,VILLAIN>
	ZGNOME-FUNCTION
	()
	(ODESC1 "There is a Gnome of Zurich here.")>

\
;"SUBTITLE FOREST OBJECTS"

<OBJECT ["NEST"]
	["BIRDS" "SMALL"]
	"birds nest"
	<+ ,OVISON ,TAKEBIT ,BURNBIT ,OPENBIT>
	<>
	(<GET-OBJ "EGG">)
	(ODESC1 "There is a small birds nest here."
	 ODESCO "On the branch is a small birds nest."
	 OCAPAC 20)>

<OBJECT ["EGG"]
	["BIRDS" "ENCRU"]
	"jewel-encrusted egg"
	<+ ,OVISON ,TAKEBIT ,CONTBIT>
	EGG-OBJECT
	(<GET-OBJ "GCANA">)
	(OFVAL 5
	 OTVAL 5 
	 ODESC1 "There is a jewel-encrusted egg here."
	 OCAPAC 6
	 ODESCO
"In the bird's nest is a large egg encrusted with precious jewels,
apparently scavenged somewhere by a childless songbird.  The egg is 
covered with fine gold inlay, and ornamented in lapis lazuli and
mother-of-pearl.  Unlike most eggs, this one is hinged and has a
delicate looking clasp holding it closed.  The egg appears extremely
fragile.")>

<OBJECT ["BEGG" "EGG"]
	["BROKE" "BIRDS" "ENCRU"]
	"broken jewel-encrusted egg"
	<+ ,OVISON ,TAKEBIT ,CONTBIT ,OPENBIT>
	<>
	(<GET-OBJ "BCANA">)
	(OCAPAC 6
	 ODESC1 "There is a somewhat ruined egg here.")>

<OBJECT ["BAUBL"]
	["BRASS" "BEAUT"]
	"beautiful brass bauble"
	<+ ,OVISON ,TAKEBIT>
	<>
	()
	(OFVAL 1
	 OTVAL 1
	 ODESC1 "There is a beautiful brass bauble here.")>

<OBJECT ["GCANA" "CANAR"]
	["CLOCK" "MECHA" "GOLD" "GOLDE"]
	"clockwork canary"
	<+ ,OVISON ,TAKEBIT>
	CANARY-OBJECT
	()
	(OFVAL 6
	 OTVAL 2
	 ODESC1 "There is golden clockwork canary here."
	 ODESCO

"There is a golden clockwork canary nestled in the egg.  It has ruby
eyes and a silver beak.  Through a crystal window below its left
wing you can see intricate machinery inside.  It appears to have
wound down.")>

<OBJECT ["BCANA" "CANAR"]
	["BROKE" "CLOCK" "MECHA" "GOLD" "GOLDE"]
	"broken clockwork canary"
	<+ ,OVISON ,TAKEBIT>
	CANARY-OBJECT
	()
	(ODESC1 "There is a non-functional canary here."
	 ODESCO

"There is a golden clockwork canary nestled in the egg.  It seems to
have recently had a bad experience.  The mountings for its jewel-like
eyes are empty, and its silver beak is crumpled.  Through a cracked
crystal window below its left wing you can see the remains of
intricate machinery.  It is not clear what result winding it would
have, as the mainspring seems sprung.")>

\ 

;"SUBTITLE CHINESE PUZZLE OBJECTS"

<OBJECT ["WARNI" "NOTE" "PAPER" "PIECE"]
	[]
	"note of warning"
	<+ ,OVISON ,TAKEBIT ,READBIT ,BURNBIT>
	<>
	()
	(ODESC1
	 "There is a piece of paper on the ground here."
	 OREAD
	 "
The paper is rather worn; although the writing is barely legible (the
author probably had only a used pencil), it is a very elegant
copperplate.
 
To Whom It May Concern:

     I regret to report that the rumours regarding treasure contained
in the chamber to which this passage leads have no basis in fact.
Should you nevertheless be sufficiently foolhardy to enter, it will
be quite impossible for you to exit.
				
				Sincerely yours,
				The Thief
")>

<PUT <OBJECT ["CPSLT" "SLIT" "SLOT"]
	["SMALL"]
	"small slit"
	<+ ,OVISON ,NDESCBIT>
	CPSLT-OBJECT
	()
	(OCAPAC 4)>
     ,OROOM <GET-ROOM "CP">>

<TRO <FIND-OBJ "CPSLT"> ,OPENBIT>

<OBJECT ["CPDR2" "DOOR"]
	["STEEL"]
	"steel door"
	<+ ,OVISON ,NDESCBIT>>

<PUT <OBJECT ["CPDOR" "DOOR"]
	["STEEL"]
	"steel door"
	<+ ,OVISON ,NDESCBIT>>
     ,OROOM <GET-ROOM "CP">>

<PUT <OBJECT ["GCARD" "CARD"]
	["GOLD"]
	"gold card"
	<+ ,TAKEBIT ,OVISON ,READBIT>
	<>
	()
	(ODESC1
	 "There is a solid gold engraved card here."
	 ODESCO
	 "Nestled inside the niche is an engraved gold card."
	 OREAD
	 "
 ____________________________________________________________
|							     |
|              FROBOZZ MAGIC SECURITY SYSTEMS		     |
|    Door Pass                  Royal Zork Puzzle Museum     |
|							     |
|                     #632-988-496-XTHF			     |
|							     |
|							     |
|     USE OF THIS PASS BY UNAUTHORIZED PERSONS OR AFTER	     |
|   EXPIRATION DATE WILL RESULT IN IMMEDIATE CONFISCATION    |
|							     |
|							     |
|                              (approved)		     |
|                              Will Weng		     |
|                               789 G.U.E.		     |
|							     |
|                                        Expires 792 G.U.E.  |
|____________________________________________________________|
"
	 OTVAL
	 15
	 OFVAL
	 10
	 OSIZE
	 4)> ,OROOM <GET-ROOM "CP">>

\
; "SUBTITLE PALANTIR OBJECTS"


<SETG SMALL-PAPERS ![<GET-OBJ "BLABE"> <GET-OBJ "LABEL"> <GET-OBJ "CARD">
		     <GET-OBJ "WARNI"> <GET-OBJ "PAPER"> <GET-OBJ "GUIDE">]>
  
<SETG PALOBJS ![<GET-OBJ "SCREW"> <GET-OBJ "KEYS">
		<GET-OBJ "STICK"> <GET-OBJ "PKEY">]>

<OBJECT ["PDOOR" "DOOR"]
	["WOODE" "OAK"]
	"door made of oak"
	<+ ,OVISON ,DOORBIT ,CONTBIT>
	PDOOR-FUNCTION>

<OBJECT ["PWIND" "WINDO"]
	["BARRE"]
	"barred window"
	<+ ,OVISON ,DOORBIT>
	PWIND-FUNCTION>

<OBJECT ["PLID1" "LID"]
	["METAL"]
	"metal lid"
	<+ ,OVISON ,NDESCBIT ,CONTBIT>
	PLID-FUNCTION>

<OBJECT ["PLID2" "LID"]
	["METAL"]
	"metal lid"
	<+ ,OVISON ,NDESCBIT ,CONTBIT ,OPENBIT>
	PLID-FUNCTION>

<OBJECT ["PTABL" "TABLE"]
	["DUSTY" "WOODE"]
	"table"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["PCRAK" "CRACK"]
	["NARRO"]
	"narrow crack"
	<+ ,OVISON ,NDESCBIT>>

<OBJECT ["PKH1" "KEYHO" "HOLE"]
	[]
	"keyhole"
	<+ ,OVISON ,NDESCBIT ,OPENBIT>
	PKH-FUNCTION
	()
	(OCAPAC 12)>

<OBJECT ["PKH2" "KEYHO" "HOLE"]
	[]
	"keyhole"
	<+ ,OVISON ,NDESCBIT ,OPENBIT>
	PKH-FUNCTION
	(<GET-OBJ "PKEY">)
	(OCAPAC 12)>

<OBJECT ["PKEY" "KEY"]
	["IRON" "RUSTY"]
	"rusty iron key"
	<+ ,OVISON ,TAKEBIT ,NDESCBIT ,TURNBIT ,TOOLBIT>
	PKEY-FUNCTION
	()
	(ODESCO "" ODESC1 "There is a rusty iron key here.")>

<OBJECT ["PALAN" "STONE" "SPHER"]
	["GLASS" "SEEIN" "CRYST" "BLUE"]
	"blue crystal sphere"
	<+ ,OVISON ,TAKEBIT>
	PALANTIR
	()
	(OTVAL 5
	 OFVAL 10
	 ODESCO
	 "In the center of the table sits a blue crystal sphere."
	 ODESC1
	 "There is blue crystal sphere here.")>

<OBJECT ["MAT"]
	["WELCO" "RUBBE"]
	"welcome mat"
	<+ ,OVISON ,TAKEBIT ,READBIT>
	MAT-FUNCTION
	()
	(ODESCO
	 "A rubber mat saying 'Welcome to Zork!' lies by the door."
	 ODESC1
	 "There is a welcome mat here."
	 OREAD
	 "Welcome to Zork!"
	 OSIZE
	 12
	 )>

<OBJECT ["STOVE"]
	["OLD"]
	"old coal stove"
	<+ ,OVISON ,NDESCBIT ,FLAMEBIT ,ONBIT>
	STOVE-FUNCTION>

<OBJECT ["PAL3" "PALAN" "STONE" "SPHER"]
	["GLASS" "SEEIN" "CRYST" "RED"]
	"red crystal sphere"
	<+ ,OVISON ,TAKEBIT>
	PALANTIR
	()
	(OTVAL 5
	 OFVAL 10
	 ODESCO
	 "On the floor sits a red crystal sphere."
	 ODESC1
	 "There is red crystal sphere here.")>

\

;"SUBTITLE LISTS OF OBSCURE ROOMS"

; "Where your objects go when you die."

<SETG RANDOM-LIST
      (<GET-ROOM "LROOM">
       <GET-ROOM "KITCH">
       <GET-ROOM "CLEAR">
       <GET-ROOM "FORE3">
       <GET-ROOM "FORE2">
       <GET-ROOM "SHOUS">
       <GET-ROOM "FORE2">
       <GET-ROOM "KITCH">
       <GET-ROOM "EHOUS">)>

\

; "SUBTITLE LISTS OF VILLAINS AND WEAPONRY"

<SETG WEAPONS (<GET-OBJ "STICK"> <GET-OBJ "KNIFE"> <GET-OBJ "SWORD">
	       <GET-OBJ "RKNIF">)>

<SETG VILLAINS (<GET-OBJ "TROLL"> <GET-OBJ "THIEF"> <GET-OBJ "CYCLO">)>

<SETG VILLAIN-PROBS <IUVECTOR <LENGTH ,VILLAINS> 0>>

<SETG BEST-WEAPONS
      [<GET-OBJ "TROLL"> <GET-OBJ "SWORD"> 1
       <GET-OBJ "THIEF"> <GET-OBJ "KNIFE"> 1]>

<SETG OPPV <IVECTOR <LENGTH ,VILLAINS> '<>>>

\

; "SUBTITLE DEMONS"

<ADD-DEMON
     <SETG ROBBER-DEMON
	   <CHTYPE [ROBBER () ,ROOMS <1 ,ROOMS> <GET-OBJ "THIEF"> <>]
		   HACK>>>

<ADD-DEMON
     <SETG SWORD-DEMON
	   <CHTYPE [SWORD-GLOW ,VILLAINS () <1 ,ROOMS> <GET-OBJ "SWORD"> <>]
		   HACK>>>

<ADD-DEMON
     <SETG FIGHT-DEMON
	   <CHTYPE [FIGHTING ,VILLAINS () <1 ,ROOMS> <GET-OBJ "TROLL"> <>]
		   HACK>>>

\

; "SUBTITLE END GAME QUESTIONS"

<ADD-QUESTION 
"From which room can one enter the robber's hideaway without passing
through the cyclops room?" ["TEMPL"]>

<ADD-QUESTION 
"Beside the Temple, to which room is it possible to go from the Altar?"
	["FORES"]>

<ADD-QUESTION 
"What is the absolute minimum specified value of the Zork treasures,
in Zorkmids?" ["30003"]>

<ADD-QUESTION
"What object is of use in determining the function of the iced cakes?"
	[<GET-OBJ "FLASK">]>

<ADD-QUESTION
"What can be done to the Mirror that is useful?" [<PLOOKUP "RUB" ,ACTIONS-POBL>]>

<ADD-QUESTION
"The taking of which object offends the ghosts?" [<GET-OBJ "BONES">]>

<ADD-QUESTION "What object in the Dungeon is haunted?" [<GET-OBJ "RKNIF">]>

<ADD-INQOBJ <GET-OBJ "KNIFE">>

<ADD-QUESTION "In which room is 'Hello, Sailor!' useful?" ["NONE" "NOWHE"]>

