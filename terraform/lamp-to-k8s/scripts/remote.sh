#!/bin/bash

# Description ----------------------------------------------------------------------------------------------------------------
# This script:
#   - clones git repository, containing k8s manifest files and Dockerfiles for LAP, into temporary_folder; 
#   - builds docker images for LAP manifest files;
#   - copies all LAP manifest files to deployment_folder;
#   - applies LAP manifest files. 
# ----------------------------------------------------------------------------------------------------------------------------

# Local Variables ------------------------------------------------------------------------------------------------------------
deployment_folder=/lap_deployment
temporary_folder=/tmp
git_repository_url=https://github.com/JK-RCZ/tasks.git
relative_target_folder=tasks/terraform/lamp-to-k8s/docker-lamp
git_repository_branch_name=lamp_to_k8s
cache_deployment_manifest=cache-deployment.yaml
cache_service_manifest=cache-service.yaml
nginx_deployment_manifest=nginx-deployment.yaml
nginx_service_manifest=nginx-service.yaml
phpmyadmin_deployment_manifest=phpmyadmin-deployment.yaml
wordpress_deployment_manifest=wordpress-deployment.yaml
# ----------------------------------------------------------------------------------------------------------------------------

# Action ---------------------------------------------------------------------------------------------------------------------
mkdir -p $deployment_folder
mkdir -p $temporary_folder
cd $temporary_folder
git clone --branch  $git_repository_branch_name $git_repository_url
cd $relative_target_folder
docker-compose build
cp *.yaml $deployment_folder
kubectl apply -f $deployment_folder/$cache_deployment_manifest
kubectl apply -f $deployment_folder/$cache_service_manifest
kubectl apply -f $deployment_folder/$nginx_deployment_manifest
kubectl apply -f $deployment_folder/$nginx_service_manifest
kubectl apply -f $deployment_folder/$phpmyadmin_deployment_manifest
kubectl apply -f $deployment_folder/$wordpress_deployment_manifest
# ----------------------------------------------------------------------------------------------------------------------------