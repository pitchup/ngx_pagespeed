#/bin/bash -x

# update list of packages
sudo apt-get update

# dpkg needed for building debs
sudo apt-get install dpkg-dev

# install any packages needed for nginx
sudo apt-get build-dep nginx-1.4.2

# deps for pagespeed
sudo apt-get install build-essential zlib1g-dev libpcre3 libpcre3-dev libssl-dev

# install the nginx sourc
mkdir build
cd build
apt-get source nginx-1.4.2
