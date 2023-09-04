#!/usr/bin/env bash


command -v nginx &> /dev/null
if [ $? != 0 ]

        then
            echo "installed"
        else  
            echo "not installed"
fi
