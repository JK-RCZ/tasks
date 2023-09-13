#!/usr/bin/env bash

function filldatabase { # fills mysql database with tables according to user demanded size 
    #if [ "$dbsize" == 1 ];
    #    then
            echo "Database size entered"
            for (( i=1 ; i<=tablequantity ; i++ )); 
            do
                sed -i "s/DROP TABLE IF EXISTS.*$/DROP TABLE IF EXISTS ""${username}""_db.movie""${i}"";/" sample.movieDB.sql
                sed -i "s/CREATE TABLE.*$/CREATE TABLE ""${username}""_db.movie""${i}"" (/" sample.movieDB.sql
                sed -i "s/INSERT INTO.*$/INSERT INTO ""${username}""_db.movie""${i}"" (movie_id, title, budget, homepage, overview, popularity, release_date, revenue, runtime, movie_status, tagline, vote_average, vote_count)/" sample.movieDB.sql
                #mysql -uroot  """${username}"""_db < sample.movieDB.sql
            done
    #fi
}

function askforuserdata { # asks for username, password, database size
    if [ "$userdata" == 1 ]
        then
            read -r -sp "Enter your mysql user name: "$'\n' username
            read -r -sp "Enter your mysql password: "$'\n' userpass
    fi
    if [ "$dbsize" == 1 ]
        then
            read -r -p "Enter desired mysql database size (INTEGER ONLY!): "$'\n' dbsize
            tablequantity="$((dbsize*2))" 
    fi
}
userdata="1"
dbsize="1"
echo "database size entered:${dbsize}"
echo "user data entered:${userdata}"
askforuserdata
filldatabase