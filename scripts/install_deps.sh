#!/bin/bash
BIN_DIR="$( cd -P "$( dirname "$0" )"&& pwd )"
. ${BIN_DIR}/init_vars.sh
    
${BIN_DIR}/10-get_freetype.sh
${BIN_DIR}/15-compile_install_freetype.sh
${BIN_DIR}/20-get_occt.sh
${BIN_DIR}/25-compile_install_occt.sh
