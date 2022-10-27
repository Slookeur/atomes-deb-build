#!/bin/bash

function autoclean
{
  rm -f aclocal.m4
  rm -rf auto4te.cache
  rm -f configure~
  aclocal
  autoconf
  automake --add-missing
  rm -f configure~
}

VERSION="1.1.8"
OVER="1.1.7"
rm -f "*_"$OVER"*"
wget https://github.com/Slookeur/Atomes-GNU/archive/refs/tags/v$VERSION.tar.gz
#scp leroux@pc-chess:files/git-files/atomes/atomes-all/atomes-$VERSION.tar.gz .
if [ -d atomes-$VERSION ]; then
  rm -rf atomes-$VERSION
fi
if [ -d atomes-$OVER ]; then
  rm -rf atomes-$OVER
fi
tar -zxf v$VERSION.tar.gz
mv Atomes-GNU-$VERSION atomes-$VERSION
rm v$VERSION.tar.gz
tar -zcf atomes-$VERSION.tar.gz  atomes-$VERSION
rm -f *.orig.* 
cp -r debian-package-data atomes-$VERSION/debian
cd atomes-$VERSION
cp README.md README
autoclean
export DEBEMAIL="sebastien.leroux@ipcms.unistra.fr"
export DEBFULLNAME="Sébastien Le Roux"
dh_make --createorig -s -y
dpkg-buildpackage -katomes@ipcms.unistra.fr
cd ..
scp * leroux@pc-chess:files/git-files/atomes/atomes-deb-build/atomes-deb-build/
scp -r debian-package-data leroux@pc-chess:files/git-files/atomes/atomes-deb-build/atomes-deb-build/
