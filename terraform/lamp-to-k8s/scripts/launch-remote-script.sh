#!/bin/bash

# Description ----------------------------------------------------------------------------------------------------------------
# This script:
#  - copies script_file from script_file_path to AWS S3;
#  - connects to EC2 by SSM;
#  - downloads script_file to EC2 node into script_path;
#  - launches script_file.
# ----------------------------------------------------------------------------------------------------------------------------

# Local Variables ------------------------------------------------------------------------------------------------------------
script_file=remote.sh
script_file_path=/home/ykarchevsky/tasks/terraform/lamp-to-k8s/scripts
s3_name=s3://k8s-buffer-19556
ec2_id=i-07493c384c1d0eca2
script_path=/tmp

# ----------------------------------------------------------------------------------------------------------------------------

# Action ---------------------------------------------------------------------------------------------------------------------
aws s3 cp $script_file_path/$script_file $s3_name
aws ssm start-session --target $ec2_id
aws s3 cp $s3_name/$script_file $script_path
chmod 755 $script_path/$script_file
$script_path/$script_file
# ----------------------------------------------------------------------------------------------------------------------------