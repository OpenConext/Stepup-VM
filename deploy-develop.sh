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
    echo $comp
#    ./deploy/scripts/deploy.sh ./tarballs/${comp} -i ./environment/inventory -l 'app*'
done
