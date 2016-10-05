#!/bin/bash

echo ansible-playbook deploy/site.yml -i environment/inventory -l app* -e "galera_bootstrap_node: app.stepup.example.com"
ansible-playbook deploy/site.yml -i environment/inventory -l app* -e "galera_bootstrap_node: app.stepup.example.com"
