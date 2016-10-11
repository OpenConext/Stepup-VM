#!/bin/sh

COMPONENTS_RELEASE_7=(
"Stepup-Gateway-2.1.0-20160808153413Z-99293417f90edc05415e7fa7b2873f563de7a8cd.tar.bz2"
"Stepup-Middleware-2.0.2-20160810101855Z-d8d88d778ea30379b606cbca58d9634ff0541b42.tar.bz2"
"Stepup-SelfService-2.1.0-20160812150713Z-0fe329a64b14e0f15cb956cd0c043e4b1595d8d7.tar.bz2"
"Stepup-RA-2.1.2-20160815123919Z-8939c8b11b1de79c3018ce7c7b4fe9d2ac62462b.tar.bz2"
"Stepup-tiqr-1.1.2-20160411073201Z-4e2581d65b4c589031df524b30627474eca9fa50.tar.bz2"
"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
)

COMPONENTS=( "${COMPONENTS_RELEASE_7[@]}" )


for comp in "${COMPONENTS[@]}"; do
    ./deploy/scripts/deploy.sh ./tarballs/${comp} -i ./environment/inventory -l 'app*'
done
