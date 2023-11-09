#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y apache2
sudo apt-get install -y php libapache2-mod-php php-mysql
sudo apt-get install -y php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
mkdir -p /usr/share/webapps/
cd /usr/share/webapps/
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
rm latest.tar.gz
rm /var/www/html/index.html
cp -a /usr/share/webapps/wordpress/. /var/www/html/
sudo chown -R www-data:www-data /var/www/html/