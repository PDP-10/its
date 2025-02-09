log_progress "ENTERING BUILD SCRIPT: MUDDLE"

mkdir "mudsav"

proc build_muddle {dir version} {
	cwd "$dir"

	respond "*" ":xfile mud$version assem\r"
	expect -timeout 300 "Assembly done!"

	respond "*" ":mudsys;stink\r"
	respond "STINK." "MMUD$version STINK\033@\033\033"
	expect  "SETPUR"
	respond "\n" "D\033\033"
	respond "\n" ":xfile mud$version init\r"
	expect -timeout 100 "Init done!"
}

build_muddle "muds54" "54"
build_muddle "mudsys" "56"

# Generate SAV FILE and FIXUP FILE for Muddle pure code library
midas "mudsys; ts mksvfl" "mudsys;mksvfl"

# Run mksvfl to create pure library for MDL 54 for the purposes of the 500-point zork
midas "sys3; ts mudinq" "sysen2; mudinq"
respond "*" ":link sys3; ts purge, sys3; ts mudinq\r"
respond "*" ":link sys3; ts makscr, sys3; ts mudinq\r"
respond "*" ":link sys3; ts status, sys3; ts mudinq\r"
respond "*" ":link sys3; ts whomud, sys3; ts mudinq\r"

respond "*" ":link sys3; ts mdl,mudsav; ts mud56\r"
respond "*" ":link sys3; ts muddle,mudsav; ts mud56\r"

midas "sys3; ts mudcom" "sysen3; mudcom" {
    respond "(Y OR N)" "Y\r"
}
respond "*" ":link sys3; ts mudchk, sys3; ts mudcom\r"
respond "*" ":link sys3; ts mudlst, sys3; ts mudcom\r"
respond "*" ":link sys3; ts mudfnd, sys3; ts mudcom\r"

midas "sys3; ts combat" "sysen3; combat" {
    respond "(Y OR N)" "Y\r"
}

midas "sys3; ts pick" "sysen2; pick"

respond "*" ":link sys1;ts mud55,mudsav;ts mud55\r"

#Build Muddle PCOMP compiler.
midas "sys1;ts pcomp" "mudsys;subsys maker" {
    respond "Type in Subsystem (Save File) name:" "pcomp\r"
    respond "Type Y if you wish to have Save File directly restored:" "y\r"
    respond "Type Second Name of Save File:" "55save\r"
    respond "Type Sname of Save File:" "mudsav\r"
}

#Build Muddle ASSEM assembler.
midas "sys1;ts assem" "mudsys;subsys maker" {
    respond "Type in Subsystem (Save File) name:" "assem\r"
    respond "Type Y if you wish to have Save File directly restored:" "y\r"
    respond "Type Second Name of Save File:" "55save\r"
    respond "Type Sname of Save File:" "mudsav\r"
}

mkdir "mbprog"
respond "*" ":assem \"mprog2;lsrtns >\" \"mbprog;lsrtns nbin\"\r"
expect ":KILL"
midas "mudsys;ts dem" "mudsys;itsdem"

# Build Muddle ECOMP compiler (PCOMP isn't good enough)
midas "sys1;ts ecomp" "mudsys;subsys maker" {
    respond "Type in Subsystem (Save File) name:" "ecomp\r"
    respond "Type Y if you wish to have Save File directly restored:" "y\r"
    respond "Type Second Name of Save File:" "55save\r"
    respond "Type Sname of Save File:" "mudsav\r"
}

# Build DM Daemons (COMBAT ZONE, BATCHN). GUNNER is already built in dm.tcl

# Build COMBAT ZONE (ZONE)
respond "*" ":assem \"combat;privat >\" \"combat;privat nbin\"\r"
expect ":KILL"

respond "*" ":ecomp\r"
respond "T" "<FILE-COMPILE \"combat;master >\" \"combat;master nbin\">\033"
respond "Job ECOMP wants the TTY" "\033p"
respond "I'm done anyway." "<QUIT>\033"
expect ":KILL"

respond "*" ":ecomp\r"
respond "T" "<FLOAD \"combat;master nbin\">\033"
respond "\"DONE\"" "<SNAME \"\">\033"
respond "\"\"" "<PROG () \n\i<SAVE \"mudsav;zone 55save\">\r"
type "\i<BATCH-COMPIL>\r>\033"
respond "#FALSE ()" "<QUIT>\033"
expect ":KILL"

midas "sys;atsign zone" "mudsys;subsys maker" {
    respond "Type in Subsystem (Save File) name:" "zone\r"
    respond "Type Y if you wish to have Save File directly restored:" "y\r"
    respond "Type Second Name of Save File:" "55save\r"
    respond "Type Sname of Save File:" "mudsav\r"
}

# Build BATCHN daemon

respond "*" ":ecomp\r"
respond "T" "<SNAME \".batch\">\033"
respond "\".batch\"" "<FILE-COMPILE \"templt >\" \"templt nbin\">\033"
respond "Job ECOMP wants the TTY" "\033p"
respond "I'm done anyway." "<FILE-COMPILE \"tcheck >\" \"tcheck nbin\">\033"
respond "Job ECOMP wants the TTY" "\033p"
respond "I'm done anyway." "<FILE-COMPILE \"taskm >\" \"taskm nbin\">\033"
expect -timeout 600 "Job ECOMP wants the TTY"
type "\033p"
respond "I'm done anyway." "<FILE-COMPILE \"batchq >\" \"batchq nbin\">\033"
respond "Job ECOMP wants the TTY" "\033p"
respond "I'm done anyway." "<FILE-COMPILE \"batchn >\" \"batchn nbin\">\033"
expect -timeout 600 "Job ECOMP wants the TTY"
type "\033p"
respond "I'm done anyway." "<QUIT>\033"
expect ":KILL"

respond "*" ":mud55\r"
respond "LISTENING-AT-LEVEL 1 PROCESS 1" "<SNAME \".batch\">\033"
respond "\".batch\"" "<FLOAD \"batchn maker\">\033"
respond "\"DONE\"" "<SAVER T>\033"
respond "TO CREATE SAVE FILE\"" "<QUIT>\033"
expect ":KILL"

midas "sys;atsign batchn" "mudsys;subsys maker" {
    respond "Type in Subsystem (Save File) name:" "batchn\r"
    respond "Type Y if you wish to have Save File directly restored:" "y\r"
    respond "Type Second Name of Save File:" "save\r"
    respond "Type Sname of Save File:" ".batch\r"
}

# Now build BATCH user program (interfaces with BATCHN daemon)

respond "*" ":link libmud;pmap fbin,mbprog;pmap fbin\r"

respond "*" ":ecomp\r"
respond "T" "<SNAME \".batch\">\033"
respond "\".batch\"" "<FILE-COMPILE \"nbatch >\" \"nbatch nbin\">\033"
expect -timeout 600 "Job ECOMP wants the TTY"
type "\033p"
respond "I'm done anyway." "<QUIT>\033"
expect ":KILL"

respond "*" ":mud55\r"
respond "LISTENING-AT-LEVEL 1 PROCESS 1" "<FLOAD \".batch;nbatch nbin\">\033"
respond "\"DONE\"" "<DUMPCAL!-MUDCAL!-PACKAGE B11 \".batch;nbatch 55save\">\033"
respond "\"SAVED\"" "<QUIT>\033"
expect ":KILL"

midas "sys3;ts batch" "mudsys;subsys maker" {
    respond "Type in Subsystem (Save File) name:" "nbatch\r"
    respond "Type Y if you wish to have Save File directly restored:" "y\r"
    respond "Type Second Name of Save File:" "55save\r"
    respond "Type Sname of Save File:" ".batch\r"
}
