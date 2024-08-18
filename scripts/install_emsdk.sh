#!/bin/bash
BIN_DIR="$( cd -P "$( dirname "$0" )"&& pwd )"
. ${BIN_DIR}/init_vars.sh

mkdir -p ${DEPS_INSTALL_DIR}/

pushd ${DEPS_INSTALL_DIR}/
git clone https://github.com/emscripten-core/emsdk.git emsdk
pushd emsdk
./emsdk install latest
./emsdk activate latest
emcc -s USE_FREETYPE=1 $(mktemp)
popd
popd

