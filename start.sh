#!/bin/bash

php-fpm -R
nginx -g 'daemon off;'
