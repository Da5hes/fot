#!/usr/bin/env bash

set -e

BASEDIR=$(dirname "$0")/setup

${BASEDIR}/0-deps.sh
${BASEDIR}/1-instrument.sh
${BASEDIR}/1-SVF.sh
${BASEDIR}/2-sem.sh
${BASEDIR}/3-fuzz.sh
#${BASEDIR}/4-ui.sh
