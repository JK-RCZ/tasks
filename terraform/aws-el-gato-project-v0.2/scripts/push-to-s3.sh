#!/bin/bash

sudo mkdir -p /wordpress-log/
sudo mkdir -p /mariadb-backup/
sudo docker cp wordpress-webserver:/var/www/localhost/htdocs/wp-content/debug.log /wordpress-log/
sudo docker cp wordpress-webserver:/mariadb-backup/. /mariadb-backup/
sudo tar -czf mariadb-backups.tar.gz --absolute-names /mariadb-backup/
sudo  mv mariadb-backups.tar.gz /mariadb-backup/
aws s3 mv /mariadb-backup/mariadb-backups.tar.gz s3://lil-pretty-bucket/mariadb-backup/mariadb-backups.tar.gz
aws s3 cp --recursive /wordpress-log/ s3://lil-pretty-bucket/wordpress-log/