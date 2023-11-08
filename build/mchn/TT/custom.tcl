#Enable the remote shutdown service.
respond "*" ":midas /t device;chaos shutdo_sysnet;shutsr\r"
respond "end input with ^C" "ALLOW==3036\r\003"
expect ":KILL"

#Gun down users that are idle and not logged in.
respond "*" ":link dragon; hourly gunner, cstacy; gunner bin\r"

#Run a weekly unattended incremental dump.
respond "*" ":midas dragon; weekly backup_lars; backup\r"
respond "HOST NAME =" "3036\r"
expect ":KILL"

# get rid of links to daemons that don't run correctly
respond "*" ":delete dragon;hourly digest\r"
respond "*" ":delete dragon;hourly gcbulk\r"
