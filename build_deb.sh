#/bin/bash -x

# update list of packages
sudo apt-get update

# dpkg needed for building debs
sudo apt-get install dpkg-dev

# install the nginx source
sudo apt-get source nginx

# install any packages needed for nginx
sudo apt-get build-dep nginx

# deps for pagespeed
sudo apt-get install build-essential zlib1g-dev libpcre3 libpcre3-dev
