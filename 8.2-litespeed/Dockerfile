# Local dev: docker run --rm -it -e LS_ADMIN_PW=changeme -p 3000:80 -p 7080:7080 cmptstks/php:8.2-litespeed /sbin/my_init -- bash -l  
FROM ghcr.io/computestacks/cs-docker-base:ubuntu-jammy

LABEL maintainer="https://computestacks.com"
LABEL org.opencontainers.image.authors="https://computestacks.com"
LABEL org.opencontainers.image.source="https://github.com/ComputeStacks/cs-docker-php/tree/main/8.2-litespeed"
LABEL org.opencontainers.image.url="https://github.com/ComputeStacks/cs-docker-php/tree/main/8.2-litespeedd"
LABEL org.opencontainers.image.title="PHP 8.2 with OpenLiteSpeed"

COPY root/monarx-agent.sh /tmp/
COPY root/postfix-run.sh /tmp/
COPY root/postfix-log-run.sh /tmp/
COPY root/40-ls-config.sh /etc/my_init.d/
COPY root/50-entrypoint.sh /etc/my_init.d/
COPY root/51-ls-env.sh /etc/my_init.d/
COPY root/60-litespeed-upgrade.sh /etc/my_init.d/
COPY root/60-php-config.sh /etc/my_init.d/
COPY root/61-newrelic.sh /etc/my_init.d/
COPY root/90-litespeed-password.sh /etc/my_init.d/
COPY root/91-litespeed-config.sh /etc/my_init.d/
COPY root/90-monarx-entry.sh /etc/my_init.d/
COPY root/90-postfix.sh /etc/my_init.d/
COPY root/90-relay.sh /etc/my_init.d/
COPY root/99-litespeed.sh /etc/my_init.d/
COPY root/migrate_php.sh /usr/local/bin/migrate_php_version

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
    ; \
    echo "postfix postfix/mailname string docker.local" | debconf-set-selections \
    && echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections \
    && apt-get -y install postfix postfix-pcre libsasl2-modules \
    ; \
    wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debain_repo.sh | bash \
    ; \
    apt-get install -y --no-install-recommends \
      lsphp82 \
      lsphp82-common \
      lsphp82-curl \
      lsphp82-dev \
      lsphp82-imap \
      lsphp82-imagick \
      lsphp82-intl \
      lsphp82-memcached \
      lsphp82-msgpack \
      lsphp82-mysql \
      lsphp82-opcache \
      lsphp82-pgsql \
      lsphp82-sqlite3 \
      lsphp82-modules-source \
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
    ln -s /usr/local/lsws/lsphp82/bin/phpize /usr/local/bin/phpize; \
    ln -s /usr/local/lsws/lsphp82/bin/php-config /usr/local/bin/php-config \
    ; \
    curl https://repository.monarx.com/repository/monarx/publickey/monarxpub.gpg | gpg -o /usr/share/keyrings/monarx-archive-keyring.gpg --dearmor \
    && echo "deb [signed-by=/usr/share/keyrings/monarx-archive-keyring.gpg] https://repository.monarx.com/repository/ubuntu-jammy/ jammy main" > /etc/apt/sources.list.d/monarx.list \
    ; \
    apt-get update \
    && apt-get -y install monarx-agent monarx-protect \
    ; \
    mkdir -p /etc/service/monarx \
    && mv /tmp/monarx-agent.sh /etc/service/monarx/run \
    && touch /etc/service/monarx/down \
    && chmod +x /etc/service/monarx/run \
    && chmod +x /usr/local/bin/migrate_php_version \
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
        && echo "extension=redis.so" > /usr/local/lsws/lsphp82/etc/php/8.2/mods-available/redis.ini \
    ; \
    RELAY_VERSION=$(curl -fs -L https://builds.r2.relay.so/meta/latest | awk -F '"' '{print $1}') \
        && wget -O /tmp/relay.tar.gz "https://builds.r2.relay.so/$RELAY_VERSION/relay-$RELAY_VERSION-php8.2-debian-x86-64%2Blibssl3.tar.gz" \
        && tar -xzf /tmp/relay.tar.gz -C /usr/src \
        && mv /usr/src/relay-* /usr/src/relay \
        && sed -i "s/00000000-0000-0000-0000-000000000000/$(cat /proc/sys/kernel/random/uuid)/" /usr/src/relay/relay-pkg.so \
        && rm /tmp/relay.tar.gz \
    ; \
    wget -O /tmp/newrelic.tar.gz https://download.newrelic.com$(curl -fs -L https://download.newrelic.com/php_agent/release/ | grep -Eo "/\S+-linux.tar.gz\"" | tr -d '"') \
        && tar -xzvf /tmp/newrelic.tar.gz -C /usr/src \
        && mv /usr/src/newrelic-php5-*-linux /usr/src/newrelic \
        && mv /usr/src/newrelic/daemon/newrelic-daemon.x64 /usr/bin/newrelic-daemon \
        && chown root: /usr/bin/newrelic-daemon \
        && mkdir -p /var/log/newrelic \
        && touch /var/log/newrelic/newrelic-daemon.log \
        && chmod 666 /var/log/newrelic/newrelic-daemon.log \
        && touch /var/log/newrelic/php_agent.log \
        && chmod 644 /var/log/newrelic/php_agent.log \
        && rm /tmp/newrelic.tar.gz

COPY root/www /usr/src/default/
COPY root/vhosts /usr/local/lsws/conf/vhosts/

RUN mkdir -p /etc/service/postfix \
    && mkdir -p /etc/service/postfix-log \
    && mv /tmp/postfix-run.sh /etc/service/postfix/run \
    && mv /tmp/postfix-log-run.sh /etc/service/postfix-log/run \
    && chmod +x /etc/service/postfix/run \
    && chmod +x /etc/service/postfix-log/run \
    && touch /etc/service/postfix/down \
    && touch /etc/service/postfix-log/down \
    ; \
    cd /usr/local/lsws/fcgi-bin/ \
    && rm lsphp \
    && ln -s /usr/local/lsws/lsphp82/bin/lsphp lsphp \
    && cd /usr/local/lsws/lsphp82/bin \
    && chmod +x /etc/my_init.d/*.sh \
    && rm /usr/local/lsws/conf/httpd_config.conf \
    ; \
    mv /usr/local/lsws /usr/src \
    && chown -R lsadm:lsadm /usr/src/lsws/conf \
    && echo "max_input_vars = 3000" >> /usr/src/lsws/lsphp82/etc/php/8.2/litespeed/php.ini \
    && sed -i 's/memory_limit = .*/memory_limit = 192M/g' /usr/src/lsws/lsphp82/etc/php/8.2/litespeed/php.ini \
    && sed -i 's/upload_max_filesize = .*/upload_max_filesize = 250M/g' /usr/src/lsws/lsphp82/etc/php/8.2/litespeed/php.ini \
    && sed -i 's/max_input_time = .*/max_input_time = 300/g' /usr/src/lsws/lsphp82/etc/php/8.2/litespeed/php.ini \
    && sed -i 's/max_execution_time = .*/max_execution_time = 300/g' /usr/src/lsws/lsphp82/etc/php/8.2/litespeed/php.ini \
    && echo "date.timezone = 'UTC'" >> /usr/src/lsws/lsphp82/etc/php/8.2/litespeed/php.ini \
    && echo "post_max_size = 250M" >> /usr/src/lsws/lsphp82/etc/php/8.2/litespeed/php.ini \
    ; \
    usermod -u 1001 www-data && groupmod -g 1001 www-data

COPY root/lswsctrl.sh /usr/local/bin/lswsctrl
COPY root/httpd_config.conf /usr/src/lsws/conf/httpd_config.conf
COPY root/monarx-agent.conf /etc/monarx-agent.conf

EXPOSE 80 7080