# Get MJS source code

```
mkdir -p exp && cd exp
export BASE_DIR=$PWD
mkdir -p info1
export SRC_DIR=$BASE_DIR/mjs
export INFO_DIR=$BASE_DIR/info1
git clone git@github.com:cesanta/mjs.git
cd $SRC_DIR && git checkout d6c06a61743d6748ac167adb75da3d81d5d62070
```

# Prepare configuration file "llvm.toml" and target site file "tgt_lines.in"
## llvm.toml
```
[tgt]
infile = "tgt_lines.in"
out_dir = "."
[ins]
ratio = 100
proj_name = "mjs1"
dist_file = "bb.dist"
```

# tgt_lines.in (please change to the ACTUAL absolute path)
```
/home/hongxu/FOT/fot-all/exp/mjs/mjs.c:8413
/home/hongxu/FOT/fot-all/exp/mjs/mjs.c:9369
/home/hongxu/FOT/fot-all/exp/mjs/mjs.c:11843
```
NOTE: The targets are supposed to be no more than 5 lines. Otherwise, the effect may not be significant. If there are indeed many targets, it is suggested to 1) categorize or combine the targets manually 2) configure with different fuzzing targets multiple times.

# Preprocessing with fot-pp
```
# using *gllvm*
export FOT_USE_GLLVM=1
cd $INFO_DIR
# wrapper for generation of whole program LLVM bitcode
fot-pp -DMJS_MAIN -fsanitize=address $SRC_DIR/mjs.c -ldl -O0 -o mjs.out
# get the actual LLVM bitcode
get-bc mjs.out
# at this moment there will be a `mjs.out.bc` file
# the normal compile command is:
# clang -DMJS_MAIN -fsanitize=address $SRC_DIR/mjs.c -ldl -O0 -o mjs.out
```
NOTE: we are now using [gllvm](https://github.com/SRI-CSL/gllvm) instead of [Gold Linker](https://en.wikipedia.org/wiki/Gold_(linker)) for whole program LLVM bitcode generation.

# Analyze the bitcode with fot-analyze
```
cd $INFO_DIR
fot-analyze -fot-conf $INFO_DIR/llvm.toml $INFO_DIR/mjs.out.bc
```
And the newly generated files are:
```
bb_calls.txt
callgraph.yaml
cfg/ # directory include CFG files
funcs.txt
tgt_bbs.txt
tgt_funcs.txt
```
NOTE: we are no longer using [opt](http://llvm.org/docs/CommandGuide/opt.html) from LLVM.

# Generate distances
```
# fot-dists renamed to fot-tgtd
fot-tgtd -c $INFO_DIR/llvm.toml -b $INFO_DIR/mjs.out.bc -i $INFO_DIR
```
Newly generated files:
```
funcs.dist
bbs.dist
```

# Compile & Instrument
```
fot-clang -fot-conf=$INFO_DIR/llvm.toml -DMJS_MAIN -fsanitize=address $SRC_DIR/mjs.c -ldl -O0 -g -o $INFO_DIR/mjs.out
```
This will create a FOT instrumented binary `mjs.out` inside `$INFO_DIR`. You can inspect this with
```
fot-inspect $INFO_DIR/mjs.out
```
The expected output is something like:
```
/home/hongxu/FOT/fot-all/exp/info1/mjs.out: ELF
has_debug:  true
has_asan:  true
has_msan:  false
has_tsan:  false
has_ubsan:  false
is_64: true
is_lib: false
soname: None
libs: ["libdl.so.2", "libpthread.so.0", "librt.so.1", "libm.so.6", "libgcc_s.so.1", "libc.so.6"]
little endian: true
container: Big, endianness: Little
extra: FOT
```
NOTE that the last line *has to be* "extra: FOT" otherwise it is a failed instrumentation.

# Map function traces
```
cd $INFO_DIR
# mjs1 is specified by "ins.proj_name" inside "llvm.toml", "proj_trace_funcs.json" will be generated
fot-funcs extract -p mjs1
fot-funcs score -d funcs.dist -m funcs.txt -p proj_trace_funcs.json -o trace_funcs.json
```

# Specify fuzzing configurations
```
[io]
in_folder = "in"
out_folder = "out"

[exec]
use_forkserver = true
mem_limit = 200
timeout = 50
qemu_mode = false

[exec.sa]
trace_func_file = "trace_funcs.json"
callgraph_file = "callgraph.yaml"
tgt_func_file = "tgt_funcs.txt"

[record]
proj_name = "mjs1"
interval = 2000
url = "redis://127.0.0.1/"
log_entry_info = false

[calibration]
# for simple regular case calibration
normal_cycles = 7
# for variable behaviors calibration
var_behavior_cycles = 37

[minimize]
ck_redundant_file = false

[mutation]
# ops = ["det", "dict", "havoc", "splice"]
ops = ["havoc", "splice"]
max_file_length = 65536
#dict_folder = "dicts_test"
dict_level = 0
# max_token_length: 64
# min_token_length: 2
# max_dict_size: 256
# in minutes
havoc_adjust_duration = 12

[fz]
workers = 1
bind_cpu = false
# "normal"/"crash"
keep_mode = "normal"
# "simple"/...
scorer = "simple"
exit_nonzero_as_crash = false
ignored_signals = []

[fz.conductor]
# in minutes
report_duration = 3

[fz.sync]
duration = 200
execs = 5
```

# Run the fuzzer
```
cd $INFO_DIR
mkdir in
cp $SRC_DIR/mjs/tests/*.js in/
fot-fuzz -c ./Config.toml -- $INFO_DIR/mjs.out @@
# regular command to run `mjs.out` is like:
./mjs.out in/err1.js
```
