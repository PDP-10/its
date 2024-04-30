#!/bin/sh

HOST="hactrn.kostersitz.com"
USER="if0_35726802@hactrn.kostersitz.com"
DIR="/images"
TESTDIR="test"
NETRC="$HOME/.netrc"
RETRY_LIMIT=5
retry_count=0

if test -z "$FTP_SECRET"; then
    echo 'ERROR: No password in $FTP_SECRET.'
    exit 1
fi

echo "machine $HOST"         > "$NETRC"
echo "login $USER"          >> "$NETRC"
echo "password $FTP_SECRET" >> "$NETRC"
chmod 600 "$NETRC"

upload_file(){
    (cd out; tar czf $EMULATOR.tgz $EMULATOR)

    echo "Deploying as $USER at $HOST"

    ftp "$HOST" <<EOF
passive on
type image
cd $DIR
lcd out
put $EMULATOR.tgz
bye
EOF
}

test_archive_integrity(){
    echo "Testing download of $EMULATOR.tgz"
    mkdir -p "$TESTDIR"
    cd "$TESTDIR"

    curl "http://$HOST/$DIR/$EMULATOR.tgz" -o "$EMULATOR.tgz"

    if [ ! -f "$EMULATOR.tgz" ]; then
        echo "File $EMULATOR.tgz not found!"
        cd ..
        rm -rf "$TESTDIR"
        return 1
    else
        echo "Testing archive $EMULATOR.tgz"
        if tar -xzf "$EMULATOR.tgz"; then
            echo "Unpacking successful!"
        else
            echo "Error unpacking $EMULATOR.tgz: $(tar -xzf "$EMULATOR.tgz" 2>&1)"
            cd ..
            rm -rf "$TESTDIR"
            return 1
        fi
    fi

    echo "Testing archive integrity"
    BUILDDIR="../$EMULATOR"
    DLDIR="./$EMULATOR"

    find "$BUILDDIR" -type f -exec md5sum {} + | sed "s|$BUILDDIR/||" > "$BUILDDIR_hashes.txt"
    find "$DLDIR" -type f -exec md5sum {} + | sed "s|$DLDIR/||" > "$DLDIR_hashes.txt"

    if cmp -s "$BUILDDIR_hashes.txt" "$DLDIR_hashes.txt"; then
        echo "The contents of $BUILDDIR and $DLDIR are binary identical."
        cd ..
        rm -rf "$TESTDIR"
        return 0
    else
        echo "Differences found between $BUILDDIR and $DLDIR:"
        diff -u "$BUILDDIR_hashes.txt" "$DLDIR_hashes.txt"
        cd ..
        rm -rf "$TESTDIR"
        return 1
    fi
}


while [ $retry_count -lt $RETRY_LIMIT ]; do
    upload_file
    if test_archive_integrity; then
        echo "File integrity verified successfully."
        exit 0
    else
        echo "File integrity verification failed, retrying... ($((retry_count+1))/$RETRY_LIMIT)"
        retry_count=$((retry_count+1))
    fi
done

echo "Reached maximum retry limit, exiting with failure."
exit 1
