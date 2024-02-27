#!/usr/bin/env bash

echo >&2 "Updating litespeed configuration..."

if grep -Fq 'errorlog' /usr/local/lsws/conf/vhosts/Default/vhconf.conf; then
  echo "defualt errorlog configuration found, skipping..."
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

echo >&2 "Configuring container healthcheck..."

mkdir -p /opt/healthcheck
cat << 'EOF' > /opt/healthcheck/index.php
<?php echo time() . "\n"; ?>
EOF
chown -R www-data:www-data /opt/healthcheck

if grep -Fq 'healthcheck' /usr/local/lsws/conf/vhosts/Default/vhconf.conf; then
  echo "healthcheck configuration found, skipping..."
else
  cat << EOF >> '/usr/local/lsws/conf/vhosts/Default/vhconf.conf'

context /healthcheck {
  location                /opt/healthcheck/
  allowBrowse             1
  indexFiles              index.php

  rewrite  {

  }
  addDefaultCharset       off

  phpIniOverride  {

  }
}

EOF
fi 

