#!/bin/sh
echo "app: network restart"; vagrant ssh app -c "sudo /etc/init.d/network restart" 
echo "manage: network restart"; vagrant ssh manage -c "sudo /etc/init.d/network restart" 
echo "lb: network restart"; vagrant ssh lb -c "sudo /etc/init.d/network restart" 
echo "db: network restart"; vagrant ssh db -c "sudo /etc/init.d/network restart" 
echo "ks: network restart"; vagrant ssh ks -c "sudo /etc/init.d/network restart" 
