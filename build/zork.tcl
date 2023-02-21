log_progress "ENTERING BUILD SCRIPT: ZORK"

# Zork startup
respond "*" ":midas sys2; ts zork_taa; zork\r"
expect ":KILL"

mkdir "cfs"

respond "*" ":xxfile lcf;comp log_lcf;comp xxfile\r"
expect -timeout 6000 "Job XXFILE interrupted: .VALUE;"
type "\033p"
expect ":KILL"

respond "*"  ":xxfile lcf;zork log_lcf;zork xxfile\r"
expect "Job XXFILE interrupted: .VALUE;"
type "\033p"
expect ":KILL"
