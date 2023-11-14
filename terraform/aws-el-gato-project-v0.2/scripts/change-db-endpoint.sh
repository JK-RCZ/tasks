#!/usr/bin/env bash

db_endpoint=$(cat /tasks/terraform/aws-el-gato-project-v0.2/db_endpoint.txt)
path_to_docker_compose_file="/tasks/terraform/aws-el-gato-project-v0.2/docker/LAMP/docker-compose.yml"


sed -i "s|- PMA_HOST=.*$|- PMA_HOST=${db_endpoint}|" ${path_to_docker_compose_file}
rm /tasks/terraform/aws-el-gato-project-v0.2/db_endpoint.txt