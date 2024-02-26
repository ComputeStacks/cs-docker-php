#!/usr/bin/env bash

PHP_INI_PATH=/etc/php/${PHP_VERSION}/fpm/

if [ ! -d "$PHP_INI_PATH" ]; then
  echo >&2 "Missing PHP INI Path, halting."
  exit 0
fi

echo >&2 "Setting PHP tunables..."

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

if [ -z ${PHP_DISPLAY_ERRORS} ]; then
  echo >&2 "PHP_DISPLAY_ERRORS not set, skipping..."
else
  sed -i "s/display_errors = .*/display_errors = $PHP_DISPLAY_ERRORS/g" "${PHP_INI_PATH}php.ini"
fi

if [ -z ${PHP_ERROR_REPORTING} ]; then
  echo >&2 "PHP_ERROR_REPORTING not set, skipping..."
else
  # first, verify if error_reporting string is valid
  php -r "error_reporting($PHP_ERROR_REPORTING);" 2>/dev/null
  if [ $? -ne 0 ]; then
    echo >&2 "PHP_ERROR_REPORTING is not valid, skipping..."
  fi
  sed -i "s/error_reporting = .*/error_reporting = $PHP_ERROR_REPORTING/g" "${PHP_INI_PATH}php.ini"
fi

# add opcache.enable bool
if [ -z ${PHP_OPCACHE_ENABLE} ]; then
  echo >&2 "PHP_OPCACHE_ENABLE not set, skipping..."
else
  echo >&2 "PHP_OPCACHE_ENABLE set, enabling..."
  # if the line opcache.enable= exists, replace it, or else add it
  if grep -q "opcache.enable=" "${PHP_INI_CONF_PATH}10-opcache.ini"; then
    sed -i "s/opcache.enable=.*/opcache.enable=$PHP_OPCACHE_ENABLE/g" "${PHP_INI_CONF_PATH}10-opcache.ini"
  else
    echo "opcache.enable=$PHP_OPCACHE_ENABLE" >> "${PHP_INI_CONF_PATH}10-opcache.ini"
  fi
fi

# add log_errors bool
if [ -z ${PHP_LOG_ERRORS} ]; then
  echo >&2 "PHP_LOG_ERRORS not set, skipping..."
else
  sed -i "s/log_errors=.*/log_errors=$PHP_LOG_ERRORS/g" "${PHP_INI_PATH}php.ini"
fi