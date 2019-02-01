#!/usr/bin/env bash

set -e

_CUR_DIR=$(dirname "$0")
source ${_CUR_DIR}/common.sh

export LLVM_DIR=/usr/lib/llvm

# SVF
fot_setup_header "SVF"
cd ${BASEDIR}/SVF
BUILDDIR=${BASEDIR}/SVF/BUILD_RELDBG
if ! [[ -d $BUILDDIR ]]; then
    mkdir $BUILDDIR
fi
cd $BUILDDIR
cmake -GNinja -DCMAKE_BUILD_TYPE=RelWithDebInfo ${BASEDIR}/SVF
ninja
sudo ninja install
cd ${BASEDIR}
fot_setup_footer "SVF"

# fot-instrument
fot_setup_header "fot-instrument"
cd ${BASEDIR}/fot-instrument
sudo make uninstall
make
sudo make install
cd ${BASEDIR}
fot_setup_footer "fot-instrument"

set +e
