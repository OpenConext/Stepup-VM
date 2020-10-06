#!/bin/bash

set -e # Stop on error

CWD=`pwd`
BASEDIR=`dirname $0`

function error_exit {
    echo "${1}"
    cd ${CWD}
    exit 1
}

function realpath {
    if [ ! -d ${1} ]; then
        return 1
    fi
    current_dir=`pwd`
    cd ${1}
    res=$?
    if [ $? -eq "0" ]; then
        path=`pwd`
        cd $current_dir
        echo $path
    fi
    return $res
}

BASEDIR=`realpath ${BASEDIR}`
ENVIRONMENT_DIR="${BASEDIR}/environment"

# Ask to continue
echo "This script is used only for development, so be careful when using this file. Old configuration files will be"
echo "removed, so make sure you have a backup of the ${ENVIRONMENT_DIR} in case you want to revert the changes."
echo "Are you sure you want to continue?"
read -p "Do you want to (E)xit (recommended) or (C)ontinue? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Cc]$ ]]; then
    exit 0
fi

# Remove old environment.conf so it could be replaced
ENVIRONMENT_CONF="${ENVIRONMENT_DIR}/environment.conf"
if [ -f "${ENVIRONMENT_CONF}" ]; then
  rm -r "${ENVIRONMENT_CONF}"
else
  echo "Skipping removal of ${ENVIRONMENT_CONF} config file because it does not exist"
fi

# Remove old directories from the template to initialize a new environment
directories=("group_vars" "handlers" "tasks" "templates" "files")
for directory in "${directories[@]}"; do
    if [ -e "${ENVIRONMENT_DIR}/${directory}" ]; then
        echo "Removing ${directory} directory"
        rm -r "${ENVIRONMENT_DIR}/${directory}"
        if [ $? -ne "0" ]; then
            error_exit "Error removing ${directory} directory"
        fi
    else
        echo "Skipping removal of ${directory} directory because it does not exist"
    fi
done

# Rerun create new environment script to update the configuration
echo "./deploy/scripts/create_new_environment.sh ./environment/"
./deploy/scripts/create_new_environment.sh ./environment/

echo ""
echo "=================================================================================="
echo "The Deploy configuration is updated and you can now rerun the Ansible tasks"
echo "=================================================================================="
echo ""
