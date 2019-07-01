proc start_dskdmp_its {} {
    start_dskdmp build/pdp10-kl/boot

    respond "DSKDMP" "ddt\r"
    respond "\n" "\033l"
    respond " " "its bin\r"
    respond "\n" "\033\033l"
    respond " " "salv bin\r"
    respond "\n" "\033y"
    respond " " "its\r"
    patch_its_and_go
}

proc mark_packs {} {
    respond "\n" "mark\033g"
    respond "UNIT #" "0"
    respond "#0?" "y"
    respond "NO =" "0\r"
    respond "ALLOC =" "3000\r"
    respond "PACK ID =" "0\r"

    respond "\n" "mark\033g"
    respond "UNIT #" "1"
    respond "#1?" "y"
    respond "NO =" "1\r"
    respond "ALLOC =" "3000\r"
    respond "PACK ID =" "1\r"

    respond "\n" "mark\033g"
    respond "UNIT #" "2"
    respond "#2?" "y"
    respond "NO =" "2\r"
    respond "ALLOC =" "3000\r"
    respond "PACK ID =" "2\r"
}

proc prepare_frontend {} {
}

proc frontend_bootstrap {} {
}

proc its_switches {} {
    respond "MACHINE NAME =" "KL\r"
}

proc make_ntsddt {} {
    # KL10 NTSDDT.
    respond "*" ":midas dsk0:.;@ ddt_system;ddt\r"
    respond "cpusw=" "0\r"
    respond "ndsk=" "1\r"
    respond "dsksw=" "3\r"
    respond "1PRSW=" "0\r"
    expect ":KILL"
}

proc make_salv {} {
    respond "*" ":midas dsk0:.;_system;salv\r"
    respond "time-sharing?" "n\r"
    respond "machine?" "KL\r"
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
    respond "RH10P=" "Y\r"
    respond "NUDSL=" "500.\r"
    respond "KS10P=" "N\r"
    respond "KL10P=" "N\r"
    expect ":KILL"
}

proc dump_switches {} {
    respond "WHICH MACHINE?" "KL\r"
}

proc peek_switches {} {
    respond "with ^C" "\003"
}

proc dump_nits {} {
    # Run the new DSKDMP from disk here, to check that it works.
    respond "DSKDMP" "dskdmp\r"

    respond "DSKDMP" "l\033ddt\r"

    # Dump an executable @ SALV.
    respond "\n" "t\033salv bin\r"
    respond "\n" "\033y"
    respond " " "salv\r"

    # Since we bootstrap with a 1-pack ITS, we need to copy the MFD to
    # the fresh packs.
    respond "\n" "\033l"
    respond " " "salv\r"
    respond "\n" "ucop\033g"
    respond "UNIT #" "0"
    respond "UNIT #" "1"
    respond "OK?" "Y"
    respond "DDT" "ucop\033g"
    respond "UNIT #" "0"
    respond "UNIT #" "2"
    respond "OK?" "Y"
    expect "DDT"

    # Now dump the new ITS.
    respond "\n" "\033l"
    respond " " "its bin\r"
    respond "\n" "\033\033l"
    respond " " "salv bin\r"
    respond "\n" "\033y"
    respond " " "nits\r"
}

proc magdmp_switches {} {
    respond "KL10P=" "n\r"
    respond "TM10BP=" "y\r"
    respond "340P=" "n\r"
}

proc bootable_tapes {} {
    global emulator_escape
    global out

    respond "*" ":midas .;magdmp bin.kl_syseng;magdmp\r"
    respond "PTRHRI=" "n\r"
    magdmp_switches
    expect ":KILL"

    respond "*" $emulator_escape
    create_tape "$out/magdmp.tape"

    type ":magfrm\r"
    respond "?" "KL\r"
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

proc clib_switches {} {
    ### UFA or FIX?!?  Probably the latter.
    respond "with ^C" "\003"
}

proc patch_lisp {} {
    respond "*" ":job lisp\r"
    respond "*" ":load .; @ lisp\r"
    respond "*" "33777//\031"
    respond "*" "\033q\033,777777\033\033z"
    respond "*" "pitele+13/"
    respond "FSC" "push p,b\n"
    respond "FSC" "jrst patch\r"
    respond "\n" "patch/"
    respond "0" "move b,echocc\n"
    respond "0" "add b,ticc\n"
    respond "0" "dpb b,.+3\n"
    respond "0" "pop p,b\n"
    respond "0" "jrst pitele+15\n"
    respond "0" "331000,,a\r"
    respond "\n" "\033y"
    respond " " "dsk0:.;@ lisp\r"
    respond "*" ":kill\r"
}

proc translate_diagnostics {} {
}

proc patch_clib_16 {} {
}
