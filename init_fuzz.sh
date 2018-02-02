#!/usr/bin/env bash

source $HOME/fot/setup/common.sh
cd $HOME/tests/

set -e

fot_setup_header "Redis Service"
redis-server &
sleep 5
fot_setup_footer "Redis Service - Started"


# Build the binary
fot_setup_header "Build Source"
if [ -f $TEST_TARGET_GZ ]; then
    sudo tar -xvzf $TEST_TARGET_GZ
    cd $TEST_TARGET
    ./configure CC=fot-clang LDFLAGS="-static" --prefix=$PWD/install
    make -j
    make install
else
    fot_setup_alert "Cannot find file $TEST_TARGET_GZ"
    exit
fi
fot_setup_foot "Build Source"