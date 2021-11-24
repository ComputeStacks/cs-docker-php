# Local dev: docker run --rm -it -e LS_ADMIN_PW=changeme -e PHP_VERSION=7.4 -p 3000:80 -p 7080:7080 cmptstks/php:universal /sbin/my_init -- bash -l
FROM cmptstks/baseimage:latest

LABEL maintainer="ComputeStacks <hello@computestacks.com>"

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
    apt update -y \
    && apt-get install -y --no-install-recommends \
      php-cli \
      php-mysql \
      openlitespeed \
      rcs \
    ; \
    mkdir -p /var/www && mkdir /usr/src/default \
    ; \
    apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY root/www /usr/src/default/
COPY root/00-entrypoint.sh /etc/my_init.d/
COPY root/05-php.sh /etc/my_init.d/
COPY root/10-litespeed-upgrade.sh /etc/my_init.d/
COPY root/50-litespeed.sh /etc/my_init.d/
COPY root/vhosts /usr/local/lsws/conf/vhosts/
COPY root/pecl/install_pear*.sh /root/
COPY root/pecl/install_mcrypt*.sh /root/

RUN chmod +x /etc/my_init.d/00-entrypoint.sh
RUN chmod +x /etc/my_init.d/05-php.sh
RUN chmod +x /etc/my_init.d/10-litespeed-upgrade.sh
RUN chmod +x /etc/my_init.d/50-litespeed.sh
RUN rm /usr/local/lsws/conf/httpd_config.conf


COPY root/httpd_config.conf /usr/local/lsws/conf/httpd_config.conf

RUN usermod -u 1001 www-data \
    && groupmod -g 1001 www-data

COPY root/lswsctrl.sh /usr/local/bin/lswsctrl

VOLUME ["/var/www", "/usr/local/lsws"]

EXPOSE 80 7080
