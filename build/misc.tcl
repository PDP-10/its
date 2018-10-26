log_progress "ENTERING BUILD SCRIPT: MISC"

respond "*" ":midas /t sysbin; midas 324bin_midas; midas 324\r"
respond "\n" "itssw==1\r"
respond "\n" "ptr==100\r"
respond "\n" "ldbi=ildb\r"
respond "\n" "dpbi=idpb\003"
expect ":KILL"

respond "*" ":job midas\r"
respond "*" ":load sysbin; midas 324bin\r"
respond "*" "purify\033g"
respond "TS MIDAS" "midas;ts 324\r"
respond "*" ":kill\r"

respond "*" ":link teach;teach emacs,emacs;teach emacs\r"
type ":vk\r"
respond "*" "teach\033\023"
respond "*" ":emacs\r"
expect ":KILL"
respond "*" ":link teach;ts emacs,emacs;tstch >\r"
type ":vk\r"

# nsalv, timesharing version
respond "*" ":midas sys1;ts nsalv_kshack;nsalv\r"
respond "machine?" "TS\r"
expect "*"

# salv, timesharing versions
respond "*" ":midas sys1;ts salv_system;salv\r"
respond "time-sharing?" "y\r"
expect ":KILL"

# system gen
respond "*" ":midas;324 dsk0:.;@ sysgen_syseng; system gen\r"
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

respond "*" ":midas bawden;_uptime\r"
expect ":KILL"

respond "*" ":midas sysbin;_sysnet;echo\r"
expect ":KILL"
respond "*" ":link device; chaos echo, sysbin; echo bin\r"

respond "*" ":midas alan;ts gensym_alan;gensym\r"
expect ":KILL"
respond "*" ":link device; chaos gensym, alan; ts gensym\r"

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

respond "*" ":midas sysbin;_sra; gcmail\r"
expect ":KILL"
respond "*" ":link dragon; hourly gcmail,sysbin; gcmail bin\r"

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

# Chaosnet MAILServer
respond "*" ":midas sysbin;_sysnet;mails\r"
expect ":KILL"
respond "*" ":link device; chaos mail, sysbin; mails bin\r"

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

# DOWNLD
respond "*" ":midas sys3;ts downld_sysen1;downld\r"
expect ":KILL"

# OCTPUS
respond "*" ":midas sys2;ts octpus_gren;octpus\r"
expect ":KILL"

# TTYTST
respond "*" ":midas sys3;ts ttytst_sysen2;ttytst\r"
expect ":KILL"

# GOTO
respond "*" ":midas sys3;ts goto_kmp; goto\r"
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

# jedgar
respond "*" ":midas sys2; ts jedgar_sysen3; jedgar\r"
expect ":KILL"
respond "*" ":midas moon; ts jedgar_moon; jedgar\r"
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
respond "*" ":link sys1; ts smeter, sys1; ts meter\r"
respond "*" ":link sys1; ts meterd, sys1; ts meter\r"

# cross
# This is not the microcomputer cross assembler.
#respond "*" ":midas sys1;ts cross_syseng;cross\r"
#expect ":KILL"

# MACN80
respond "*" ":midas sys3;ts macn80_gz;macn80\r"
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

# WEBSER
respond "*" ":xfile hack;make webser\r"
expect -timeout 300 "*:kill"

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

# Tech II chess: timesharing, using TV display
respond "*" ":midas games;ts chess2_rg;chess2\r"
expect ":KILL"

# Unknown chess
respond "*" ":midas games;ts chess_as;chess\r"
expect ":KILL"

# Old chess?  Timesharing, no TV, no CHEOPS processor.
respond "*" ":midas /t games;ts ocm_chprog;ocm\r"
respond "with ^C" "DSPLY==0\r"
respond "\n" "CHEOPS==0\r\003"
expect ":KILL"

# MachHack VI with 340 display.
respond "*" ":midas games;ts c_rg;c\r"
expect ":KILL"

# CKR
respond "*" ":midas games;ts ckr_agb;ckr\r"
expect ":KILL"

# Spacewar, standalone
respond "*" ":midas;324 dsk0:.;@ spcwar_spcwar; newwar\r"
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
respond "*" ":midas;324 games;ts mlife_rwg;mlife\r"
expect ":KILL"
respond "*" ":midas;324 /t dsk0:.;@ mlife_rwg;mlife\r"
respond "with ^C" "TS==0\r\003"
expect ":KILL"

# TV-munching square.
respond "*" ":midas sys2;ts munch_sysen2;munch\r"
expect ":KILL"

# PI
respond "*" ":midas sys3;ts pi_rwg; ran\r"
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
respond "words" ":pdump sys1;ts jotto\r"
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

# MACRO-10
respond "*" ":cwd decsys\r"
respond "*" ":dec sys:macro\r"
respond "*" "macro=macro\r"
respond "*" "\003"
type ":kill\r"
respond "*" ":dec sys:link\r"
respond "*" "macro/go\r"
# Strange error here.  Workaround is to retry.
expect "%LNKNED"
respond "*" "macro/go\r"
respond "*" ":start 45\r"
respond "Command" "d"
respond "*" ":pdump sys2; ts macro\r"
respond "*" ":kill\r"
respond "*" ":delete decsys; macro shr\r"
# Assemble with itself, now no errors
respond "*" ":macro\r"
respond "*" "macro=macro\r"
respond "*" "\003"
type ":kill\r"
respond "*" ":dec sys:link\r"
respond "*" "macro/go\r"
expect "%LNKNED"
respond "*" "macro/go\r"
respond "*" ":start 45\r"
respond "Command" "d"
respond "*" ":pdump sys2; ts macro\r"
respond "*" ":kill\r"

# CROSS, assembler
respond "*" ":macro\r"
respond "*" "cross=cross\r"
respond "*" "\003"
respond "*" ":kill\r"
respond "*" ":dec sys:loader\r"
respond "*" "cross/go\r"
respond "*" ":start 45\r"
respond "Command:" "d"
respond "*" ":pdump sys1; ts cross\r"
respond "*" ":kill\r"

# Old PALX
respond "*" ":midas sys3;ts plx143_rms;palx 143\r"
expect ":KILL"

# Phil Budne's PALX Game of Life.
respond "*" ":cwd budd\r"
respond "*" ":palx live palx\r"

# Cookie Bear
respond "*" ":midas gls; ts check_gls; check\r"
respond "DEBUGP==" "0\r"
respond "ITEM:" "COOKIE\r"
respond "SUBJECT:" "COOKIE\r"
respond "NAME:" "BEAR\r"
expect ":KILL"

# LOGOUT TIMES cleanup program.
respond "*" ":midas sys3;ts lotcln_sysen1; lotcln\r"
expect ":KILL"

# itsdev
respond "*" ":link syseng;chsdef 999999,system;chsdef >\r"
respond "*" ":midas device;chaos itsdev_bawden;itsdev\r"
expect ":KILL"
respond "*" ":link device; tcp syn723, device; chaos itsdev\r"

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

# yow server
respond "*" ":midas sys3;ts yow_maeda; yow\r"
expect ":KILL"
respond "*" ":link device;chaos yow, sys3; ts yow\r"

# yow client
respond "*" ":midas sysnet;ts yow_sysen2; yow\r"
expect ":KILL"

# @
respond "*" ":midas sys;ts @_sysen1;@\r"
expect ":KILL"

# PLAN/CREATE
respond "*" ":midas sys3;ts create_syseng;create\r"
expect ":KILL"
respond "*" ":link sys1;ts plan,sys3;ts create\r"

respond "*" ":midas;324 dsk0:.;@ pt_syseng;pt\r"
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

# TTYLINK, just a stub.
respond "*" ":midas sysbin;ttylin bin_bawden; u\r"
expect ":KILL"
respond "*" ":link device; chaos ttylin, sysbin; ttylin bin\r"

# RIPDEV
respond "*" ":midas device;atsign r.i.p._sysen2;ripdev\r"
expect ":KILL"

# GMSGS
respond "*" ":midas sys2;ts gmsgs_sysen1;gmsgs\r"
expect ":KILL"
respond "*" ":link sys2;ts expire, sys2;ts gmsgs\r"
respond "*" ":link dragon;daily expire,sys2;ts gmsgs\r"
respond "*" ":link device;chaos gmsgs,sys2;ts gmsgs\r"

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

# CHASTA
respond "*" ":midas sys3;ts chasta_chsgtv;chasta\r"
expect ":KILL"

# STYLOG
respond "*" ":midas sys2;ts stylog_sysen1;stylog\r"
expect ":KILL"

# COMIFY
respond "*" ":midas sys2;ts comify_sysen3;comify\r"
expect ":KILL"

# CRC
respond "*" ":midas sys3;ts crc_gren; crc\r"
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
respond "*" ":link device;chaos uptime,sysbin;uptime bin\r"

# SHUTDN
respond "*" ":midas sys3;ts shutdn_bawden;shutdn\r"
expect ":KILL"

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
respond "*" ":link sys2;ts typesq,sys2;ts usq\r"

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

# WHOIML
respond "*" ":midas sysbin;_sysen1; whoiml\r"
respond "FILE:" "whoiml\r"
respond "FILE:" "sys2\r"
expect ":KILL"
respond "*" ":job whoiml\r"
respond "*" ":load sysbin; whoiml bin\r"
respond "*" "start1\033b\033g"
expect ">>"
respond "   " ":kill\r"

# VTTIME
respond "*" ":midas sys1;ts vttime_rvb;vttime\r"
expect ":KILL"

# APLCLK
respond "*" ":midas sys3;ts aplclk_music1; vtclk\r"
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

# KA10 maintenance
respond "*" ":midas;324 sys;ts 10run_sysen2; 10run\r"
expect ":KILL"

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

update_microcode

# KNS10, KS10 console
respond "*" ":cwd kshack\r"
respond "*" ":cross\r"
respond "*" "FOR21.DAT/PTP,KNS10.PNT/M80/OCT/CRF/EQ:PASS2:SCECOD=CONDEF.M80,HCORE.M80,CMDS.M80,SUBRTN.M80,DR.M80,MSG.M80,STORE.M80\r"
# kns10,kns10/m80/oct/eq:pass2:scecod=condef,hcore,cmds,subrtn,dr,msg,store
respond "*" "\003"
type ":kill\r"

# XXFILE
respond "*" ":midas sysbin;xxfile bin_sysen1;xxfile\r"
expect ":KILL"
respond "*" ":job xxfile\r"
respond "*" ":load sysbin;xxfile bin\r"
respond "*" "ttyop1\033b\033g"
expect ":PDUMP SYS2;TS XXFILE"
expect ">>"
respond "   " ":kill\r"

# MSEND
respond "*" ":midas sysbin;_sysen2;msend\r"
expect ":KILL"
respond "*" ":job msend\r"
respond "*" ":load sysbin;msend bin\r"
respond "*" "ttyopn\033b\033g"
expect ">>"
respond "   " ":kill\r"

# IMLOAD and IMTRAN
respond "*" ":midas sys1; ts imload_syseng; imload\r"
expect ":KILL"
respond "*" ":link sys1; ts imtran, sys1; ts imload\r"

# IMPRNT
respond "*" ":midas sys1; ts imprnt_syseng; imprnt\r"
expect ":KILL"
respond "*" ":link sys1; ts imprin, sys1; ts imprnt\r"
respond "*" ":link sys1; ts ardprn, sys1; ts imprnt\r"
respond "*" ":link sys1; ts tekprn, sys1; ts imprnt\r"

# Dump TV bitmap as XGP scan file.
# TVREAD expects the binary in BKPH.
respond "*" ":midas bkph; ts zap_zap\r"
expect ":KILL"

# View bitmap file on TV.
respond "*" ":midas sys2; ts tvread_sysen2; tvread\r"
expect ":KILL"

# Save TV display as bitmap file.
respond "*" ":midas sys2; ts tvwrit_sysen2; tvwrit\r"
expect ":KILL"

# Save TV display as text file.
respond "*" ":midas sys2; ts record_sysen2; record\r"
expect ":KILL"

# Maze War
respond "*" ":midas /t sysbin;_imsrc; maze\r"
respond "with ^C" "MOUSE==1\r\003"
respond "with ^C" "MOUSE==1\r\003"
expect ":KILL"
respond "*" ":imtran\r"
respond "@" "imlac; m iml_sysbin; maze bin\r"
respond "@" "\032"
type ":kill\r"

respond "*" ":midas sysbin;_klh; mazser\r"
respond "NPTCL=" "1\r"
respond "DEBUG=" "1\r"
respond "STATS=" "1\r"
expect ":KILL"
respond "*" ":job maze\r"
respond "*" ":load sysbin; mazser bin\r"
respond "*" ":start init\r"
respond "M IML" "\r"
respond ":PDUMP" "games; ts maze\r"
respond "*" ":kill\r"

# The old CLIB has a UFA instruction which doesn't work on a KS10.
# Patch out the call to FIXIFY.
respond "*" ":job cc\r"
respond "*" ":load c; ts cc\r"
respond "*" "55107/"
respond "FIXIFY" "jfcl\r"
respond "UNPURE" ":corblk pure,55107\r"
respond "*" ":pdump c; ts cc\r"
respond "*" ":kill\r"

# CLIB
respond "*" ":cwd clib\r"
respond "*" ":midas c10cor cmid\r"
respond "*" ":midas c10fo cmid\r"
respond "*" ":midas c10int cmid\r"
respond "*" ":midas c10mio cmid\r"
respond "*" ":midas c10sys cmid\r"
respond "*" ":midas alloc cmid\r"
respond "*" ":midas blt cmid\r"
respond "*" ":midas /t cfloat cmid\r"
clib_switches
respond "*" ":midas random cmid\r"
respond "*" ":midas string cmid\r"
respond "*" ":midas uuoh cmid\r"
respond "*" ":midas /t c10run cmid\r"
clib_switches
respond "*" ":cc c10exp.c\r"
respond "*" ":cc c10fd.c\r"
respond "*" ":cc c10fil.c\r"
respond "*" ":cc c10fnm.c\r"
respond "*" ":cc c10io.c\r"
respond "*" ":cc c10map.c\r"
respond "*" ":cc c10pag.c\r"
respond "*" ":cc c10tty.c\r"
respond "*" ":cc ac.c\r"
respond "*" ":cc apfnam.c\r"
respond "*" ":cc atoi.c\r"
respond "*" ":cc cprint.c\r"
respond "*" ":cc date.c\r"
respond "*" ":cc fprint.c\r"
respond "*" ":cc match.c\r"
respond "*" ":cc pr60th.c\r"
respond "*" ":cc stkdmp.c\r"
# Expect ZMAIN to be undefined, and three symbols in DATE.
respond "*" ":stinkr mkclib\r"
respond "*" ":cc maklib.c\r"
respond "*" ":cc c10job.c\r"
respond "*" ":stinkr maklib\r"
respond "*" ":maklib\r"
expect ":MIDAS"
expect ":KILL"
respond "*" ":delete c; \[crel\] 16\r"

# CC
respond "*" ":cwd c\r"
respond "*" ":copy ts cc, ts occ\r"
respond "*" ":cc cc.>\r"
expect ":KILL"
respond "*" ":cc c5.c\r"
expect ":KILL"
respond "*" ":cc c93.c\r"
expect ":KILL"
respond "*" ":cc clib/c10exc.c\r"
expect ":KILL"
respond "*" ":stinkr cc\r"
expect ":KILL"

# GT
respond "*" ":c;occ g0.c g1.c g2.c g3.c g4.c g5.c c25.c\r"
expect ":KILL"
respond "*" ":stinkr gt\r"

# TJ6
respond "*" ":midas sysbin;_tj6;tj6\r"
expect ":KILL"
respond "*" ":job tj6\r"
respond "*" ":load sysbin; tj6 bin\r"
respond "*" "purify\033g"
respond "DSK: SYS; TS NTJ6" "\r"
respond "*" ":kill\r"
respond "*" ":link sys; ts tj6, sys; ts ntj6\r"

# OINIT
respond "*" ":cwd c\r"
respond "*" ":c;occ sysen2/oinit\r"
expect ":KILL"
respond "*" ":stinkr\r"
respond "=" "x c/clib\r"
respond "=" "l sysen2/oinit.stk\r"
respond "=" "o sys3/ts.oinit\r"
respond "=" "\0"
expect ":KILL"

# Versatec spooler
# This has some harmless unresolved symbols (FOO, XE4).
respond "*" ":midas sys3;ts versa_dcp; versa\r"
expect ":KILL"
# respond "*" ":link channa; rakash v80spl,sys3; ts versa\r"

# SCAN
respond "*" ":midas sysbin;_sysen1; scan\r"
expect ":KILL"
respond "*" ":job scan\r"
respond "*" ":load sysbin; scan bin\r"
respond "*" "purify\033g"
respond "*" ":pdump sys3; ts scan\r"
respond "*" ":kill\r"

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

# XD, view XGP files on TV.
respond "*" ":midas sys3;ts xd_sysen2;xd\r"
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

# CARPET, remote PDP-11 debugger through Rubin 10-11 interface.
respond "*" ":midas sys3;ts carpet_syseng;carpet\r"
expect ":KILL"

# GTLOAD, load programs into GT40.
respond "*" ":midas sys1; ts gtload_syseng; gtload\r"
expect ":KILL"

# RUG, PDP-11 debugger.
respond "*" ":cwd pdp11\r"
respond "*" ":palx rug\r"
respond "?" "2\r"
respond "?" "100000\r"
respond "?" "1\r"
respond "?" "1\r"
expect ":KILL"

# URUG, GT40 debugger.
respond "*" ":palx sysbin;_sysen2;urug\r"
respond "=YES" "1\r"
respond "37000" "37000\r"
expect ":KILL"

# GT40 Lunar Lander.
respond "*" ":palx gt40;_gt40;gtlem\r"
expect ":KILL"

# KL10 front end debugger.  Put it in the same directory as the
# "MX" IOELEV.
respond "*" ":palx sysbin;_syseng; klrug\r"
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

# KL10 NTSDDT.
respond "*" ":midas dsk0:.;@ ntsddt_system;ddt\r"
respond "cpusw=" "2\r"
respond "ndsk=" "1\r"
respond "dsksw=" "3\r"
respond "1PRSW=" "1\r"
expect ":KILL"

# IOELEV, PDP-11 doing I/O for the PDP-10 host.
# First, the "AI" IOELEV, also known as CHAOS-11.
# STUFF prefers to have it in the "." directory.
respond "*" ":palx dsk0:.;_system;ioelev\r"
respond "MACHINE NAME =" "AI\r"
expect ":KILL"

# The KL10 console "MX" IOELEV.  Put it in SYSBIN as to not conflict
# with the "AI" IOELEV.
respond "*" ":palx sysbin;_system;ioelev\r"
respond "MACHINE NAME =" "MX\r"
expect ":KILL"
respond "*" ":11stnk\r"
# Rumour has it 11DDT 14K should be used, but then 11STNK barfs on
# KLDCP.  KLRUG works better.
respond "*" "R"
respond "FILENAME" "\r"
respond "*" "L"
respond "FILENAME" "kldcp; kldcp bin\r"
respond "*" "L"
respond "FILENAME" "sysbin; ioelev bin\r"
respond "*" "A"
respond "FILENAME" ".temp.; ioelev bin\r"
expect ":KILL"
respond "*" ":pcnvrt .temp.; ioelev bin\r"
expect ":KILL"
# Write the file to the front end filesystem:
# :klfedr write .temp.; ioelev a11

# The KL10 "MX-DL" IOELEV won't assemble due to CHADD being undefined.
# Maybe roll back to IOELEV 431, or fix it in new version 433.  Maybe
# link with 11DDT 16K.

# TV-11.  STUFF prefers it to be in the "." directory.
respond "*" ":palx dsk0:.;_system;tv\r"
expect ":KILL"

# XGP-11.  STUFF prefers it to be SYSBIN; VXGP BIN.
respond "*" ":palx sysbin;vxgp bin_sysen2;xgp\r"
expect ":KILL"

# CCONS.  STUFF prefers it to be in the CONS directory.
respond "*" ":print cons;..new. (udir)\r"
type ":vk\r"
respond "*" ":palx cons;_lmcons;ccons\r"
expect ":KILL"

# Logo RUG.  STUFF prefers it to be RUG; AR BIN.
respond "*" ":palx rug;_ar\r"
# We'll just do the Logo PDP-11/45.
respond "COMPUTER=" "1\r"
expect ":KILL"

# BBN Logo
respond "*" ":cwd bbn\r"
respond "*" ":macro\r"
respond "*" "logo=logo\r"
respond "CORE USED" "\032"
type ":kill\r"
respond "*" ":dec sys:loader\r"
respond "*" "logo/go\r"
respond "EXIT" ":start 45\r"
respond "Command:" "d"
respond "*" ":pdump bbn; ts logo\r"
respond "*" ":kill\r"

# CLOGO
respond "*" ":job clogo\r"
respond "*" ":load hqm; clogo bin\r"
respond "*" "purify\033g"
respond "PURIFIED" "\r"
respond "*" ":pdump sys; ts clogo\r"
respond "*" ":kill\r"

# 11LOGO
respond "*" ":cwd 11logo\r"
respond "*" ":plx143 /H/M/CL BIN,N CREF_SYSTEM,TYI,READ,EVAL,TURTLE,ZEND\r"
respond "ASSSW=" "0\r"
expect ":KILL"

# Apple II Logo
respond "*" ":cwd aplogo\r"
respond "*" ":cross\r"
respond "*" "logo,logo=logo\r"
respond "*" "\003"
respond "*" ":kill\r"

# TENTH, toy Forth for KS10.
respond "*" ":midas .; @ tenth_aap; tenth\r"
expect ":KILL"
respond "*" ":midas /t aap; ts tenth_tenth\r"
respond "end input with ^C" "TS==1\r"
respond "\n" "\003"
expect ":KILL"

# 11BOOT
respond "*" ":midas;324 sys3;ts 11boot_syseng;11boot\r"
expect ":KILL"
# Note, must be run with symbols loaded.
# Takes IOELEV BIN and KLRUG BIN from the current directory.
respond "*" ":cwd sysbin\r"
respond "*" "11boot\033\013"
expect ":KILL"
respond "*" ":move sysbin;@ boot11, .;\r"

# STUFF
respond "*" ":midas sys1;ts stuff_sysen2;stuff\r"
expect ":KILL"

# GEORGE
respond "*" ":midas sys3;ts george_syseng;george\r"
expect ":KILL"

# MONIT
# The ERROR lines printed during assembly are locations of unlikely
# runtime errors (e.g. not being able to open TTY:).
respond "*" ":midas sys;ts monit_dmcg;monit\r"
expect ":KILL"

# IBMASC
respond "*" ":midas sys3;ts ibmasc_sysen1;ibmasc\r"
expect ":KILL"
