FROM php:8.2-apache


    
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libzip-dev \
    libcurl4-openssl-dev \
    libmcrypt-dev \
    libreadline-dev


RUN docker-php-ext-install pdo_mysql zip pcntl bcmath sockets

#RUN pecl install mongodb redis
#RUN docker-php-ext-enable redis mongodb



WORKDIR /var/www/html

COPY . .

RUN composer install 


EXPOSE 80


RUN chmod -R 7777 /var/www/html/storage

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
