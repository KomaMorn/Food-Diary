FROM php:8.4-fpm-alpine

# install packages
RUN apk update && apk upgrade \
 && apk add --no-cache \
    git \
    bash \
    curl \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    freetype-dev \
    libxml2-dev \
    oniguruma-dev \
    postgresql-dev \
    zlib-dev \
    icu-dev \
    bzip2-dev \
    libzip-dev \
    libintl \
 && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
 && docker-php-ext-install -j$(nproc) \
    pdo \
    pdo_pgsql \
    mbstring \
    gd \
    zip \
    opcache \
    intl \
    bcmath \
    xml

# install xdebug
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
 && apk add --update linux-headers \
 && pecl install xdebug-3.4.0 \
 && docker-php-ext-enable xdebug \
 && apk del -f .build-deps

# install symfony cli and composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
 && curl -sS https://get.symfony.com/cli/installer | bash && mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# configure xdebug.ini
RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
 && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
 && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
 && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
 && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# configure non-root user
ENV PUID=1000
ENV PGID=1000
RUN apk --no-cache add shadow \
 && groupmod -o -g ${PGID} www-data \
 && usermod -o -u ${PUID} -g www-data www-data

# source code
WORKDIR /var/www/html
COPY . .

# change owner of source code
RUN chown -R www-data:www-data ./

USER www-data