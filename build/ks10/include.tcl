proc start_dskdmp_its {} {
    global out
    start_dskdmp $out/minsys.tape

    respond "DSKDMP" "l\033ddt\r"
    respond "\n" "t\033its rp06\r"
    respond "\n" "\033u"
    respond "DSKDMP" "m\033salv rp06\r"
    respond "\n" "d\033its\r"
    respond "\n" "its\r"
    patch_its_and_go
}

proc mark_packs {} {
    respond "\n" "mark\033g"
    respond "Format pack on unit #" "0"
    respond "Are you sure you want to format pack on drive" "y"
    respond "Pack no ?" "0\r"
    respond "Verify pack?" "n"
    respond "Alloc?" "3000\r"
    respond "ID?" "foobar\r"
}

proc prepare_frontend {} {
    global emulator_escape
    global out

    type ":ksfedr\r"
    respond "File not found" "create\r"
    expect -re {Directory address: ([0-7]*)\r\n}
    set dir $expect_out(1,string)
    type "write\r"
    respond "Are you sure" "yes\r"
    respond "Which file" "ram\r"
    expect "Input from"
    sleep 1
    respond ":" ".;ram ram\r"
    respond "!" "write\r"
    respond "Are you sure" "yes\r"
    respond "Which file" "bt\r"
    expect "Input from"
    sleep 1
    respond ":" ".;bt rp06\r"
    respond "!" "quit\r"
    expect ":KILL"
    shutdown

    restart_nsalv

    expect "\n"
    sleep 1
    type "feset\033g"
    respond "on unit #" "0"
    respond "address: " "$dir\r"
    respond "DDT" $emulator_escape
    quit_emulator

    start_its
    respond "DSKDMP" "its\r"
    patch_its_and_go
    pdset

    respond "*" ":login db\r"
    sleep 1
    
    type $emulator_escape
    mount_tape "$out/minsrc.tape"
}

proc frontend_bootstrap {} {
    respond "*" ":midas sysbin;_kshack;ksfedr\r"
    expect ":KILL"
    respond "*" ":delete sys;ts ksfedr\r"
    respond "*" ":link sys;ts ksfedr,sysbin;ksfedr bin\r"

    respond "*" ":ksfedr\r"
    respond "!" "write\r"
    respond "Are you sure" "yes\r"
    respond "Which file" "bt\r"
    expect "Input from"
    sleep 1
    respond ":" ".;bt bin\r"
    respond "!" "quit\r"
    expect ":KILL"
}

proc its_switches {} {
    respond "MACHINE NAME =" "DB\r"
    respond "Configuration?" "RP06\r"
}

proc make_ntsddt {} {
    respond "*" ":midas dsk0:.;@ ddt_system;ddt\r"
    respond "cpusw" "3\r"
    respond "New One Proceed" "1\r"
    expect ":KILL"
}

proc make_salv {} {
    respond "*" ":midas dsk0:.;_kshack;nsalv\r"
    respond "Which machine?" "KSRP06\r"
    expect ":KILL"
}

proc make_dskdmp {} {
    respond "*" ":midas dsk0:.;_system;dskdmp\r"
    expect "Configuration"
    respond "?" "ksrp06\r"
    respond "Assemble BOOT?" "no\r"
    expect ":KILL"

    respond "*" ":midas dsk0:.;bt_system;dskdmp\r"
    expect "Configuration"
    respond "?" "ksrp06\r"
    respond "Assemble BOOT?" "yes\r"
    expect ":KILL"
}

proc dump_switches {} {
    respond "WHICH MACHINE?" "DB\r"
}

proc peek_switches {} {
    respond "with ^C" "\003"
}

proc dump_nits {} {
    # Run the new DSKDMP from disk here, to check that it works.
    respond "DSKDMP" "dskdmp bin\r"

    respond "DSKDMP" "l\033ddt\r"

    # Dump an executable @ NSALV.
    respond "\n" "t\033nsalv bin\r"
    respond "\n" "\033u"
    respond "DSKDMP" "d\033nsalv\r"

    # Now dump the new ITS.
    respond "\n" "t\033its bin\r"
    respond "\n" "\033u"
    respond "DSKDMP" "m\033nsalv bin\r"
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

    respond "*" ":link kshack;good ram,.;ram ram\r"
    respond "*" ":link kshack;ddt bin,.;@ ddt\r"
    respond "*" $emulator_escape
    create_tape "$out/ndskdmp.tape"
    type ":kshack;mtboot\r"
    respond "Write a tape?" "y"
    respond "Rewind tape first?" "y"
    respond "Include DDT?" "y"
    respond "Input file" ".;dskdmp bin\r"
    expect ":KILL"

    respond "*" $emulator_escape
    create_tape "$out/nnsalv.tape"
    type ":kshack;mtboot\r"
    respond "Write a tape?" "y"
    respond "Rewind tape first?" "y"
    respond "Include DDT?" "y"
    respond "Input file" ".;nsalv bin\r"
    expect ":KILL"
}

proc update_microcode {} {
    type ":ksfedr\r"
    respond "!" "write\r"
    respond "Are you sure" "yes\r"
    respond "Which file" "ram\r"
    expect "Input from"
    sleep 1
    respond ":" ".;ram ram\r"
    respond "!" "quit\r"
    expect ":KILL"
}

proc clib_switches {} {
    respond "with ^C" "KS10==1\r\003"
}

proc patch_lisp {} {
}

proc translate_diagnostics {} {
    # PART K doesn't work on the KS10.
    respond "*" "\033\024"
    respond " " "dsk: maint; part k, part l\r"
}

proc patch_clib_16 {} {
}

proc copy_to_klfe {file} {
}
