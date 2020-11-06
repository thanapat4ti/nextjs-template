#!/bin/bash

if [ ! -f /etc/letsencrypt/live/${APP_DOMAIN_NAME} ]; then
    mkdir -p /etc/letsencrypt/live/${APP_DOMAIN_NAME}
    ln -s /etc/nginx/ssl/ssl.crt /etc/letsencrypt/live/${APP_DOMAIN_NAME}/fullchain.pem
    ln -s /etc/nginx/ssl/ssl.key /etc/letsencrypt/live/${APP_DOMAIN_NAME}/privkey.pem
    (sleep 60 && certbot certonly --webroot -w /usr/app/public/ -n -d ${APP_DOMAIN_NAME} --agree-tos --email ${APP_EMAIL} && nginx -s reload) &
else
    certbot renew && nginx -s reload
fi

echo '0 12 * * * (/usr/bin/certbot renew && nginx -s reload)' | crontab

pm2-runtime start npm -- start &
nginx -g "daemon off;"