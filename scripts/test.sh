#!/usr/bin/env bash


function delnginx {
    sudo systemctl stop nginx
    sudo apt remove -y nginx
    sudo apt autoremove -y
    #sudo rm -r "$dvalue"
}

delnginx