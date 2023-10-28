#!/bin/sh

### BEGIN INIT INFO
# Provides:		pidp10
# Required-Start:	$syslog
# Required-Stop:	$syslog
# Default-Start:	2 3 4 5
# Default-Stop:		0 1 6
# Short-Description:	PiDP-10 emulator
### END INIT INFO

HOME="/home/lars/src/its2"
MCHN="$HOME/build/mchn/PT"
TOOLS="$HOME/tools"
LOG="$HOME/automated.log"
PID="$HOME/pidp10.pid"

action="$1"

fail() {
    echo "$1" 1>&2
    exit 1
}

expect() {
    text="$1"
    while :; do
        grep -q "$text" "$LOG" && return
        sleep 0.5
    done
}

status_screen() {
    screen -ls | grep -q pidp10
}

status_emulator() {
    kill -CONT `cat "$PID"` 2>/dev/null
}

case "$action" in
    status)
        status_screen || fail "PiDP-10 is down."
        status_emulator || fail "PiDP-10 is down."
	echo "PiDP-10 is up." 1>&2
        ;;
    start)
        cd "$HOME"
        screen -c "$MCHN/pidp10.screen" -dmS pidp10
        screen -S pidp10 -X logfile flush 1
        screen -S pidp10 -X select 0
        screen -S pidp10 -X title "SIMH control console"
        sleep 3
        screen -S pidp10 -X screen telnet localhost 1025
        rm -f "$LOG"
        screen -S pidp10 -X logfile "$LOG"
        screen -S pidp10 -X log on
        screen -S pidp10 -X title "KA10 console teletype"
        expect "DSKDMP"
        screen -S pidp10 -X log off
        rm -f "$LOG"
        screen -S pidp10 -X logfile "$HOME/ka10.log"
        screen -S pidp10 -X log on
	screen -S pidp10 -X stuff "ITS\r"
	screen -S pidp10 -X stuff "\033G"
        ;;
    stop)
        cd "$HOME"
        screen -S pidp10 -X log off
        rm -f "$LOG"
        screen -S pidp10 -X select 1
        screen -S pidp10 -X logfile "$LOG"
        screen -S pidp10 -X log on
        "$TOOLS/chaosnet-tools/shutdown" its
        expect "NOT IN OPERATION"
        expect "SHUTDOWN COMPLETE"
        screen -S pidp10 -X log off
        rm -f "$LOG"
	screen -S pidp10 -p0 -X stuff "\034"; sleep 1
	screen -S pidp10 -p0 -X stuff "quit\r"; sleep 1
	screen -S pidp10 -X quit
        if status_emulator; then
            kill `cat "$PID"` 2>/dev/null; sleep 1
            status_emulator && kill -9 `cat $PID` 2>/dev/null
        fi
        rm -f "$PID"
        ;;
    restart)
        $MCHN/pidp10.sh stop
        $MCHN/pidp10.sh start
        ;;
    *)
        echo "Unknown action: $action" 1>&2
        ;;
esac
