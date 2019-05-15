#!/bin/sh

ETH="$2"
HOSTIP="$3"
TAP=tap0
BRIDGE=br0
USER=${SUDO_USER:-`whoami`}

usage() {
    echo "Usage: $0 start|stop interface [address]"
    exit 1
}

start() {
    test -z "$HOSTIP" && usage

    echo "WARNING!  This script may mess up your network configuration."
    echo "The current configuration will be logged to config.log."
    echo "Type Enter to continue."
    read foo

    brctl show > config.log
    ifconfig -a >> config.log
    route -n >> config.log

    #
    tunctl -t $TAP -u $USER
    ifconfig $TAP 0.0.0.0 down
    ifconfig $ETH 0.0.0.0 down
    brctl addbr $BRIDGE
    brctl setfd $BRIDGE 0
    brctl addif $BRIDGE $ETH $TAP
    ifconfig $BRIDGE up
    ifconfig $TAP up
    ifconfig $ETH up

    dhclient -v $BRIDGE

    route add -host $HOSTIP dev br0

    ifconfig $TAP | head -2
    ifconfig $ETH | head -2
    ifconfig $BRIDGE | head -2
    route -n
}

stop()
{
    ifconfig $BRIDGE 0.0.0.0 down
    ifconfig $TAP 0.0.0.0 down
    ifconfig $ETH 0.0.0.0 down
    brctl delif $BRIDGE $ETH $TAP
    brctl delbr $BRIDGE
    tunctl -d tap0
    ifconfig $ETH up
    dhclient $ETH
}

test -z "$1" && usage
test -z "$2" && usage

set -e
"$1"
