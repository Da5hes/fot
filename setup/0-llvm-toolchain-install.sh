#!/usr/bin/env bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

PRIORITY=10

if [ "$#" -lt 1 ]; then
    echo "usage: $0 LLVMVER [PRIORITY]"
    exit 1
elif [ "$#" -eq 1 ]; then
    echo "Default priority: $PRORITY"
else
    echo "Setting prority: $PRORITY"
    PRIORITY=$2
fi

VER=$1
echo "LLVM Version=$VER ..."
LLVM_LIB_DIR=/usr/lib/llvm

rm -f /usr/bin/llvm-config
rm -f /usr/bin/llvm-link
rm -f /usr/bin/clang
rm -f /usr/bin/clang++

if [[ -L  $LLVM_LIB_DIR ]]; then
    rm /usr/lib/llvm
elif [[ -e $LLVM_LIB_DIR ]]; then
    echo "ERROR: $LLVM_LIB_DIR exists, however not a symlink"
    exit 1
fi

update-alternatives --install /usr/bin/clang clang /usr/bin/clang-$VER $PRIORITY
update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-$VER $PRIORITY
update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-$VER $PRIORITY
update-alternatives --install /usr/bin/llvm-link llvm-link /usr/bin/llvm-link-$VER $PRIORITY
update-alternatives --install /usr/bin/llvm-symbolizer llvm-symbolizer /usr/bin/llvm-symbolizer-$VER $PRIORITY
ln -sf $LLVM_LIB_DIR-$VER $LLVM_LIB_DIR

set +e
