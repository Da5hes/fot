#!/bin/bash

_CUR_DIR=$(dirname "$0")
source ${_CUR_DIR}/common.sh

set -e

# fot-fuzz
fot_setup_header "fot-fuzz"
cd ${BASEDIR}/fot-fuzz
task install
fot_setup_footer "fot-fuzz"
fot_setup_alert "see how to use runtime fuzzing with 'fot-fuzz --help'"
