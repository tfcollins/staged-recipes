#!/usr/bin/env bash

set -ex

mkdir build
cd build

# enable components explicitly so we get build error when unsatisfied
#  WITH_LOCAL_CONFIG requires libini
#  WITH_SERIAL_BACKEND requires libserialport
cmake_config_args=(
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_INSTALL_PREFIX=$PREFIX
    -DCMAKE_INSTALL_LIBDIR=lib
    -DCMAKE_INSTALL_SBINDIR=bin
    -DENABLE_PYTHON=ON
    -DENABLE_CSHARP=OFF
    -DENABLE_TOOLS=OFF
    -DBUILD_EXAMPLES=OFF
    -DINSTALL_UDEV_RULES=OFF
    -DENABLE_PACKAGING=OFF
    -DPython_EXECUTABLE=$PYTHON
    -DENABLE_DOC=OFF
    -DENABLE_LOG=OFF
    -DENABLE_EXCEPTIONS=ON
)

if [[ $target_platform == linux* ]] ; then
    cmake_config_args+=(
        -DINSTALL_UDEV_RULES=OFF
        -DUDEV_RULES_INSTALL_DIR=$PREFIX/lib/udev/rules.d
    )
else
    cmake_config_args+=(
        -DOSX_PACKAGE=OFF
    )
fi

cmake .. "${cmake_config_args[@]}"
cmake --build . --config Release -- -j${CPU_COUNT}
cmake --build . --config Release --target install
