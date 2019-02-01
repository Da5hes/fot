#!/usr/bin/env bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

VER=$1
echo "LLVM Version=$VER ..."
LLVM_LIB_DIR=/usr/lib/llvm


if [[ -L  $LLVM_LIB_DIR ]]; then
    rm /usr/lib/llvm
elif [[ -e $LLVM_LIB_DIR ]]; then
    echo "ERROR: $LLVM_LIB_DIR exists, however not a symlink"
    exit 1
fi

update-alternatives --set clang /usr/bin/clang-$VER
update-alternatives --set clang++ /usr/bin/clang++-$VER
update-alternatives --set llvm-config /usr/bin/llvm-config-$VER
update-alternatives --set llvm-link /usr/bin/llvm-link-$VER
update-alternatives --set llvm-symbolizer /usr/bin/llvm-symbolizer-$VER
ln -sf $LLVM_LIB_DIR-$VER $LLVM_LIB_DIR

set +e
