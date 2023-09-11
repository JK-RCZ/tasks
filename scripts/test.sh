#!/usr/bin/env bash

cvalue="\/kkk\/mysql2\/"

function changemysqlconfig { # creates mysql config with specified parameters
    systemctl stop mysql.service
    sed -i "s/datadir.\{2,\}$/datadir = ""${cvalue}""/" mysqld.cnf
    sed -i "s/\# socket/socket/" mysqld.cnf
    cp -r ./mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
    if grep -wq "socket" mysql.cnf
        then
            :
        else
            echo -e "[client]\nsocket	= /var/run/mysqld/mysqld.sock" >> mysql.cnf
    fi
    cp -r ./mysql.cnf /etc/mysql/mysql.conf.d/mysql.cnf
    systemctl start mysql.service
}
changemysqlconfig