#/bin/bash

NGINX_VERSION=1.4.4
OPENSSL_VERSION=1.0.1e
PSOL_VERSION=1.6.29.7
PAGESPEED_VERSION=release-1.6.29.7-beta
UBUNTU_VERSION=lucid

# add nginx to sources
sudo apt-add-repository "deb http://nginx.org/packages/ubuntu/ ${UBUNTU_VERSION} nginx"

# update list of packages
sudo apt-get update

# dpkg needed for building debs
sudo apt-get install dpkg-dev

# install any packages needed for nginx
sudo apt-get build-dep nginx=$NGINX_VERSION

# deps for pagespeed
sudo apt-get install build-essential zlib1g-dev libpcre3 libpcre3-dev

# install the nginx source
#rm -rf build
mkdir build
cd build
apt-get source nginx=$NGINX_VERSION

# openssl (lucids version is old)
wget -N http://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
tar -xzvf openssl-${OPENSSL_VERSION}.tar.gz
ln -sf openssl-${OPENSSL_VERSION} openssl

# download pagespeed
wget -N https://github.com/pagespeed/ngx_pagespeed/archive/${PAGESPEED_VERSION}.zip
unzip -o ${PAGESPEED_VERSION}.zip
ln -sf ngx_pagespeed-${PAGESPEED_VERSION} ngx_pagespeed 
cd ngx_pagespeed

# psol lib (needed for pagespeed)
wget -N https://dl.google.com/dl/page-speed/psol/${PSOL_VERSION}.tar.gz
tar -xzvf ${PSOL_VERSION}.tar.gz

cd ..

# copy our rules
cp -f ../debian/rules2 nginx-${NGINX_VERSION}/debian/rules

# build it
cd nginx-${NGINX_VERSION} 
dpkg-buildpackage -b

echo ".deb built"
