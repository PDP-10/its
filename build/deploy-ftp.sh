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

# create_archive will create a tar ball from the out folder 
# try to extract it to see if it is valid
# retry 3 times then fail
create_archive() {
    MAX_RETRIES=3
    RETRY_COUNT=0

    while [ "$RETRY_COUNT" -lt "$MAX_RETRIES" ]; do
        (cd out; tar czf $EMULATOR.tgz $EMULATOR)

        # Verify the tarball
        if tar tf $EMULATOR.tgz >/dev/null 2>&1; then
            echo "Tarball is valid and can be expanded."
            break
        else
            echo "Tarball is not valid or cannot be expanded. Retrying..."
            RETRY_COUNT=`expr "$RETRY_COUNT" + 1`
            rm -f $EMULATOR.tgz
            continue
        fi
    done

    if [ "$RETRY_COUNT" = "$MAX_RETRIES" ]; then
        echo "Failed to create a valid tarball after $MAX_RETRIES attempts."
        return 1
    fi
}

# upload_file tries to upload the tar ball to the FTP server, will retry 5 times and then fail
upload_file() {
    MAX_RETRIES=5
    RETRY_COUNT=0

    while [ "$RETRY_COUNT" -lt "$MAX_RETRIES" ]; do
        echo "Deploying as $USER at $HOST"

        # Attempt to upload the file
        if ftp "$HOST" <<EOF
passive on
type image
cd $DIR
lcd out
put $EMULATOR.tgz
bye
EOF
        then
            echo "Upload successful."
            break
        else
            echo "Upload failed. Retrying..."
            RETRY_COUNT=`expr "$RETRY_COUNT" + 1`
        fi
    done

    if [ "$RETRY_COUNT" = "$MAX_RETRIES" ]; then
        echo "Failed to upload the file after $MAX_RETRIES attempts."
        return 1
    fi
}

# test_archive_integrity will download the tarball after successful upload and verify its integrity 
# by binary comparing the contents of the source folder and the expanded folder
test_archive_integrity() {
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

# main loop
while [ $retry_count -lt $RETRY_LIMIT ]; do
    create_archive
    upload_file
    if test_archive_integrity; then
        echo "File integrity verified successfully."
        exit 0
    else
        echo "File integrity verification failed, retrying... (`expr "$retry_count" + 1`/$RETRY_LIMIT)"
        retry_count=`expr "$retry_count" + 1`
    fi
done

echo "Reached maximum retry limit, exiting with failure."
exit 1
