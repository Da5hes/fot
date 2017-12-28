#!/usr/bin/env bash

_CUR_DIR=$(dirname "$0")
source ${_CUR_DIR}/common.sh

set -e

fot_setup_header "dependencies"
fot_setup_header "OS-level dependencies"
sudo apt install -y cmake python-pip libspdlog-dev redis-tools redis-server liblzma-dev libhwloc-dev libc6-dev-i386 golang curl realpath
sudo pip install -U virtualenv
fot_setup_ensure_exec "go"
fot_setup_footer "OS-level dependencies"

# go
fot_setup_header "golang dependencies"
if ! hash task 2>/dev/null; then
    export GOPATH=$HOME/gocode
    fot_setup_alert "PLEASE 'export GOPATH=$HOME/gocode' for permanent uses"
    mkdir -p $GOPATH
    go get -u -v github.com/go-task/task/cmd/task
    fot_setup_ensure_exec "task"
    export PATH=$GOPATH/bin:$PATH
    fot_setup_alert "PLEASE 'export PATH=\$GOPATH/bin:$PATH' for permanent uses"
fi
fot_setup_ensure_exec "task"
fot_setup_footer "golang dependencies"

# rust
fot_setup_header "rust-toolchain (rustup)"
if hash cargo 2>/dev/null; then
    fot_setup_alert "'cargo' found, make sure you are using 'nightly' rust toolchain!"
    if ! hash cargo-deb 2>/dev/null; then
        cargo install --force cargo-deb
    fi
else
    curl https://sh.rustup.rs -sSf -o /tmp/fot-rustup.sh
    sh /tmp/fot-rustup.sh --default-toolchain=nightly
    export PATH=$HOME/.cargo/bin:$PATH
    echo "${red}PLEASE export PATH=\"\$HOME/.cargo/bin:\$PATH\" for permanent use${reset}"
    cargo install --force cargo-deb
fi

fot_setup_ensure_exec "cargo"
fot_setup_ensure_exec "cargo-deb"
fot_setup_footer "rust-toolchain (rustup)"

fot_setup_footer "dependencies"
