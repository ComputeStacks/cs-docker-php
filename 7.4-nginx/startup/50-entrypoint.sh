#!/bin/bash

set -euo pipefail

if ! [ "$(ls -A /var/www/html)" ]; then
  echo >&2 "No files found in volume - copying default files..."
  mv /usr/src/default/* /var/www/
  cp /etc/nginx/sites-available/default /var/www/nginx/site.conf.example
  cp /etc/nginx/nginx.conf /var/www/nginx/nginx.conf.example
  cp /etc/php/7.4/fpm/pool.d/www.conf /var/www/nginx/pool.conf.example
  chown -R www-data:www-data /var/www
  echo >&2 "Complete! Sample files have been successfully copied to /var/www/"
else
  if [ -f /var/www/nginx/site.conf ]; then
    cp /var/www/nginx/site.conf /etc/nginx/sites-available/default
  fi

  if [ -f /var/www/nginx/nginx.conf ]; then
    cp /var/www/nginx/nginx.conf /etc/nginx/nginx.conf
  fi

  if [ -f /var/www/nginx/pool.conf ]; then
    cp /var/www/nginx/pool.conf /etc/php/7.4/fpm/pool.d/www.conf
  fi
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

if [ ! -d /var/www/nginx ]; then
  mkdir -p /var/www/nginx
  chown -R www-data:www-data /var/www/nginx
fi
if [ ! -d /var/www/logs ]; then
  mkdir -p /var/www/logs
  chown -R www-data:www-data /var/www/logs
fi