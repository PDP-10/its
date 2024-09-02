set build [pwd]/build
set out "out/$env(EMULATOR)"
set emulator_escape "\034"

proc start_salv args {
    set ini ""
    if {[llength $args] == 1} {
        set ini [lindex $args 0]
    } {
        set ini "build/pdp10-ka/init"
    }
    set foo "spawn ./tools/sims/BIN/pdp10-ka $ini"
    uplevel #0 $foo
    setup_timeout
    respond "MAGDMP\r\n" "l\033ddt\r"
    respond "\n" "t\033salv bin\r"
}

proc start_dskdmp args {
    global mchn

    quit_emulator
    set ini ""
    if {[llength $args] == 1} {
        set ini [lindex $args 0]
    } {
        set ini "build/mchn/$mchn/boot"
    }
    set foo "spawn ./tools/sims/BIN/pdp10-ka $ini"
    uplevel #0 $foo
    setup_timeout
}

proc mount_tape {file} {
    respond "sim>" "at mta0 $file\r"
    respond "sim>" "c\r"
    expect -timeout 2 "BUGPC/" {
        type "\033P"
    } timeout {
	;
    }
}

proc create_tape {file} {
    respond "sim>" "at mta0 $file\r"
    respond "sim>" "c\r"
    expect -timeout 2 "BUGPC/" {
        type "\033P"
    } timeout {
	;
    }
}

proc punch_tape {file} {
    respond "sim>" "at ptp $file\r"
    respond "sim>" "c\r"
}

proc quit_emulator {} {
    respond "sim>" "q\r"
    expect eof
}

proc initialize_comsat {} {
    respond "*" ":job comsat\r"
    respond "*" ":load .mail.;comsat launch\r"
    respond "*" "debug/-1\r"
    type "mfinit\033g"
	respond "Proceeding will launch Comsat" ":kill\r"
}

source build/ka10/include.tcl
source build/mchn/$mchn/mchn.tcl
source build/build.tcl
