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
#   https://github.com/lordmikefin/LMAutoSetBotBSD/blob/master/init.sh


# init.sh
# This script will install minimal set of required apps.



unset CURRENT_SCRIPT_VER CURRENT_SCRIPT_DATE
CURRENT_SCRIPT_VER="0.0.5"
CURRENT_SCRIPT_DATE="2021-07-29"
echo "CURRENT_SCRIPT_VER: ${CURRENT_SCRIPT_VER} (${CURRENT_SCRIPT_DATE})"




CURRENT_SCRIPT_REALPATH=$(realpath ${BASH_SOURCE[0]})
CURRENT_SCRIPT_DIR=$(dirname ${CURRENT_SCRIPT_REALPATH})
CURRENT_SCRIPT=$(basename ${CURRENT_SCRIPT_REALPATH})
LM_TOYS_DIR=$(realpath "${CURRENT_SCRIPT_DIR}/submodule/LMToysBash")
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



# TODO: Should I check version of these apps?  *sigh*

echo ""
APP_GIT="git"
GIT_VERSION=$(lm_get_git_version)  || lm_failure
#GIT_VERSION=$(lm_get_app_version ${APP_GIT})  || lm_failure
#echo ${GIT_VERSION}
if [ -z "${GIT_VERSION}" ] ; then
	echo "'${APP_GIT}' is not installed !"
else
	echo "'${APP_GIT}' is installed."
fi


echo ""
APP_PY="python3"
PY_VERSION=$(lm_get_app_version ${APP_PY})  || lm_failure
#echo ${PY_VERSION}
if [ -z "${PY_VERSION}" ] ; then
	echo "'${APP_PY}' is not installed !"
else
	echo "'${APP_PY}' is installed."
fi


echo ""
APP_PIP="pip"
PIP_VERSION=$(lm_get_app_version ${APP_PIP})  || lm_failure
#echo "PIP_VERSION ${PIP_VERSION}"
if [ -z "${PIP_VERSION}" ] ; then
	echo "'${APP_PIP}' is not installed !"
else
	echo "'${APP_PIP}' is installed."
fi


echo ""
APP_JAVA="java"
#JAVA_VERSION=$(lm_get_app_version ${APP_JAVA})  || lm_failure
JAVA_VERSION=$(lm_get_java_version)  || lm_failure
#echo "JAVA_VERSION ${JAVA_VERSION}"
if [ "${JAVA_VERSION}" == "Failed" ] ; then
	echo "'${APP_JAVA}' is not installed !"
	JAVA_VERSION=""
else
	echo "'${APP_JAVA}' is installed."
	JAVA_VERSION="Java is installed"
fi


lm_incomplete_message () {
	>&2 echo ""
	>&2 echo "All applications suggested by this script should be installed"
    >&2 echo "before you continue to real script (Python)."
	>&2 echo ""
}


# install git
if [ -z "${GIT_VERSION}" ] ; then
	#echo "'${APP_GIT}' is not installed !"
	unset INPUT
	lm_read_to_INPUT "Do you want to install the 'git'?"
	case "${INPUT}" in
		"YES" )
			sudo pkg install git
			;;
		"NO" )
			echo "Ok then. Bye."
			lm_incomplete_message
			exit 1
			;;
		"FAILED" | * )
			lm_failure_message
			;;
	esac
fi

# install python 3
if [ -z "${PY_VERSION}" ] ; then
	#echo "'${APP_PY}' is not installed !"
	unset INPUT
	lm_read_to_INPUT "Do you want to install the 'python3'?"
	case "${INPUT}" in
		"YES" )
			sudo pkg install python3
			;;
		"NO" )
			echo "Ok then. Bye."
			lm_incomplete_message
			exit 1
			;;
		"FAILED" | * )
			lm_failure_message
			;;
	esac
fi

# install pip
if [ -z "${PIP_VERSION}" ] ; then
	unset INPUT
	lm_read_to_INPUT "Do you want to install the 'py37-pip'?"
	case "${INPUT}" in
		"YES" )
			sudo pkg install py37-pip
			;;
		"NO" )
			echo "Ok then. Bye."
			lm_incomplete_message
			exit 1
			;;
		"FAILED" | * )
			lm_failure_message
			;;
	esac
fi

# install Java 8
if [ -z "${JAVA_VERSION}" ] ; then
	unset INPUT
	lm_read_to_INPUT "Do you want to install the 'openjdk-8-jdk'?"
	case "${INPUT}" in
		"YES" )
			sudo pkg install openjdk8
			;;
		"NO" )
			echo "Ok then. Bye."
			lm_incomplete_message
			exit 1
			;;
		"FAILED" | * )
			lm_failure_message
			;;
	esac
fi


cd python

# Create Python virtual environment 'venv-LMAutoSetBotBSD'
echo "Run script  ./setup_python_venv.sh"
./setup_python_venv.sh


echo "End of script '${CURRENT_SCRIPT}'"

