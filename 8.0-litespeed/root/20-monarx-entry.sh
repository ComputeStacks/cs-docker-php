#!/bin/bash

if [ -z ${MONARX_ID} ] || [ -z ${MONARX_SECRET} ]; then
  echo >&2 "MONARX_ID or MONARX_SECRET not set, disabling monarx."
else
  sed -i "s/SET_CLIENT_ID/$MONARX_ID/g" /etc/monarx-agent.conf
  sed -i "s/SET_CLIENT_SECRET/$MONARX_SECRET/g" /etc/monarx-agent.conf
  # grab latest file
  if [ -f /usr/local/lsws/lsphp74/lib/php/20190902/monarxprotect-php74.so ]; then
    rm /usr/local/lsws/lsphp74/lib/php/20190902/monarxprotect-php74.so
  fi
  cp /usr/lib/monarx-protect/monarxprotect-php74.so /usr/local/lsws/lsphp74/lib/php/20190902/
  echo "extension=monarxprotect-php74.so" > /usr/local/lsws/lsphp74/etc/php/7.4/mods-available/monarxprotect.ini
  if [ -f /etc/service/monarx/down ]; then
    echo "Activating Monarx"
    rm /etc/service/monarx/down
  fi
fi
