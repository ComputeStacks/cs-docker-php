#!/usr/bin/env bash

set -euo pipefail

FPM_POOL_CONF=/etc/php/8.2/fpm/pool.d/www.conf

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

# Set CS Auth Key
if [ -z ${CS_AUTH_KEY} ]; then
  echo >&2 "CS_AUTH_KEY not set, generating random key..."
  export CS_AUTH_KEY=$(xxd -l24 -ps /dev/urandom | xxd -r -ps | base64 | tr -d = | tr + - | tr / _)
fi

sed -i "s/env\[CS_AUTH_KEY\] = .*/env\[CS_AUTH_KEY\] = '$CS_AUTH_KEY'/g" $FPM_POOL_CONF

# Add our metadata environmental variables
if [ -z ${METADATA_SERVICE} ]; then
  echo >&2 "METADATA_SERVICE not set."
else
  sed -i "s|env\[METADATA_SERVICE\] = .*|env\[METADATA_SERVICE\] = '$METADATA_SERVICE'|g" $FPM_POOL_CONF
fi
if [ -z ${METADATA_AUTH} ]; then
  echo >&2 "METADATA_AUTH not set."
else
  sed -i "s/env\[METADATA_AUTH\] = .*/env\[METADATA_AUTH\] = '$METADATA_AUTH'/g" $FPM_POOL_CONF
fi