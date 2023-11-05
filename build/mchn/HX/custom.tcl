#Gun down users that are idle and not logged in.
respond "*" ":link dragon; hourly gunner, cstacy; gunner bin\r"

#Run a weekly unattended incremental dump.
respond "*" ":midas dragon; weekly backup_lars; backup\r"
respond "HOST NAME =" "177001\r"
expect ":KILL"

# get rid of links to daemons that don't run correctly
respond "*" ":delete dragon;hourly digest\r"
respond "*" ":delete dragon;hourly gcbulk\r"
