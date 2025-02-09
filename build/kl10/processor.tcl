log_progress "ENTERING BUILD SCRIPT: PROCESSOR"

# Programs particular to the KL10 processor.

# KL10 front end directory tool
midas "sys1;ts klfedr" "syseng;klfedr" {
    respond "RP06P=" "0\r"
    respond "RP04P=" "1\r"
}

mkdir ".klfe."
respond "*" ":move .temp.; -read- -this-, .klfe.;\r"
copy_to_klfe "kldcp; kldcp hlp"
#copy_to_klfe "kldcp; kldcp doc"

# KL10 microcode assembler
midas "sysbin;" "syseng;micro"
respond "*" ":job micro\r"
respond "*" ":load sysbin; micro bin\r"
respond "*" ":start purify\r"
respond "TS MICRO" "sys; ts micro\r"
respond "*" ":kill\r"

# Microcode ASCIIzer and binarator converter.
midas "sysbin;" "syseng;cnvrt"
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
linker "klddt"
decuuo "kldcp; klddt bin" "\033y"
respond "*" ":mcnvrt kldcp; klddt bin\r"
expect ":KILL"
move_to_klfe "kldcp; klddt a10"

# KL10 front end dumper
midas "dsk0:.;@ fedump" "kldcp; fedump"

# KL10 front end debugger.  Put it in the same directory as the
# "MC" IOELEV.
palx "sysbin;" "syseng; klrug"
# 11STNK expects a copy in the . directory.
respond "*" ":copy sysbin; klrug bin, .;\r"

# PDP-11 linker.
midas "sys1;ts 11stnk" "kldcp;11stnk"
respond "*" ":link .; ts boot11, sys1; ts 11stnk\r"

# KL10 diagnostics console program.
palx "kldcp;" "kldcp"
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
palx "kldcp;" "kldcpu\r"
respond "*" ":pcnvrt kldcp; kldcpu bin\r"
move_to_klfe "kldcp; kldcpu a11"

# PDP-11 debugger.
# 16K is used with the DL10 IOELEV.
palx ".; 11ddt 16k" "kldcp; 11ddt" {
    respond "PDP11=" "40\r"
    respond "EISSW=" "0\r"
    respond "MAPSW=" "0\r"
    respond "HCOR=" "100000\r"
    respond "TT10SW=" "0\r"
    respond "VT05SW=" "0\r"
    respond "DEBSW=" "0\r"
}
# 14K is used with the console IOELEV.
palx "dsk0:.;11ddt 14k" "kldcp; 11ddt" {
    respond "PDP11=" "40\r"
    respond "EISSW=" "0\r"
    respond "MAPSW=" "0\r"
    respond "HCOR=" "70000\r"
    respond "TT10SW=" "0\r"
    respond "VT05SW=" "0\r"
    respond "DEBSW=" "0\r"
}

# The KL10 console "MC" IOELEV.
palx ".; cons11" "system;ioelev" { respond "MACHINE NAME =" "MC\r" }
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
palx "sysbin;" "system;ioelev" { respond "MACHINE NAME =" "MC\r" }

# 11BOOT
midas;"324 sys3;ts 11boot" "syseng;11boot"
# Note, must be run with symbols loaded.
# Takes IOELEV BIN and KLRUG BIN from the current directory.
cwd "sysbin"
respond "*" "11boot\033\013"
expect ":KILL"
respond "*" ":move sysbin;@ boot11, .;\r"

# LSPEED
midas "sys1;ts lspeed" "syseng;lspeed"
