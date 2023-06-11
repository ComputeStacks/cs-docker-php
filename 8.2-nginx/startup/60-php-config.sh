#!/bin/bash

echo >&2 "Setting PHP tunables..."

PHP_INI_PATH=/etc/php/8.2/fpm/

sed -i 's/^;\? \?cgi.fix_pathinfo=.*/cgi.fix_pathinfo=0/g' ${PHP_INI_PATH}php.ini

if [ -z ${PHP_INPUT_VAR} ]; then
  echo >&2 "PHP_INPUT_VAR not set, skipping..."
else
  sed -i "s/max_input_vars = .*/max_input_vars = $PHP_INPUT_VAR/g" "${PHP_INI_PATH}php.ini"
fi

if [ -z ${PHP_MEMORY_LIMIT} ]; then
  echo >&2 "PHP_MEMORY_LIMIT not set, skipping..."
else
  sed -i "s/memory_limit = .*/memory_limit = $PHP_MEMORY_LIMIT/g" "${PHP_INI_PATH}php.ini"
fi

if [ -z ${PHP_UPLOAD_SIZE} ]; then
  echo >&2 "PHP_UPLOAD_SIZE not set, skipping..."
else
  sed -i "s/upload_max_filesize = .*/upload_max_filesize = $PHP_UPLOAD_SIZE/g" "${PHP_INI_PATH}php.ini"
fi

if [ -z ${PHP_INPUT_TIME} ]; then
  echo >&2 "PHP_INPUT_TIME not set, skipping..."
else
  sed -i "s/max_input_time = .*/max_input_time = $PHP_INPUT_TIME/g" "${PHP_INI_PATH}php.ini"
fi

if [ -z ${PHP_EXEC_TIME} ]; then
  echo >&2 "PHP_EXEC_TIME not set, skipping..."
else
  sed -i "s/max_execution_time = .*/max_execution_time = $PHP_EXEC_TIME/g" "${PHP_INI_PATH}php.ini"
fi

if [ -z ${PHP_TIMEZONE} ]; then
  echo >&2 "PHP_TIMEZONE not set, skipping..."
else
  sed -i "s/date.timezone = .*/date.timezone = '$PHP_TIMEZONE'/g" "${PHP_INI_PATH}php.ini"
fi

if [ -z ${PHP_POST_SIZE} ]; then
  echo >&2 "PHP_POST_SIZE not set, skipping..."
else
  sed -i "s/post_max_size = .*/post_max_size = $PHP_POST_SIZE/g" "${PHP_INI_PATH}php.ini"
fi
