#!/bin/bash
echo "Looking for latest of: ${1}"
tarball=`ls ${1}* | sort | tail -1`
echo "Deploying: ${tarball}"
./deploy/scripts/deploy.sh ${tarball} -i environment/inventory -l app.stepup.example.com,ks.stepup.example.com
