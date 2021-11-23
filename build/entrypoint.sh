#!/bin/bash

if [ "$INIT" ]; then
    echo "exec command : composer install"
    cd /var/www/offerbox-v2 && /usr/bin/composer install
    mkdir -p /var/www/offerbox-v2/storage/logs
    chmod 777 /var/www/offerbox-v2/bootstrap/cache
    chmod 777 /var/www/offerbox-v2/storage/app/public
    chmod 777 /var/www/offerbox-v2/storage/framework/cache
    chmod 777 /var/www/offerbox-v2/storage/framework/sessions
    chmod 777 /var/www/offerbox-v2/storage/framework/views
    chmod 777 /var/www/offerbox-v2/storage/logs
fi

if [ "$APP_ENV" = "production" ]; then
    mv /usr/local/etc/php-fpm.d/www.conf.prod /usr/local/etc/php-fpm.d/www.conf
    DD_TRACE_PHP_URL="https://github.com/$( curl -s -L https://github.com/DataDog/dd-trace-php/releases/latest | grep -o '/DataDog/dd-trace-php/releases/download/.*/.*.deb' )"
    curl -sSL -o datadog-php-tracer.deb $DD_TRACE_PHP_URL
    dpkg -i datadog-php-tracer.deb
fi

php-fpm
