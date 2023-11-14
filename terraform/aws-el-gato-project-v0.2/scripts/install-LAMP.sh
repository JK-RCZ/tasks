#!/usr/bin/env bash

# FOR SUSE-----------------------------------------
#sudo zypper refresh
#sudo zypper install -y git
#sudo SUSEConnect --product PackageHub/15.5/x86_64
#sudo zypper install -y docker-compose
#sudo systemctl start docker
#git clone https://github.com/JK-RCZ/tasks.git
#cd /tasks/docker/LAMP/
#sudo docker-compose up -d
# FOR SUSE------------------------------------------


sudo yum update
sudo yum install -y git
sudo yum install -y docker
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo systemctl start docker
git clone https://github.com/JK-RCZ/tasks.git
/usr/bin/bash  /tasks/terraform/aws-el-gato-project-v0.2/scripts/change-db-endpoint.sh
cd /tasks/terraform/aws-el-gato-project-v0.2/docker/LAMP/
sudo docker-compose up -d