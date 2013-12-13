#/bin/bash

NGINX_VERSION=1.4.4
OPENSSL_VERSION=1.0.1e
PSOL_VERSION=1.7.30.1

# update list of packages
sudo apt-get update

# dpkg needed for building debs
sudo apt-get install dpkg-dev

# install any packages needed for nginx
sudo apt-get build-dep nginx=$NGINX_VERSION

# deps for pagespeed
sudo apt-get install build-essential zlib1g-dev libpcre3 libpcre3-dev

# psol lib (needed for pagespeed)
wget -N https://dl.google.com/dl/page-speed/psol/${PSOL_VERSION}.tar.gz
tar -xzvf ${PSOL_VERSION}.tar.gz

# openssl (lucids version is old)
wget -N http://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
tar -xzvf openssl-${OPENSSL_VERSION}.tar.gz

# install the nginx source
#rm -rf build
mkdir build
cd build
apt-get source nginx=$NGINX_VERSION

# copy our rules
cp -f ../debian/rules nginx-${NGINX_VERSION}/debian/rules

# build it
cd nginx-${NGINX_VERSION} 
dpkg-buildpackage -b

echo ".deb built"
ls -l "nginx*.deb"
