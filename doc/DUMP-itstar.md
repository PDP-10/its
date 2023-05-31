# DUMP and itstar

### A note about emulators

ITS runs on many PDP-10 emulators, and they have various names for the
tape device.  KLH10 calls it `mta0`.  The SIMH based KA10 and KL10
emulators also call it `mta0`, but the KS10 "pdp10" emulator calls it
`tu0`, and the KS10 "pdp10-ks" emulator calls it `tua0`.  It's
important to use the right device name.  The instructions below spell
out each case explicitly.

### A note about file formats

PDP-10 files store 36 bits per word.  Text files store five characters
per word, plus one extra bit which may or may not be used.  This
presents a problem when storing PDP-10 files as a sequence of 8-bit
bytes, and this has been solved using many different encodings.  The
itstar program expects files to use the "ITS evacuate" encoding, which
makes text files look like normal Unix LF line ending files.  If files
use some other format, it's important to convert them to ITS evacuate
format before use with itstar.  This can be done with the `cat36`
program in the `tools/dasm` directory.  For example, to convert from
CR LF line endings, use `cat36 -Wascii -Xits`.

### Saving ITS files and extracting them using itstar

- Mount a tape image in the emulator.

  - Type Control-\\.

  - For KLH10, type

         devmount mta0 files.tape create
         continue

  - For SIMH KA10 or KL10, type

         attach mta0 files.tape
         continue

  - For SIMH KS10 "pdp10", type

         attach tu0 files.tape
         continue

  - For SIMH KS10 "pdp10-ks", type

         attach tua0 files.tape
         continue

- In ITS, type `:dump`.  At the _ prompt, type `dump`.  The `FILE=`
  prompt will accept directory and file names.  `*` can be used as a
  wild card.  Finish with an empty line.  When DUMP has finished
  writing the files, type `quit` to exit.

- Unmount the tape image.

  - Type Control-\\.

  - For KLH10, type

         devunmount mta0
         continue

  - For SIMH KA10 or KL10, type

         detach mta0
         continue

  - For SIMH KS10 "pdp10", type

         detach tu0
         continue

  - For SIMH KS10 "pdp10-ks", type

         detach tua0
         continue

- In the host, run itstar to extract the files:

       itstar -xf files.tape

### Moving host files to ITS

- Create one or more directories, and put the files in them.  There
  can not be directories inside directories.  For example, let's say
  you created the directories foo and bar.

- Run itstar to make a tape image:

       itstar -cf files.tape foo bar

- Mount the tape image in the emulator.

- Type Control-\\.

  - For KLH10, type

         devmount mta0 files.tape
         continue

  - For SIMH KA10 or KL10, type

         attach mta0 files.tape
         continue

  - For SIMH KS10 "pdp10", type

         attach tu0 files.tape
         continue

  - For SIMH KS10 "pdp10-ks", type

         attach tua0 files.tape
         continue

- In ITS, type `:dump`.  At the _ prompt, type `load crdir`.  (The
  `crdir` is to create new directories when necessary and may be
  omitted if all files go to existing directories.)  The `FILE=`
  prompt will accept file names as above.  `*` can be used as a wild
  card; for example `*; * *` to read all files.  Finish with an empty
  line.  If you need to load more files, type `rewind` to make another
  pass over the tape.  When you're finished, type `quit` to exit.

- Unmount the tape image as above.
