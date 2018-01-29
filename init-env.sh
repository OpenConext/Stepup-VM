#!/bin/bash

set -e # Stop on error

echo "./deploy/scripts/create_new_environment.sh ./environment/"
./deploy/scripts/create_new_environment.sh ./environment/

echo ""
echo "=================================================================================="
echo "Tip: For development set some of the randomly generated passwords to known values."
echo "     To do this first run: ./set_passwords.sh"
echo "=================================================================================="
echo ""
echo "You'll find the configuration in:"
echo "- ./environment/group_vars"
echo "- ./environment/templates"
echo ""
echo "All locations where you may need to make changes are marked with 'TODO:'. However,"
echo "because the generated environment is already mostly configured for a deployment to"
echo "a development VM most of the 'TODO:' locations are already set to suitable values."
echo ""
echo "Please refer to the README.md in this repo for more information."
echo ""
echo "For the next step in the deployment run:"
echo "Reset some passwords:             ./set_passwords.sh"
echo "Deploy application server:        ./deploy-site-app.sh"
echo "Deploy manage server (optional):  ./deploy-site-manage.sh"
echo "Deploy components:"
echo "- From prebiold releases:         ./deploy-release.sh"
echo "- From source (requires ENV=dev): ./deploy-develop.sh"
echo ""