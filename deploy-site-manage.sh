#!/bin/bash

echo ansible-playbook deploy/site.yml -i environment/inventory -l manage* 
ansible-playbook deploy/site.yml -i environment/inventory -l manage*
