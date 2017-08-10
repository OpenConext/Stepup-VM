#!/bin/bash

set -e # Stop on error

echo "./deploy/scripts/create_new_environment.sh ./environment/"
./deploy/scripts/create_new_environment.sh ./environment/

echo ""
echo "====================================================================================="
echo "Tip: For developemnt set some of the randomly generated passwords to known values."
echo "     To do this first run: ./set_passwords.sh"
echo "====================================================================================="
echo ""
echo "The generated environment is already configured for a deployment to a development VM."
echo "You'll find most of the configuration in: ./environment/group_vars"
echo ""
echo "For the next step in the deployment run:"
echo "Reset some passwords:            ./set_passwords.sh"
echo "Deploy application server:       ./deploy-site-app.sh"
echo "Deploy manage server (optional): ./deploy-site-manage.sh"