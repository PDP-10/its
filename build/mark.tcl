log_progress "ENTERING BUILD SCRIPT: MARK"

start_salv

mark_bootstrap_packs

respond "DDT" "tran\033g"
respond "#" "0"
respond "OK" "y"
expect -timeout 300 EOT

respond "DDT" $emulator_escape

start_dskdmp_its

pdset
respond "*" ":login db\r"
type ":vk\r"

respond "*" $emulator_escape
mount_tape "$out/minsrc.tape"

type ":dump\r"
respond "_" "load links crdir sorry\r"
respond "FILE=" "*;* *\r"
expect -timeout 3000 "E-O-T"
respond "_" "quit\r"
expect ":KILL"

# Gague free disk blocks.
respond "*" ":listf sys\r"

mkdir "sysbin"
midas "sysbin;" "midas;midas"
respond "*" ":job midas\r"
respond "*" ":load sysbin;midas bin\r"
respond "*" "purify\033g"
respond "CR to dump" "\r"
sleep 2
respond "*" ":kill\r"

midas "sysbin;" "sysen1;ddt"
respond "*" ":job ddt\r"
respond "*" ":load sysbin;ddt bin\r"
respond "*" "purify\033g"
respond "*" ":pdump sys;atsign ddt\r"
respond "*" ":kill\r"

midas "dsk0:.;" "system;its" its_switches

make_ntsddt

make_salv

make_dskdmp

finish_mark
start_dskdmp
dump_nits
prepare_frontend
