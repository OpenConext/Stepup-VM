#!/bin/bash

echo ansible-playbook deploy/site.yml -i environment/inventory -e "galera_bootstrap_node=app.stepup.example.com inventory_dir=`pwd`/environment" $@
ansible-playbook deploy/site.yml -i environment/inventory -e "galera_bootstrap_node=app.stepup.example.com inventory_dir=`pwd`/environment" $@

echo ""
echo "Next steps:"
echo "- Deploy manage server (optional): ./deploy-site-manage.sh"
echo "- Deploy components              : ./deploy-release.sh (or, for a development server, ./deploy-develop.sh)"

