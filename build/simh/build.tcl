set emulator_escape "\005"

proc start_nsalv {} {
    uplevel #0 {spawn pdp10 build/simh/init}
    respond "sim>" "show ver\r"
    respond "sim>" "b tu1\r"
    expect "MTBOOT"
}

proc restart_nsalv {} {
    respond "sim>" "b tu1\r"
    expect "MTBOOT"
}

proc start_dskdmp {} {
    respond "sim>" "b tu2\r"
    respond "MTBOOT" "\033g"
}

proc start_its {} {
    uplevel #0 {spawn pdp10 build/simh/boot}
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
}

source build/build.tcl
