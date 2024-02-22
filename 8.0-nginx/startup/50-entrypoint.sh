#!/usr/bin/env bash

set -euo pipefail

FPM_POOL_CONF=/etc/php/8.0/fpm/pool.d/www.conf

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

##
#  Store original configuration files under /opt. This lets us always keep the user's
#  volume up to date with the latest version of our configuration files.
#
#  If the file /opt/nginx/site.conf already exists, then don't copy again.
#  This file is wiped out on rebuild, so it will only ever be the most recent version
#  this container image has. Also, this prevents us from potentially copying over the user's
#  custom config, since the nginx conf directory will be persisted through restarts.
##

##
# Install user created configuration files
if [ -f /var/www/nginx/site.conf ]; then
  if [ ! -f /opt/nginx/site.conf ]; then
    cp /etc/nginx/sites-available/default /opt/nginx/site.conf
  fi
  cp /var/www/nginx/site.conf /etc/nginx/sites-available/default
fi

if [ -f /var/www/nginx/nginx.conf ]; then
  if [ ! -f /opt/nginx/nginx.conf ]; then
    cp /etc/nginx/nginx.conf /opt/nginx/nginx.conf
  fi
  cp /var/www/nginx/nginx.conf /etc/nginx/nginx.conf
fi

if [ -f /var/www/nginx/pool.conf ]; then
  if [ ! -f /opt/nginx/pool.conf ]; then
    cp $FPM_POOL_CONF /opt/nginx/pool.conf
  fi
  cp /var/www/nginx/pool.conf $FPM_POOL_CONF
fi

if [ -f /var/www/crontab ]; then
  echo >&2 "Crontab found, moving to cron.d directory..."
  cp /var/www/crontab /etc/cron.d/myapp && chown root:root /etc/cron.d/myapp
else
  if [ -f /etc/cron.d/myapp ]; then
    echo >&2 "Removing stale crontab..."
    rm /etc/cron.d/myapp
  fi
fi
