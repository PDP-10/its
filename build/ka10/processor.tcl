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
respond "*" ":midas sys3; ts utnam_lars; utnam\r"
expect ":KILL"

# Name Dragon
respond "*" ":link syseng;tvkbd rooms, sysen2;\r"
type ":vk\r"
respond "*" ":midas sysbin;_sysen2;namdrg\r"
expect ":KILL"
respond "*" ":link channa;rakash namdrg, sysbin; namdrg bin\r"
type ":vk\r"

# STUFF
respond "*" ":midas sys1;ts stuff_sysen2;stuff\r"
expect ":KILL"
respond "*" ":link channa;rakash tvfix, sys1; ts stuff\r"
type ":vk\r"

# IOELEV, PDP-11 doing I/O for the PDP-10 host.
# The "AI" IOELEV, also known as CHAOS-11.
# STUFF prefers to have it in the "." directory.
respond "*" ":palx dsk0:.;_system;ioelev\r"
respond "MACHINE NAME =" "AI\r"
expect ":KILL"

# TV-11.  STUFF prefers it to be in the "." directory.
respond "*" ":palx dsk0:.;_system;tv\r"
expect ":KILL"

# XGP-11.  STUFF prefers it to be SYSBIN; VXGP BIN.
respond "*" ":palx sysbin;vxgp bin_sysen2;xgp\r"
expect ":KILL"

# CCONS.  STUFF prefers it to be in the CONS directory.
mkdir "cons"
respond "*" ":palx cons;_lmcons;ccons\r"
expect ":KILL"

# Old Spacewar
respond "*" ":cwd spcwar\r"
respond "*" ":midas;324 spcwar; war\r"
expect ":KILL"
respond "*" ":midas spcwar; stars\r"
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
respond "*" ":midas games;ts spcwar_spcwar; spcwar\r"
respond "ITS version" "YES\r"
respond "ships" "\r"
respond "designs" "\r"
respond "suns" "\r"
expect ":KILL"

# PDP-6/10 Dazzle Dart
respond "*" ":midas games;ts dazdrt_klh; dazdrt\r"
respond "Run under ITS?" "YES\r"
expect ":KILL"
respond "*" ":midas;324 dsk0:.;@ dazdrt_klh; dazdrt\r"
respond "Run under ITS?" "NO\r"
expect ":KILL"

# Knight TV Spacewar
respond "*" ":midas gjd;_swr data\r"
expect ":KILL"
respond "*" ":job swr\r"
respond "*" ":load gjd; swr bin\r"
respond "*" "first\033,last\033\060ygjd; swr ships\r"
respond "*" ":kill\r"
respond "*" ":midas games;ts tvwar_spcwar; tvwar\r"
expect ":KILL"

# Dump TV bitmap as XGP scan file.
# TVREAD expects the binary in BKPH.
respond "*" ":midas bkph; ts zap_zap\r"
expect ":KILL"

# View bitmap file on TV.
respond "*" ":midas sys2; ts tvread_vis; tvread\r"
expect ":KILL"

# Save TV display as bitmap file.
respond "*" ":midas sys2; ts tvwrit_sysen2; tvwrit\r"
expect ":KILL"

# Save TV display as text file.
respond "*" ":midas sys2; ts record_sysen2; record\r"
expect ":KILL"

# TV paint program.
respond "*" ":midas sys2; ts tvedit_sysen2; tvedit\r"
expect ":KILL"

# KLH's Knight TV clock.
respond "*" ":midas klh; ts tinyw_klh; clock\r"
respond "=" "1\r"
respond "=" "1\r"
expect ":KILL"
respond "*" ":midas klh; ts bigw_klh; clock\r"
respond "=" "1\r"
respond "=" "0\r"
respond "=" "0\r"
expect ":KILL"
respond "*" ":midas klh; ts digiw_klh; clock\r"
respond "=" "1\r"
respond "=" "0\r"
respond "=" "1\r"
expect ":KILL"

# XD, view XGP files on TV.
respond "*" ":midas sys3;ts xd_sysen2;xd\r"
expect ":KILL"

# TV-munching square.
respond "*" ":midas sys2;ts munch_sysen2;munch\r"
expect ":KILL"

# TITLER
respond "*" ":midas dsk0:.;@ titler_mb; titler\r"
expect ":KILL"

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
respond "*" ":midas stan.k;mod11 bin_340d\r"
expect ":KILL"
respond "*" ":link sys1;ts 340d, stan.k; mod11 bin\r"

# Munching squares for 340 display.
respond "*" ":midas lars; ts munch_munch\r"
expect ":KILL"
respond "*" ":midas /t dsk0: .; @ munch_lars; munch\r"
respond "with ^C" ".iotlsr==jfcl\r\003"
expect ":KILL"

# Minskytron, translated from PDP-1.
respond "*" ":midas dsk0: lars; ts minsky_minsky tron\r"
expect ":KILL"
respond "*" ":link dsk0: .; @ minsky, lars; ts minsky\r"

# Edward Lorenz' strange attactor.
respond "*" ":midas dsk0: lars; ts lorenz_lorenz\r"
expect ":KILL"
respond "*" ":link dsk0: .; @ lorenz, lars; ts lorenz\r"

# Mandelbrot.
respond "*" ":midas lars; ts tvbrot_tvbrot\r"
expect ":KILL"

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
respond "*" ":midas dsk0:maint;_tst342\r"
expect ":KILL"

# XGP spooler
respond "*" ":midas sys2;ts xgpspl_sysen2;xgpspl\r"
expect ":KILL"

# XGP unspooler
respond "*" ":midas sysbin;_syseng;scrimp\r"
expect ":KILL"

# CARPET, remote PDP-11 debugger through Rubin 10-11 interface.
respond "*" ":midas sys3;ts carpet_syseng;carpet\r"
expect ":KILL"

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
respond "*" ":midas sys; atsign 6slave_sysen2; ld10\r"
respond "   PDP6F = " "1\r"
expect ":KILL"

# Test for the 340 "hack hack".
respond "*" $emulator_escape
punch_tape "$out/hhtest.rim"
type ":vk\r"
respond "*" ":midas ptp:_maint;hhtest\r"
expect ":KILL"
