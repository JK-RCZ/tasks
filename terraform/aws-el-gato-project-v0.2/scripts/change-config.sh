#!/usr/bin/env bash

# This script changes:
# - PhpMyAdmin database connection value in docker-compose file;
# - db_name, db_user, db_host and db_pass variable values in wordpress image script.


db_name=$(sed '1!d' /tmp/db_data.txt)
db_user=$(sed '2!d' /tmp/db_data.txt)
db_host=$(sed '3!d' /tmp/db_data.txt)
db_pass=$(sed '4!d' /tmp/db_data.txt)
lb_host=$(sed '5!d' /tmp/db_data.txt)

docker_compose_file_path="/tasks/terraform/aws-el-gato-project-v0.2/docker/LAMP/docker-compose.yml"
wordpress_image_script_path="/tasks/terraform/aws-el-gato-project-v0.2/docker/LAMP/wordpress/change-wp-config.sh"

# Changes PhpMyAdmin database connection to db_host value
sed -i "s|- PMA_HOST=.*$|- PMA_HOST=${db_host}|" ${docker_compose_file_path}
sed -i "s|- PMA_ABSOLUTE_URI=.*$|- PMA_ABSOLUTE_URI=${lb_host}|" ${docker_compose_file_path}

# Changes variables in wordpress image script
sed -i "s|db_name=.*$|db_name=${db_name}|" ${wordpress_image_script_path}
sed -i "s|db_user=.*$|db_user=${db_user}|" ${wordpress_image_script_path}
sed -i "s|db_host=.*$|db_host=${db_host}|" ${wordpress_image_script_path}
sed -i "s|db_pass=.*$|db_pass=${db_pass}|" ${wordpress_image_script_path}


