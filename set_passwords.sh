#!/bin/bash

# Set default (known) passwords for:
# - mariadb (mysql) root user
# - yubico API

if [ ! -e "environment/yubico_secret_key" -o ! -e "environment/yubico_client_id" ]; then
    echo "Missing environment/yubico_secret_key or environment/yubico_client_id"
    echo "You must create these two files. Theae must contain the client id and secret for"
    echo "Accessing the Yubico API."
    echo ""
    echo "Get a free client id and secret key from: https://upgrade.yubico.com/getapikey/"
    echo "You need a yubikey. These are not free. See: https://www.yubico.com/products/yubikey-hardware/"
    echo ""
    echo "- Set the contents of '/environment/yubico_client_id' to the 'Client ID'. This is a"
    echo "  5 digit string.  Do not add a newline."
    echo "- Set the contents of './environment/yubico_secret_key' to the 'Secret key'. This is a"
    echo "  28 character long Base64 string. Do not add a newline."
    echo ""
    echo "If you want to continue without a yubikey you can use the included .sample files. Note that"
    echo "these values are not valid, thus authentication with yubikey will not possible."
    exit 1
fi

PASSWORDS=(
    "mariadb_root:password"
    "yubico_secret_key: $(cat environment/yubico_secret_key)"
)

# Encrypt passwords
for password in "${PASSWORDS[@]}"; do
    password_file=${password%%:*}
    password_value=${password#*:}

    echo "Setting password (plaintext): ${password_file}"
    echo "${password_value}" > "./environment/password/${password_file}"
done