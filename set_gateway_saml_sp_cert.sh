#!/bin/bash

# Copy a known gateway SP SAML cert into the VM environment. This certificate is registered for the
# "https://gateway.stepup.example.com/authentication/metadata" SP in SURFconext (engine.surfconext.nl)

# Encrypt key for VM environment
./deploy/scripts/encrypt-file.sh -f ./cert/gateway_saml_sp.key ./environment/stepup-ansible-keystore/ > ./environment/saml_cert/gateway_saml_sp.key
# Copy certificate
cp ./cert/gateway_saml_sp.crt ./environment/saml_cert/gateway_saml_sp.crt