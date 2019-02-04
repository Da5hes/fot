#!/usr/bin/env bash

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset=$(tput sgr0)

for f in *.res; do
    rg 'ThreadSanitizer' $f &>/dev/null
    if [[ $? -eq 0 ]]; then
        rg 'libomp|omp_outlined' $f &>/dev/null
        if [[ $? -ne 0 ]]; then
            echo "${red}Y${reset} $f"
        else
            # because of tsan FP
            echo "${yellow}N${reset} $f"
        fi
    else
        # not even has tsan issue
        echo "${yellow}N${reset} $f"
    fi
done
