#!/usr/bin/env bash

# This script creates index.html file with nslookup output in it and copies index.html to /usr/local/apache2/htdocs/
function nslookup_output_to_file { #writes nslookup output to temporary file
    nslookup "${SITE}" > tmp.txt
    sed -i "s|$|<br>|" tmp.txt 
    sed -i "1s|^|<p>|" tmp.txt
    sed -i "9s|<br>|</p>|" tmp.txt
}

function fill_index_html { #creates index.html page with nslookup output in it
    
    echo "<!DOCTYPE html><html><head><title>Information on site you requiered</title><style>body {width: 35em;margin: 0 auto;font-family: Tahoma, Verdana, Arial, sans-serif;}</style></head><body><h1>Information on site you requiered:</h1><br>" > index.html
    while read -r line; 
    do
        echo "${line}" >> index.html
    done < tmp.txt
    echo "<p><em>Thank you for using site.ip script!</em></p></body></html>" >> index.html
    mv index.html /var/www/localhost/htdocs/index.html
    
}

if [ "${SITE}" != "0" ]; # checks if enviroment variable was entered
    then
       
        nslookup_output_to_file
        fill_index_html
        rm tmp.txt
        echo -e "\nNow you can open your browser and call for 127.0.0.1 to see the results.\nStop container, when you're done."
        apachectl -D FOREGROUND
    else
        echo -e "\nPlease run command with -e flag like this:\nsudo docker run -p 80:80 -e SITE=www.site.dom image_name\n"
        exit
fi

