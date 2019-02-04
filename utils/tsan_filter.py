#!/usr/bin/env python3

import os
import sys
import subprocess
import shutil

if len(sys.argv) < 2:
    print("usage: {} pattern".format(sys.argv[0]), file=sys.stderr)
    sys.exit(1)

with open(sys.argv[1], 'r') as pat_file:
    pat_lines = pat_file.read().splitlines()
pat_lines = list(filter(None, pat_lines))
pat_lines.extend(['libomp', 'omp_outlined'])
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
