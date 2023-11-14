#!/usr/bin/env bash

db_endpoint=$(cat ../db_endpoint.txt)
path_to_docker_compose_file="../docker/LAMP/docker-compose.yml"

echo "${db_endpoint}"
sed -i "s|- PMA_HOST=.*$|- PMA_HOST=${db_endpoint}|" ${path_to_docker_compose_file}
