#!/usr/bin/env bash

a=1
for i in $(ls * | sort -R); do
  new=$(printf "%03d.in" "$a")
  mv -- "$i" "$new"
  let a=a+1
done
