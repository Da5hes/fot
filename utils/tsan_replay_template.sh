#!/usr/bin/env bash

EXT="res"

# set -e

if [ "$#" -lt 2 ]; then
    echo "usage: $0 REPLAY_DIR LOGFILE"
    exit 1
fi

REPLAY_DIR=$1
LOGFILE=$2

export LD_LIBRARY_PATH=/home/ubuntu/work/openmp/openmp-4-install/lib
# export LD_LIBRARY_PATH=/home/ubuntu/work/openmp/openmp-7-install/lib

for f in $REPLAY_DIR/*; do 
    ext="${f##*.}";
    if [[ "$ext" == "$EXT" ]]; then
        echo "Ignore $f"
    else
        echo "===$f"
        time timeout -s 9 30 ./ImageMagick-tsan/install/bin/convert -quiet $f /tmp/tsan.bmp 2>$f.${EXT}
    fi
done | tee $LOGFILE

# set +e
