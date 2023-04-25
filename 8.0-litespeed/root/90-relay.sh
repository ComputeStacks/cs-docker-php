#!/bin/bash

# Installation of Relay
RELAY=v0.6.3
PLATFORM=$(uname -m | sed 's/_/-/')
RELAY_PHP=$(/usr/local/lsws/lsphp80/bin/php-config --version | cut -c -3) 
RELAY_INI_DIR=$(/usr/local/lsws/lsphp80/bin/php-config --ini-dir)          
RELAY_EXT_DIR=$(/usr/local/lsws/lsphp80/bin/php-config --extension-dir)    

# if $PHP_INI_DIR/60-relay.ini does not exist, cp relay.ini to $PHP_INI_DIR/60-relay.ini
if [ ! -f "$RELAY_INI_DIR/60-relay.ini" ]; then
    cp "/usr/src/relay/relay-$RELAY-php$RELAY_PHP-debian-$PLATFORM+libssl3/relay.ini" "$RELAY_INI_DIR/60-relay.ini"
fi

if [ ! -f "$RELAY_EXT_DIR/relay.so" ]; then
    cp "/usr/src/relay/relay-$RELAY-php$RELAY_PHP-debian-$PLATFORM+libssl3/relay-pkg.so" "$RELAY_EXT_DIR/relay.so"
fi

cp "/usr/src/relay/relay-$RELAY-php8.0-debian-$PLATFORM+libssl3/relay.ini" "$PHP_INI_DIR/60-relay.ini" 
cp "/usr/src/relay/relay-$RELAY-php8.0-debian-$PLATFORM+libssl3/relay-pkg.so" "$PHP_EXT_DIR/relay.so"

sed -i "s/00000000-0000-0000-0000-000000000000/$(cat /proc/sys/kernel/random/uuid)/" "$PHP_EXT_DIR/relay.so"

# setting configuration;
RELAY_INI="/usr/local/lsws/lsphp80/etc/php/8.0/litespeed/php.ini"

if [ -z "$RELAY_LICENSE" ]; then
    sed -i "s/^;\? \?relay.key =.*/relay.key = $RELAY_LICENSE/" $RELAY_INI
    sed -i "s/^;\? \?relay.maxmemory =.*/relay.maxmemory = ${RELAY_MEMORY:-128M}/" $RELAY_INI
else
    sed -i "s/^;\? \?relay.maxmemory =.*/relay.maxmemory = 32M/" $RELAY_INI
fi


sed -i "s/^;\? \?relay.environment =.*/relay.environment = ${RELAY_ENV:-production}/" $RELAY_INI
sed -i "s/^;\? \?relay.maxmemory_pct =.*/relay.maxmemory_pct = ${RELAY_MEMORY_PCT:-75}/" $RELAY_INI
sed -i "s/^;\? \?relay.eviction_policy =.*/relay.eviction_policy = ${RELAY_EVICTION_POLICY:-noeviction}/" $RELAY_INI
sed -i "s/^;\? \?relay.eviction_sample_keys =.*/relay.eviction_sample_keys = ${RELAY_EVICTION_SAMPLE_KEYS:-128}/" $RELAY_INI
sed -i "s/^;\? \?relay.default_pconnect =.*/relay.default_pconnect = ${RELAY_DEFAULT_PCONNECT:-1}/" $RELAY_INI
sed -i "s/^;\? \?relay.databases =.*/relay.databases = ${RELAY_DATABASES:-16}/" $RELAY_INI
sed -i "s/^;\? \?relay.max_endpoint_dbs =.*/relay.max_endpoint_dbs = ${RELAY_MAX_ENDPOINT_DBS:-32}/" $RELAY_INI
sed -i "s/^;\? \?relay.initial_readers =.*/relay.initial_readers = ${RELAY_INITIAL_READERS:-128}/" $RELAY_INI
sed -i "s/^;\? \?relay.invalidation_poll_freq =.*/relay.invalidation_poll_freq = ${RELAY_INVALIDATION_POLL_FREQ:-5}/" $RELAY_INI
sed -i "s/^;\? \?relay.loglevel =.*/relay.loglevel = ${RELAY_LOGLEVEL:-off}/" $RELAY_INI
sed -i "s|^;\? \?relay.logfile = .*|relay.logfile = ${RELAY_LOGFILE:-/var/log/www/logs/relay}|" $RELAY_INI
