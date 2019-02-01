#!/usr/bin/env bash

set -e

_CUR_DIR=$(dirname "$0")
source ${_CUR_DIR}/common.sh


# fot-instrument
fot_setup_header "fot-instrument"
cd ${BASEDIR}/fot-instrument
sudo make uninstall
make
sudo make install
cd ${BASEDIR}
fot_setup_footer "fot-instrument"

set +e
