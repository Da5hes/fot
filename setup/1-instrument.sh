#!/usr/bin/env bash

_CUR_DIR=$(dirname "$0")
source ${_CUR_DIR}/common.sh

# fot-instrument
echo -e "\n${green}[x] install fot-instrument utilities...${reset}"
cd ${BASEDIR}/fot-instrument
make
sudo make install
echo -e "[+] fot-instrument setup done!\n"
echo -e "[x] see how to use instrumentation with by using fot-clang for C project, and fot-clang++ for C++ project"
