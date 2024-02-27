#!/usr/bin/env bash

# Configure Relay
RELAY_INI_DIR=$(/usr/local/bin/php-config --ini-dir)
RELAY_EXT_DIR=$(/usr/local/bin/php-config --extension-dir)
RELAY_INI="${RELAY_INI_DIR}60-relay.ini"

# if $PHP_INI_DIR/60-relay.ini does not exist, cp relay.ini to $PHP_INI_DIR/60-relay.ini
# Allow customizations outside of the defined env vars.
if [ ! -f "$RELAY_INI_DIR/60-relay.ini" ]; then
    cp "/usr/src/relay/relay.ini" "$RELAY_INI"
fi

cp "/usr/src/relay/relay-pkg.so" "$RELAY_EXT_DIR/relay.so"

if [[ -z "${RELAY_LICENSE}" ]]; then
    echo >&2 "No Relay License found."
    sed -i "s/^;\? \?relay.maxmemory =.*/relay.maxmemory = 32M/" $RELAY_INI
else
    echo >&2 "Relay License found."
    sed -i "s/^;\? \?relay.key =.*/relay.key = $RELAY_LICENSE/" $RELAY_INI
    sed -i "s/^;\? \?relay.maxmemory =.*/relay.maxmemory = ${RELAY_MEMORY:-128M}/" $RELAY_INI    
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
sed -i "s|^;\? \?relay.logfile = .*|relay.logfile = ${RELAY_LOGFILE:-/var/www/logs/relay.log}|" $RELAY_INI
