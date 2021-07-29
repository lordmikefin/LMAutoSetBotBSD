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
CURRENT_SCRIPT_VER="0.0.1"
CURRENT_SCRIPT_DATE="2021-07-28"
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



echo "End of script '${CURRENT_SCRIPT}'"

