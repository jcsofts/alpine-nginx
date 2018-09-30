FROM alpine:3.8


RUN apk update && \
    apk add bash nginx && \
	rm -rf /var/cache/apk/* && \
	mkdir -p /etc/nginx/sites-available/ && \
	mkdir -p /etc/nginx/sites-enabled/ && \
	mkdir -p /etc/nginx/ssl/ && \
	rm -Rf /var/www/* && \
	mkdir -p /var/www/html/ 


# nginx site conf
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/conf.d/ /etc/nginx/sites-available/


# Add Scripts
COPY scripts/ /usr/local/bin/
RUN chmod 755 /usr/local/bin/start.sh && \
	ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

# copy in code
COPY src/ /var/www/html/
# ADD errors/ /var/www/errors


EXPOSE 443 80

CMD ["/usr/local/bin/start.sh"]