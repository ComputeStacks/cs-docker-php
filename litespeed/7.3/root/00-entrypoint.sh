#!/usr/bin/env bash

if ! [ "$(ls -A /var/www)" ]; then
  echo >&2 "No files found in volume - copying default files..."
  mv /usr/src/default/* /var/www/
  chown -R www-data:www-data /var/www
  echo >&2 "Complete! Sample files have been successfully copied to /var/www/"
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

if ! [ "$(ls -A /usr/local/lsws)" ]; then
  echo >&2 "No files found in config volume - copying files..."
  mv /usr/src/lsws/* /usr/local/lsws/
  chown -R lsadm: /usr/local/lsws/conf/vhosts
  echo >&2 "Complete! Configuration files have been successfully copied to /usr/local/lsws/"
fi
