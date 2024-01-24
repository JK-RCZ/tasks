FROM alpine:3.18.3
RUN apk update && apk upgrade && apk add nginx
COPY nginx.conf /etc/nginx/nginx.conf
RUN apk add bash
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
