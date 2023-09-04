#!/usr/bin/env bash

# This script installs nginx and configures it with specified PORT and WORKING DIRECTORY


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
                    echo -e "Using Standart nginx.conf file"
                    #root check
                    if [ "$(whoami)" != root ]; then
                        echo -e "\nSorry. You can run this script as root only. Try using sudo.\n"
                        exit
                    fi
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
                            listen       80;
                            server_name  localhost;
                            location / {
                                root   /srv/www/htdocs/;
                                index  index.html index.htm index.php;
                            }
                            error_page   500 502 503 504  /50x.html;
                                location = /50x.html {
                                root   /srv/www/htdocs/;
                            }
                        }
                        include vhosts.d/*.conf;
                    }" > nginx.conf
                    #------------------------------------------END OF NGINX CONFIG----------------------------------
                    sudo apt update -y
                    sudo apt install -y nginx
                    sudo systemctl start nginx
                    sudo systemctl enable nginx
                    sudo cp -r ./nginx.conf /etc/nginx/nginx.conf
                    sudo systemctl restart nginx
                    sudo mkdir -p /srv/www/htdocs/
                    sudo cp -r ./index.html /srv/www/htdocs/index.html
                    exit  
                else # in case nginx is installed but user wants to update it using parameters
                     #root check
                    if [ "$(whoami)" != root ]; then
                        echo -e "\nSorry. You can run this script as root only. Try using sudo.\n"
                        exit
                    fi
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
                    sudo apt update -y
                    sudo apt install -y nginx
                    sudo systemctl start nginx
                    sudo systemctl enable nginx
                    sudo cp -r ./nginx.conf /etc/nginx/nginx.conf
                    sudo systemctl restart nginx
                    sudo mkdir -p "$dvalue"
                    sudo cp -r ./index.html "$dvalue"/index.html
                    exit    
            fi
            

        else # in case nginx is not installed
             #root check
            if [ "$(whoami)" != root ]; then
                echo -e "\nSorry. You can run this script as root only. Try using sudo.\n"
                exit
            fi
            echo "not installed"
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
            sudo apt update -y
            sudo apt install -y nginx
            sudo systemctl start nginx
            sudo systemctl enable nginx
            sudo cp -r ./nginx.conf /etc/nginx/nginx.conf
            sudo systemctl restart nginx
            sudo mkdir -p "$dvalue"
            sudo cp -r ./index.html "$dvalue"/index.html
            exit
            
fi

#----------------------------------DELETE NGINX---------------------------------------------------
#sudo systemctl stop nginx
#sudo apt remove -y nginx
#sudo apt autoremove -y
#sudo rm -r "$dvalue"
#sudo rm -r /srv/www/htdocs/