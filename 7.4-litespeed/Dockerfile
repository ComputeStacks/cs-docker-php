# Local dev: docker run --rm -it -e LS_ADMIN_PW=changeme -p 3000:80 -p 7080:7080 cmptstks/php:7.4-litespeed /sbin/my_init -- bash -l  
FROM cmptstks/baseimage:ubuntu

LABEL maintainer="https://github.com/ComputeStacks"
LABEL org.opencontainers.image.authors="https://github.com/ComputeStacks"
LABEL org.opencontainers.image.source="https://github.com/ComputeStacks/cs-docker-php/tree/main/7.4-litespeed"
LABEL org.opencontainers.image.url="https://github.com/ComputeStacks/cs-docker-php/tree/main/7.4-litespeed"
LABEL org.opencontainers.image.title="PHP 7.4 with OpenLiteSpeed"

COPY root/monarx-agent.sh /tmp/
COPY root/00-entrypoint.sh /etc/my_init.d/
COPY root/10-litespeed-upgrade.sh /etc/my_init.d/
COPY root/20-monarx-entry.sh /etc/my_init.d/
COPY root/50-litespeed.sh /etc/my_init.d/

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
    ; \
    wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debain_repo.sh | bash \
    ; \
    apt-get install -y --no-install-recommends \
      lsphp73 \
      lsphp73-common \
      lsphp73-json \
      lsphp73-mysql \
      lsphp73-imap \
      lsphp73-opcache \
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
      lsphp74-sqlite3 \
      php-cli \
      php-mysql \
      openlitespeed \
      rcs \
      sudo \
      libonig-dev \
      libzip-dev \
    ; \
    mkdir -p /var/www && mkdir /usr/src/default \
    ; \
    curl https://repository.monarx.com/repository/monarx/publickey/monarxpub.gpg | apt-key add - \
    && echo "deb [arch=amd64] https://repository.monarx.com/repository/ubuntu-focal/ focal main" > /etc/apt/sources.list.d/monarx.list \
    ; \
    apt-get update \
    && apt-get -y install monarx-agent monarx-protect \
    ; \
    mkdir -p /etc/service/monarx \
    && mv /tmp/monarx-agent.sh /etc/service/monarx/run \
    && touch /etc/service/monarx/down \
    && chmod +x /etc/service/monarx/run \
    && chmod +x /etc/my_init.d/20-monarx-entry.sh \
    ; \
    apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY root/www /usr/src/default/
COPY root/vhosts /usr/local/lsws/conf/vhosts/
COPY root/pecl/install_pear.sh /root/
COPY root/pecl/install_mcrypt.sh /root/

RUN cd /usr/local/lsws/fcgi-bin/ \
    && rm lsphp \
    && ln -s /usr/local/lsws/lsphp74/bin/lsphp lsphp \
    && cd /usr/local/lsws/lsphp74/bin \
    && chmod +x /etc/my_init.d/00-entrypoint.sh \
    && chmod +x /etc/my_init.d/10-litespeed-upgrade.sh \
    && chmod +x /etc/my_init.d/50-litespeed.sh \
    && wget -O /tmp/go-pear.phar http://pear.php.net/go-pear.phar \
    && chmod +x -R /root/install_*.sh \
    && /root/install_pear.sh \
    && /usr/local/lsws/lsphp74/bin/pecl channel-update pecl.php.net \
    ; \
    /root/install_mcrypt.sh \
    ; \
    echo "extension=mcrypt.so" >> /usr/local/lsws/lsphp74/etc/php/7.4/mods-available/50-mcrypt.ini \
    && rm /root/install_*.sh \
    && rm /usr/local/lsws/conf/httpd_config.conf \
    ; \
    mv /usr/local/lsws /usr/src \
    && chown -R lsadm:lsadm /usr/src/lsws/conf \
    && echo "max_input_vars = 3000" >> /usr/src/lsws/lsphp74/etc/php/7.4/litespeed/php.ini \
    && sed -i 's/memory_limit = .*/memory_limit = 192M/g' /usr/src/lsws/lsphp74/etc/php/7.4/litespeed/php.ini \
    && sed -i 's/upload_max_filesize = .*/upload_max_filesize = 250M/g' /usr/src/lsws/lsphp74/etc/php/7.4/litespeed/php.ini \
    && sed -i 's/max_input_time = .*/max_input_time = 300/g' /usr/src/lsws/lsphp74/etc/php/7.4/litespeed/php.ini \
    && sed -i 's/max_execution_time = .*/max_execution_time = 300/g' /usr/src/lsws/lsphp74/etc/php/7.4/litespeed/php.ini \
    && echo "date.timezone = 'UTC'" >> /usr/src/lsws/lsphp74/etc/php/7.4/litespeed/php.ini \
    && echo "post_max_size = 250M" >> /usr/src/lsws/lsphp74/etc/php/7.4/litespeed/php.ini \
    ; \
    usermod -u 1001 www-data && groupmod -g 1001 www-data

COPY root/lswsctrl.sh /usr/local/bin/lswsctrl
COPY root/httpd_config.conf /usr/src/lsws/conf/httpd_config.conf
COPY root/monarx-agent.conf /etc/monarx-agent.conf

EXPOSE 80 7080
