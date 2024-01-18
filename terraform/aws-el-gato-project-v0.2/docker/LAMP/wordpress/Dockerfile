FROM alpine:3.18.3
RUN apk update && apk upgrade && apk add \
    apache2 \
    apache2-ctl \
    bash \ 
    php82 \ 
    php82-mysqli \
    mariadb-client \
    php82-apache2 \
    redis \
    curl
COPY change-wp-config.sh /tmp/change-wp-config.sh
COPY wp-config.php /tmp/wp-config.php
COPY generate-wp-errors.sh /etc/periodic/15min/generate-wp-errors.sh
COPY mysql-dump.sh /etc/periodic/15min/mysql-dump.sh
RUN mkdir -p /usr/share/webapps/ && cd /usr/share/webapps/ \
    && wget https://wordpress.org/latest.tar.gz \
    && tar -xzvf latest.tar.gz \
    && rm latest.tar.gz \
    && rm /var/www/localhost/htdocs/index.html \
    && cp -a /usr/share/webapps/wordpress/. /var/www/localhost/htdocs/ \
    && chown -R apache:apache /var/www/localhost/htdocs/ \
    && chmod 755 /var/www/localhost/htdocs/ \
    && echo "ServerName localhost" >> /etc/apache2/httpd.conf \
    && chmod 755 /tmp/change-wp-config.sh \
    && chmod 755 /etc/periodic/15min/generate-wp-errors.sh \
    && chmod 755 /etc/periodic/15min/mysql-dump.sh \
    && /tmp/change-wp-config.sh 
CMD ( crond -f -l 8 & ) && httpd -D FOREGROUND

