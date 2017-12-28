#!/usr/bin/env bash

_CUR_DIR=$(dirname "$0")
source ${_CUR_DIR}/common.sh

set -e

# fot-fuzz
echo -e "\n${green}[x] set up fot-fuzz utilities...${reset}"
cd ${BASEDIR}/fot-fuzz
task install
echo -e "[+] fot-fuzz done!\n"
echo -e "[x] see how to use runtime fuzzing by 'fot-fuzz --help'"
