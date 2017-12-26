#!/usr/bin/env bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

set -ex

# dependencies
echo "${green}[x] install general dependencies...${reset}"
sudo apt install -y cmake python-pip libspdlog-dev redis-tools redis-server liblzma-dev libhwloc-dev libc6-dev-i386 golang curl realpath
sudo pip install -U virtualenv

if hash task 2>/dev/null; then
    echo "golang 'task runner' (task) found"
else
    export GOPATH=$HOME/gocode
    echo "${red}PLEASE 'export GOPATH=$HOME/gocode' for permanent use${reset}"
    mkdir -p $GOPATH
    go get -u -v github.com/go-task/task/cmd/task
    export PATH=$GOPATH/bin:$PATH
    echo "${red} PLEASE 'export PATH=$GOPATH/bin:$PATH' for permanent use${reset}"
fi
BASEDIR=$(realpath $(dirname "$0"))

echo "${green}[x] install rust toolchain with rustup...${reset}"
if hash cargo 2>/dev/null; then
    echo "cargo path found, make sure you are using 'nightly' version!"
    if hash cargo-deb 2>/dev/null; then
        echo "cargo-deb found"
    else
        cargo install --force cargo-deb
    fi
else
    curl https://sh.rustup.rs -sSf -o /tmp/fot-rustup.sh
    sh /tmp/fot-rustup.sh --default-toolchain=nightly
    export PATH=$HOME/.cargo/bin:$PATH
    echo "${red}PLEASE export PATH=\"$HOME/.cargo/bin:$PATH\" for permanent use${reset}"
    cargo install --force cargo-deb
fi
echo -e "[+] general dependencies done\n"


# fot-instrument
echo "${green}[x] install fot-instrument utilities...${reset}"
cd ${BASEDIR}/fot-instrument
make
sudo make install
echo -e "[+] fot-instrument done!\n"

# fot-fuzz
echo "${green}[x] install fot-fuzz utilities...${reset}"
cd ${BASEDIR}/fot-fuzz
task install
echo -e "[+] fot-fuzz done!\n"

# fot-ui
echo "${green}[x] set up fot-ui...${reset}"
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
