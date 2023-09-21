FROM alpine:3.18.3
ENV SITE 0
COPY    site.ip.sh /kkk/site.ip.sh 
RUN apk update && apk upgrade && apk add \
bash \
apache2 \
bind-tools \
apache2-ctl
RUN echo "ServerName localhost" >> /etc/apache2/httpd.conf
ENTRYPOINT ["/kkk/site.ip.sh"]
