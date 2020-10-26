#!/bin/bash

# This script:
# - Clones the Stepup repo's of the gateway, middleware, RA, selfservice and keyserver components for a development
#   deploy from github into /src
# - Clones the Stepup-Deploy repo into /deploy
#
# Run this script from the Stepup-VM directory
#
# Will not overwrite existing directories

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
    echo "Creating src directory"
    mkdir "src"
else
    echo "Directory ./src exists. Not creating that directory."
fi

# List of repositories (Format: <Github origanization>:<name>)
SOURCE_REPOS=(
    "OpenConext:Stepup-Gateway"
    "OpenConext:Stepup-Middleware"
    "OpenConext:Stepup-SelfService"
    "OpenConext:Stepup-RA"
    "OpenConext:Stepup-tiqr"
    "SURFnet:oath-service-php"
    "OpenConext:Stepup-Webauthn"
    "OpenConext:Stepup-Azure-MFA"
)

# Clone sources from github, if directory does not yet exist
for repo in "${SOURCE_REPOS[@]}"; do
    org=${repo%%:*}
    name=${repo#*:}
    if [ ! -e "./src/${name}" ]; then
        echo "git clone https://github.com/${org}/${name}.git ./src/${name}"
        git clone https://github.com/${org}/${name}.git ./src/${name}
    else
        echo "Directory ./src/${name} exists. Skipping git clone into that directory."
    fi
done


# Checkout the deploy repository as "deploy"
# Note: If you want the deploy repository to reside somewhere else, you can make "deploy" a symlink.
#       E.g.: ln -s ~/mydeployrepo deploy
if [ ! -e "./deploy" ]; then
    echo "git clone https://github.com/OpenConext/Stepup-Deploy.git ./deploy"
    git clone https://github.com/OpenConext/Stepup-Deploy.git ./deploy
else
    echo "Directory ./deploy exists. Skipping git clone into that directory."
fi



if [ ! -e "./src/stepup-demo-gssp" ]; then
  git clone https://github.com/OpenConext/Stepup-gssp-example.git ./src/stepup-demo-gssp
else
  echo "Directory ./src/Stepup-gssp-example exists. Skipping git clone into that directory."
fi

if [ ! -e "./src/stepup-demo-gssp-2" ]; then
  git clone https://github.com/OpenConext/Stepup-gssp-example.git ./src/stepup-demo-gssp-2
else
  echo "Directory ./src/Stepup-gssp-example-2 exists. Skipping git clone into that directory."
fi

echo "OK."