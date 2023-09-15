#!/usr/bin/env bash

# This script bla bla bla




while getopts 's:' FLAG; do
    case "$FLAG" in
        d)
            site="$OPTARG"
            
        ;;
        ?)
            echo -e "\nYou should run this script with SUDO!.. and -s flag\n\nScript usage: site-ip.sh [-s] www.sitename.domain"
            exit
        ;;
    esac
done

# Condition for no flag was passed
if [ $OPTIND == 1 ]; 
    then 
        echo -e "\nYou should run this script with SUDO!.. and -s flag\n\nScript usage: site-ip.sh [-s] www.sitename.domain"
        exit
fi

nslookup "${site}" 