respond "*" ":print teach;..new. (udir)\r"
type ":vk\r"

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

respond "*" ":midas sys3;ts syslod_sysen1;syslod\r"
expect ":KILL"

respond "*" ":midas sys3;ts vv_sysen2;vv\r"
expect ":KILL"
respond "*" ":link sys3;ts vj,sys3;ts vv\r"
respond "*" ":link sys3;ts detree,sys3;ts vv\r"

respond "*" ":midas sys2;ts syschk_sysen2;syschk\r"
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

respond "*" ":midas sys3;ts ddtdoc_syseng;ddtdoc\r"
expect ":KILL"

respond "*" ":midas sys1;ts nwatch_sysen1;nwatch\r"
expect ":KILL"

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

respond "*" ":midas sys1;ts dir_bawden;dir^k\r"
expect ":KILL"

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

respond "*" ":midas sys2;ts limeri_sysen1;limeri\r"
respond "Use what filename instead?" "eak; lims >\r"
expect ":KILL"

respond "*" ":link sys2;ts limmer,sys2;ts limeri\r"

respond "*" ":midas sysbin;_eak;limser\r"
expect ":KILL"
respond "*" ":link device;chaos limeri,sysbin;limser bin\r"

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

# SRDATE
respond "*" ":midas sys3;ts srdate_sysen3;srdate\r"
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

# binprt
respond "*" ":midas sys3;ts binprt_sysen1;binprt\r"
expect ":KILL"

# bitprt
respond "*" ":midas sys3;ts bitprt_sysen2;bitprt\r"
expect ":KILL"

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

# 350-point ADVENT
respond "*" ":cwd games\r"
respond "*" ":dec sys:f40\r"
respond "*" "adv3sr=adv3sr\r"
respond "*" "adv3sb=adv3sb\r"
respond "CORE USED" "\032"
type ":kill\r"
respond "*" ":dec sys:loader\r"
respond "*" "adv3sb\r"
respond "*" "adv3sr\r"
respond "*" "/go\r"
respond "EXIT" ":start\r"
respond "*" "adv3db.1"
respond "*" "\032"
type ":start 45\r"
respond "Command:" "d"
respond "*" ":pdump games; ts adv350\r"
respond "*" ":kill\r"

# 448-point ADVENT
respond "*" ":cwd games\r"
respond "*" ":dec sys:f40\r"
respond "*" "adv4ma=adv4ma\r"
respond "*" "adv4su=adv4su\r"
respond "CORE USED" "\032"
type ":kill\r"
respond "*" ":dec sys:loader\r"
respond "*" "adv4ma\r"
respond "*" "adv4su\r"
respond "*" "/go\r"
respond "EXIT" ":start\r"
respond "*" "adv4db.2"
respond "Are you a wizard?" "\032"
type ":start 45\r"
respond "Command:" "d"
respond "*" ":pdump games; ts adv448\r"
respond "*" ":kill\r"

# TREK
respond "*" ":cwd games\r"
respond "*" ":dec sys:f40\r"
respond "*" "trek=trek\r"
respond "CORE USED" "\032"
type ":kill\r"
respond "*" ":dec sys:loader\r"
respond "*" "trek\r"
respond "*" "/go\r"
respond "EXIT" ":start 45\r"
respond "Command:" "d"
respond "*" ":pdump games; ts trek\r"
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

# Hunt the Wumpus
respond "*" ":midas sys1;ts wumpus_games; wumpus\r"
expect ":KILL"

# Jotto
respond "*" ":cwd games\r"
respond "*" ":midas jotto\r"
expect ":KILL"
respond "*" ":job jotto\r"
respond "*" ":load jotto bin\r"
# Run initialisation code to open the TTY channels.
respond "*" "erase0\033bbeg\033g"
# Patch in the filename DSK;JOTTO DICT.
type "utopen/\0331'   dsk\033\r"
type "b/\0331'jotto\033\r"
type "c/\0331'dict\033\r"
# Run the dictionary loader, skipping its filename setup code.
type "beg7\033g"
# Dump out TS JOTTO including the dictionary.
respond ". words" ":pdump sys1;ts jotto\r"
respond "*" ":kill\r"

# ngame
respond "*" ":midas games;ts game_ejs;ngame\r"
respond "Star Trek: " "ts,trek,games\r"
respond "Adventure (2): " "ts,adv448,games\r"
respond "Adventure (1.5): " "ts,adv350,games\r"
expect ":KILL"
respond "*" ":link sys3;ts game,games;ts game\r"
respond "*" ":link info;o.info,_info_;\r"

# guess
respond "*" ":midas games;ts guess_games;guess\r"
expect ":KILL"

# ten50
respond "*" ":midas sys3;ts ten50_mrc; ten50\r"
expect ":KILL"

# who%
respond "*" ":midas sys1;ts who%_sysen3;who%\r"
expect ":KILL"
respond "*" ":link sys1;ts %,sys1;ts who%\r"

# palx
respond "*" ":midas sys;ts palx_sysen1;palx\r"
expect ":KILL"

# Phil Budne's PALX Game of Life.
respond "*" ":cwd budd\r"
respond "*" ":palx live palx\r"

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

# VTTIME
respond "*" ":midas sys1;ts vttime_rvb;vttime\r"
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

# FACTOR
respond "*" ":midas sys1;ts factor_rz;factor\r"
expect ":KILL"

# balanc
respond "*" ":midas sys3;ts balanc_alan;balanc\r"
expect ":KILL"
respond "*" ":link sys3;ts movdir,sys3;ts balanc\r"

# scrmbl and unscr
respond "*" ":midas sys3;ts scrmbl_ejs;scrmbl\r"
expect ":KILL"
respond "*" ":link sys3;ts unscr,sys3;ts scrmbl\r"

# KL10 microcode assembler
respond "*" ":midas sysbin;_syseng;micro\r"
expect ":KILL"
respond "*" ":job micro\r"
respond "*" ":load sysbin; micro bin\r"
respond "*" ":start purify\r"
respond "TS MICRO" "sys; ts micro\r"
respond "*" ":kill\r"

# Microcode ASCIIzer and binarator converter.
respond "*" ":midas sysbin;_syseng;cnvrt\r"
expect ":KILL"
respond "*" ":link sys1;ts mcnvrt,sysbin;cnvrt bin\r"
respond "*" ":link sys1;ts pcnvrt,sysbin;cnvrt bin\r"
respond "*" ":link sys1;ts ucnvrt,sysbin;cnvrt bin\r"
respond "*" ":link sys1;ts acnvrt,sysbin;cnvrt bin\r"

# KS10 microcode assembler
respond "*" ":midas kshack;ts micro_micro\r"
expect ":KILL"

# KL10 microcode.
respond "*" ":micro ucode;u1=ucode;its,define,macro,basic,skpjmp,shift,arith,fp,byte,io,eis,blt\r"
expect ":KILL"
respond "*" ":ucnvrt ucode; u1\r"
expect ":KILL"
# Write the RAM file to the front end filesystem:
# :klfedr write ucode;u1 ram

# KS10 microcode.
# It doesn't seem to work very well when purified.
respond "*" ":kshack;micro kshack;mcr 262=kshack;its,ks10,simple,flt,extend,inout,itspag,pagef\r"
expect ":KILL"
respond "*" ":copy kshack; mcr ram, .; ram ram\r"

# XXFILE
respond "*" ":midas sysbin;xxfile bin_sysen1;xxfile\r"
expect ":KILL"
respond "*" ":job xxfile\r"
respond "*" ":load sysbin;xxfile bin\r"
respond "*" "ttyop1\033b\033g"
expect ":PDUMP SYS2;TS XXFILE"
expect ">>"
respond "   " ":kill\r"

# TJ6
respond "*" ":midas sysbin;_tj6;tj6\r"
expect ":KILL"
respond "*" ":job tj6\r"
respond "*" ":load sysbin; tj6 bin\r"
respond "*" "purify\033g"
respond "DSK: SYS; TS NTJ6" "\r"
respond "*" ":kill\r"
respond "*" ":link sys; ts tj6, sys; ts ntj6\r"

# Versatec spooler
# This has some harmless unresolved symbols (FOO, XE4).
respond "*" ":midas sys3;ts versa_dcp; versa\r"
expect ":KILL"
# respond "*" ":link channa; rakash v80spl,sys3; ts versa\r"

# DDT subroutines
respond "*" ":midas sys3;ts cmd_dcp; cmd\r"
expect ":KILL"

# XGP spooler
respond "*" ":midas sys2;ts xgpspl_sysen2;xgpspl\r"
expect ":KILL"

# XGP and GLP
respond "*" ":midas sysbin;xgp bin_sysen2;xqueue\r"
expect ":KILL"
respond "*" ":job xgp\r"
respond "*" ":load sysbin;xgp bin\r"
respond "*" "debug/0\r"
type ":pdump sys;ts xgp\r"
respond "*" ":kill\r"
respond "*" ":midas /t sysbin;glp bin_sysen2;xqueue\r"
respond "with ^C" "GLP==1\r\003"
expect ":KILL"
respond "*" ":job glp\r"
respond "*" ":load sysbin;glp bin\r"
respond "*" "debug/0\r"
type ":pdump sys2;ts glp\r"
respond "*" ":kill\r"

# XGPDEV and GLPDEV
respond "*" ":midas device;jobdev xgp_sysen2;xgpdev\r"
expect ":KILL"
respond "*" ":midas /t device;jobdev glp_sysen2;xgpdev\r"
respond "with ^C" "GLP==1\r\003"
expect ":KILL"

# KL10 front end directory tool
respond "*" ":midas sys1;ts klfedr_syseng;klfedr\r"
expect ":KILL"

# KL10 front end dumper
respond "*" ":midas dsk0:.;@ fedump_kldcp; fedump\r"
expect ":KILL"

# PDP-11 linker.
respond "*" ":midas sys1;ts 11stnk_kldcp;11stnk\r"
expect ":KILL"

# KL10 front end debugger.
respond "*" ":palx dsk0:.;_syseng; klrug\r"
expect ":KILL"

# PDP-11 debugger.
respond "*" ":palx dsk0:.;11ddt 16k_kldcp; 11ddt\r"
respond "PDP11=" "45\r"
respond "FPPSW=" "1\r"
respond "MAPSW=" "1\r"
respond "HCOR=" "40000\r"
respond "TT10SW=" "0\r"
respond "VT05SW=" "0\r"
respond "DEBSW=" "0\r"
expect ":KILL"

respond "*" ":palx dsk0:.;11ddt 14k_kldcp; 11ddt\r"
respond "PDP11=" "45\r"
respond "FPPSW=" "1\r"
respond "MAPSW=" "1\r"
respond "HCOR=" "34000\r"
respond "TT10SW=" "0\r"
respond "VT05SW=" "0\r"
respond "DEBSW=" "0\r"
expect ":KILL"

# KL10 diagnostics console program.
respond "*" ":palx kldcp; kldcp\r"
expect ":KILL"
