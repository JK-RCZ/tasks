#!/usr/bin/env bash

# This script installs mysql and configures it with specified PARAMETERS

function root_check { # checks if user is root
    if [ "$(whoami)" != root ]; then
        echo -e "\nSorry. You can run this script as root only. Try using sudo.\n"
        exit
    fi
}

function install_mysql { # installs mysql
    apt update -y
    apt install -y mysql-server
    mkdir -p "${directory}"
    chown mysql:mysql "${directory}"
    systemctl start mysql.service
    systemctl enable mysql.service
}

function change_mysql_config { # changes mysql config with specified parameters
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

function fill_database { # fills mysql database with tables according to user demanded size 
    if [ "$db_size" == 1 ];
        then
            for (( i=1 ; i<=table_quantity ; i++ )); 
            do
                sed -i "s/DROP TABLE IF EXISTS.*$/DROP TABLE IF EXISTS ""${username}""_db.movie""${i}"";/" sample.movieDB.sql
                sed -i "s/CREATE TABLE.*$/CREATE TABLE ""${username}""_db.movie""${i}"" (/" sample.movieDB.sql
                sed -i "s/INSERT INTO.*$/INSERT INTO ""${username}""_db.movie""${i}"" (movie_id, title, budget, homepage, overview, popularity, release_date, revenue, runtime, movie_status, tagline, vote_average, vote_count)/" sample.movieDB.sql
                cat sample.movieDB.sql >> movieDB.sql
            done
            mysql -uroot  """${username}"""_db < movieDB.sql
            rm movieDB.sql
    fi
}

function delete_mysql { # deletes mysql
    apt remove -y mysql-service
    apt autoremove -y
}

function create_user { # creates mysql user with password and database 
    if [ "$user_data" == 1 ]
        then
            mysql -uroot -e "CREATE DATABASE ${username}_db /*\!40100 DEFAULT CHARACTER SET utf8 */;"
            mysql -uroot -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
            mysql -uroot -e "GRANT ALL PRIVILEGES ON ${username}_db.* TO '${username}'@'localhost';"
            mysql -uroot -e "FLUSH PRIVILEGES;"
    fi
}

function ask_for_user_data { # asks for username, password, database size
    if [ "$user_data" == 1 ]
        then
            read -r -sp "Enter your mysql user name: "$'\n' username
            read -r -sp "Enter your mysql password: "$'\n' userpass
    fi
    if [ "$db_size" == 1 ]
        then
            read -r -p "Enter desired mysql database size (INTEGER ONLY!): "$'\n' db_size_value
            table_quantity="$((db_size_value*2))" 
    fi
}

function mysql_installed { # assigns to variable 'mysql_status' '1' if mysql is installed, '0' - if not
    if command -v mysql &> /dev/null
        then 
            mysql_status="1"
        else
            mysql_status="0"
    fi
}

function user_decision { # assigns to variable 'value' 'y' if user wants to update mysql using parameters, 'n' - if not
    echo -e "\nCurrent"
            mysql -V
            echo -e "Would you like to update it? y/n"
            read -r user_decided
            if [ "$user_decided" == "n" ]; 
                then 
                    echo -e "Thank you for you time!"
                    exit
            fi
            echo -e "Would you like to update mysql configuration with parameters you have entered? y/n"
            read -r user_decided
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
            db_size="1"
            
        ;;
        u)
            user_data="1"
        ;;
        ?)
            echo -e "\nYou should run this script with SUDO!.. and flags.\n\nScript usage: install-mysql.sh [-h] [-d] [value] [-s] [-u]\n-h - Help\n-d - Working directory\n-s - Size of DB in Mb\n-u - User name\n"
            exit
        ;;
    esac
done

# Condition for no flag was passed
if [ $OPTIND == 1 ]; 
    then 
        echo -e "\nYou should run this script with SUDO!.. and flags.\n\nScript usage: install-mysql.sh [-h] [-d] [value] [-s] [-u]\n-h - Help\n-d - Working directory\n-s - Size of DB in Mb\n-u - User name\n"
        exit
fi

root_check
ask_for_user_data
mysql_installed


if [ ${mysql_status} == 1 ]
        then # in case mysql is installed
            user_decision
            if [ "$user_decided" == "n" ]; 
                then # in case mysql is installed but user wants to update it not using parameters
                    delete_mysql
                    install_mysql
                    
                else # in case mysql is installed but user wants to update it using parameters
                    delete_mysql                    
                    install_mysql
                    change_mysql_config
                    create_user
                    fill_database
                    
                      
            fi
        else # in case mysql is not installed
            install_mysql
            change_mysql_config
            create_user
            fill_database
fi
