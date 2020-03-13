FROM php:7.3-apache

## Basic tools
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y bash \
    apt-utils \
    curl \
    wget \
    ca-certificates \
    nano \
    git \
    unzip \
    libicu-dev \
    zlib1g-dev \
    libxml2 \
    libxml2-dev \
    libreadline-dev \
    libzip-dev \
    gnupg \
    && docker-php-ext-install \
    opcache \
    intl \
    zip \
    && rm -fr /tmp/* && \
    rm -rf /var/list/apt/* && \
    rm -r /var/lib/apt/lists/* && \
    apt-get clean

## Composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN echo "memory_limit = -1" > /usr/local/etc/php/conf.d/memory_limit.ini; \
    curl -sS http://getcomposer.org/installer | php -- --filename=composer && chmod a+x composer  && mv composer /usr/local/bin/composer; \
    echo 'export PATH=~/.composer/vendor/bin:$PATH' >> ~/.bashrc; \
    composer global require hirak/prestissimo

## NodeJS
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash && apt-get install -y nodejs

## Confirm installation
RUN node -v; npm -v
## End NODEJS

## Yarn
RUN npm install yarn -g; yarn --version

## Apache
RUN a2enmod rewrite ssl

WORKDIR /var/www/symfony

EXPOSE 80
