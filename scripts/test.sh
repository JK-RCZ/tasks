#!/usr/bin/env bash


#command -v nginx &> /dev/null
#if [ $? != 0 ]
#
#        then
#            echo "installed"
#        else  
#            echo "not installed"
#fi

if command -v nginx &> /dev/null
then
    echo "nginx ON"
    exit
else
    echo "nginx OFF"    
fi
