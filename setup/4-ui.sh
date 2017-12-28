#!/usr/bin/env bash

_CUR_DIR=$(dirname "$0")
source ${_CUR_DIR}/common.sh

set -e

# fot-ui
echo -e "\n${green}[x] set up fot-ui...${reset}"
cd ${BASEDIR}/fot-ui
if ! [ -d env ]; then
  virtualenv env
  . env/bin/activate
  pip install -r requirements.txt
fi
cd ${BASEDIR}/fot-ui/fuzzer_ui
python manage.py migrate
echo -e "[+] fot-ui setup done!\n"
echo -e "${green}[x] fot-ui is started by the following commands${reset}"
echo -e "# set virtual environment\n\
$ source ../env/bin/activate\n\
# web service\n\
$ python manage.py runserver 0.0.0.0:8000 --no-reload\n\
# background task\n\
$ python manage.py process_tasks\n\
"
