#!/usr/bin/env bash
path_to_wordpress_template="/tmp/wp-config.php"
path_to_wordpress_root="/var/www/localhost/htdocs/wp-config.php"
db_name="wordpress"
db_user="henry"
db_host="db"
db_pass="any"

cp ${path_to_wordpress_template} ${path_to_wordpress_root}
sed -i "s|define( 'DB_NAME'.*$|define( 'DB_NAME', '${db_name}');|" ${path_to_wordpress_root}
sed -i "s|define( 'DB_USER'.*$|define( 'DB_USER', '${db_user}');|" ${path_to_wordpress_root}
sed -i "s|define( 'DB_PASSWORD'.*$|define( 'DB_PASSWORD', '${db_pass}');|" ${path_to_wordpress_root}
sed -i "s|define( 'DB_HOST'.*$|define( 'DB_HOST', '${db_host}' );|" ${path_to_wordpress_root}