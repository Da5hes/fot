#!/usr/bin/env bash

_CUR_DIR=$(dirname "$0")
source ${_CUR_DIR}/common.sh

set -e

echo -e "\n${green}[x] set up fot-sem...${reset}"
cd ${BASEDIR}/fot-sem
task install
export export PATH=/usr/local/lib/fot/bin:$PATH
if hash fot-sem &>/dev/null; then
    echo "[+] fot-sem set up done!"
else
    echo "${red}[-] fot-sem NOT installed${reset}"
    exit 1
fi

echo -e "\n**********************************************************************"
echo -e "${red}PLEASE 'export PATH=/usr/local/lib/fot/bin:\$PATH' for permanent uses${reset}"
echo -e "**********************************************************************"
