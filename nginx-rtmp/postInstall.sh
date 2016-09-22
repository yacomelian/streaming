#!/bin/bash

service nginx start

# PRODUCTION
#/opt/letsencrypt/letsencrypt-auto certonly --agree-tos --text --non-interactive --register-unsafely-without-email -a webroot --webroot-path=/var/www/ -d myurl.mydomain
# DEVELOPMENT
#/opt/letsencrypt/letsencrypt-auto certonly --test-cert --agree-tos --text --non-interactive --register-unsafely-without-email -a webroot --webroot-path=/var/www/ -d myurl.mydomain

cp /usr/local/nginx/conf/nginx.conf.new /usr/local/nginx/conf/nginx.conf

service nginx restart
