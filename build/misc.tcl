log_progress "ENTERING BUILD SCRIPT: MISC"

# MIDAS 324, needed for older programs.
midast "sysbin; midas 324bin" "midas; midas 324" {
    respond "\n" "itssw==1\r"
    respond "\n" "ptr==100\r"
    respond "\n" "ldbi=ildb\r"
    respond "\n" "dpbi=idpb\003"
}
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
oomidas 77 "MIDAS; TS 73" "MIDAS; MIDAS 73"
oomidas 73 "MIDAS; TS 73" "MIDAS; MIDAS 73"
respond "*" ":xfile midas; patch 73\r"
expect ":kill"

# ITS 138
oomidas 73 ".;ITS 138BIN" "SYSENG;ITS 138"

# MACTAP
omidas "sysbin;" "sysen2; mactap"

# TECO6
midas "sysbin;teco 335bin" ".teco.; teco 335"
respond "*" ":job teco\r"
respond "*" ":load sysbin; teco 335bin\r"
respond "*" "purify\033g"
respond "PURIFIED" "\r"
respond "*" ":pdump .teco.; ts 335\r"
respond "*" ":kill\r"

respond "*" ":link teach;teach emacs,emacs;teach emacs\r"
respond "*" "teach\033\023"
respond "*" ":emacs\r"
expect ":KILL"
respond "*" ":link sys2;ts teachemacs,emacs;tstch >\r"

# nsalv, timesharing version
midas "sys1;ts nsalv" "kshack;nsalv" {
    respond "machine?" "TS\r"
}

# salv, timesharing versions
midas "sys1;ts salv" "system;salv" {
    respond "time-sharing?" "y\r"
}

midas "sys3;ts syslod" "sysen1;syslod"

midas "sys3;ts vv" "sysen2;vv"
respond "*" ":link sys3;ts vj,sys3;ts vv\r"
respond "*" ":link sys3;ts detree,sys3;ts vv\r"

midas "sys3;ts trees" "sysen1; trees"

midas "sys2;ts syschk" "sysen2;syschk"

midas "sysbin;" "sysen3;whoj"
respond "*" ":link sys1;ts talk,sysbin;whoj bin\r"
respond "*" ":link sys1;ts who,sysbin;whoj bin\r"
respond "*" ":link sys1;ts whoj,sysbin;whoj bin\r"
respond "*" ":link sys1;ts whom,sysbin;whoj bin\r"
respond "*" ":link sys2;ts users,sysbin;whoj bin\r"
respond "*" ":link sys1;ts w,sys1;ts who\r"
respond "*" ":link sys2;ts u,sys2;ts users\r"

#Inter-Entity Communication
midas "sysbin;" "sysen2; iec"
respond "*" ":link sys; atsign iec, sysbin; iec bin\r"
arpanet "rfc113" "sys; atsign iec"

midas "sys2;ts untalk" "gren;untalk"

midas "sys3;ts ufind" "syseng;ufind"

midas "sys3;ts ddtdoc" "syseng;ddtdoc"

midas "sys1;ts nwatch" "sysen1;nwatch"

midas "sys1;ts crock" "sysen1;crock" { respond "System?" "ITS\r" }
respond "*" ":link sys2;ts c,sys1;ts crock\r"

midas "sys1;ts dcrock" "sysen1;dcrock" { respond "System?" "ITS\r" }
respond "*" ":link sys2;ts dc,sys1;ts dcrock\r"

# Not Zork
midas "sys3;ts zork" "sysen3;zork"

midas "sys1;ts instal" "sysen2;instal"

midas "sys1;ts dir" "bawden;dir^k"

midas "bawden;" "uptime"

# Chaosnet EVACUATE service.
midas "sysbin; evacua" "bawden; evacua"
respond "*" ":job evacua\r"
respond "*" ":load sysbin; evacua bin\r"
respond "*" "purify\033g"
respond "CHAOS EVACUA" "\r"
respond "*" ":kill\r"

# Mini Chaosnet file server.  Version 24 is MINI.
midas "sysbin; mini" "lmio; minisr 24"
respond "*" ":link device; chaos mini, sysbin; mini bin\r"

# Mini Chaosnet file server.  This is the 36-bit version.
midas "kshack;" "mini36"
respond "*" ":link device; chaos mini36, kshack; mini36 bin\r"

midas "sysbin;" "sysnet;echo"
respond "*" ":link device; chaos echo, sysbin; echo bin\r"

midas "alan;ts gensym" "alan;gensym"
respond "*" ":link device; chaos gensym, alan; ts gensym\r"

midas "device;chaos load" "alan;load"

# Mini Chaosnet file server.  Version 5 is MINIC.
midas "sysbin; minic bin" "syseng; minisr 5"
respond "*" ":link device; chaos minic, sysbin; minic bin\r"

midas "sysbin;" "lmio1; door"
respond "*" ":link device; chaos door, sysbin; door bin\r"

midas "sys3; ts esce" "sysen1; esce"

midas "sysbin;chtn" "sysnet;chtn"
respond "*" ":link sys2;ts chtn,sysbin;chtn bin\r"

midas "sys;ts ttloc" "sysen1;ttloc"
respond "*" ":link sys2;ts styloc,sys;ts ttloc\r"

midas "device;jobdev dp" "sysen3;dpdev"

midas "sys1;ts quote" "sysen1;limeri" {
    respond "Use what filename instead?" "ecc;quotes >\r"
}

midas "sys2;ts limeri" "sysen1;limeri" {
    respond "Use what filename instead?" "eak; lims >\r"
}
respond "*" ":link sys2;ts limmer,sys2;ts limeri\r"

midas "sysbin;" "eak;limser"
respond "*" ":link device;chaos limeri,sysbin;limser bin\r"

midas "sys;ts srccom" "sysen2;srccom"
respond "*" ":link sys2;ts =,sys;ts srccom\r"

midas ".mail.;comsat" "sysnet;comsat" comsat_switches

midas "device;jobdev dq" "sysnet;dqxdev" dqxdev_switches

respond "*" "comsat\033j"
respond "*" "\033l.mail.;comsat bin\r"
respond "*" "debug/0\r"
type "xvers/0\r"
type "purify\033g"
respond ":PDUMP DSK:.MAIL.;COMSAT LAUNCH" "\r"
respond "*" ":kill\r"

initialize_comsat

respond "*" ":link emacs;rmail \021:ej,emacs;\[rmai\] >\r"

midas "sys1;ts rmail" "emacs1;rmaill"

respond "*" ":link channa;rakash cnavrl,.mail.;comsat launch\r"
respond "*" ":link channa;ts cnavrl,channa;rakash cnavrl\r"
respond "*" ":link dragon;hourly cnavrl,.mail.;comsat launch\r"

midas "sysbin;" "sra; gcmail"
respond "*" ":link dragon; hourly gcmail,sysbin; gcmail bin\r"
respond "*" ":link dragon; hourly gcbulk,sysbin; gcmail bin\r"

midas "sysbin;qmail" "ksc;qmail" { respond "PWORD version (Y or N)? " "N\r" }
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
midas "sysbin;" "sysnet;mails"
respond "*" ":link device; chaos mail, sysbin; mails bin\r"

# DIGEST
midas "digest; ts digest" "digest"
respond "*" ":link dragon; hourly digest, digest; ts digest\r"

# MBXLOC
midas "digest; ts mbxloc" "mbxloc"

# TIME
midas "sys1;ts time" "sysen2;time"

# DATE
midas "sys1;ts date" "sysen3;date"

# SRDATE
midas "sys3;ts srdate" "sysen3;srdate"

# PWMAIL
midas "sys;ts pwmail" "ksc;qmail" { respond "PWORD version (Y or N)? " "Y\r" }

# FIDO
midas "sys3;ts fido" "ksc;fidox"

# STTY
midas "sys2;ts stty" "archy;stty"

# DOWNLD
midas "sys3;ts downld" "sysen1;downld"

# OCTPUS
midas "sys2;ts octpus" "gren;octpus"

# TTYTST
midas "sys3;ts ttytst" "sysen2;ttytst"

# GOTO
midas "sys3;ts goto" "kmp; goto"

# binprt
midas "sys3;ts binprt" "sysen1;binprt"

# bitprt
midas "sys3;ts bitprt" "sysen2;bitprt"

# bday
midas "sysbin;" "sysen1;bday"
respond "*" ":link dragon;daily bday,sysbin;bday bin\r"

# sender
midas "sysbin;sender" "sysen1;sender"
respond "*" ":link sys;ts freply,sysbin;sender bin\r"
respond "*" ":link sys;ts send,sysbin;sender bin\r"
respond "*" ":link sys2;ts fr,sysbin;sender bin\r"
respond "*" ":link sys2;ts reply,sysbin;sender bin\r"
respond "*" ":link sys3;ts fs,sysbin;sender bin\r"
respond "*" ":link sys1;ts s,sys;ts send\r"
respond "*" ":link sys3;ts snd,sys;ts send\r"
respond "*" ":link sys3;ts sned,sys;ts send\r"

# psend
midas "sys3;ts psend" "sysen2;b"

# whosen
midas "sys2;ts whosen" "syseng;wsent"

# sensor
midas "sys3;ts sensor" "gren;sensor"

# NICNAM
midas "sys2;ts nicnam" "sysen3;nicnam"

# NICWHO
midas "sys2;ts nicwho" "sysen3;nicwho"

# reatta
midas "sys1;ts reatta" "sysen2;reatta"

# print
midas "sys;ts print" "sysen2;print"
respond "*" ":link sys;ts copy,sys;ts print\r"
respond "*" ":link sys;ts listf,sys;ts print\r"

# fdir 
midas "sys2;ts fdir" "syseng;fdir"

# timoon
midas "sys1;ts timoon" "syseng;timoon"

# jedgar
midas "sys2; ts jedgar" "sysen3; jedgar"
midas "moon; ts jedgar" "moon; jedgar"

# failsa
midas "moon;" "failsa"

# ports
midas "sys2;ts ports" "sysen2;ports"

# sysmsg
midas "sys1;ts sysmsg" "sysen1;sysmsg"

# meter
midas "sys1;ts meter" "syseng;meter"
respond "*" ":link sys1; ts smeter, sys1; ts meter\r"
respond "*" ":link sys1; ts meterd, sys1; ts meter\r"

# cross
# This is not the microcomputer cross assembler.
#midas "sys1;ts cross" "syseng;cross"

# MACN80
midas "sys3;ts macn80" "gz;macn80"

# dired
midas "sys;ts dired" "sysen2;dired"

# dircpy
midas "sys3;ts dircpy" "sysen3;dircop"

# hsname
midas "sys2;ts hsname" "sysen1;hsname"

# arcsal
midas "sys1;ts arcsal" "sysen1;arcsal"

# acount
midas "sys;ts acount" "sysen3;acount"

# idents
midas "sysbin;" "sysnet;idents"
respond "*" ":link device;tcp syn161,sysbin;idents bin\r"

# timsrv
midas "sysbin;timsrv bin" "sysnet;timsrv"
respond "*" ":link device;tcp syn045,sysbin;timsrv bin\r"
arpanet "rfc045" "sysbin;timsrv bin"

# datsrv
midas "sysbin;" "sysnet;datsrv"
respond "*" ":link device;tcp syn015,sysbin;datsrv bin\r"

# WEBSER
respond "*" ":xfile sysnet;make webser\r"
expect -timeout 300 "*:kill"

# mailt
respond "*" ":link sys;ts mailt,sys2;ts emacs\r"

# rmtdev
midas "device;atsign rmtdev" "gz;rmtdev"

# mmodem
midas "sys3; ts mmodem" "gz; mmodem"

# Compile ADVENT and dump it out with DECUUO.
cwd "games"
respond "*" ":dec sys:f40\r"
respond "*" "advent=advent\r"
expect "CORE USED"
respond "*" "\032"
type ":kill\r"
loader "advent"
respond "*" ":start\r"
respond "*" "\032"
type ":vk\r"
decuuo "sys3; ts advent"

# 350-point ADVENT
cwd "games"
respond "*" ":dec sys:f40\r"
respond "*" "adv3sr=adv3sr\r"
respond "*" "adv3sb=adv3sb\r"
expect "CORE USED"
respond "*" "\032"
type ":kill\r"
loader "adv3sb,adv3sr"
respond "*" ":start\r"
respond "*" "adv3db.1"
respond "*" "\032"
type ":vk\r"
decuuo "games; ts adv350"

# 448-point ADVENT
cwd "games"
respond "*" ":dec sys:f40\r"
respond "*" "adv4ma=adv4ma\r"
respond "*" "adv4su=adv4su\r"
expect "CORE USED"
respond "*" "\032"
type ":kill\r"
loader "adv4ma,adv4su"
respond "*" ":start\r"
respond "*" "adv4db.2"
respond "Are you a wizard?" "\032"
type ":vk\r"
decuuo "games; ts adv448"

# TREK
cwd "games"
respond "*" ":dec sys:f40\r"
respond "*" "trek=trek\r"
expect "CORE USED"
respond "*" "\032"
type ":kill\r"
loader "trek"
decuuo "games; ts trek"

# Tech II chess: timesharing, using TV display
midas "games;ts chess2" "rg;chess2"

# Unknown chess
midas "games;ts chess" "as;chess"

# MacHack VI chess: timesharing, using TV display, no CHEOPS processor.
midast "games;ts ocm" "chprog;ocm" { respond "with ^C" "CHEOPS==0\r\003" }

# MacHack VI: timesharing, using 340 display.
midas "games;ts c" "rg;c"

# CKR
midas "games;ts ckr" "agb;ckr"

# Dazzle Dart, video game for the Logo group PDP-11/45
palx "bs;" "dazzle"

# TOSBLK, convert from PALX binary to SBLK.
midas "pdp11;ts tosblk" "tosblk"

# PI
midas "sys3;ts pi" "rwg; ran"

# Hunt the Wumpus
midas "sys1;ts wumpus" "games; wumpus"

# Jotto
cwd "games"
midas "games;" "jotto"
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
midas "games;ts game" "ejs;ngame" {
    respond "Star Trek: " "ts,trek,games\r"
    respond "Adventure (2): " "ts,adv448,games\r"
    respond "Adventure (1.5): " "ts,adv350,games\r"
}
respond "*" ":link sys3;ts game,games;ts game\r"
respond "*" ":link info;o.info,_info_;\r"

# guess
midas "games;ts guess" "games;guess"

# ten50
midas "sys3;ts ten50" "mrc; ten50"

# who%
midas "sys1;ts who%" "sysen3;who%"
respond "*" ":link sys1;ts %,sys1;ts who%\r"

# MACRO-10
cwd "decsys"
respond "*" ":dec sys:macro\r"
respond "*" "macro=macro\r"
expect "CORE USED"
respond "*" "\003"
respond "*" ":kill\r"
linker "macro"
decuuo "sys2; ts macro"
respond "*" ":delete decsys; macro shr\r"
# Assemble with itself, now no errors
macro10 "macro" "macro"
linker "macro"
decuuo "sys2; ts macro"

# MACSYM and MONSYM universal files.
cwd "decsys"
macro10 "macsym.unv" "macsym.mac"
macro10 "monsym.unv" "monsym.mac"

# MACTEN and UUOSYM universal files.
macro10 "macten.unv" "macten.mac"
macro10 "uuosym.unv" "uuosym.mac"

# CROSS, assembler
macro10 "cross" "cross"
loader "cross"
decuuo "sys1; ts cross"

# Old PALX
midas "11logo;ts palx" "rms;palx 143"

# Phil Budne's PALX Game of Life.
cwd "budd"
palx "budd;" "live palx"

# MACN11, pdp-11 cross assembler
cwd "decsys"
macro10 "macn11" "macn11.hdr,macn11.mac"
loader "macn11"
decuuo "sys3; ts macn11"

# Cookie Bear
midas "gls; ts check" "gls; check" {
    respond "DEBUGP==" "0\r"
    respond "ITEM:" "COOKIE\r"
    respond "SUBJECT:" "COOKIE\r"
    respond "NAME:" "BEAR\r"
}

# Cookie Bear (this one actually works)
midas "eak;ts bear" "eak;bear"

# LOGOUT TIMES cleanup program.
midas "sys3;ts lotcln" "sysen1; lotcln"

# itsdev
midas "device;chaos itsdev" "bawden;itsdev"
respond "*" ":link device; tcp syn723, device; chaos itsdev\r"

# charfc/charfs
midas "sys1;ts charfc" "sysen3;charfc"
respond "*" ":link sys1;ts charfs,sys1;ts charfc\r"

# file
midas "sysbin;" "syseng;file"
respond "*" ":job file\r"
respond "*" ":load sysbin;\r"
respond "*" "purify\033g"
respond "CHAOS FILE" "\r"
respond "*" ":kill\r"

# filei, fileo
midas "device;chaos filei" "eak;file"
respond "*" ":link device;chaos fileo,device;chaos filei\r"

# ifile
midas "device;chaos ifile" "syseng;ifile"

# NFILE
midas "alan;" "bawden;nfile"
respond "*" ":job nfile\r"
respond "*" ":load alan;nfile bin\r"
respond "*" "purify\033g"
respond "CHAOS NFILE" "\r"
respond "*" ":kill\r"

# 11sim
midas "sys;ts pdp45" "syseng;11sim"
midast "sys1;ts pdp11" "syseng;11sim" {
    respond "end input with ^C" "45p==0\r"
    respond "\n" "\003"
}

# times
midas "sysbin;times bin" "sysnet;times"
respond "*" ":link sys1;ts ctimes,sysbin;times bin\r"
respond "*" ":link sys1;ts times,sysbin;times bin\r"

# idle
midas "sys1;ts idle" "gren;idle"

# spell
midas "sys1;ts spell" "syseng;spell"
respond "*" ":link sys1;ts espell,sys1;ts spell\r"

# jobs
midas "sys2;ts jobs" "sysen1;jobs"

# hsndev
midas "device;jobdev hsname" "sysen1;hsndev"
respond "*" ":link device;jobdev hs,device;jobdev hsname\r"
respond "*" ":link device;jobdev hf,device;jobdev hsname\r"

# gunner
midas "device; jobdev shoe" "rwk; gunner"

# Trivial Gunner
# Make a link from e.g. DRAGON; HOURLY GUNNER to use this program.
# It will log its actions to SPACY; GUNNER LOG.
midas "cstacy;" "gunner"

# pr
midas "sys1;ts pr" "sysen1;pr"
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
midas "sys2;ts inline" "sysen1;inline"

# init
midas "sys3;ts init" "sysen2;init"

# scandl
midas "sys3;ts scandl" "sysen1;scandl"

# os
midas "sys1;ts os" "sysen2;os"

# sn
midas "sys2;ts sn" "sysen3;sn"

# ttyswp
midas "sys;ts ttyswp" "sysen3;ttyswp"

# argus
midas "sys2;ts argus" "sysen2;argus"

# fretty
midas "sys3;ts fretty" "sysen2;fretty"

# bye
midas "sys1;ts bye" "sysen1;bye"
respond "*" ":link device;chaos bye,sys1;ts bye\r"

# yow server
midas "sys3;ts yow" "maeda; yow"
respond "*" ":link device;chaos yow, sys3; ts yow\r"

# yow client
midas "sysnet;ts yow" "sysen2; yow"

# @
midas "sysbin;" "sysen1;@"
respond "*" ":job @\r"
respond "*" ":load sysbin;\r"
respond "*" "purify\033g"
respond "TS @" "\r"
respond "*" ":kill\r"

omidas "dsk0:.;@ pt" "syseng;pt"

# PTY
midas "sys1;ts pty" "sysen1;pty"

# PRUFD
midas "sys1;ts prufd" "sysen2;prufd"

# udir
midas "sys3;ts nudir" "sysen3; nudir"

# STY
midas "sys1;ts sty" "sysen2;sty"

# luser
midas "sysbin;luser bin" "syseng;luser"
respond "*" ":link sys1;ts luser,sysbin;luser bin\r"

# ARCCPY
midas "sys2;ts arccpy" "sysen2;arccpy"

# CALPRT
midas "sys2;ts calprt" "sysen2;calprt"

# HOSTAB
midas "sys2;ts hostab" "sysen1;hostab"

# HOSTAT
midas "sys2;ts hostat" "sysen2;hostat"

# PROBE
respond "*" ":link syseng;its defs,sys;itsdfs >\r"
midas "sysbin;probe bin" "bawden;probe"
# note: setting debug to 0 and running causes it to pdump itself to
#  sys;ts probe
respond "*" ":job probe\r"
respond "*" ":load sysbin;probe bin\r"
respond "*" "debug/0\r"
type "\033g"
respond "*" ":link sys;ts pb,sys;ts probe\r"

# TTY
midas "sys1;ts tty" "sysen1;tty"

# TTYLINK, just a stub.
midas "sysbin;ttylin bin" "bawden; u"
respond "*" ":link device; chaos ttylin, sysbin; ttylin bin\r"

# IPLJOB
midas "sys;atsign ipl" "sysen2; ipljob"

# RIPDEV
midas "device;atsign r.i.p." "sysen2;ripdev"

# GMSGS
midas "sys2;ts gmsgs" "sysen1;gmsgs"
respond "*" ":link sys2;ts expire, sys2;ts gmsgs\r"
respond "*" ":link dragon;daily expire,sys2;ts gmsgs\r"
respond "*" ":link device;chaos gmsgs,sys2;ts gmsgs\r"

# X, Y, Z
midas "sys1;ts x" "sysen2;x"
respond "*" ":link sys1;ts y,sys1;ts x\r"
respond "*" ":link sys1;ts z,sys1;ts x\r"

# LOADP
midas "sys2;ts loadp" "sysen1;loadp"

# ACCLNK
midas "sys2;ts acclnk" "sysen2;acclnk"

# MSPLIT
midas "sys2;ts msplit" "sysen2;msplit"

# CHATST
midas "sys2;ts chatst" "sysen3;chatst"

# CHASTA
midas "sys3;ts chasta" "chsgtv;chasta"

# CHATAB
midas "sys3;ts chatab" "sysen1;chatab"

# STYLOG
midas "sys2;ts stylog" "sysen1;stylog"

# COMIFY
midas "sys2;ts comify" "sysen3;comify"

# CRC
midas "sys3;ts crc" "gren; crc"

# TMPKIL
midas "sys2;ts tmpkil" "syseng;tmpkil"
respond "*" ":link dragon;hourly tmpkil,sys2;ts tmpkil\r"

# WHAT
midas "sys2;ts what" "syseng;what"

# Build KCC support programs: EXECVT, GETSYM, and 20XCSV.
midas "sys2;ts execvt" "sysen3;execvt" 
midas "kcc;ts getsym" "getsym"
midas "kcc;ts 20xcsv" "20xcsv"

# Run GETSYM to get all monitor symbols.
cwd "kcc"
respond "*" ":getsym\r"
expect ":KILL"

# UP
midas "sys1;ts up" "sysen1;up"
respond "*" ":link sys1;ts down, sys1;ts up\r"

# UPTIME
midas "sysbin;uptime bin" "sysen1;uptime"
respond "*" ":link device;chaos uptime,sysbin;uptime bin\r"

# SHUTDN
midas "sys3;ts shutdn" "bawden;shutdn"

# HEXIFY
midas "sys2;ts hexify" "sysen3;hexify"

# PHOTO
midas "sys2;ts photo" "sysen2;photo"

# TYPE8
midas "sys;ts type8" "sysen3;type8"

# USQ
midas "sys2;ts usq" "sysen3;usq"
respond "*" ":link sys2;ts typesq,sys2;ts usq\r"

# SCRAM
midas "sys2;ts scram" "rwk;scram"

# HOST
midas "sys3;ts host" "sysnet;host"

# EXPN/VRFY
midas "sys3;ts expn" "sysnet;expn"
respond "*" ":link sys3;ts vrfy,sys3;ts expn\r"

# MUSCOM
midas "sysbin;" "syseng; muscom"
respond "*" ":link sys1;ts muscom, sysbin; muscom bin\r"

# BIG
oomidas 77 "SYSBIN;" "SYSENG; BIG"
oomidas 77 "SYSBIN;" "PRS; SUDSUD"
oomidas 77 "SYSBIN;" "PRS; PLOT"
oomidas 77 "SYSBIN;" "PRS; FIGS"
oomidas 77 "SYSBIN;" "PRS; SMOLDM"
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
midas "sys2;ts wholin" "sysen2;wholin"

# LINE
midas "sys2;ts line" "rab;line"

# WHOIML
midas "sysbin;" "sysen1; whoiml" {
    respond "FILE:" "whoiml\r"
    respond "FILE:" "sys2\r"
}
respond "*" ":job whoiml\r"
respond "*" ":load sysbin; whoiml bin\r"
respond "*" "start1\033b\033g"
expect ">>"
respond "   " ":kill\r"

# VTTIME
midas "sys1;ts vttime" "rvb;vttime"

# APLCLK
midas "sys3;ts aplclk" "music1; vtclk"

# DEVICE; CHAOS TIME
midas "device;chaos time" "syseng;ctimsr"

# DEVICE; CHAOS SEND
midas "sysbin;" "sysnet;senver"
respond "*" ":link device;chaos send,sysbin;senver bin\r"

# Alternate DEVICE; CHAOS SEND
midas "sysbin;" "sysnet;sends"
#respond "*" ":link device;chaos send,sysbin;senver bin\r"

# Chaosnet BABEL service.
midas "sysbin; babel" "dcp2; babel"
respond "*" ":link device;chaos babel,sysbin; babel bin\r"

# Chaosnet HOSTAB service.
midas "sysbin;" "eak; chahtb"
respond "*" ":link device; chaos hostab, sysbin; chahtb bin\r"
arpanet "rfc121" "sysbin; chahtb bin"

# Chaosnet 11LOAD service for booting MINITS.
midas "device; chaos 11load" "minits; 11load"

# OBS
midas "sys;ts obs" "bawden;obs"

# FED
midas "sys;ts fed" "sysen2;fed"

# XHOST
midas "sys2;ts xhost" "sysen3;xhost"

# FACTOR
midas "sys1;ts factor" "rz;factor"

# balanc
midas "sys3;ts balanc" "alan;balanc"
respond "*" ":link sys3;ts movdir,sys3;ts balanc\r"

# scrmbl and unscr
midas "sys3;ts scrmbl" "ejs;scrmbl"
respond "*" ":link sys3;ts unscr,sys3;ts scrmbl\r"

# ZOTZ
midas "ksc; ts zotz" "zotz"

respond "*" ":job maint\r"
# KA10 needs the .OLD files.  KL10 and KS10 the newer.
translate_diagnostics
respond "*" ":load maint; part a\r"
respond "*" ":start\r"
respond "PARt a" "\032"
expect -re {>>|\)}
type ":kill\r"

# Test one-proceed.
midas "maint;ts 1proc" "1proc test"
respond "*" ":maint;1proc\r"
expect "SUCCESSFUL"
expect ":KILL"

# XXFILE
midas "sysbin;xxfile bin" "sysen1;xxfile"
respond "*" ":job xxfile\r"
respond "*" ":load sysbin;xxfile bin\r"
respond "*" "ttyop1\033b\033g"
expect ":PDUMP SYS2;TS XXFILE"
expect ">>"
respond "   " ":kill\r"

# MSEND
midas "sysbin;" "sysen2;msend"
respond "*" ":job msend\r"
respond "*" ":load sysbin;msend bin\r"
respond "*" "ttyopn\033b\033g"
expect ">>"
respond "   " ":kill\r"

# IMLOAD and IMTRAN
midas "sys1; ts imload" "syseng; imload"
respond "*" ":link sys1; ts imtran, sys1; ts imload\r"

# UNTRAN
midas "imlac; ts untran" "untran"

# IMPRNT
midas "sys1; ts imprnt" "syseng; imprnt"
respond "*" ":link sys1; ts imprin, sys1; ts imprnt\r"
respond "*" ":link sys1; ts ardprn, sys1; ts imprnt\r"
respond "*" ":link sys1; ts tekprn, sys1; ts imprnt\r"

# IMGOUT
midas "sys3; ts imgout" "cbf; imgout"

# LINES
midas "bkph; ts lines" "lines"

# Random TV experiments.
midas "bkph; ts bull" "bull"
midas "bkph; ts grade" "grade"
midas "bkph; ts circle" "loops circle"
midas "bkph; ts randy" "randy"

# BLKLDR, Imlac secondary block loader.
midas "sysbin;" "imsrc; blkldr"
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
omidas "sysbin;" "imsrc; ssv22"
respond "*" ":imtran\r"
respond "@" "imlac; ssv22 iml_sysbin; ssv22 bin\r"
respond "@" "\021"
expect ":KILL"
respond "*" ":link imlac; .prgm. normal, imlac; ssv22 iml\r"

# Assemble SSV4.
midas "imlac; ts assv4" "assv4"

# SSV4, SSV for PDS-4.
respond "*" ":imlac;assv4\r"
respond "NUMBER" ">"
expect ":KILL"
respond "*" ":imtran\r"
respond "@" "imlac; ssv4 iml_imlac; ssv4b >\r"
respond "@" "\021"

# Maze War
midast "sysbin;" "imsrc; maze" {
    respond "with ^C" "MOUSE==1\r\003"
    respond "with ^C" "MOUSE==1\r\003"
}
respond "*" ":imtran\r"
respond "@" "imlac; m iml_sysbin; maze bin\r"
respond "@" "\021"

midas "sysbin;" "klh; mazser" {
    respond "NPTCL=" "1\r"
    respond "DEBUG=" "1\r"
    respond "STATS=" "1\r"
}
respond "*" ":job maze\r"
respond "*" ":load sysbin; mazser bin\r"
respond "*" ":start init\r"
respond "M IML" "\r"
respond ":PDUMP" "games; ts maze\r"
respond "*" ":kill\r"

# SWAR
midas "imlac;" "imsrc; swar" {
    respond "INFINITE FUEL AND BULLETS VERSION?" "N\r"
}
respond "*" ":imtran\r"
respond "@" "imlac; swar iml_imlac; swar bin\r"
respond "@" "\021"

# PONG
midas "imlac;" "imsrc; pong"
respond "*" ":imtran\r"
respond "@" "imlac; pong iml_imlac; pong bin\r"
respond "@" "\021"

# CRASH, PDS-4 version
midas "imlac;" "imsrc; crash"
respond "*" ":imtran\r"
respond "@" "imlac; crash4 iml_imlac; crash bin\r"
respond "@" "\021"
# PDS-1 version
midast "imlac;" "imsrc; crash" {
    respond "with ^C" "PDS4==0\r\003"
    respond "with ^C" "PDS4==0\r\003"
}
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
cwd "clib"
midas "clib;" "c10cor cmid"
midas "clib;" "c10fo cmid"
midas "clib;" "c10int cmid"
midas "clib;" "c10mio cmid"
midas "clib;" "c10sys cmid"
midas "clib;" "alloc cmid"
midas "clib;" "blt cmid"
midast "clib;" "cfloat cmid" clib_switches
midas "clib;" "random cmid"
midas "clib;" "string cmid"
midas "clib;" "uuoh cmid"
midast "clib;" "c10run cmid" clib_switches
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
cwd "c"
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
cwd "clib"
respond "*" ":cc tv.>\r"
expect ":KILL"

# TJ6
midas "sysbin;" "tj6;tj6"
respond "*" ":job tj6\r"
respond "*" ":load sysbin; tj6 bin\r"
respond "*" "purify\033g"
respond "DSK: SYS; TS NTJ6" "\r"
respond "*" ":kill\r"
respond "*" ":link sys; ts tj6, sys; ts ntj6\r"

# Old TJ6.
midas "sys2; ts otj6" "tj6; otj6"

# Alan Snyder's R typesetting language.
cwd "r"
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
cwd "c"
build_c_program "sysen2/oinit" "sys3/ts.oinit"

# RALP
build_c_program "cprog/ralp" "sys2/ts.ralp"

build_c_program "cprog/shell" "sys2/ts.shell" {clib/c10job.stk}

build_c_program "cprog/search" "sys2/ts.search"

build_c_program "cprog/ipak" "sys2/ts.ipak"

build_c_program "cprog/rstat" "cprog/ts.rstat"

# Versatec spooler
# This has some harmless unresolved symbols (FOO, XE4).
midas "sys3;ts versa" "dcp; versa"
# respond "*" ":link channa; rakash v80spl,sys3; ts versa\r"

# SCAN
midas "sysbin;" "sysen1; scan"
respond "*" ":job scan\r"
respond "*" ":load sysbin; scan bin\r"
respond "*" "purify\033g"
respond "*" ":pdump sys3; ts scan\r"
respond "*" ":kill\r"

# DDT subroutines
midas "sys3;ts cmd" "dcp; cmd"

# XGP and GLP
midas "sysbin;xgp bin" "sysen2;xqueue"
respond "*" ":job xgp\r"
respond "*" ":load sysbin;xgp bin\r"
respond "*" "debug/0\r"
type ":pdump sys;ts xgp\r"
respond "*" ":kill\r"
midast "sysbin;glp bin" "sysen2;xqueue" { respond "with ^C" "GLP==1\r\003" }
respond "*" ":job glp\r"
respond "*" ":load sysbin;glp bin\r"
respond "*" "debug/0\r"
type ":pdump sys2;ts glp\r"
respond "*" ":kill\r"

# XGPDEV and GLPDEV
midas "device;jobdev xgp" "sysen2;xgpdev"
midast "device;jobdev glp" "sysen2;xgpdev" {
    respond "with ^C" "GLP==1\r\003"
}

# GTLOAD, load programs into GT40.
midas "sys1; ts gtload" "syseng; gtload"

# RUG, PDP-11 debugger.
cwd "pdp11"
palx "pdp11;" "rug" {
    respond "?" "2\r"
    respond "?" "100000\r"
    respond "?" "1\r"
    respond "?" "1\r"
}

# URUG, GT40 debugger.
palx "sysbin;" "sysen2;urug" {
    respond "=YES" "1\r"
    respond "37000" "37000\r"
}

# GT40 Lunar Lander.
palx "gt40;" "gt40;gtlem"

# MINITS
cwd "mits.s"
palx "test" "config" {
    respond ":::" "777\r"
}

# MINITS boot ROM for an Interlan network interface.
cwd "mits.b"
palx "mits.b;" "bootil" {
    respond "Interlan CSR?" "0\r"
    respond "Chaos address of Interlan board?" "0\r"
    expect "Which set of downloading hosts?"
    respond ")" "0\r"
    respond "Start address?" "0\r"
    respond "Do you want a power up/boot support" "0\r"
    respond "Boot PROM mapping kludge?" "0\r"
    respond "Start of temporary data storage?" "150000\r"
}

# ELF
# The configuration to use, either ucbmac or voimac.
set mac "voimac"
respond "*" ":cwd elf\r"
macn11 "dis" "$mac,elfdis"
macn11 "dm1" "$mac,elfdm1"
macn11 "dm2" "$mac,elfdm2"
macn11 "ftp" "$mac,elfftp"
macn11 "lp" "$mac,elflp"
macn11 "mdv" "$mac,elfmdv"
macn11 "ncp" "$mac,elfncp"
macn11 "np0" "$mac,elfnp0"
macn11 "np1" "$mac,elfnp1"
macn11 "np2" "$mac,elfnp2"
macn11 "rk" "$mac,elfrk"
macn11 "rst" "$mac,elfrst"
macn11 "rti" "$mac,elfrti"
macn11 "rto" "$mac,elfrto"
macn11 "sa" "$mac,elfsa"
macn11 "tbl" "$mac,elftbl"
macn11 "tc" "$mac,elftc"
macn11 "wd" "$mac,elfwd"
macn11 "npo" "$mac,netnpo"
macn11 "clk" "$mac,voiclk"
macn11 "ioc" "$mac,voiioc"
macn11 "dtft" "$mac,dtftp"
macn11 "tnft" "$mac,tnftp"
macn11 "tnlogs" "$mac,tnlogs"

# ITS universal file.
cwd "decsys"
macro10 "sits.unv" "sits.mac"

# Datacomputer file transfer.
cwd "mrc"
macro10 "dftp" "dftp"
linker "dftp"
decuuo "sys1; ts dftp"

# PDP-11 Lisp.
palx "rms;" "lisp11" {
    respond "System (RANDOM, SIMULATOR, LOGO, MATH, or STANFORD)?" "SIMULATOR\r"
}

# Logo RUG.  STUFF prefers it to be RUG; AR BIN.
palx "rug;" "ar" {
    # We'll just do the Logo PDP-11/45.
    respond "COMPUTER=" "1\r"
}

# PUNCH, punch out paper tapes in the Logo RUG format.
midas "rug; ts punch" "punch"

# LODER, PDP-11 file transfer.
midas "rug;" "loder"
respond "*" ":link sys; ts nloder, rug; loder bin\r"
respond "*" ":link sys1; ts mloder, rug; loder bin\r"

# SITS.
cwd "sits"
palx "sits;" "sits"

# Salvager for the SITS file system.
palx "sits;" "salv"

# System Sphere for SITS.
palx "sits;" "sysspr"

# DDT for SITS.
palx "sits;" "ddt"

# Font loader daemon for SITS.
palx "sits;" "fnt"

# INQUIR for SITS.
palx "sits;" "inquir"

# DIRED for SITS.
palx "sits;" "dired"

# TECO for SITS.
cwd "rjl"
palx "rjl;" "teco"

# SLOGO, 11LOGO for SITS.
cwd "nlogo"
palx "slogo" "@slogo"

# HLOGO, "Hal hack" 11LOGO.
palx "hlogo" "@hlogo"

# ITSCOM, ITS-SITS communication.
cwd "bee"
palx "bee;" "itscom"

# ITS, SITS file transfer.
cwd "gld"
palx "gld;" "its"

# TORTIS
omidas "radia;" "tortis"

# BBN Logo
cwd "bbn"
macro10 "logo" "logo"
loader "logo"
decuuo "bbn; ts logo"

# CLOGO
midas "sys; ts clogo" "rjl; logo" {
    respond "STANDARD=" "0\r"
    respond "TBOX=" "0\r"
    respond "TURTLE=" "1\r"
    respond "PHYSICS=" "0\r"
    respond "LFLAG=" "0\r"
    respond "OLDMUSIC=" "0\r"
    respond "DFLAG=" "1\r"
}

# NVMIDS, Nova assembler
cwd "nova"
oomidas 73 "TS NVMIDS" "NVMIDS >"

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
cwd "11logo"
palx "/H/M/CL BIN,N CREF" "SYSTEM,TYI,READ,EVAL,TURTLE,ZEND" {
    respond "ASSSW=" "0\r"
}

# Apple II Logo
cwd "aplogo"
respond "*" ":cross\r"
respond "*" "logo/ptp,logo=logo\r"
expect "Core used"
respond "*" "\003"
respond "*" ":kill\r"

# Atari 800 terminal emulator Chameleon by Jack Palevich.
cwd "atlogo"
respond "*" ":cross\r"
respond "*" "supdup,supdup=supdup/m65\r"
expect "Core used"
respond "*" "\003"
respond "*" ":kill\r"

# TENTH, toy Forth.
midast "aap; ts tenth" "tenth" {
    respond "end input with ^C" "TS==1\r"
    respond "\n" "KS==0\r"
    respond "\n" "\003"
}

# GEORGE
midas "sys3;ts george" "syseng;george"

# MONIT
# The ERROR lines printed during assembly are locations of unlikely
# runtime errors (e.g. not being able to open TTY:).
midas "sys;ts monit" "dmcg;monit"

# BANNER
midas "sys3;ts banner" "sysen2; banner"

# IBMASC
midas "sys3;ts ibmasc" "sysen1;ibmasc"

# NEWDEC
midas "sys3;ts newdec" "sysen1;newdec"

# TBMOFF
midas "sys; ts tbmoff" "cstacy; tbmoff"

# UPTINI
midas "ejs;ts uptini" "uptini"

# CHATER
midas "sys1;ts chater" "gren;coms"

# STINK 121T, used to build Muddle and some old programs
midas "mudsys;ts stink" "sysen2;stink 121t"

# Move hello world xfiles into an archive.
cwd "hello"
respond "*" ":move dsk:c xfile, ar:\r"
respond "*" ":move dsk:clu xfile, ar:\r"
respond "*" ":move dsk:clu xxfile, ar:\r"
respond "*" ":move dsk:fail xfile, ar:\r"
respond "*" ":move dsk:fail xxfile, ar:\r"
respond "*" ":move dsk:fortra xfile, ar:\r"
respond "*" ":move dsk:fortra xxfile, ar:\r"
respond "*" ":move dsk:lisp xfile, ar:\r"
respond "*" ":move dsk:lisp xxfile, ar:\r"
respond "*" ":move dsk:macro xfile, ar:\r"
respond "*" ":move dsk:macro xxfile, ar:\r"
respond "*" ":move dsk:midas xfile, ar:\r"
respond "*" ":move dsk:muddle xfile, ar:\r"
respond "*" ":move dsk:muddle xxfile, ar:\r"
respond "*" ":move dsk:palx xfile, ar:\r"
respond "*" ":move dsk:palx xxfile, ar:\r"
respond "*" ":rename dsk:ar >, ar xfiles\r"
