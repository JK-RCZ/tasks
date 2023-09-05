#!/usr/bin/env bash

function rootcheck { # checks if user is root
    if [ "$(whoami)" != root ]; then
        echo -e "\nSorry. You can run this script as root only. Try using sudo.\n"
        exit
    fi
}


function installmysql { # installs mysql
    sudo apt update -y
    sudo apt install -y mysql-server
    sudo mkdir -p "$dvalue"
    sudo cp -r ./mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
    sudo systemctl start mysql.service
    sudo systemctl enable mysql.service
    exit
}

function mysqlconfig { # creates mysql config with specified parameters
    #-------------------------------------------MYSQL CONFIG----------------------------------------------
    echo "# The MySQL database server configuration file.
    #
    # One can use all long options that the program supports.
    # Run program with --help to get a list of available options and with
    # --print-defaults to see which it would actually understand and use.
    #
    # For explanations see
    # http://dev.mysql.com/doc/mysql/en/server-system-variables.html

    # Here is entries for some specific programs
    # The following values assume you have at least 32M ram

    [mysqld]
    #
    # * Basic Settings
    #
    user		= mysql
    # pid-file	= /var/run/mysqld/mysqld.pid
    # socket	= /var/run/mysqld/mysqld.sock
    # port		= 3306
    datadir	= "$dvalue"
    innodb_data_file_path = ibdata1:"$svalue"M:autoextend:max:1G


    # If MySQL is running as a replication slave, this should be
    # changed. Ref https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_tmpdir
    # tmpdir		= /tmp
    #
    # Instead of skip-networking the default is now to listen only on
    # localhost which is more compatible and is not less secure.
    bind-address		= 127.0.0.1
    mysqlx-bind-address	= 127.0.0.1
    #
    # * Fine Tuning
    #
    key_buffer_size		= 16M
    # max_allowed_packet	= 64M
    # thread_stack		= 256K

    # thread_cache_size       = -1

    # This replaces the startup script and checks MyISAM tables if needed
    # the first time they are touched
    myisam-recover-options  = BACKUP

    # max_connections        = 151

    # table_open_cache       = 4000

    #
    # * Logging and Replication
    #
    # Both location gets rotated by the cronjob.
    #
    # Log all queries
    # Be aware that this log type is a performance killer.
    # general_log_file        = /var/log/mysql/query.log
    # general_log             = 1
    #
    # Error log - should be very few entries.
    #
    log_error = /var/log/mysql/error.log
    #
    # Here you can see queries with especially long duration
    # slow_query_log		= 1
    # slow_query_log_file	= /var/log/mysql/mysql-slow.log
    # long_query_time = 2
    # log-queries-not-using-indexes
    #
    # The following can be used as easy to replay backup logs or for replication.
    # note: if you are setting up a replication slave, see README.Debian about
    #       other settings you may need to change.
    # server-id		= 1
    # log_bin			= /var/log/mysql/mysql-bin.log
    # binlog_expire_logs_seconds	= 2592000
    max_binlog_size   = 100M
    # binlog_do_db		= include_database_name
    # binlog_ignore_db	= include_database_name" > mysqld.cnf

    #---------------------------------------END OF MYSQL CONFIG-------------------------------------------
}

function delmysql { # deletes mysql and working folder
    sudo systemctl stop mysql-service
    sudo apt remove -y mysql-service
    sudo apt autoremove -y
    sudo rm -r "$dvalue"
}
# while loop to read flags and values
while getopts 'hd:s:u:p:' FLAG; do
    case "$FLAG" in
        h)
            echo -e "\nScript usage: 'install-mysql.sh [-h] [-d] [value] [-s] [value] [-u] [value] [-p] [value]'\n-h - Help\n-d - Working directory\n-s - Size of DB in Mb\n-u - User name\n-p - User password\n"
        ;;
        d)
            dvalue="$OPTARG"
            
        ;;
        s)
            svalue="$OPTARG"
            
        ;;
        u)
            uvalue="$OPTARG"
        ;;
        p)
            pvalue="$OPTARG"
        ;;
        ?)
            echo -e "\nScript usage: 'install-mysql.sh [-h] [-d] [value] [-s] [value] [-u] [value] [-p] [value]'\n-h - Help\n-d - Working directory\n-s - Size of DB in Mb\n-u - User name\n-p - User password\n"
            exit
        ;;
    esac
done

# Condition for no flag was passed
if [ $OPTIND == 1 ]; 
    then 
        echo -e "\nScript usage: 'install-mysql.sh [-h] [-d] [value] [-s] [value] [-u] [value] [-p] [value]'\n-h - Help\n-d - Working directory\n-s - Size of DB in Mb\n-u - User name\n-p - User password\n"
        exit
fi

#Check if mysql is installed
if command -v mysql &> /dev/null
        then # in case mysql is installed
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
            if [ "$value" == "n" ]; 
                then # in case mysql is installed but user wants to update it not using parameters
                    rootcheck
                    echo "mysql is installed but user wants to update it not using parameters"
                    dvalue="/var/lib/mysql"
                    svalue="5"
                    mysqlconfig
                    delmysql
                    installmysql
                else # in case mysql is installed but user wants to update it using parameters
                    rootcheck
                    echo "mysql is installed but user wants to update it using parameters"
                    mysqlconfig
                    delmysql
                    installmysql
                      
            fi
        else # in case mysql is not installed
            rootcheck
            echo "mysql is not installed"
            installmysql
            mysqlconfig
            installmysql
fi
