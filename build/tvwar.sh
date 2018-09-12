# Run this and direct the output to a file.  Copy it to GJD; SWR DATA.

#(loop for i from 0 to 63 do (insert (format "%.1f " (mod (- 90 (* (/ i 64.0) 360)) 360))))

rotate() {
    n=0
    for i in 90.0 84.4 78.8 73.1 67.5 61.9 56.2 50.6 45.0 39.4 33.8 28.1 22.5 16.9 11.2 5.6 0.0 354.4 348.8 343.1 337.5 331.9 326.2 320.6 315.0 309.4 303.8 298.1 292.5 286.9 281.2 275.6 270.0 264.4 258.8 253.1 247.5 241.9 236.2 230.6 225.0 219.4 213.8 208.1 202.5 196.9 191.2 185.6 180.0 174.4 168.8 163.1 157.5 151.9 146.2 140.6 135.0 129.4 123.8 118.1 112.5 106.9 101.2 95.6; do
        f="$1".`printf '%03o' $n`.xpm
        f2="$1".`printf '%03o' $n`-0.xpm
        convert -background black "$1".png -rotate "$i" -gravity center -crop 256x256 -resize 32x32 -colorspace gray -auto-level -threshold 50% "$f"
        test -r "$f" || f="$f2"
        cat "$f" | tail -33 | grep -v '^}' | tr -d '",' | tr ' .' '01'
        n=`expr $n + 1`
    done
}

echo "loc 100"
echo "radix 2"
echo "first=."
rotate wedge3
rotate needle3
rotate enterprise3
echo "last=.-1"
echo "end"
