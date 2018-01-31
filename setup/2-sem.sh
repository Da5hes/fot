#!/usr/bin/env bash

_CUR_DIR=$(dirname "$0")
source ${_CUR_DIR}/common.sh

set -e

fot_setup_header "fot-sem"
cd ${BASEDIR}/fot-sem
pwd
task install
export export PATH=/usr/local/lib/fot/bin:$PATH
fot_setup_ensure_exec "fot-sem"
fot_setup_alert "PLEASE 'export PATH=/usr/local/lib/fot/bin:\$PATH' for permanent uses"
