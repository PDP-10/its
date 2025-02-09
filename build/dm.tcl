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
respond "*" ":midas sysbin;_sysen2; gunner\r"
expect ":KILL"
respond "*" ":link sys; atsign gunner, sysbin; gunner bin\r"

# Line printer unspooler demon.
respond "*" ":midas sys; atsign unspoo_sysen1; unspoo\r"
# Just accept the defaults for now.
respond "(CR) FOR DEVICE LPT, nn FOR Tnn" "\r"
respond "(CR) FOR .LPTR. DIRECTORY, OR TYPE NEW NAME" "\r"
expect ":KILL"

# ARPANET support, Dynamic Modeling demon style
if [string equal "$mchn" "DM"] {
    respond "*" ":midas sys;atsign netrfc_syseng; netrfc\r"
    respond "DEMONP=" "1\r"
    expect ":KILL"
}

# Arpanet survey demon.
respond "*" ":midas sys; atsign survey_survey; survey\r"
expect ":KILL"

# Survey giver demon.
respond "*" ":midas survey; atsign surgiv_surgiv\r"
expect ":KILL"
respond "*" ":link sys; atsign surgiv, survey;\r"

# Survey sender demon.
respond "*" ":link sys; atsign sursnd, survey;\r"

# Login program.
respond "*" ":midas sysbin;_syseng; booter\r"
expect ":KILL"
# Enter an empty password for AS.
respond "*" ":job pw\r"
respond "*" "2/"
respond "0" "\0331'AS\033\r"
respond "\n" ":job booter\r"
respond "*" ":load sysbin;\r"
respond "*" "start/"
respond "LITTER" "\033q\033x"
respond "*" "a/"
respond "0" "\0331'\033\r"
respond "\n" ":go scramble\r"
expect "ILOPR"
respond "0>>0" "a/"
respond "   " ":job pw\r"
respond "*" "3/"
respond "0" "\0331q\r"
respond "\n" "\033y"
respond " " "sys;\021 \021 pass \021 words\r"
respond "*" ":kill\r"
respond "*" ":kill\r"
mkdir "(init)"
respond "*" ":link (init); as hactrn, sys2; ts shell\r"
