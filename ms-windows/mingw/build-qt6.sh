#!/bin/bash
set -euo pipefail

# QGIS 4 → Windows mit mingw64-Qt6 (Fedora 42+)
njobs=$(($(grep -c ^processor /proc/cpuinfo) * 3 / 2))
MINGWROOT=/usr/x86_64-w64-mingw32/sys-root/mingw

# Dependencies installieren
dnf install -y --skip-unavailable \
  mingw64-qt6-qtbase mingw64-qt6-qtsvg mingw64-qt6-qttools \
  mingw64-qt6-qtimageformats mingw64-qt6-qtlocation \
  mingw64-qt6-qtmultimedia mingw64-qt6-qtserialport \
  mingw64-qt6-qttranslations mingw64-gcc-c++ mingw64-gdal \
  mingw64-geos mingw64-proj mingw64-spatialindex \
  mingw64-sqlite mingw64-zstd mingw64-libzip mingw64-exiv2 \
  mingw64-python3 cmake make ccache git flex bison

# Bauen
cd /QGIS
mkdir -p build_mingw64
cd build_mingw64

mingw64-cmake \
  -DCMAKE_CROSS_COMPILING=1 \
  -DUSE_CCACHE=ON \
  -DCMAKE_BUILD_TYPE=RelWithDebugInfo \
  -DWITH_3D=OFF \
  -DWITH_DRACO=OFF \
  -DWITH_PDAL=OFF \
  -DWITH_SERVER=OFF \
  -DWITH_QSPATIALITE=OFF \
  -DWITH_ORACLE=OFF \
  -DWITH_HANA=OFF \
  -DBUILD_TESTING=OFF \
  -DENABLE_TESTS=OFF \
  -DQGIS_BIN_SUBDIR=bin \
  -DQGIS_LIB_SUBDIR=lib \
  -DQGIS_DATA_SUBDIR=share/qgis \
  -DQGIS_PLUGIN_SUBDIR=lib/qgis/plugins \
  -DQGIS_INCLUDE_SUBDIR=include/qgis \
  -DBINDINGS_GLOBAL_INSTALL=ON \
  -DSIP_GLOBAL_INSTALL=ON \
  ..

echo ""
echo "===== Baue QGIS 4.0.3 für Windows ($njobs Jobs) ====="
mingw64-make -j"$njobs"
