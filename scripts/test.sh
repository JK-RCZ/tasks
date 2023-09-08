#!/usr/bin/env bash



uvalue="1"
username="hoffmann"
userpass="123"


function createuser { # creates mysql user with password and database 
    if [ "$uvalue" == 1 ]
        then
            mysql -uroot -e "CREATE DATABASE ${username}db /*\!40100 DEFAULT CHARACTER SET utf8 */;"
            mysql -uroot -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
            mysql -uroot -e "GRANT ALL PRIVILEGES ON ${username}db.* TO '${username}'@'localhost';"
            mysql -uroot -e "FLUSH PRIVILEGES;"
    fi
}
createuser