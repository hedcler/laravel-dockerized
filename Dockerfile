################################################################################
# Base image
################################################################################

FROM php:7-alpine

################################################################################
# Build instructions
################################################################################

# install extensions
# intl, zip, soap
RUN apk add --update --no-cache libintl icu icu-dev libxml2-dev \
    && docker-php-ext-install intl zip soap

# Remove default nginx configs.
RUN rm -f /etc/nginx/conf.d/*

# Install packages
RUN apk update && apk upgrade
RUN apk add nginx
RUN apk add supervisor
RUN apk add wget
RUN apk add git
RUN apk add curl
RUN apk add wget
RUN apk add php7
RUN apk add php7-openssl
RUN apk add php7-json
RUN apk add php7-phar
RUN apk add php7-dom
RUN apk add php7-curl
RUN apk add php7-fpm
RUN apk add php7-gd
RUN apk add php7-mcrypt
RUN apk add php7-iconv
RUN apk add php7-session
RUN apk add php7-ctype
RUN apk add php7-tokenizer

# mysqli, pdo, pdo_mysql, pdo_pgsql
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Ensure that PHP5 FPM is run as root.
RUN sed -i "s/user = www-data/user = root/g" /etc/php7/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = root/g" /etc/php7/php-fpm.d/www.conf
RUN sed -i "s#listen = 127.0.0.1:9000#listen = /var/run/php-fpm7.sock#g" /etc/php7/php-fpm.d/www.conf

# Install HHVM
# RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
# RUN echo deb http://dl.hhvm.com/debian jessie main | tee /etc/apt/sources.list.d/hhvm.list
# RUN apt-get update && apt-get install -y hhvm

# Add configuration files
COPY conf/nginx.conf /etc/nginx/
COPY conf/supervisord.conf /etc/supervisor/conf.d/
COPY conf/php.ini /etc/php7/php-fpm/conf.d/40-custom.ini

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www", "/etc/nginx/conf.d"]
WORKDIR /var/www

################################################################################
# Ports
################################################################################

EXPOSE 80 443 9000 9001

################################################################################
# Entrypoint
################################################################################

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
