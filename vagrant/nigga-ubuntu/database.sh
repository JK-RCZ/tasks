#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y mysql-server
sudo mysql -e "CREATE DATABASE wordpress;"
sudo mysql -e "CREATE USER wordpress identified by 'simple';"
sudo mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress';"
sudo mysql -e "FLUSH PRIVILEGES;"

sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart
