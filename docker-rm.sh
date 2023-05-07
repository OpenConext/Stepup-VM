#!/bin/bash

set -e

# Ask for confirmation, unless -y is given
if [[ "$1" != "-y" ]]; then
  read -p "Are you sure you want to remove the docker container stepupvm and the docker image stepupvm:latest? [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    echo "Aborting."
    exit 1
  fi
fi

# Stop docker container stepupvm if it is running
echo "Stopping docker container stepupvm"
docker stop stepupvm || true

# Remove docker container stepupvm, forced, including anonymous volumes
echo "Removing docker container stepupvm"
docker container remove -f -v stepupvm || true

# Remove docker image stepupvm:latest, forced
echo "Removing docker image stepupvm:latest"
docker image remove -f stepupvm:latest || true
