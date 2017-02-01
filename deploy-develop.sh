#!/bin/sh

COMPONENTS=(
"Stepup-Gateway"
"Stepup-Middleware"
"Stepup-SelfService"
"Stepup-RA"
#"Stepup-tiqr"
#"oath-service-php"
)

for comp in "${COMPONENTS}"; do
    comp_lower=`echo "${comp}" | tr '[:upper:]' '[:lower:]'`
    ansible-playbook deploy/deploy.yml -l app* -i environment/inventory -t ${comp_lower} -e tarball_location="dummy" -e component_dir_name="/src/${comp}" -e develop=true
done
