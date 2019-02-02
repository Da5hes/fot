#!/usr/bin/env bash

EXT="res"

# set -e

if [ "$#" -lt 1 ]; then
    echo "usage: $0 REPLAY_DIR"
    exit 1
fi

REPLAY_DIR=$1

for f in $REPLAY_DIR/*; do 
    ext=="${f##*.}";
    if [[ "$ext" == "$EXT" ]]; then
        echo "Ignore $f"
    else
        echo "===$f"
        time timeout -s 9 60 ./ImageMagick-tsan/install/bin/convert -quiet $f /tmp/tsan.bmp 2>$f.${EXT}
    fi
done | tee REPLAY 

# set +e
