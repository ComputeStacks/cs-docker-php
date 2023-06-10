#!/bin/bash

MONARX_PHP_VERSION=81
PHP_INI_DIR=/etc/php/8.1/mods-available/
PHP_EXT_DIR=$(/usr/bin/php-config --extension-dir)

if [ ! -f "/usr/lib/monarx-protect/monarxprotect-php${MONARX_PHP_VERSION}.so" ]; then
  echo >&2 "PHP Version for Monarx not present, skipping."
   if [ ! -f /etc/service/monarx/down ]; then
    touch /etc/service/monarx/down
    /sbin/phpdismod monarx
  fi
elif [ -z ${MONARX_ID} ] || [ -z ${MONARX_SECRET} ]; then
  echo >&2 "MONARX_ID or MONARX_SECRET not set, disabling monarx."
   if [ ! -f /etc/service/monarx/down ]; then
    touch /etc/service/monarx/down
    /sbin/phpdismod monarx
  fi
else
  sed -i "s/SET_CLIENT_ID/$MONARX_ID/g" /etc/monarx-agent.conf
  sed -i "s/SET_CLIENT_SECRET/$MONARX_SECRET/g" /etc/monarx-agent.conf
  # Fallback to hostname if agent is not set.
  if [ -z ${MONARX_AGENT} ]; then    
    sed -i "s/SET_SERVICE_NAME/$HOSTNAME/g" /etc/monarx-agent.conf
  else
    sed -i "s/SET_SERVICE_NAME/$MONARX_AGENT/g" /etc/monarx-agent.conf
  fi
  # grab latest file
  if [ -f "${PHP_EXT_DIR}monarxprotect-php${MONARX_PHP_VERSION}.so" ]; then
    rm "${PHP_EXT_DIR}monarxprotect-php${MONARX_PHP_VERSION}.so"
  fi
  cp /usr/lib/monarx-protect/monarxprotect-php${MONARX_PHP_VERSION}.so $PHP_EXT_DIR
  echo "extension=monarxprotect-php${MONARX_PHP_VERSION}.so" > "${PHP_INI_DIR}monarxprotect.ini"
  if [ -f /etc/service/monarx/down ]; then
    echo "Activating Monarx"
    rm /etc/service/monarx/down
    /sbin/phpenmod monarxprotect
  fi
fi
