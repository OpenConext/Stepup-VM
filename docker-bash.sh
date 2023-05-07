#!/bin/bash

set -e  

# Open interactive bash shell in docker container stepupvm
docker exec -it stepupvm /bin/bash

# ansible-playbook deploy/site.yml -i environment/inventory.docker -e "galera_bootstrap_node=app.stepup.example.com" --skip-tags skip_docker_test --vault-password-file environment/stepup-ansible-vault-password