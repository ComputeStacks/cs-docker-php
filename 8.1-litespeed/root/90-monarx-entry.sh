#!/bin/bash

if [ -z ${MONARX_ID} ] || [ -z ${MONARX_SECRET} ]; then
  echo >&2 "MONARX_ID or MONARX_SECRET not set, disabling monarx."
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
  if [ -f /usr/local/lsws/lsphp81/lib/php/20210902/monarxprotect-php81.so ]; then
    rm /usr/local/lsws/lsphp81/lib/php/20210902/monarxprotect-php81.so
  fi
  cp /usr/lib/monarx-protect/monarxprotect-php81.so /usr/local/lsws/lsphp81/lib/php/20210902/
  echo "extension=monarxprotect-php81.so" > /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/monarxprotect.ini
  if [ -f /etc/service/monarx/down ]; then
    echo "Activating Monarx"
    rm /etc/service/monarx/down
  fi
fi
