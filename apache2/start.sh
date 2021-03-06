#!/bin/sh
chown apache: /config

if [ ! -d /config/sessions ]; then
    install -o apache -g apache -d /config/sessions
fi

if [ ! -d /config/httpd/ssl ]; then
    install -d /config/httpd/ssl
    ln -sf /etc/ssl/apache2/server.pem /config/httpd/ssl/garage.crt
    ln -sf /etc/ssl/apache2/server.key /config/httpd/ssl/garage.key
fi

pidfile=/var/run/apache2/httpd.pid

if [ -f ${pidfile} ]; then
    pid=$(cat ${pidfile})

    if [ ! -d /proc/${pid} ] || [ -d /proc/${pid} -a $(basename $(readlink /proc/${pid}/exe)) != 'httpd' ]; then
        rm ${pidfile}
    fi
elif [ ! -d /var/run/apache2 ]; then
    install -d /var/run/apache2
fi

for PIN in "${OPENER_PIN} high" "${SENSOR_PIN} in"; do
    set -- ${PIN}
    if [ ${#} -eq 2 ]; then
        if [ ! -L /sys/class/gpio/gpio${1} ]; then
            echo ${1} > /sys/class/gpio/export
        fi

        echo ${2} > /sys/class/gpio/gpio${1}/direction
    fi
done

groupadd -fg $(stat -c '%g' /sys/class/gpio/) gpio
usermod -aG gpio apache

$(which su) \
    -c $(which schedule.php) \
    -s /bin/sh \
    apache &

sleep 1

$(which su) \
    -c $(which notifications.php) \
    -s /bin/sh \
    apache &

sleep 1

exec $(which apachectl) \
    -D FOREGROUND \
    -D ${HTTPD_SSL:-SSL} \
    -D ${HTTPD_REDIRECT:-REDIRECT}
