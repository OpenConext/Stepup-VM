#!/bin/bash

# Get directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# check if first parameter is docker or vagrant
if [ "$1" != "--docker" ] && [ "$1" != "--vagrant" ]; then
	echo "Usage: $0 --docker|--vagrant [ansible options]"
	exit 1
fi
# strip the leading "--"" from the first parameter in a variable and put it in vm_type
vm_type=${1:2}
shift

# Vagrant command
if [ "$vm_type" == "varant" ]; then
	echo "ansible-playbook deploy/site.yml -i environment/inventory -e \"galera_bootstrap_node=app.stepup.example.com inventory_dir=$SCRIPT_DIR/environment\" $*"
	ansible-playbook deploy/site.yml -i environment/inventory -e "galera_bootstrap_node=app.stepup.example.com inventory_dir=$SCRIPT_DIR/environment" "$*"
	retVal=$?
fi

# Docker command
if [ "$vm_type" == "docker" ]; then
     echo docker exec -it stepupvm ansible-playbook /deploy/site.yml -i /environment/inventory.docker -e "galera_bootstrap_node=app.stepup.example.com" --skip-tags skip_docker_test --vault-password-file /environment/stepup-ansible-vault-password "$@"
	 docker exec -it stepupvm ansible-playbook /deploy/site.yml -i /environment/inventory.docker -e "galera_bootstrap_node=app.stepup.example.com" --skip-tags skip_docker_test --vault-password-file /environment/stepup-ansible-vault-password "$@"
	  #-i /environment/inventory.docker -e "galera_bootstrap_node=app.stepup.example.com" --skip-tags skip_docker_test --vault-password-file /environment/stepup-ansible-vault-password "$*"
	retVal=$?
fi

if [ "$retVal" -eq 0 ]; then
	echo ""
	echo "Next steps:"
	echo "- Deploy components (release)     : ./deploy-release.sh --$vm_type"
	echo "- Deploy components (developemnt) : ./deploy-develop.sh --$vm_type"
fi
exit "$retVal"

