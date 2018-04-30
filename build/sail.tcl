# stktrn
respond "*" ":cwd sail\r"
respond "*" ":fail stktrn\r"

# jobdat
respond "*" "jobdat\r"

# fail
respond "*" "fail\r"
respond "*" "\032:kill\r"
respond "*" ":delete fail bin\r"
respond "*" ":stink fail\r"
respond "\n" "\177"
respond "??" "\033\0331l decsys;decbot bin\r"
respond "*" ".jbsa/strt\r"
respond ":" "56/1000\r"
respond "\n" "\033y sail; fail bin\r"
respond "*" ":kill\r"
