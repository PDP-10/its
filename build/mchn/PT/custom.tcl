#Enable the remote shutdown service.
respond "*" ":midas /t device;chaos shutdo_sysnet;shutsr\r"
respond "end input with ^C" "ALLOW==177001\r\003"
expect ":KILL"
