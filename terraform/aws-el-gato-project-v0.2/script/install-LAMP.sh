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
curl -s https://api.github.com/repos/docker/compose/releases/latest \
  | grep browser_download_url \
  | grep docker-compose-linux-x86_64 \
  | cut -d '"' -f 4 \
  | wget -qi -
chmod +x docker-compose-linux-x86_64
sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose
sudo systemctl start docker
git clone https://github.com/JK-RCZ/tasks.git
cd /tasks/terraform/aws-el-gato-project-v0.2/docker/LAMP/
sudo docker-compose up -d