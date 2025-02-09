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
respond "*" ":link sys;ts dump,sysbin;dump bin\r"
respond "*" ":link sys;ts load,sys;ts dump\r"

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
respond "*" ":link sys1;ts tctype, sys1; ts tctyp\r"

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
respond "*" ":link sys;ts pdset,sysbin;pdset bin\r"

# LOCK
midas "sysbin;" "syseng;lock"
respond "*" ":delete sys;ts lock\r"
respond "*" ":link sys;ts lock,sysbin;lock bin\r"
respond "*" ":link sys3; ts vtfix, sys; ts lock\r"

# ATSIGN DEVICE
midas "sysbin;" "syseng;@dev\r"
respond "*" ":delete sys;atsign device\r"
respond "*" ":link sys;atsign device,sysbin;@dev bin\r"

# CRTSTY
midas "sysbin;" "syseng;crtsty"
respond "*" ":job crtsty\r"
respond "*" ":load sysbin;crtsty bin\r"
respond "*" "purify\033g"
respond " BIN" "\r"
respond "*" ":kill\r"
respond "*" ":link sys3;ts crtsty,sysbin;crtsty bin\r"

# CTN, networking "supdup" CRTSTY
midast "sysbin;ctn bin" "syseng; crtsty" {
    respond "with ^C" "NET==1\r\003"
}
respond "*" ":job ctn\r"
respond "*" ":load sysbin; ctn bin\r"
respond "*" "purify\033g"
respond " BIN" "sys3; ts ctn\r"
respond "*" ":kill\r"

midast "sysbin;" "sysen2;peek" peek_switches
respond "*" ":job peek\r"
respond "*" ":load sysbin;peek bin\r"
respond "*" "purify\033g"
respond {$G} "q"
expect ":KILL"
respond "*" ":link sys; ts p,sys; ts peek\r"

midas "device;jobdev arc" "syseng;arcdev"
respond "*" ":link device;jobdev ar,device;jobdev arc\r"

midas "device;oarcdv bin" "sysen2; dmarcd"

# JOBDEV D (DSKDEV)
midas "device;jobdev d" "syseng;dskdev"

midas "sysbin;" "sysen2;find"
respond "*" ":link sys;ts find,sysbin;find bin\r"
respond "*" ":link sys;ts fi,sys;ts find\r"
respond "*" ":link sys;ts comb,sys;ts find\r"
respond "*" ":link sys2;ts lf,sys;ts find\r"

midas "sys;ts dskuse" "syseng;dskuse"

midas "channa;atsign taraka" "taraka"
respond "*" ":link sys; atsign dragon,channa; atsign taraka\r"

midas "channa;rakash dmpcpy" "syseng; dmpcpy"

midas "channa;rakash modems" "syseng; modems"
respond "*" ":link channa;ts modems,channa;rakash modems\r"
respond "*" ":link dragon;hourly modems,channa;ts modems\r"

midas "channa;rakash netime" "sysen1; netime"
respond "*" ":link channa;ts netime,channa;rakash netime\r"

midas "channa;rakash papsav" "sysen3;papsav"

midas "dragon;rakash pfthmg" "syseng; pft" {
    respond "mcp=" "0\r"
}
respond "*" ":link channa; rakash pfthmg,dragon; rakash pfthmg\r"

# LOSS device
midas "device;jobdev loss" "syseng;loss"
respond "*" ":link device;jobdev los,device;jobdev loss\r"

midas "syshst;" "syshst;hosts3"
respond "*" ":link syshst;ts hosts3,syshst;hosts3 bin\r"

respond "*" ":link syseng;t20mac 999999,system;t20mac >\r"

midas "syshst;" "syshst;h3make"
respond "*" ":link syshst;ts h3make,syshst;h3make bin\r"

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
respond "*" ":link sys;atsign chaos,sysbin;@chaos bin\r"

# ARPANET support
if { ! [string equal "$mchn" "DM"] } {
    midas "sys;atsign netrfc" "syseng; netrfc" {
        respond "DEMONP=" "0\r"
    }
}

# CHA: and CHAOS: device
midas "device;jobdev cha" "dcp;chadev"
respond "*" ":link device;jobdev chaos,device;jobdev cha\r"

respond "*" ":link syseng;netwrk 999999,sysnet;netwrk >\r"

# CHAOS ARPA/NCP/TCP gateway
midas "sysnet;" "arpa"
respond "*" ":link device;chaos arpa, sysnet;arpa bin\r"
respond "*" ":link device;chaos ncp, sysnet;arpa bin\r"
respond "*" ":link device;chaos tcp, sysnet;arpa bin\r"

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
respond "*" ":link device;tcp syn027,sysbin;telser bin\r"
# NCP sockets 1 and 23 use TELSER
arpanet "rfc001" "sysbin;telser bin"
arpanet "rfc027" "sysbin;telser bin"

# Old telnet server
midas "sys;atsign stelnt" "syseng;stelnt"

# telnet client
midas "sysbin;telnet" "sysnet;telnet"
respond "*" ":link sys;ts telnet,sysbin;telnet bin\r"
respond "*" ":link sys;ts tcptn,sys;ts telnet\r"
respond "*" ":link sys;ts ttn,sys;ts telnet\r"
respond "*" ":link sys;ts ncptn,sys;ts telnet\r"
respond "*" ":link sys;ts oth,sys;ts telnet\r"

# old user telnet
midas "sys1;ts ut" "syseng;ut"

# supdup TCP port (95) uses telser
respond "*" ":link device;tcp syn137,sysbin;telser bin\r"
# NCP socket 95 uses TELSER
arpanet "rfc137" "sysbin;telser bin"
# We don't know why
arpanet "rcf107" "sys1;ts supdup"

# supdup client
midas "sysbin;supdup" "sysnet;supdup"
respond "*" ":link sys1;ts supdup,sysbin;supdup bin\r"

# these two links are expected by sysnet; ftps > and are present
# in the PI distribution
respond "*" ":link ksc;nuuos 999999,klh;nuuos >\r"
respond "*" ":link ksc;macros 999999,klh;macros >\r"
respond "*" ":link ksc;out 999999,klh; out >\r"

midas "sysbin;ftps" "sysnet;ftps"
respond "*" ":link device;tcp syn025,sysbin;ftps bin\r"
respond "*" ":link device;tcp syn031,sysbin;ftps bin\r"
respond "*" ":link device;chaos smtp,sysbin;ftps bin\r"
arpanet "rfc003" "sysbin;ftps bin"
arpanet "rfc025" "sysbin;ftps bin"
arpanet "rfc031" "sysbin;ftps bin"
arpanet "rfc103" "sysbin;ftps bin"

midas "sysbin;ftpu" "sysnet;ftpu"
respond "*" ":link sys;ts ftp,sysbin;ftpu bin\r"

# NAME
midas "sysbin;name" "sysen2;name"

respond "*" ":link syseng;ttytyp 999999,system;ttytyp >\r"

# Build INQUIR;INQUPD BIN
midas "inquir;inqupd bin" "inquir;inqupd"

# Build INQUIR;DIRS BIN
midas "inquir;dirs bin" "inquir;dmunch"

# create .temp.;lsr1 empty
respond "*" "lsrini\033j"
respond "*" "\033linquir;inqupd bin\r"
respond "*" "\033g"
expect ":KILL"

# create inquir;lsr1 1
respond "*" ":move .temp.;lsr1 empty,inquir;lsr1 1\r"

# Now create INQUIR updates in new database
#   note: this reads the file inquir;.upd1. > and loads entries into the LSR database
respond "*" "inqupd\033j"
respond "*" "\033linquir;inqupd bin\r"
respond "*" "\033g"
expect ":KILL"

# pword/panda
midas "sysbin;panda bin" "sysen1;pword" {
    respond "Is this to be a PANDA?" "yes\r"
}
midas "sysbin;pword bin" "sysen1;pword" {
    respond "Is this to be a PANDA?" "no\r"
}
midas "sysbin;pwinit bin" "sysen1;pwinit"
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

# Remove placeholder SYSBIN; HOSTS3 database.
respond "*" ":delete sysbin; hosts3 <\r"

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
arpanet "rfc117" "sys;ts name"

midas "device;atsign mldev" "sysen2;mldev"
respond "*" ":link device;jobdev db,device;atsign mldev\r"
respond "*" ":link device;jobdev es,device;atsign mldev\r"
respond "*" ":link device;jobdev no,device;atsign mldev\r"
respond "*" ":link device;jobdev sj,device;atsign mldev\r"
respond "*" ":link device;jobdev up,device;atsign mldev\r"

midas "device;atsign mlslv" "sysen2;mlslv"
respond "*" ":link device;tcp syn123,device;atsign mlslv\r"
respond "*" ":link device;chaos mldev,device;atsign mlslv\r"

midas "device;jobdev fc" "sysen2;fcdev"

midas "device;atsign dirdev" "syseng;dirdev"
respond "*" ":link device;jobdev dir,device;atsign dirdev\r"
respond "*" ":link device;jobdev dirdb,device;atsign dirdev\r"
respond "*" ":link device;jobdev dires,device;atsign dirdev\r"
respond "*" ":link device;jobdev dirno,device;atsign dirdev\r"
respond "*" ":link device;jobdev dirsj,device;atsign dirdev\r"
respond "*" ":link device;jobdev dirup,device;atsign dirdev\r"

midas "sys1;ts cftp" "sysen2; cftp" {
    respond "KLp==" "0\r"
}

respond "*" ":link device;chaos telnet,sysbin;telser bin\r"
respond "*" ":link device;chaos supdup,sysbin;telser bin\r"

# decuuo
midas "decsys;" "decuuo"
respond "*" ":job decuuo\r"
respond "*" ":load decsys;decuuo bin\r"
respond "*" "purify\033g"
respond "TS DEC" "\r"
respond "*" ":kill\r"
respond "*" ":link sys;ts dec\021 *,must; be here\r"

midas "decsys;" "decbot"

# palx
midas "sys;ts palx" "sysen1;palx"

# GT40 boot ROM.
palx "gt40;" "gt40;bootvt"

# PLAN/CREATE
midas "sys3;ts create" "syseng;create"
respond "*" ":link sys1;ts plan,sys3;ts create\r"

processor_basics
