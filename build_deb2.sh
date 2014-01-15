#/bin/bash -x 

NGINX_VERSION=1.4.4
OPENSSL_VERSION=1.0.1e
PSOL_VERSION=1.7.30.2
PAGESPEED_VERSION=1.7.30.2-beta
UBUNTU_VERSION=raring
PAGESPEED_URL=https://github.com/pagespeed/ngx_pagespeed/archive/release-1.7.30.2-beta.zip

sudo apt-get install build-essential -y
sudo apt-get build-dep nginx -y
sudo apt-get install dpkg-dev build-essential zlib1g-dev libpcre3 libpcre3-dev git unzip -y

wget -N http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key

echo "deb http://nginx.org/packages/ubuntu/ ${UBUNTU_VERSION} nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
echo "deb-src http://nginx.org/packages/ubuntu/ ${UBUNTU_VERSION} nginx" | sudo tee -a /etc/apt/sources.list.d/nginx.list

# add nginx to sources
#sudo apt-add-repository "deb http://nginx.org/packages/ubuntu/ ${UBUNTU_VERSION} nginx"

# update list of packages
sudo apt-get update

# dpkg needed for building debs
#sudo apt-get install dpkg-dev

cd /tmp

# install any packages needed for nginx
sudo apt-get build-dep nginx -y

# deps for pagespeed
#sudo apt-get install build-essential zlib1g-dev libpcre3 libpcre3-dev

# install the nginx source
#rm -rf build
#mkdir build
#cd build
#apt-get source nginx=$NGINX_VERSION

apt-get source nginx
NGINX_VER=$(find ./nginx* -maxdepth 0 -type d | sed "s|^\./||")
NGINX_BUILD_DIR=/tmp/$NGINX_VER

echo "Using nginx ${NGINX_VER}"


# openssl (lucids version is old)
#wget -N http://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
#tar -xzvf openssl-${OPENSSL_VERSION}.tar.gz
#ln -sf openssl-${OPENSSL_VERSION} openssl

sed -i '/--with-http_sub_module \\/i--with-http_geoip_module \\' $NGINX_BUILD_DIR/debian/rules

mkdir $NGINX_BUILD_DIR/modules

wget -N ${PAGESPEED_URL} -O $NGINX_BUILD_DIR/modules/pagespeed.zip
unzip $NGINX_BUILD_DIR/modules/pagespeed.zip -d $NGINX_BUILD_DIR/modules

wget https://dl.google.com/dl/page-speed/psol/1.7.30.2.tar.gz -O $NGINX_BUILD_DIR/modules/ngx_pagespeed-release-1.7.30.2-beta/1.7.30.2.tar.gz

tar -C $NGINX_BUILD_DIR/modules/ngx_pagespeed-release-1.7.30.2-beta -xzf $NGINX_BUILD_DIR/modules/ngx_pagespeed-release-1.7.30.2-beta/1.7.30.2.tar.gz

sed -i '/--with-file-aio \\/i--add-module=modules/ngx_pagespeed-release-1.7.30.2-beta \\' $NGINX_BUILD_DIR/debian/rules

cd $NGINX_BUILD_DIR
dpkg-buildpackage -b

