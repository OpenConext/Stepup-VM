#!/bin/bash

# Check required tools
REQUIRED_TOOLS=(
    "git"
)
for tool in "${REQUIRED_TOOLS[@]}"; do
    which ${tool} > /dev/null
    if [ $? -ne "0" ]; then
        echo "Error: Required command '${tool}' not found in path"
    fi
done

# Stop on error
set -e

# Make a src directory for holding the Stepup source repo's
# Note: If you want the sources to reside somewhere else, you can make "src" a symlink.
#       E.g.: ln -s ~/mysources src
if [ ! -e "./src" ]; then
    mkdir src
fi

# List of repositories (Format: <Github origanization>:<name>)
SOURCE_REPOS=(
    "OpenConext:Stepup-Gateway"
    "OpenConext:Stepup-Middleware"
    "OpenConext:Stepup-SelfService"
    "OpenConext:Stepup-RA"
    "OpenConext:Stepup-tiqr"
    "SURFnet:oath-service-php"
)

# Clone sources from github, if directory does not yet exist
for repo in "${SOURCE_REPOS[@]}"; do
    org=${repo%%:*}
    name=${repo#*:}
    if [ ! -e "./src/${name}" ]; then
        git clone https://github.com/${org}/${name}.git ./src/${name}
    fi
done


# Checkout the deploy repository as "deploy"
# Note: If you want the deploy repository to reside somewhere else, you can make "deploy" a symlink.
#       E.g.: ln -s ~/mydeployrepo deploy
if [ ! -e "./deploy" ]; then
    git clone https://github.com/OpenConext/Stepup-Deploy.git ./deploy
fi