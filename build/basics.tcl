log_progress "ENTERING BUILD SCRIPT: BASICS"

patch_its_and_go
pdset

respond "*" ":login db\r"
sleep 1

# Normally we'd save the old ITS as OITS, but since it was used for
# bootstrapping with another configuration, it's no longer any use.
type ":delete .;@ its\r"

# The new ITS is now canonical.
respond "*" ":rename .;@ nits, .;@ its\r"
sleep 1

respond "*" ":midas sysbin;_syseng;dump\r"
dump_switches
expect ":KILL"
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
respond "*" ":midas sys1; ts tctyp_syseng;tctyp\r"
expect ":KILL"
respond "*" ":link sys1;ts tctype, sys1; ts tctyp\r"

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
respond "*" ":link sys3; ts vtfix, sys; ts lock\r"

respond "*" ":midas sysbin;_syseng;@dev\r"
expect ":KILL"
respond "*" ":delete sys;atsign device\r"
respond "*" ":link sys;atsign device,sysbin;@dev bin\r"

respond "*" ":midas sysbin;_syseng;crtsty\r"
expect ":KILL"
respond "*" ":job crtsty\r"
respond "*" ":load sysbin;crtsty bin\r"
respond "*" "purify\033g"
respond " BIN" "\r"
respond "*" ":kill\r"
respond "*" ":link sys3;ts crtsty,sysbin;crtsty bin\r"

# CTN, networking "supdup" CRTSTY
respond "*" ":midas /t sysbin;ctn bin_syseng; crtsty\r"
respond "with ^C" "NET==1\r\003"
expect ":KILL"
respond "*" ":job ctn\r"
respond "*" ":load sysbin; ctn bin\r"
respond "*" "purify\033g"
respond " BIN" "sys3; ts ctn\r"
respond "*" ":kill\r"

respond "*" ":midas /t sysbin;_sysen2;peek\r"
peek_switches
expect ":KILL"
respond "*" ":job peek\r"
respond "*" ":load sysbin;peek bin\r"
respond "*" "purify\033g"
respond {$G} "q"
expect ":KILL"
respond "*" ":link sys; ts p,sys; ts peek\r"

respond "*" ":midas device;jobdev arc_syseng;arcdev\r"
expect ":KILL"
respond "*" ":link device;jobdev ar,device;jobdev arc\r"

respond "*" ":midas device;oarcdv bin_sysen2; dmarcd\r"
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

respond "*" ":midas channa;atsign taraka_taraka\r"
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

respond "*" ":midas channa;rakash papsav_sysen3;papsav\r"
expect ":KILL"

respond "*" ":midas dragon;rakash pfthmg_syseng; pft\r"
respond "mcp=" "0\r"
expect ":KILL"
respond "*" ":link channa; rakash pfthmg,dragon; rakash pfthmg\r"

# LOSS device
respond "*" ":midas device;jobdev loss_syseng;loss\r"
expect ":KILL"
respond "*" ":link device;jobdev los,device;jobdev loss\r"

respond "*" ":midas syshst;_syshst;hosts3\r"
expect ":KILL"
respond "*" ":link syshst;ts hosts3,syshst;hosts3 bin\r"

respond "*" ":link syseng;t20mac 999999,system;t20mac >\r"

respond "*" ":midas syshst;_syshst;h3make\r"
expect ":KILL"
respond "*" ":link syshst;ts h3make,syshst;h3make bin\r"

# Run H3MAKE to make the SYSBIN; HOSTS3 > database.  H3MAKE looks for
# an older version, so there is an empty placeholder to make this
# work.  H3MAKE runs in the background and leaves either SYSHST; H3TYO
# or H3ERR with the output from the HOSTS3 program.  The placeholder
# file is removed later.
respond "*" ":syshst;h3make\r"
expect {$$^K}

# basic TCP support
respond "*" ":midas sys;atsign tcp_syseng;@tcp\r"
expect ":KILL"

# Chaosnet support
respond "*" ":midas sysbin;_syseng;@chaos\r"
expect ":KILL"
respond "*" ":link sys;atsign chaos,sysbin;@chaos bin\r"

# ARPANET support
respond "*" ":midas sys;atsign netrfc_sysen2; netrfc\r"
expect ":KILL"

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

# Old NIC Arpanet HOSTS TXT.  Run a TECO macro to generate
# SYSENG;HOSTS PRETTY and HOSTS INSERT.
respond "*" ":teco\r"
respond "&" "ER SYSENG;HOSTER >\033 Y HXM MM\033\033"
respond "&" "\032"
respond ")   " ":kill\r"

# telnet server
respond "*" ":midas sysbin;telser_sysnet;telser\r"
expect ":KILL"

# port 23 (telnet) uses TELSER
respond "*" ":link device;tcp syn027,sysbin;telser bin\r"

# telnet client
respond "*" ":midas sysbin;telnet_sysnet;telnet\r"
expect ":KILL"

respond "*" ":link sys;ts telnet,sysbin;telnet bin\r"
respond "*" ":link sys;ts tcptn,sys;ts telnet\r"
respond "*" ":link sys;ts ttn,sys;ts telnet\r"
respond "*" ":link sys;ts ncptn,sys;ts telnet\r"
respond "*" ":link sys;ts oth,sys;ts telnet\r"

# supdup port (95) uses telser
respond "*" ":link device;tcp syn137,sysbin;telser bin\r"

# supdup client
respond "*" ":midas sysbin;supdup_sysnet;supdup\r"
expect ":KILL"

respond "*" ":link sys1;ts supdup,sysbin;supdup bin\r"

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

# Build INQUIR;INQUPD BIN
respond "*" ":midas inquir;inqupd bin_inquir;inqupd\r"
expect ":KILL"

# Build INQUIR;DIRS BIN
respond "*" ":midas inquir;dirs bin_inquir;dmunch\r"
expect ":KILL"

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
respond "*" ":midas sysbin;panda bin_sysen1;pword\r"
respond "Is this to be a PANDA?" "yes\r"
expect ":KILL"
respond "*" ":midas sysbin;pword bin_sysen1;pword\r"
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

# palx
respond "*" ":midas sys;ts palx_sysen1;palx\r"
expect ":KILL"

# GT40 boot ROM.
respond "*" ":palx gt40;_gt40;bootvt\r"
expect ":KILL"

# PLAN/CREATE
respond "*" ":midas sys3;ts create_syseng;create\r"
expect ":KILL"
respond "*" ":link sys1;ts plan,sys3;ts create\r"

processor_basics
