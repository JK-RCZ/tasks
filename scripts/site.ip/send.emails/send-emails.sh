#!/usr/bin/env bash

wc -l /home/janik.karczewski/projects/scripts/temp/final.txt > /home/janik.karczewski/projects/scripts/temp/4.txt
COUNT=$(sed 's/  */\t/g' /home/janik.karczewski/projects/scripts/temp/4.txt | cut -f1)
echo "Number of mail(s) in file is $COUNT"

declare -a arr

i=0
while read line; 
do arr[i]=$line; ((i++)); echo "Sending... $line";
done < /home/janik.karczewski/projects/scripts/temp/final.txt

for ((i = 0 ; i < $COUNT ; i++ )); 
do  
     mail -s "Looking for DevOps position in Poland" -a /home/janik.karczewski/Jan/DevOps-Jan-Karczewski-CV.pdf ${arr[i]} < /home/janik.karczewski/projects/scripts/temp/body.txt
done

