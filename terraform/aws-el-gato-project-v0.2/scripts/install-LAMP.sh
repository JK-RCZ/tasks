#!/usr/bin/env bash

echo "${db_name}" > /tmp/db_data.txt
echo "${db_user}" >> /tmp/db_data.txt
echo "${db_host}" >> /tmp/db_data.txt
echo "${db_pass}" >> /tmp/db_data.txt
echo "${lb_host}" >> /tmp/db_data.txt


yum update
yum install -y git
yum install -y docker
yum install -y cronie
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
systemctl start docker
systemctl start crond.service
git clone --branch staging https://github.com/JK-RCZ/tasks.git
echo "*/30 * * * * root /tasks/terraform/aws-el-gato-project-v0.2/scripts/push-to-s3.sh" >> /etc/crontab
usr/bin/bash  /tasks/terraform/aws-el-gato-project-v0.2/scripts/change-config.sh
rm /tmp/db_data.txt
cd /tasks/terraform/aws-el-gato-project-v0.2/docker/LAMP/ #test/ #delete "/test"
docker-compose up -d
