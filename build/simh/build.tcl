set build [pwd]/build
set out "out/$env(EMULATOR)"
set emulator_escape "\034"

proc start_salv {} {
    uplevel #0 {spawn pdp10 build/simh/init}
    setup_timeout

    respond "sim>" "show ver\r"
    respond "sim>" "b tu1\r"
    expect "MTBOOT"
}

proc restart_nsalv {} {
    respond "sim>" "b tu1\r"
    expect "MTBOOT"
}

proc start_dskdmp args {
    global out
    set tape ""
    if {[llength $args] == 1} {
        set tape [lindex $args 0]
    } {
        set tape "$out/sources.tape"
    }
    respond "sim>" "at tu0 $tape\r"
    respond "sim>" "at tu2 $out/dskdmp.tape\r"
    respond "sim>" "b tu2\r"
    respond "MTBOOT" "\033g"
}

proc start_its {} {
    uplevel #0 {spawn pdp10 build/simh/boot}
    setup_timeout
}

proc mount_tape {file} {
    respond "sim>" "at tu0 $file\r"
    respond "sim>" "c\r"
}

proc create_tape {file} {
    respond "sim>" "at tu0 $file\r"
    respond "sim>" "c\r"
}

proc quit_emulator {} {
    respond "sim>" "q\r"
    expect eof
}

proc initialize_comsat {} {
    # commented out because you cannot run COMSAT initialization without network
    # support
    #respond "*" ":job comsat\r"
    #respond "*" ":load .mail.;comsat launch\r"
    #respond "*" "debug/-1\r"
    #type "mfinit\033g"
}

source build/ks10/include.tcl
source build/mchn/$mchn/mchn.tcl
source build/build.tcl
