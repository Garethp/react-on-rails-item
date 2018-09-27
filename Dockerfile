# Dockerfile for PHP 7.2 with PHP-FPM running on nginx and also PHP CLI support

FROM ubuntu:16.04
ENV REFRESHED_AT=2018-08-17
ENV PGPASSWORD=secret
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp

RUN apt-get update -y

RUN apt-get install -y --no-install-recommends \
    curl \
    software-properties-common \
    g++ \
    make

RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php \
    && LC_ALL=C.UTF-8 add-apt-repository -y ppa:pinepain/php \
    && apt update

RUN apt install -y --no-install-recommends \
    libv8-6.6 libv8-6.6-dev \
    git php7.2 php7.2-dev php-pear php7.2-zip

RUN pecl config-set php_ini /etc/php/7.2/cli/php.ini \
    && pear config-set php_ini /etc/php/7.2/cli/php.ini

RUN yes '/opt/libv8-6.6/' | pecl install v8js

# Install packages and PHP extensions
#RUN apt-get update \
#    && apt-get upgrade -y \
#    && apt-get install  -y --no-install-recommends ca-certificates software-properties-common python-software-properties \
#    && apt-get install -y tzdata \
#    && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php \
#    && LC_ALL=C.UTF-8 add-apt-repository ppa:pinepain/libv8 \
#    && apt-get update \
#    && apt-get install --no-install-recommends -y \
#           wget curl openssl build-essential \
#           php7.2 php-pear php7.2-cli php7.2-fpm php7.2-apcu php7.2-bcmath php7.2-common php7.2-curl php7.2-igbinary \
#           php7.2-intl php7.2-json php7.2-mbstring php7.2-readline php7.2-redis php7.2-sqlite3 php7.2-xdebug php7.2-zip \
#           php7.2-dev libv8-6.4 libv8-6.4-dev
#
## Install / compile v8js
#RUN echo '/opt/libv8-6.4' | pecl install v8js \
#    && mkdir -p /etc/php/7.2/mods-enabled \
#    && echo 'extension=v8js.so' > /etc/php/7.2/mods-available/v8js.ini \
#    && ln -s /etc/php/7.2/mods-available/v8js.ini /etc/php/7.2/cli/conf.d/20-v8js.ini \
#    && ln -s /etc/php/7.2/mods-available/v8js.ini /etc/php/7.2/fpm/conf.d/20-v8js.ini
#
## Clean up apt
#RUN apt-get -y autoremove \
#    && apt-get clean all \
#    && apt-get autoclean \
#    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install composer into this container
RUN curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/da290238de6d63faace0343efbdd5aa9354332c5/web/installer \
 && php -r " \
    \$signature = '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410'; \
    \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer  \
 && composer --ansi --version --no-interaction \
 && rm -rf /tmp/* /tmp/.htaccess

# Configure and secure PHP
# COPY src/Resources/docker/php-fpm/ubuntu/php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf
# COPY src/Resources/docker/php-fpm/ubuntu/www.conf /etc/php/7.2/fpm/pool.d/www.conf

# setup custom PHP ini files
# COPY src/Resources/docker/php-fpm/custom.ini /etc/php/7.2/mods-available/custom.ini

# app will be mounted here, so set this as our working directory
WORKDIR /app

# run setup scripts to ensure environment is OK
EXPOSE 9000

COPY "docker-entrypoint.sh" "/docker-entrypoint.sh"
CMD [ "/docker-entrypoint.sh"]
