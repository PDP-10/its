proc dskdmp_switches {boot} {
    expect "Configuration"
    respond "?" "ksrp06\r"
    respond "Assemble BOOT?" "$boot\r"
}

proc peek_switches {} {
    respond "with ^C" "\003"
}

proc mark_packs {} {
    mark_pack "0" "0" "LC#0"
    mark_pack "1" "1" "LC#1"
    mark_pack "2" "2" "LC#2"
    mark_pack "3" "3" "LC#3"
    mark_pack "4" "4" "LC#4"
    mark_pack "5" "5" "LC#5"
    mark_pack "6" "6" "LC#6"
    mark_pack "7" "7" "LC#7"
}
