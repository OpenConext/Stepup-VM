#!/bin/bash

SCRIPT_DIR=`dirname "$0"`

DEPLOY_DIR=${SCRIPT_DIR}/deploy
ENV_DIR=${SCRIPT_DIR}/environment

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <config|whitelist|institution>"
    echo ""
    echo "Push the specified configuration to the middleware. Any additional paramaters are passed to ansible-playbook"
    echo ""
fi

WHAT=$1
shift
if [ "${WHAT}" != "config" -a "${WHAT}" != "whitelist" -a "${WHAT}" != "institution" ]; then
    echo "Expected 'config', 'whitelist' or institution. Got: '${WHAT}'"
    exit 1
fi

# In a PRODUCTION setting you would setup your ~/.ssh_config so that the "stepup-deploy" user authenticates to the app servers
# using the deploy.key in environment/ssh/deploy.key (Note: you would need to decrypt it first)
# Your environment would be stored in a git repo. You would then use deploy/scripts/push_config.sh to "push" the configuration
# to an app server. This runs the deploy/push-mw-<config|institution|whitelist>.yml playbook which writes the configuration to
# an app server and then runs a script there to write the config to the databas.

# This script in the Stepup-VM takes a shortcut. It calls the push-mw-<config|institution|whitelist>.yml playbook directly
# The "ansible_user" variable is set to "stepup-deploy" to emultate authentication with that user while you're actually using the
# ssh user provisioned by vagrant to authenticate.

ansible_command="ansible-playbook ${DEPLOY_DIR}/push-mw-${WHAT}.yml -i ${ENV_DIR}/inventory -e ansible_user=stepup-deploy $@"
echo $ansible_command
$ansible_command
