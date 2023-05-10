#!/bin/bash

# Get directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# check if first parameter is docker or vagrant
if [ "$1" != "--docker" ] && [ "$1" != "--vagrant" ]; then
	echo "Use Stepup-Deploy to deply the component from source in \"develop\"."
	echo "This install the dev dependencies and allows you to run the component"
	echo "using the Symfony dev environment"
	echo
	echo "Usage: $0 --docker|--vagrant [component]"
  echo
  echo "If the component parameter is omitted all components are deployed."
	exit 1
fi
# strip the leading "--"" from the first parameter in a variable and put it in vm_type
vm_type=${1:2}

# Optionally use the second parameter to specify the component to deploy
# If not specified all components are deployed
COMPONENT=$(echo "$2" | tr '[:upper:]' '[:lower:]')

COMPONENTS=(
"Stepup-Gateway"
"Stepup-Middleware"
"Stepup-SelfService"
"Stepup-RA"
"Stepup-tiqr"
"oath-service-php"
"stepup-demo-gssp"
"stepup-demo-gssp-2"
"Stepup-Webauthn"
"Stepup-Azure-MFA"
)

rv=0 # Set to last ansible-playbook result
did_some_work=0 # 1 when we tried to deploy a component, 0 otherwise
for comp in "${COMPONENTS[@]}"; do
    comp_lower=$(echo "${comp}" | tr '[:upper:]' '[:lower:]')
    if [  -z "${COMPONENT}" -o \( "${COMPONENT}" == "${comp_lower}" \) ]; then
        did_some_work=1 # A component matched
        if [ $rv -ne 0 ]; then
           echo "Skipping deploy of ${comp_lower} due to previous error(s). Use '$0 --$vm_type ${comp_lower}' to deploy only this component again"
           continue
        fi
        echo "***** Deploying ${comp_lower} *****"
        if [ "$vm_type" == "vagrant" ]; then
            echo "ansible-playbook deploy/deploy.yml -l 'app*' -i environment/inventory -t \"${comp_lower}\" -e tarball_location=\"dummy\" -e component_dir_name=\"/src/${comp}\" -e configonly=false -e develop=true --vault-password-file environment/stepup-ansible-vault-password"
            ansible-playbook deploy/deploy.yml -l 'app*' -i environment/inventory -t "${comp_lower}" -e tarball_location="dummy" -e component_dir_name="/src/${comp}" -e configonly=false -e develop=true --vault-password-file environment/stepup-ansible-vault-password
            rv=$?
        fi

        if [ "$vm_type" == "docker" ]; then
            echo docker exec -it stepupvm bash -c "ansible-playbook /deploy/deploy.yml -l 'app*' -i /environment/inventory.docker -t \"${comp_lower}\" -e tarball_location=\"dummy\" -e component_dir_name=\"/src/${comp}\" -e configonly=false -e develop=true --vault-password-file /environment/stepup-ansible-vault-password"
            docker exec -it stepupvm bash -c "ansible-playbook /deploy/deploy.yml -l 'app*' -i /environment/inventory.docker -t \"${comp_lower}\" -e tarball_location=\"dummy\" -e component_dir_name=\"/src/${comp}\" -e configonly=false -e develop=true --vault-password-file /environment/stepup-ansible-vault-password"
            rv=$?
        fi
        
        if [ $rv -ne 0 ]; then
            echo ""
            echo "--------------------------------------------------------------------------------------------------------"
            echo "Installation of ${comp_lower} failed"
            echo ""
            echo "Troubleshooting tips:"
            echo ""
            echo "- Note that you can deploy individual components. E.g. '$0 --$vm_type ${comp_lower}'"
            echo ""
            echo "- Repeating the installation of a component typically results in an error because 'composer install'"
            echo "  is not idempotent. Reset the configuration of the component e.g. 'git reset --hard && git clean -Xf'"
            echo " (note: you will loose all uncommitted changes!) before repeating the deploy of the component."
            echo
            echo " Docker:"
            echo "- The error in the ansible output can be hard to read. Repeat the command from the VM for a more readable"
            echo "  output. E.g.:"
            echo "  - ./docker-bash.sh"
            echo "  - cd /src/<component>"
            echo "  - ..."
            echo
            echo " Vagrant:"
            echo "- The NFS mount can cause intermittent file IO errors, typically during IO intensive operations"
            echo "  like composer install. In that case retrying without a configuration reset should be sufficient."
            echo "- The error in the ansible output can be hard to read. Repeat the command from the VM for a more readable"
            echo "  output. E.g.:"
            echo "  - vagrant ssh"
            echo "  - cd /vagrant/src/<component>"
            echo "  - ..."
            echo "--------------------------------------------------------------------------------------------------------"
            echo ""
        else
            echo ""
            echo "--------------------------------------------------------------------------------------"
            echo "Installation of ${comp_lower} succeeded"
            echo
            echo "By default nginx is configured to run the component using the Symfony prod environment"
            echo "To run the component using the dev environment, update the nginx configuration of the"
            echo "component in /etc/nginx/conf.d/<component>.stepup.example.com.conf"
            echo "and set the app_env variable to \"dev\". E.g.:"
            echo "    set $app_env \"dev\";"
            echo
            echo "Then reload nginx to apply the configuration:"
            echo "    systemctl reload nginx"
            echo "--------------------------------------------------------------------------------------"
            echo
        fi
    fi
done

if [ $did_some_work -eq 0 ]; then
    echo "No components matched. Use '$0 --$vm_type <component name>' to deploy a single component, or leave blank"
    echo "to deploy all components. Supported components:"
    echo ${COMPONENTS[*]}
    echo ""
fi

exit $rv
