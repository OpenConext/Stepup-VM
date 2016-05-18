#!/bin/bash

if [ $# -ne "1" ]; then
  echo "Use: ./deploy.sh <tarball prefix>"
  echo
  echo "Script to deploy the latest stepup component with the specified prefix."
  echo "Uses a lexical ordering (i.e. 'sort') of the matching filenames to pick te latest one."
  echo "Script must be run from the Stepup-VM dir."
  echo "Requires a local 'deploy' directory with a clone of the Stepup-Deploy repo"
  echo
  echo "Works especially well for development snapshots like 'Stepup-SelfService-develop-20150728150908Z-02ca2ed57a14a98d07e305efc7a67b6789cdd487.tar.bz2'"
  exit 1
fi

echo "Looking for latest of: ${1}"
tarball=`ls ${1}* | sort | tail -1`
echo "Deploying: ${tarball}"
./deploy/scripts/deploy.sh ${tarball} -i environment/inventory -l app.stepup.example.com,ks.stepup.example.com
