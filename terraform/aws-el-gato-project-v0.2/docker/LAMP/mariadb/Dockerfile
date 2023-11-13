FROM alpine:3.18.3
COPY mariadb.sh /kkk/mariadb.sh
CMD ["/bin/sh"]
RUN apk update && apk upgrade && apk add \
    bash \
    mariadb 
ENTRYPOINT ["/kkk/mariadb.sh"]