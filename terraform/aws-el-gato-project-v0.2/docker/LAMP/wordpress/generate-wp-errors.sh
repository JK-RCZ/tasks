#!/usr/bin/env bash

#This script causes momentary errors in Wordpress theme twentytwentyfour

sed -i "s|if ( ! function_exists( 'twentytwentyfour_block_styles' ) ) :|if ( ! function_exists( 'twentytwentyfour_block_styles' ) ) ;|" /var/www/localhost/htdocs/wp-content/themes/twentytwentyfour/functions.php
curl localhost
sed -i "s|if ( ! function_exists( 'twentytwentyfour_block_styles' ) ) ;|if ( ! function_exists( 'twentytwentyfour_block_styles' ) ) :|" /var/www/localhost/htdocs/wp-content/themes/twentytwentyfour/functions.php


