#!/usr/bin/env bash

# remove, even when there is NO
sudo apt-get purge fot_tools -y
_CUR_DIR=$(dirname "$0")
source ${_CUR_DIR}/common.sh
# fot-instrument
fot_setup_header "fot-instrument"
cd ${BASEDIR}/fot-instrument
make
sudo make install
fot_setup_footer "fot-instrument"
