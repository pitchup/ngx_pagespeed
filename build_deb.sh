#/bin/bash

NGINX_VERSION=1.4.2

# update list of packages
sudo apt-get update

# dpkg needed for building debs
sudo apt-get install dpkg-dev

# install any packages needed for nginx
sudo apt-get build-dep nginx=$NGINX_VERSION

# deps for pagespeed
sudo apt-get install build-essential zlib1g-dev libpcre3 libpcre3-dev libssl-dev

# psol lib (needed for pagespeed)
rm 1.6.29.5.tar.gz 
wget https://dl.google.com/dl/page-speed/psol/1.6.29.5.tar.gz
tar -xzvf 1.6.29.5.tar.gz # expands to psol/


# install the nginx source
rm -rf build
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
