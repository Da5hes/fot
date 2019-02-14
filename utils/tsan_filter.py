#!/usr/bin/env python3

import os
import sys
import subprocess
import shutil

def touch(fname, times=None):
    with open(fname, 'a'):
        os.utime(fname, times)


if len(sys.argv) < 2:
    print("usage: {} pattern [-no-omp]".format(sys.argv[0]), file=sys.stderr)
    sys.exit(1)

if not os.path.isfile(sys.argv[1]):
    touch(sys.argv[1])

with open(sys.argv[1], 'r') as pat_file:
    pat_lines = pat_file.read().splitlines()
pat_lines = list(filter(None, pat_lines))

if len(sys.argv) == 3 and sys.argv[2] == "-no-omp":
    libomp_relevant=['libomp', 'omp_outlined']
else:
    libomp_relevant=[]
pat_lines.extend(libomp_relevant)
pat_strs = "|".join(pat_lines)
print("=" * 80 + "\n" + pat_strs + "\n" + "=" * 80)

FNULL = open(os.devnull, 'w')

for root, dirs, files in os.walk('.'):
    files.sort()
    for f in files:
        if not f.endswith(".res"):
            continue
        fname = os.path.join(root, f)
        cmd_match_tsan = "rg -a -l {} {}".format("ThreadSanitizer", fname)
        # print(cmd_match_tsan)
        rc_match_tsan = subprocess.call(cmd_match_tsan.split(), stdout=FNULL, stderr=FNULL)
        if rc_match_tsan != 0:
            print("NO TSAN report; removing... {}".format(fname))
            os.remove(fname)
        else:
            cmd_str = "rg -a -l {} {}".format(pat_strs, fname)
            rc = subprocess.call(cmd_str.split(), stdout=FNULL, stderr=FNULL)
            if rc != 0:
                print("NEW: {}".format(fname))
            # else:
            #     print("OLD: {}".format(fname))
