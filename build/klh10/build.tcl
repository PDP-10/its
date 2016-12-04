cd build/klh10

set emulator_prompt "KLH10"
set emulator_escape "\034"

proc start_nsalv {} {
    uplevel #0 {spawn ./kn10-ks-its nsalv.ini}
    expect "EOF"
    respond "KLH10#" "go\r"
}

proc restart_nsalv {} {
    quit_emulator
    start_nsalv
}

proc start_dskdmp {} {
    #respond "KLH10>" "zero\r"
    quit_emulator
    uplevel #0 {spawn ./kn10-ks-its dskdmp.ini}
    expect "EOF"
    respond "KLH10#" "go\r"
}

proc start_its {} {
    uplevel #0 {spawn ./kn10-ks-its dskdmp.ini}
    expect "EOF"
    respond "KLH10#" "go\r"
}

proc mount_tape {file} {
    respond "KLH10>" "devmo mta0 ../../$file\r"
    respond "KLH10>" "c\r"
}

proc create_tape {file} {
    respond "KLH10>" "devmo mta0 ../../$file create\r"
    respond "KLH10>" "c\r"
}

proc quit_emulator {} {
    respond "KLH10>" "quit\r"
    respond "Confirm" "y\r"
}

proc initialize_comsat {} {
    respond "*" ":job comsat\r"
    respond "*" ":load .mail.;comsat launch\r"
    respond "*" "debug/-1\r"
    type "mfinit\033g"
    respond "*" ":kill\r"
}

source ../build.tcl
