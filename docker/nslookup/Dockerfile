FROM ubuntu
ENV SITE 0
RUN apt-get update && apt-get install -y \
  apache2 \
  dnsutils \
  && service apache2 start
  # && service apache2 enable
  # && mkdir /kkk 
COPY    site.ip.sh /kkk/site.ip.sh
ENTRYPOINT /kkk/site.ip.sh

