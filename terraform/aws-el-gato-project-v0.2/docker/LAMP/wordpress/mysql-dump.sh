#!/usr/bin/env bash

db_host="db"
user_name="henry"
password="any"
db_name="wordpress"

current_date=$(date +"%d-%m-%Y_%T" | awk -F: '{ print ($1)"h"($2)"m"($3)"s" }')
mkdir -p /mariadb-backup
mysqldump -u $user_name --password=$password -h $db_host $db_name > /mariadb-backup/$db_name-$current_date.sql 
 
