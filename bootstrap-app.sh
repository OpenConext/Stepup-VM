#!/bin/bash

vagrant ssh -c "echo y | sudo /root/01-gateway-db_migrate.sh" app.stepup.example.com
vagrant ssh -c "echo y | sudo /root/01-middleware-db_migrate.sh" app.stepup.example.com
vagrant ssh -c "sudo /root/01-keyserver-db_init.sh" app.stepup.example.com
vagrant ssh -c "sudo /root/01-tiqr-db_init.sh" app.stepup.example.com
vagrant ssh -c "sudo /root/02-middleware-config.sh" app.stepup.example.com
vagrant ssh -c "sudo /root/04-middleware-whitelist.sh" app.stepup.example.com
vagrant ssh -c "sudo /root/05-middleware-institution.sh" app.stepup.example.com
# Note that 06-middleware-bootstrap-sraa-users.sh is NOT idempotent
vagrant ssh -c "sudo /root/06-middleware-bootstrap-sraa-users.sh" app.stepup.example.com
