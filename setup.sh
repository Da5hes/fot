#!/usr/bin/env bash

set -ex

# dependencies
echo "[x] install general dependencies..."
sudo apt install -y cmake python-pip libspdlog-dev redis-tools redis-server liblzma-dev libhwloc-dev libc6-dev-i386 golang curl realpath
go get -u -v github.com/go-task/task/cmd/task
cargo install --force cargo-deb
sudo pip install -U virtualenv

BASEDIR=$(realpath $(dirname "$0"))

echo "[x] install rust toolchain with rustup..."
curl https://sh.rustup.rs -sSf -o /tmp/fot-rustup.sh
sh /tmp/fot-rustup.sh --default-toolchain=nightly
echo "export PATH=\"$HOME/.cargo/bin:$PATH\"" >> $HOME/.bashrc
echo -e "[+] general dependencies done\n"


# fot-instrument
echo "[x] install fot-instrument utilities..."
cd ${BASEDIR}/fot-instrument
make
sudo make install
echo -e "[+] fot-instrument done!\n"

# fot-fuzz
echo "[x] install fot-fuzz utilities..."
cd ${BASEDIR}/fot-fuzz
task install
echo -e "[+] fot-fuzz done!\n"

# fot-ui
echo "[x] set up fot-ui..."
cd ${BASEDIR}/fot-ui
if ! [ -d env ]; then
  virtualenv env
  . env/bin/activate
  pip install -r requirements.txt
fi
cd ${BASEDIR}/fot-ui/fuzzer_ui
python manage.py migrate
echo -e "[+] fot-ui set up!\n"


echo "[+] Now you should be able to use FOT"
echo -e "[x] see how to use instrumentation with by using fot-clang for C project, and fot-clang++ for C++ project"
echo -e "[x] see how to use runtime fuzzing by 'fot-fuzz --help'"
echo -e "[x] fot-ui is run by\n\
        # web service\n\
        $ python manage.py runserver 0.0.0.0:8000 --no-reload\n\
        # background task\n\
        $ python manage.py process_tasks\n\
"
