#!/usr/bin/env bash

# This script installs nginx and configures it with specified PORT and WORKING DIRECTORY

function delnginx { # deletes nginx and working folder
    sudo systemctl stop nginx
    sudo apt remove -y nginx
    sudo apt autoremove -y
    sudo rm -r "$dvalue"
}

function createnginxconf { # creates nginx.conf file with parameters: port and root folder
    #-------------------------------------------------NGINX CONFIG---------------------------------------------
        echo "worker_processes  1;
        events {
            worker_connections  1024;
            use epoll;
        }
        http {
            include       mime.types;
            default_type  application/octet-stream;
            sendfile        on;
            keepalive_timeout  65;
            include conf.d/*.conf;
            server {
                listen       "$pvalue";
                server_name  localhost;
                location / {
                    root   "$dvalue";
                    index  index.html index.htm index.php;
                }
                error_page   500 502 503 504  /50x.html;
                    location = /50x.html {
                    root   "$dvalue";
                }
            }
            include vhosts.d/*.conf;
        }" > nginx.conf
    #------------------------------------------END OF NGINX CONFIG----------------------------------
}

function installnginx { # installs nginx
    sudo apt update -y
    sudo apt install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    sudo cp -r ./nginx.conf /etc/nginx/nginx.conf
    sudo systemctl restart nginx
    sudo mkdir -p "$dvalue"
    sudo cp -r ./index.html "$dvalue"/index.html
    exit
}

function rootcheck { # check if user is root
    if [ "$(whoami)" != root ]; then
        echo -e "\nSorry. You can run this script as root only. Try using sudo.\n"
        exit
    fi
}

# while loop to read flags and values
while getopts 'hp:d:' FLAG; do
    case "$FLAG" in
        h)
            echo -e "\nScript usage: 'install-nginx.sh [-h] [-p] [value] [-d] [value]'\n-h - Help\n-p - Port destination\n-d - Working directory\n"
        ;;
        p)
            pvalue="$OPTARG"
            
        ;;
        d)
            dvalue="$OPTARG"
            
        ;;
        ?)
            echo -e "\nScript usage: 'install-nginx.sh [-h] [-p] [value] [-d] [value]'\n-h - Help\n-p - Port destination\n-d - Working directory\n"
            exit
        ;;
    esac
done

# Condition for no flag was passed
if [ $OPTIND == 1 ]; 
    then 
        echo -e "\nScript usage: 'install-nginx.sh [-h] [-p] [value] [-d] [value]'\n-h - Help\n-p - Port destination\n-d - Working directory\n"
        exit
fi

#Check if nginx is installed
if command -v nginx &> /dev/null
        then # in case nginx is installed
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
            if [ "$value" == "n" ]; 
                then # in case nginx is installed but user wants to update it not using parameters
                    rootcheck
                    pvalue="80"
                    dvalue="/srv/www/htdocs/"
                    createnginxconf
                    delnginx
                    installnginx
                else # in case nginx is installed but user wants to update it using parameters
                    rootcheck
                    createnginxconf
                    delnginx
                    installnginx
                      
            fi
        else # in case nginx is not installed
            rootcheck
            createnginxconf
            installnginx
fi
