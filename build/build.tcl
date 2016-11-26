proc type s {
    sleep .1
    foreach c [split $s ""] {
        send -- $c
        if [string match {[a-z]} $c] {
	    expect -nocase $c
	} else {
	    expect "?"
	}
	sleep .03
    }
}

proc respond { w r } {
    expect -exact $w
    type $r
}

proc pdset {} {
    type "\032"

    respond "Fair" ":pdset\r"
    set t [timestamp]
    respond "PDSET" [expr [timestamp -seconds $t -format "%Y"] / 100]C
    type [timestamp -seconds $t -format "%y%m%dD"]
    type [timestamp -seconds $t -format "%H%M%ST"]
    type "!."
    expect "DAYLIGHT SAVINGS" {
        type "N"
	respond "IT IS NOW" "Q"
    } "IT IS NOW" {
        type "Q"
    }
    expect ":KILL"
}

proc maybe_pdset {} {
    expect "YOU MAY HAVE TO :PDSET" {
	pdset
    } "PDTIME OFFSET" {
	pdset
    } "IT IS NOW" {
	type "\032"
	expect "Fair"
	type ":vk\r"
    }
}

proc shutdown {} {
    global emulator_escape
    respond "*" ":lock\r"
    expect "_"
    send "5kill"
    respond "GO DOWN?\r\n" "y"
    respond "BRIEF MESSAGE" "\003"
    respond "NOW IN DDT" $emulator_escape
}

set timeout 100
expect_before timeout abort

start_nsalv

respond "\n" "mark\033g"
respond "Format pack on unit #" "0"
respond "Are you sure you want to format pack on drive" "y"
respond "Pack no ?" "0\r"
respond "Verify pack?" "n"
respond "Alloc?" "3000\r"
respond "ID?" "foobar\r"
respond "DDT" "tran\033g"
respond "onto unit" "0"
respond "OK" "y"
expect "EOT"
respond "DDT" $emulator_escape

start_dskdmp

respond "DSKDMP" "l\033ddt\r"
expect "\n"; type "t\033its rp06\r"
expect "\n"; type "\033u"
respond "DSKDMP" "m\033salv rp06\r"
expect "\n"; type "d\033its\r"
expect "\n"; type "its\r"
expect "\n"; type "\033g"
pdset
respond "*" ":ksfedr\r"
respond "File not found" "create\r"
expect -re {Directory address: ([0-7]*)\r\n}
set dir $expect_out(1,string)
type "write\r"
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
type "\033g"
maybe_pdset

respond "*" $emulator_escape
mount_tape "out/sources.tape"
type ":dump\r"
respond "_" "reload "
respond "ARE YOU SURE" "y"
respond "\n" "links crdir sorry\r"
respond "FILE=" "*;* *\r"
expect -timeout 200 "E-O-T"
respond "_" "quit\r"
expect ":KILL"

respond "*" ":print sysbin;..new. (udir)\r"
type ":vk\r"
respond "*" ":midas sysbin;_midas;midas\r"
expect ":KILL"
respond "*" ":job midas\r"
respond "*" ":load sysbin;midas bin\r"
respond "*" "purify\033g"
respond "CR to dump" "\r"
respond "*" ":kill\r"

respond "*" ":midas sysbin;_sysen1;ddt\r"
expect ":KILL"
respond "*" ":job ddt\r"
respond "*" ":load sysbin;ddt bin\r"
respond "*" "purify\033g"
respond "*" ":pdump sys;atsign ddt\r"
respond "*" ":kill\r"

respond "*" ":midas .;_system;its\r"
respond "MACHINE NAME =" "DB\r"
respond "Configuration?" "RP06\r"
expect ":KILL"

respond "*" ":midas .;@ ddt_system;ddt\r"
respond "cpusw" "3\r"
respond "New One Proceed" "1\r"
expect ":KILL"

respond "*" ":midas .;_kshack;nsalv\r"
respond "Which machine?" "KSRP06\r"
expect ":KILL"

respond "*" ":midas .;_system;dskdmp\r"
expect "Configuration"
respond "?" "ksrp06\r"
respond "Assemble BOOT?" "no\r"
expect ":KILL"

respond "*" ":midas .;bt_system;dskdmp\r"
expect "Configuration"
respond "?" "ksrp06\r"
respond "Assemble BOOT?" "yes\r"
expect ":KILL"

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
start_dskdmp
respond "DSKDMP" "l\033ddt\r"
expect "\n"; type "t\033dskdmp bin\r"
expect "\n"; type "\033g"
respond "DSKDMP" "t\033its bin\r"
expect "\n"; type "\033u"
respond "DSKDMP" "m\033nsalv bin\r"
expect "\n"; type "d\033nits\r"
expect "\n"; type "nits\r"
expect "\n"; type "\033g"
pdset

respond "*" ":rename .;@ its, .;@ oits\r"
respond "*" ":rename .;@ nits, .;@ its\r"

respond "*" ":midas sysbin;_.teco.;teco\r"
expect ":KILL"
respond "*" ":job teco\r"
respond "*" ":load sysbin;teco bin\r"
sleep 2
respond "*" "dumpit\033g"
sleep 2
respond "TECPUR" "\r"
respond "*" ":kill\r"
respond "*" ":link sys3;ts teco,.teco.;tecpur >\r"

respond "*" ":midas sysbin;_syseng;dump\r"
respond "WHICH MACHINE?" "DB\r"
expect ":KILL"
respond "*" ":delete sys;ts dump\r"
respond "*" ":link sys;ts dump,sysbin;dump bin\r"

respond "*" ":midas sysbin;_sysen1;pdset\r"
expect ":KILL"
respond "*" ":delete sys;ts pdset\r"
respond "*" ":link sys;ts pdset,sysbin;pdset bin\r"

respond "*" ":midas sysbin;_syseng;lock\r"
expect ":KILL"
respond "*" ":delete sys;ts lock\r"
respond "*" ":link sys;ts lock,sysbin;lock bin\r"

respond "*" ":midas sysbin;_syseng;@dev\r"
expect ":KILL"
respond "*" ":delete sys;atsign device\r"
respond "*" ":link sys;atsign device,sysbin;@dev bin\r"

respond "*" ":midas sysbin;_syseng;tctyp\r"
expect ":KILL"
respond "*" ":link sys;ts tctyp,sysbin;tctyp bin\r"

respond "*" ":midas sysbin;_syseng;crtsty\r"
expect ":KILL"
respond "*" ":job crtsty\r"
respond "*" ":load sysbin;crtsty bin\r"
respond "*" "purify\033g"
respond " BIN" "\r"
respond "*" ":kill\r"
respond "*" ":link sys3;ts crtsty,sysbin;crtsty bin\r"

respond "*" ":midas sysbin;_sysen2;peek\r"
expect ":KILL"
respond "*" ":job peek\r"
respond "*" ":load sysbin;peek bin\r"
respond "*" "purify\033g"
respond "Idle" "q"
expect ":KILL"

respond "*" ":midas device;jobdev arc_syseng;arcdev\r"
expect ":KILL"
respond "*" ":link device;jobdev ar,device;jobdev arc\r"

respond "*" ":midas sysbin;_ar1:cstacy;whoj\r"
expect ":KILL"
respond "*" ":print sys1;..new. (udir)\r"
type ":vk\r"
respond "*" ":link sys1;ts talk,sysbin;whoj bin\r"
type ":vk\r"
respond "*" ":link sys1;ts who,sysbin;whoj bin\r"
type ":vk\r"
respond "*" ":link sys1;ts whoj,sysbin;whoj bin\r"
type ":vk\r"
respond "*" ":link sys1;ts whom,sysbin;whoj bin\r"
type ":vk\r"
respond "*" ":link sys2;ts users,sysbin;whoj bin\r"
type ":vk\r"
respond "*" ":link sys1;ts w,sys1;ts who\r"
type ":vk\r"
respond "*" ":link sys2;ts u,sys2;ts users\r"
type ":vk\r"

respond "*" ":midas sysbin;_sysen2;find\r"
expect ":KILL"
respond "*" ":link sys;ts find,sysbin;find bin\r"
type ":vk\r"

respond "*" ":midas channa;atsign taraka_syseng; dragon\r"
expect ":KILL"
respond "*" ":link sys; atsign dragon,channa; atsign taraka\r"

respond "*" ":midas channa;rakash dmpcpy_syseng; dmpcpy\r"
expect ":KILL"

respond "*" ":midas channa;rakash modems_syseng; modems\r"
expect ":KILL"
respond "*" ":link channa;ts modems,channa;rakash modems\r"

respond "*" ":midas channa;rakash netime_sysen1; netime\r"
expect ":KILL"
respond "*" ":link channa;ts netime,channa;rakash netime\r"

respond "*" ":link dragon;hourly modems,channa;ts modems\r"

# sources dump tape now creates dragon directory and populates
# with an initial dragon; dragon hoard file, which is required
# by PFT
#
# respond "*" ":print dragon;..new. (udir)\r"
#
respond "*" ":midas dragon;rakash pfthmg_syseng; pft\r"
respond "mcp=" "0\r"
expect ":KILL"
respond "*" ":link channa; rakash pfthmg,dragon; rakash pfthmg\r"

respond "*" ":link sys; ts p,sys; ts peek\r"

respond "*" ":midas kshack;ts mtboot_kshack;mtboot\r"
expect ":KILL"

respond "*" ":midas syshst;_syshst;hosts3\r"
expect ":KILL"

respond "*" ":link syseng;t20mac 999999,system;t20mac >\r"

respond "*" ":midas syshst;_syshst;h3make\r"
expect ":KILL"

# submit job to daemon to build binary host table
respond "*" ":job h3make\r"
respond "*" ":load syshst;h3make bin\r"
respond "*" "\033g"

# basic TCP support
respond "*" ":midas sys;atsign tcp_syseng;@tcp\r"
expect ":KILL"

respond "*" ":link syseng;netwrk 999999,sysnet;netwrk >\r"

# telnet server
respond "*" ":midas sysbin;telser_sysnet;telser\r"
expect ":KILL"

# port 23 (telnet) uses TELSER
respond "*" ":link device;tcp syn027,sysbin;telser bin\r"

# telnet client
respond "*" ":midas sysbin;telnet_sysnet;telnet\r"
expect ":KILL"

respond "*" ":link sys;ts telnet,sysbin;telnet bin\r"
respond "*" ":link sys;ts tn,sys;ts telnet\r"

# supdup port (95) uses telser
respond "*" ":link device;tcp syn137,sysbin;telser bin\r"

# supdup client
respond "*" ":midas sysbin;supdup_sysnet;supdup\r"
expect ":KILL"

respond "*" ":print sys1;..new. (udir)\r"
type ":vk\r"

respond "*" ":link sys1;ts supdup,sysbin;supdup bin\r"

respond "*" ":link syseng;fsdefs 999999,system;fsdefs >\r"

# these two links are expected by sysnet; ftps > and are present
# in the PI distribution
respond "*" ":link ksc;nuuos 999999,klh;nuuos >\r"
respond "*" ":link ksc;macros 999999,klh;macros >\r"
respond "*" ":link ksc;out 999999,klh; out >\r"

respond "*" ":midas sysbin;ftps_sysnet;ftps \r"
expect ":KILL"

respond "*" ":link device;tcp syn025,sysbin;ftps bin\r"
respond "*" ":link device;tcp syn031,sysbin;ftps bin\r"

respond "*" ":midas sysbin;ftpu_sysnet;ftpu\r"
expect ":KILL"

respond "*" ":link sys;ts ftp,sysbin;ftpu bin\r"

# NAME
respond "*" ":midas sysbin;name_sysen2;name\r"
expect ":KILL"

respond "*" ":link syseng;ttytyp 999999,system;ttytyp >\r"
respond "*" ":copy inquir;lsr1 empty,inquir;lsr1 >\r"

respond "*" ":copy sysbin;name bin,sys;ts name\r"
respond "*" "name\033j"
respond "*" "\033l sys;ts name\r"
respond "*" "debug/"
respond "-1" "0\r\033g"

respond "*" ":link sys1;ts when,sys;ts name\r"
respond "*" ":link sys1;ts whoare,sys;ts name\r"
respond "*" ":link sys1;ts whois,sys;ts name\r"
respond "*" ":link sys1;ts supnam,sys;ts name\r"
respond "*" ":link sys1;ts finger,sys;ts name\r"
respond "*" ":link sys;ts f,sys;ts name\r"
respond "*" ":link sys2;ts n,sys;ts name\r"
respond "*" ":link device;tcp syn117,sys;ts name\r"

respond "*" ":midas device;atsign mldev_sysen2;mldev\r"
expect ":KILL"

respond "*" ":link device;jobdev db,device;atsign mldev\r"

respond "*" ":midas device;atsign mlslv_sysen2;mlslv\r"
expect ":KILL"

respond "*" ":link device;tcp syn123,device;atsign mlslv\r"

respond "*" ":midas sys1;ts cftp_sysen2; cftp\r"
respond "KLp==" "0\r"
expect ":KILL"

respond "*" ":link device;chaos telnet,sysbin;telser bin\r"
respond "*" ":link device;chaos supdup,sysbin;telser bin\r"

respond "*" ":midas sysbin;chtn_sysnet;chtn\r"
expect ":KILL"

respond "*" ":link sys2;ts chtn,sysbin;supdup bin\r"

respond "*" ":midas sys;ts ttloc_sysen1;ttloc\r"
expect ":KILL"

respond "*" ":link kshack;good ram,.;ram ram\r"
respond "*" ":link kshack;ddt bin,.;@ ddt\r"
respond "*" $emulator_escape
create_tape "out/ndskdmp.tape"
type ":kshack;mtboot\r"
respond "Write a tape?" "y"
respond "Rewind tape first?" "y"
respond "Include DDT?" "y"
respond "Input file" ".;dskdmp bin\r"
expect ":KILL"

respond "*" $emulator_escape
create_tape "out/nnsalv.tape"
type ":kshack;mtboot\r"
respond "Write a tape?" "y"
respond "Rewind tape first?" "y"
respond "Include DDT?" "y"
respond "Input file" ".;nsalv bin\r"
expect ":KILL"

respond "*" $emulator_escape
create_tape "out/output.tape"
type ":dump\r"
respond "_" "dump links full\r"
respond "TAPE NO=" "0\r"
expect "REEL"
respond "_" "quit\r"

shutdown
quit_emulator
