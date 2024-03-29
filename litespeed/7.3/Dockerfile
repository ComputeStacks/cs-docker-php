FROM ghcr.io/computestacks/cs-docker-base:ubuntu-focal

LABEL maintainer="https://github.com/ComputeStacks"
LABEL org.opencontainers.image.authors="https://github.com/ComputeStacks"
LABEL org.opencontainers.image.source="https://github.com/ComputeStacks/cs-docker-php/tree/main/litespeed/7.3"
LABEL org.opencontainers.image.url="https://github.com/ComputeStacks/cs-docker-php/tree/main/litespeed/7.3"
LABEL org.opencontainers.image.title="PHP 7.3 with OpenLiteSpeed"

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      autoconf \
      build-essential \
      wget \
      dpkg-dev \
      file \
      g++ \
      gcc \
      libc-dev \
      make \
      pkg-config \
      re2c \
      dirmngr \
      gnupg \
      libcurl4-openssl-dev \
      libedit-dev \
      libsodium-dev \
      libsqlite3-dev \
      libssl-dev \
      libxml2-dev \
      zlib1g-dev \
      procps \
      vim \
      tree \
      zip \
      unzip \
      libpng-dev \
      libbz2-dev \
      libmemcached-dev \
      libfreetype6-dev \
      libc-client-dev \
      libkrb5-dev \
      libxslt-dev \
      libicu-dev \
      imagemagick \
      libmagickwand-dev \
      libmariadb-dev \
      mariadb-client \
      libmcrypt-dev \
      mcrypt \
      expect \
      net-tools \
      ca-certificates \
      curl \
      xz-utils \
      rcs \
      inotify-tools \
      sudo \
    ; \
    wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debain_repo.sh | bash \
    ; \
    apt-get install -y --no-install-recommends \
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
      lsphp73-redis \
      php-cli \
      php-mysql \
      openlitespeed \
    ; \
    mkdir -p /var/www && mkdir /usr/src/default \
    ; \
    apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY root/www /usr/src/default/
COPY root/00-entrypoint.sh /etc/my_init.d/
COPY root/10-litespeed-upgrade.sh /etc/my_init.d/
COPY root/15-litespeed-password.sh /etc/my_init.d/
COPY root/50-litespeed.sh /etc/my_init.d/
COPY root/vhosts /usr/local/lsws/conf/vhosts/
COPY root/pecl/install_pear.sh /root/
COPY root/pecl/install_mcrypt.sh /root/
COPY root/ioncube_loader_lin_7.3.so /usr/local/lsws/lsphp73/lib/php/20180731/
COPY root/migrate_php.sh /usr/local/bin/migrate_php_version

RUN cd /usr/local/lsws/fcgi-bin/ \
    && rm lsphp \
    && ln -s /usr/local/lsws/lsphp73/bin/lsphp lsphp \
    && cd /usr/local/lsws/lsphp73/bin \
    && chmod +x /etc/my_init.d/00-entrypoint.sh \
    && chmod +x /etc/my_init.d/10-litespeed-upgrade.sh \
    && chmod +x /etc/my_init.d/15-litespeed-password.sh \
    && chmod +x /etc/my_init.d/50-litespeed.sh \
    && chmod +x /usr/local/bin/migrate_php_version \
    && wget -O /tmp/go-pear.phar http://pear.php.net/go-pear.phar \
    && chmod +x -R /root/install_*.sh \
    && /root/install_pear.sh \
    && /usr/local/lsws/lsphp73/bin/pecl channel-update pecl.php.net \
    && /root/install_mcrypt.sh \
    && echo "extension=mcrypt.so" >> /usr/local/lsws/lsphp73/etc/php/7.3/mods-available/50-mcrypt.ini \
    && echo "zend_extension=ioncube_loader_lin_7.3.so" >> /usr/local/lsws/lsphp73/etc/php/7.3/mods-available/ioncube.ini \
    && rm /root/install_*.sh \
    && rm /usr/local/lsws/conf/httpd_config.conf

COPY root/httpd_config.conf /usr/local/lsws/conf/httpd_config.conf

RUN mv /usr/local/lsws /usr/src \
    && chown -R lsadm:lsadm /usr/src/lsws/conf \
    && echo "max_input_vars = 3000" >> /usr/src/lsws/lsphp73/etc/php/7.3/litespeed/php.ini \
    && sed -i 's/memory_limit = .*/memory_limit = 192M/g' /usr/src/lsws/lsphp73/etc/php/7.3/litespeed/php.ini \
    && sed -i 's/upload_max_filesize = .*/upload_max_filesize = 250M/g' /usr/src/lsws/lsphp73/etc/php/7.3/litespeed/php.ini \
    && sed -i 's/max_input_time = .*/max_input_time = 300/g' /usr/src/lsws/lsphp73/etc/php/7.3/litespeed/php.ini \
    && sed -i 's/max_execution_time = .*/max_execution_time = 300/g' /usr/src/lsws/lsphp73/etc/php/7.3/litespeed/php.ini \
    && echo "date.timezone = 'UTC'" >> /usr/src/lsws/lsphp73/etc/php/7.3/litespeed/php.ini \
    && echo "post_max_size = 250M" >> /usr/src/lsws/lsphp73/etc/php/7.3/litespeed/php.ini

RUN usermod -u 1001 www-data \
    && groupmod -g 1001 www-data

COPY root/lswsctrl.sh /usr/local/bin/lswsctrl

VOLUME ["/var/www", "/usr/local/lsws"]

EXPOSE 80 7080
