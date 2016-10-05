#!/bin/sh

# Running this script should fix any networking issues in the VMs

# Let vagrant rewrite the ansible inventory
vagrant provision

# Restart network service in the VMs
echo "app: network restart"; vagrant ssh app.stepup.example.com -c "sudo /etc/init.d/network restart"
echo "manage: network restart"; vagrant ssh manage.stepup.example.com -c "sudo /etc/init.d/network restart"
