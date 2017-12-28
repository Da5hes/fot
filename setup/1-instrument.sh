#!/usr/bin/env bash

_CUR_DIR=$(dirname "$0")
source ${_CUR_DIR}/common.sh

# fot-instrument
fot_setup_header "fot-instrument"
cd ${BASEDIR}/fot-instrument
make
sudo make install
fot_setup_footer "fot-instrument"
