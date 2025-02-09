log_progress "ENTERING BUILD SCRIPT: DM"

# This build script is for programs particular to the
# Dynamic Modeling PDP-10.

# Demon starter.
midas "sys; atsign demstr" "sysen2; demstr"

# Demon status.  Self purifying.
midas "sysen2; ts demst" "sysen2; demst"

# Gun down dead demons.
respond "*" ":link taa; pwfile 999999, sysen1; pwfile >\r"
midas "sysbin;" "sysen2; gunner"
respond "*" ":link sys; atsign gunner, sysbin; gunner bin\r"

# Line printer unspooler demon.
midas "sys; atsign unspoo" "sysen1; unspoo" {
    # Just accept the defaults for now.
    respond "(CR) FOR DEVICE LPT, nn FOR Tnn" "\r"
    respond "(CR) FOR .LPTR. DIRECTORY, OR TYPE NEW NAME" "\r"
}

# ARPANET support, Dynamic Modeling demon style
if [string equal "$mchn" "DM"] {
    midas "sys;atsign netrfc" "syseng; netrfc" {
        respond "DEMONP=" "1\r"
    }
}

# Arpanet survey demon.
midas "sys; atsign survey" "survey; survey"

# Survey giver demon.
midas "survey; atsign surgiv" "surgiv"
respond "*" ":link sys; atsign surgiv, survey;\r"

# Survey sender demon.
respond "*" ":link sys; atsign sursnd, survey;\r"

# Login program.
midas "sysbin;" "syseng; booter"
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
