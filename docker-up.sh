#!/bin/bash

set -e

image="stepupvm:latest"
# Set image to the first parameter of this script, if it is given
# You can use this to start a different image, e.g. stepupvm:mytag that
# you created using e.g.:
#   docker commit stepupvm stepupvm:mytag
#
# The container is always named "stepupvm". This means that when using this scrip, you can have
# only one container running at a time. If you want to run multiple containers, you must use
# docker directly.

function show_tips()
{
    echo
    echo "Tips:"
    echo "* You create an image from the container using:"
    echo "    docker stop stepupvm && docker commit stepupvm stepupvm:mytag"
    echo
    echo "  You can then start a new container from that image using:"
    echo "    ./docker-up.sh stepupvm:mytag"
    echo "  To do that you must stop and remove a running stepupup container first using:"
    echo "    docker stop stepupvm && docker rm stepupvm"
    echo
    echo "* To log in to the container run:"
    echo "    ./docker-bash.sh"
    echo
    echo "Next steps:"
    echo "* Create the environment, if you haven't done so already. See README.md"
    echo
    echo "* Deploy app role from site.yaml:"
    echo "    ./deploy-site-app.sh --docker"
    echo
    echo "* Deploy Stepup components from prebuild tarballs"
    echo "    ./deploy-release.sh --docker"
    echo "* Deploy Stepup components from source"
    echo "    ./deploy-develop.sh --docker"
    echo
}

# Set image to use to create the container from
if [[ "$1" != "" ]]; then
  image="$1"
fi


# Check whether docker container named stepupvm is already running
if [[ "$(docker ps -q -f name=stepupvm 2> /dev/null)" != "" ]]; then
  echo "Docker container \"stepupvm\" is already running. Nothing to do"
  show_tips
  exit 0  
fi


# Check whether docker is using cgroup v1
# If not, exit with error
echo "Checking whether docker is using cgroup v1."
if [[ "$(docker info | grep 'Cgroup Version: 1')" == "" ]]; then
  echo "Docker is not using cgroup v1. Please configure docker to use cgroup v1."
  echo
  echo "For Docker Desktop OSX set '"deprecatedCgroupv1": true' in "
  echo "'~/Library/Group Containers/group.com.docker/settings.json' and restart Docker Desktop."
  echo
  echo "On linux set the kernel parameter 'systemd.unified_cgroup_hierarchy=0' during boot."

  exit 1
fi

# Check whether docker container named already stepupvm exists
if [[ "$(docker ps -aq -f name=stepupvm 2> /dev/null)" != "" ]]; then
  # Exists but is not running
  echo "Docker container \"stepupvm\" exists but is not running. Starting it."
  docker start stepupvm
  if [ $? -ne 0 ]; then
    echo "Failed to start docker container stepupvm"
    exit 1
  fi
  echo "Started Docker container 'stepupvm'"
  echo
  show_tips
  exit 0
fi

# Check whether docker image stepupvm:latest exists
echo "Checking whether Docker image ${image} exists."
if [[ "$(docker images -q "${image}" 2> /dev/null)" == "" ]]; then
  echo "Docker image ${image} does not exist."
  if [[ "$image" == "stepupvm:latest" ]]; then
    docker build --pull --rm -f "Dockerfile" -t stepupvm:latest "."
  else
    echo "Please build the docker image ${image} first."
    exit 1
  fi
fi

# Get directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Docker HOST IP
host_ip=127.0.0.1

# Start docker container stepupvm from image stepupvm:latest
echo "Starting docker container stepupvm"
docker run -d --name stepupvm \
           --hostname="app.stepup.example.com" \
           --add-host="middleware.stepup.example.com:127.0.0.1" \
           --add-host="keyserver.stepup.example.com:127.0.0.1" \
           --add-host="db.stepup.example.com:127.0.0.1" \
           --tmpfs /tmp \
           --tmpfs /run \
           -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
           -v "${SCRIPT_DIR}/yum:/var/cache/yum" \
           -v "${SCRIPT_DIR}/composer_cache:/composer_cache" \
           -v "${SCRIPT_DIR}/tarballs:/tarballs" \
           -v "${SCRIPT_DIR}/src:/src" \
           -v "${SCRIPT_DIR}/deploy:/deploy" \
           -v "${SCRIPT_DIR}/environment:/environment" \
           -p $host_ip:13306:3306 \
           -p $host_ip:1025:1025  \
           -p $host_ip:1080:1080  \
           -p $host_ip:80:80      \
           -p $host_ip:443:443    \
           "$image"
if [ $? -ne 0 ]; then
  echo "Failed to start docker container stepupvm"
  exit 1
fi

#     host:container
# -p 13306:3306    \ MariaDB
# -p  1025:1025    \ Mailcatcher SMTP
# -p  1080:1080    \ Mailcatcher web interface
# -p  2080:80      \ NGINX HTTP
# -p 20443:443     \ NGINX HTTPS

echo "Started Docker container 'stepupvm' from image '${image}'"
show_tips
