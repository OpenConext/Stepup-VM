#!/bin/bash

set -e # Stop on error

if [ ! -e "./src" ]; then
    mkdir src
fi

# Ansible playbook
if [ ! -e "./src/Stepup-Deploy" ]; then
    git clone git@github.com:OpenConext/Stepup-Deploy.git ./src/Stepup-Deploy
fi

# Stepup source code
if [ ! -e "./src/Stepup-Middleware" ]; then
    git clone git@github.com:OpenConext/Stepup-Middleware.git ./src/Stepup-Middleware
    #php56 /usr/local/bin/composer install -n -d ./src/Stepup-Middleware
fi
if [ ! -e "./src/Stepup-Gateway" ]; then
    git clone git@github.com:OpenConext/Stepup-Gateway.git ./src/Stepup-Gateway
    #php56 /usr/local/bin/composer install -n -d ./src/Stepup-Gateway
fi
if [ ! -e "./src/Stepup-SelfService" ]; then
    git clone git@github.com:OpenConext/Stepup-SelfService.git ./src/Stepup-SelfService
    #php56 /usr/local/bin/composer install -n -d ./src/Stepup-SelfService
fi
if [ ! -e "./src/Stepup-RA" ]; then
    git clone git@github.com:OpenConext/Stepup-RA.git ./src/Stepup-RA
    #php56 /usr/local/bin/composer install -n -d ./src/Stepup-RA
fi

if [ ! -e "./deploy" ]; then
    ln -s src/Stepup-Deploy/ deploy
fi
