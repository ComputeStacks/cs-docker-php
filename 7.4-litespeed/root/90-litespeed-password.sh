#!/bin/bash

set -euo pipefail

if [[ -z "${LS_ADMIN_PW}" ]]; then
  echo >&2 "Litespeed admin password not set, leaving default of 123456."
else
  ENCRYPT_PASS=`/usr/local/lsws/admin/fcgi-bin/admin_php -q /usr/local/lsws/admin/misc/htpasswd.php $LS_ADMIN_PW`
  echo "admin:$ENCRYPT_PASS" > /usr/local/lsws/admin/conf/htpasswd
  if [ $? -eq 0 ]; then
    echo "Litespeed admin password successfully changed to ${LS_ADMIN_PW}".
  else
    echo "Failed to set Litespeed admin password to ${LS_ADMIN_PW}, leaving default at 123456."
  fi
fi

echo "Ensuring Litespeed Admin file permissions are correct"
chown lsadm:lsadm /usr/local/lsws/admin/conf/admin_config.conf
chown lsadm:lsadm /usr/local/lsws/admin/conf/htpasswd