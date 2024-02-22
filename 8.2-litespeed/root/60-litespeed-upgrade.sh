#!/usr/bin/env bash

set -e


if [ ! -d /usr/src/lsws ]; then
  echo "/usr/src/lsws does not exist, exiting upgrade process."
  exit 0
fi

if [ ! -f /usr/src/lsws/VERSION ]; then
  echo "/usr/src/lsws/VERSION does not exist, exiting upgrade process."
  exit 0
fi

if [ -f /usr/local/lsws/.upgrade-lock ]; then
  # Check file age
  upgrade_age=$(stat --format='%Y' /usr/local/lsws/.upgrade-lock)
  current_time=$( date +%s )
  # Older than 10 minutes, remove lock file and try again
  if (( $upgrade_age < ( $current_time - ( 60 * 10 ) ) )); then
    rm /usr/local/lsws/.upgrade-lock
  else
    echo "/usr/local/lsws/.upgrade-lock exists, waiting for existing upgrade to finish. create_time=$(stat --format='%y' /usr/local/lsws/.upgrade-lock)"
    while read i; do if [ "$i" = .upgrade-lock ]; then break; fi; done \
      < <(inotifywait -e delete,delete_self --format '%f' --quiet /usr/local/lsws --monitor)
  fi
fi

touch /usr/local/lsws/.upgrade-lock

CURRENT_VERSION=$(cat /usr/local/lsws/VERSION)
NEW_VERSION=$(cat /usr/src/lsws/VERSION)

if [ $CURRENT_VERSION != $NEW_VERSION ]; then
  echo "Current OpenLiteSpeed version is $CURRENT_VERSION, upgrading to $NEW_VERSION"
  if [ -f /usr/src/openlitespeed_${LS_VERSION}_amd64.deb ]; then
    dpkg -i /usr/src/openlitespeed_${LS_VERSION}_amd64.deb
  else
    echo "Saving current configuration..."
    mkdir -p /var/www/.lsws_snapshot
    if [ -f /usr/local/lsws/admin/conf/admin_config.conf ]; then
      mv /usr/local/lsws/admin/conf/admin_config.conf /var/www/.lsws_snapshot/
    fi
    if [ -f /usr/local/lsws/admin/conf/htpasswd ]; then
      mv /usr/local/lsws/admin/conf/htpasswd /var/www/.lsws_snapshot/
    fi
    if [ -d /usr/local/lsws/conf ]; then
      mv /usr/local/lsws/conf /var/www/.lsws_snapshot/
    fi
    echo "Installing new version..."
    rm -rf /usr/local/lsws/* && mv /usr/src/lsws/* /usr/local/lsws/
    echo "Restoring previous configuration..."
    mv /var/www/.lsws_snapshot/admin_config.conf /usr/local/lsws/admin/conf/
    mv /var/www/.lsws_snapshot/htpasswd /usr/local/lsws/admin/conf/
    rm -rf /usr/local/lsws/conf && mv /var/www/.lsws_snapshot/conf /usr/local/lsws/
    chown -R lsadm: /usr/local/lsws/conf/vhosts
    rm -rf /var/www/.lsws_snapshot
    echo "Finished upgrade to $NEW_VERSION"
  fi
else
  echo "Installed version matches current version, exiting upgrade process."
fi

rm /usr/local/lsws/.upgrade-lock
