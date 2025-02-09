#Enable the remote shutdown service.
midas "/t device;chaos shutdo" "sysnet;shutsr" {
    respond "end input with ^C" "ALLOW==177001\r\003"
}

#Disable the DM gunner.
respond "*" ":delete sys;atsign gunner\r"
