#!/usr/bin/env bash

set -e

_CUR_DIR=$(dirname "$0")
source ${_CUR_DIR}/common.sh

# SVF
fot_setup_header "SVF"
cd ${BASEDIR}/SVF
BUILDDIR=${BASEDIR}/SVF/BUILD_RELDBG
if ! [[ -d $BUILDDIR ]]; then
    mkdir $BUILDDIR
fi
cd $BUILDDIR
cmake -GNinja -DSVF_BUILD_PIC_LIBS=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo ${BASEDIR}/SVF
ninja
sudo ninja install
cd ${BASEDIR}
fot_setup_footer "SVF"

set +e
