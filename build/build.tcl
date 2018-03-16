proc abort {} {
    puts ""
    puts "The last command timed out."
    exit 1
}

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
respond "*" ":print cstacy;..new. (udir)\r"
type ":vk\r"
respond "*" ":print teach;..new. (udir)\r"
type ":vk\r"
respond "*" ":print device;..new. (udir)\r"
type ":vk\r"

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

respond "*" ":link sys2;ts emacs,emacs;ts >\r"
respond "*" ":emacs\r"
respond "EMACS Editor" "\033xrun\033einit\033? Generate\r"
expect -timeout 2000 "EINIT"
respond ":EJ" "\033xgenerate\033emacs;aux\033emacs1;aux\r"
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
respond "*" ":link sys2;ts edit,sys2;ts emacs\r"

# BABYL, BABYLM, CACHE, FIXLIB, IVORY, MKDUMP, OUTLINE-MODE, PL1,
# TEACH-C100, TMACS and WORDAB are generated with IVORY.
respond "*" ":emacs\r"
respond "EMACS Editor" "\033xload\033ivory\r"
respond "\n" "\033xgenerate\033emacs;ivory\033emacs1;ivory\r"
respond ":EJ" "\033xgenerate\033emacs;pl1\033emacs1;pl1\r"
respond ":EJ" "\033xgenerate\033emacs;wordab\033emacs1;wordab\r"
respond ":EJ" "\033xgenerate\033emacs;tmacs\033emacs1;tmacs\033tmucs\r"
respond ":EJ" "\030\003"
respond "*" ":kill\r"

respond "*" ":emacs\r"
respond "EMACS Editor" "\033xload\033purify\r"
respond "\n" "\033xgenerate\033emacs;abstr\033emacs1;abstr\r"
respond ":EJ" "\025\033x& compress file\033emacs1;auto-s\r"
respond "Compressing file" "\033xgenerate\033emacs;auto-s\033emacs1;auto-s\r"
respond ":EJ" "\033xbare\033emacs1;bare\r"
respond "\n" "\033xgenerate\033emacs;c\033emacs1;c\r"
respond ":EJ" "\033xgenerate\033emacs;delim\033emacs1;delim\r"
respond ":EJ" "\033xgenerate\033emacs;dired\033emacs1;dired\r"
respond ":EJ" "\033xgenerate\033emacs;doclsp\033emacs1;doclsp\r"
respond ":EJ" "\033xgenerate\033emacs;docond\033emacs1;docond\r"
respond ":EJ" "\033xgenerate\033emacs;env\033dcp;eenv\r"
respond ":EJ" "\033xgenerate\033emacs;elisp\033emacs1;elisp\r"
respond ":EJ" "\033xgenerate\033emacs;info\033emacs1;info\r"
respond ":EJ" "\033xgenerate\033emacs;kbdmac\033emacs1;kbdmac\r"
respond ":EJ" "\033xgenerate\033emacs;ledit\033emacs1;ledit\r"
respond ":EJ" "\033xgenerate\033emacs;lispt\033emacs1;lispt\r"
respond ":EJ" "\033xgenerate\033emacs;lsputl\033emacs1;lsputl\r"
respond ":EJ" "\033xgenerate\033emacs;modlin\033emacs1;modlin\r"
respond ":EJ" "\033xgenerate\033emacs;muddle\033emacs1;muddle\r"
respond ":EJ" "\033xgenerate\033emacs;page\033emacs1;page\r"
respond ":EJ" "\033xgenerate\033emacs;pictur\033emacs1;pictur\r"
respond ":EJ" "\033xgenerate\033emacs;\[rmai\]\033emacs1;rmailx\033rmailz\r"
respond ":EJ" "\033xgenerate\033emacs;scribe\033emacs1;scribe\r"
respond ":EJ" "\033xgenerate\033emacs;scrlin\033emacs1;scrlin\r"
respond ":EJ" "\033xgenerate\033emacs;slowly\033emacs1;slowly\r"
respond ":EJ" "\033xgenerate\033emacs;sort\033emacs1;sort\r"
respond ":EJ" "\033xgenerate\033emacs;tags\033emacs1;tags\r"
respond ":EJ" "\033xgenerate\033emacs;taggen\033emacs1;taggen\r"
respond ":EJ" "\033xgenerate\033emacs;tdebug\033emacs1;tdebug\r"
respond ":EJ" "\033xgenerate\033emacs;tex\033emacs1;tex\r"
respond ":EJ" "\033xgenerate\033emacs;texmac\033emacs1;texmac\r"
respond ":EJ" "\033xgenerate\033emacs;time\033emacs1;time\r"
respond ":EJ" "\033xgenerate\033emacs;trmtyp\033emacs1;trmtyp\r"
respond ":EJ" "\033xgenerate\033emacs;vt100\033emacs1;vt100\r"
respond ":EJ" "\033xgenerate\033emacs;vt52\033emacs1;vt52\r"
respond ":EJ" "\033xgenerate\033emacs;xlisp\033emacs1;xlisp\r"

respond ":EJ" "\033xrun\033einit\033? Document\r"
respond "\n" "\030\003"
respond "*" ":kill\r"

respond "*" ":rename emacs;\[rmai\] \021:ej, emacs;\[rmai\] 146\r"

respond "*" ":link teach;teach emacs,emacs;teach emacs\r"
type ":vk\r"
respond "*" "teach\033\023"
respond "*" ":emacs\r"
expect ":KILL"
respond "*" ":link teach;ts emacs,emacs;tstch >\r"
type ":vk\r"

# nsalv, timesharing version
respond "*" ":midas sys1;_kshack;nsalv\r"
respond "machine?" "TS\r"
expect "*"

# salv, timesharing versions
respond "*" ":midas sys1;ts salv_system;salv\r"
respond "time-sharing?" "y\r"
expect ":KILL"

# magdmp
respond "*" ":midas dsk0:.;_syseng;magdmp\r"
respond "PTRHRI=" "y\r"
respond "KL10P=" "n\r"
respond "TM10BP=" "n\r"
respond "340P=" "n\r"
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

respond "*" ":midas sysbin;_sysen2;peek\r"
expect ":KILL"
respond "*" ":job peek\r"
respond "*" ":load sysbin;peek bin\r"
respond "*" "purify\033g"
respond "Idle" "q"
expect ":KILL"

respond "*" ":midas sys3;ts syslod_sysen1;syslod\r"
expect ":KILL"

respond "*" ":midas sys3;ts vv_sysen2;vv\r"
expect ":KILL"
respond "*" ":link sys3;ts vj,sys3;ts vv\r"
respond "*" ":link sys3;ts detree,sys3;ts vv\r"

respond "*" ":midas sys2;ts syschk_sysen2;syschk\r"
expect ":KILL"

respond "*" ":midas device;jobdev arc_syseng;arcdev\r"
expect ":KILL"
respond "*" ":link device;jobdev ar,device;jobdev arc\r"

respond "*" ":midas device;oarcdv bin_syseng;arcdev 66\r"
expect ":KILL"

# JOBDEV D (DSKDEV)
respond "*" ":midas device;jobdev d_syseng;dskdev\r"
expect ":KILL"

respond "*" ":midas sysbin;_sysen3;whoj\r"
expect ":KILL"
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

respond "*" ":midas sys2;ts untalk_gren;untalk\r"
expect ":KILL"

respond "*" ":midas sys3;ts ufind_syseng;ufind\r"
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

respond "*" ":midas sys3;ts ddtdoc_syseng;ddtdoc\r"
expect ":KILL"

respond "*" ":midas sys1;ts nwatch_sysen1;nwatch\r"
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

respond "*" ":midas sys1;ts crock_sysen1;crock\r"
respond "System?" "ITS\r"
expect ":KILL"
respond "*" ":link sys2;ts c,sys1;ts crock\r"

respond "*" ":midas sys1;ts dcrock_sysen1;dcrock\r"
respond "System?" "ITS\r"
expect ":KILL"
respond "*" ":link sys2;ts dc,sys1;ts dcrock\r"

# Zork
respond "*" ":midas sys3;ts zork_sysen3;zork\r"
expect ":KILL"

respond "*" ":midas sys1;ts instal_sysen2;instal\r"
expect ":KILL"

# LOSS device
respond "*" ":midas device;jobdev loss_syseng;loss\r"
expect ":KILL"
respond "*" ":link device;jobdev los,device;jobdev loss\r"

respond "*" ":midas sys1;ts dir_bawden;dir^k\r"
expect ":KILL"

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

respond "*" ":midas sysbin;chtn_sysnet;chtn\r"
expect ":KILL"

respond "*" ":link sys2;ts chtn,sysbin;chtn bin\r"

respond "*" ":midas sys;ts ttloc_sysen1;ttloc\r"
expect ":KILL"
respond "*" ":link sys2;ts styloc,sys;ts ttloc\r"

respond "*" ":midas device;jobdev dp_sysen3;dpdev\r"
expect ":KILL"

respond "*" ":midas sys1;ts quote_sysen1;limeri\r"
respond "Use what filename instead?" "ecc;quotes >\r"
expect ":KILL"

respond "*" ":midas sys;ts srccom_sysen2;srccom\r"
expect ":KILL"
respond "*" ":link sys2;ts =,sys;ts srccom\r"

respond "*" ":midas .mail.;comsat_sysnet;comsat\r"
expect ":KILL"

respond "*" ":midas device;jobdev dq_sysnet;dqxdev\r"
expect ":KILL"

respond "*" "comsat\033j"
respond "*" "\033l.mail.;comsat bin\r"
respond "*" "bughst/$ip\r"
type "domgat/$gw\r"
type "tcpgat/$gw\r"
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
respond "*" ":link channa;ts cnavrl,channa;rakash cnavrl\r"
respond "*" ":link dragon;hourly cnavrl,.mail.;comsat launch\r"

respond "*" ":midas sysbin;qmail_ksc;qmail\r"
respond "PWORD version (Y or N)? " "N\r"
expect ":KILL"

respond "*" ":link sys;ts mail,sysbin;qmail bin\r"
respond "*" ":link sys;ts qmail,sysbin;qmail bin\r"
respond "*" ":link sys;ts qsend,sysbin;qmail bin\r"
respond "*" ":link sys1;ts bug,sysbin;qmail bin\r"
respond "*" ":link sys;ts m,sys;ts mail\r"
respond "*" ":link sys2;ts featur,sys;ts qmail\r"
respond "*" ":link .info.;mail info,.info.;qmail info\r"

# TIME
respond "*" ":midas sys1;ts time_sysen2;time\r"
expect ":KILL"

# DATE
respond "*" ":midas sys1;ts date_sysen3;date\r"
expect ":KILL"

# PWMAIL
respond "*" ":midas sys;ts pwmail_ksc;qmail\r"
respond "PWORD version (Y or N)? " "Y\r"
expect ":KILL"

# FIDO
respond "*" ":midas sys3;ts fido_ksc;fidox\r"
expect ":KILL"

# STTY
respond "*" ":midas sys2;ts stty_archy;stty\r"
expect ":KILL"

# OCTPUS
respond "*" ":midas sys2;ts octpus_gren;octpus\r"
expect ":KILL"

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
respond "*" ":pdump sys;purqio 2154\r"
respond "*" ":kill\r"

respond "*" ":link sys;ts lisp,sys:purqio >\r"
respond "*" ":link sys;ts q,sys;purqio >\r"
respond "*" ":link sys;atsign lisp,sys;purqio >\r"
respond "*" ":link sys;ts l,sys;ts lisp\r"

respond "*" ":link .info.;lisp step,.info.;step info\r"
respond "*" ":link libdoc;struct 280,alan;struct >\r"
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
respond "*" ":link sys;ts cl,sys;ts complr\r"
respond "*" ":link info;complr 1,info;lispc >\r"

# binprt
respond "*" ":midas sys3;ts binprt_sysen1;binprt\r"
expect ":KILL"

# bitprt
respond "*" ":midas sys3;ts bitprt_sysen2;bitprt\r"
expect ":KILL"

# inquir
respond "*" ":link lisp;subloa lsp,nilcom;subloa >\r"
respond "*" ":link sys;.fasl defs,lisp;.fasl defs\r"
respond "*" ":midas inquir;_lsrrtn\r"
expect ":KILL"

respond "*" ":link liblsp;debug fasl,liblsp;dbg fasl\r"
respond "*" ":link lisp;debug fasl,liblsp;debug fasl\r"
respond "*" "complr\013"
respond "_" "liblsp;_libdoc;tty\r"
respond "_" "inquir;reader\r"
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

# od
respond "*" "complr\013"
respond "_" "liblsp;_libdoc; od\r"
respond "_" "\032"
type ":kill\r"
respond "*" ":lisp libdoc;od (dump)\r"
expect ":KILL"

# comred
respond "*" "complr\013"
respond "_" "liblsp;_libdoc; comred\r"
respond "_" "\032"
type ":kill\r"

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
respond "*" ":kill\r"
respond "*" ":link sys;atsign pword,sysbin;pword bin\r"
respond "*" ":link sys;ts panda,sysbin;panda bin\r"

# bday
respond "*" ":midas sysbin;_sysen1;bday\r"
expect ":KILL"
respond "*" ":link dragon;bday daily,sysbin;bday bin\r"

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

# psend
respond "*" ":midas sys3;ts psend_sysen2;b\r"
expect ":KILL"

# whosen
respond "*" ":midas sys2;ts whosen_syseng;wsent\r"
expect ":KILL"

# sensor
respond "*" ":midas sys3;ts sensor_gren;sensor\r"
expect ":KILL"

# more lisp packages
respond "*" ":link lisp;tty fasl,liblsp;tty fasl\r"
respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((lisp) subloa lsp))"
respond "T" "(maklap)"
respond "_" "lisp;_lspsrc;funcel\r"
respond "_" "lisp;_lspsrc;bits\r"
respond "_" "lisp;_lspsrc;reap\r"
respond "_" "lisp;_lspsrc;lexprf\r"
respond "_" "lisp;_lspsrc;ldbhlp\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "lisp;_nilcom;sharpa\r"
respond "_" "lisp;_nilcom;sharpc\r"
respond "_" "lisp;_nilcom;lsets\r"
respond "_" "lisp;_nilcom;drammp\r"
respond "(Y or N)" "Y"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((lisp) subloa lsp))"
respond "T" "(maklap)"
respond "_" "lisp;_nilcom;sharpm\r"
respond "_" "lisp;_lspsrc;nilaid\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "liblsp;_libdoc;sharab\r"
respond "_" "liblsp;_libdoc;bs\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":link lisp;sharab fasl,liblsp;\r"
respond "*" ":link lisp;bs fasl,liblsp\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((lisp) subloa lsp))"
respond "T" "(maklap)"
respond "_" "lisp;_nilcom;thread\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":midas lisp;_l;lchnsp\r"
expect ":KILL"
respond "*" ":midas lisp;_l;purep\r"
expect ":KILL"

# struct

respond "*" ":link alan;dprint fasl,liblsp;dprint fasl\r"
respond "*" ":link alan;struct 9,alan;nstruc 280\r"
respond "*" ":copy liblsp;struct fasl,alan;struct boot\r"
respond "*" ":link alan;struct fasl,liblsp;struct fasl\r"
respond "*" "complr\013"
respond "_" "alan;lspcom\r"
respond "_" "alan;lspenv\r"
respond "_" "alan;lspint\r"
respond "_" "alan;setf\r"
respond "_" "alan;binda\r"
respond "_" "alan;crawl\r"
respond "_" "alan;nstruc 280\r"
respond "_" "\032"
type ":kill\r"
respond "*" ":copy alan;nstruc fasl,liblsp;struct fasl\r"
respond "*" ":link lisp;struct fasl,liblsp;struct fasl\r"

respond "*" ":midas liblsp;_alan;macits\r"
expect ":KILL"

respond "*" "complr\013"
respond "_" "liblsp;_alan;dprint\r"
respond "_" "\032"
type ":kill\r"

#respond "*" "complr\013"
#respond "_" "alan;ljob\r"
#respond "_" "liblsp;_libdoc;gprint rcw3\r"
#respond "_" "alan;lspgub\r"
#respond "_" "\032"
#type ":kill\r"

# NICNAM
respond "*" ":midas sys2;ts nicnam_sysen3;nicnam\r"
expect ":KILL"

# NICWHO
respond "*" ":midas sys2;ts nicwho_sysen3;nicwho\r"
expect ":KILL"

# reatta
respond "*" ":midas sys1;ts reatta_sysen2;reatta\r"
expect ":KILL"

# print
respond "*" ":midas sys;ts print_sysen2;print\r"
expect ":KILL"
respond "*" ":link sys;ts copy,sys;ts print\r"
respond "*" ":link sys;ts listf,sys;ts print\r"

# fdir 
respond "*" ":midas sys2;ts fdir_syseng;fdir\r"
expect ":KILL"

# timoon
respond "*" ":midas sys1;ts timoon_syseng;timoon\r"
expect ":KILL"

# ports
respond "*" ":midas sys2;ts ports_sysen2;ports\r"
expect ":KILL"

# sysmsg
respond "*" ":midas sys1;ts sysmsg_sysen1;sysmsg\r"
expect ":KILL"

# meter
respond "*" ":midas sys1;ts meter_syseng;meter\r"
expect ":KILL"

# cross
respond "*" ":midas sys1;ts cross_syseng;cross\r"
expect ":KILL"

# dired
respond "*" ":midas sys;ts dired_sysen2;dired\r"
expect ":KILL"

# dircpy
respond "*" ":midas sys3;ts dircpy_sysen3;dircop\r"
expect ":KILL"

# hsname
respond "*" ":midas sys2;ts hsname_sysen1;hsname\r"
expect ":KILL"

# arcsal
respond "*" ":midas sys1;ts arcsal_sysen1;arcsal\r"
expect ":KILL"

# acount
respond "*" ":midas sys;ts acount_sysen3;acount\r"
expect ":KILL"

# idents
respond "*" ":midas sysbin;_sysnet;idents\r"
expect ":KILL"
respond "*" ":link device;tcp syn161,sysbin;idents bin\r"

# timsrv
respond "*" ":midas sysbin;timsrv bin_sysnet;timsrv\r"
expect ":KILL"
respond "*" ":link device;tcp syn045,sysbin;timsrv bin\r"

# datsrv
respond "*" ":midas sysbin;_sysnet;datsrv\r"
expect ":KILL"
respond "*" ":link device;tcp syn015,sysbin;datsrv bin\r"

# mailt
respond "*" ":link sys;ts mailt,sys2;ts emacs\r"

# rmtdev
respond "*" ":midas device;atsign rmtdev_gz;rmtdev\r"

# decuuo
respond "*" ":midas decsys;_decuuo\r"
expect ":KILL"
respond "*" ":job decuuo\r"
respond "*" ":load decsys;decuuo bin\r"
respond "*" "purify\033g"
respond "TS DEC" "\r"
respond "*" ":kill\r"
respond "*" ":link sys;ts dec\021 *,must; be here\r"

respond "*" ":midas decsys;_decbot\r"
expect ":KILL"

# Compile ADVENT and dump it out with DECUUO.
respond "*" ":cwd games\r"
respond "*" ":dec sys:f40\r"
respond "*" "advent=advent\r"
respond "CORE USED" "\032"
type ":kill\r"
respond "*" ":dec sys:loader\r"
respond "*" "advent/go\r"
respond "EXIT" ":start\r"
respond "*" "\032"
type ":start 45\r"
respond "Command:" "d"
respond "*" ":pdump sys3; ts advent\r"
respond "*" ":kill\r"

# Chess: timesharing, no TV display
respond "*" ":midas /t games;ts chess2_rg;chess2\r"
respond "with ^C" "TV==0\r\003"
expect ":KILL"

# Old chess?  Timesharing, no TV, no CHEOPS processor.
respond "*" ":midas /t games;ts ocm_chprog;ocm\r"
respond "with ^C" "DSPLY==0\r"
respond "\n" "CHEOPS==0\r\003"
expect ":KILL"

# Spacewar, standalone
respond "*" ":midas /t dsk0:.;@ spcwar_spcwar; newwar\r"
respond "with ^C" "APR==0\r"
respond "\n" "PI==4\r"
respond "\n" "DIS==130\r\003"
respond "ITS version" "NO\r"
respond "interrupt" "NO\r"
respond "ships" "\r"
respond "designs" "\r"
respond "suns" "\r"
respond "recording" "\r"
expect ":KILL"

# Spacewar, timesharing
respond "*" ":midas games;ts spcwar_spcwar; newwar\r"
respond "ITS version" "YES\r"
respond "ships" "\r"
respond "designs" "\r"
respond "suns" "\r"
expect ":KILL"

# MLIFE
respond "*" ":midas /t games;ts mlife_rwg;mlife\r"
respond "with ^C" "APR==0\r"
respond "\n" "PI==4\r"
respond "\n" "DIS==130\r\003"
expect ":KILL"
respond "*" ":midas /t dsk0:.;@ mlife_rwg;mlife\r"
respond "with ^C" "TS==0\r"
respond "\n" "APR==0\r"
respond "\n" "PI==4\r"
respond "\n" "PTP==100\r"
respond "\n" "PTR==104\r"
respond "\n" "TTY==120\r"
respond "\n" "DIS==130\r\003"
expect ":KILL"

# ten50
respond "*" ":midas sys3;ts ten50_mrc; ten50\r"
expect ":KILL"

# stktrn
respond "*" ":fail sail;stktrn rel_sail;stktrn >\r"
respond "*" "\032:kill\r"

# jobdat
respond "*" ":fail sail;jobdat rel_sail;jobdat >\r"
respond "*" "\032:kill\r"

# fail
respond "*" ":fail sail;fail rel_sail;fail >\r"
respond "*" "\032:kill\r"
respond "*" ":delete sail; fail bin\r"
respond "*" ":stink\r"
respond "\n" "m sail;jobdat rel\033l\033\033"
respond "\n" "m sail;stktrn rel\033l\033\033"
respond "\n" "m sail;fail rel\033l\033\033"
respond "\n" "jfail\033\033"
respond "\n" "d\033\033"
respond "\n" "\033\0331l decsys;decbot bin\r"
respond "*" ".jbsa/strt\r"
respond "'" "\033y sys;ts fail\r"
respond "*" ":kill\r"

# who%
respond "*" ":midas sys1;ts who%_sysen3;who%\r"
expect ":KILL"
respond "*" ":link sys1;ts %,sys1;ts who%\r"

# palx
respond "*" ":midas sys;ts palx_sysen1;palx\r"
expect ":KILL"

# itsdev
respond "*" ":link syseng;chsdef 999999,system;chsdef >\r"
respond "*" ":midas device;chaos itsdev_bawden;itsdev\r"
expect ":KILL"

# charfc/charfs
respond "*" ":midas sys1;ts charfc_sysen3;charfc\r"
expect ":KILL"
respond "*" ":link sys1;ts charfs,sys1;ts charfc\r"

# file
respond "*" ":midas device;chaos file_syseng;file\r"
expect ":KILL"

# filei, fileo
respond "*" ":midas device;chaos filei_eak;file\r"
expect ":KILL"
respond "*" ":link device;chaos fileo,device;chaos filei\r"

# ifile
respond "*" ":midas device;chaos ifile_syseng;ifile\r"
expect ":KILL"

# 11sim
respond "*" ":midas /t sys1;ts pdp11_syseng;11sim\r"
respond "end input with ^C" "45p==0\r"
respond "\n" "\003"
expect ":KILL"
respond "*" ":midas sys;ts pdp45_syseng;11sim\r"
expect ":KILL"

# times
respond "*" ":midas sysbin;times bin_sysnet;times\r"
expect ":KILL"
respond "*" ":link sys1;ts ctimes,sysbin;times bin\r"
respond "*" ":link sys1;ts times,sysbin;times bin\r"

# idle
respond "*" ":midas sys1;ts idle_gren;idle\r"
expect ":KILL"

# spell
respond "*" ":midas sys1;ts spell_syseng;spell\r"
expect ":KILL"
respond "*" ":link sys1;ts espell,sys1;ts spell\r"

# jobs
respond "*" ":midas sys2;ts jobs_sysen1;jobs\r"
expect ":KILL"

# hsndev
respond "*" ":midas device;jobdev hsname_sysen1;hsndev\r"
expect ":KILL"
respond "*" ":link device;jobdev hs,device;jobdev hsname\r"
respond "*" ":link device;jobdev hf,device;jobdev hsname\r"

# pr
respond "*" ":midas sys1;ts pr_sysen1;pr\r"
expect ":KILL"
respond "*" ":link sys1;ts call,sys1;ts pr\r"
respond "*" ":link sys1;ts .call,sys1;ts pr\r"
respond "*" ":link sys1;ts uuo,sys1;ts pr\r"
respond "*" ":link sys1;ts uset,sys1;ts pr\r"
respond "*" ":link sys1;ts suset,sys1;ts pr\r"
respond "*" ":link sys1;ts doc,sys1;ts pr\r"
respond "*" ":link sys1;ts intrup,sys1;ts pr\r"
respond "*" ":link sys1;ts ttyvar,sys1;ts pr\r"

respond "*" ":link .info.;its .calls,sysdoc;.calls >\r"
respond "*" ":link .info.;its uuos,sysdoc;uuos >\r"
respond "*" ":link .info.;its usets,sysdoc;usets >\r"
respond "*" ":link .info.;its %pi,sysdoc;%pi >\r"
respond "*" ":link .info.;its ttyvar,sysdoc;ttyvar >\r"

# inline
respond "*" ":midas sys2;ts inline_sysen1;inline\r"
expect ":KILL"

# init
respond "*" ":midas sys3;ts init_sysen2;init\r"
expect ":KILL"

# scandl
respond "*" ":midas sys3;ts scandl_sysen1;scandl\r"
expect ":KILL"

# os
respond "*" ":midas sys1;ts os_sysen2;os\r"
expect ":KILL"

# sn
respond "*" ":midas sys2;ts sn_sysen3;sn\r"
expect ":KILL"

# ttyswp
respond "*" ":midas sys;ts ttyswp_sysen3;ttyswp\r"
expect ":KILL"

# argus
respond "*" ":midas sys2;ts argus_sysen2;argus\r"
expect ":KILL"

# fretty
respond "*" ":midas sys3;ts fretty_sysen2;fretty\r"
expect ":KILL"

# bye
respond "*" ":midas sys1;ts bye_sysen1;bye\r"
expect ":KILL"
respond "*" ":link device;chaos bye,sys1;ts bye\r"

# @
respond "*" ":midas sys;ts @_sysen1;@\r"
expect ":KILL"

# PLAN/CREATE
respond "*" ":midas sys3;ts create_syseng;create\r"
expect ":KILL"
respond "*" ":link sys1;ts plan,sys3;ts create\r"

respond "*" ":midas /t dsk0:.;@ pt_syseng;pt\r"
respond "with ^C" "pi==4\r"
respond "\n" "tty==120\r"
respond "\n" "ptr==104\r"
respond "\n" "\003"
expect ":KILL"

# PTY
respond "*" ":midas sys1;ts pty_sysen1;pty\r"
expect ":KILL"

# PRUFD
respond "*" ":midas sysbin;prufd bin_sysen2;prufd\r"
expect ":KILL"

# patch PRUFD to use the TTY: device rather than the LPT: device
respond "*" ":job prufd\r"
respond "*" ":load sysbin;prufd bin\r"
respond "*" "nlinks+14/ A,,646471\r"
type ":pdump sys1;ts prufd\r"
respond "*" ":kill\r"

# udir
respond "*" ":midas sys3;ts nudir_sysen3; nudir\r"
expect ":KILL"

# STY
respond "*" ":midas sys1;ts sty_sysen2;sty\r"
expect ":KILL"

# luser
respond "*" ":midas sysbin;luser bin_syseng;luser\r"
expect ":KILL"
respond "*" ":link sys1;ts luser,sysbin;luser bin\r"

# ARCCPY
respond "*" ":midas sys2;ts arccpy_sysen2;arccpy\r"
expect ":KILL"

# CALPRT
respond "*" ":midas sys2;ts calprt_sysen2;calprt\r"
expect ":KILL"

# HOSTAB
respond "*" ":midas sys2;ts hostab_sysen1;hostab\r"
expect ":KILL"

# LSPEED
respond "*" ":midas sys1;ts lspeed_syseng;lspeed\r"
expect ":KILL"

# PROBE
respond "*" ":link syseng;its defs,sys;itsdfs >\r"
respond "*" ":midas sysbin;probe bin_bawden;probe\r"
expect ":KILL"
# note: setting debug to 0 and running causes it to pdump itself to
#  sys;ts probe
respond "*" ":job probe\r"
respond "*" ":load sysbin;probe bin\r"
respond "*" "debug/0\r"
type "\033g"
respond "*" ":link sys;ts pb,sys;ts probe\r"

# TTY
respond "*" ":midas sys1;ts tty_sysen1;tty\r"
expect ":KILL"

# RIPDEV
respond "*" ":midas device;atsign r.i.p._sysen2;ripdev\r"
expect ":KILL"

# GMSGS
respond "*" ":midas sys2;ts gmsgs_sysen1;gmsgs\r"
expect ":KILL"
respond "*" ":link sys2;ts expire, sys2;ts gmsgs\r"
respond "*" ":link dragon;daily expire,sys2;ts gmsgs\r"

# X, Y, Z
respond "*" ":midas sys1;ts x_sysen2;x\r"
expect ":KILL"
respond "*" ":link sys1;ts y,sys1;ts x\r"
respond "*" ":link sys1;ts z,sys1;ts x\r"

# LOADP
respond "*" ":midas sys2;ts loadp_sysen1;loadp\r"
expect ":KILL"

# ACCLNK
respond "*" ":midas sys2;ts acclnk_sysen2;acclnk\r"
expect ":KILL"

# MSPLIT
respond "*" ":midas sys2;ts msplit_sysen2;msplit\r"
expect ":KILL"

# TAGS
respond "*" ":midas sys2;ts tags_sysen2;tags\r"
expect ":KILL"

# CHATST
respond "*" ":midas sys2;ts chatst_sysen3;chatst\r"
expect ":KILL"

# STYLOG
respond "*" ":midas sys2;ts stylog_sysen1;stylog\r"
expect ":KILL"

# COMIFY
respond "*" ":midas sys2;ts comify_sysen3;comify\r"
expect ":KILL"

# TMPKIL
respond "*" ":midas sys2;ts tmpkil_syseng;tmpkil\r"
expect ":KILL"
respond "*" ":link dragon;hourly tmpkil,sys2;ts tmpkil\r"

# WHAT
respond "*" ":midas sys2;ts what_syseng;what\r"
expect ":KILL"

# Build KCC support programs: EXECVT, GETSYM, and 20XCSV.
respond "*" ":midas sys2;ts execvt_sysen3;execvt\r" 
expect ":KILL"
respond "*" ":midas kcc;ts getsym_getsym\r"
expect ":KILL"
respond "*" ":midas kcc;ts 20xcsv_20xcsv\r"
expect ":KILL"

# Run GETSYM to get all monitor symbols.
respond "*" ":cwd kcc\r"
respond "*" ":getsym\r"
expect ":KILL"

# UP
respond "*" ":midas sys1;ts up_sysen1;up\r"
expect ":KILL"
respond "*" ":link sys1;ts down, sys1;ts up\r"

# UPTIME
respond "*" ":midas sysbin;uptime bin_sysen1;uptime\r"
expect ":KILL"
respond "*" ":link dragon;hourly uptime,sysbin;uptime bin\r"

# HEXIFY
respond "*" ":midas sys2;ts hexify_sysen3;hexify\r"
expect ":KILL"

# PHOTO
respond "*" ":midas sys2;ts photo_sysen2;photo\r"
expect ":KILL"

# TYPE8
respond "*" ":midas sys;ts type8_sysen3;type8\r"
expect ":KILL"

# USQ
respond "*" ":midas sys2;ts usq_sysen3;usq\r"
expect ":KILL"

# SCRAM
respond "*" ":midas sys2;ts scram_rwk;scram\r"
expect ":KILL"

# HOST
respond "*" ":midas sys3;ts host_sysnet;host\r"
expect ":KILL"

# EXPN/VRFY
respond "*" ":midas sys3;ts expn_sysnet;expn\r"
expect ":KILL"
respond "*" ":link sys3;ts vrfy,sys3;ts expn\r"

# WHOLIN
respond "*" ":midas sys2;ts wholin_sysen2;wholin\r"
expect ":KILL"

# DEVICE; CHAOS TIME
respond "*" ":midas device;chaos time_syseng;ctimsr\r"
expect ":KILL"

# DEVICE; CHAOS SEND
respond "*" ":midas sysbin;_sysnet;senver\r"
expect ":KILL"
respond "*" ":link device;chaos send,sysbin;senver bin\r"

# Alternate DEVICE; CHAOS SEND
respond "*" ":midas sysbin;_sysnet;sends\r"
expect ":KILL"
#respond "*" ":link device;chaos send,sysbin;senver bin\r"

# OBS
respond "*" ":midas sys;ts obs_bawden;obs\r"
expect ":KILL"

# FED
respond "*" ":midas sys;ts fed_sysen2;fed\r"
expect ":KILL"

# XHOST
respond "*" ":midas sys2;ts xhost_sysen3;xhost\r"
expect ":KILL"

# compile lisp compiler
respond "*" ":link comlap;cdmacs fasl,cd.fas >\r"
respond "*" "complr\013"
respond "_" ".temp.;_comlap;comaux\r"
respond "_" ".temp.;_comlap;complr\r"
respond "_" ".temp.;_comlap;faslap\r"
respond "_" ".temp.;_comlap;initia\r"
respond "_" ".temp.;_comlap;maklap\r"
respond "_" ".temp.;_comlap;phas1\r"
respond "_" ".temp.;_comlap;srctrn\r"
respond "_" "\032"
type ":kill\r"
respond "*" ":move .temp.;comaux fasl,comlap;cx.fas 25\r"
respond "*" ":move .temp.;complr fasl,comlap;cl.fas 936\r"
respond "*" ":move .temp.;faslap fasl,comlap;fl.fas 392\r"
respond "*" ":move .temp.;initia fasl,comlap;in.fas 120\r"
respond "*" ":move .temp.;maklap fasl,comlap;mk.fas 80\r"
respond "*" ":move .temp.;phas1 fasl,comlap;ph.fas 86\r"
respond "*" ":move .temp.;srctrn fasl,comlap;st.fas 20\r"

# balanc
respond "*" ":midas sys3;ts balanc_alan;balanc\r"
expect ":KILL"
respond "*" ":link sys3;ts movdir,sys3;ts balanc\r"

# Additional LSPLIB packages
respond "*" "complr\013"
respond "_" "liblsp;iota_libdoc;iota kmp1\r"
respond "_" "liblsp;time_libdoc;time kmp8\r"
respond "_" "liblsp;letfex_libdoc;letfex gjc2\r"
respond "_" "liblsp;lusets fasl_libdoc;lusets\r"
respond "_" "liblsp;break fasl_libdoc;break\r"
respond "_" "liblsp;smurf_libdoc;smurf rwk1\r"
respond "_" "liblsp;fasdmp fasl_rlb%;fasdmp\r"
respond "_" "\032"
type ":kill\r"

# libmax

# all libmax components (well almost all) require libmax;module fasl
# at compile time.  Build it first.

respond "*" "complr\013"
respond "_" "libmax;module\r"
respond "_" "\032"
type ":kill\r"

# libmax;maxmac can't be compiled unless libmax;mforma is (first) compiled.
# However, libmax;mforma uses libmax;macmac.  Hence you end up having to
# compile libmax;mforma first, then libmax;maxmac, and then compiling these
# both a second time.  Otherwise, there are not incorrectly generated FASL
# files for each, but anything that depends on these two packages will also
# have errors during compilation.

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond "274534" "(maklap)"
respond "_" "libmax;mforma\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond "274534" "(maklap)"
respond "_" "libmax;maxmac\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond "274534" "(maklap)"
respond "_" "libmax;mforma\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond "274534" "(maklap)"
respond "_" "libmax;maxmac\r"
respond "_" "\032"
type ":kill\r"

# the following are required to compile some of the libmax;
# FASL files
#
respond "*" ":midas rwk;lfsdef fasl_rwk;lfsdef\r"
expect ":KILL"
respond "*" ":midas rat;ratlap fasl_rat;ratlap\r"
expect ":KILL"
respond "*" ":print maxdmp;..new. (udir)\r"
type ":vk\r"
respond "*" ":link maxdmp;ratlap fasl,rat;ratlap fasl\r"
respond "*" ":link libmax;lusets fasl,liblsp;\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond "274534" "(maklap)"
respond "_" "libmax;ermsgx\r"
respond "_" "libmax;ermsgc\r"
respond "_" "z;fildir\r"
respond "_" "libmax;lmmac\r"
respond "_" "libmax;meta\r"
respond "_" "libmax;lmrund\r"
respond "_" "libmax;lmrun\r"
respond "_" "libmax;displm\r"
respond "_" "libmax;defopt\r"
respond "_" "libmax;mopers\r"
respond "_" "libmax;mrgmac\r"
respond "_" "libmax;nummac\r"
respond "_" "libmax;opshin\r"
respond "_" "libmax;edmac_emaxim;\r"
respond "_" "libmax;procs\r"
respond "_" "libmax;readm\r"
respond "_" "libmax;strmac\r"
respond "_" "libmax;transm\r"
respond "_" "libmax;rzmac_rz;macros\r"
respond "_" "libmax;transq\r"
respond "_" "libmax;mdefun\r"
respond "_" "\032"
type ":kill\r"

# build MAXTUL FASL files

respond "*" ":print maxerr;..new. (udir)\r"
type ":vk\r"
respond "*" ":print maxer1;..new. (udir)\r"
type ":vk\r"

respond "*" "complr\013"
respond "_" "maxtul;strmrg\r"
respond "_" "maxtul;defile\r"
respond "_" "maxtul;docgen\r"
respond "_" "maxtul;query\r"
respond "_" "maxtul;maxtul\r"
respond "_" "maxtul;toolm\r"
respond "_" "maxtul;dclmak\r"
respond "_" "maxtul;mailer\r"
respond "_" "maxtul;mcl\r"
respond "_" "maxtul;timepn\r"
respond "_" "maxtul;expand\r"
respond "_" "maxtul;fsubr!\r"
respond "_" "maxtul;error!\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "maxtul;fasmap\r"
respond "_" "\032"
type ":kill\r"

# define needs (for some reason) to be compiled separately.
# not doing this results in errors compiling macsyma sources,
# such as ELL; HYP >
#
respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond "274534" "(maklap)"
respond "_" "libmax;define\r"
respond "_" "\032"
type ":kill\r"

# build macsyma

respond "*" ":print macsym;..new. (udir)\r"
type ":vk\r"

respond "*" ":link macsym;mdefun fasl,libmax;\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond "274534" "(maklap)"
respond "_" "macsym;ermsgm_maxsrc;ermsgm\r"
respond "_" "maxdoc;tdcl\r"
respond "_" "rlb;bitmac\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "rlb;faslre\r"
respond "_" "rlb;faslro\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":link rlb%;faslre fasl,rlb;\r"
respond "*" ":copy rlb;faslre fasl,liblsp;\r"
respond "*" "l\013"
respond "Alloc?" "n"
respond "*" "(setq pure t)"
type "(load \"liblsp;sharab\")"
type "(load \"liblsp;comrd\")"
type "(load \"liblsp;time\")"
type "(load \"alan;ljob\")"
type "(load \"libmax;define\")"
type "(sstatus gcmax 'fixnum 30000)"
type "(sstatus gcmax 'list 60000)"
type "(load \"maxtul;strmrg\")"
type "(load \"maxtul;docgen\")"
type "(load \"maxtul;query\")"
type "(load \"maxtul;maxtul\")"
type "(load \"maxtul;dclmak\")"
type "(sstatus gcmax 'hunk32 6000)"
respond "T" "(sstatus gcmax 'symbol 12000)"
respond "T" "(sstatus gcmax 'list 60000)"
respond "T" "(sstatus gcmax 'fixnum 20000)"
respond "T" "(dump-it)"
respond "MAXIMUM TOOLAGE>" "load-info\r"
respond "MAXIMUM TOOLAGE>" "gen-mcl-check\r"
respond "MAXIMUM TOOLAGE>" "declare-file-make\r"
respond "MAXIMUM TOOLAGE>" "quit\r"
respond "*" "(quit)"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond "274534" "(maklap)"
respond "_" "libmax;mhayat_rat;mhayat\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond "274534" "(maklap)"
respond "_" "libmax;ratmac_rat;ratmac\r"
respond "_" "\032"
type ":kill\r"

# mforma needs to get recompiled (not sure exactly which
# dependency yet causes the version we've built so far
# not to work, but if recompiled at this point, we're
# able to build macsyma
respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond "274534" "(maklap)"
respond "_" "libmax;mforma\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(setq pure t)"
respond "T" "(load \"liblsp;sharab\")"
respond "276437" "(load \"maxtul;mcldmp (init)\")"
respond "T" "\007"
respond "*" "(dump-mcl 32. t)"
respond "File name->" "\002"
respond ";BKPT" "(quit)"

respond "*" ":midas maxtul;ts mcl_mcldmp midas\r"
respond "*" ":link maxtul;.good. complr,sys;ts complr\r"
respond "*" ":link liblsp;gcdemn fasl,lisp;\r"

respond "*" "complr\013"
respond "_" "mrg;macros\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":print maxout;..new. (udir)\r"
type ":vk\r"
respond "*" ":print share2;..new. (udir)\r"
type ":vk\r"

# Here we actually perform the compilation of Macsyma sources
# For some unknown reason, compilation fails in the same place
# every time (as though COMPLR gets corrupted or its state is
# inconsistent with the ability to compile the next source).  
# A random error is raised and a break level entered.  Simply
# quitting and restarting the process causes it to pick up 
# where it left off and the previously failing source compiles
# fine. The only way I've been able to get past this is by 
# exiting COMPLR and restarting it.  The number of invocations,
# below, appears to get through the whole list of sources. The
# failures appear at the same places each time, so the number
# of COMPLR invocations needed to make it through all the 
# compilations appears to be constant.
# 
# We should investigate whether there is a better way to do this,
# but I (EJS) have not found one that works so far.
#
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion

respond "*" ":maxtul;maxtul\r"
respond "MAXIMUM TOOLAGE>" "load-info\r"
respond "MAXIMUM TOOLAGE>" "merge-incore-system\r"
respond "MAXIMUM TOOLAGE>" "gen-tags\r"
respond "MAXIMUM TOOLAGE>" "quit\r"
respond "*" "(quit)"

respond "*" "aljabr\033\023"
respond "*" ":lisp\r"
type "(load \"libmax;module\")"
respond "132170" "(load \"libmax;define\")"
respond "134541" "(load \"libmax;maxmac\")"
respond "140351" "(load \"libmax;displm\")"
respond "141162" "(load \"aljabr;loader\")"
respond "T" "(loader 999)"
respond "(C1)" "quit();"

respond "*" ":link sys3;ts macsym,maxdmp;loser >\r"

### more lisplib stuff
respond "*" "complr\013"
respond "_" "liblsp;_libdoc;%print\r"
respond "_" "liblsp;_libdoc;6bit\r"
respond "_" "liblsp;_libdoc;apropo\r"
respond "_" "liblsp;_libdoc;arith\r"
respond "_" "liblsp;_libdoc;aryfil\r"
respond "_" "liblsp;_libdoc;atan\r"
respond "_" "liblsp;_libdoc;autodf\r"
respond "_" "liblsp;_libdoc;bboole\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "liblsp;_libdoc;bench\r"
respond "_" "liblsp;_libdoc;binprt\r"
respond "_" "liblsp;_lmlib;gprint\r"
respond "_" "liblsp;_libdoc;carcdr\r"
respond "_" "liblsp;_libdoc;char\r"
respond "_" "liblsp;_libdoc;debug*\r"
respond "_" "liblsp;_libdoc;defsta\r"
respond "_" "lisp;_libdoc;defvst\r"
respond "_" "liblsp;_libdoc;doctor\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "liblsp;_libdoc;dow\r"
respond "_" "liblsp;_libdoc;dribbl\r"
respond "_" "liblsp;_libdoc;dumpgc\r"
respond "_" "liblsp;_libdoc;fake-s\r"
respond "_" "liblsp;_libdoc;fforma\r"
respond "_" "liblsp;_libdoc;filbit\r"
respond "_" "liblsp;_libdoc;fload\r"
respond "_" "liblsp;_libdoc;fontrd\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "liblsp;_libdoc;for\r"
respond "_" "liblsp;_libdoc;gcdemn\r"
respond "_" "liblsp;_libdoc;genfns\r"
respond "_" "liblsp;_libdoc;graphs\r"
respond "_" "liblsp;_libdoc;graphm\r"
respond "_" "liblsp;_libdoc;graph$\r"
respond "_" "liblsp;_libdoc;grapha\r"
respond "_" "liblsp;_libdoc;grapht\r"
respond "_" "liblsp;_libdoc;impdef\r"
respond "_" "liblsp;_libdoc;laugh\r"
respond "_" "liblsp;_libdoc;lchstr\r"
respond "_" "liblsp;_nilcom;let\r"
respond "_" "liblsp;_libdoc;lets\r"
respond "_" "liblsp;_libdoc;linere\r"
respond "_" "liblsp;_libdoc;lspmac\r"
respond "_" "liblsp;_libdoc;lispt\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "liblsp;_libdoc;loop\r"
respond "_" "liblsp;_libdoc;more\r"
respond "_" "liblsp;_libdoc;nshare\r"
respond "_" "liblsp;_libdoc;octal\r"
respond "_" "liblsp;_libdoc;optdef\r"
respond "_" "liblsp;_libdoc;phsprt\r"
respond "_" "liblsp;_libdoc;privob\r"
respond "_" "liblsp;_libdoc;prompt\r"
respond "_" "liblsp;_libdoc;qtrace\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "liblsp;_libdoc;reads\r"
respond "_" "liblsp;_libdoc;redo\r"
respond "_" "liblsp;_libdoc;save\r"
respond "_" "liblsp;_libdoc;sets\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "liblsp;_libdoc;share\r"
respond "_" "liblsp;_libdoc;sixbit\r"
respond "_" "liblsp;_libdoc;split\r"
respond "_" "liblsp;_libdoc;stack\r"
respond "_" "liblsp;_libdoc;statty\r"
respond "_" "liblsp;_libdoc;stepmm\r"
respond "_" "liblsp;_libdoc;stepr\r"
respond "_" "liblsp;_libdoc;string\r"
respond "_" "liblsp;_libdoc;sun\r"
respond "_" "liblsp;_libdoc;trap\r"
respond "_" "liblsp;_libdoc;ttyhak\r"
respond "_" "liblsp;_libdoc;wifs\r"
respond "_" "liblsp;_libdoc;window\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":link liblsp;defvst fasl,lisp;\r"
respond "*" ":link liblsp;format fasl,liblsp;fforma fasl\r"
respond "*" ":link libdoc;lispt info,info;lispt >\r"
respond "*" ":link liblsp;sharpm fasl,lisp;\r"
respond "*" ":copy nilcom;sharpm >,libdoc;sharpm nil\r"
respond "*" ":link libdoc;step info,.info.;\r"
respond "*" ":link libdoc;stepmm info,.info.;lisp stepmm\r"
respond "*" ":copy nilcom;string >,libdoc;string nil\r"

# can't build any more LIBLSP FASLs because directory is full
respond "*" ":delete liblsp;%print unfasl\r"
respond "*" ":delete liblsp;6bit   unfasl\r"
respond "*" ":delete liblsp;apropo unfasl\r"
respond "*" ":delete liblsp;arith  unfasl\r"
respond "*" ":delete liblsp;aryfil unfasl\r"
respond "*" ":delete liblsp;atan   unfasl\r"
respond "*" ":delete liblsp;autodf unfasl\r"
respond "*" ":delete liblsp;bboole unfasl\r"
respond "*" ":delete liblsp;bench  unfasl\r"
respond "*" ":delete liblsp;binprt unfasl\r"
respond "*" ":delete liblsp;break  unfasl\r"
respond "*" ":delete liblsp;bs     unfasl\r"
respond "*" ":delete liblsp;carcdr unfasl\r"
respond "*" ":delete liblsp;char   unfasl\r"
respond "*" ":delete liblsp;comrd  unfasl\r"
respond "*" ":delete liblsp;comred unfasl\r"
respond "*" ":delete liblsp;dbg    unfasl\r"
respond "*" ":delete liblsp;debug* unfasl\r"
respond "*" ":delete liblsp;defsta unfasl\r"
respond "*" ":delete liblsp;doctor unfasl\r"
respond "*" ":delete liblsp;dow    unfasl\r"
respond "*" ":delete liblsp;dprint unfasl\r"
respond "*" ":delete liblsp;dribbl unfasl\r"
respond "*" ":delete liblsp;dumpgc unfasl\r"
respond "*" ":delete liblsp;fake-s unfasl\r"
respond "*" ":delete liblsp;fasdmp unfasl\r"
respond "*" ":delete liblsp;fforma unfasl\r"
respond "*" ":delete liblsp;filbit unfasl\r"
respond "*" ":delete liblsp;fload  unfasl\r"
respond "*" ":delete liblsp;fontrd unfasl\r"
respond "*" ":delete liblsp;for    unfasl\r"
respond "*" ":delete liblsp;gcdemn unfasl\r"
respond "*" ":delete liblsp;genfns unfasl\r"
respond "*" ":delete liblsp;gprint unfasl\r"
respond "*" ":delete liblsp;graph$ unfasl\r"
respond "*" ":delete liblsp;grapha unfasl\r"
respond "*" ":delete liblsp;graphm unfasl\r"
respond "*" ":delete liblsp;graphs unfasl\r"
respond "*" ":delete liblsp;grapht unfasl\r"
respond "*" ":delete liblsp;impdef unfasl\r"
respond "*" ":delete liblsp;iota   unfasl\r"
respond "*" ":delete liblsp;laugh  unfasl\r"
respond "*" ":delete liblsp;lchstr unfasl\r"
respond "*" ":delete liblsp;let    unfasl\r"
respond "*" ":delete liblsp;letfex unfasl\r"
respond "*" ":delete liblsp;lets   unfasl\r"
respond "*" ":delete liblsp;linere unfasl\r"
respond "*" ":delete liblsp;lispm  unfasl\r"
respond "*" ":delete liblsp;lispt  unfasl\r"
respond "*" ":delete liblsp;loop   unfasl\r"
respond "*" ":delete liblsp;lspmac unfasl\r"
respond "*" ":delete liblsp;lusets unfasl\r"
respond "*" ":delete liblsp;more   unfasl\r"
respond "*" ":delete liblsp;nshare unfasl\r"
respond "*" ":delete liblsp;octal  unfasl\r"
respond "*" ":delete liblsp;od     unfasl\r"
respond "*" ":delete liblsp;optdef unfasl\r"
respond "*" ":delete liblsp;phsprt unfasl\r"
respond "*" ":delete liblsp;privob unfasl\r"
respond "*" ":delete liblsp;prompt unfasl\r"
respond "*" ":delete liblsp;qtrace unfasl\r"
respond "*" ":delete liblsp;reads  unfasl\r"
respond "*" ":delete liblsp;redo   unfasl\r"
respond "*" ":delete liblsp;save   unfasl\r"
respond "*" ":delete liblsp;sets   unfasl\r"
respond "*" ":delete liblsp;sharab unfasl\r"
respond "*" ":delete liblsp;share  unfasl\r"
respond "*" ":delete liblsp;sixbit unfasl\r"
respond "*" ":delete liblsp;smurf  unfasl\r"
respond "*" ":delete liblsp;split  unfasl\r"
respond "*" ":delete liblsp;stack  unfasl\r"
respond "*" ":delete liblsp;statty unfasl\r"
respond "*" ":delete liblsp;stepmm unfasl\r"
respond "*" ":delete liblsp;stepr  unfasl\r"
respond "*" ":delete liblsp;string unfasl\r"
respond "*" ":delete liblsp;sun    unfasl\r"
respond "*" ":delete liblsp;time   unfasl\r"
respond "*" ":delete liblsp;trap   unfasl\r"
respond "*" ":delete liblsp;tty    unfasl\r"
respond "*" ":delete liblsp;ttyhak unfasl\r"
respond "*" ":delete liblsp;wifs   unfasl\r"
respond "*" ":delete liblsp;window unfasl\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libdoc) set ira1))"
respond "T" "(maklap)"
respond "_" "liblsp;_libdoc;askusr\r"
respond "_" "liblsp;_pratt;cgrub\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((lisp) cgol fasl))"
respond "312654" "(maklap)"
respond "_" "liblsp;_pratt;cgprin\r"
respond "_" "\032"
type ":kill\r"

# clean up remaining unfasl files in liblsp
respond "*" ":delete liblsp;askusr unfasl\r"
respond "*" ":delete liblsp;cgprin unfasl\r"
respond "*" ":delete liblsp;cgrub unfasl\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(sstatus features Compile-Subload)"
respond "COMPILE-SUBLOAD" "(maklap)"
respond "_" "lisp;_nilcom;subloa\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":midas liblsp;_libdoc;bssq\r"
respond "*" ":midas liblsp;_libdoc;aryadr\r"
respond "*" ":midas lisp;_l;humble\r"
respond "*" ":midas liblsp;_libdoc;link\r"
respond "*" ":midas liblsp;_libdoc;lscall\r"
respond "*" ":link sys;fasdfs 1,lisp;.fasl defs\r"
respond "*" ":midas liblsp;_libdoc;cpyhnk\r"

respond "*" ":link lisp;defns mid,l;defns >\r"
respond "*" ":midas liblsp;_libdoc;fft\r"
respond "*" ":midas liblsp;_libdoc;phase\r"

bootable_tapes

# make output.tape

respond "*" $emulator_escape
create_tape "out/output.tape"
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
