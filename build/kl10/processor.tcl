log_progress "ENTERING BUILD SCRIPT: PROCESSOR"

# Programs particular to the KL10 processor.

# KL10 front end directory tool
respond "*" ":midas sys1;ts klfedr_syseng;klfedr\r"
respond "RP06P=" "0\r"
respond "RP04P=" "1\r"
expect ":KILL"

mkdir ".klfe."
respond "*" ":move .temp.; -read- -this-, .klfe.;\r"
copy_to_klfe "kldcp; kldcp hlp"
#copy_to_klfe "kldcp; kldcp doc"

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

respond "*" ":mcnvrt .; @ ddt\r"
expect ":KILL"
respond "*" ":rename .; @ a10, ddt a10\r"
move_to_klfe ".; ddt a10"

# KL10 microcode.
respond "*" ":micro ucode;u1=ucode;its,define,macro,basic,skpjmp,shift,arith,fp,byte,io,eis,blt\r"
expect ":KILL"
respond "*" ":ucnvrt ucode; u1\r"
expect ":KILL"

# Update microcode in frontend filesystem.
copy_to_klfe "ucode;u1 ram"

# KLDDT
cwd "kldcp"
macro10 "klddt" "klddt"
respond "*" ":dec sys:link\r"
respond "*" "klddt/go\r"
respond "EXIT" ":start 45\r"
respond "Command:" "d"
respond "*" "\033y"
respond " " "kldcp; klddt bin\r"
respond "*" ":kill\r"
respond "*" ":mcnvrt kldcp; klddt bin\r"
expect ":KILL"
move_to_klfe "kldcp; klddt a10"

# KL10 front end dumper
respond "*" ":midas dsk0:.;@ fedump_kldcp; fedump\r"
expect ":KILL"

# KL10 front end debugger.  Put it in the same directory as the
# "MC" IOELEV.
respond "*" ":palx sysbin;_syseng; klrug\r"
expect ":KILL"
# 11STNK expects a copy in the . directory.
respond "*" ":copy sysbin; klrug bin, .;\r"

# PDP-11 linker.
respond "*" ":midas sys1;ts 11stnk_kldcp;11stnk\r"
expect ":KILL"
respond "*" ":link .; ts boot11, sys1; ts 11stnk\r"

# KL10 diagnostics console program.
respond "*" ":palx kldcp;_kldcp\r"
expect ":KILL"
respond "*" ":11stnk\r"
respond "*" "R"
respond "FILENAME" "\r"
respond "*" "L"
respond "FILENAME" "kldcp; kldcp bin\r"
respond "*" "B"
respond "FILENAME" ".temp.; kldcp bin\r"
expect ":KILL"
move_to_klfe ".temp.; kldcp bin"

# KL10 diagnostic console utility
respond "*" ":palx kldcp;_kldcpu\r"
expect ":KILL"
respond "*" ":pcnvrt kldcp; kldcpu bin\r"
move_to_klfe "kldcp; kldcpu a11"

# PDP-11 debugger.
# 16K is used with the DL10 IOELEV.
respond "*" ":palx .; 11ddt 16k_kldcp; 11ddt\r"
respond "PDP11=" "40\r"
respond "EISSW=" "0\r"
respond "MAPSW=" "0\r"
respond "HCOR=" "100000\r"
respond "TT10SW=" "0\r"
respond "VT05SW=" "0\r"
respond "DEBSW=" "0\r"
expect ":KILL"
# 14K is used with the console IOELEV.
respond "*" ":palx dsk0:.;11ddt 14k_kldcp; 11ddt\r"
respond "PDP11=" "40\r"
respond "EISSW=" "0\r"
respond "MAPSW=" "0\r"
respond "HCOR=" "70000\r"
respond "TT10SW=" "0\r"
respond "VT05SW=" "0\r"
respond "DEBSW=" "0\r"
expect ":KILL"

# The KL10 console "MC" IOELEV.
respond "*" ":palx .; cons11_system;ioelev\r"
respond "MACHINE NAME =" "MC\r"
expect ":KILL"
respond "*" ":11stnk\r"
respond "*" "D"
respond "FILENAME" ".; 11ddt 14k\r"
respond "*" "L"
respond "FILENAME" ".; cons11 bin\r"
respond "*" "A"
respond "FILENAME" ".temp.; ioelev bin\r"
expect ":KILL"
respond "*" ":pcnvrt .temp.; ioelev bin\r"
expect ":KILL"
move_to_klfe ".temp.; ioelev a11"

# The KL10 "MC-DL" IOELEV.  Put in same directory as KLRUG BIN.
# TS BOOT11 stuffs it over DL10 in timesharing.  TS 11BOOT makes a
# @ BOOT11 to stuff out of timesharing.
respond "*" ":palx sysbin;_system;ioelev\r"
respond "MACHINE NAME =" "MC\r"
expect ":KILL"

# 11BOOT
respond "*" ":midas;324 sys3;ts 11boot_syseng;11boot\r"
expect ":KILL"
# Note, must be run with symbols loaded.
# Takes IOELEV BIN and KLRUG BIN from the current directory.
cwd "sysbin"
respond "*" "11boot\033\013"
expect ":KILL"
respond "*" ":move sysbin;@ boot11, .;\r"

# LSPEED
respond "*" ":midas sys1;ts lspeed_syseng;lspeed\r"
expect ":KILL"
