FROM php:8.0-fpm
SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]

# timezone environment
ENV TZ=UTC \
    # locale
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    # composer environment
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/composer \
    # Unit test
    TESTING_DB_HOST=mysql \
    TESTING_DB_PORT=3306 \
    TESTING_DB_DATABASE=offerboxtest \
    TESTING_DB_USERNAME=root \
    TESTING_DB_PASSWORD=rara6y

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN apt-get update && \
    apt-get install -y \
        git \
        vim \
        libicu-dev \
        libonig-dev \
        libjpeg-dev \
        libpng-dev \
        libzip-dev \
        unzip \
        locales \
        default-mysql-client \
        default-libmysqlclient-dev \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8 && \
    localedef -f UTF-8 -i en_US en_US.UTF-8

RUN pecl install redis
RUN pecl install -o -f xdebug \
  && docker-php-ext-enable xdebug

RUN docker-php-ext-configure gd --with-jpeg=/usr/include/ && \
        docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install \
        mysqli \
        pdo_mysql
RUN docker-php-ext-enable \
        redis

COPY ./docker/v2_php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/v2_php/www.conf.prod /usr/local/etc/php-fpm.d/www.conf.prod
COPY ./docker/v2_php/php.ini /usr/local/etc/php/php.ini

RUN mkdir -p /var/www/offerbox-v2
ADD ./offerbox-v2 /var/www/offerbox-v2/
ADD ./share_module /var/www/share_module/

WORKDIR /var/www/offerbox-v2

# コンテナ起動時の処理は全て下記のファイルで行うこと
# 自動起動等も下記ファイル内で記述
COPY ./docker/v2_php/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
CMD ["/entrypoint.sh"]
