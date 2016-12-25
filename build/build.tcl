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
    } "ITS revived" {
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
    respond "_" "q"
    expect ":KILL"
    respond "*" ":logout\r"
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
respond "*" ":login db\r"
sleep 1
type ":ksfedr\r"
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

respond "*" ":login db\r"
sleep 1
type $emulator_escape
mount_tape "out/sources.tape"
type ":dump\r"
respond "_" "reload "
respond "ARE YOU SURE" "y"
respond "\n" "links crdir sorry\r"
respond "FILE=" "*;* *\r"
expect -timeout 220 "E-O-T"
respond "_" "quit\r"
expect ":KILL"

respond "*" ":print sysbin;..new. (udir)\r"
type ":vk\r"
respond "*" ":xfile build;midas xfile\r"
expect ":kill"

respond "*" ":xfile build;ddt xfile\r"
expect ":kill"

respond "*" ":midas .;_system;its\r"
respond "MACHINE NAME =" "DB\r"
respond "Configuration?" "RP06\r"
expect ":KILL"

respond "*" ":midas .;@ ddt_system;ddt\r"
respond "cpusw" "3\r"
respond "New One Proceed" "1\r"
expect ":KILL"

respond "*" ":xfile build;nsalv xfile\r"
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

respond "*" ":xfile build;ksfedr xfile\r"
expect ":KILL"

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
maybe_pdset

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

respond "*" ":xfile build;teco xfile\r"
expect ":kill"
respond "*" ":xfile build;emacs xfile\r"
expect ":KILL"
expect ":KILL"
respond "*" ":xfile build;teache xfile\r"
respond "*" ":xfile build;dump xfile\r"
respond "*" ":xfile build;stink xfile\r"
respond "*" ":xfile build;pdset xfile\r"
respond "*" ":xfile build;lock xfile\r"
respond "*" ":xfile build;@dev xfile\r"
respond "*" ":xfile build;tctyp xfile\r"
respond "*" ":xfile build;crtsty xfile\r"

respond "*" ":midas sysbin;_sysen2;peek\r"
expect ":KILL"
respond "*" ":job peek\r"
respond "*" ":load sysbin;peek bin\r"
respond "*" "purify\033g"
respond "Idle" "q"
expect ":KILL"

respond "*" ":xfile build;syschk xfile\r"
respond "*" ":xfile build;arcdev xfile\r"
respond "*" ":xfile build;dskdev xfile\r"
respond "*" ":xfile build;whoj xfile\r"
respond "*" ":xfile build;untalk xfile\r"
respond "*" ":xfile build;find xfile\r"
respond "*" ":xfile build;dskuse xfile\r"
respond "*" ":xfile build;ddtdoc xfile\r"
respond "*" ":xfile build;nwatch xfile\r"
respond "*" ":xfile build;taraka xfile\r"
respond "*" ":xfile build;dmpcpy xfile\r"
respond "*" ":xfile build;modems xfile\r"
respond "*" ":xfile build;netime xfile\r"
respond "*" ":xfile build;pfthmg xfile\r"

respond "*" ":link sys; ts p,sys; ts peek\r"

respond "*" ":xfile build;crock xfile\r"
expect "done"
respond "*" ":xfile build;dcrock xfile\r"
expect "done"
respond "*" ":xfile build;instal xfile\r"
respond "*" ":xfile build;loss xfile\r"
respond "*" ":xfile build;dir xfile\r"
respond "*" ":xfile build;mtboot xfile\r"
respond "*" ":xfile build;hosts3 xfile\r"
respond "*" ":xfile build;h3make xfile\r"
respond "*" ":xfile build;@tcp xfile\r"
respond "*" ":xfile build;telser xfile\r"
respond "*" ":xfile build;telnet xfile\r"
respond "*" ":xfile build;supdup xfile\r"
respond "*" ":xfile build;ftps xfile\r"
respond "*" ":xfile build;ftpu xfile\r"
respond "*" ":xfile build;name xfile\r"
respond "*" ":xfile build;mldev xfile\r"
respond "*" ":xfile build;mlslv xfile\r"
respond "*" ":xfile build;dirdev xfile\r"
respond "*" ":xfile build;cftp xfile\r"
respond "*" ":xfile build;chtn xfile\r"
respond "*" ":xfile build;ttloc xfile\r"
respond "*" ":xfile build;dpdev xfile\r"
respond "*" ":xfile build;quote xfile\r"
respond "*" ":xfile build;srccom xfile\r"
respond "*" ":xfile build;dqxdev xfile\r"
respond "*" ":xfile build;comsat xfile\r"
initialize_comsat

respond "*" ":xfile build;rmail xfile\r"
expect ":KILL"
respond "*" ":xfile build;qmail xfile\r"
expect "done"
respond "*" ":xfile build;time xfile\r"
respond "*" ":xfile build;pwmail xfile\r"
expect ":KILL"
respond "*" ":xfile build;lisp xfile\r"
expect "done"

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

respond "*" ":xfile build;binprt xfile\r"

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

respond "*" ":xfile build;dmunch xfile\r"
respond "*" ":xfile build;inqupd xfile\r"
respond "*" ":link inquir;lsrtns 1,syseng;lsrtns >\r"
respond "*" ":xfile build;lookup xfile\r"
respond "*" ":xfile build;pwinit xfile\r"
respond "*" ":copy cstacy;big dat,sysbin;\021 \021 \021 big \021 \021 0dat\r"
respond "*" ":xfile build;pword xfile\r"
respond "*" ":xfile build;panda xfile\r"
respond "*" ":xfile build;sender xfile\r"

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
respond "_" "lisp;_nilcom;subloa\r"
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
respond "_" "lisp;_libdoc;sharab\r"
respond "_" "lisp;_libdoc;bs\r"
respond "_" "\032"
type ":kill\r"

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

#respond "*" "complr\013"
#respond "_" "alan;ljob\r"
#respond "_" "liblsp;_libdoc;gprint rcw3\r"
#respond "_" "alan;lspgub\r"
##source file is damaged
##respond "_" "alan;dprint\r"
#respond "_" "\032"
#type ":kill\r"

respond "*" ":xfile build;nicnam xfile\r"
respond "*" ":xfile build;nicwho xfile\r"
respond "*" ":xfile build;reatta xfile\r"
respond "*" ":xfile build;print xfile\r"
respond "*" ":xfile build;fdir xfile\r"
respond "*" ":xfile build;timoon xfile\r"
respond "*" ":xfile build;ports xfile\r"
respond "*" ":xfile build;sysmsg xfile\r"
respond "*" ":xfile build;meter xfile\r"
respond "*" ":xfile build;cross xfile\r"
respond "*" ":xfile build;dired xfile\r"
respond "*" ":xfile build;hsname xfile\r"
respond "*" ":xfile build;arcsal xfile\r"
respond "*" ":xfile build;acount xfile\r"

# mailt
respond "*" ":link sys;ts mailt,sys2;ts emacs\r"

respond "*" ":xfile build;timsrv xfile\r"
respond "*" ":xfile build;rmtdev xfile\r"
respond "*" ":xfile build;decuuo xfile\r"

# stktrn
respond "*" ":fail sail;stktrn rel_sail;stktrn >\r"
respond "*" "\032:kill\r"

# fail
respond "*" ":fail sail;fail rel_sail;fail >\r"
respond "*" "\032:kill\r"
respond "*" ":stink\r"
respond "\n" "m sail;jobdat rel\033l\033\033"
respond "\n" "m sail;stktrn rel\033l\033\033"
respond "\n" "m sail;fail rel\033l\033\033"
respond "\n" "m sail;fail bin\033y\033\033"
expect ":KILL"
respond "*" ":job fail\r"
respond "*" ":load sail;fail bin\r"
respond "*" "\033\0331l decsys;decbot bin\r"
respond "*" ".jbsa/strt\r"
respond "'" "\033y sys;ts fail\r"
respond "*" ":kill\r"

respond "*" ":xfile build;who% xfile\r"
respond "*" ":xfile build;palx xfile\r"
respond "*" ":link syseng;chsdef 999999,system;chsdef >\r"
respond "*" ":xfile build;itsdev xfile\r"
respond "*" ":xfile build;charfc xfile\r"
respond "*" ":xfile build;times xfile\r"
respond "*" ":xfile build;11sim xfile\r"
respond "*" ":xfile build;idle xfile\r"
respond "*" ":xfile build;spell xfile\r"
respond "*" ":xfile build;jobs xfile\r"
respond "*" ":xfile build;hsndev xfile\r"
respond "*" ":xfile build;pr xfile\r"

respond "*" ":link .info.;its .calls,sysdoc;.calls >\r"
respond "*" ":link .info.;its uuos,sysdoc;uuos >\r"
respond "*" ":link .info.;its usets,sysdoc;usets >\r"
respond "*" ":link .info.;its %pi,sysdoc;%pi >\r"
respond "*" ":link .info.;its ttyvar,sysdoc;ttyvar >\r"

respond "*" ":xfile build;inline xfile\r"
respond "*" ":xfile build;init xfile\r"
respond "*" ":xfile build;scandl xfile\r"
respond "*" ":xfile build;os xfile\r"
respond "*" ":xfile build;argus xfile\r"
respond "*" ":xfile build;fretty xfile\r"
respond "*" ":xfile build;bye xfile\r"
respond "*" ":xfile build;@ xfile\r"
respond "*" ":xfile build;create xfile\r"
respond "*" ":xfile build;pty xfile\r"
respond "*" ":xfile build;prufd xfile\r"
respond "*" ":xfile build;sty xfile\r"
respond "*" ":xfile build;luser xfile\r"
respond "*" ":xfile build;arccpy xfile\r"
respond "*" ":xfile build;calprt xfile\r"
respond "*" ":xfile build;hostab xfile\r"
respond "*" ":xfile build;lspeed xfile\r"
respond "*" ":xfile build;probe xfile\r"
respond "*" ":xfile build;tty xfile\r"
respond "*" ":xfile build;ripdev xfile\r"
respond "*" ":xfile build;gmsgs xfile\r"
respond "*" ":xfile build;x xfile\r"
respond "*" ":xfile build;loadp xfile\r"
respond "*" ":xfile build;acclnk xfile\r"
respond "*" ":xfile build;msplit xfile\r"
respond "*" ":xfile build;tags xfile\r"
respond "*" ":xfile build;chatst xfile\r"
respond "*" ":xfile build;stylog xfile\r"
respond "*" ":xfile build;comify xfile\r"
respond "*" ":xfile build;tmpkil xfile\r"
respond "*" ":xfile build;what xfile\r"
respond "*" ":xfile build;execvt xfile\r"
respond "*" ":xfile build;hexify xfile\r"
respond "*" ":xfile build;uptime xfile\r"
respond "*" ":xfile build;photo xfile\r"
respond "*" ":xfile build;type8 xfile\r"
respond "*" ":xfile build;usq xfile\r"
respond "*" ":xfile build;host xfile\r"
respond "*" ":xfile build;wholin xfile\r"
respond "*" ":xfile build;obs xfile\r"
respond "*" ":xfile build;fed xfile\r"
respond "*" ":xfile build;xhost xfile\r"

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
