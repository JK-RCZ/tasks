#!/bin/bash

# Prerequisites --------------------------------------------------------------------------------------------------------------
# This script clones git repository, containing k8s manifest files for LAP, into temporary_folder
# ----------------------------------------------------------------------------------------------------------------------------
# Local Variables ------------------------------------------------------------------------------------------------------------
deployment_folder=lap_deployment # folder in which all k8s config files for LAP will be situated
temporary_folder=tmp
git_repository_url=https://github.com/JK-RCZ/tasks.git
relative_working_folder=tasks/terraform/lamp-to-k8s/docker-lamp
git_repository_branch_name=lamp_to_k8s
cache_deployment_file=cache-deployment.yaml
cache_service=cache-service.yaml

# ----------------------------------------------------------------------------------------------------------------------------

# Action ---------------------------------------------------------------------------------------------------------------------
mkdir -p /$working_folder
cd /tmp
git clone --branch  $git_repository_branch_name $git_repository_url
kubectl apply -f $working_folder/$relative_working_folder/$cache_deployment_file
kubectl apply -f $working_folder/$relative_working_folder/
kubectl apply -f $working_folder/$relative_working_folder/
kubectl apply -f $working_folder/$relative_working_folder/
kubectl apply -f $working_folder/$relative_working_folder/
kubectl apply -f $working_folder/$relative_working_folder/
# ----------------------------------------------------------------------------------------------------------------------------