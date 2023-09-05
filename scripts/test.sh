#!/usr/bin/env bash

if command -v mysql &> /dev/null
        then # in case mysql is installed
            echo "It's ON"
        else
            echo "It's OFF"
fi


