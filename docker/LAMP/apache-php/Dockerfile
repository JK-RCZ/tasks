FROM alpine:3.18.3
RUN apk update && apk upgrade && apk add \
    apache2 \
    apache2-ctl \
    bash \ 
    php82 \ 
    php82-mysqli \
    mariadb-client \
    php82-apache2
RUN echo "ServerName localhost" >> /etc/apache2/httpd.conf \
    && echo "<?php phpinfo(); ?>" > /var/www/localhost/htdocs/phpinfo.php 
CMD ["apachectl", "-D", "FOREGROUND"]

