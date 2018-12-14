#!/bin/bash

# Run behat tests in the developement VM
vagrant ssh -c "/vagrant/deploy/tests/run-tests.sh $@"
