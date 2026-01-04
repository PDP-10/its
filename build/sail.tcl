log_progress "ENTERING BUILD SCRIPT: SAIL"

# stktrn
cwd "sail"
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

# Make links needed for SUDS.
make_link "wl; switch 999999" " draw; switch >"
make_link "wl; first 999999" " draw; first >"
make_link "wl; sigsub 999999" " draw; sigsub >"
make_link "draw; board0 999999" " wl; board0 >"
make_link "draw; board1 999999" " wl; board1 >"
make_link "draw; board2 999999" " wl; board2 >"
make_link "draw; decloc 999999" " wl; decloc >"
make_link "draw; lg627 999999" " wl; lg627 >"
make_link "draw; lg684 999999" " wl; lg684 >"
make_link "draw; mpg21 999999" " wl; mpg21 >"
make_link "draw; mpg216 999999" " wl; mpg216 >"
make_link "draw; ncp13 999999" " wl; ncp13 >"
make_link "draw; ug61c 999999" " wl; ug61c >"
make_link "sys1; ts d" " datdrw; d bin"
make_link "sys1; ts wl" " datdrw; wl bin"
make_link "sys1; ts pc" " datdrw; pc bin"
make_link "sys1; ts scnv" " datdrw; scnv bin"

# The drawing program needs WL; BOARDS REL
cwd "wl"
respond "*" ":fail boards\r"
respond ";^C" ";\003"

# The PC program needs WL; PCBOARDS REL
respond "*" "PCBOARDS_BOARDS\r"
respond ";^C" "PC\r"
respond "SELECTED" ";\003"
respond "*" "\032:kill\r"

# SUDS drawing program
cwd "draw"
respond "*" ":fail d\r"
respond ";^C" ";\003"
respond "*" "\032:kill\r"
respond "*" ":stink d\r"
respond "STINK." "\177"
respond "??" "\033\0331L decsys; decbot bin\r"
respond "*" ".jbsa/strt\r"
respond ":" "56/107\r"
respond "\n" ":pdump datdrw; d bin\r"
respond "*" ":kill\r"

# SUDS ... PC
respond "*" ":fail pc_d\r"
respond ";^C" "PC\r"
respond "SELECTED" ";\003"
respond "*" "\032:kill\r"
respond "*" ":stink pc\r"
respond "STINK." "\177"
respond "??" "\033\0331L decsys; decbot bin\r"
respond "*" ".jbsa/strt\r"
respond ":" "56/107\r"
respond "\n" ":pdump datdrw; pc bin\r"
respond "*" ":kill\r"

# SUDS layout program.
respond "*" ":fail layd_d\r"
respond ";^C" "ONE\r"
respond "SELECTED" "D\r"
respond "\n" ";\003"
respond "*" "laypc_d\r"
respond ";^C" "ONE\r"
respond "SELECTED" "PC\r"
respond "SELECTED" ";\003"
respond "*" "\032:kill\r"
respond "*" ":stink lay\r"
respond "STINK." "\177"
respond "??" "\033\0331L decsys; decbot bin\r"
respond "*" ".jbsa/strt\r"
respond ":" "56/107\r"
respond "\n" ":pdump datdrw; lay bin\r"
respond "*" ":kill\r"

# SUDS wirelist program.
cwd "wl"
respond "*" ":fail wl\r"
respond "*" "wboard\r"
respond "*" "\032:kill\r"
respond "*" ":stink wl\r"
respond "STINK." "\177"
respond "??" "\033\0331L decsys; decbot bin\r"
respond "*" ".jbsa/strt\r"
respond ":" "56/107\r"
respond "\n" ":pdump datdrw; nodips bin\r"
respond "*" ":go\r"
expect {
    "PDP-6 not available" {
        respond "*" "C"
        # Display not available
        respond "*" "C"
        expect "TOP MODE"
    }
    "TOP MODE" {}
}
respond "*" "XRESIDENT\r"
respond "GO ON." "Y\r"
respond "WL BIN" "\r"
respond "*" ":kill\r"

midas "datdrw;" "draw; scnv"
