#!/bin/sh

set -e

HOST="hactrn.kostersitz.com"
USER="hactrn@kostersitz.com"
DIR="images"
NETRC="$HOME/.netrc"

if test -z "$FTP_SECRET"; then
    echo 'ERROR: No password in $FTP_SECRET.'
    exit 1
fi

echo "machine $HOST"         > "$NETRC"
echo "login $USER"          >> "$NETRC"
echo "password $FTP_SECRET" >> "$NETRC"
chmod 600 "$NETRC"

echo "Deploying to $USER@$HOST"

ftp "$HOST" <<EOF
type image
cd $DIR
lcd out
put $EMULATOR.tgz
bye
EOF

exit 0
