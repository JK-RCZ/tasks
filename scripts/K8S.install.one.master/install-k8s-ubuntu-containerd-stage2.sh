#!/usr/bin/env bash

#------------------------------------------------------------------------------------------------------------
# Run this script on MASTER NODE ONLY 
# Following instructions are taken from sources:
# - https://v1-27.docs.kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
#------------------------------------------------------------------------------------------------------------

echo -e "This script will initialize and configure Kubeadm\n
You should run this script with SUDO priviliges\n
RUN THIS SCRIPT ON MASTER NODE ONLY!!!\n\n
If it is OK, enter API IP address (if you're not sure about it - press Ctrl+c to exit):"
read -r api_ip_address

kubeadm init --pod-network-cidr=10.244.0.0./16 --apiserver-advertise-address="$api_ip_address"

echo "\nREAD THE INSTRUCTIONS ABOVE CAREFULLY!\n
You should create directory at home folder at master node, copy config there and change it's ownership\n
Then you should run the depicted above command on each of your worker nodes!"
#mkdir -p $HOME/.kube
#cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#chown $(id -u):$(id -g) $HOME/.kube/config


