#!/bin/bash

function autoclean
{
  rm -f aclocal.m4
  rm -f configure~
  aclocal
  autoconf
  automake --add-missing
  rm -f configure~
}

VERSION="1.1.4"

if [ -f atomes-$VERSION ]; then
  rm -rf atomes-$VERSION
fi
tar -zxf atomes-$VERSION.tar.gz
rm -f *.orig.* 
cp -r debian-package-data atomes-$VERSION/debian
cd atomes-$VERSION
autoclean
export DEBEMAIL="sebastien.leroux@ipcms.unistra.fr"
export DEBFULLNAME="Sébastien Le Roux"
dh_make --createorig -s -y
dpkg-buildpackage
cd ..
scp * leroux@pc-chess:files/git-files/atomes/atomes-deb-build/atomes-deb-build/
scp -r debian-package-data leroux@pc-chess:files/git-files/atomes/atomes-deb-build/atomes-deb-build/
