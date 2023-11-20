FROM alpine:3.18.3

#RUN apk update && apk upgrade && apk add nginx php82 php82-fpm
#COPY nginx.conf /etc/nginx/nginx.conf
RUN apk update && apk upgrade && \
    apk add openssl curl ca-certificates && \
    printf "%s%s%s%s\n" \
    "@nginx " \
    "http://nginx.org/packages/alpine/v" \
    `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
    "/main" \
    | tee -a /etc/apk/repositories && \
    curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub && \
    mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/ &&\
    apk add nginx@nginx &&\
    apk add nginx-module-image-filter@nginx nginx-module-njs@nginx
RUN apk add bash openrc 

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
