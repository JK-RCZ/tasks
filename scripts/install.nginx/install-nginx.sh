#!/usr/bin/env bash

# This script installs nginx and configures it with specified PORT and WORKING DIRECTORY

function del_nginx { # deletes nginx and working folder
    systemctl stop nginx
    apt remove -y nginx
    apt autoremove -y
}

function change_nginx_conf { # creates nginx.conf file with parameters: port and root folder
    sed -i "s/listen[ ]\{2,\}[0-9]\{2,\}/listen           ""${port}""/" nginx.conf
    sed -i "s/root.\{2,\}$/root        ""${converted_path}"";/" nginx.conf
}

function install_nginx { # installs nginx
    apt update -y
    apt install -y nginx
    systemctl start nginx
    systemctl enable nginx
    cp -r ./nginx.conf /etc/nginx/nginx.conf
    systemctl restart nginx
    mkdir -p "${directory}"
    cp -r ./index.html "${directory}"/index.html
    chmod 644 "${directory}"/index.html
}

function root_check { # checks if user is root
    if [ "$(whoami)" != root ]; then
        echo -e "\nSorry. You can run this script as root only. Try using sudo.\n"
        exit
    fi
}

function nginx_installed { # assigns to variable 'nginx_status' '1' if nginx is installed, '0' - if not
    if command -v nginx &> /dev/null
        then 
            nginx_status="1"
        else
            nginx_status="0"
    fi
}

function user_decision { # assigns to variable 'value' 'y' if user wants to update nginx using parameters, 'n' - if not
    echo "Current"
            nginx -v
            echo -e "Would you like to update it? y/n"
            read -r user_decided
            if [ "$user_decided" == "n" ]; 
                then 
                    echo -e "Thank you for you time!"
                    exit
            fi
            echo -e "Would you like to update nginx configuration with port and folder you have entered? y/n"
            read -r user_decided
} 

function convert_path { # converting path to working directory to be compatible with sed command
    echo "${directory}" > 1.txt
    sed -i 's/\//\\\//g'  1.txt
    converted_path=$(cat 1.txt)
}

# while loop to read flags and values
while getopts 'hp:d:' FLAG; do
    case "${FLAG}" in
        h)
            echo -e "\nScript usage: install-nginx.sh [-h] [-p] [value] [-d] [value]'\n-h - Help\n-p - Port destination\n-d - Working directory\n"
        ;;
        p)
            port="${OPTARG}"
            
        ;;
        d)
            directory="${OPTARG}"
            
        ;;
        ?)
            echo -e "\nScript usage: install-nginx.sh [-h] [-p] [value] [-d] [value]'\n-h - Help\n-p - Port destination\n-d - Working directory\n"
            exit
        ;;
    esac
done

# Condition for no flag was passed
if [ ${OPTIND} == 1 ]; 
    then 
        echo -e "\nScript usage: 'install-nginx.sh [-h] [-p] [value] [-d] [value]'\n-h - Help\n-p - Port destination\n-d - Working directory\n"
        exit
fi

root_check
nginx_installed
convert_path

if [ ${nginx_status} == 1 ]
        then # in case nginx is installed
            user_decision
            if [ "$user_decided" == "n" ]; 
                then # in case nginx is installed but user wants to update it not using parameters
                    del_nginx
                    install_nginx
                else # in case nginx is installed but user wants to update it using parameters
                    change_nginx_conf
                    del_nginx
                    install_nginx
                      
            fi
        else # in case nginx is not installed
            change_nginx_conf
            install_nginx
fi
