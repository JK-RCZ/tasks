#!/usr/bin/env bash

# This script backups nginx configuration files each day and stores this backups in user picked folder for 7 days or if there's more then 7 backups stored

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
    echo "${cron_interval} ${script_path}" >> "${user_name}"
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
    echo -e "\nPlease enter the folder you would like to save nginx backups:"
    read -r backup_folder
    mkdir -p "${backup_folder}"
    echo "${backup_folder}" > backup_path.txt
}

function test_or_not { # asks for testmode (backups created every minute)
    echo -e "\nHello, ""${user_name^}""!\nThis script is for creating nginx configuration files backup once a day."
    echo -e "Would you like to test backup script first (backups will be created every minute)? Y/N"
    read -r test_mode
    if [ "${test_mode}" == "y" ];
        then
            cron_interval="* * * * *"
        else
            cron_interval="1 1 * * 0-6"
            
    fi
}

function delete_older_then_seven { # deletes files older then 7 days or if their amount is more the 7
    
    find "${backup_path}" -type f -mtime +"${date_limit}" -name '*.gz' -delete #deletes files older then 7 days

    del_quantity="(($(find "${backup_path}" -type f -name '*.gz' | wc -l)-"${file_limit}"))" # amount of files to delete
    files_to_delete=$(find "${backup_path}" -type f -name '*.gz' -printf "%p %TY-%Tm-%Td %TH:%TM:%TS\n" | sort -t- -k2 | head -n "${del_quantity}")
        
    if [ "${del_quantity}" -gt "0" ] # deletes files if their amount is more the 7
        then
            for i in "${files_to_delete}"
            do
                    rm "${i}"
            done
    fi
}

date_limit="7"
file_limit="7"

if [ -t 0 ]; # checks if script was launched by user or by daemon
    then # if user
        root_check
        current_user_name
        test_or_not
        ask_for_directory        
        current_script_path
        create_crontab_job
    else # if daemon
        current_script_path
        create_nginx_backup
        delete_older_then_seven
fi
