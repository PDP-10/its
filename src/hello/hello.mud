;"Hello world example for Muddle.  Load this file with FLOAD to make a"
;"HELLO SAVE file which can later be loaded into Muddle with RESTORE."

<DEFINE HELLO ()
  <PRINC "Hello, muddled world!">
  <TERPRI>
  <QUIT>>

<DEFINE SAVE-IT ()
  <COND (<=? <SAVE "HELLO SAVE"> "SAVED"> <QUIT>)>
  <HELLO>>

<SAVE-IT>
