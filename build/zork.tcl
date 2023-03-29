log_progress "ENTERING BUILD SCRIPT: ZORK"

# Old Zork startup
respond "*" ":midas sys2; ts ozork_taa; zork\r"
expect ":KILL"

# New Zork startup
respond "*" ":midas sys; ts rbye_cfs; zork\r"
expect ":KILL"
respond "*" ":link sys1;ts zork, sys; ts rbye\r"

mkdir "cfs"

respond "*" ":xxfile lcf;comp log_lcf;comp xxfile\r"
expect -timeout 6000 "Job XXFILE interrupted: .VALUE;"
type "\033p"
expect -timeout 500 ":KILL"

respond "*"  ":xxfile lcf;TTY:_lcf;zork xxfile\r"
expect -timeout 6000 "Job XXFILE interrupted: .VALUE;"
type "\033p"
expect -timeout 500 ":KILL"
