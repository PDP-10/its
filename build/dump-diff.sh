#!/bin/sh

cleanup() {
    cd "$home"
    rm -rf "$tmp"
}

absolute() {
    case "$1" in
        /*) echo "$1";;
        *) echo "$PWD/$1";;
    esac
}

tape1="`absolute $1`"
tape2="`absolute $2`"
home="$PWD"
tmp="$PWD/tmp.$$"

trap cleanup EXIT INT TERM QUIT

mkdir "$tmp"
cd "$tmp"

mkdir tape1
cd tape1
itstar xf "$tape1"
rm -- */_file_.\(dir\) */m_f_d_.\(file\)
cd "$tmp"
mkdir tape2
cd tape2
itstar xf "$tape2"
rm -- */_file_.\(dir\) */m_f_d_.\(file\)
cd "$tmp"
rm "$home/diffs"

output() {
    echo "$1: $2"
    echo "$2" >> "$home/diffs"
}

diff_file() {
    file="$1"
    if test -L "$file"; then
        if test -L "../tape1/$file"; then
            l1=`readlink "../tape1/$file"`
            l2=`readlink "$file"`
            if test "$l1" \!= "$l2"; then
                output "UPDATED LINK" "$file"
            fi
        else
            output "NEW LINK" "$file"
        fi
    elif test -f "../tape1/$file"; then
        if cmp -- "$file" "../tape1/$file" > /dev/null; then
            :
        else
            dis10 "$file" 2> /dev/null | grep -v -e 'Creation time:' -e 'Symbol ' -e '^[0-7][0-7][0-7]   [0-7]' > "$tmp/TMP1"
            dis10 "../tape1/$file" 2> /dev/null | grep -v -e 'Creation time:' -e 'Symbol ' -e '^[0-7][0-7][0-7]   [0-7]' > "$tmp/TMP2"
            if cmp -- "$tmp/TMP1" "$tmp/TMP2" > /dev/null; then
                :
            else
                output "UPDATED FILE" "$file"
            fi
        fi
    else
        output "NEW FILE" "$file"
    fi
}

cd tape2
for dir in *; do
    if test -d "../tape1/$dir"; then
        for file in $dir/*; do
            test -r "$file" && diff_file "$file"
        done
    else
        output "NEW DIRECTORY" "$dir"
    fi
done

cd "$tmp/tape2"
head -1 "$home/diffs" | xargs itstar cvf "$home/diffs.tap"
tail +2 "$home/diffs" | xargs itstar rvf "$home/diffs.tap"
cd "$home"
rm "$home/diffs"
