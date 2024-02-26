#!/bin/sh
/usr/sbin/php-fpm${PHP_VERSION} --nodaemonize --php-ini /etc/php/${PHP_VERSION}/fpm/php.ini --fpm-config /etc/php/${PHP_VERSION}/fpm/php-fpm.conf
