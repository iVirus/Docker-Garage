FROM bmoorman/alpine:3.12

ENV HTTPD_SERVERNAME=localhost \
    HTTPD_PORT=8440

RUN apk add --no-cache \
    apache2 \
    apache2-ctl \
    apache2-ssl \
    curl \
    php7 \
    php7-apache2 \
    php7-curl \
    php7-json \
    php7-memcached \
    php7-redis \
    php7-session \
    php7-sqlite3 \
    php7-sysvmsg \
 && ln -sf /dev/stderr /var/log/apache2/error.log \
 && ln -sf /dev/stderr /var/log/apache2/ssl_error.log \
 && ln -sf /dev/stdout /var/log/apache2/access.log \
 && ln -sf /dev/stdout /var/log/apache2/ssl_access.log

COPY apache2/ /etc/apache2/
COPY htdocs/ /var/www/localhost/htdocs/
COPY bin/ /usr/local/bin/

VOLUME /config

EXPOSE ${HTTPD_PORT}

CMD ["/etc/apache2/start.sh"]

HEALTHCHECK --interval=60s --timeout=5s CMD /etc/apache2/healthcheck.sh || exit 1
