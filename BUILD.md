BUILDING DEB
------------

This will be modified but instructions came from:
https://groups.google.com/forum/#!msg/ngx-pagespeed-discuss/K2qGP7OIYt0/xEXuK46ZsuAJ

This is not really and issue but I wanted to contribute with this steps if someone else need to know how.

Create a directory to download necessary packages (optional) :

    mkdir pagespeed && cd pagespeed

Make sure that you have latest version of nginx, I recommend using nginx repo.

To add nginx repo :

    wget http://nginx.org/keys/nginx_signing.key
    sudo apt-key add nginx_signing.key

Add this lines to /etc/apt/sources.list file:

    deb http://nginx.org/packages/debian/ codename nginx (for 12.04 codename is squeeze)
    deb-src http://nginx.org/packages/debian/ codename nginx

Download nginx sources and build packages :
    
    sudo apt-get update
    sudo apt-get install dpkg-dev
    sudo apt-get source nginx

Build nginx deps :

    sudo apt-get build-dep nginx

Make sure you have this ngx_pagespeed requirements :

    sudo apt-get install build-essential zlib1g-dev libpcre3 libpcre3-dev


Clone ngx_pagespeed git repo :

    git clone https://github.com/pagespeed/ngx_pagespeed.git


Edit build rules for nginx 1.4 package :

    vim nginx-1.4.0/debian/rules

and add :

    --add-module=../ngx_pagespeed \

it will look like this :

    ...
    --with-file-aio \
    --add-module=../ngx_pagespeed \
    $(WITH_SPDY) \
    --with-ipv6
    ...

Build nginx 1.4.0 debian package with pagespeed module :

    cd nginx-1.4.0/ && dpkg-buildpackage -b

Install new nginx deb package:

    cd .. && dpkg --install nginx_1.4.0-1~squeeze_amd64.deb

> `If you have nginx installed you will need to remove it and then reinstall the new package ( do not use --purge options otherwise you will delete all your config files)`

Add this lines to /etc/nginx.conf to test if pagespeed works :

    ...
    http {
        pagespeed on;
        pagespeed FileCachePath /var/ngx_pagespeed_cache;
    ...

Create pagespeed cache directory and change permissions :

    mkdir /var/ngx_pagespeed_cache
    chown -R www-data:www-data /var/ngx_pagespeed_cache

Reload nginx :

    nginx -s reload

Test if pagespeed is working :

    curl -I -p http://localhost:8080/index.php|grep X-Page-Speed 

>make sure to use the correct url

you should see :

    X-Page-Speed: 1.5.27.1-2845

If you see that header you are done enjoy!!!

Now you need to RT?M!!

For More detailed information please read :

https://github.com/pagespeed/ngx_pagespeed

http://nginx.org/en/linux_packages.html#stable


Any feedback on this instructions is welcome

> This process could be used to build basically any module for nginx that is not on the nginx-full or default dedi
