log_progress "ENTERING BUILD SCRIPT: MUDDLE"

respond "*" ":cwd mudsys\r"
respond "*" ":midas ts stinkm_stink\r"
expect ":KILL"

respond "*" ":xfile assem xfile\r"
expect -timeout 300 "Assembly done!"

mkdir "mudsav"

respond "*" ":stinkm\r"
respond "STINK." "MMUD56 STINK\033@\033\033"
expect  "SETPUR"
respond "\n" "D\033\033"
respond "\n" "strng/\0331\"56^?^?^?\033\r"
respond "\n" ":pdump mudsav; ts mud56\r"
respond "*" ":start\r"
respond "..PERM/   -1" ":pdump mudsav; ts mdl56\r"
respond "*" ":kill\r"

respond "*" ":midas sys3; ts mudinq_sysen2; mudinq\r"
expect ":KILL"
respond "*" ":link sys3; ts purge, sys3; ts mudinq\r"
respond "*" ":link sys3; ts makscr, sys3; ts mudinq\r"
respond "*" ":link sys3; ts status, sys3; ts mudinq\r"
respond "*" ":link sys3; ts whomud, sys3; ts mudinq\r"

respond "*" ":link sys3; ts mdl,mudsav; ts mdl56\r"
respond "*" ":link sys3; ts muddle,mudsav; ts mdl56\r"

respond "*" ":midas sys3; ts mudcom_sysen3; mudcom\r"
respond "(Y OR N)" "Y\r"
expect ":KILL"
respond "*" ":link sys3; ts mudchk, sys3; ts mudcom\r"
respond "*" ":link sys3; ts mudlst, sys3; ts mudcom\r"
respond "*" ":link sys3; ts mudfnd, sys3; ts mudcom\r"

respond "*" ":midas sys3; ts combat_sysen3; combat\r"
respond "(Y OR N)" "Y\r"
expect ":KILL"

respond "*" ":midas sys3; ts pick_sysen2; pick\r"
expect ":KILL"
