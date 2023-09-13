#!/usr/bin/env bash

# This script installs mysql and configures it with specified PARAMETERS

function rootcheck { # checks if user is root
    if [ "$(whoami)" != root ]; then
        echo -e "\nSorry. You can run this script as root only. Try using sudo.\n"
        exit
    fi
}

function installmysql { # installs mysql
    apt update -y
    apt install -y mysql-server
    mkdir -p "${directory}"
    chown mysql:mysql "${directory}"
    systemctl start mysql.service
    systemctl enable mysql.service
}

function changemysqlconfig { # changes mysql config with specified parameters
    sed -i "s|datadir.\{2,\}$|datadir = ""${directory}""|" mysqld.cnf
    sed -i "s/\# socket/socket/" mysqld.cnf
    cp -r ./mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
    if grep -wq "socket" mysql.cnf
        then
            :
        else
            echo -e "[client]\nsocket	= /var/run/mysqld/mysqld.sock" >> mysql.cnf
    fi
    cp -r ./mysql.cnf /etc/mysql/mysql.conf.d/mysql.cnf
    systemctl restart mysql.service
    
}

function filldatabase { # fills mysql database with tables according to user demanded size 
    if [ "$dbsize" == 1 ];
        then
            for (( i=1 ; i<=tablequantity ; i++ )); 
            do
                sed -i "s/DROP TABLE IF EXISTS.*$/DROP TABLE IF EXISTS ""${username}""_db.movie""${i}"";/" sample.movieDB.sql
                sed -i "s/CREATE TABLE.*$/CREATE TABLE ""${username}""_db.movie""${i}"" (/" sample.movieDB.sql
                sed -i "s/INSERT INTO.*$/INSERT INTO ""${username}""_db.movie""${i}"" (movie_id, title, budget, homepage, overview, popularity, release_date, revenue, runtime, movie_status, tagline, vote_average, vote_count)/" sample.movieDB.sql
                mysql -uroot  """${username}"""_db < sample.movieDB.sql
            done
    fi
}

function delmysql { # deletes mysql
    #systemctl stop mysql-service
    apt remove -y mysql-service
    apt autoremove -y
}

function createuser { # creates mysql user with password and database 
    if [ "$userdata" == 1 ]
        then
            mysql -uroot -e "CREATE DATABASE ${username}_db /*\!40100 DEFAULT CHARACTER SET utf8 */;"
            mysql -uroot -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
            mysql -uroot -e "GRANT ALL PRIVILEGES ON ${username}db.* TO '${username}'@'localhost';"
            mysql -uroot -e "FLUSH PRIVILEGES;"
    fi
}

function askforuserdata { # asks for username, password, database size
    if [ "$userdata" == 1 ]
        then
            read -r -sp "Enter your mysql user name: "$'\n' username
            read -r -sp "Enter your mysql password: "$'\n' userpass
    fi
    if [ "$dbsize" == 1 ]
        then
            read -r -p "Enter desired mysql database size (INTEGER ONLY!): "$'\n' dbsize_value
            tablequantity="$((dbsize_value*2))" 
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
    echo -e "\nCurrent"
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
while getopts 'hd:su' FLAG; do
    case "$FLAG" in
        h)
            echo -e "\nYou should run this script with SUDO!.. and flags.\n\nScript usage: 'install-mysql.sh [-h] [-d] [value] [-s] [-u]\n-h - Help\n-d - Working directory\n-s - Size of DB in Mb\n-u - User name\n"
            exit
        ;;
        d)
            directory="$OPTARG"
            
        ;;
        s)
            dbsize="1"
            
        ;;
        u)
            userdata="1"
        ;;
        ?)
            echo -e "\nYou should run this script with SUDO!.. and flags.\n\nScript usage: 'install-mysql.sh [-h] [-d] [value] [-s] [-u]\n-h - Help\n-d - Working directory\n-s - Size of DB in Mb\n-u - User name\n"
            exit
        ;;
    esac
done

# Condition for no flag was passed
if [ $OPTIND == 1 ]; 
    then 
        echo -e "\nYou should run this script with SUDO!.. and flags.\n\nScript usage: 'install-mysql.sh [-h] [-d] [value] [-s] [-u]\n-h - Help\n-d - Working directory\n-s - Size of DB in Mb\n-u - User name\n"
        exit
fi

rootcheck
askforuserdata
mysqlinstalled


if [ ${mysqlstatus} == 1 ]
        then # in case mysql is installed
            userdecision
            if [ "$value" == "n" ]; 
                then # in case mysql is installed but user wants to update it not using parameters
                    delmysql
                    installmysql
                    
                else # in case mysql is installed but user wants to update it using parameters
                    delmysql                    
                    installmysql
                    changemysqlconfig
                    createuser
                    filldatabase
                    
                      
            fi
        else # in case mysql is not installed
            installmysql
            changemysqlconfig
            createuser
            filldatabase
fi
