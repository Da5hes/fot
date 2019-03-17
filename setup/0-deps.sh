#!/usr/bin/env bash

_CUR_DIR=$(dirname "$0")
source ${_CUR_DIR}/common.sh

set -e

os=$(lsb_release -r -s)
if [[ $os != "18.04" ]] || [[ $os != "16.04" ]]; then
    echo "unsupported OS version: $os"
fi

LLVMVER=7

fot_setup_header "dependencies"
fot_setup_header "OS-level dependencies"

if [[ $os == "16.04" ]]; then
    sudo add-apt-repository ppa:longsleep/golang-backports -y
fi

sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update
sudo apt-get install -y cmake \
                        python-pip \
                        libspdlog-dev \
                        redis-tools \
                        redis-server \
                        liblzma-dev \
                        libhwloc-dev \
                        libc6-dev-i386 \
			            libssl-dev \
                        curl \
                        realpath \
                        scons \
                        git \
                        clang-${LLVMVER} \
                        oracle-java8-installer

if [[ $os == "16.04" ]]; then
    sudo apt-get install -y software-properties-common python-software-properties
fi

sudo ln -sf /usr/lib/jvm/java-8-oracle/jre/lib/amd64/server/libjvm.so /usr/lib/libjvm.so 
sudo ln -sf /usr/bin/clang-${LLVMVER} /usr/bin/clang
sudo ln -sf /usr/bin/clang++-${LLVMVER} /usr/bin/clang++

sudo apt-get install -y golang-go
fot_setup_ensure_exec "go"
fot_setup_footer "OS-level dependencies"

# go
fot_setup_header "golang dependencies"
if [[ ! -z "$GOPATH" ]]; then
    fot_setup_alert "PLEASE 'export GOPATH=\$HOME/gocode' and make sure \$GOPATH/bin is in \$PATH"
    exit 1
fi
# go task
if ! hash task 2>/dev/null; then
    mkdir -p $GOPATH
    go get -u -v github.com/go-task/task/cmd/task
    fot_setup_ensure_exec "task"
    fot_setup_alert "PLEASE 'export PATH=\$GOPATH/bin:\$PATH' for permanent uses"
fi
fot_setup_ensure_exec "task"
# gllvm
if ! hash gclang 2>/dev/null; then
    mkdir -p $GOPATH
    go get -u -v github.com/SRI-CSL/gllvm/cmd/...
    fot_setup_ensure_exec "gclang"
    fot_setup_ensure_exec "gclang++"
fi
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
    sh /tmp/fot-rustup.sh -y --default-toolchain=nightly
    export PATH=$HOME/.cargo/bin:$PATH
    fot_setup_alert "PLEASE export PATH=\"\$HOME/.cargo/bin:\$PATH\" for permanent uses"
    cargo install --force cargo-deb
fi

fot_setup_ensure_exec "cargo"
fot_setup_ensure_exec "cargo-deb"
fot_setup_footer "rust-toolchain (rustup)"

fot_setup_footer "dependencies"
