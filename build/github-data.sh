#!/bin/bash

url="https://api.github.com/repos/PDP-10/its/issues?state=all&per_page=100"
n=1

get_next() {
    grep Link: log | tr , '\n' | grep 'rel="next"' | sed 's/.*<\(.*\)>.*/\1/'
}

while test -n "$url"; do
    wget -S -o log -O "data$n" "$url"
    url=`get_next`
    echo "NEXT: >>>$url<<<"
    n=`expr $n + 1`
done
