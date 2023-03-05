#!/bin/sh

# At the $HOST, the $USER needs to have an .ssh directory with
# authorized_keys matching $SECRET.

set -e

HOST=hactrn.org
PORT=22
USER=images
DIR=/var/www/hactrn.org/images

SSH=$HOME/.ssh
ID=$SSH/id_rsa

if test -z "$SECRET"; then
    echo 'ERROR: No key in $SECRET.'
    exit 1
fi

mkdir -p $SSH
chmod 700 $SSH
echo "$SECRET" > $ID
chmod 600 $ID

ssh-keyscan -p $PORT -H $HOST >> ~/.ssh/known_hosts

(cd out; tar czf $EMULATOR.tgz $EMULATOR)

echo "Deploying to $USER@$HOST:$PORT"
rsync -av --inplace -e "ssh -p$PORT -l$USER" out/$EMULATOR.tgz $HOST:$DIR

# deploy images to mirror using FTP
# Define FTP connection details

if test -z "$FTP_SECRET"; then
    echo 'ERROR: No key in $FTP_SECRET.'
    exit 1
fi

FTP_HOST="hactrn.kostersitz.com"
FTP_USERNAME="hactrn@kostersitz.com"
FTP_PASSWORD="$FTP_SECRET"
DIR="images"

echo "Deploying to mirror at hactrn.kostersitz.com"

ftp -n $FTP_HOST <<END_SCRIPT
quote USER $FTP_USERNAME
quote PASS $FTP_PASSWORD
cd $DIR
put out/$EMULATOR.tgz
quit
END_SCRIPT

exit 0
