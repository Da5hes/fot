FOT [![Built with cargo-make](https://sagiegurari.github.io/cargo-make/assets/badges/cargo-make.svg)](https://sagiegurari.github.io/cargo-make)
====================

FOT is a Fuzzing Orchestration Toolkit that aims to provide a flexible and scalable fuzzing framework.
It is inspired by [AFL](http://lcamtuf.coredump.cx/afl/) but has many advantages for research purpose.

installation
====================

```
./install.sh
```

user interface
====================

### inputs

- fot-clang/fot-clang++ compiled executables or executables with fot-qemu environment
- Config.toml
- input folder
- dict folder (optional)

### outputs
- out/fuzzer0
- out/fuzzer1
- ...
- out/queue
- out/crash
- out/hangs
- ...


Case Study on [libpng](http://www.libpng.org/pub/png/libpng.html)
====================


# Code Instrumentation

    # configure libpng for compilation, CC should be fot-clang
    $ ./configure CC=fot-clang LDFLAGS="-static" --prefix=$PWD/install
    # compile (with all CPU cores)
    $ make -j
    # install to target directory (in our case, ./install)
    $ make install

# Fuzzing Engine

    # 1. prepare png file in input folder "in/"
    # 2. prepare Config.toml file

    # run fot-fuzz
    $ fot-fuzz ./pngfix @@

# User Interface

    $ python manage.py migrate
    $ python manage.py runserver 0.0.0.0:8000 --noreload
    $ python manage.py process_tasks
    # need to wait for a while when the charts are plotted
