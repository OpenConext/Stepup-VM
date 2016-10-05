#!/bin/sh

CWD=`pwd`
cd `dirname $0`
environment_dir=`pwd`/environment/
cd $CWD
echo "You are about to remove the environment your created in "${environment_dir}"."
read -p "Do you want to continue? [y/n]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# Remove all files and directories except 'inventory'
echo "Removing files and directories:"
find ${environment_dir}/* -maxdepth 0 -type d -exec rm -v -r {} +
find ${environment_dir}/. ! -name 'inventory' -type f -exec rm -v {} +
echo "Done."
echo
echo 'You can use "./deploy/scripts/create_new_environment.sh environment/" to create a new environment.'
echo