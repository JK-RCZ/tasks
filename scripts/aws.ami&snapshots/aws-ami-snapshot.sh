#!/bin/bash

echo -e "\nHello this script will help you create AWS AMI or volume snaphot.\nWhat would you like to do?\n 1. Create AMI\n 2. Create snapshot\n 3. Exit"
read -r -p "Choose option:" user_decision

case "$user_decision" in
        1)
            echo -e "\nuser dicision = 1"
            exit
        ;;
        2)
            echo -e "\nuser dicision = 2"
            exit
            
        ;;
        3)
            exit
        ;;
esac