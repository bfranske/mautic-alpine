FROM alpine:3.19
LABEL maintainer="ben.mm@franske.com"
LABEL description="Alpine based image for Mautic."

# Setup apache and php
RUN apk --no-cache --update \
    add apache2 \
    curl \
    php81 \
    php81-apache2 \
    php81-ctype \
    php81-iconv \
    php81-mbstring \
    php81-session \
    php81-simplexml \
    php81-tokenizer \
    php81-xml \
    php81-intl \
    php81-curl \
    php81-imap \
    php81-openssl \
    php81-fileinfo \
    php81-zip \
    php81-mysqli \
    php81-pdo \
    php81-pdo_mysql \
    php81-xsl \
    php81-posix \
    php81-phar \
    php81-bcmath \
    php81-gd \
    php81-xmlreader \
    php81-xmlwriter \
    npm \
    bash \
    wget \
    unzip \
    runuser \
    git

#Setup php command
RUN ln -s /usr/bin/php81 /usr/bin/php

#Add PHP Option Override
#RUN sed -i '/max_execution_time =/s/[0-9][0-9]*$/240/g' /etc/php81/php.ini
#RUN sed -i '/memory_limit =/s/[0-9][0-9][0-9]M*$/512M/g' /etc/php81/php.ini
COPY docker-buildfiles/mautic-php.ini /etc/php81/conf.d/

#Enable mod rewrite
RUN sed -i '/LoadModule rewrite_module/s/^#//g' /etc/apache2/httpd.conf

# INSTALL COMPOSER
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer

#RUN wget https://github.com/mautic/mautic/releases/download/5.0.2/5.0.2.zip
#RUN chown -R apache:apache /var/www/mautic
#RUN runuser -u apache -- unzip 5.0.2.zip -d /var/www/mautic/


COPY docker-buildfiles/mautic-apache.conf /etc/apache2/conf.d/

COPY docker-buildfiles/entrypoint.sh /
RUN chmod u+x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]