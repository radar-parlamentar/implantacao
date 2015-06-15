#! /bin/bash
#License: GPLv3

#Check if sudo command exists.
# If it doesn't, use the su command

if which sudo &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y ruby1.9.1 ruby1.9.1-dev build-essential
    sudo gem install chef -v 11.16
else
    su -c 'apt-get update &&
            apt-get install -y ruby1.9.1 ruby1.9.1-dev build-essential &&
            gem install chef -v 11.16'
fi
