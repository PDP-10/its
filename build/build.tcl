# If the environment variable BASICS is set to "yes", only build
# the basics; ITS, tools, infastructure.
if {![info exists env(BASICS)]} {
    set env(BASICS) "no"
}

proc abort {} {
    puts ""
    puts "The last command timed out."
    exit 1
}

proc type s {
    sleep .1
    foreach c [split $s ""] {
        send -- $c
        if [string match {[a-zA-Z0-9]} $c] {
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
    expect "SYSTEM JOB USING THIS CONSOLE"
    sleep 1
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
    } "ITS revived" {
        type "Q"
    }
    expect ":KILL"
}

proc shutdown {} {
    global emulator_escape
    respond "*" ":lock\r"
    expect "_"
    send "5kill"
    respond "GO DOWN?\r\n" "y"
    respond "BRIEF MESSAGE" "\003"
    respond "_" "q"
    expect ":KILL"
    respond "*" ":logout\r"
    respond "NOW IN DDT" $emulator_escape
}

proc ip_address {string} {
    set x 0
    set octets [lreverse [split $string .]]
    for {set i 0} {$i < 4} {incr i} {
	incr x [expr {256 ** $i * [lindex $octets $i]}]
    }
    format "%o" $x
}

proc build_macsyma_portion {} {
    respond "*" "complr\013"
    respond "_" "\007"
    respond "*" "(load \"liblsp;iota\")"
    respond "274630" "(load \"maxtul;docgen\")"
    respond "300052" "(load \"maxtul;mcl\")"
    respond "302615" "(load \"maxdoc;mcldat\")"
    respond "302615" "(load \"libmax;module\")"
    respond "303351" "(load \"libmax;maxmac\")"
    respond "307161" "(todo)"
    sleep 10
    type "(todoi)"
    sleep 10
    type "(mapcan #'(lambda (x) (cond ((not (memq x\r"
    type "'(SETS TRANSS MTREE TRHOOK EDLM)\r"
    type ")) (doit x)))) (append todo todoi))"
    expect {
	";BKPT" {
	    type "(quit)"
	}
        "NIL" {
	    type "(quit)"
	}
    }
}

set timeout 100
expect_after timeout abort

set ip [ip_address [lindex $argv 0]]
set gw [ip_address [lindex $argv 1]]

start_salv

mark_packs

respond "DDT" "tran\033g"
respond "#" "0"
respond "OK" "y"
expect -timeout 300 EOT

respond "DDT" $emulator_escape

start_dskdmp_its

pdset
respond "*" ":login db\r"
sleep 1

prepare_frontend

type ":dump\r"
respond "_" "reload "
respond "ARE YOU SURE" "y"
respond "\n" "links crdir sorry\r"
respond "FILE=" "*;* *\r"
expect -timeout 3000 "E-O-T"
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
sleep 2
respond "*" ":kill\r"

respond "*" ":midas sysbin;_sysen1;ddt\r"
expect ":KILL"
respond "*" ":job ddt\r"
respond "*" ":load sysbin;ddt bin\r"
respond "*" "purify\033g"
respond "*" ":pdump sys;atsign ddt\r"
respond "*" ":kill\r"

respond "*" ":midas dsk0:.;_system;its\r"
its_switches
expect ":KILL"

make_ntsddt

make_salv

make_dskdmp

frontend_bootstrap

shutdown
start_dskdmp

dump_nits
expect "\n"; type "nits\r"
expect "\n"; type "\033g"
pdset

respond "*" ":login db\r"
sleep 1
type ":rename .;@ its, .;@ oits\r"
respond "*" ":rename .;@ nits, .;@ its\r"

respond "*" ":print sys1;..new. (udir)\r"
type ":vk\r"
respond "*" ":print sys2;..new. (udir)\r"
type ":vk\r"
respond "*" ":print sys3;..new. (udir)\r"
type ":vk\r"
respond "*" ":print device;..new. (udir)\r"
type ":vk\r"

source $build/emacs.tcl

# TAGS
respond "*" ":midas sys2;ts tags_sysen2;tags\r"
expect ":KILL"

# magdmp, paper tape
respond "*" ":midas dsk0:.;_syseng;magdmp\r"
respond "PTRHRI=" "y\r"
magdmp_switches
expect ":KILL"

# magdmp
respond "*" ":midas sys1;ts magfrm_syseng;magfrm\r"
expect ":KILL"

respond "*" ":midas sysbin;_syseng;dump\r"
dump_switches
expect ":KILL"
respond "*" ":delete sys;ts dump\r"
respond "*" ":link sys;ts dump,sysbin;dump bin\r"
respond "*" ":link sys;ts load,sys;ts dump\r"

respond "*" ":midas sys1;ts stink_sysen2;stink\r"
expect ":KILL"

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

respond "*" ":midas /t sysbin;_sysen2;peek\r"
peek_switches
expect ":KILL"
respond "*" ":job peek\r"
respond "*" ":load sysbin;peek bin\r"
respond "*" "purify\033g"
respond "Idle" "q"
expect ":KILL"
respond "*" ":link sys; ts p,sys; ts peek\r"

respond "*" ":midas device;jobdev arc_syseng;arcdev\r"
expect ":KILL"
respond "*" ":link device;jobdev ar,device;jobdev arc\r"

respond "*" ":midas device;oarcdv bin_syseng;arcdev 66\r"
expect ":KILL"

# JOBDEV D (DSKDEV)
respond "*" ":midas device;jobdev d_syseng;dskdev\r"
expect ":KILL"

respond "*" ":midas sysbin;_sysen2;find\r"
expect ":KILL"
respond "*" ":link sys;ts find,sysbin;find bin\r"
type ":vk\r"
respond "*" ":link sys;ts fi,sys;ts find\r"
type ":vk\r"
respond "*" ":link sys;ts comb,sys;ts find\r"
type ":vk\r"
respond "*" ":link sys2;ts lf,sys;ts find\r"
type ":vk\r"

respond "*" ":midas sys;ts dskuse_syseng;dskuse\r"
expect ":KILL"

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

# LOSS device
respond "*" ":midas device;jobdev loss_syseng;loss\r"
expect ":KILL"
respond "*" ":link device;jobdev los,device;jobdev loss\r"

respond "*" ":midas kshack;ts mtboot_kshack;mtboot\r"
expect ":KILL"

respond "*" ":midas syshst;_syshst;hosts3\r"
expect ":KILL"
respond "*" ":link syshst;ts hosts3,syshst;hosts3 bin\r"

respond "*" ":link syseng;t20mac 999999,system;t20mac >\r"

respond "*" ":midas syshst;_syshst;h3make\r"
expect ":KILL"
respond "*" ":link syshst;ts h3make,syshst;h3make bin\r"

# build binary host table
respond "*" ":syshst;hosts3 /insert syshst; h3text > /outfil sysbin; hosts3 bin\r"
expect ":KILL"

# basic TCP support
respond "*" ":midas sys;atsign tcp_syseng;@tcp\r"
expect ":KILL"

# Chaosnet support
respond "*" ":midas sysbin;_syseng;@chaos\r"
expect ":KILL"
respond "*" ":link sys;atsign chaos,sysbin;@chaos bin\r"

# CHA: and CHAOS: device
respond "*" ":midas device;jobdev cha_dcp;chadev\r"
expect ":KILL"
respond "*" ":link device;jobdev chaos,device;jobdev cha\r"

respond "*" ":link syseng;netwrk 999999,sysnet;netwrk >\r"

# CHAOS ARPA/NCP/TCP gateway
respond "*" ":midas sysnet;_arpa\r"
expect ":KILL"
respond "*" ":link device;chaos arpa, sysnet;arpa bin\r"
respond "*" ":link device;chaos ncp, sysnet;arpa bin\r"
respond "*" ":link device;chaos tcp, sysnet;arpa bin\r"

respond "*" ":midas .;ts redrct_sysnet;redrct\r"
expect ":KILL"

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
respond "*" ":link device;chaos smtp,sysbin;ftps bin\r"

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
respond "*" ":link sys1;ts wheres,sys1;ts whois\r"
respond "*" ":link sys1;ts supnam,sys;ts name\r"
respond "*" ":link sys1;ts finger,sys;ts name\r"
respond "*" ":link sys;ts f,sys;ts name\r"
respond "*" ":link sys2;ts n,sys;ts name\r"
respond "*" ":link device;tcp syn117,sys;ts name\r"
respond "*" ":link device;chaos name,sys;ts name\r"

respond "*" ":midas device;atsign mldev_sysen2;mldev\r"
expect ":KILL"

respond "*" ":link device;jobdev db,device;atsign mldev\r"
respond "*" ":link device;jobdev es,device;atsign mldev\r"
respond "*" ":link device;jobdev no,device;atsign mldev\r"
respond "*" ":link device;jobdev sj,device;atsign mldev\r"
respond "*" ":link device;jobdev up,device;atsign mldev\r"

respond "*" ":midas device;atsign mlslv_sysen2;mlslv\r"
expect ":KILL"

respond "*" ":link device;tcp syn123,device;atsign mlslv\r"
respond "*" ":link device;chaos mldev,device;atsign mlslv\r"

respond "*" ":midas device;jobdev fc_sysen2;fcdev\r"
expect ":KILL"

respond "*" ":midas device;atsign dirdev_syseng;dirdev\r"
expect ":KILL"
respond "*" ":link device;jobdev dir,device;atsign dirdev\r"
respond "*" ":link device;jobdev dirdb,device;atsign dirdev\r"
respond "*" ":link device;jobdev dires,device;atsign dirdev\r"
respond "*" ":link device;jobdev dirno,device;atsign dirdev\r"
respond "*" ":link device;jobdev dirsj,device;atsign dirdev\r"
respond "*" ":link device;jobdev dirup,device;atsign dirdev\r"

respond "*" ":midas sys1;ts cftp_sysen2; cftp\r"
respond "KLp==" "0\r"
expect ":KILL"

respond "*" ":link device;chaos telnet,sysbin;telser bin\r"
respond "*" ":link device;chaos supdup,sysbin;telser bin\r"

if {$env(BASICS)!="yes"} {
    source $build/misc.tcl
    source $build/lisp.tcl
    source $build/scheme.tcl
}

source $build/muddle.tcl

respond "*" ":midas sys3;ts lsrprt_sysen1; lsrprt\r"
expect ":KILL"

respond "*" ":midas sysbin;_sra; gcmail\r"
expect ":KILL"
respond "*" ":link dragon; hourly gcmail,sysbin; gcmail bin\r"

bootable_tapes

# make output.tape

respond "*" $emulator_escape
create_tape "$out/output.tape"
type ":dump\r"
respond "_" "dump links full list\r"
respond "LIST DEV =" "tty\r"
respond "TAPE NO=" "1\r"
expect -timeout 3000 "REEL"
respond "_" "rewind\r"
respond "_" "icheck\r"
expect -timeout 3000 "_"
type "quit\r"

shutdown
quit_emulator
