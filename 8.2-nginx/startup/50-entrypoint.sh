#!/usr/bin/env bash

set -euo pipefail

FPM_POOL_CONF=/etc/php/8.2/fpm/pool.d/www.conf

if ! [ "$(ls -A /var/www/html)" ]; then
  echo >&2 "No files found in volume - copying default files..."
  mv /usr/src/default/* /var/www/
  mkdir -p /var/www/{nginx,logs}  
  cp /etc/nginx/sites-available/default /var/www/nginx/site.conf.example
  cp /etc/nginx/nginx.conf /var/www/nginx/nginx.conf.example
  cp $FPM_POOL_CONF /var/www/nginx/pool.conf.example
  chown -R www-data:www-data /var/www
  echo >&2 "Complete! Sample files have been successfully copied to /var/www/"
else
  mkdir -p /var/www/{nginx,logs} \
    && chown www-data:www-data /var/www/{nginx,logs}
fi

mkdir -p /opt/nginx

##
# re-seed conf files to keep them up to date
if [ -f /opt/nginx/site.conf ]; then
  cp /opt/nginx/site.conf /var/www/nginx/site.conf.example
elif [ -f /etc/nginx/sites-available/default ]; then
  cp /etc/nginx/sites-available/default /var/www/nginx/site.conf.example
else
  echo >&2 "ERROR: Missing nginx site.conf"
fi

if [ -f /opt/nginx/nginx.conf ]; then
  cp /opt/nginx/nginx.conf /var/www/nginx/nginx.conf.example
elif [ -f /etc/nginx/nginx.conf ]; then
  cp /etc/nginx/nginx.conf /var/www/nginx/nginx.conf.example
else  
  echo >&2 "ERROR: Missing nginx.conf"
fi

if [ -f /opt/nginx/pool.conf ]; then
  cp /opt/nginx/pool.conf /var/www/nginx/pool.conf.example
elif [ -f $FPM_POOL_CONF ]; then
  cp $FPM_POOL_CONF /var/www/nginx/pool.conf.example
else  
  echo >&2 "ERROR: Missing pool.conf"
fi

chown -R www-data:www-data /var/www/nginx
