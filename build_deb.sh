#!/bin/bash

VERSION="1.1.0"

if [ -f atomes-$VERSION ]; then
  rm -rf atomes-$VERSION
fi
tar -zxf atomes-$VERSION.tar.gz
cd atomes-$VERSION
cp -r ../debian-package-data ./debian
export DEBEMAIL="sebastien.leroux@ipcms.unistra.fr"
export export DEBFULLNAME="Sébastien Le Roux"
dh_make --createorig -s -y
dpkg-buildpackage
cd ..
