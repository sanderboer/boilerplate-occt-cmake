#!/bin/bash
BIN_DIR="$( cd -P "$( dirname "$0" )"&& pwd )"
. ${BIN_DIR}/init_vars.sh


pushd ${EMSDK_DIR}
./emsdk activate latest
source ./emsdk_env.sh
popd


