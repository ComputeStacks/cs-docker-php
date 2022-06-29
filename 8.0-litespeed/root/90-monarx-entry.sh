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
  if [ -f /usr/local/lsws/lsphp80/lib/php/20200930/monarxprotect-php80.so ]; then
    rm /usr/local/lsws/lsphp80/lib/php/20200930/monarxprotect-php80.so
  fi
  cp /usr/lib/monarx-protect/monarxprotect-php80.so /usr/local/lsws/lsphp80/lib/php/20200930/
  echo "extension=monarxprotect-php80.so" > /usr/local/lsws/lsphp80/etc/php/8.0/mods-available/monarxprotect.ini
  if [ -f /etc/service/monarx/down ]; then
    echo "Activating Monarx"
    rm /etc/service/monarx/down
  fi
fi
