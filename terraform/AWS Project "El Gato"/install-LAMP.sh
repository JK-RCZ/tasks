#!/usr/bin/env bash

sudo zypper refresh
sudo zypper install -y git
sudo SUSEConnect --product PackageHub/15.5/x86_64
sudo zypper install -y docker-compose
sudo systemctl start docker
git clone https://github.com/JK-RCZ/tasks.git
cd /tasks/docker/LAMP/
sudo docker-compose up -d
