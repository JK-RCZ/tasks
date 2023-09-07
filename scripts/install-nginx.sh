#!/usr/bin/env bash

# This script installs nginx and configures it with specified PORT and WORKING DIRECTORY

function delnginx { # deletes nginx and working folder
    systemctl stop nginx
    apt remove -y nginx
    apt autoremove -y
}

function changenginxconf { # creates nginx.conf file with parameters: port and root folder
    sed -i "s/listen[ ]\{2,\}[0-9]\{2,\}/listen           "${pvalue}"/" nginx.conf
    sed -i "s/root.\{2,\}$/root        "${cvalue}";/" nginx.conf
}

function installnginx { # installs nginx
    apt update -y
    apt install -y nginx
    systemctl start nginx
    systemctl enable nginx
    cp -r ./nginx.conf /etc/nginx/nginx.conf
    systemctl restart nginx
    mkdir -p "${dvalue}"
    cp -r ./index.html "${dvalue}"/index.html
}

function rootcheck { # checks if user is root
    if [ "$(whoami)" != root ]; then
        echo -e "\nSorry. You can run this script as root only. Try using sudo.\n"
        exit
    fi
}

function nginxinstalled { # assigns to variable 'nginxstatus' '1' if nginx is installed, '0' - if not
    if command -v nginx &> /dev/null
        then 
            nginxstatus="1"
        else
            nginxstatus="0"
    fi
}

function userdecision { # assigns to variable 'value' 'y' if user wants to update nginx using parameters, 'n' - if not
    echo "Current"
            nginx -v
            echo -e "Would you like to update it? y/n"
            read -r value
            if [ "$value" == "n" ]; 
                then 
                    echo -e "Thank you for you time!"
                    exit
            fi
            echo -e "Would you like to update nginx configuration with port and folder you have entered? y/n"
            read -r value
} 

function convertpath { # converting path to working directory to be compatible with sed command
    echo "${dvalue}" > 1.txt
    sed -i 's/\//\\\//g'  1.txt
    cvalue=$(cat 1.txt)
}

# while loop to read flags and values
while getopts 'hp:d:' FLAG; do
    case "${FLAG}" in
        h)
            echo -e "\nScript usage: 'install-nginx.sh [-h] [-p] [value] [-d] [value]'\n-h - Help\n-p - Port destination\n-d - Working directory\n"
        ;;
        p)
            pvalue="${OPTARG}"
            
        ;;
        d)
            dvalue="${OPTARG}"
            
        ;;
        ?)
            echo -e "\nScript usage: 'install-nginx.sh [-h] [-p] [value] [-d] [value]'\n-h - Help\n-p - Port destination\n-d - Working directory\n"
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

rootcheck
nginxinstalled
convertpath

if [ ${nginxstatus} == 1 ]
        then # in case nginx is installed
            userdecision
            if [ "$value" == "n" ]; 
                then # in case nginx is installed but user wants to update it not using parameters
                    delnginx
                    installnginx
                else # in case nginx is installed but user wants to update it using parameters
                    changenginxconf
                    delnginx
                    installnginx
                      
            fi
        else # in case nginx is not installed
            changenginxconf
            installnginx
fi
