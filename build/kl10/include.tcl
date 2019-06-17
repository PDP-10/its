make_ntsddt {} {
    # KL10 NTSDDT.
    respond "*" ":midas dsk0:.;@ ntsddt_system;ddt\r"
    respond "cpusw=" "2\r"
    respond "ndsk=" "1\r"
    respond "dsksw=" "3\r"
    respond "1PRSW=" "1\r"
    expect ":KILL"
}
