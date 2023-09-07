#!/usr/bin/env bash
#awk  '{gsub("listen.\{2,\}$", "listen           95;")}{print $0}' inputfile.txt > output.txt
echo "Type the path"
read path
echo "${path}" > 1.txt
sed -i 's/\//\\\//g'  1.txt
path=$(cat 1.txt)
sed -i 's/listen[ ]\{2,\}[0-9]\{2,\}/listen           97/' inputfile.txt
sed -i "s/root.\{2,\}$/root        "${path}";/" inputfile.txt


