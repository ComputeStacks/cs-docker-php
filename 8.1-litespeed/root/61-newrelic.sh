#!/bin/bash

NR_PHP_VERSION=$(/usr/local/bin/php-config --version | awk -F '[.]' '{print $1 "." $2}')
NR_PHP=$(/usr/local/bin/php-config --extension-dir | awk -F/ '{print $NF}') 
NR_INI_DIR=$(/usr/local/bin/php-config --ini-dir)
NR_EXT_DIR=$(/usr/local/bin/php-config --extension-dir)
NR_EXT="/usr/src/newrelic/agent/x64/newrelic-${NR_PHP}.so"

if [ ! -f "${NR_EXT}" ]; then
  echo >&2 "New Relic not available for PHP ${NR_PHP_VERSION}, skipping."
  if [ -f $NR_INI_DIR/newrelic.ini ]; then
    sed -i 's/^;\? \?newrelic.enabled = .*/newrelic.enabled = false/g' $NR_INI_DIR/newrelic.ini
    sed -i 's/^;\? \?newrelic.license = .*/newrelic.license = "REPLACE_WITH_REAL_KEY"/g' $NR_INI_DIR/newrelic.ini
  fi
elif [[ -z "${NEW_RELIC_KEY}" ]]; then
  # Enable New Relic with -e NEW_RELIC_KEY="Your New Relic Key"
  echo >&2 "New Relic Not Configured, skipping..."
  if [ -f $NR_INI_DIR/newrelic.ini ]; then
    sed -i 's/^;\? \?newrelic.enabled = .*/newrelic.enabled = false/g' $NR_INI_DIR/newrelic.ini
    sed -i 's/^;\? \?newrelic.license = .*/newrelic.license = "REPLACE_WITH_REAL_KEY"/g' $NR_INI_DIR/newrelic.ini
  fi
elif [ -f /usr/src/newrelic/agent/x64/newrelic-$NR_PHP.so ]; then
  echo >&2 "Configuring New Relic..."

  # Ensure we always grab the latest version
  cp $NR_EXT $NR_EXT_DIR/newrelic.so

  if [ ! -f $NR_INI_DIR/newrelic.ini ]; then
    cp /usr/src/newrelic/scripts/newrelic.ini.template $NR_INI_DIR/newrelic.ini
  fi

  sed -i 's/^;\? \?newrelic.enabled = .*/newrelic.enabled = true/g' $NR_INI_DIR/newrelic.ini
  sed -i "s/^;\? \?newrelic.license = .*/newrelic.license = \"$NEW_RELIC_KEY\"/g" $NR_INI_DIR/newrelic.ini

  # Set the app name. Defaults to hostname. Can be overriden by passing -e NEW_RELIC_APP_NAME="my-app"
  if [[ -z "${NEW_RELIC_APP_NAME}" ]]; then
    sed -i "s/^;\? \?newrelic.appname = .*/newrelic.appname = \"$HOSTNAME\"/g" $NR_INI_DIR/newrelic.ini
  else
    sed -i "s/^;\? \?newrelic.appname = .*/newrelic.appname = \"$NEW_RELIC_APP_NAME\"/g" $NR_INI_DIR/newrelic.ini
  fi

  # Reduce overal usage by disable platform checks. Can be overriden by passing -e NEW_RELIC_ALLOW_CHECKS=true
  if [[ -z "${NEW_RELIC_ALLOW_CHECKS}" ]]; then
    sed -i 's/^;\? \?newrelic.daemon.utilization.detect_aws = .*/newrelic.daemon.utilization.detect_aws = false/g' $NR_INI_DIR/newrelic.ini
    sed -i 's/^;\? \?newrelic.daemon.utilization.detect_azure = .*/newrelic.daemon.utilization.detect_azure = false/g' $NR_INI_DIR/newrelic.ini
    sed -i 's/^;\? \?newrelic.daemon.utilization.detect_gcp = .*/newrelic.daemon.utilization.detect_gcp = false/g' $NR_INI_DIR/newrelic.ini
  fi

else

  echo >&2 "newrelic-$NR_PHP.so does not exist, disabling new relic..."
  if [ -f $NR_INI_DIR/newrelic.ini ]; then
    sed -i 's/^;\? \?newrelic.enabled = .*/newrelic.enabled = false/g' $NR_INI_DIR/newrelic.ini
    sed -i 's/^;\? \?newrelic.license = .*/newrelic.license = "REPLACE_WITH_REAL_KEY"/g' $NR_INI_DIR/newrelic.ini
  fi

fi