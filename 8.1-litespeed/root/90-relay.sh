#!/bin/bash

RELAY=v0.6.1
PLATFORM=$(uname -m | sed 's/_/-/')

curl -L "https://builds.r2.relay.so/$RELAY/relay-$RELAY-php8.1-debian-$PLATFORM%2Blibssl3.tar.gz" | tar xz -C /tmp
cp "/tmp/relay-$RELAY-php8.1-debian-$PLATFORM+libssl3/relay.ini" "$PHP_INI_DIR/60-relay.ini" 
cp "/tmp/relay-$RELAY-php8.1-debian-$PLATFORM+libssl3/relay-pkg.so" "$PHP_EXT_DIR/relay.so"

sed -i "s/00000000-0000-0000-0000-000000000000/$(cat /proc/sys/kernel/random/uuid)/" "$PHP_EXT_DIR/relay.so"