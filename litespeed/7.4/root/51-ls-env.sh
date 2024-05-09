#!/usr/bin/env bash

echo >&2 "Setting CS WP Env..."

if [ -z "$CS_AUTH_KEY" ]; then
  echo >&2 "CS_AUTH_KEY not set, generating random key..."
  export CS_AUTH_KEY=$(xxd -l24 -ps /dev/urandom | xxd -r -ps | base64 | tr -d = | tr + - | tr / _)
fi

# Ensure we always have the correct auth key.
sed -i "s/CS_AUTH_KEY=.*/CS_AUTH_KEY=$CS_AUTH_KEY/g" /usr/local/lsws/conf/httpd_config.conf

# if it does not exist, create it.
grep -q -e 'CS_AUTH_KEY' /usr/local/lsws/conf/httpd_config.conf || sed -i "/extprocessor lsphp/a  env                     CS_AUTH_KEY=$CS_AUTH_KEY" /usr/local/lsws/conf/httpd_config.conf

if [ -z ${METADATA_SERVICE} ]; then
  echo >&2 "METADATA_SERVICE not set."
else
  sed -i "s|METADATA_SERVICE=.*|METADATA_SERVICE=$METADATA_SERVICE|g" /usr/local/lsws/conf/httpd_config.conf
  grep -q -e 'METADATA_SERVICE' /usr/local/lsws/conf/httpd_config.conf || sed -i "/extprocessor lsphp/a  env                     METADATA_SERVICE=$METADATA_SERVICE" /usr/local/lsws/conf/httpd_config.conf
fi

if [ -z ${METADATA_AUTH} ]; then
  echo >&2 "METADATA_AUTH not set."
else
  sed -i "s/METADATA_AUTH=.*/METADATA_AUTH=$METADATA_AUTH/g" /usr/local/lsws/conf/httpd_config.conf
  grep -q -e 'METADATA_AUTH' /usr/local/lsws/conf/httpd_config.conf || sed -i "/extprocessor lsphp/a  env                     METADATA_AUTH=$METADATA_AUTH" /usr/local/lsws/conf/httpd_config.conf
fi
