log_progress "ENTERING BUILD SCRIPT: PROCESSOR"

# Programs particular to the KA10 processor.

# macdmp, PDP-10 hardware read in, with 340 support.
respond "*" ":midas;77\r"
respond "MIDAS.77" ".;MACDMP RIM10_SYSENG; MACDMP MOBY1\r"
expect ":KILL"
# macdmp, PDP-6 read in hack.
respond "*" ":midas;77\r"
respond "MIDAS.77" ".;MACDMP RIM2_SYSENG; MACDMP 6U32\r"
expect ":KILL"

# system gen
respond "*" ":midas;324 dsk0:.;@ sysgen_syseng; system gen\r"
expect ":KILL"

# mark
respond "*" ":midas;324 dsk0:.;@ mark_syseng; mark\r"
expect ":KILL"

# utnam
midas "sys3; ts utnam" "lars; utnam"

# Name Dragon
respond "*" ":link syseng;tvkbd rooms, sysen2;\r"
midas "sysbin;" "sysen2;namdrg"
respond "*" ":link channa;rakash namdrg, sysbin; namdrg bin\r"

# STUFF
midas "sys1;ts stuff" "sysen2;stuff"
respond "*" ":link channa;rakash tvfix, sys1; ts stuff\r"

# IOELEV, PDP-11 doing I/O for the PDP-10 host.
# The "AI" IOELEV, also known as CHAOS-11.
# STUFF prefers to have it in the "." directory.
palx "dsk0:.;" "system;ioelev" { respond "MACHINE NAME =" "AI\r" }

# TV-11.  STUFF prefers it to be in the "." directory.
palx "dsk0:.;" "system;tv"

# XGP-11.  STUFF prefers it to be SYSBIN; VXGP BIN.
palx "sysbin;vxgp bin" "sysen2;xgp"

# CCONS.  STUFF prefers it to be in the CONS directory.
mkdir "cons"
palx "cons;" "lmcons;ccons"

# Old Spacewar
cwd "spcwar"
respond "*" ":midas;324 spcwar; war\r"
expect ":KILL"
midas "spcwar;" "stars"
expect ":KILL"
respond "*" ":midas;324 spcwar; math\r"
expect ":KILL"
respond "*" ":stink\r"
respond "\n" "mspcwar; war\033l\033\033"
respond "\n" "mstars\033l\033\033"
respond "\n" "mmath\033l\033\033"
respond "\n" "jwar\033d\033\033"
respond "\n" "\033y"
respond " " "dsk0:.;@ war\r"
respond "*" ":kill\r"

# Spacewar, standalone
respond "*" ":midas;324 dsk0:.;@ spcwar_spcwar; spcwar\r"
respond "ITS version" "NO\r"
respond "interrupt" "NO\r"
respond "ships" "\r"
respond "designs" "\r"
respond "suns" "\r"
respond "recording" "\r"
expect ":KILL"

# Spacewar, timesharing
midas "games;ts spcwar" "spcwar; spcwar" {
    respond "ITS version" "YES\r"
    respond "ships" "\r"
    respond "designs" "\r"
    respond "suns" "\r"
}

# PDP-6/10 Dazzle Dart
midas "games;ts dazdrt" "klh; dazdrt" {
    respond "Run under ITS?" "YES\r"
}
respond "*" ":midas;324 dsk0:.;@ dazdrt_klh; dazdrt\r"
respond "Run under ITS?" "NO\r"
expect ":KILL"

# Knight TV Spacewar
midas "gjd;" "swr data"
respond "*" ":job swr\r"
respond "*" ":load gjd; swr bin\r"
respond "*" "first\033,last\033\060ygjd; swr ships\r"
respond "*" ":kill\r"
respond "*" ":midas games;ts tvwar_spcwar; tvwar\r"
expect ":KILL"

# Dump TV bitmap as XGP scan file.
# TVREAD expects the binary in BKPH.
midas "bkph; ts zap" "zap"

# View bitmap file on TV.
midas "sys2; ts tvread" "vis; tvread"

# Save TV display as bitmap file.
midas "sys2; ts tvwrit" "sysen2; tvwrit"

# Save TV display as text file.
midas "sys2; ts record" "sysen2; record"

# TV paint program.
midas "sys2; ts tvedit" "sysen2; tvedit"

# KLH's Knight TV clock.
midas "klh; ts tinyw" "klh; clock" {
    respond "=" "1\r"
    respond "=" "1\r"
}
midas "klh; ts bigw" "klh; clock" {
    respond "=" "1\r"
    respond "=" "0\r"
    respond "=" "0\r"
}
midas "klh; ts digiw" "klh; clock" {
    respond "=" "1\r"
    respond "=" "0\r"
    respond "=" "1\r"
}

# XD, view XGP files on TV.
midas "sys3;ts xd" "sysen2;xd"

# TV-munching square.
midas "sys2;ts munch" "sysen2;munch"

# TITLER
midas "dsk0:.;@ titler" "mb; titler"

# MLIFE
respond "*" ":midas;324 games;ts mlife_rwg;mlife\r"
expect ":KILL"
respond "*" ":midas;324 /t dsk0:.;@ mlife_rwg;mlife\r"
respond "with ^C" "TS==0\r\003"
expect ":KILL"

# MLIFE
respond "*" ":midas;324 dsk0:.;@ pornis_rwg; pornis\r"
expect ":KILL"

# 3406
respond "*" ":midas;324 dsk0:.;@ 3406_stan.k; 3406\r"
expect ":KILL"

# 340D
midas "stan.k;mod11 bin" "340d"
respond "*" ":link sys1;ts 340d, stan.k; mod11 bin\r"

# Munching squares for 340 display.
midas "lars; ts munch" "munch"
midast "dsk0: .; @ munch" "lars; munch" {
    respond "with ^C" ".iotlsr==jfcl\r\003"
}

# Minskytron, translated from PDP-1.
midas "dsk0: lars; ts minsky" "minsky tron"
respond "*" ":link dsk0: .; @ minsky, lars; ts minsky\r"

# Edward Lorenz' strange attactor.
midas "dsk0: lars; ts lorenz" "lorenz"
respond "*" ":link dsk0: .; @ lorenz, lars; ts lorenz\r"

# Mandelbrot.
midas "lars; ts tvbrot" "tvbrot"

# MUSRUN
respond "*" ":midas;77\r"
respond "MIDAS.77" "SYSBIN;_SYSENG; MUSRUN\r"
expect ":KILL"
respond "*" ":midas;77\r"
respond "MIDAS.77" "SYSBIN;_SYSENG; H10D\r"
expect ":KILL"
respond "*" ":stink\r"
respond "\n" "msysbin; musrun\033l\033\033"
respond "\n" "mh10d\033l\033\033"
respond "\n" "jmusrun\033?d\033\033"
respond "\n" "\033y"
respond " " "sys1; ts musrun\r"
respond "*" ":kill\r"

# KA10 maintenance
respond "*" ":midas;324 sys;ts 10run_sysen2; 10run\r"
expect ":KILL"

# Display all Type 342 characters.
midas "dsk0:maint;" "tst342"

# XGP spooler
midas "sys2;ts xgpspl" "sysen2;xgpspl"

# XGP unspooler
midas "sysbin;" "syseng;scrimp"

# CARPET, remote PDP-11 debugger through Rubin 10-11 interface.
midas "sys3;ts carpet" "syseng;carpet"

# Patch PDP-6 LISP to run on PDP-10.
respond "*" ":job lisp\r"
respond "*" ":load .; @ lisp\r"
respond "*" "33777//\031"
respond "*" "\033q\033,777777\033\033z"
respond "*" "pitele+13/"
respond "FSC" "push p,b\n"
respond "FSC" "jrst patch\r"
respond "\n" "patch/"
respond "0" "move b,echocc\n"
respond "0" "add b,ticc\n"
respond "0" "dpb b,.+3\n"
respond "0" "pop p,b\n"
respond "0" "jrst pitele+15\n"
respond "0" "331000,,a\r"
respond "\n" "\033y"
respond " " "dsk0:.;@ lisp\r"
respond "*" ":kill\r"

# Lisp display slave, PDP-6 version.
midas "sys; atsign 6slave" "sysen2; ld10" {
    respond "   PDP6F = " "1\r"
}

# Test for the 340 "hack hack".
respond "*" $emulator_escape
punch_tape "$out/hhtest.rim"
type ":vk\r"
respond "*" ":midas ptp:_maint;hhtest\r"
expect ":KILL"

# NTS TECO-6
cwd ".teco."
respond "*" ":midas;73\r"
expect "MIDAS"
respond "\n" "TECODM REL_TECO DUMMY\r"
expect ":KILL"
respond "*" ":midas;73\r"
expect "MIDAS"
respond "\n" "MACTAP REL_SYSENG;MACTAP F68\r"
expect ":KILL"
respond "*" ":midas;73\r"
expect "MIDAS"
respond "\n" "LPT REL_SYSENG;LPT 11\r"
expect ":KILL"
respond "*" ":midas;73\r"
expect "MIDAS"
respond "\n" "TECO6 REL_.TECO.;TECO6 256K\r"
expect ":KILL"
respond "*" ":mudsys;stink\r"
respond "\n" "MTECODM\033L MLPT\033L MMACTAP\033L MTECO6\033L D\033\033"
respond "\n" "\033YDSK0:.;@ TECO\r"
respond "*" ":kill\r"
