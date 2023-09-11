#!/usr/bin/env bash
uvalue="1"
function askfornameandpassword { # asks for username and password
    if [ "$uvalue" == 1 ]
        then
            read -r -sp "Enter your mysql user name: "$'\n' username
            read -r -sp "Enter your mysql password: " userpass
    fi
}
 
function createuser { # creates mysql user with password and database 
    if [ "$uvalue" == 1 ]
        then
            mysql -uroot -e "CREATE DATABASE ${username}_db /*\!40100 DEFAULT CHARACTER SET utf8 */;"
            mysql -uroot -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
            mysql -uroot -e "GRANT ALL PRIVILEGES ON ${username}db.* TO '${username}'@'localhost';"
            mysql -uroot -e "FLUSH PRIVILEGES;"
            #mysql -uroot -e "CREATE TABLE movies(title VARCHAR(50) NOT NULL,genre VARCHAR(30) NOT NULL,director VARCHAR(60) NOT NULL,release_year INT NOT NULL,PRIMARY KEY(title));"

    fi
}
askfornameandpassword
createuser




