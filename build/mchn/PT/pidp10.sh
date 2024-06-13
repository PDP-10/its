#!/bin/sh

### BEGIN INIT INFO
# Provides:		pidp10
# Required-Start:	$syslog
# Required-Stop:	$syslog
# Default-Start:	2 3 4 5
# Default-Stop:		0 1 6
# Short-Description:	PiDP-10 emulator
### END INIT INFO

verbose=message

HOME="/home/lars/src/its2"
MCHN="$HOME/build/mchn/PT"
TOOLS="$HOME/tools"
LOG="$HOME/automated.log"
PID="$HOME/pidp10.pid"

action="$1"

message() {
    echo "$1" 1>&2
}

fail() {
    message "$1"
    exit 1
}

expect() {
    text="$1"
    timeout="${2:-10}"
    i=0
    while :; do
        grep -q "$text" "$LOG" && return 0
        i=`expr $i + 1`
        test $i -ge $timeout && return 1
        sleep 1
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
	message "PiDP-10 is up."
        ;;
    start)
        cd "$HOME"
        $verbose "Starting PiDP-10 screen."
        screen -c "$MCHN/pidp10.screen" -dmS pidp10
        $verbose "Starting DSKDMP."
        screen -S pidp10 -X logfile flush 1
        screen -S pidp10 -X select 0
        screen -S pidp10 -X title "SIMH control console"
        sleep 3
        screen -S pidp10 -X screen telnet localhost 1025
        rm -f "$LOG"
        screen -S pidp10 -X logfile "$LOG"
        screen -S pidp10 -X log on
        screen -S pidp10 -X title "KA10 console teletype"
        if expect "DSKDMP"; then
            $verbose "Starting ITS."
	    screen -S pidp10 -X stuff "ITS\r"
	    screen -S pidp10 -X stuff "\033G"
            if expect "IN OPERATION" 20; then
                $verbose "ITS in operation."
                screen -S pidp10 -X log off
                rm -f "$LOG"
                screen -S pidp10 -X log on
                screen -S pidp10 -X logfile "$HOME/ka10.log"
                exit 0
            else
                fail "ITS failed to start."
            fi
        else
            fail "DSKDMP not started."
        fi

        # Something failed, shut everything down.
        if status_emulator; then
            kill `cat "$PID"` 2>/dev/null; sleep 1
            status_emulator && kill -9 `cat $PID` 2>/dev/null
        fi
	screen -S pidp10 -X quit
        ;;
    stop)
        cd "$HOME"
        screen -S pidp10 -X log off
        rm -f "$LOG"
        screen -S pidp10 -X select 1
        screen -S pidp10 -X logfile "$LOG"
        screen -S pidp10 -X log on
        $verbose "Shutting down ITS."
        "$TOOLS/chaosnet-tools/shutdown" its
        expect "NOT IN OPERATION" || fail "ITS failed to shut down."
        $verbose "ITS not in operation."
        expect "SHUTDOWN COMPLETE" 60 || fail "ITS failed to shut down."
        $verbose "ITS shutdown complete."
        screen -S pidp10 -X log off
        rm -f "$LOG"
        $verbose "Quitting KA10 emulator."
        screen -S pidp10 -X select 0
	screen -S pidp10 -X stuff "\034"; sleep 1
	screen -S pidp10 -X stuff "quit\r"; sleep 1
        if status_emulator; then
            $verbose "Emulator still running; forcibly killing it."
            kill `cat "$PID"` 2>/dev/null; sleep 1
            status_emulator && kill -9 `cat $PID` 2>/dev/null
        fi
        rm -f "$PID"
        $verbose "Stopping PiDP-10 screen."
	screen -S pidp10 -X quit
        ;;
    restart)
        $MCHN/pidp10.sh stop
        $MCHN/pidp10.sh start
        ;;
    *)
        message "Unknown action: $action"
        ;;
esac
