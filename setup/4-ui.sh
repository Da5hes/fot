#!/usr/bin/env bash

_CUR_DIR=$(dirname "$0")
source ${_CUR_DIR}/common.sh

set -e

# fot-ui
fot_setup_header "fot-ui"
cd ${BASEDIR}/fot-ui
if ! [ -d env ]; then
  virtualenv env
  . env/bin/activate
  pip install -r requirements.txt
fi
cd ${BASEDIR}/fot-ui/fuzzer_ui
python manage.py migrate
fot_setup_footer "fot-ui"
fot_setup_alert "${yellow}fot-ui is started by the following commands\n\
# set virtual environment\n\
$ source ../env/bin/activate\n\
# web service\n\
$ python manage.py runserver 0.0.0.0:8000 --no-reload\n\
# background task\n\
$ python manage.py process_tasks\n\
"
