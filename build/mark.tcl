log_progress "ENTERING BUILD SCRIPT: MARK"

start_salv

mark_packs

respond "DDT" "tran\033g"
respond "#" "0"
respond "OK" "y"
expect -timeout 300 EOT

respond "DDT" $emulator_escape

start_dskdmp_its

pdset
respond "*" ":login db\r"
sleep 1

prepare_frontend

type ":dump\r"
respond "_" "load links crdir sorry\r"
respond "FILE=" "*;* *\r"
expect -timeout 3000 "E-O-T"
respond "_" "quit\r"
expect ":KILL"

# Gague free disk blocks.
respond "*" ":listf sys\r"

mkdir "sysbin"
respond "*" ":midas sysbin;_midas;midas\r"
expect ":KILL"
respond "*" ":job midas\r"
respond "*" ":load sysbin;midas bin\r"
respond "*" "purify\033g"
respond "CR to dump" "\r"
sleep 2
respond "*" ":kill\r"

respond "*" ":midas sysbin;_sysen1;ddt\r"
expect ":KILL"
respond "*" ":job ddt\r"
respond "*" ":load sysbin;ddt bin\r"
respond "*" "purify\033g"
respond "*" ":pdump sys;atsign ddt\r"
respond "*" ":kill\r"

respond "*" ":midas dsk0:.;_system;its\r"
its_switches
expect ":KILL"

make_ntsddt

make_salv

make_dskdmp

frontend_bootstrap

finish_mark
start_dskdmp
dump_nits
