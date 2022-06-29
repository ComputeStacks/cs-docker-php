# Local dev: docker run --rm -it -e LS_ADMIN_PW=changeme -p 3000:80 -p 7080:7080 cmptstks/php:8.1-litespeed /sbin/my_init -- bash -l  
FROM cr.cmptstks.com/cs-public/images/base-image:ubuntu

LABEL maintainer="https://computestacks.com"
LABEL org.opencontainers.image.authors="https://computestacks.com"
LABEL org.opencontainers.image.source="https://git.cmptstks.com/cs-public/images/php/-/tree/main/8.1-litespeed"
LABEL org.opencontainers.image.url="https://git.cmptstks.com/cs-public/images/php/-/tree/main/8.1-litespeed"
LABEL org.opencontainers.image.title="PHP 8.1 with OpenLiteSpeed"

COPY root/monarx-agent.sh /tmp/
COPY root/40-ls-config.sh /etc/my_init.d/
COPY root/50-entrypoint.sh /etc/my_init.d/
COPY root/60-litespeed-upgrade.sh /etc/my_init.d/
COPY root/60-php-config.sh /etc/my_init.d/
COPY root/90-litespeed-password.sh /etc/my_init.d/
COPY root/90-monarx-entry.sh /etc/my_init.d/
COPY root/90-postfix.sh /etc/my_init.d/
COPY root/99-litespeed.sh /etc/my_init.d/

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
      inotify-tools \
      mailutils \
      apt-utils \
    ; \
    echo "postfix postfix/mailname string docker.local" | debconf-set-selections \
    && echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections \
    && apt-get -y install postfix postfix-pcre libsasl2-modules \
    ; \
    wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debain_repo.sh | bash \
    ; \
    apt-get install -y --no-install-recommends \
      lsphp81 \
      lsphp81-common \
      lsphp81-curl \
      lsphp81-dev \
      lsphp81-imap \
      lsphp81-imagick \
      lsphp81-intl \
      lsphp81-memcached \
      lsphp81-msgpack \
      lsphp81-mysql \
      lsphp81-opcache \
      lsphp81-pgsql \
      lsphp81-redis \
      lsphp81-sqlite3 \
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
    && chmod +x /etc/my_init.d/21-postfix.sh \
    ; \
    apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY root/www /usr/src/default/
COPY root/vhosts /usr/local/lsws/conf/vhosts/
COPY root/pecl/install_pear.sh /root/
COPY root/pecl/install_mcrypt.sh /root/

RUN cd /usr/local/lsws/fcgi-bin/ \
    && rm lsphp \
    && ln -s /usr/local/lsws/lsphp81/bin/lsphp lsphp \
    && cd /usr/local/lsws/lsphp81/bin \
    && chmod +x /etc/my_init.d/*.sh \
    && wget -O /tmp/go-pear.phar http://pear.php.net/go-pear.phar \
    && chmod +x -R /root/install_*.sh \
    && /root/install_pear.sh \
    && /usr/local/lsws/lsphp81/bin/pecl channel-update pecl.php.net \
    ; \
    /root/install_mcrypt.sh \
    ; \
    echo "extension=mcrypt.so" >> /usr/local/lsws/lsphp81/etc/php/8.1/mods-available/50-mcrypt.ini \
    && rm /root/install_*.sh \
    && rm /usr/local/lsws/conf/httpd_config.conf \
    ; \
    mv /usr/local/lsws /usr/src \
    && chown -R lsadm:lsadm /usr/src/lsws/conf \
    && echo "max_input_vars = 3000" >> /usr/src/lsws/lsphp81/etc/php/8.1/litespeed/php.ini \
    && sed -i 's/memory_limit = .*/memory_limit = 192M/g' /usr/src/lsws/lsphp81/etc/php/8.1/litespeed/php.ini \
    && sed -i 's/upload_max_filesize = .*/upload_max_filesize = 250M/g' /usr/src/lsws/lsphp81/etc/php/8.1/litespeed/php.ini \
    && sed -i 's/max_input_time = .*/max_input_time = 300/g' /usr/src/lsws/lsphp81/etc/php/8.1/litespeed/php.ini \
    && sed -i 's/max_execution_time = .*/max_execution_time = 300/g' /usr/src/lsws/lsphp81/etc/php/8.1/litespeed/php.ini \
    && echo "date.timezone = 'UTC'" >> /usr/src/lsws/lsphp81/etc/php/8.1/litespeed/php.ini \
    && echo "post_max_size = 250M" >> /usr/src/lsws/lsphp81/etc/php/8.1/litespeed/php.ini \
    ; \
    usermod -u 1001 www-data && groupmod -g 1001 www-data

COPY root/lswsctrl.sh /usr/local/bin/lswsctrl
COPY root/httpd_config.conf /usr/src/lsws/conf/httpd_config.conf
COPY root/monarx-agent.conf /etc/monarx-agent.conf

EXPOSE 80 7080