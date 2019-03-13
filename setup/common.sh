#!/usr/bin/env bash

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset=`tput sgr0`

LLVM_VER=7

if [[ -z ${LLVM_VER} ]]; then
    export LLVM_DIR=/usr/lib/llvm
else
    export LLVM_DIR=/usr/lib/llvm-${LLVM_VER}
fi

if [[ ! -d ${LLVM_DIR} ]]; then
    echo "${red}LLVM_DIR=${LLVM_DIR} NOT exists${reset}"
fi

BASEDIR=$(realpath $(dirname "$0")/..)

function fot_setup_header() {
    echo -e "\n${green}[+] setup $1...${reset}"
}

function fot_setup_footer() {
    echo -e "${green}[+] setup for $1 done${reset}"
}

function fot_setup_alert() {
    echo -e "${yellow}\n======================================================================${reset}"
    echo -e "${red}$1${reset}"
    echo -e "${yellow}======================================================================${reset}"
}

function fot_setup_ensure_exec() {
    if hash $1 &>/dev/null; then
        echo -e "command '${yellow}$1${reset}' found${reset}"
    else
        echo -e "${red}$1 not found${reset}"
        exit 1
    fi
}
