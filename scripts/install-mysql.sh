#!/usr/bin/env bash

function rootcheck { # checks if user is root
    if [ "$(whoami)" != root ]; then
        echo -e "\nSorry. You can run this script as root only. Try using sudo.\n"
        exit
    fi
}

function convertpath { # converting path to working directory to be compatible with sed command
    echo "${dvalue}" > 1.txt
    sed -i 's/\//\\\//g'  1.txt
    cvalue=$(cat 1.txt)
}

function installmysql { # installs mysql
    apt update -y
    apt install -y mysql-server
    mkdir -p "${dvalue}"
    chown mysql:mysql "${dvalue}"
    cp -R -p /var/lib/mysql "${dvalue}"
    systemctl start mysql.service
    systemctl enable mysql.service
}

function changemysqlconfig { # creates mysql config with specified parameters
    systemctl stop mysql.service
    sed -i "s/datadir.\{2,\}$/datadir = ""${cvalue}""/" mysqld.cnf
    cp -r ./mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
    systemctl start mysql.service
}

function changeapparmorconfig {
    systemctl stop apparmor.service
    linenumber=$(sed -n '/# Allow data dir access/{=;q;}' usr.sbin.mysqld)
    linenumber="$((linenumber+1))"
    sed -i """${linenumber}""s/.*/  ""${cvalue}"" r,/" usr.sbin.mysqld
    linenumber="$((linenumber+1))"
    sed -i """${linenumber}""s/.*/  ""${cvalue}""** rwk,/" usr.sbin.mysqld
    cp -r ./usr.sbin.mysqld /etc/apparmor.d/usr.sbin.mysqld
    systemctl start apparmor.service
}

function delmysql { # deletes mysql
    systemctl stop mysql-service
    apt remove -y mysql-service
    apt autoremove -y
}

#function createuser { 
#    # IN PRODUCTION...
#    fi
#}

function askfornameandpassword { # asks for username and password
    if [ "$uvalue" == 1 ]
        then
            read -r -sp "Enter your mysql user name: "$'\n' username
            read -r -sp "Enter your mysql password: " userpass
    fi
}

function mysqlinstalled { # assigns to variable 'mysqlstatus' '1' if mysql is installed, '0' - if not
    if command -v mysql &> /dev/null
        then 
            mysqlstatus="1"
        else
            mysqlstatus="0"
    fi
}

function userdecision { # assigns to variable 'value' 'y' if user wants to update mysql using parameters, 'n' - if not
    echo "Current"
            mysql -V
            echo -e "Would you like to update it? y/n"
            read -r value
            if [ "$value" == "n" ]; 
                then 
                    echo -e "Thank you for you time!"
                    exit
            fi
            echo -e "Would you like to update mysql configuration with parameters you have entered? y/n"
            read -r value
} 

# while loop to read flags and values
while getopts 'hd:s:u' FLAG; do
    case "$FLAG" in
        h)
            echo -e "\nYou should run this script with SUDO!.. and flags.\n\nScript usage: 'install-mysql.sh [-h] [-d] [value] [-s] [value] [-u]\n-h - Help\n-d - Working directory\n-s - Size of DB in Mb\n-u - User name\n"
        ;;
        d)
            dvalue="$OPTARG"
            
        ;;
        s)
            svalue="$OPTARG"
            
        ;;
        u)
            uvalue="1"
        ;;
        ?)
            echo -e "\nYou should run this script with SUDO!.. and flags.\n\nScript usage: 'install-mysql.sh [-h] [-d] [value] [-s] [value] [-u]\n-h - Help\n-d - Working directory\n-s - Size of DB in Mb\n-u - User name\n"
            exit
        ;;
    esac
done

# Condition for no flag was passed
if [ $OPTIND == 1 ]; 
    then 
        echo -e "\nYou should run this script with SUDO!.. and flags.\n\nScript usage: 'install-mysql.sh [-h] [-d] [value] [-s] [value] [-u]\n-h - Help\n-d - Working directory\n-s - Size of DB in Mb\n-u - User name\n"
        exit
fi

rootcheck
askfornameandpassword 
mysqlinstalled
convertpath

if [ ${mysqlstatus} == 1 ]
        then # in case mysql is installed
            userdecision
            if [ "$value" == "n" ]; 
                then # in case mysql is installed but user wants to update it not using parameters
                    delmysql
                    installmysql
                    #createuser
                else # in case mysql is installed but user wants to update it using parameters
                    changemysqlconfig
                    changeapparmorconfig
                    delmysql                    
                    installmysql
                    #createuser
                      
            fi
        else # in case mysql is not installed
            changemysqlconfig
            changeapparmorconfig
            installmysql
            #createuser
fi
