.xgp
.font 0 30vr kst
.font 1 30vri kst
.font 2 36vbee kst
.spw 16
.adjust
.ds
.ce
2Dazzle Dart:
.ce
Reflections on Computer Games0
.ce
Harold Abelson
.ce
;Copyright (C) 1975 -- Harold Abelson, Andy diSessa, Nat Goodman
.sp
	One of the striking things about the current crop of
"educational computer games" is the generally tame and above
all 1stingy0 way in which they use computational resources.
Computer programs select random numbers, display game boards, and
prompt players to guess secret words or numbers.  In almost
every case these things can be done, not
to mention done better, without using a computer
at all.  It is
short-sighted and wasteful to have powerful machines simply replace
spinners, game boards and flash cards.
	The game of Spacewar is a notable
exception.  It is exciting, fast-moving and uses
the unique capabilities of computer-controlled graphics.
It is also anathema to large time-sharing systems and other
CPU-second Scrooges, and perhaps this is the reason why, in almost
fifteen years, Spacewar is the only game of its caliber which
has become widely known.  We would like to offer
Dazzle Dart as another illustration of a game which makes
effective use of interactive
computation.
	Dazzle Dart was designed and implemented at M.I.T.'s LOGO Lab by Hal
Abelson, Andy diSessa, and Nat
Goodman.  The basic idea
for the game, and the name as well,
come from Malcolm Jameson's 1941 science fiction story "Bullard Reflects."
Briefly, Dazzle Dart is a team game similar to hockey.  Instead of hitting a 
puck, the attacking team tries to shine a "beam of light" into a goal.
The players control moveable mirrors which are used to deflect the beam.  Since 
the beam moves "instantaneously" players must react to the entire 
configuration of all the "men" on the field.  The rules require teammates
to score, not
by "direct hits," but by setting up reflection patterns
among all the players.
(Figure 1)
.block 15
.sp 15
  The rules and 
parameters (size of playing field, size and speed of the pieces, etc.)
in the current M.I.T. version of Dazzle Dart have been arranged to 
make a good game for two teams of two players each, although we intend to experiment 
with larger teams.  Players can move vertically or horizontally
(or both at once),
rotate clockwise and counterclockwise,
and the player controlling the beam fire it or pass
it to his teammate.  All the action happens in "real time"
and with our current speed settings it takes about 5 seconds
for a player to move down the field or to rotate through 180 degrees.  The
playing field and starting positions are shown in Figure 2.  
Players may not move off the field or into the semicircular "forbidden zone" in front of 
each goal.  A team has 30 seconds in which to score, after which it loses control of the beam.
.block 15
.sp 15
.ss
.rline 16
1.  Goals count for one point.  In order to score, the beam must be
reflected at least once before hitting the goal.  The defending team can 
score a two-point "touchback" by deflecting the beam into the attacker's home goal.
.sp
2.  The beam will reflect at most twice.  If a player
is hit on the "third bounce" he gains
control of the beam.  This not only discourages firing at random but also allows the 
defending team to "steal the beam."  One effective way
to do this is to guard the player who has the beam
and move directly in front of and parallel to him at the moment of firing.  Stealing the beam resets the clock and
starts a new playing period.
.sp
3.  The player with the beam can instantaneously "pass" it
to his teammate by pressing a switch.  This
feature makes both team members equally dangerous.  In fact, a good
scoring tactic is for the 
attacking player who does not have the beam to set up for a shot and
then rapidly pass and 
fire.
.sp
.ds
.rline -16
	Here are some examples of how Dazzle Dart is played.  Figure
3 shows how the triangle team can score with a fast break from the 
opening position.  In Figure 4, however, we see that this allows double-square
to not only block the shot but to steal the beam for his teammate.  Figure
5 shows how the triangles could lose a point by both guarding single-square, 
who has the beam.  A pass would allow double-square
to easily score by
reflecting off the back
of single-triangle.  Finally in Figure 6 we see how a skillful block could turn this 
goal into a touchback.
.block 15
.sp 15
	There are, of course, many possible variations on
these rules.  We urge you to explore some of them, as well
as to invent even better computer games.  There is a serious issue
here for research in computers in education where "frivolous games"
often serve as models for more serious work.  As technology
makes the use of small
stand-alone computers more feasible than in the past, we
can begin to appreciate how often our work is limited, in
imagination as well as performance, by the economics of
time sharing.  Too much current work in CAI is modeled upon
Twenty Questions
and Tic-tac-toe.
