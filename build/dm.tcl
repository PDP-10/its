log_progress "ENTERING BUILD SCRIPT: DM"

# This build script is for programs particular to the
# Dynamic Modeling PDP-10.

# Demon starter.
respond "*" ":midas sys; atsign demstr_sysen2; demstr\r"
expect ":KILL"

# Demon status.  Self purifying.
respond "*" ":midas sysen2; ts demst_sysen2; demst\r"
expect ":KILL"

# Gun down dead demons.
respond "*" ":link taa; pwfile 999999, sysen1; pwfile >\r"
type ":vk\r"
respond "*" ":midas sys; atsign gunner_sysen2; gunner\r"
expect ":KILL"

# Line printer unspooler demon.
respond "*" ":midas sys; atsign unspoo_sysen1; unspoo\r"
# Just accept the defaults for now.
respond "(CR) FOR DEVICE LPT, nn FOR Tnn" "\r"
respond "(CR) FOR .LPTR. DIRECTORY, OR TYPE NEW NAME" "\r"
expect ":KILL"

# Arpanet survey demon.
respond "*" ":midas sys; atsign survey_survey; survey\r"
expect ":KILL"

# Survey giver demon.
respond "*" ":midas survey; atsign surgiv_surgiv\r"
expect ":KILL"
respond "*" ":link sys; atsign surgiv, survey;\r"
type ":vk\r"

# Survey sender demon.
respond "*" ":link sys; atsign sursnd, survey;\r"
type ":vk\r"
