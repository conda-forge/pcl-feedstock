#!/bin/bash

set -ex

if [[ "$pcl_variant" == "headless" ]]; then
    # No VTK, Qt or OpenGL: skips pcl_visualization and everything depending on it
    GUI_SUPPORT=OFF
    QT_SUPPORT=OFF
elif [[ "$pcl_variant" == "gui" ]]; then
    GUI_SUPPORT=ON
    if [[ "$target_platform" != "linux-ppc64le" ]]; then
        QT_SUPPORT=QT6
    else
        QT_SUPPORT=OFF
    fi
else
    echo "Unknown pcl_variant: '$pcl_variant'"
    exit 1
fi

if [[ "$build_platform" != "$target_platform" && "$pcl_variant" == "gui" ]]; then
    export QT_HOST_PATH="$BUILD_PREFIX"
fi

if [[ "${target_platform}" == "osx-64" ]]; then
    # https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
    export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

mkdir build && cd build

cmake ${CMAKE_ARGS} \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_BUILD_TYPE=Release \
  -DWITH_CUDA=OFF \
  -DWITH_DAVIDSDK=OFF \
  -DWITH_DSSDK=OFF \
  -DWITH_ENSENSO=OFF \
  -DWITH_FZAPI=OFF \
  -DWITH_LIBUSB=OFF \
  -DWITH_OPENGL=${GUI_SUPPORT} \
  -DWITH_OPENNI=OFF \
  -DWITH_OPENNI2=OFF \
  -DWITH_PCAP=OFF \
  -DWITH_PNG=OFF \
  -DWITH_QHULL=ON \
  -DWITH_QT=${QT_SUPPORT} \
  -DWITH_VTK=${GUI_SUPPORT} \
  -DBUILD_global_tests=OFF \
  -DBUILD_examples=OFF \
  -DBUILD_tools=ON \
  -DBUILD_apps=OFF \
  -DBoost_NO_BOOST_CMAKE:BOOL=ON \
  -DBoost_USE_DEBUG_RUNTIME:BOOL=OFF \
  ..

cmake --build . --config Release
cmake --build . --config Release --target install
