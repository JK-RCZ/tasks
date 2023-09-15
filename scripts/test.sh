#!/usr/bin/env bash



function create_nginx_backup { # creates archive file with nginx config data
    backup_path="$(cat "${script_folder}"/backup_path.txt)"
    current_date=$(date +"%d-%m-%Y_%T" | awk -F: '{ print ($1)"h"($2)"m"($3)"s" }')
    cd "${backup_path}" || exit
    tar -czf nginx-config_"${current_date}".tar.gz --absolute-names /etc/nginx/ 
       
}
function current_script_path { # checks path of current script
    cd "$(dirname "$0")" || exit
    script_folder="$(pwd)"
    script_path="$(pwd)"/"$(basename "$0")"

}

current_script_path
create_nginx_backup