#Default ITS name for KL10.
set mchn "KL"

set cpu "kl10"
set salv "salv"

proc start_dskdmp_its {} {
    global salv

    start_dskdmp build/pdp10-kl/boot

    sleep 3
    respond "\n" "\033l"
    respond " " "its bin\r"
    sleep 2
    respond "\n" "\033\033l"
    respond " " "$salv bin\r"
    respond "\n" "\033y"
    respond " " "its\r"
    patch_its_and_go
}

proc mark_packs {} {
    respond "\n" "mark\033g"
    respond "UNIT #" "0"
    respond "#0?" "y"
    respond "NO =" "0\r"
    expect -timeout 300 "VERIFICATION BEGINS"
    respond "ALLOC =" "3000\r"
    respond "PACK ID =" "0\r"

    respond "\n" "mark\033g"
    respond "UNIT #" "1"
    respond "#1?" "y"
    respond "NO =" "1\r"
    expect -timeout 300 "VERIFICATION BEGINS"
    respond "ALLOC =" "3000\r"
    respond "PACK ID =" "1\r"

    respond "\n" "mark\033g"
    respond "UNIT #" "2"
    respond "#2?" "y"
    respond "NO =" "2\r"
    expect -timeout 300 "VERIFICATION BEGINS"
    respond "ALLOC =" "3000\r"
    respond "PACK ID =" "2\r"
}

proc prepare_frontend {} {
}

proc frontend_bootstrap {} {
}

proc its_switches {} {
    global mchn

    respond "MACHINE NAME =" "$mchn\r"
}

proc make_ntsddt {} {
    # KL10 NTSDDT.
    respond "*" ":midas dsk0:.;@ ddt_system;ddt\r"
    respond "cpusw=" "2\r"
    respond "ndsk=" "3\r"
    respond "dsksw=" "3\r"
    respond "dsktp=" "0\r"
    respond "1PRSW=" "0\r"
    expect ":KILL"
}

proc make_salv {} {
    global mchn

    respond "*" ":midas dsk0:.;_system;salv\r"
    respond "time-sharing?" "n\r"
    respond "machine?" "$mchn\r"
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
    respond "RH10P=" "Y\r"
    respond "R10R6P=" "N\r"
    respond "NUDSL=" "500.\r"
    respond "KS10P=" "N\r"
    respond "KL10P=" "Y\r"
    expect ":KILL"
}

proc dump_switches {} {
    global mchn

    respond "WHICH MACHINE?" "$mchn\r"
}

proc peek_switches {} {
    respond "with ^C" "\003"
}

proc dump_nits {} {
    global salv

    sleep 3

    # Dump an executable @ SALV.
    respond "\n" "\033l"
    respond " " "$salv bin\r"
    respond "\n" "\033y"
    respond " " "$salv\r"

    # Since we bootstrap with a 1-pack ITS, we need to copy the MFD to
    # the fresh packs.
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
    respond " " "$salv bin\r"
    respond "\n" "\033y"
    respond " " "nits\r"
}

proc magdmp_switches {} {
    respond "KL10P=" "y\r"
    respond "TM10BP=" "y\r"
    respond "340P=" "n\r"
}

proc bootable_tapes {} {
    global emulator_escape
    global out
    global mchn

    respond "*" ":midas .;magdmp bin.${mchn}_syseng;magdmp\r"
    respond "PTRHRI=" "n\r"
    magdmp_switches
    expect ":KILL"

    respond "*" $emulator_escape
    create_tape "$out/magdmp.tape"

    type ":magfrm\r"
    respond "?" "$mchn\r"
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

proc clib_switches {} {
    ### UFA or FIX?!?  Probably the latter.
    respond "with ^C" "\003"
}

proc translate_diagnostics {} {
    # KL10 doesn't need any translations.
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

proc comsat_switches {} {
    respond "Limit to KA-10 instructions" "n\r"
}

proc dqxdev_switches {} {
    respond "Limit to KA-10 instructions" "n\r"
}

proc processor_basics {} {
}
