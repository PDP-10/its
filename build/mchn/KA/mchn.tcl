proc dskdmp_switches {hriflg} {
    expect "Configuration"
    respond "?" "ASK\r"
    respond "HRIFLG=" "$hriflg\r"
    respond "BOOTSW=" "N\r"
    respond "R11R6P=" "N\r"
    respond "R11R7P=" "N\r"
    respond "RM03P=" "N\r"
    respond "RM80P=" "N\r"
    respond "RH10P=" "N\r"
    respond "DC10P=" "N\r"
    respond "NUDSL=" "500.\r"
    respond "KS10P=" "N\r"
    respond "KL10P=" "N\r"
}

proc peek_switches {} {
    respond "with ^C" "340P==1\r\003"
}

proc mark_packs {} {
    mark_pack "0" "2" "2"
    mark_pack "1" "3" "3"
    mark_pack "2" "0" "0"
    mark_pack "3" "1" "1"
}
