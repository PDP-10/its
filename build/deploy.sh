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
set +x
echo "$SECRET" > $ID
chmod 600 $ID

ssh-keyscan -p $PORT -H $HOST >> ~/.ssh/known_hosts

echo "Deploying to $USER@$HOST:$PORT"
rsync -av -e "ssh -p$PORT -l$USER" out $HOST:$DIR

exit 0
