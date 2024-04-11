#!/bin/sh

set -e

HOST="hactrn.kostersitz.com"
USER="if0_35726802@hactrn.kostersitz.com"
DIR="/images"
TESTDIR="test"
NETRC="$HOME/.netrc"

if test -z "$FTP_SECRET"; then
    echo 'ERROR: No password in $FTP_SECRET.'
    exit 1
fi

echo "machine $HOST"         > "$NETRC"
echo "login $USER"          >> "$NETRC"
echo "password $FTP_SECRET" >> "$NETRC"
chmod 600 "$NETRC"

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

# test the upload and see if it expands correctly
echo "Testing download of $EMULATOR.tgz"
mkdir -p "$TESTDIR"
cd "$TESTDIR"

curl "http://$HOST/$DIR/$EMULATOR.tgz" -o "$EMULATOR.tgz"

if [ ! -f "$EMULATOR.tgz" ]; then
    echo "File $EMULATOR.tgz not found!"
    exit 1
else
    echo "Testing archive $EMULATOR.tgz"
    tar -xzf "$EMULATOR.tgz"
    if [ $? -eq 0 ]; then
        echo "Unpacking successful!"
    else
        echo "Error unpacking $EMULATOR.tgz: $(tar -xzf "$EMULATOR.tgz" 2>&1)"
        exit 1
    fi
fi

echo "Testing archive integrity"
# Define the paths to the folders
BUILDDIR="../$EMULATOR"
DLDIR="./$EMULATOR"

# Generate MD5 hashes for files in FOLDER1 (with relative filenames)
find "$BUILDDIR" -type f -exec md5sum {} + | sed "s|$BUILDDIR/||" > "$BUILDDIR_hashes.txt"

# Generate MD5 hashes for files in FOLDER2 (with relative filenames)
find "$DLDIR" -type f -exec md5sum {} + | sed "s|$DLDIR/||" > "$DLDIR_hashes.txt"

# Compare the hash files
if cmp -s "$BUILDDIR_hashes.txt" "$DLDIR_hashes.txt"; then
    echo "The contents of $BUILDDIR and $DLDIR are binary identical."
else
    echo "Differences found between $BUILDDIR and $DLDIR:"
    diff -u "$BUILDDIR_hashes.txt" "$DLDIR_hashes.txt"
fi

# Clean up temporary files
cd ..
rm -r "$TESTDIR"

exit 0
