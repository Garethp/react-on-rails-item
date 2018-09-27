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

# app will be mounted here, so set this as our working directory
WORKDIR /app

# run setup scripts to ensure environment is OK
EXPOSE 9000

COPY "docker-entrypoint.sh" "/docker-entrypoint.sh"
CMD [ "/docker-entrypoint.sh"]
