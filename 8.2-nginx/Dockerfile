# Local dev: docker run --rm -it -p 3000:80 cmptstks/php:8.2-nginx /sbin/my_init -- bash -l  
FROM ghcr.io/computestacks/cs-docker-base:ubuntu-jammy

LABEL maintainer="https://computestacks.com"
LABEL org.opencontainers.image.authors="https://computestacks.com"
LABEL org.opencontainers.image.source="https://github.com/ComputeStacks/cs-docker-php/tree/main/8.2-nginx"
LABEL org.opencontainers.image.url="https://github.com/ComputeStacks/cs-docker-php/tree/main/8.2-nginx"
LABEL org.opencontainers.image.title="PHP 8.2 with nginx"


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
      libzstd-dev \
      liblzf-dev \
      git \
      nginx-extras \
    ; \
    echo "postfix postfix/mailname string docker.local" | debconf-set-selections \
    && echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections \
    && apt-get -y install postfix postfix-pcre libsasl2-modules \
    ; \
    add-apt-repository ppa:ondrej/php \
    ; \
    apt-get install -y --no-install-recommends \
      php8.2 \
      php8.2-cli \
      php8.2-common \
      php8.2-curl \
      php8.2-decimal \
      php8.2-dev \
      php8.2-fpm \
      php8.2-gd \
      php8.2-gnupg \
      php8.2-grpc \
      php8.2-igbinary \
      php8.2-imap \
      php8.2-intl \
      php8.2-lz4 \
      php8.2-mbstring \
      php8.2-mcrypt \
      php8.2-mysql \
      php8.2-opcache \
      php8.2-protobuf \
      php8.2-xml \
      php8.2-xmlrpc \
      php8.2-zip \
      php8.2-zstd \
      rcs \
      sudo \
      libonig-dev \
      libzip-dev \
    ; \
    mkdir -p /var/www && mkdir /usr/src/default \
    ; \
    curl https://repository.monarx.com/repository/monarx/publickey/monarxpub.gpg | gpg -o /usr/share/keyrings/monarx-archive-keyring.gpg --dearmor \
    && echo "deb [signed-by=/usr/share/keyrings/monarx-archive-keyring.gpg] https://repository.monarx.com/repository/ubuntu-jammy/ jammy main" > /etc/apt/sources.list.d/monarx.list \
    ; \
    apt-get update \
    && apt-get -y install monarx-agent monarx-protect \
    ; \
    mkdir -p /etc/service/php-fpm \
        && mkdir -p /etc/service/postfix \
        && mkdir -p /etc/service/postfix-log \
        && mkdir -p /etc/service/monarx \
        && mkdir -p /etc/service/nginx \
        && mkdir -p /usr/src/default \
    ; \
    apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN cd /usr/src; \
    git clone https://github.com/phpredis/phpredis.git \
        && cd /usr/src/phpredis \
        && git checkout $(curl -fs -L https://api.github.com/repos/phpredis/phpredis/releases/latest | grep -i "tag_name" | awk -F '"' '{print $4}') \
        && phpize \
        && ./configure --enable-redis-igbinary --enable-redis-zstd --with-liblzf --enable-redis-msgpack \
        && make \
        && make install \
        && echo "extension=redis.so" > /etc/php/8.2/mods-available/redis.ini \
        && /usr/sbin/phpenmod redis \
    ; \
    RELAY_VERSION=$(curl -fs -L https://builds.r2.relay.so/meta/latest | awk -F '"' '{print $1}') \
        && wget -O /tmp/relay.tar.gz "https://builds.r2.relay.so/$RELAY_VERSION/relay-$RELAY_VERSION-php8.2-debian-x86-64%2Blibssl3.tar.gz" \
        && tar -xzf /tmp/relay.tar.gz -C /usr/src \
        && mv /usr/src/relay-* /usr/src/relay \
        && rm /tmp/relay.tar.gz

ADD conf/logrotate.conf /etc/logrotate.d/nginx-computestacks
ADD migrate_php.sh /usr/local/bin/migrate_php_version
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/site.conf /etc/nginx/sites-available/default
ADD conf/fpm-pool.conf /etc/php/8.2/fpm/pool.d/www.conf
ADD startup/ /etc/my_init.d/
ADD services/php-fpm.sh /etc/service/php-fpm/run
ADD services/postfix-log-run.sh /etc/service/postfix-log/run
ADD services/postfix-run.sh /etc/service/postfix/run
ADD services/monarx.sh /etc/service/monarx/run
ADD services/nginx.sh /etc/service/nginx/run
ADD www/ /usr/src/default/

RUN chmod +x /etc/service/php-fpm/run \
        && chmod +x /usr/local/bin/migrate_php_version \
        && chmod +x /etc/service/postfix-log/run \
        && chmod +x /etc/service/postfix/run \
        && chmod +x /etc/service/postfix-log/run \
        && chmod +x /etc/service/monarx/run \
        && chmod +x /etc/service/nginx/run \
        && touch /etc/service/postfix/down \
        && touch /etc/service/postfix-log/down \
        && touch /etc/service/monarx/down \
        && mkdir -p /run/php \
        && rm -rf /var/www/html \
    ; \
    chmod +x /etc/my_init.d/*.sh \
    ; \
    echo "max_input_vars = 3000" >> /etc/php/8.2/fpm/php.ini \
        && echo "max_input_vars = 3000" >> /etc/php/8.2/cli/php.ini \
        && sed -i 's/memory_limit = .*/memory_limit = 192M/g' /etc/php/8.2/fpm/php.ini \
        && sed -i 's/memory_limit = .*/memory_limit = 192M/g' /etc/php/8.2/cli/php.ini \
        && sed -i 's/upload_max_filesize = .*/upload_max_filesize = 250M/g' /etc/php/8.2/fpm/php.ini \
        && sed -i 's/max_input_time = .*/max_input_time = 300/g' /etc/php/8.2/fpm/php.ini \
        && sed -i 's/max_input_time = .*/max_input_time = 300/g' /etc/php/8.2/cli/php.ini \
        && sed -i 's/max_execution_time = .*/max_execution_time = 300/g' /etc/php/8.2/fpm/php.ini \
        && sed -i 's/max_execution_time = .*/max_execution_time = 300/g' /etc/php/8.2/cli/php.ini \
        && echo "date.timezone = 'UTC'" >> /etc/php/8.2/fpm/php.ini \
        && echo "date.timezone = 'UTC'" >> /etc/php/8.2/cli/php.ini \
        && echo "post_max_size = 250M" >> /etc/php/8.2/fpm/php.ini \
    ; \
    usermod -u 1001 www-data && groupmod -g 1001 www-data

ADD conf/monarx-agent.conf /etc/monarx-agent.conf

EXPOSE 80