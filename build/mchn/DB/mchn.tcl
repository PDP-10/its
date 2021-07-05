proc dskdmp_switches {boot} {
    expect "Configuration"
    respond "?" "ksrp06\r"
    respond "Assemble BOOT?" "$boot\r"
}

proc peek_switches {} {
    respond "with ^C" "\003"
}

proc mark_packs {} {
    mark_pack "0" "0" "foobar"
}
