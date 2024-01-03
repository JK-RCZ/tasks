#!/bin/bash

echo -e "\nHello this script will help you create AWS AMI or volume snaphot.\nDON'T FORGET TO INJECT AWS ACCESS KEY, SECRET KEY AND REGION BEFORE PROCEEDING!\n\nWhat would you like to do?\n 1. Create AMI\n 2. Create snapshot\n 3. Exit"
read -r -p "Choose option:" user_decision

case "$user_decision" in
        1)
            read -r -p "Please enter instance ID:" instance_id
            read -r -p "Please enter AMI name:" ami_name
            aws ec2 create-image --instance-id $instance_id --name $ami_name --no-reboot
            exit
        ;;
        2)
            read -r -p "Please enter EBS volume ID:" volume_id
            read -r -p "Please enter snapshot description:" snapshot_description
            aws ec2 create-snapshot --volume-id $volume_id --description $snapshot_description
            exit
            
        ;;
        3)
            exit
        ;;
esac