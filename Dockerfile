FROM bmoorman/alpine:armhf AS builder

WORKDIR /opt/memcached

RUN apk add --no-cache --virtual .build-deps \
    build-base \
    libevent-dev \
 && wget -q -O - "http://memcached.org/latest" | tar xz --strip-components 1 \
 && ./configure && make \
 && apk del --no-cache .build-deps

FROM bmoorman/alpine:armhf

ENV HTTPD_SERVERNAME="localhost" \
    OPENER_PIN="23:high" \
    SENSOR_PIN="24:in" \
    LAT="40.760779" \
    LONG="-111.891047"

RUN apk add --no-cache \
    apache2 \
    apache2-ctl \
    apache2-ssl \
    curl \
    libevent \
    php7 \
    php7-apache2 \
    php7-curl \
    php7-json \
    php7-memcached \
    php7-session \
    php7-sqlite3 \
    php7-sysvmsg \
 && useradd -c memcached -r -s /sbin/nologin memcached

COPY --from=builder /opt/memcached/memcached /usr/bin
COPY apache2/ /etc/apache2/
COPY htdocs/ /var/www/localhost/htdocs/
COPY bin/ /usr/local/bin/

VOLUME /config

EXPOSE 8440

CMD ["/etc/apache2/start.sh"]

HEALTHCHECK --interval=60s --timeout=5s CMD curl --silent --location --fail http://localhost:80/ > /dev/null || exit 1
