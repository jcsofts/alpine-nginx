FROM alpine:3.6


RUN apk update && \
    apk add nginx bash supervisor python python-dev py-pip\
    openssl-dev \
    ca-certificates certbot && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/letsencrypt/webrootauth
#    ln -s /usr/bin/php7 /usr/bin/php

ADD conf/supervisord.conf /etc/supervisord.conf

# nginx site conf
COPY conf/nginx.conf /etc/nginx/nginx.conf


# nginx site conf
RUN mkdir -p /etc/nginx/sites-available/ && \
mkdir -p /etc/nginx/sites-enabled/ && \
mkdir -p /etc/nginx/ssl/ && \
rm -Rf /var/www/* && \
mkdir -p /var/www/html/
ADD conf/conf.d/default.conf /etc/nginx/sites-available/default.conf
ADD conf/conf.d/default-ssl.conf /etc/nginx/sites-available/default-ssl.conf
RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf


# Add Scripts
ADD scripts/start.sh /start.sh
ADD scripts/pull /usr/bin/pull
ADD scripts/push /usr/bin/push
ADD scripts/letsencrypt-setup /usr/bin/letsencrypt-setup
ADD scripts/letsencrypt-renew /usr/bin/letsencrypt-renew
RUN chmod 755 /usr/bin/pull && chmod 755 /usr/bin/push && chmod 755 /usr/bin/letsencrypt-setup && chmod 755 /usr/bin/letsencrypt-renew && chmod 755 /start.sh

# copy in code
ADD src/ /var/www/html/
ADD errors/ /var/www/errors


EXPOSE 443 80

CMD ["/start.sh"]