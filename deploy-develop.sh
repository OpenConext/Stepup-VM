#!/bin/sh

set -e

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
)

for comp in "${COMPONENTS[@]}"; do
    comp_lower=`echo "${comp}" | tr '[:upper:]' '[:lower:]'`
    if [  -z "${COMPONENT}" -o \( "${COMPONENT}" == "${comp_lower}" \) ]; then
        echo "***** Deploying ${comp_lower} *****"
        echo ansible-playbook deploy/deploy.yml -l app* -i environment/inventory -t ${comp_lower} -e tarball_location="dummy" -e component_dir_name="/src/${comp}" -e develop=true
        ansible-playbook deploy/deploy.yml -l app* -i environment/inventory -t ${comp_lower} -e tarball_location="dummy" -e component_dir_name="/src/${comp}" -e develop=true
    fi
done
