#!/bin/bash

# Set a known password ("password") for kibana (https://manage.stepup.example.com/kibana4)

password="password"
tempfile=`mktemp -t set_kb_pwd.XXXXX`
echo -n ${password} > "$tempfile"
crypt=`./deploy/scripts/encrypt-file.sh ./environment/stepup-ansible-keystore/ -f "$tempfile"`
if [ $? -ne "0" ]; then
    echo "Encryption failed"
    rm "$tempfile"
    exit 1
fi
rm "$tempfile"
echo "${crypt}" > ./environment/password/manage_kibana

