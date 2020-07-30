# Stepup-VM
Stepup-VM - Vagrant VMs for use with [Stepup-Deploy](https://github.com/OpenConext/Stepup-Deploy)

You can use the Vagrant file and scripts in this repository to create a complete Stepup system for testing or development purposes. After following the instructions in this repository you will have one or two virtual machines.

1. app.stepup.example.com with a fixed IP of 192.168.66.3. This machine hosts all the stepup applications and the database.
2. manage.stepup.example.com (optional) with a fixed IP of 192.168.66.4. This machine hosts the ELK stack.

The app VM includes an IdP and an SP that you can immediately use for testing Stepup.

Two different setups are supported:

1. Everything is installed in the VM, the Stepup components are installed from tarballs. This closely matches a production setup
2. A developemnt setup. The source repositories of the Stepup components are located on the host and are mounted in the VM. Installation from source (git clone), not tarball. This setup is suitable for development as it allows modification and debugging of the code from an IDE on the host.

# Requirements

These are the requirements for a minimal installation and results in a Stepup system where Yubikey and U2F tokens can be used. Using other token types has additional requirements.

Requirements:
- a YubiKey
- VirtualBox / VMware Fusion or Workstation
    - VirtualBox requirements:
        - virtualbox-extension-pack
        - vagrant-vbguest
- Vagrant
- Ansible 2.x (< 2.4)
- bash, openssl, git
- keyczart and keytool

See the [Stepup-Deploy README](https://github.com/OpenConext/Stepup-Deploy/blob/develop/README.md) for more detailed information on (installing) the requirements above.

# Production Stepup-VM guide 

This installs a Stepup-VM for testing purposes. Installation of the stepup components is from the prebuild tarballs that are hosted on github.

Ensure that you have all the tools installed:
- Vagrant with the VirtualBox or the VMWare provider
- git, openssl, bash
- Ansible 2.x (< 2.4). Can be installed using pip:
  `pip install "ansible<2.4"`
- keyczart and keytool. These can be installed using pip:
  `pip install python-keyczar`

A fast (wired) connection is recommended while setting up the VM. The VM has been configured to cache downloaded rpms and composer packages in the Stepup-VM/vagrant directory, so releated installatinos are faster.

## Setup repositories

We will assume that you are working in a directory `~/workspace`.

* Clone the Stepup-VM (this) repository into `~/workspace`
```
cd ~/workspace/
git clone https://github.com/OpenConext/Stepup-VM
```

* Checkout the Stepup-Deploy repository that matches the Stepup components that you want to deploy. E.g. "master" (latest release), "branch-release-15" (a specific release) or "develop" (current development version)
```
git clone -b master https://github.com/OpenConext/Stepup-Deploy 
```

* Create a symlink named "deploy" in Stepup-VM that points to Stepup-Deploy. This link is used by the various scripts in Stepup-VM that use Stepup-Deploy.
```
ln -s ~/workspace/Stepup-Deploy ~/workspace/Stepup-VM/deploy
```

## Create app.stepup.example.com VM

Vagrant is used to create the app.stepup.example.com VM. Vagrant uses Ansible to provision to configure the networking in the VM and to do a yum update. This takes a while. If you have the resources, you could increase the memory from 2 to 3 or 4 GB by editing the ~/workspace/Stepup-VMVagrant file.

Add the following to your hosts-file:

```
192.168.66.3 app.stepup.example.com gateway.stepup.example.com selfservice.stepup.example.com ra.stepup.example.com tiqr.stepup.example.com tiqr.stepup.example.com middleware.stepup.example.com ks.stepup.example.com keyserver.stepup.example.com db.stepup.example.com ssp.stepup.example.com
192.168.66.4 manage.stepup.example.com
```
Start the creation of the Virtual machines by running
```
~/workspace/Stepup-VM 
vagrant up
```

This takes a while. In the mean time:

Initialise the Ansible environment
```
cd ~/workspace/Stepup-VM
./init-env.sh
```

Get an API key for using the Yubico authentication service at https://upgrade.yubico.com/getapikey/
This requires a YubiKey. This gives you a client ID and a secret key for accessing the Yubico authentication service. You need to authenticate with an YubiKey to get them.
Copy the client ID to environment/yubico_client_id and the secret key to environment/yubico_secret_key. E.g:
```
echo '12345' > ./environment/yubico_client_id
echo 'AAAAAAAAAAAAAAAAAAAAAAAAAAA=' > ./environment/yubico_secret_key
```
Put the ID of your YubiKey in environment/yubikey_id. This ID is printed on your YubiKey ans is 8 digits. If this id is less then 8 characters prepend with 0. E.g. 
```
echo '12345678' > ./environment/yubikey_id
```

Set some passwords to known values:
```
./set_passwords.sh
```

When Vagrant is done provisionning the VM, continue with the setup of the app VM.
Deploy the stepup components in the app VM:
```
./deploy-release
```

Bootstrap the database
```
bootstrap-app.sh
```

Now you can login to (username/password: admin/admin):
https://selfservice.stepup.example.com
https://ra.stepup.example.com (requires authentication with the yubikey ID you set previously

Note that the admin account is an SRAA (i.e. super user, root for stepup). This account can be
used to vet and administer additional users.

Read mail in mailcatcher at: http://app.stepup.example.com:1080

There is a test SP installed at https://ssp.stepup.example.com/sp.php that can authenticate to the Stepup-Gateway


# Test Accounts

The Stepup-VM includes a simplesamlphp IdP (and SP) for testing purposes. This test IdP contains accounts that are usefull for testing. All accounts use the username as the password. 

The IdP has an "admin" account that has Super RA Administrator (SRAA) rights in Stepup. This account can be used to access all institutions.

There are many test user accounts available they have the form: 
(joe|jane)-(a|b|c|d)(1|2|3|4|5|-yk|-tiqr|-u2f|-bio|-ra|-raa)

The only part that has meaning is the "(a|b|c|d)" part. This determines the value of the schacHomeOrganization attribute of the user, which corresponds to the "institution" of the user in Stepup.
"a" corresponds to "institution-a.example.com", "b" corresponds to "institution-b.example.com", "c" corresponds to "institution-c.example.com" and "d" corresponds to "Institution-D.example.com" (note: mixed case).
 
Some example usernames: joe-a1, joe-a2, jane-a1, joe-d4, jane-b-yk, jane-b-raa, ...
For all usernames the password equals the username. E.g. "joe-c5" has password "joe-c5"


# Mailcatcher

Mailcatcher is installed to catch all mail send from the environment.  

http://app.stepup.example.com:1080


# Kibana

Syslog messages from the app and manage VMs are send to ELK on manage.stepup.example.com. The can be accessed using Kibana: https://manage.stepup.example.com/kibana4

username: stepup
password: password

The first time you login you are asked to "Configure an index pattern". The defaults are OK, but you need to select a "Time-field name". Set it to "generated_at". 

Recommended Settings:
* Index contains time-based events (checked)
* Use event times to create index names (unchecked)
* Index name or pattern: "logstash-*"
* Time-field name: "generated_at"

Choose "Discover" to start searching / filtering. See https://www.elastic.co/guide/en/kibana/4.6/discover.html for more information.


# Development Stepup-VM guide

## 1. Create two VMs using Vagrant

```
$ vagrant up
```

This creates two VMs:
1. `app.stepup.example.com`. This VM is going to host the application stack (CentOS7-Nginx-PHP-FPM-MariaDB)
2. `manage.stepup.example.com`. This VM is going to host the ELK stack (Elastic Search-Logstash-Kibana)

Vagrant is used to create two VMs:
- The VMs have are given an additional fixed IP in the 192.168.66.0/24 network. This IP is used for inter VM communication and to access the Stepup applications from the host. The VMs also keep their DHCP assigned IP. This dynamicly assigned IP is used by Vagrant and Ansible.
- Vagrant writes the Ansible inventory. "environment/inventory" is a symlink to this inventory.
- Vagrant uses Ansible to provision the VM
  - Configures yum to cache RPMs to /vagrant/yum and to hold back kernel packages
  - Runs yum update
  - Configures networking in the VM
  - In addition to the "/vagrant" share that is mounted by default in Vagrant, an additional share is mounted: "/src". This share is used to mount the Stepup component sources from the host in the app VM. 
  - That's all. The rest of the setup is done via scripts.  
 
## 2. Clone git repositories

```
$ clone-repos.sh
```

The script clones read only (i.e. https://) versions of the Stepup repositories from GitHub into the "./src" directory:

- Stepup-Gateway
- Stepup-Middleware
- Stepup-RA
- Stepup-SelfService 
- Stepup-tiqr
- oath-service-php

You can put your existing repos here or update them as long als you keep the directory names.

The script clones the Stepup-Deploy repo as ./deploy. This repository contains the Ansible playbooks for setting up the VMs and for deploying the Stepup applications to them.

## 3. Create an "environment"

```
$ init-env.sh
```

This script creates an new Ansible environment. This contains all the configuration for the Stepup VMs. This "environment" will be stored in the "environment" directory and is created from a template environment in Stepup-Deploy (deploy/environments/template). 

The template environment is already setup such that it is almost ready to use for creating the Stepup-VM. During the first step Vagrant created an inventory that is suitable for use with the Stepup-VM. However a few changes need to be made to complete it. You could make these changes directly, however each time you recreate the environment, you need to reapply these changes. So a mechanism was created to make these changes without modifying files created by the template environment:

The Ansible variables that need to be set are put "environment/host_vars/app.stepup.example.com.yml". This file is part of the Stepup-VM repo. The values are read from files in the environment directory. You set the values there.

1. Get an API key for using the Yubico authentication service at https://upgrade.yubico.com/getapikey/ This requires a YubiKey. This gives you a client ID and a secret key for accessing the Yubico authentication service
      
  - Copy the client ID to environment/yubico_client_id. E.g. `echo '12345' > ./environment/yubico_client_id`.
  - Copy the secret key to environment/yubico_secret_key. E.g. `echo 'AAAAAAAAAAAAAAAAAAAAAAAAAAA=' > ./environment/yubico_secret_key`. 
      
2. Put the ID of your YubiKey in environment/yubikey_id. E.g. `echo '12345678' > ./environment/yubikey_id`. This ID is printed on your YubiKey. If this id is less then 8 characters prepend with 0'.

During creation of the new environment new, random, passwords and certificates are generated. Because it is convenient to have some simple known passwords there is a script that sets these passwords:
  
```  
$ set_passwords.sh
```
This script will also encrypt the value from the "/environment/yubico_secret_key" and write it to "environment/password/yubico_secret_key".

## 4. Deploy the app server 

```
$ deploy-site-app.sh
```

This script runs the Ansible playbook "site.yml" on the app server (app.stepup.example.com). This sets up everything on the server, except the Stepup applications themselves: nginx, php-fpm, logging, mail, firewall
 
Because this is a development server:
- MariaDB galera cluster is bootsrapped and configured as one node and a script is installed to bootstrap the node after boot. 

## 5. Use the test GSSP's

You could add the hosts below to your `/etc/hosts` file to use the test GSSP's
```
192.168.66.3 demo-gssp.stepup.example.com demo-gssp-2.stepup.example.com
```

# Troubleshooting

## I'm getting an error while creating / setting up the VM's 

All the scrips are written such that they can be safely run again. So you can fix end then retry a step without having to redo everything. 

Note that even though a yum / composer cache are kept outside the VM you do need a network connection to (re)create a VM.


## Where are the logs?

The app server is configured to log all messages to syslog, you can find these in /var/log/messages:
```
$ vagrant ssh
$ sudo tail /var/log/messages
```

Same for the management server:
```
$ vagrant ssh manage.stepup.example.com
$ sudo tail /var/log/messages
```

The logs are also accessible in processed, searchable form in Kibana. See the section about "Kibana" above. 

## Getting the ID of a YubiKey

The ID of a YubiKey as used in Stepup is an 8 digit number. This number is printed on the yubikey. 

You can also get this ID by decoding the first 12 characters of an OTP generated by the token and prefixing 0's until it is 8 digits long. The output of a YubiKey us ModHex encoded. You can find a ModHex decoder at https://demo.yubico.com/modhex.php. Make sure you set "Format" to "ModHex" before converting.
 
E.g. If the first 12 characters of your YubikeyOutput are "ccccccbdthji" this decodes to the number "1234567". Prefixing a "0" gives a yubikey ID of "01234567". 

## Cannot connect to a VM anymore

- Verify that it is running: 
    ```
    $ vagrant up app.stepup.example.com 
    $ vagrant up manage.stepup.example.com
    ```
- Reboot it:
    ```
    $ vagrant reload app.stepup.example.com 
    $ vagrant reload manage.stepup.example.com
    ```
    
## Ansible cannot connect to the box anymore

- If you can connect to the box using `vagrant ssh`, provisioning it again can help. This recreates the Ansible inventory and restarts networking in the VM:
    ```
    $ vagrant provision app.stepup.example.com 
    $ vagrant provision manage.stepup.example.com
    ```

- Run Ansible with the "-vvvv" option to get more details.


## Fusion network configuration

The VMs get a fixed IP in the 192.168.66/24 network. This is added by fusion automatically. 
When you experience problems with the 192.168.66/24 network verify that it is setup correctly in `/Library/Preferences/VMware\ Fusion/networking`. 
You can disable DHCP for the 192.168.66.* network.
 
To restart Fusing networking:
```
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --stop
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --start
```

Other usefull commands:
```
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --status
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --configure
```

## Changing git repo remotes

The clone-repos.sh script checks out the repos using https:// url from the OpenConext / SURFnet orgs.
If you want to push your changes to a different repo (e.g. an fork) or if you want to use your SSH key 
for authentication you need to change the remote origin of the repo.
 
Use `git remote -v` to see the current origin of a repo. E.g.:
```
$ git remote -v
origin	https://github.com/OpenConext/Stepup-Gateway.git (fetch)
origin	https://github.com/OpenConext/Stepup-Gateway.git (push)
```

Use `git remote set-url origin` to update the origin of a repo. E.g.:
```
$ git remote set-url origin git@github.com:OpenConext/Stepup-Gateway.git
```
This updates both the fetch and the push URL.


## The database did not start

The database is a MariaDB Galera cluster that consists of one node and that runs on the app.stepup.example.com VM. It cannot be started using "service mysql start". Instead it needs to be bootstrapped. To bootstrap it login to the app server and as root run `service mysql bootstrap`:
 
```
$ vagrant ssh app.stepup.example.com
$ sudo service mysql bootstrap
```
