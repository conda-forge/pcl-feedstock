#!/bin/bash

set -ex

EXTRA_CMAKE_ARGS=()

if [[ "$build_variant" == "egl" ]]; then
  EXTRA_CMAKE_ARGS+=(
    "-DOPENGL_egl_LIBRARY:FILEPATH=${BUILD_PREFIX}/${HOST}/sysroot/usr/lib/libEGL.so.1"
    "-DOPENGL_opengl_LIBRARY:FILEPATH=${BUILD_PREFIX}/${HOST}/sysroot/usr/lib64/libGL.so"
  )
fi

cmake \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_BUILD_TYPE=Release \
  -DWITH_CUDA=OFF \
  -DWITH_DAVIDSDK=OFF \
  -DWITH_DSSDK=OFF \
  -DWITH_ENSENSO=OFF \
  -DWITH_FZAPI=OFF \
  -DWITH_LIBUSB=OFF \
  -DWITH_OPENGL=ON \
  -DWITH_OPENNI=OFF \
  -DWITH_OPENNI2=OFF \
  -DWITH_PCAP=OFF \
  -DWITH_PNG=OFF \
  -DWITH_QHULL=ON \
  -DWITH_QT=ON \
  -DWITH_VTK=ON \
  -DBUILD_global_tests=OFF \
  -DBUILD_examples=OFF \
  -DBUILD_tools=ON \
  -DBUILD_apps=OFF \
  -DBoost_NO_BOOST_CMAKE:BOOL=ON \
  ${CMAKE_ARGS} "${EXTRA_CMAKE_ARGS[@]}"

cmake --build . --config Release
cmake --build . --config Release --target install
