proc start_dskdmp_its {} {
    start_dskdmp build/sims/boot

    respond "DSKDMP" "its\r"
    patch_its_and_go
}

proc mark_packs {} {
    respond "\n" "mark\033g"
    respond "UNIT #" "0"
    respond "#0?" "y"
    respond "NO =" "2\r"
    expect -timeout 300 "VERIFICATION"
    respond "ALLOC =" "3000\r"
    respond "PACK ID =" "2\r"

    respond "\n" "mark\033g"
    respond "UNIT #" "1"
    respond "#1?" "y"
    respond "NO =" "3\r"
    expect -timeout 300 "VERIFICATION"
    respond "ALLOC =" "3000\r"
    respond "PACK ID =" "3\r"

    respond "\n" "mark\033g"
    respond "UNIT #" "2"
    respond "#2?" "y"
    respond "NO =" "0\r"
    expect -timeout 300 "VERIFICATION"
    respond "ALLOC =" "3000\r"
    respond "PACK ID =" "0\r"

    respond "DDT" "mark\033g"
    respond "UNIT #" "3"
    respond "#3?" "y"
    respond "NO =" "1\r"
    expect -timeout 300 "VERIFICATION"
    respond "ALLOC =" "3000\r"
    respond "PACK ID =" "1\r"
}

proc prepare_frontend {} {
}

proc frontend_bootstrap {} {
}

proc its_switches {} {
    respond "MACHINE NAME =" "KA\r"
}

proc make_ntsddt {} {
    respond "*" ":midas dsk0:.;@ ddt_system;ddt\r"
    respond "cpusw=" "0\r"
    respond "ndsk=" "0\r"
    respond "dsksw=" "0\r"
    expect ":KILL"
}

proc make_salv {} {
    respond "*" ":midas dsk0:.;@ salv_system;salv\r"
    respond "time-sharing?" "n\r"
    respond "machine?" "KA\r"
    expect ":KILL"
}

proc make_dskdmp {} {
    respond "*" ":midas dsk0:.;@ dskdmp_system;dskdmp\r"
    expect "Configuration"
    respond "?" "ASK\r"
    respond "HRIFLG=" "N\r"
    respond "BOOTSW=" "N\r"
    respond "RP06P=" "N\r"
    respond "RP07P=" "N\r"
    respond "RM03P=" "N\r"
    respond "RM80P=" "N\r"
    respond "RH10P=" "N\r"
    respond "DC10P=" "N\r"
    respond "NUDSL=" "250.\r"
    respond "KS10P=" "N\r"
    respond "KL10P=" "N\r"
    expect ":KILL"
}

proc dump_switches {} {
    respond "WHICH MACHINE?" "KA\r"
}

proc peek_switches {} {
    respond "with ^C" "340P==1\r\003"
}

proc dump_nits {} {
    # Run the new DSKDMP from disk here, to check that it works.
    respond "DSKDMP" "dskdmp\r"

    respond "DSKDMP" "l\033ddt\r"

    # Since we bootstrap with a 2-pack ITS, we need to copy the MFD to
    # the fresh packs.
    respond "\n" "t\033salv\r"
    respond "\n" "ucop\033g"
    respond "UNIT #" "0"
    respond "UNIT #" "2"
    respond "OK?" "Y"
    respond "DDT" "ucop\033g"
    respond "UNIT #" "0"
    respond "UNIT #" "3"
    respond "OK?" "Y"
    respond "DDT" "\033u"

    # Now dump the new ITS.
    respond "DSKDMP" "t\033its bin\r"
    respond "\n" "\033u"
    respond "DSKDMP" "m\033@ salv\r"
    respond "\n" "d\033nits\r"
}

proc magdmp_switches {} {
    respond "KL10P=" "n\r"
    respond "TM10BP=" "n\r"
    # 340P=y doesn't work yet.
    respond "340P=" "n\r"
}

proc bootable_tapes {} {
    global emulator_escape
    global out

    respond "*" ":midas .;magdmp bin.ka_syseng;magdmp\r"
    respond "PTRHRI=" "n\r"
    magdmp_switches
    expect ":KILL"

    respond "*" $emulator_escape
    create_tape "$out/magdmp.tape"

    type ":magfrm\r"
    respond "?" "KA\r"
    respond "?" "Y"
    respond "_" "W"
    respond "FROM" ".; @ DDT\r"
    respond "FILE" "@ DDT\r"
    respond "_" "W"
    respond "FROM" ".; @ SALV\r"
    respond "FILE" "@ SALV\r"
    respond "_" "W"
    respond "FROM" ".; @ DSKDMP\r"
    respond "FILE" "@ DSKDMP\r"
    respond "_" "Q"
    expect ":KILL"
}

proc update_microcode {} {
}
