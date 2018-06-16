#!/usr/bin/env bash

set -e

BASEDIR=$(dirname "$0")/setup
os=$(lsb_release -r -s)

${BASEDIR}/0-deps-${os}.sh
${BASEDIR}/1-instrument.sh
${BASEDIR}/2-sem.sh
${BASEDIR}/3-fuzz.sh
#${BASEDIR}/4-ui.sh
