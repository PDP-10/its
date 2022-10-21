log_progress "ENTERING BUILD SCRIPT: MISC"

# MIDAS 324, needed for older programs.
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

# MIDAS 77, needed for MUSRUN.
respond "*" ":job midas\r"
respond "*" ":load sysbin; midas 77bin\r"
# Patch to accomodate more symbols returned from .GETSYS.
respond "*" "tsymgt+5/"
respond "P" "10\r"
respond "\n" "purify\033g"
expect "PURIFIED"
respond "*" ":pdump midas; ts 77\r"
respond "*" ":kill\r"

# MIDAS 73, bootstrapped from 77.
respond "*" ":midas;77\r"
respond "MIDAS.77" "MIDAS; TS 73_MIDAS; MIDAS 73\r"
respond "*" ":midas;73\r"
respond "MIDAS.73" "MIDAS; TS 73_MIDAS; MIDAS 73\r"
respond "*" ":xfile midas; patch 73\r"
expect ":kill"

# MACTAP
respond "*" ":midas;324 sysbin;_sysen2; mactap\r"
expect ":KILL"

# TECO6
respond "*" ":midas sysbin;teco 335bin_.teco.; teco 335\r"
expect ":KILL"
respond "*" ":job teco\r"
respond "*" ":load sysbin; teco 335bin\r"
respond "*" "purify\033g"
respond "PURIFIED" "\r"
respond "*" ":pdump .teco.; ts 335\r"
respond "*" ":kill\r"

respond "*" ":link teach;teach emacs,emacs;teach emacs\r"
type ":vk\r"
respond "*" "teach\033\023"
respond "*" ":emacs\r"
expect ":KILL"
respond "*" ":link sys2;ts teachemacs,emacs;tstch >\r"
type ":vk\r"

# nsalv, timesharing version
respond "*" ":midas sys1;ts nsalv_kshack;nsalv\r"
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

respond "*" ":midas sys3;ts trees_sysen1; trees\r"
expect ":KILL"

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

#Inter-Entity Communication
respond "*" ":midas sysbin;_sysen2; iec\r"
expect ":KILL"
respond "*" ":link sys; atsign iec, sysbin; iec bin\r"

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

# Not Zork
respond "*" ":midas sys3;ts zork_sysen3;zork\r"
expect ":KILL"

respond "*" ":midas sys1;ts instal_sysen2;instal\r"
expect ":KILL"

respond "*" ":midas sys1;ts dir_bawden;dir^k\r"
expect ":KILL"

respond "*" ":midas bawden;_uptime\r"
expect ":KILL"

# Chaosnet EVACUATE service.
respond "*" ":midas sysbin; evacua_bawden; evacua\r"
expect ":KILL"
respond "*" ":job evacua\r"
respond "*" ":load sysbin; evacua bin\r"
respond "*" "purify\033g"
respond "CHAOS EVACUA" "\r"
respond "*" ":kill\r"

# Mini Chaosnet file server.  Version 24 is MINI.
respond "*" ":midas sysbin; mini_lmio; minisr 24\r"
expect ":KILL"
respond "*" ":link device; chaos mini, sysbin; mini bin\r"

# Mini Chaosnet file server.  This is the 36-bit version.
respond "*" ":midas kshack;_mini36\r"
expect ":KILL"
respond "*" ":link device; chaos mini36, kshack; mini36 bin\r"

respond "*" ":midas sysbin;_sysnet;echo\r"
expect ":KILL"
respond "*" ":link device; chaos echo, sysbin; echo bin\r"

respond "*" ":midas alan;ts gensym_alan;gensym\r"
expect ":KILL"
respond "*" ":link device; chaos gensym, alan; ts gensym\r"

# Mini Chaosnet file server.  Version 5 is MINIC.
respond "*" ":midas sysbin; minic bin_syseng; minisr 5\r"
expect ":KILL"
respond "*" ":link device; chaos minic, sysbin; minic bin\r"

respond "*" ":midas sysbin;_lmio1; door\r"
expect ":KILL"
respond "*" ":link device; chaos door, sysbin; door bin\r"

respond "*" ":midas sys3; ts esce_sysen1; esce\r"
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
comsat_switches
expect ":KILL"

respond "*" ":midas device;jobdev dq_sysnet;dqxdev\r"
dqxdev_switches
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
respond "*" ":link dragon; hourly gcbulk,sysbin; gcmail bin\r"

respond "*" ":midas sysbin;qmail_ksc;qmail\r"
respond "PWORD version (Y or N)? " "N\r"
expect ":KILL"
respond "*" ":job qmail\r"
respond "*" ":load sysbin;\r"
respond "*" "purify\033g"
respond "QMAIL BIN" "\r"
respond "*" ":kill\r"

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

# DIGEST
respond "*" ":midas digest; ts digest_digest\r"
expect ":KILL"
respond "*" ":link dragon; hourly digest, digest; ts digest\r"

# MBXLOC
respond "*" ":midas digest; ts mbxloc_mbxloc\r"
expect ":KILL"

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
respond "*" ":link dragon;daily bday,sysbin;bday bin\r"

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

# failsa
respond "*" ":midas moon;_failsa\r"
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
respond "*" ":xfile sysnet;make webser\r"
expect -timeout 300 "*:kill"

# mailt
respond "*" ":link sys;ts mailt,sys2;ts emacs\r"

# rmtdev
respond "*" ":midas device;atsign rmtdev_gz;rmtdev\r"
expect ":KILL"

# mmodem
respond "*" ":midas sys3; ts mmodem_gz; mmodem\r"
expect ":KILL"

# Compile ADVENT and dump it out with DECUUO.
respond "*" ":cwd games\r"
respond "*" ":dec sys:f40\r"
respond "*" "advent=advent\r"
respond "CORE USED" "\032"
type ":kill\r"
respond "*" ":dec sys:loader\r"
respond "*" "advent/g\r"
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
respond "*" "/g\r"
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
respond "*" "/g\r"
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
respond "*" "/g\r"
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

# MacHack VI chess: timesharing, using TV display, no CHEOPS processor.
respond "*" ":midas /t games;ts ocm_chprog;ocm\r"
respond "with ^C" "CHEOPS==0\r\003"
expect ":KILL"

# MacHack VI: timesharing, using 340 display.
respond "*" ":midas games;ts c_rg;c\r"
expect ":KILL"

# CKR
respond "*" ":midas games;ts ckr_agb;ckr\r"
expect ":KILL"

# Dazzle Dart, video game for the Logo group PDP-11/45
respond "*" ":palx bs;_dazzle\r"
expect ":KILL"

# TOSBLK, convert from PALX binary to SBLK.
respond "*" ":midas pdp11;ts tosblk_tosblk\r"
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
expect "CORE USED"
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
expect "CORE USED"
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

# MACSYM and MONSYM universal files.
respond "*" ":cwd decsys\r"
respond "*" ":macro\r"
respond "*" "macsym.unv=macsym.mac\r"
expect "CORE USED"
respond "*" "\003"
respond "*" ":kill\r"
respond "*" ":macro\r"
respond "*" "monsym.unv=monsym.mac\r"
expect "CORE USED"
respond "*" "\003"
respond "*" ":kill\r"

# CROSS, assembler
respond "*" ":macro\r"
respond "*" "cross=cross\r"
expect "CORE USED"
respond "*" "\003"
respond "*" ":kill\r"
respond "*" ":dec sys:loader\r"
respond "*" "cross/g\r"
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
respond "*" ":midas device;chaos itsdev_bawden;itsdev\r"
expect ":KILL"
respond "*" ":link device; tcp syn723, device; chaos itsdev\r"

# charfc/charfs
respond "*" ":midas sys1;ts charfc_sysen3;charfc\r"
expect ":KILL"
respond "*" ":link sys1;ts charfs,sys1;ts charfc\r"

# file
respond "*" ":midas sysbin;_syseng;file\r"
expect ":KILL"
respond "*" ":job file\r"
respond "*" ":load sysbin;\r"
respond "*" "purify\033g"
respond "CHAOS FILE" "\r"
respond "*" ":kill\r"

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

# gunner
respond "*" ":midas device; jobdev shoe_rwk; gunner\r"
expect ":KILL"

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
respond "*" ":link sys1;ts prim,sys1;ts pr\r"

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
respond "*" ":midas sysbin;_sysen1;@\r"
expect ":KILL"
respond "*" ":job @\r"
respond "*" ":load sysbin;\r"
respond "*" "purify\033g"
respond "TS @" "\r"
respond "*" ":kill\r"

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
respond "*" ":midas sys1;ts prufd_sysen2;prufd\r"
expect ":KILL"

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

# HOSTAT
respond "*" ":midas sys2;ts hostat_sysen2;hostat\r"
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

# IPLJOB
respond "*" ":midas sys;atsign ipl_sysen2; ipljob\r"
expect ":KILL"

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

# CHATAB
respond "*" ":midas sys3;ts chatab_sysen1;chatab\r"
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

# MUSCOM
respond "*" ":midas sysbin;_syseng; muscom\r"
expect ":KILL"
respond "*" ":link sys1;ts muscom, sysbin; muscom bin\r"

# BIG
respond "*" ":midas;77\r"
respond "MIDAS.77" "SYSBIN;_SYSENG; BIG\r"
expect ":KILL"
respond "*" ":midas;77\r"
respond "MIDAS.77" "SYSBIN;_PRS; SUDSUD\r"
expect ":KILL"
respond "*" ":midas;77\r"
respond "MIDAS.77" "SYSBIN;_PRS; PLOT\r"
expect ":KILL"
respond "*" ":midas;77\r"
respond "MIDAS.77" "SYSBIN;_PRS; FIGS\r"
expect ":KILL"
respond "*" ":midas;77\r"
respond "MIDAS.77" "SYSBIN;_PRS; SMOLDM\r"
expect ":KILL"
respond "*" ":stink\r"
respond "\n" "msysbin;sudsud\033l\033\033"
respond "\n" "mbig\033l\033\033"
respond "\n" "mfigs\033l\033\033"
respond "\n" "mplot\033l\033\033"
respond "\n" "msmoldm\033l\033\033"
respond "\n" "jbig\033?d\033\033"
respond "\n" "\033y"
respond " " "sys1; ts big\r"
respond "*" ":kill\r"

respond "*" ":muscom\r"
respond "MUSCOM" "PDP10;MUSIC GRYMG_DECUS;GRYMG MUS\r"
expect "$^X."
respond "*" ":muscom\r"
respond "MUSCOM" "PDP10;MUSIC HDN_DECUS;HDN MUS\r"
expect "$^X."
respond "*" ":muscom\r"
respond "MUSCOM" "PDP10;MUSIC JSBI13_DECUS;JSBI13 MUS\r"
expect "$^X."
respond "*" ":muscom\r"
respond "MUSCOM" "PDP10;MUSIC JSBI1_DECUS;JSBI1 MUS\r"
expect "$^X."
respond "*" ":muscom\r"
respond "MUSCOM" "PDP10;MUSIC MIDNIT_DECUS;MIDNIT MUS\r"
expect "$^X."
respond "*" ":muscom\r"
respond "MUSCOM" "PDP10;MUSIC OLITTL_DECUS;OLITTL MUS\r"
expect "$^X."
respond "*" ":muscom\r"
respond "MUSCOM" "PDP10;MUSIC PAPER_DECUS;PAPER MUS\r"
expect "$^X."
respond "*" ":muscom\r"
respond "MUSCOM" "PDP10;MUSIC SILVER_DECUS;SILVER MUS\r"
expect "$^X."
respond "*" ":muscom\r"
respond "MUSCOM" "PDP10;MUSIC WINCH_DECUS;WINCH MUS\r"
expect "$^X."

# WHOLIN
respond "*" ":midas sys2;ts wholin_sysen2;wholin\r"
expect ":KILL"

# LINE
respond "*" ":midas sys2;ts line_rab;line\r"
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

# Chaosnet BABEL service.
respond "*" ":midas sysbin; babel_dcp2; babel\r"
expect ":KILL"
respond "*" ":link device;chaos babel,sysbin; babel bin\r"

# Chaosnet HOSTAB service.
respond "*" ":midas sysbin;_eak; chahtb\r"
expect ":KILL"
respond "*" ":link device; chaos hostab, sysbin; chahtb bin\r"

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

# ZOTZ
respond "*" ":midas ksc; ts zotz_zotz\r"
expect ":KILL"

respond "*" ":job maint\r"
# KA10 needs the .OLD files.  KL10 and KS10 the newer.
translate_diagnostics
respond "*" ":load maint; part a\r"
respond "*" ":start\r"
respond "PARt a" "\032"
expect -re {>>|\)}
type ":kill\r"

# Test one-proceed.
respond "*" ":midas maint;ts 1proc_1proc test\r"
expect ":KILL"
respond "*" ":maint;1proc\r"
expect "SUCCESSFUL"
expect ":KILL"

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

# UNTRAN
respond "*" ":midas imlac; ts untran_untran\r"
expect ":KILL"

# IMPRNT
respond "*" ":midas sys1; ts imprnt_syseng; imprnt\r"
expect ":KILL"
respond "*" ":link sys1; ts imprin, sys1; ts imprnt\r"
respond "*" ":link sys1; ts ardprn, sys1; ts imprnt\r"
respond "*" ":link sys1; ts tekprn, sys1; ts imprnt\r"

# IMGOUT
respond "*" ":midas sys3; ts imgout_cbf; imgout\r"
expect ":KILL"

# LINES
respond "*" ":midas bkph; ts lines_lines\r"
expect ":KILL"

# Random TV experiments.
respond "*" ":midas bkph; ts bull_bull\r"
expect ":KILL"
respond "*" ":midas bkph; ts grade_grade\r"
expect ":KILL"
respond "*" ":midas bkph; ts circle_loops circle\r"
expect ":KILL"
respond "*" ":midas bkph; ts randy_randy\r"
expect ":KILL"

# BLKLDR, Imlac secondary block loader.
respond "*" ":midas sysbin;_imsrc; blkldr\r"
expect ":KILL"
# IMTRAN will put the file IMLAC; IMLAC BLKLDR first in its output.
# The BLKLDR file should say !blk ldr! on the first line.
respond "*" ":create imlac; imlac blkldr\r"
respond "help." "!blk ldr!\r\003"
respond "*" "imtran\033\013"
# The IMTRAN output is in block loader format, but the block loader
# itself is in the special TTY bootstrap format.  Patch IMTRAN to not
# write flat data without blocks.
respond "@" "\032"
type "smalup+5/"
respond "EMIT2" "jfcl\r"
type "smalup+11/"
respond "EMIT4" "jfcl\r"
type "datlup+4/"
respond "EMIT4" "jfcl\r"
type "prgend/"
type "jrst prgen1+4\r"
type "\033p"
type "imlac; imlac blkldr_sysbin; blkldr bin\r"
respond "@" "\021"
expect ":KILL"

# SSV 22, Imlac scroll saver
respond "*" ":midas;324 sysbin;_imsrc; ssv22\r"
expect ":KILL"
respond "*" ":imtran\r"
respond "@" "imlac; ssv22 iml_sysbin; ssv22 bin\r"
respond "@" "\021"
expect ":KILL"
respond "*" ":link imlac; .prgm. normal, imlac; ssv22 iml\r"
type ":vk\r"

# Assemble SSV4.
respond "*" ":midas imlac; ts assv4_assv4\r"
expect ":KILL"

# SSV4, SSV for PDS-4.
respond "*" ":imlac;assv4\r"
respond "NUMBER" ">"
expect ":KILL"
respond "*" ":imtran\r"
respond "@" "imlac; ssv4 iml_imlac; ssv4b >\r"
respond "@" "\021"

# Maze War
respond "*" ":midas /t sysbin;_imsrc; maze\r"
respond "with ^C" "MOUSE==1\r\003"
respond "with ^C" "MOUSE==1\r\003"
expect ":KILL"
respond "*" ":imtran\r"
respond "@" "imlac; m iml_sysbin; maze bin\r"
respond "@" "\021"

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

# SWAR
respond "*" ":midas imlac;_imsrc; swar\r"
respond "INFINITE FUEL AND BULLETS VERSION?" "N\r"
expect ":KILL"
respond "*" ":imtran\r"
respond "@" "imlac; swar iml_imlac; swar bin\r"
respond "@" "\021"

# PONG
respond "*" ":midas imlac;_imsrc; pong\r"
expect ":KILL"
respond "*" ":imtran\r"
respond "@" "imlac; pong iml_imlac; pong bin\r"
respond "@" "\021"

# CRASH, PDS-4 version
respond "*" ":midas imlac;_imsrc; crash\r"
expect ":KILL"
respond "*" ":imtran\r"
respond "@" "imlac; crash4 iml_imlac; crash bin\r"
respond "@" "\021"
# PDS-1 version
respond "*" ":midas /t imlac;_imsrc; crash\r"
respond "with ^C" "PDS4==0\r\003"
respond "with ^C" "PDS4==0\r\003"
expect ":KILL"
respond "*" ":imtran\r"
respond "@" "imlac; crash iml_imlac; crash bin\r"
respond "@" "\021"

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
# C10SFD is obsolete, but used by R.
respond "*" ":cc c10sfd.c\r"
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

# Update compiler files with information from machine description.
respond "*" ":gt pdp10.gt\r"
respond "*" ":teco\r"
# Load macro file and store it in q-register x.
respond "&" "ERinstll teco\033 @Y HXx\033\033"
# Load output file, and call the macro in x.
respond "&" "ERpdp10 gtout\033 @Y Mx\033\033"
respond "&" "\003"
respond "*" ":kill\r"

# Run Yacc to generate parser.
respond "*" ":c;yacc c/c.grammr\r"
expect ":KILL"
respond "*" ":teco\r"
respond "&" "ERyinstl teco\033 @Y HXx Mx\033\033"
respond "&" "\003"
respond "*" ":kill\r"

# C compiler, parser.
respond "*" ":c;occ c1.c c21.c c22.c c23.c c24.c c25.c c26.c\r"
expect ":KILL"
respond "*" ":c;occ c91.c c95.c\r"
expect ":KILL"
respond "*" ":stinkr lp\r"
expect ":KILL"
respond "*" ":delete c; ts occ\r"

# C compiler, code generator.
respond "*" ":cc c31.c c32.c c33.c c34.c c35.c\r"
expect ":KILL"
respond "*" ":cc c95.c\r"
expect ":KILL"
respond "*" ":stinkr c\r"
expect ":KILL"

# C compiler, macro expander.
respond "*" ":cc c41.c c42.c c43.c\r"
expect ":KILL"
respond "*" ":stinkr m\r"
expect ":KILL"

# Test C compiler.
respond "*" ":cc testc.c\r"
expect ":KILL"
respond "*" ":stinkr testc\r"
expect ":KILL"
respond "*" ":testc\r"
expect "Done."

# Revert patch to [CLIB] 16 to avoid use of the FIX instruction on a KA10.
patch_clib_16

# C library for drawing on a TV display.
respond "*" ":cwd clib\r"
respond "*" ":cc tv.>\r"
expect ":KILL"

# TJ6
respond "*" ":midas sysbin;_tj6;tj6\r"
expect ":KILL"
respond "*" ":job tj6\r"
respond "*" ":load sysbin; tj6 bin\r"
respond "*" "purify\033g"
respond "DSK: SYS; TS NTJ6" "\r"
respond "*" ":kill\r"
respond "*" ":link sys; ts tj6, sys; ts ntj6\r"

# Old TJ6.
respond "*" ":midas sys2; ts otj6_tj6; otj6\r"
expect ":KILL"

# Alan Snyder's R typesetting language.
respond "*" ":cwd r\r"
respond "*" ":cc rcntrl rdev rexpr rfile rfonts richar ridn rin rin1 rin2\r"
respond "*" ":cc rits rline rlpt rmain rmisc rout rreadr rreg rreq1 rreq2\r"
respond "*" ":cc rreq3 rtext rtoken rtrap rvaria rxgp\r"
respond "*" ":stinkr r\r"
respond "*" ":link sys3; ts r, r; ts r30\r"
# sys2; ts rr -> r; ts rr
# .info.; r info -> r; r info
# .info.; r recent -> r; r recent
# r; r macros -> r; r30 rmac
# r; rmacro 1 -> r; r macros
# sys3; ts itype -> r; ts itype

# Binary patch Lisp image to work on ITS not named AI, ML, MC, or DM.
# This is for Bolio.
respond "*" ":job purqio\r"
respond "*" ":load sys; purqio 2138\r"
respond "*" "udirset+20/"
# Cross fingers, nop out valret, hope for best!
respond ".VALUE" "JFCL\r"
respond "UNPURE" ":corblk pure .\r"
respond "*" ":pdump sys; purqio 2138\r"
respond "*" ":kill\r"

proc build_c_program {input output {libs {}}} {
    respond "*" ":cc $input\r"
    expect ":KILL"
    respond "*" ":stinkr\r"
    respond "=" "x c/clib\r"
    foreach lib $libs {
        respond "=" "l $lib\r"
    }
    respond "=" "l $input.stk\r"
    respond "=" "o $output\r"
    # Use the ^_ octal-input feature of ITS to send \0.  The space
    # ends the octal digits without ITS passing it through to the
    # program.  Using octal input works around Mac OS X and BSD which
    # require literal \0s to be doubled.
    respond "=" "\0370 "
    expect ":KILL"
}

# OINIT
respond "*" ":cwd c\r"
build_c_program "sysen2/oinit" "sys3/ts.oinit"

# RALP
build_c_program "cprog/ralp" "sys2/ts.ralp"

build_c_program "cprog/shell" "sys2/ts.shell" {clib/c10job.stk}

build_c_program "cprog/search" "sys2/ts.search"

build_c_program "cprog/ipak" "sys2/ts.ipak"

build_c_program "cprog/rstat" "cprog/ts.rstat"

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

# MINITS
respond "*" ":cwd mits.s\r"
respond "*" ":palx test_config\r"
respond ":::" "777\r"
expect ":KILL"

# ITS universal file.
respond "*" ":cwd decsys\r"
respond "*" ":macro\r"
respond "*" "sits.unv=sits.mac\r"
expect "CORE USED"
respond "*" "\003"
respond "*" ":kill\r"

# Datacomputer file transfer.
respond "*" ":cwd mrc\r"
respond "*" ":macro\r"
respond "*" "dftp=dftp\r"
expect "CORE USED"
respond "*" "\003"
respond "*" ":kill\r"
respond "*" ":dec sys:link\r"
respond "*" "dftp/go\r"
expect "EXIT"
respond "*" ":start 45\r"
respond "Command" "d"
respond "*" ":pdump sys1; ts dftp\r"
respond "*" ":kill\r"

# PDP-11 Lisp.
respond "*" ":palx rms;_lisp11\r"
respond "System (RANDOM, SIMULATOR, LOGO, MATH, or STANFORD)?" "SIMULATOR\r"
expect ":KILL"

# Logo RUG.  STUFF prefers it to be RUG; AR BIN.
respond "*" ":palx rug;_ar\r"
# We'll just do the Logo PDP-11/45.
respond "COMPUTER=" "1\r"
expect ":KILL"

# PUNCH, punch out paper tapes in the Logo RUG format.
respond "*" ":midas rug; ts punch_punch\r"
expect ":KILL"

# SITS.
respond "*" ":cwd sits\r"
respond "*" ":palx sits\r"
expect ":KILL"

# Salvager for the SITS file system.
respond "*" ":palx salv\r"
expect ":KILL"

# System Sphere for SITS.
respond "*" ":palx sysspr\r"
expect ":KILL"

# DDT for SITS.
respond "*" ":palx ddt\r"
expect ":KILL"

# TORTIS
respond "*" ":midas;324 radia;_tortis\r"
expect ":KILL"

# BBN Logo
respond "*" ":cwd bbn\r"
respond "*" ":macro\r"
respond "*" "logo=logo\r"
respond "CORE USED" "\032"
type ":kill\r"
respond "*" ":dec sys:loader\r"
respond "*" "logo/g\r"
respond "EXIT" ":start 45\r"
respond "Command:" "d"
respond "*" ":pdump bbn; ts logo\r"
respond "*" ":kill\r"

# CLOGO
respond "*" ":midas sys; ts clogo_rjl; logo\r"
respond "STANDARD=" "0\r"
respond "TBOX=" "0\r"
respond "TURTLE=" "1\r"
respond "PHYSICS=" "0\r"
respond "LFLAG=" "0\r"
respond "OLDMUSIC=" "0\r"
respond "DFLAG=" "1\r"
expect ":KILL"

# NVMIDS, Nova assembler
respond "*" ":cwd nova\r"
respond "*" ":midas;73\r"
expect "MIDAS"
respond "\n" "TS NVMIDS_NVMIDS >\r"
expect ":KILL"

# Nova programs.
respond "*" ":nvmids\r"
expect "NVMDS"
respond "\n" ".LODEE\r"
expect ":KILL"
respond "*" ":nvmids\r"
expect "NVMDS"
respond "\n" "DEBUG\r"
expect ":KILL"
respond "*" ":nvmids\r"
expect "NVMDS"
respond "\n" "DISPLA\r"
expect ":KILL"
respond "*" ":nvmids\r"
expect "NVMDS"
respond "\n" "NDTEST\r"
expect ":KILL"
respond "*" ":nvmids\r"
expect "NVMDS"
respond "\n" "NOVTEN\r"
expect ":KILL"
respond "*" ":nvmids\r"
expect "NVMDS"
respond "\n" "PNOVCN\r"
expect ":KILL"
respond "*" ":nvmids\r"
expect "NVMDS"
respond "\n" "TIME MACHIN\r"
expect ":KILL"

# 11LOGO
respond "*" ":cwd 11logo\r"
respond "*" ":plx143 /H/M/CL BIN,N CREF_SYSTEM,TYI,READ,EVAL,TURTLE,ZEND\r"
respond "ASSSW=" "0\r"
expect ":KILL"

# Apple II Logo
respond "*" ":cwd aplogo\r"
respond "*" ":cross\r"
respond "*" "logo/ptp,logo=logo\r"
expect "Core used"
respond "*" "\003"
respond "*" ":kill\r"

# Atari 800 terminal emulator Chameleon by Jack Palevich.
respond "*" ":cwd atlogo\r"
respond "*" ":cross\r"
respond "*" "supdup,supdup=supdup/m65\r"
expect "Core used"
respond "*" "\003"
respond "*" ":kill\r"

# TENTH, toy Forth.
respond "*" ":midas /t aap; ts tenth_tenth\r"
respond "end input with ^C" "TS==1\r"
respond "\n" "KS==0\r"
respond "\n" "\003"
expect ":KILL"

# GEORGE
respond "*" ":midas sys3;ts george_syseng;george\r"
expect ":KILL"

# MONIT
# The ERROR lines printed during assembly are locations of unlikely
# runtime errors (e.g. not being able to open TTY:).
respond "*" ":midas sys;ts monit_dmcg;monit\r"
expect ":KILL"

# BANNER
respond "*" ":midas sys3;ts banner_sysen2; banner\r"
expect ":KILL"

# IBMASC
respond "*" ":midas sys3;ts ibmasc_sysen1;ibmasc\r"
expect ":KILL"

# NEWDEC
respond "*" ":midas sys3;ts newdec_sysen1;newdec\r"
expect ":KILL"

# TBMOFF
respond "*" ":midas sys; ts tbmoff_cstacy; tbmoff\r"
expect ":KILL"

# UPTINI
respond "*" ":midas ejs;ts uptini_uptini\r"
expect ":KILL"

# CHATER
respond "*" ":midas sys1;ts chater_gren;coms\r"
expect ":KILL"
