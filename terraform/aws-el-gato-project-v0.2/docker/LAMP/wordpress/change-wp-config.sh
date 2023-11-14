#!/usr/bin/env bash
path_to_wordpress="/var/www/localhost/htdocs/"
db_name="wordpress"
db_user="henry"
db_password="any"
db_host="db"

cp ${path_to_wordpress}wp-config-sample.php ${path_to_wordpress}wp-config.php
sed -i "s|define( 'DB_NAME'.*$|define( 'DB_NAME', '${db_name}');|" ${path_to_wordpress}wp-config.php
sed -i "s|define( 'DB_USER'.*$|define( 'DB_USER', '${db_user}');|" ${path_to_wordpress}wp-config.php
sed -i "s|define( 'DB_PASSWORD'.*$|define( 'DB_PASSWORD', '${db_password}');|" ${path_to_wordpress}wp-config.php
sed -i "s|define( 'DB_HOST'.*$|define( 'DB_HOST', '${db_host}' );|" ${path_to_wordpress}wp-config.php