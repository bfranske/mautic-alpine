#!/bin/bash

## entry point file, needed to be able to pass ENV vars from docker-compose.yml to the containers.

touch /entrypointhasrunonce

crond
/usr/sbin/httpd -D FOREGROUND