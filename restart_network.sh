#!/bin/sh
vagrant ssh app -c "sudo /etc/init.d/network restart"
vagrant ssh manage -c "sudo /etc/init.d/network restart"
