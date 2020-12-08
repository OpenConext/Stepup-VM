#!/bin/bash

# Optionally use the first parameter to specify the component to deploy
# If not specified all components are deployed
COMPONENT=`echo "$1" | tr '[:upper:]' '[:lower:]'`

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
    comp_lower=`echo "${comp}" | tr '[:upper:]' '[:lower:]'`
    if [  -z "${COMPONENT}" -o \( "${COMPONENT}" == "${comp_lower}" \) ]; then
        did_some_work=1 # A component matched
        if [ $rv -ne 0 ]; then
           echo "Skipping deploy of ${comp_lower} due to previous error(s). Use '$0 ${comp_lower}' to deploy this component"
           continue
        fi
        echo "***** Deploying ${comp_lower} *****"
        echo ansible-playbook deploy/deploy.yml -l app* -i environment/inventory -t ${comp_lower} -e tarball_location="dummy" -e component_dir_name="/src/${comp}" -e develop=true -e configonly=false
        ansible-playbook deploy/deploy.yml -l app* -i environment/inventory -t ${comp_lower} -e tarball_location="dummy" -e component_dir_name="/src/${comp}" -e develop=true -e configonly=false
        rv=$?
        if [ $rv -ne 0 ]; then
            echo ""
            echo "Installation of ${comp_lower} failed"
            echo ""
            echo "Troubleshooting tips:"
            echo ""
            echo "- Note that you can deploy individual components. E.g. '$0 ${comp_lower}'"
            echo "- Repeating the installation of a component typically results in an error because 'composer install'"
            echo "  is not idempotent. Reset the configuration of the component e.g. 'git reset --hard && git clean -Xf'"
            echo " (note: you will loose all uncommitted changes!) before repeating the deploy of the component."
            echo "- The NFS mount can cause intermittent file IO errors during, typically during IO intensive operations"
            echo "  like composer install. In that case retrying without a configuration reset should be sufficient."
            echo "- The error in the ansible output can be hard to read. Repeat the command from the VM for a more readable"
            echo "  output. E.g.:"
            echo "  - vagrant ssh"
            echo "  - cd /vagrant/src/<component>"
            echo "  - ..."
            echo ""
        fi
    fi
done

if [ $did_some_work -eq 0 ]; then
    echo "No components matched. Use $0 <component name> to deploy a single component, or leave blank"
    echo "to deploy all components. Supported components:"
    echo ${COMPONENTS[*]}
    echo ""
fi

exit $rv