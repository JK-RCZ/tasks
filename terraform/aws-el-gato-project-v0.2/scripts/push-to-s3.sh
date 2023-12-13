#!/usr/bin/env bash
sudo mkdir -p /wordpress-log/
sudo mkdir -p /mariadb-backup/
sudo docker cp wordpress-webserver:/var/www/localhost/htdocs/wp-content/debug.log /wordpress-log/
sudo docker cp wordpress-webserver:/mariadb-backup/. /mariadb-backup/

