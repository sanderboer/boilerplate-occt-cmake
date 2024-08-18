#!/bin/bash

BIN_DIR="$( cd -P "$( dirname "$0" )"&& pwd )"
SRC_DIR="$( cd -P "$( dirname "$0" )"&& cd src && pwd )"
ROOT_DIR="$( cd -P "$( dirname "$0" )"&& pwd )"
DIST_DIR=${ROOT_DIR}/dist
DEPS_SRC_DIR=${ROOT_DIR}/deps_src
BUILD_DEPS_DIR=${ROOT_DIR}/build_deps
DEPS_INSTALL_DIR=${ROOT_DIR}/deps
OCCT_SRC_DIR=${BUILD_DEPS_DIR}/occt_src
OCCT_BUILD_DIR=${BUILD_DEPS_DIR}/occt_build
FREETYPE_SRC_DIR=${BUILD_DEPS_DIR}/freetype_src
FREETYPE_BUILD_DIR=${BUILD_DEPS_DIR}/freetype_build
EMSDK_DIR=${DEPS_INSTALL_DIR}/emsdk
EMSDK_TOOLCHAIN_FILE=${EMSDK_DIR}/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake



TOTAL_CORES=$(nproc)
COMPILE_CORES=$((TOTAL_CORES - 1))


echo "Building with Emscripten..."
echo "================================================================================="
echo "DIST_DIR                          : $DIST_DIR"
echo "EMSDK_DIR                         : $EMSDK_DIR"
echo "EMSDK_TOOLCHAIN_FILE              : $EMSDK_TOOLCHAIN_FILE"
echo "OCCT_INSTALL_DIR                  : $DEPS_INSTALL_DIR"
echo "================================================================================="

# Set the build directory name
BUILD_DIR="build"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
echo "Creating build directory '$BUILD_DIR'."

# Change to the build directory
pushd "$BUILD_DIR"

# Run CMake
echo "Running CMake..."
cmake \
  -DCMAKE_TOOLCHAIN_FILE:FILEPATH=${EMSDK_TOOLCHAIN_FILE} \
  -DOCCT_INSTALL_DIR:PATH=${DEPS_INSTALL_DIR} \
  -DDIST_DIR:PATH=${DIST_DIR} \
  ..

# Build the project
echo "Building the project..."
cmake --build . --target install -j ${COMPILE_CORES}

# Check if the build was successful
if [ $? -eq 0 ]; then
  echo "Build successful."
else
  echo "Build failed."
fi

popd
