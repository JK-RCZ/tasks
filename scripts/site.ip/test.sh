#!/usr/bin/env bash



function delete_older_then_seven { # deletes files older then 7 days or if their amount is more the 7
    del_time="$(cat "${script_folder}"/del.time.txt)"
    find "${backup_path}" -type f -mtime +"${del_time}" -name '*.gz' -execdir rm -- '{}' \; #deletes files older then 7 days
    
    count_files="$(ls -l "${backup_path}"/*.gz | wc -l)"
    if [ "${count_files}" -gt "7" ] # deletes files if their amount is more the 7
        then
            for i in $(ls -lt "${backup_path}"/*.gz | head -n 7)
            do
                    rm "${i}"
            done
    fi
}

deltime=