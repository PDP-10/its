log_progress "ENTERING BUILD SCRIPT: TYPESET"

respond "*" ":bolio;bolio moon;amber\r"
respond "NIL" "(quit)"
expect ":KILL"

# DDT Reference Manual by Eric Osman.
respond "*" ":otj6\r"
respond "_" "hur;ddtmem\r"
respond "_" "\032"
type ":kill\r"
