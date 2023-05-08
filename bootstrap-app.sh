#!/bin/bash

# Get vm_type
if [ "$v1" != "--vagant" ] && [ "$1" != "--docker" ]; then
    echo "Usage: $0 --vagrant|--docker"
    exit 1
fi

# Remove the first to characters from $1
vm_type=$(echo $1 | cut -c3- )

sudo=""
# Only vagrant VM requires sudo
if [ "$vm_type" == "vagrant" ]; then
    sudo="sudo"
fi

# Array of bootstrap command to run
commands=(
    "[ -f '/root/01-middleware-db_migrate.sh' ] && echo y | ${sudo} /root/01-middleware-db_migrate.sh"
    "[ -f '/root/01-webauthn-db_init.sh' ] && echo y | ${sudo} /root/01-webauthn-db_init.sh"
    "[ -f '/root/01-keyserver-db_init.sh' ] && ${sudo} /root/01-keyserver-db_init.sh"
    "[ -f '/root/01-tiqr-db_init.sh' ] && ${sudo} /root/01-tiqr-db_init.sh"
    "[ -f '/root/02-middleware-config.sh' ] && ${sudo} /root/02-middleware-config.sh"
    "[ -f '/root/04-middleware-whitelist.sh' ] && ${sudo} /root/04-middleware-whitelist.sh"
    "[ -f '/root/05-middleware-institution.sh' ] && ${sudo} /root/05-middleware-institution.sh"
    # Note that 06-middleware-bootstrap-sraa-users.sh is NOT idempotent
    "[ -f '/root/06-middleware-bootstrap-sraa-users.sh' ] && ${sudo} /root/06-middleware-bootstrap-sraa-users.sh"
)

# Run commands
if [ "$vm_type" == "vagant" ]; then
    for command in "${commands[@]}"; do
        echo "Running: ${command}"
        sudo="sudo; "vagrant ssh -c "${command}" app.stepup.example.com
    done
fi

if [ "$vm_type" == "docker" ]; then
    for command in "${commands[@]}"; do
        echo "Running: ${command}"
        docker exec -it stepupvm /bin/bash -c "${command}"
    done
fi