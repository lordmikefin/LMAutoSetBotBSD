#!/usr/local/bin/bash

# Copyright (c) 2021, Mikko Niemelä a.k.a. Lord Mike (lordmike@iki.fi)
# 
# License of this script file:
#   MIT License
# 
# License is available online:
#   https://github.com/lordmikefin/LMAutoSetBotBSD/blob/master/LICENSE
# 
# Latest version of this script file:
#   https://github.com/lordmikefin/LMAutoSetBotBSD/blob/master/python/setup_python_venv.sh


# setup_python_venv.sh
# This script will setup Python virtual environment for my scripts :)



unset CURRENT_SCRIPT_VER CURRENT_SCRIPT_DATE
CURRENT_SCRIPT_VER="0.0.2"
CURRENT_SCRIPT_DATE="2021-07-29"
echo "CURRENT_SCRIPT_VER: ${CURRENT_SCRIPT_VER} (${CURRENT_SCRIPT_DATE})"




CURRENT_SCRIPT_REALPATH=$(realpath ${BASH_SOURCE[0]})
CURRENT_SCRIPT_DIR=$(dirname ${CURRENT_SCRIPT_REALPATH})
CURRENT_SCRIPT=$(basename ${CURRENT_SCRIPT_REALPATH})
LM_TOYS_DIR=$(realpath "${CURRENT_SCRIPT_DIR}/../submodule/LMToysBash")
#IMPORT_FUNCTIONS="$(realpath "${CURRENT_SCRIPT_DIR}/../../script/lm_functions.sh")"
IMPORT_FUNCTIONS=$(realpath "${LM_TOYS_DIR}/lm_functions.sh")
if [[ ! -f "${IMPORT_FUNCTIONS}" ]]; then
	>&2 echo "${BASH_SOURCE[0]}: line ${LINENO}: Source script '${IMPORT_FUNCTIONS}' missing!"
	exit 1
fi

source ${IMPORT_FUNCTIONS}

if [ ${LM_FUNCTIONS_LOADED} == false ]; then
	>&2 echo "${BASH_SOURCE[0]}: line ${LINENO}: Something went wrong while loading functions."
	exit 1
elif [ ${LM_FUNCTIONS_VER} != "1.3.6" ]; then
	lm_functions_incorrect_version
	if [ "${INPUT}" == "FAILED" ]; then
		lm_failure
	fi
fi



#echo -e "\n This script is in test mode :)  Aborting." >&2
#exit 1



echo ""
APP_PY="python3"
PY_VERSION=$(lm_get_app_version ${APP_PY})  || lm_failure
#echo ${PY_VERSION}
if [ -z "${PY_VERSION}" ] ; then
	echo "'${APP_PY}' is not installed !"
	echo -e "\n Run init.sh first.  Aborting." >&2
else
	echo "'${APP_PY}' is installed."
fi


echo ""
APP_PIP="pip"
PIP_VERSION=$(lm_get_app_version ${APP_PIP})  || lm_failure
if [ -z "${PIP_VERSION}" ] ; then
	echo "'${APP_PIP}' is not installed !"
	echo -e "\n Run init.sh first.  Aborting." >&2
else
	echo "'${APP_PIP}' is installed."
fi


# Make sure we are using the lates pip version.
echo ""
echo "Make sure we are using the lates pip version."
echo " $ ${APP_PIP} install --upgrade pip"
sudo ${APP_PIP} install --upgrade pip


# Installing root environment (Python) modules.
echo ""
echo "Installing root environment (Python) modules."
echo ""
echo " $ ${APP_PIP} install -U -r root_environment_requirements_bsd.txt"
sudo ${APP_PIP} install -U -r root_environment_requirements_bsd.txt  || lm_failure


# List of 'Root' environment modules
echo ""
echo "List of 'Root' environment modules"
# NOTE: Ubuntu is using extreme old 'pip' which does not have parameter 'format' :(
#echo " $ ${APP_PIP} list --format=columns"
#${APP_PIP} list --format=columns
echo " $ ${APP_PIP} list"
${APP_PIP} list  || lm_failure



echo -e "\n This script is in test mode :)  Aborting." >&2
exit 1

# Create the venv
VENV="venv-LMAutoSetBotBSD"
VENV_PATH="${HOME}/Envs"
func_create_venv () {
	echo "I will create a new virtual environment '${VENV}'"
	echo " $ virtualenv -p /usr/bin/python3 ${VENV_PATH}/${VENV}"
	echo ""
	# NOTE: virtualenv is not in path (Ubuntu-Mate 20)
	#  WARNING: The script virtualenv is installed in '/home/lordmike/.local/bin' which is not on PATH.
    #  Consider adding this directory to PATH
    # TODO: add folder into PATH
    # https://askubuntu.com/questions/60218/how-to-add-a-directory-to-the-path
    # https://help.ubuntu.com/community/EnvironmentVariables
    # $ nano ~/.profile
    # $ export PATH="$HOME/.local/bin:$PATH"
    export PATH="$HOME/.local/bin:$PATH"
	virtualenv -p /usr/bin/python3 ${VENV_PATH}/${VENV}  || lm_failure
}

# I will try to use virtual environment 'venv-LMAutoSetBotUbM'.
echo ""
echo "I will try to use virtual environment '${VENV}'."
echo "All my python scripts will use this environment."
echo " $ source ${VENV_PATH}/${VENV}/bin/activate"
source ${VENV_PATH}/${VENV}/bin/activate  && {
	echo ""
	echo "Virtual environment '${VENV}' already exists."
	echo "Now workon  ${VENV}"
	echo ""
} || {
	echo ""
	echo "Virtual environment '${VENV}' not found."
	echo "Next I will create the venv."
	echo ""
	lm_pause
	func_create_venv
	source ${VENV_PATH}/${VENV}/bin/activate  || lm_failure
}



echo ""
echo "Current virtual environment:"
echo "  ${VIRTUAL_ENV}"
echo ""


# Make sure we are using the lates pip version.
echo ""
echo "Make sure we are using the lates pip version."
echo " (venv) $ ${APP_PIP} install --upgrade pip"
${APP_PIP} install --upgrade pip  || lm_failure


echo ""
echo "(venv) $ ${APP_PIP} list --format=columns"
echo ""
${APP_PIP} list --format=columns  || lm_failure


# TODO: add submodules
#echo ""
#echo "Install all needed Python modules into venv."
#echo "(venv) $ ${APP_PIP} install -U -r setup_apps/requirements.txt"
#echo "(venv) $ ${APP_PIP} install -U -r app_source_handler/requirements.txt"
#echo "(venv) $ ${APP_PIP} install -U -r LMToyBoxPython/requirements.txt"
#echo ""
#${APP_PIP} install -U -r setup_apps/requirements.txt  || lm_failure
#${APP_PIP} install -U -r app_source_handler/requirements.txt  || lm_failure
#${APP_PIP} install -U -r LMToyBoxPython/requirements.txt  || lm_failure


echo ""
echo "List all outdated modules."
echo "(venv) $ ${APP_PIP} list -o --format=columns"
echo ""
${APP_PIP} list -o --format=columns



echo "End of script '${CURRENT_SCRIPT}'"


