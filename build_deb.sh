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

VERSION="1.1.16"
OVER="1.1.15"

CLEAN=1
if [ $CLEAN -eq 1 ]; then
  rm -f "*"$OVER"*"
  rm -f "*"$VERSION"*"
  if [ -d atomes-$VERSION ]; then
    rm -rf atomes-$VERSION
  fi
  if [ -d atomes-$OVER ]; then
    rm -rf atomes-$OVER
  fi
fi

DOWN=1
if [ $DOWN -eq 1 ]; then
  wget https://github.com/Slookeur/Atomes-GNU/archive/refs/tags/v$VERSION.tar.gz
  tar -zxf v$VERSION.tar.gz
  mv Atomes-GNU-$VERSION atomes-$VERSION
  rm v$VERSION.tar.gz
else
  scp -r leroux@pc-chess:files/git-files/atomes/atomes-all/atomes-$VERSION .
fi

BUILD=1
if [ $BUILD -eq 1 ]; then
  rm -f *.orig.* 
  cd atomes-$VERSION
  cp -r ../debian-package-data debian
  cp README.md README
  autoclean
  export DEBEMAIL="sebastien.leroux@ipcms.unistra.fr"
  export DEBFULLNAME="Sébastien Le Roux"
  dh_make --createorig -s -y
  dpkg-buildpackage -b --no-sign
  # -katomes@ipcms.unistra.fr
  cd ..
fi

TEST=1
if [ $TEST -eq 1 ]; then
  lintian  -EviIL +pedantic ./atomes_*changes >& results.lintian
  cd atomes-$VERSION
  licensecheck --recursive --copyright . >& ../license.check
  scan-copyrights >& ../scan.copy
  cd ..
fi

PIUPARTS=1
if [ $PIUPARTS -eq 1 ]; then
  # To use piuparts remove the atomes-data dependency
  echo "Piuparts on atomes.deb" > results.piuparts
  echo " " >> results.piuparts
  sudo piuparts ./atomes_$VERSION*.deb &>> results.piuparts
  echo " " >> results.piuparts
  echo "Piuparts on atomes-data.deb" >> results.piuparts
  echo " " >> results.piuparts
  sudo piuparts ./atomes-data*.deb &>> results.piuparts
fi

COPY=1
if [ $COPY -eq 1 ]; then
  scp build_deb.sh leroux@pc-chess:files/git-files/atomes/atomes-deb-build/atomes-deb-build/
  debian=`lsb_release -a|grep Release|awk '{print $2}'`
  scp atomes_* leroux@pc-chess:files/git-files/atomes/atomes-deb-build/atomes-deb-build/Debian-$debian/
  scp atomes-dbg* leroux@pc-chess:files/git-files/atomes/atomes-deb-build/atomes-deb-build/Debian-$debian/
  scp atomes-data* leroux@pc-chess:files/git-files/atomes/atomes-deb-build/atomes-deb-build/Debian-$debian/
  scp -r debian-package-data leroux@pc-chess:files/git-files/atomes/atomes-deb-build/atomes-deb-build/
fi
