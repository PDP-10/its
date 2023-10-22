#Enable the remote shutdown service.
respond "*" ":midas /t device;chaos shutdo_sysnet;shutsr\r"
respond "end input with ^C" "ALLOW==3036\r\003"
expect ":KILL"

#Gun down users that are idle and not logged in.
respond "*" ":link dragon; hourly gunner, cstacy; gunner bin\r"
