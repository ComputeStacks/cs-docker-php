#!/usr/bin/env bash

set -e

echo >&2 "Updating litespeed configuration..."

if grep -Fq 'errorlog' /usr/local/lsws/conf/vhosts/Default/vhconf.conf; then
  echo "default errorlog configuration found, skipping..."
else
  cat << EOF >> '/usr/local/lsws/conf/vhosts/Default/vhconf.conf'

errorlog /var/www/logs/error.log {
  useServer               0
  logLevel                NOTICE
  rollingSize             10M
  keepDays                30
  compressArchive         0
}
EOF
fi 

if grep -Fq 'accesslog' /usr/local/lsws/conf/vhosts/Default/vhconf.conf; then
  echo "default accesslog configuration found, skipping..."
else
  cat << EOF >> '/usr/local/lsws/conf/vhosts/Default/vhconf.conf'

accesslog /var/www/logs/access.log {
  useServer               0
  logFormat               "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"
  logHeaders              7
  rollingSize             10M
  keepDays                30
  compressArchive         0
}
EOF
fi 