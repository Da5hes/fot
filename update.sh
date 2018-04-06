#!/usr/bin/env bash

set -x

git submodule update --remote
cd fot-fuzz && git checkout master && git pull && cd ..
cd fot-instrument && git checkout master && git pull && cd ..
cd fot-sem && git checkout master && git pull && cd ..
