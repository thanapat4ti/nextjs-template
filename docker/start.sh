#!/bin/bash

nginx -g "daemon off;" 
if [ ! -f /etc/letsencrypt/live/${APP_DOMAIN_NAME} ]; then
    certbot certonly --webroot -w /usr/app/public/ -n -d ${APP_DOMAIN_NAME} --agree-tos --email ${APP_EMAIL}
else
    certbot renew
fi
cp /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
nginx -s reload

echo '0 12 * * * (/usr/bin/certbot renew && nginx -s reload)' | crontab

pm2-runtime start npm -- start