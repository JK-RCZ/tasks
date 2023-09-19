FROM ubuntu:22.04
ENV SITE 0
COPY    site.ip.sh /kkk/site.ip.sh 
RUN apt-get update && apt-get install -y \
  apache2 \
  dnsutils
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
#EXPOSE 80
ENTRYPOINT ["/kkk/site.ip.sh"]





