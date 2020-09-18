log_progress "ENTERING BUILD SCRIPT: DM"

# This build script is for programs particular to the
# Dynamic Modeling PDP-10.

# Demon starter.
respond "*" ":midas sys; atsign demstr_sysen2; demstr\r"
expect ":KILL"
