#!/usr/bin/env bash

set -e

export GOROOT=/usr/local/lib/go
export PATH=/usr/local/lib/go/bin:$PATH
export GOPATH=${HOME}/gocode
export PATH=${GOPATH}/bin:${PATH}
export PATH=${HOME}/.cargo/bin:${PATH}


BASEDIR=$(dirname "$0")/setup

${BASEDIR}/0-deps.sh
${BASEDIR}/1-instrument.sh
${BASEDIR}/2-sem.sh
${BASEDIR}/3-fuzz.sh
${BASEDIR}/4-ui.sh
