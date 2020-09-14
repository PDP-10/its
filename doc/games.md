# Games

### Adventure

There are three versions of Adventure installed: the original Crowther
version, a 350-point version, and a 448-point version.  To play them,
type one of:

- `:advent`
- `:games;adv350`
- `:games;adv448`

### Checkers

Checkers program by Alan Baisley. To play, type `:games;ckr`.

### ITSter

Donald Fisk wrote this implementation of a classic puzzle game for ITS
in 2002. To play, type `:q games;itster (init)`.

### Jotto

Two players, one of which is the computer, competes in first guessing
a five-letter word.  To play this, type `:jotto`.

### Mac Hack VI

This is Richard Greenblatt's chess program.  Type `:games;ocm` to play.
For instructions, see CHPROG; OCM ORDER.

There is also an older version `:games:c` which can draw the chess
board on a Type 340 display.  Type
<code>FANCY<kbd>TAB</kbd>2<kbd>Enter</kbd></code> to get the fanc
chess board.

### Maze

First multi-user first person shooter.  When logged in on an Imlac,
type `:games;maze c` to play.  The `c` is necessary to avoid
restrictions on when the game can be played.  Use `r` to start a robot
player.

Game controls are: Arrow keys to move around, ESC to fire, and TAB to
see the overhead view.  ^Z exits back to ITS.

### MAZLIB

This is a maze game for EMACS.  To play, start EMACS and type
<code><kbd>M-X</kbd>Load Library<kbd>$</kbd>mazlib</code>, then
<code><kbd>M-X</kbd> Maze Run</code>.

### MLIFE

This is a Conway Game of Life by Mike Speciner.  Type `:games;mlife` to
run it.

### Spacewar

This is a PDP-6/10 port of Steve Russell's PDP-1 game, using the Type
340 display.  It can run either standalone on a PDP-6 or 10, or in
timesharing on a PDP-10.

To run it standalone, start DSKDMP and type `spcwar`.  To run in
timesharing, type `:games;spcwar`.

Notes:

- Only the KA10 emulator can run this game.
- Remember to enable the Spacewar consoles (game controllers).  `set
  wcnsls enabled` in the emulator.
- Timesharing Spacewar doesn't work yet.

### Tech II

Chess program by Alan Baisley.  To play this, type `:games;chess2`. For
instructions, see CHPROG; CHESS2 ORDER.

### Trek

Star Trek simulation.  To play this, type `:games;trek`.

### TVWAR

Knight TV adaptation of Spacewar.  To play this, type `:games;tvwar`.

### Wumpus

Enter a cave and hunt a creature called a wumpus.  To play this, type
`:wumpus`.

### Zork

Classic text adventure game.  To play, type `zork^K`.  For more information,
see [madadv.info](madman/madadv.info) and [madadv.help](madman/madadv.info).
