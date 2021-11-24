#!/bin/bash
# This file installs the PHP version specified in the $PHP_VERSION variable

set -e

export DEBIAN_FRONTEND=NONINTERACTIVE

# download and install debian repos for litespeed php
wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debain_repo.sh | bash

apt update

if [[ $PHP_VERSION = "7.3" ]]; then
  echo "Installing PHP 7.3 with default modules"
  apt install -y \
    lsphp73 \
    lsphp73-common \
    lsphp73-curl \
    lsphp73-dev \
    lsphp73-imap \
    lsphp73-imagick \
    lsphp73-intl \
    lsphp73-json \
    lsphp73-memcached \
    lsphp73-mysql \
    lsphp73-redis

    PHP_NODOT=73
  elif [[ $PHP_VERSION = "7.2" ]]; then
  echo "Installing PHP 7.2"
  apt-get install -y \
    lsphp72 \
    lsphp72-common \
    lsphp72-curl \
    lsphp72-dev \
    lsphp72-imap \
    lsphp72-intl \
    lsphp72-json \
    lsphp72-memcached \
    lsphp72-mysql \
    lsphp72-redis

  PHP_NODOT=72
else
  if [[ -z "$PHP_VERSION" ]]; then
    echo "PHP version not specified; defaulting to 7.4"
    PHP_VERSION="7.4"
  elif [[ $PHP_VERSION != "7.4" ]]; then
    echo "Specified PHP version invalid; defaulting to 7.4"
    PHP_VERSION="7.4"
  fi

  echo "Installing PHP 7.4 with default modules"

  PHP_NODOT=74

  apt install -y \
      lsphp74 \
      lsphp74-common \
      lsphp74-curl \
      lsphp74-dev \
      lsphp74-imap \
      lsphp74-imagick \
      lsphp74-intl \
      lsphp74-ioncube \
      lsphp74-json \
      lsphp74-memcached \
      lsphp74-msgpack \
      lsphp74-mysql \
      lsphp74-opcache \
      lsphp74-pear \
      lsphp74-pgsql \
      lsphp74-redis \
      lsphp74-sqlite3
fi

cd /usr/local/lsws/fcgi-bin/ \
    && rm lsphp \
    && ln -s /usr/local/lsws/lsphp$PHP_NODOT/bin/lsphp lsphp \
    && cd /usr/local/lsws/lsphp$PHP_NODOT/bin \
    && wget -O /tmp/go-pear.phar http://pear.php.net/go-pear.phar \
    && chmod +x -R /root/install_*.sh \
    && /root/install_pear.sh \
    && /usr/local/lsws/lsphp$PHP_NODOT/bin/pecl channel-update pecl.php.net \
    && /root/install_mcrypt.sh \
    && echo "extension=mcrypt.so" >> /usr/local/lsws/lsphp$PHP_NODOT/etc/php/$PHP_VERSION/mods-available/50-mcrypt.ini \
    chmod +x /root/install_*.sh
    /bin/expect /root/install_pear$PHP_NODOT.sh
    /bin/bash /usr/local/lsws/lsphp$PHP_NODOT/bin/pecl channel-update pecl.php.net
    /bin/expect /root/install_mcrypt$PHP_NODOT.sh

cp -r /usr/local/lsws /usr/src \
    && chown -R lsadm:lsadm /usr/src/lsws/conf \
    && echo "max_input_vars = 3000" >> /usr/src/lsws/lsphp$PHP_NODOT/etc/php/$PHP_VERSION/litespeed/php.ini \
    && sed -i 's/memory_limit = .*/memory_limit = 192M/g' /usr/src/lsws/lsphp$PHP_NODOT/etc/php/$PHP_VERSION/litespeed/php.ini \
    && sed -i 's/upload_max_filesize = .*/upload_max_filesize = 250M/g' /usr/src/lsws/lsphp$PHP_NODOT/etc/php/$PHP_VERSION/litespeed/php.ini \
    && sed -i 's/max_input_time = .*/max_input_time = 300/g' /usr/src/lsws/lsphp$PHP_NODOT/etc/php/$PHP_VERSION/litespeed/php.ini \
    && sed -i 's/max_execution_time = .*/max_execution_time = 300/g' /usr/src/lsws/lsphp$PHP_NODOT/etc/php/$PHP_VERSION/litespeed/php.ini \
    && echo "date.timezone = 'UTC'" >> /usr/src/lsws/lsphp$PHP_NODOT/etc/php/$PHP_VERSION/litespeed/php.ini \
    && echo "post_max_size = 250M" >> /usr/src/lsws/lsphp$PHP_NODOT/etc/php/$PHP_VERSION/litespeed/php.ini \
    && cp /usr/src/lsws/conf/httpd_config.conf /usr/local/lsws/conf/httpd_config.conf
