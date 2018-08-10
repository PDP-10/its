log_progress "ENTERING BUILD SCRIPT: MUDDLE"

respond "*" ":cwd mudsys\r"
respond "*" ":midas ts stinkm_stink\r"
expect ":KILL"

respond "*" ":xfile assem xfile\r"
expect -timeout 300 "Assembly done!"

respond "*" ":print mudsav; ..new. (udir)\r"
type ":vk\r"

respond "*" ":stinkm\r"
respond "STINK." "MMUD56 STINK\033@\033\033"
expect  "SETPUR"
respond "\n" "D\033\033"
respond "\n" "strng/\0331\"56^?^?^?\033\r"
respond "\n" ":pdump mudsav; ts mud56\r"
respond "*" ":start\r"
respond "..PERM/   -1" ":pdump mudsav; ts mdl56\r"
respond "*" ":kill\r"

respond "*" ":link sys3; ts mdl,mudsav; ts mdl56\r"
respond "*" ":link sys3; ts muddle,mudsav; ts mdl56\r"
