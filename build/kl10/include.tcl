proc start_dskdmp_its {} {
    start_dskdmp build/pdp10-kl/boot

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
    sleep 3

    # Since we bootstrap with a 1-pack ITS, we need to copy the MFD to
    # the fresh packs.
    respond "\n" "\033l"
    respond " " "salv bin\r"
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
    copy_to_klfe "ucode;u1 ram"
}

proc clib_switches {} {
    ### UFA or FIX?!?  Probably the latter.
    respond "with ^C" "\003"
}

proc patch_lisp {} {
}

proc translate_diagnostics {} {
    respond "*" "\033\024"
    respond " " "dsk: maint; part f, part f.old\r"
    respond "*" "\033\024"
    respond " " "dsk: maint; part g, part g.old\r"
    respond "*" "\033\024"
    respond " " "dsk: maint; part k, part k.old\r"
}

proc patch_clib_16 {} {
    respond "*" ":job clib\r"
    respond "*" "\033\060l"
    respond " " "c; \[clib\] 16\r"
    respond "*" "23237/"
    respond "FIX" "ufa 1,775763\n"
    respond "JRST" "tlo 2,777000\r"
    respond "\n" "23244/"
    respond "FIX" "ufa 1,775763\n"
    respond "MOVN" "tlo 2,777000\n"
    respond "JRST" "movn 2,2\r"
    respond "\n" "\033\060y"
    respond " " "c; \[clib\] 16\r"
    respond "*" ":kill\r"
}

proc copy_to_klfe {file} {
    respond "*" ":klfedr write $file\r"
    expect ":KILL"
}
