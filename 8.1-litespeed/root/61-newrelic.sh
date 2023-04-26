#!/bin/bash

# Enable New Relic with -e NEW_RELIC_KEY="Your New Relic Key"
if [[ -z "${NEW_RELIC_KEY}" ]]; then
  echo >&2 "New Relic Not Configured, skipping..."
  if [ -f /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/newrelic.ini ]; then
    sed -i 's/;newrelic.enabled = .*/newrelic.enabled = false/g' /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/newrelic.ini
    sed -i 's/newrelic.enabled = .*/newrelic.enabled = false/g' /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/newrelic.ini
    sed -i 's/newrelic.license = .*/newrelic.license = "REPLACE_WITH_REAL_KEY"/g' /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/newrelic.ini
  fi
else
  echo >&2 "Configuring New Relic..."

  if [ -f /usr/local/lsws/lsphp81/lib/php/20210902/newrelic.so ]; then
    rm /usr/local/lsws/lsphp81/lib/php/20210902/newrelic.so
  fi

  cp /usr/src/newrelic/agent/x64/newrelic-20210902.so /usr/local/lsws/lsphp81/lib/php/20210902/newrelic.so

  if [ ! -f /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/newrelic.ini ]; then
    cp /usr/src/newrelic/scripts/newrelic.ini.template /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/newrelic.ini
  fi

  sed -i 's/;newrelic.enabled = .*/newrelic.enabled = true/g' /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/newrelic.ini
  sed -i 's/newrelic.enabled = .*/newrelic.enabled = true/g' /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/newrelic.ini
  sed -i "s/newrelic.license = .*/newrelic.license = \"$NEW_RELIC_KEY\"/g" /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/newrelic.ini

  # Set the app name. Defaults to hostname. Can be overriden by passing -e NEW_RELIC_APP_NAME="my-app"
  if [[ -z "${NEW_RELIC_APP_NAME}" ]]; then
    sed -i "s/newrelic.appname = .*/newrelic.appname = \"$HOSTNAME\"/g" /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/newrelic.ini
  else
    sed -i "s/newrelic.appname = .*/newrelic.appname = \"$NEW_RELIC_APP_NAME\"/g" /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/newrelic.ini
  fi

  # Reduce overal usage by disable platform checks. Can be overriden by passing -e NEW_RELIC_ALLOW_CHECKS=true
  if [[ -z "${NEW_RELIC_ALLOW_CHECKS}" ]]; then
    sed -i 's/;newrelic.daemon.utilization.detect_aws = .*/newrelic.daemon.utilization.detect_aws = false/g' /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/newrelic.ini
    sed -i 's/;newrelic.daemon.utilization.detect_azure = .*/newrelic.daemon.utilization.detect_azure = false/g' /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/newrelic.ini
    sed -i 's/;newrelic.daemon.utilization.detect_gcp = .*/newrelic.daemon.utilization.detect_gcp = false/g' /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/newrelic.ini
  fi

fi