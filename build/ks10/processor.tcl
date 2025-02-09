log_progress "ENTERING BUILD SCRIPT: PROCESSOR"

# Programs particular to the KS10 processor.

# KNS10, KS10 console
cwd "kshack"
respond "*" ":cross\r"
respond "*" "FOR21.DAT/PTP,KNS10.PNT/M80/OCT/CRF/EQ:PASS2:SCECOD=CONDEF.M80,HCORE.M80,CMDS.M80,SUBRTN.M80,DR.M80,MSG.M80,STORE.M80\r"
expect "Core used"
respond "*" "\003"
type ":kill\r"

# KS10 microcode assembler
midas "kshack;ts micro" "micro"

# KS10 microcode.
# It doesn't seem to work very well when purified.
respond "*" ":kshack;micro kshack;mcr 262=kshack;its,ks10,simple,flt,extend,inout,itspag,pagef\r"
expect ":KILL"
respond "*" ":copy kshack; mcr ram, .; ram ram\r"

# Update microcode on frontend filesystem.
respond "*" ":ksfedr\r"
respond "!" "write\r"
respond "Are you sure" "yes\r"
respond "Which file" "ram\r"
expect "Input from"
sleep 1
respond ":" ".;ram ram\r"
respond "!" "quit\r"
expect ":KILL"

# TENTH, toy Forth for KS10.
midas ".; @ tenth" "aap; tenth"
