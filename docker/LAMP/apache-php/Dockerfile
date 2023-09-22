FROM alpine:3.18.3
RUN apk update && apk upgrade && apk add \
    apache2 \
    apache2-ctl \
    bash \ 
    php82 \ 
    php82-mysqli \
    mariadb-client \
    php82-apache2 
RUN mkdir -p /usr/share/webapps/ && cd /usr/share/webapps/ \
    && wget https://wordpress.org/latest.tar.gz \
    && tar -xzvf latest.tar.gz \
    && rm latest.tar.gz \
    && rm /var/www/localhost/htdocs/index.html \
    && cp -a /usr/share/webapps/wordpress/. /var/www/localhost/htdocs/
RUN echo "ServerName localhost" >> /etc/apache2/httpd.conf
CMD ["apachectl", "-D", "FOREGROUND"]

