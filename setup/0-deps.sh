#!/usr/bin/env bash

_CUR_DIR=$(dirname "$0")
source ${_CUR_DIR}/common.sh

set -e

# dependencies
echo -e "\n${green}[x] install general dependencies...${reset}"
sudo apt install -y cmake python-pip libspdlog-dev redis-tools redis-server liblzma-dev libhwloc-dev libc6-dev-i386 golang curl realpath
sudo pip install -U virtualenv

if hash task 2>/dev/null; then
    echo "golang 'task runner' (task) found"
else
    export GOPATH=$HOME/gocode
    echo "${red}PLEASE 'export GOPATH=$HOME/gocode' for permanent use${reset}"
    mkdir -p $GOPATH
    go get -u -v github.com/go-task/task/cmd/task
    export PATH=$GOPATH/bin:$PATH
    echo "${red} PLEASE 'export PATH=\$GOPATH/bin:$PATH' for permanent use${reset}"
fi

echo "${green}[x] install rust toolchain with rustup...${reset}"
if hash cargo 2>/dev/null; then
    echo "cargo path found, make sure you are using 'nightly' version!"
    if hash cargo-deb 2>/dev/null; then
        echo "cargo-deb found"
    else
        cargo install --force cargo-deb
    fi
else
    curl https://sh.rustup.rs -sSf -o /tmp/fot-rustup.sh
    sh /tmp/fot-rustup.sh --default-toolchain=nightly
    export PATH=$HOME/.cargo/bin:$PATH
    echo "${red}PLEASE export PATH=\"\$HOME/.cargo/bin:\$PATH\" for permanent use${reset}"
    cargo install --force cargo-deb
fi
echo -e "[+] general dependencies done\n"

