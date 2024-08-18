#!/bin/bash
BIN_DIR="$( cd -P "$( dirname "$0" )"&& pwd )"
. ${BIN_DIR}/init_vars.sh
    
export EMCC_FLAGS="-s USE_FREETYPE=1"
export CMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} ${EMCC_FLAGS}"
export CMAKE_C_FLAGS="${CMAKE_C_FLAGS} ${EMCC_FLAGS}"
export CMAKE_EXE_LINKER_FLAGS="${CMAKE_EXE_LINKER_FLAGS} ${EMCC_FLAGS}"


mkdir -p ${FREETYPE_BUILD_DIR}/
pushd ${FREETYPE_BUILD_DIR}/

cmake -DCMAKE_TOOLCHAIN_FILE=${EMSDK_TOOLCHAIN_FILE} \
  -DCMAKE_INSTALL_PREFIX=${DEPS_INSTALL_DIR} \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  ${FREETYPE_SRC_DIR}

cmake --build . --target install -j ${COMPILE_CORES}
popd

