#!/usr/bin/env bash


echo -e "Hello! Script will upload/download/delete files from AWS S3 Bucket\n------------------------- MAIN MENU -------------------------"
PS3="Type your choise: "

items=("UPLOAD" "DOWNLOAD" "DELETE" "SHOW ALL BUCKET FILES")

while true; do
    select item in "${items[@]}" QUIT
    do
        case $REPLY in
            1) echo -e " \n------------------------- UPLOAD MENU -------------------------\n   You're going to upload a file to S3 Bucket.\n   If so, type path to file (e.g. /home/user/yourfile)\n   If not, type 'm' to exit to the MAIN MENU" 
            read uvalue;
            if [ $uvalue == m ]
            then
            echo -e " \n------------------------- MAIN MENU -------------------------"
            break
            else
            aws s3 cp $uvalue s3://jan-aws-bucket
            echo -e " \n------------------------- MAIN MENU -------------------------"
            fi
            break;;
            2) aws s3 ls s3://jan-aws-bucket
            echo -e " \n------------------------- DOWNLOAD MENU -------------------------\n   All files in your S3 Bucket are listed above.\n   Type name of file you'd like to dowload, \notherwise type 'm' to exit to the MAIN MENU"
            read dvalue;
            if [ $dvalue == m ]
            then
            echo -e " \n------------------------- MAIN MENU -------------------------"
            break
            else
            aws s3 cp s3://jan-aws-bucket/$dvalue ./
            echo -e " \n------------------------- MAIN MENU -------------------------"
            fi
            break;;
            3) aws s3 ls s3://jan-aws-bucket
            echo -e " \n------------------------- DELETE MENU -------------------------\n   All files in your S3 Bucket are listed above.\n   Type name of file you'd like to delete, \notherwise type 'm' to exit to the MAIN MENU"
            read delvalue;
            if [ $delvalue == m ]
            then
            echo -e " \n------------------------- MAIN MENU -------------------------"
            break
            else
            aws s3 rm s3://jan-aws-bucket/$delvalue
            echo -e " \n------------------------- MAIN MENU -------------------------"
            fi
            break;;
            4) aws s3 ls s3://jan-aws-bucket;
            echo " \n------------------------- MAIN MENU -------------------------"
            break;;
            $((${#items[@]}+1))) echo "See ya!"; break 2;;
            *) echo "*************** Select 1-5, don't be foolish! ***************"
            echo -e " \n------------------------- MAIN MENU -------------------------" 
            break;
        esac
    done
done
