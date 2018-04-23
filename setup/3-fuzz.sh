#!/usr/bin/env bash

_CUR_DIR=$(dirname "$0")
source ${_CUR_DIR}/common.sh

# remove, even when there is NO
sudo apt-get purge fot_tools -y

set -e

# fot-fuzz
fot_setup_header "fot-fuzz"
cd ${BASEDIR}/fot-fuzz
cargo clean
task install
fot_setup_footer "fot-fuzz"
fot_setup_alert "see how to use runtime fuzzing with 'fot-fuzz --help'"
