#!/usr/bin/env bash

# This script backups nginx.conf each day and stores this backups for 7 days or if there's more then 7 backups stored

function root_check { # checks if user is root
    if [ "$(whoami)" != root ]; then
        echo -e "\nSorry. You can run this script as root only. Try using sudo.\n"
        exit
    fi
}

function current_script_path { # checks path of current script and it's folder
    cd "$(dirname "$0")" || exit
    script_folder="$(pwd)"
    script_path="$(pwd)"/"$(basename "$0")"

}

function current_user_name { # checks name of current user
    user_name=$(logname)
}

function create_crontab_job { # creates crontab job that launches this script
    cp cron.conf "${user_name}"
    echo "* * * * * ${script_path}" >> "${user_name}"
    cp "${user_name}" /var/spool/cron/crontabs/
    chown "${user_name}":crontab /var/spool/cron/crontabs/"${user_name}"
    chmod 600 /var/spool/cron/crontabs/"${user_name}"
    rm "${user_name}"
}

function create_nginx_backup { # creates archive file with nginx config data
    backup_path="$(cat "${script_folder}"/backup_path.txt)"
    current_date=$(date +"%d-%m-%Y_%T" | awk -F: '{ print ($1)"h"($2)"m"($3)"s" }')
    cd "${backup_path}" || exit
    tar -czf nginx-config_"${current_date}".tar.gz --absolute-names /etc/nginx/ 
       
}

function ask_for_directory { # asks user for backup files directory and creates it
    echo "Please enter the folder you would like to save nginx backups:"
    read -r backup_folder
    if test -d "${backup_folder}";
        then
            chown -R "${user_name}":crontab "${backup_folder}"
            touch backup_path.txt
            echo "${backup_folder}" > backup_path.txt
        else
            mkdir "${backup_folder}"
            chown -R "${user_name}":crontab "${backup_folder}"
            touch backup_path.txt
            echo "${backup_folder}" > backup_path.txt
    fi
}

if [ -t 0 ]; # checks if script was launched by user or by daemon
    then
        root_check
        current_user_name
        ask_for_directory        
        current_script_path
        create_crontab_job
    else
        current_script_path
        create_nginx_backup
fi
