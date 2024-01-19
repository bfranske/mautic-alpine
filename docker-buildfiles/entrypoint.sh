#!/bin/bash

## entry point file, needed to be able to pass ENV vars from docker-compose.yml to the containers.

#Things to do only the first time this entrypoint runs

if [ ! -f /mautic-docker-data/entrypointrunonce ]; then
    # These things are only ever done once as the /mautic-docker-data/ directory persists on a docker volume

    # Install Mautic via composer
    chown apache:apache /var/www
    chown apache:apache /var/www/mautic
    cd /var/www/mautic
    runuser -u apache -- composer create-project mautic/recommended-project:^5 /var/www/mautic --no-interaction

    # Install Amazon Mailer
    cd /var/www/mautic
    runuser -u apache -- composer require symfony/amazon-mailer 

    # Install Doctrine Transport Database Queue
    cd /var/www/mautic
    runuser -u apache -- composer require symfony/doctrine-messenger

    touch /mautic-docker-data/entrypointrunonce
fi

# Things to do everytime the container is launched
crond
/usr/sbin/httpd -D FOREGROUND