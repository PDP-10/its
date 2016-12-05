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

respond "*" ":print sys2;..new. (udir)\r"
type ":vk\r"
respond "*" ":link sys2;ts emacs,emacs;ts >\r"

respond "*" ":emacs\r"
respond "EMACS Editor" "\033xrun\033einit\033? Generate\r"
expect "EINIT"
respond ":EJ" "\033xgenerate\033emacs;aux\033emacs1;aux\r"
respond ":EJ" "\033xgenerate\033emacs;info\033emacs1;info\r"
respond ":EJ" "\030\003"
respond "*" ":kill\r"

respond "*" ":delete emacs;ts 126\r"
respond "*" ":delete \[prfy\] <\r"
respond "*" ":delete \[pure\] 162\r"
respond "*" ":rename \[pure\] 163, \[pure\] 162\r"

respond "*" "emacs\033\023"
respond "*" ":teco\r"
respond "&" "mmrun\033purify\033dump\033ts 126\033\033"
respond "&" "\003"
respond "*" ":kill\r"

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
respond "*" ":link sys;ts fi,sys;ts find\r"
type ":vk\r"
respond "*" ":link sys;ts comb,sys;ts find\r"
type ":vk\r"
respond "*" ":link sys2;ts lf,sys;ts find\r"
type ":vk\r"

respond "*" ":midas sys;ts dskuse_syseng;dskuse\r"
expect ":KILL"

respond "*" ":midas sys3;ts ddtdoc_syseng;ddtdoc\r"
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

respond "*" ":link sys; ts p,sys; ts peek\r"

respond "*" ":midas sys1;ts dir_bawden;dir^k\r"
expect ":KILL"

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

respond "*" ":midas device;atsign dirdev_syseng;dirdev\r"
expect ":KILL"

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

respond "*" ":midas sys;ts srccom_sysen2;srccom\r"
expect ":KILL"

respond "*" ":midas .mail.;comsat_sysnet;comsat\r"
expect ":KILL"

respond "*" ":midas device;jobdev dq_sysnet;dqxdev\r"
expect ":KILL"

respond "*" "comsat\033j"
respond "*" "\033l.mail.;comsat bin\r"
respond "*" "bughst/<<192.\033_24.>+<168.\033_16.>+<1.\033_8.>+100.>\r"
type "domgat/<<192.\033_24.>+<168.\033_16.>+<0.\033_8.>+45.>\r"
type "tcpgat/<<192.\033_24.>+<168.\033_16.>+<0.\033_8.>+45.>\r"
type "debug/0\r"
type "xvers/0\r"
type "purify\033g"
respond ":PDUMP DSK:.MAIL.;COMSAT LAUNCH" "\r"

respond "*" ":kill\r"

initialize_comsat

respond "*" ":link emacs;rmail \021:ej,emacs;\[rmai\] >\r"

respond "*" ":midas sys1;ts rmail_emacs1;rmaill\r"
expect ":KILL"

respond "*" ":link channa;rakash cnavrl,.mail.;comsat launch\r"
respond "*" ":link dragon;hourly cnavrl,.mail.;comsat launch\r"

respond "*" ":midas sysbin;qmail_ksc;qmail\r"
respond "PWORD version (Y or N)? " "Y\r"
expect ":KILL"

respond "*" ":link sys;ts mail,sysbin;qmail bin\r"
respond "*" ":link sys;ts qmail,sysbin;qmail bin\r"
respond "*" ":link sys;ts qsend,sysbin;qmail bin\r"
respond "*" ":link sys1;ts bug,sysbin;qmail bin\r"
respond "*" ":link sys;ts m,sys;ts mail\r"
respond "*" ":link sys2;ts featur,sys;ts qmail\r"
respond "*" ":link .info.;mail info,.info.;qmail info\r"

# lisp
respond "*" ":link l;fasdfs 1,lisp;.fasl defs\r"
respond "*" ":link lisp;grind fasl,lisp;gfile fasl\r"
respond "*" ":link lisp;grinde fasl,lisp;gfn fasl\r"
respond "*" ":link l;loop fasl,liblsp;loop fasl\r"
respond "*" ":link lisp;loop fasl,liblsp;loop fasl\r"

respond "*" ":midas .temp.;_l;*lisp\r"
respond "end input with ^C" "\003"
expect ":KILL"
respond "*" ":job lisp\r"
respond "*" ":load .temp.;*lisp bin\r"
respond "*" "\033g"
respond "*" "purify\033g"
respond "*" ":pdump sys;purqio >\r"
respond "*" ":kill\r"

respond "*" ":link sys;ts lisp,sys:purqio >\r"
respond "*" ":link sys;ts q,sys;purqio >\r"
respond "*" ":link sys;atsign lisp,sys;purqio >\r"
respond "*" ":link sys;ts l,sys;ts lisp\r"

respond "*" ":link .info.;lisp step,.info.;step info\r"
respond "*" ":link libdoc;struct doc,alan;struct doc\r"
respond "*" ":link .info.;lisp struct,libdoc;struct doc\r"
respond "*" ":link l;-read- -this-,lisp;-read- -this-\r"

# lisp compiler
respond "*" ":link comlap;complr fasl,comlap;cl.fas >\r"
respond "*" ":link comlap;phas1 fasl,comlap;ph.fas >\r"
respond "*" ":link comlap;comaux fasl,comlap;cx.fas >\r"
respond "*" ":link comlap;faslap fasl,comlap;fl.fas >\r"
respond "*" ":link comlap;maklap fasl,comlap;mk.fas >\r"
respond "*" ":link comlap;initia fasl,comlap;in.fas >\r"
respond "*" ":link comlap;srctrn fasl,comlap;st.fas >\r"
respond "*" ":print lspdmp;..new. (udir)\r"
type ":vk\r"
respond "*" "lisp\013"
respond "Alloc?" "n\r"
respond "*" "(load \"comlap;ccload\")"
respond ";BKPT CCLOAD:DUMPVERNO" "(setq ccload:dumpverno 2154)"
respond "2154" "(return)"
respond "*" ":kill\r"
respond "*" ":link sys;ts complr,lspdmp;cl.dmp >\r"
respond "*" ":link info;complr 1,info;lispc >\r"

# binprt
respond "*" ":midas sys3;ts binprt_sysen1;binprt\r"
expect ":KILL"

# inquir
respond "*" ":link lisp;subloa lsp,nilcom;subloa >\r"
respond "*" ":link sys;.fasl defs,lisp;.fasl defs\r"
respond "*" ":midas inquir;_lsrrtn\r"
expect ":KILL"
respond "*" ":link liblsp;debug fasl,liblsp;dbg fasl\r"
respond "*" "complr\013"
respond "_" "liblsp;_libdoc;tty\r"
respond "_" "inquir;reader\r"
respond "_" "lisp;_nilcom;subloa\r"
respond "_" "lisp;_lspsrc;umlmac\r"
respond "_" "inquir;fake-s\r"
respond "_" "rwk;debmac\r"
respond "_" "liblsp;_libdoc;lispm\r"
respond "_" "lisp;_nilcom;evonce\r"
respond "_" "inquir;inquir\r"
respond "_" "\032"
type ":kill\r"
respond "*" "complr\013"
respond "_" "liblsp;_libdoc;dbg rwk1\r"
respond "_" "liblsp;_libdoc;comrd kmp1\r"
respond "_" "\032"
type ":kill\r"
respond "*" ":lisp inquir;inquir (dump)\r"
respond "*" ":link inquir;ts inquir,inquir;inqbin >\r"
respond "*" ":link sys;ts inquir,inquir;ts inquir\r"

respond "*" ":midas inquir;dirs bin_inquir;dmunch\r"
expect ":KILL"

respond "*" ":midas inquir;inqupd bin_inquir;inqupd\r"
expect ":KILL"

respond "*" ":link inquir;lsrtns 1,syseng;lsrtns >\r"

respond "*" ":midas inquir;ts lookup_inquir;lookup\r"
expect ":KILL"

respond "*" ":link sys1;ts lookup,inquir;ts lookup\r"

# pword/panda
respond "*" ":midas sysbin;pword bin_sysen1;pword\r"
respond "Is this to be a PANDA?" "yes\r"
expect ":KILL"
respond "*" ":midas sysbin;panda bin_sysen1;pword\r"
respond "Is this to be a PANDA?" "no\r"
expect ":KILL"
respond "*" ":midas sysbin;pwinit bin_sysen1;pwinit\r"
expect ":KILL"
respond "*" ":job pwinit\r"
respond "*" ":load sysbin;pwinit\r"
respond "*" "\033g"
respond "*" ":copy cstacy;big dat,sysbin;\021 \021 \021 big \021 \021 0dat\r"
respond "*" ":job panda\r"
respond "*" ":load sysbin;panda bin\r"
# set password to "panda"
respond "*" "spword/107150326162\r"
type "purify\033g"
respond "*" ":pdump sysbin;panda bin\r"
respond "*" ":link sys;atsign pword,sysbin;pword bin\r"
respond "*" ":link sys;ts panda,sysbin;panda bin\r"

# sender
respond "*" ":midas sysbin;sender_sysen1;sender\r"
expect ":KILL"
respond "*" ":link sys;ts freply,sysbin;sender bin\r"
respond "*" ":link sys;ts send,sysbin;sender bin\r"
respond "*" ":link sys2;ts fr,sysbin;sender bin\r"
respond "*" ":link sys2;ts reply,sysbin;sender bin\r"
respond "*" ":link sys3;ts fs,sysbin;sender bin\r"
respond "*" ":link sys1;ts s,sys;ts send\r"
respond "*" ":link sys3;ts snd,sys;ts send\r"
respond "*" ":link sys3;ts sned,sys;ts send\r"

# reatta
respond "*" ":midas sys1;ts reatta_sysen2;reatta\r"
expect ":KILL"

# timoon
respond "*" ":midas sys1;ts timoon_syseng;timoon\r"
expect ":KILL"

# sysmsg
respond "*" ":midas sys1;ts sysmsg_sysen1;sysmsg\r"
expect ":KILL"

# meter
respond "*" ":midas sys1;ts meter_syseng;meter\r"
expect ":KILL"

# dired
respond "*" ":midas sys;ts dired_sysen2;dired\r"
expect ":KILL"

# hsname
respond "*" ":midas sys2;ts hsname_sysen1;hsname\r"
expect ":KILL"

# arcsal
respond "*" ":midas sys1;ts arcsal_sysen1;arcsal\r"
expect ":KILL"

# rmtdev
respond "*" ":midas device;atsign rmtdev_gz;rmtdev\r"
expect ":KILL"

# ndskdmp tape

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

# make nnsalv.tape

respond "*" $emulator_escape
create_tape "out/nnsalv.tape"
type ":kshack;mtboot\r"
respond "Write a tape?" "y"
respond "Rewind tape first?" "y"
respond "Include DDT?" "y"
respond "Input file" ".;nsalv bin\r"
expect ":KILL"

# make output.tape

respond "*" $emulator_escape
create_tape "out/output.tape"
type ":dump\r"
respond "_" "dump links full\r"
respond "TAPE NO=" "0\r"
expect "REEL"
respond "_" "quit\r"

shutdown
quit_emulator
