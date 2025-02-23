mkdir build
cd build

:: Make sure that PCL does not inject custom compilation options
:: See https://github.com/conda-forge/pcl-feedstock/pull/54
set "CXXFLAGS=/nologo %CXXFLAGS%"

cmake -G "Ninja" ^
  -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DWITH_CUDA=OFF ^
  -DWITH_DAVIDSDK=OFF ^
  -DWITH_DSSDK=OFF ^
  -DWITH_ENSENSO=OFF ^
  -DWITH_FZAPI=OFF ^
  -DWITH_LIBUSB=OFF ^
  -DWITH_OPENGL=OFF ^
  -DWITH_OPENNI=OFF ^
  -DWITH_OPENNI2=OFF ^
  -DWITH_PCAP=OFF ^
  -DWITH_PNG=OFF ^
  -DWITH_QHULL=ON ^
  -DWITH_QT=QT6 ^
  -DWITH_VTK=ON ^
  -DBUILD_global_tests=OFF ^
  -DBUILD_examples=OFF ^
  -DBUILD_tools=ON ^
  -DBUILD_apps=OFF ^
  -DBoost_NO_BOOST_CMAKE:BOOL=ON ^
  -DBoost_USE_DEBUG_RUNTIME:BOOL=OFF ^
  -DPCL_BUILD_WITH_BOOST_DYNAMIC_LINKING_WIN32:BOOL=ON ^
  %SRC_DIR%
if errorlevel 1 exit 1

ninja install -j 1
if errorlevel 1 exit 1
