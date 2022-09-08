#!/bin/bash

VERSION="1.1.0"

<<<<<<< HEAD
rm -rf atomes-$VERSION
rm -f *.orig.*
=======
if [ -f atomes-$VERSION ]; then
  rm -rf atomes-$VERSION
fi
>>>>>>> df88eea4ce6e2604617f77368272a0d07b32a2b6
tar -zxf atomes-$VERSION.tar.gz
cd atomes-$VERSION
cp -r ../debian-package-data ./debian
export DEBEMAIL="sebastien.leroux@ipcms.unistra.fr"
export export DEBFULLNAME="Sébastien Le Roux"
dh_make --createorig -s -y
dpkg-buildpackage
cd ..
