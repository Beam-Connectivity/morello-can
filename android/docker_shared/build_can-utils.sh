#!/bin/bash

# Set path
export PATH="${HOME}/morello_workspace/android/prebuilts/clang/host/linux-x86/clang-morello/bin:$PATH"

# Set toolchain file if not set
MORELLO_TOOLCHAIN_FILE="${MORELLO_TOOLCHAIN_FILE:-/root/morello_workspace/toolchain.morello.cmake}"

# Get source
git clone https://github.com/linux-can/can-utils.git
cd can-utils/
git checkout v2021.08.0

# Cmake build dir
mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=$MORELLO_TOOLCHAIN_FILE -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=/root/docker_shared ..

# Build and install
make
make install
