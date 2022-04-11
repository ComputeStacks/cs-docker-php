#!/bin/bash

if ! [ "$(ls -A /usr/local/lsws)" ]; then
  echo >&2 "OpenLiteSpeed not configured, setting configuration..."
  
  if [ -z ${PHP_LSAPI_CHILDREN} ]; then
    echo >&2 "SET_PHP_CHILDREN not set, setting default of 35."
    sed -i "s/SET_PHP_CHILDREN/35/g" /usr/src/lsws/conf/httpd_config.conf
  else
    sed -i "s/SET_PHP_CHILDREN/$PHP_LSAPI_CHILDREN/g" /usr/src/lsws/conf/httpd_config.conf
  fi
  
  if [ -z ${PHP_MAX_CONN} ]; then
    echo >&2 "PHP_MAX_CONN not set, setting default of 35."
    sed -i "s/SET_PHP_MAX_CONN/35/g" /usr/src/lsws/conf/httpd_config.conf
  else
    sed -i "s/SET_PHP_MAX_CONN/$PHP_MAX_CONN/g" /usr/src/lsws/conf/httpd_config.conf
  fi
  # This is a fix for an issue where an image wouldn't be processed after uploading
  echo "MAGICK_THREAD_LIMIT=1" >> /usr/src/lsws/conf/httpd_config
  
fi
