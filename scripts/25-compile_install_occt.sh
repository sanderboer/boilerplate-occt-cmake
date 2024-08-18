#!/bin/bash
BIN_DIR="$( cd -P "$( dirname "$0" )"&& pwd )"
. ${BIN_DIR}/init_vars.sh
    
export OCCT_GIT=https://github.com/Open-Cascade-SAS/OCCT.git
export OCCT_TAG=V7_8_1
export EMCC_FLAGS="-s USE_FREETYPE=1"
export CMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} ${EMCC_FLAGS}"
export CMAKE_C_FLAGS="${CMAKE_C_FLAGS} ${EMCC_FLAGS}"
export CMAKE_EXE_LINKER_FLAGS="${CMAKE_EXE_LINKER_FLAGS} ${EMCC_FLAGS}"

rm -rf ${OCCT_BUILD_DIR}
mkdir -p ${OCCT_BUILD_DIR}

pushd ${OCCT_BUILD_DIR}
cmake \
  -DCMAKE_TOOLCHAIN_FILE=${EMSDK_TOOLCHAIN_FILE} \
  -DBUILD_LIBRARY_TYPE=Static \
  -DBUILD_MODULE_ApplicationFramework=ON \
  -DBUILD_MODULE_DETools=OFF \
  -DBUILD_MODULE_DataExchange=ON \
  -DBUILD_MODULE_Draw=OFF \
  -DBUILD_MODULE_FoundationClasses=ON \
  -DBUILD_MODULE_ModelingAlgorithms=ON \
  -DBUILD_MODULE_ModelingData=ON \
  -DBUILD_MODULE_Visualization=ON \
  -DBUILD_DOC_Overview=OFF \
  -DBUILD_SAMPLES_QT=OFF \
  -D3RDPARTY_FREETYPE_INCLUDE_DIR_ft2build=${DEPS_INSTALL_DIR}/include/freetype2 \
  -D3RDPARTY_FREETYPE_INCLUDE_DIR_freetype2=${DEPS_INSTALL_DIR}/include/freetype2/freetype \
  ${OCCT_SRC_DIR}

cmake --build . --target install -j ${COMPILE_CORES}
popd

