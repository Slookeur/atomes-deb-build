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

VERSION="1.1.11"
OVER="1.1.11"
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
cd atomes-$VERSION
cp -r ../debian-package-data debian
cp README.md README
autoclean
export DEBEMAIL="sebastien.leroux@ipcms.unistra.fr"
export DEBFULLNAME="Sébastien Le Roux"
dh_make --createorig -s -y
dpkg-buildpackage -katomes@ipcms.unistra.fr
echo "Lintian on changes:" > ../results.lintian
echo " " >> ../results.lintian
lintian -v ../atomes_*changes &>> ../results.lintian
echo " " >> ../results.lintian
echo "Lintian on deb:" >> ../results.lintian
echo " " >> ../results.lintian
lintian -v ../atomes_*amd64.deb &>> ../results.lintian
echo " " >> ../results.lintian
echo "Lintian on buildinfo:" >> ../results.lintian
echo " " >> ../results.lintian
lintian -v ../atomes_*amd64.buildinfo &>> ../results.lintian
echo " " >> ../results.lintian
echo "Lintian on dsc:" >> ../results.lintian
echo " " >> ../results.lintian
lintian -v ../atomes_*.dsc &>> ../results.lintian

#scan-copyrights >& ../scan.copy
#licensecheck --check=. --recursive --copyright . >> ../license.check
cd ..
scp build_deb.sh leroux@pc-chess:files/git-files/atomes/atomes-deb-build/atomes-deb-build/
scp atomes_* leroux@pc-chess:files/git-files/atomes/atomes-deb-build/atomes-deb-build/
scp -r debian-package-data leroux@pc-chess:files/git-files/atomes/atomes-deb-build/atomes-deb-build/
