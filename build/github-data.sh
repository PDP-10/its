#!/bin/bash

get_next() {
    grep Link: log | tr , '\n' | grep 'rel="next"' | sed 's/.*<\(.*\)>.*/\1/'
}

get_data() {
    file=$1
    url="https://api.github.com/$2"
    n=1
    while test -n "$url"; do
	wget -S -o log -O "$file$n" "$url"
	url=`get_next`
	echo "NEXT: >>>$url<<<"
	n=`expr $n + 1`
    done
}

repo="PDP-10/its"
get_data issues "repos/$repo/issues?state=all&per_page=100"
get_data pulls "repos/$repo/pulls?state=all&per_page=100"
get_data comments "repos/$repo/issues/comments?per_page=100"
