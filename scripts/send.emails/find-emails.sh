#!/usr/bin/env bash

touch /home/jan/projects/scripts/temp/final.txt
rm /home/jan/projects/scripts/temp/final.txt

grep -i 'summary\|\@' Downloads/IT\ Specialist\ -\ Poland.Business\ Harbour\ \(Angielski\)\ -\ Gov.pl\ website.html > /home/jan/projects/scripts/temp/1.txt
grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" /home/jan/projects/scripts/temp/1.txt > /home/jan/projects/scripts/temp/2.txt
wc -l /home/jan/projects/scripts/temp/2.txt > /home/jan/projects/scripts/temp/3.txt
COUNT=$(sed 's/  */\t/g' /home/jan/projects/scripts/temp/3.txt | cut -f1)

declare -a arr

i=0
while read line; 
do arr[i]=$line; ((i++));
done < /home/jan/projects/scripts/temp/2.txt

for ((i = 0 ; i < $COUNT ; i++ )); 
do  
if [[ ${arr[i]} == ${arr[i+1]} ]]; 
then
    arr[i+1]=0
fi
done

arr[$COUNT-2]=0

for ((i = 0 ; i < $COUNT ; i++ )); 
do  
if [[ ${arr[i]} != 0 ]]; 
then
   echo ${arr[i]} >> /home/jan/projects/scripts/temp/final.txt
fi
done

echo -e "\nAll e-mails from:     /home/jan/Downloads/IT Specialist - Poland.Business Harbour (Angielski) - Gov.pl website.html\n          are in:     /home/jan/projects/scripts/temp/final.txt\n"
