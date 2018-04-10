set emulator_escape "\005"

proc start_salv {} {
    uplevel #0 {spawn ./tools/sims/BIN/ka10 build/sims/init}
    expect "MAGDMP\r\n"; send "l\033ddt\r"
    expect "\n"; send "t\033salv\r"
}

proc start_dskdmp args {
    puts [llength $args]
    quit_emulator
    set ini ""
    if {[llength $args] == 1} {
        set ini [lindex $args 0]
    } {
        set ini "build/sims/boot2"
    }
    set foo "spawn ./tools/sims/BIN/ka10 $ini"
    uplevel #0 $foo
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

proc quit_emulator {} {
    respond "sim>" "q\r"
}

proc initialize_comsat {} {
    # commented out because you cannot run COMSAT initialization without network
    # support
    #respond "*" ":job comsat\r"
    #respond "*" ":load .mail.;comsat launch\r"
    #respond "*" "debug/-1\r"
    #type "mfinit\033g"
}

source build/ka10/include.tcl
source build/build.tcl
