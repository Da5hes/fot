#!/usr/bin/env bash

BASEDIR=$(dirname "$0")/setup

${BASEDIR}/0-deps.sh
${BASEDIR}/1-instrument.sh
${BASEDIR}/2-fuzz.sh
${BASEDIR}/3-sem.sh
${BASEDIR}/4-ui.sh
