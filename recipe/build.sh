#!/bin/bash

set -e

export CFLAGS="-I$PREFIX/include -O3 -DNDEBUG -ffast-math -march=native"
export LDFLAGS="-L$PREFIX/lib"

# Fix for missing liblzma
perl -pi -e "s#(/[^\s]*?lib)/lib([^\s]+).la#-L\$1 -l\$2#g" ${PREFIX}/lib/*.la

if [ "$(uname)" = "Darwin" ]; then
    EXT='.dylib'
else
    EXT='.so'
fi

mkdir -p build
cd build
cmake .. -DTIFF_LIBRARY_RELEASE="${PREFIX}/lib/libtiff${EXT}"

make -j${CPU_COUNT}

BIN_DIR=${PREFIX}/plugins/stereo/elas/bin
mkdir -p ${BIN_DIR}
/bin/cp -fv elas ${BIN_DIR}/elas
