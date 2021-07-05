if [info exists env(MCHN)] {
    set mchn "$env(MCHN)"
} else {
    #Default ITS name for KS10.
    set mchn "DB"
}

set cpu "ks10"
set salv "nsalv"

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

proc mark_pack {unit pack id} {
    respond "\n" "mark\033g"
    respond "Format pack on unit #" "$unit"
    respond "Are you sure you want to format pack on drive" "y"
    respond "Pack no ?" "$pack\r"
    respond "Verify pack?" "n"
    respond "Alloc?" "3000\r"
    respond "ID?" "$id\r"
}

proc mark_bootstrap_packs {} {
    mark_pack "0" "0" "foobar"
}

proc prepare_frontend {} {
    global emulator_escape
    global out

    patch_its_and_go
    pdset

    respond "*" ":login db\r"
    sleep 1

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

    start_dskdmp
    respond "DSKDMP" "nits\r"
    patch_its_and_go
    pdset

    respond "*" ":login db\r"
    sleep 1
    type ":vk\r"

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

    shutdown
    start_dskdmp "$out/sources.tape"
    respond "DSKDMP" "nits\r"
}

proc finish_mark {} {
    global emulator_escape
    global build
    global mchn
    global out

    # Here's a dance to get around the fact that the bootstrapping ITS
    # may have a different disk format from the target.  First save
    # all files to tape.  Next, run the new SALV to mark the disks
    # using the target format.  Finally load back the files from tape.

    respond "*" $emulator_escape
    create_tape "$out/reboot.tape"
    type ":dump\r"
    respond "_" "dump links full\r"
    respond "TAPE NO=" "0\r"
    expect -timeout 6000 "_"
    type "quit\r"

    respond "*" $emulator_escape
    quit_emulator
    start_salv

    mark_packs

    respond "DDT" $emulator_escape
    mount_tape "$out/reboot.tape"
    type "tran\033g"
    respond "#" "0"
    respond "OK" "y"
    expect -timeout 300 EOT
    respond "DDT" $emulator_escape
}

proc its_switches {} {
    global mchn

    respond "MACHINE NAME =" "$mchn\r"
    respond "Configuration?" "RP06\r"
}

proc make_ntsddt {} {
    respond "*" ":midas dsk0:.;@ ddt_system;ddt\r"
    respond "cpusw" "3\r"
    respond "dsktp=" "1\r"
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
    dskdmp_switches "no"
    expect ":KILL"

    respond "*" ":midas dsk0:.;bt_system;dskdmp\r"
    dskdmp_switches "yes"
    expect ":KILL"
}

proc dump_switches {} {
    global mchn
    respond "WHICH MACHINE?" "$mchn\r"
}

proc dump_nits {} {
    global salv

    # Run the new DSKDMP from disk here, to check that it works.
    respond "DSKDMP" "dskdmp bin\r"

    respond "DSKDMP" "l\033ddt\r"

    # Dump an executable @ NSALV.
    respond "\n" "t\033$salv bin\r"
    respond "\n" "\033u"
    respond "DSKDMP" "d\033$salv\r"

    # Now dump the new ITS.
    respond "\n" "t\033its bin\r"
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

proc clib_switches {} {
    respond "with ^C" "KS10==1\r\003"
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

proc comsat_switches {} {
    respond "Limit to KA-10 instructions" "n\r"
}

proc dqxdev_switches {} {
    respond "Limit to KA-10 instructions" "n\r"
}

proc processor_basics {} {
    # Create KS10 bootable tape.
    respond "*" ":midas kshack;ts mtboot_kshack;mtboot\r"
    expect ":KILL"
}
