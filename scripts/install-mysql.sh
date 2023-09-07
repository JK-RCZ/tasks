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
    sudo cp -R -p /var/lib/mysql "$dvalue"
    
    sudo cp -r ./mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
    sudo systemctl start mysql.service
    sudo systemctl enable mysql.service
}

function apparmorconfig {
    #-------------------------------------------APPARMOR CONFIG-------------------------------------------
    echo "# vim:syntax=apparmor
    # Last Modified: Tue Feb 09 15:28:30 2016
    #include <tunables/global>

    /usr/sbin/mysqld {
        #include <abstractions/base>
        #include <abstractions/nameservice>
        #include <abstractions/user-tmp>
        #include <abstractions/mysql>
        #include <abstractions/winbind>

    # Allow system resource access
        /proc/*/status r,
        /sys/devices/system/cpu/ r,
        /sys/devices/system/node/ r,
        /sys/devices/system/node/** r,
        capability sys_resource,
        capability dac_override,
        capability dac_read_search,
        capability setuid,
        capability setgid,

    # Allow network access
        network tcp,

        /etc/hosts.allow r,
        /etc/hosts.deny r,

    # Allow config access
        /etc/mysql/** r,

    # Allow pid, socket, socket lock file access
        /var/run/mysqld/mysqld.pid rw,
        /var/run/mysqld/mysqld.sock rw,
        /var/run/mysqld/mysqld.sock.lock rw,
        /var/run/mysqld/mysqlx.sock rw,
        /var/run/mysqld/mysqlx.sock.lock rw,
        /run/mysqld/mysqld.pid rw,
        /run/mysqld/mysqld.sock rw,
        /run/mysqld/mysqld.sock.lock rw,
        /run/mysqld/mysqlx.sock rw,
        /run/mysqld/mysqlx.sock.lock rw,

    # Allow systemd notify messages
        /{,var/}run/systemd/notify w,

    # Allow execution of server binary
        /usr/sbin/mysqld mr,
        /usr/sbin/mysqld-debug mr,

    # Allow plugin access
        /usr/lib/mysql/plugin/ r,
        /usr/lib/mysql/plugin/*.so* mr,

    # Allow error msg and charset access
        /usr/share/mysql/ r,
        /usr/share/mysql/** r,

    # Allow data dir access
        /var/lib/mysql/ r,
        /var/lib/mysql/** rwk,

    # Allow data files dir access
        /var/lib/mysql-files/ r,
        /var/lib/mysql-files/** rwk,

    # Allow keyring dir access
        /var/lib/mysql-keyring/ r,
        /var/lib/mysql-keyring/** rwk,

    # Allow log file access
        /var/log/mysql.err rw,
        /var/log/mysql.log rw,
        /var/log/mysql/ r,
        /var/log/mysql/** rw,

    # Allow read access to mecab files
        /var/lib/mecab/dic/ipadic-utf8/** r,

    # Allow read access to OpenSSL config
        /etc/ssl/openssl.cnf r,
    # Site-specific additions and overrides. See local/README for details.
    #include <local/usr.sbin.mysqld>" > usr.sbin.mysqld
    #----------------------------------------END OF APPARMOR CONFIG----------------------------------------
}


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

function createuser { # asks for username and password, creates user with password and database 
    if [ "$uvalue" == 1 ]
        then
            read -sp "Enter your user name: " username
            read -sp "Enter your password: " userpass
            mysql -uroot -e "CREATE DATABASE ${username}db /*\!40100 DEFAULT CHARACTER SET utf8 */;"
            mysql -uroot -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
            mysql -uroot -e "GRANT ALL PRIVILEGES ON ${username}db.* TO '${username}'@'localhost';"
            mysql -uroot -e "FLUSH PRIVILEGES;"
    fi
}

# while loop to read flags and values
while getopts 'hd:s:u' FLAG; do
    case "$FLAG" in
        h)
            echo -e "\nScript usage: 'install-mysql.sh [-h] [-d] [value] [-s] [value] [-u]\n-h - Help\n-d - Working directory\n-s - Size of DB in Mb\n-u - User name\n"
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
            echo -e "\nScript usage: 'install-mysql.sh [-h] [-d] [value] [-s] [value] [-u]\n-h - Help\n-d - Working directory\n-s - Size of DB in Mb\n-u - User name\n"
            exit
        ;;
    esac
done

# Condition for no flag was passed
if [ $OPTIND == 1 ]; 
    then 
        echo -e "\nScript usage: 'install-mysql.sh [-h] [-d] [value] [-s] [value] [-u]\n-h - Help\n-d - Working directory\n-s - Size of DB in Mb\n-u - User name\n"
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
                    createuser
                else # in case mysql is installed but user wants to update it using parameters
                    rootcheck
                    echo "mysql is installed but user wants to update it using parameters"
                    mysqlconfig
                    delmysql
                    installmysql
                    createuser
                      
            fi
        else # in case mysql is not installed
            rootcheck
            echo "mysql is not installed"
            installmysql
            mysqlconfig
            installmysql
            createuser
fi
