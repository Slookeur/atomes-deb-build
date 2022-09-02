#!/bin/bash

VERSION="1.1.0"

rm -rf atomes-$VERSION
tar -zxf atomes-$VERSION.tar.gz
cd atomes-$VERSION
cp -r ../debian-package-data ./debian
export DEBEMAIL="sebastien.leroux@ipcms.unistra.fr"
export export DEBFULLNAME="Sébastien Le Roux"
dh_make --createorig -s -y
dpkg-buildpackage
cd ..
