#!/usr/bin/env bash

cd /app

# run composer if vendor files not present
if [ ! -f "/app/vendor/autoload.php" ]; then
    /usr/bin/composer install

    sleep 1
fi

php index.php
