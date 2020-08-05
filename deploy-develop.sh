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
)

rv=0
for comp in "${COMPONENTS[@]}"; do
    comp_lower=`echo "${comp}" | tr '[:upper:]' '[:lower:]'`
    if [  -z "${COMPONENT}" -o \( "${COMPONENT}" == "${comp_lower}" \) ]; then
        if [ $rv -ne 0 ]; then
           echo "Skipping deploy of ${comp_lower} due to previous error(s). Use '$0 ${comp_lower}' to deploy this component"
           continue
        fi
        echo "***** Deploying ${comp_lower} *****"
        echo ansible-playbook deploy/deploy.yml -l app* -i environment/inventory -t ${comp_lower} -e tarball_location="dummy" -e component_dir_name="/src/${comp}" -e develop=true
        ansible-playbook deploy/deploy.yml -l app* -i environment/inventory -t ${comp_lower} -e tarball_location="dummy" -e component_dir_name="/src/${comp}" -e develop=true
        rv=$?
        if [ $rv -ne 0 ]; then
            echo ""
            echo "Installation of ${comp_lower} failed"
            echo ""
            echo "Troublesooting tips:"
            echo ""
            echo "- Note that you can deploy individual components. E.g. '$0 ${comp_lower}'"
            echo "- Repeating the installation of a component typically results in configuration errors."
            echo "  reset the component first e.g. 'git reset --hard' (note you will loose all changes!)"
            echo "- The NFS mount can cause intermittent errors during composer install. In that case retry. A git reset"
            echo "  should not be necessary in that case"
            echo "- The error in the ansible output can be hard to read. Repeat the command from the VM for clean output:"
            echo "  - vagrant ssh"
            echo "  - cd /vagrant/src/<component>"
            echo "  - ..."
            echo ""
        fi
    fi
done

exit $rv