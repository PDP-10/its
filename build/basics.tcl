log_progress "ENTERING BUILD SCRIPT: BASICS"

patch_its_and_go
pdset

respond "*" ":login db\r"
type ":vk\r"

# Normally we'd save the old ITS as OITS, but since it was used for
# bootstrapping with another configuration, it's no longer any use.
respond "*" ":delete .;@ its\r"

# The new ITS is now canonical.
respond "*" ":rename .;@ nits, .;@ its\r"

midas "sysbin;" "syseng;dump" dump_switches
respond "*" ":delete sys;ts dump\r"
make_link "sys;ts dump" "sysbin;dump bin"
make_link "sys;ts load" "sys;ts dump"

type ":dump\r"
respond "_" "load links crdir sorry\r"
respond "FILE=" "*;* *\r"
expect -timeout 3000 "E-O-T"
respond "_" "quit\r"
expect ":KILL"

mkdir "sys1"
mkdir "sys2"
mkdir "sys3"
mkdir "device"
mkdir "cstacy"

# TCTYP
midas "sys1; ts tctyp" "syseng;tctyp"
make_link "sys1;ts tctype" " sys1; ts tctyp"

source $build/emacs.tcl

# TAGS
midas "sys2;ts tags" "sysen2;tags"

# magdmp, paper tape
midas "dsk0:.;" "syseng;magdmp" {
    respond "PTRHRI=" "y\r"
    magdmp_switches
}

# magdmp
midas "sys1;ts magfrm" "syseng;magfrm"

# STINK linker
midas "sys1;ts stink" "sysen2;stink"

# PDSET
midas "sysbin;" "sysen1;pdset"
respond "*" ":delete sys;ts pdset\r"
make_link "sys;ts pdset" "sysbin;pdset bin"

# LOCK
midas "sysbin;" "syseng;lock"
respond "*" ":delete sys;ts lock\r"
make_link "sys;ts lock" "sysbin;lock bin"
make_link "sys3; ts vtfix" " sys; ts lock"

# ATSIGN DEVICE
midas "sysbin;" "syseng;@dev\r"
respond "*" ":delete sys;atsign device\r"
make_link "sys;atsign device" "sysbin;@dev bin"

# CRTSTY
midas "sysbin;" "syseng;crtsty"
purify crtsty "sysbin;crtsty bin" {
    respond "*" "purify\033g"
    respond " BIN" "\r"
}
make_link "sys3;ts crtsty" "sysbin;crtsty bin"

# CTN, networking "supdup" CRTSTY
midast "sysbin;ctn bin" "syseng; crtsty" {
    respond "with ^C" "NET==1\r\003"
}
purify ctn "sysbin; ctn bin" {
    respond "*" "purify\033g"
    respond " BIN" "sys3; ts ctn\r"
}

midast "sysbin;" "sysen2;peek" peek_switches
purify peek "sysbin;peek bin" {
    respond "*" "purify\033g"
    respond {$G} "q"
    expect ":KILL"
}
make_link "sys; ts p" "sys; ts peek"

midas "device;jobdev arc" "syseng;arcdev"
make_link "device;jobdev ar" "device;jobdev arc"

midas "device;oarcdv bin" "sysen2; dmarcd"

# JOBDEV D (DSKDEV)
midas "device;jobdev d" "syseng;dskdev"

midas "sysbin;" "sysen2;find"
make_link "sys;ts find" "sysbin;find bin"
make_link "sys;ts fi" "sys;ts find"
make_link "sys;ts comb" "sys;ts find"
make_link "sys2;ts lf" "sys;ts find"

midas "sys;ts dskuse" "syseng;dskuse"

midas "channa;atsign taraka" "taraka"
make_link "sys; atsign dragon" "channa; atsign taraka"

midas "channa;rakash dmpcpy" "syseng; dmpcpy"

midas "channa;rakash modems" "syseng; modems"
make_link "channa;ts modems" "channa;rakash modems"
make_link "dragon;hourly modems" "channa;ts modems"

midas "channa;rakash netime" "sysen1; netime"
make_link "channa;ts netime" "channa;rakash netime"

midas "channa;rakash papsav" "sysen3;papsav"

midas "dragon;rakash pfthmg" "syseng; pft" {
    respond "mcp=" "0\r"
}
make_link "channa; rakash pfthmg" "dragon; rakash pfthmg"

# LOSS device
midas "device;jobdev loss" "syseng;loss"
make_link "device;jobdev los" "device;jobdev loss"

midas "syshst;" "syshst;hosts3"
make_link "syshst;ts hosts3" "syshst;hosts3 bin"

make_link "syseng;t20mac 999999" "system;t20mac >"

midas "syshst;" "syshst;h3make"
make_link "syshst;ts h3make" "syshst;h3make bin"

# Run H3MAKE to make the SYSBIN; HOSTS3 > database.  H3MAKE looks for
# an older version, so there is an empty placeholder to make this
# work.  H3MAKE runs in the background and leaves either SYSHST; H3TYO
# or H3ERR with the output from the HOSTS3 program.  The placeholder
# file is removed later.
respond "*" ":syshst;h3make\r"
expect {$$^K}

# basic TCP support
midas "sys;atsign tcp" "syseng;@tcp"

# Chaosnet support
midas "sysbin;" "syseng;@chaos"
make_link "sys;atsign chaos" "sysbin;@chaos bin"

# ARPANET support
if { ! [string equal "$mchn" "DM"] } {
    midas "sys;atsign netrfc" "syseng; netrfc" {
        respond "DEMONP=" "0\r"
    }
}

# CHA: and CHAOS: device
midas "device;jobdev cha" "dcp;chadev"
make_link "device;jobdev chaos" "device;jobdev cha"

make_link "syseng;netwrk 999999" "sysnet;netwrk >"

# CHAOS ARPA/NCP/TCP gateway
midas "sysnet;" "arpa"
make_link "device;chaos arpa" " sysnet;arpa bin"
make_link "device;chaos ncp" " sysnet;arpa bin"
make_link "device;chaos tcp" " sysnet;arpa bin"

midas ".;ts redrct" "sysnet;redrct"

# Old NIC Arpanet HOSTS TXT.  Run a TECO macro to generate
# SYSENG;HOSTS PRETTY and HOSTS INSERT.
respond "*" ":teco\r"
respond "&" "ER SYSENG;HOSTER >\033 Y HXM MM\033\033"
respond "&" "\032"
respond ")   " ":kill\r"

# telnet server
midas "sysbin;telser" "sysnet;telser"
# TCP port 23 (telnet) uses TELSER
make_link "device;tcp syn027" "sysbin;telser bin"
# NCP sockets 1 and 23 use TELSER
arpanet "rfc001" "sysbin;telser bin"
arpanet "rfc027" "sysbin;telser bin"

# Old telnet server
midas "sys;atsign stelnt" "syseng;stelnt"

# telnet client
midas "sysbin;telnet" "sysnet;telnet"
make_link "sys;ts telnet" "sysbin;telnet bin"
make_link "sys;ts tcptn" "sys;ts telnet"
make_link "sys;ts ttn" "sys;ts telnet"
make_link "sys;ts ncptn" "sys;ts telnet"
make_link "sys;ts oth" "sys;ts telnet"

# old user telnet
midas "sys1;ts ut" "syseng;ut"

# supdup TCP port (95) uses telser
make_link "device;tcp syn137" "sysbin;telser bin"
# NCP socket 95 uses TELSER
arpanet "rfc137" "sysbin;telser bin"
# We don't know why
arpanet "rcf107" "sys1;ts supdup"

# supdup client
midas "sysbin;supdup" "sysnet;supdup"
make_link "sys1;ts supdup" "sysbin;supdup bin"

# these two links are expected by sysnet; ftps > and are present
# in the PI distribution
make_link "ksc;nuuos 999999" "klh;nuuos >"
make_link "ksc;macros 999999" "klh;macros >"
make_link "ksc;out 999999" "klh; out >"

midas "sysbin;ftps" "sysnet;ftps"
make_link "device;tcp syn025" "sysbin;ftps bin"
make_link "device;tcp syn031" "sysbin;ftps bin"
make_link "device;chaos smtp" "sysbin;ftps bin"
arpanet "rfc003" "sysbin;ftps bin"
arpanet "rfc025" "sysbin;ftps bin"
arpanet "rfc031" "sysbin;ftps bin"
arpanet "rfc103" "sysbin;ftps bin"

midas "sysbin;ftpu" "sysnet;ftpu"
make_link "sys;ts ftp" "sysbin;ftpu bin"

# NAME
midas "sysbin;name" "sysen2;name"

make_link "syseng;ttytyp 999999" "system;ttytyp >"

# Build INQUIR;INQUPD BIN
midas "inquir;inqupd bin" "inquir;inqupd"

# Build INQUIR;DIRS BIN
midas "inquir;dirs bin" "inquir;dmunch"

# create .temp.;lsr1 empty
purify lsrini "inquir;inqupd bin" {
    respond "*" "\033g"
    expect ":KILL"
}

# create inquir;lsr1 1
respond "*" ":move .temp.;lsr1 empty,inquir;lsr1 1\r"

# Now create INQUIR updates in new database
#   note: this reads the file inquir;.upd1. > and loads entries into the LSR database
purify inqupd "inquir;inqupd bin" {
    respond "*" "\033g"
    expect ":KILL"
}

# pword/panda
midas "sysbin;panda bin" "sysen1;pword" {
    respond "Is this to be a PANDA?" "yes\r"
}
midas "sysbin;pword bin" "sysen1;pword" {
    respond "Is this to be a PANDA?" "no\r"
}
midas "sysbin;pwinit bin" "sysen1;pwinit"
purify pwinit "sysbin;pwinit" {
    respond "*" "\033g"
}
respond "*" ":copy cstacy;big dat,sysbin;\021 \021 \021 big \021 \021 0dat\r"
purify panda "sysbin;panda bin" {
    # set password to "panda"
    respond "*" "spword/107150326162\r"
    type "purify\033g"
    respond "*" ":pdump sysbin;panda bin\r"
}
make_link "sys;atsign pword" "sysbin;pword bin"
make_link "sys;ts panda" "sysbin;panda bin"

# Remove placeholder SYSBIN; HOSTS3 database.
respond "*" ":delete sysbin; hosts3 <\r"

respond "*" ":copy sysbin;name bin,sys;ts name\r"
purify name "sys;ts name" {
    respond "*" "debug/"
    respond "-1" "0\r\033g"
}

make_link "sys1;ts when" "sys;ts name"
make_link "sys1;ts whoare" "sys;ts name"
make_link "sys1;ts whois" "sys;ts name"
make_link "sys1;ts wheres" "sys1;ts whois"
make_link "sys1;ts supnam" "sys;ts name"
make_link "sys1;ts finger" "sys;ts name"
make_link "sys;ts f" "sys;ts name"
make_link "sys2;ts n" "sys;ts name"
make_link "device;tcp syn117" "sys;ts name"
make_link "device;chaos name" "sys;ts name"
arpanet "rfc117" "sys;ts name"

midas "device;atsign mldev" "sysen2;mldev"
make_link "device;jobdev db" "device;atsign mldev"
make_link "device;jobdev es" "device;atsign mldev"
make_link "device;jobdev no" "device;atsign mldev"
make_link "device;jobdev sj" "device;atsign mldev"
make_link "device;jobdev up" "device;atsign mldev"

midas "device;atsign mlslv" "sysen2;mlslv"
make_link "device;tcp syn123" "device;atsign mlslv"
make_link "device;chaos mldev" "device;atsign mlslv"

midas "device;jobdev fc" "sysen2;fcdev"

midas "device;atsign dirdev" "syseng;dirdev"
make_link "device;jobdev dir" "device;atsign dirdev"
make_link "device;jobdev dirdb" "device;atsign dirdev"
make_link "device;jobdev dires" "device;atsign dirdev"
make_link "device;jobdev dirno" "device;atsign dirdev"
make_link "device;jobdev dirsj" "device;atsign dirdev"
make_link "device;jobdev dirup" "device;atsign dirdev"

midas "sys1;ts cftp" "sysen2; cftp" {
    respond "KLp==" "0\r"
}

make_link "device;chaos telnet" "sysbin;telser bin"
make_link "device;chaos supdup" "sysbin;telser bin"

# decuuo
midas "decsys;" "decuuo"
purify decuuo "decsys;decuuo bin" {
    respond "*" "purify\033g"
    respond "TS DEC" "\r"
}
make_link "sys;ts dec\021 *" "must; be here"

midas "decsys;" "decbot"

# palx
midas "sys;ts palx" "sysen1;palx"

# GT40 boot ROM.
palx "gt40;" "gt40;bootvt"

# PLAN/CREATE
midas "sys3;ts create" "syseng;create"
make_link "sys1;ts plan" "sys3;ts create"

processor_basics
