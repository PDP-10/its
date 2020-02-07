set salv "salv"

proc start_dskdmp_its {} {
    start_dskdmp build/pdp10-ka/boot

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
    respond "MACHINE NAME =" "TF\r"
}

proc make_ntsddt {} {
    respond "*" ":midas dsk0:.;@ ddt_system;ddt\r"
    respond "cpusw=" "0\r"
    respond "ndsk=" "0\r"
    respond "dsksw=" "0\r"
    respond "dsktp=" "0\r"
    respond "1PRSW=" "1\r"
    expect ":KILL"

    # Old NTS DDT with 340 support.
    respond "*" ":midas dsk0:.;@ ntsddt_syseng; ntsddt\r"
    expect ":KILL"
}

proc make_salv {} {
    respond "*" ":midas dsk0:.;_system;salv\r"
    respond "time-sharing?" "n\r"
    respond "machine?" "TF\r"
    expect ":KILL"
}

proc make_dskdmp {} {
    respond "*" ":midas dsk0:.;@ dskdmp_system;dskdmp\r"
    expect "Configuration"
    respond "?" "ASK\r"
    respond "HRIFLG=" "N\r"
    respond "BOOTSW=" "N\r"
    respond "R11R6P=" "N\r"
    respond "R11R7P=" "N\r"
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
    respond "WHICH MACHINE?" "TF\r"
}

proc peek_switches {} {
    respond "with ^C" "340P==1\r\003"
}

proc dump_nits {} {
    global salv

    # Run the new DSKDMP from disk here, to check that it works.
    respond "DSKDMP" "dskdmp\r"

    respond "DSKDMP" "l\033ddt\r"

    # Dump an executable @ SALV.
    respond "\n" "t\033$salv bin\r"
    respond "\n" "\033u"
    respond "DSKDMP" "d\033$salv\r"

    # Since we bootstrap with a 2-pack ITS, we need to copy the MFD to
    # the fresh packs.
    respond "\n" "$salv\r"
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
    respond "DSKDMP" "m\033$salv bin\r"
    respond "\n" "d\033nits\r"
    respond "\n" "g\033"
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

    respond "*" ":midas .;magdmp bin.tf_syseng;magdmp\r"
    respond "PTRHRI=" "n\r"
    magdmp_switches
    expect ":KILL"

    respond "*" $emulator_escape
    create_tape "$out/magdmp.tape"

    type ":magfrm\r"
    respond "?" "TF\r"
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
}

proc comsat_switches {} {
    respond "Limit to KA-10 instructions" "y\r"
}

proc dqxdev_switches {} {
    respond "Limit to KA-10 instructions" "y\r"
}
