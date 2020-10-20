# Stepup-VM
Stepup-VM – A Vagrant VM for use with [Stepup-Deploy](https://github.com/OpenConext/Stepup-Deploy)

You can use the Vagrant file and scripts in this repository to create a complete Stepup system for testing or development purposes. After following the instructions in this repository you will have one virtual machine `app.stepup.example.com` with a fixed IP of 192.168.66.3. This machine hosts all the stepup applications, the database and an IdP and SP for testing. To create a true production setup follow the instructions from [Stepup-Deploy](https://github.com/OpenConext/Stepup-Deploy) instead.

Two different setups are supported:

1. Test setup - A setup that is aimed at testers and others that want to try out or explore Stepup. Everything is installed in the VM, the Stepup components are installed from the same tarballs that are used for a production install. This closely matches a production setup. The main difference is that test tooling is installed in the VM. This provides you with a self-contained Stepup installation that allows you to use most of its functionality.
2. Development setup - A setup that is aimed at developers working on Stepup. The source repositories of the Stepup components are located on the host and are mounted in the VM. Installation is from source (git clone), not tarball. This setup is suitable for development as it allows modification and debugging of the code from an IDE on the host.

# Requirements

These are the requirements for a minimal installation and results in a Stepup system where Yubikey and "demo-gssp" tokens can be used. Using one of the other Stepup token types has additional requirements.

Requirements:
- a YubiKey
- VirtualBox / VMware Fusion or Workstation
    - VirtualBox requirements:
        - virtualbox-extension-pack
        - vagrant-vbguest
- Vagrant
- Ansible version 2.8
- bash, openssl, git
- keyczart and keytool

See the [Stepup-Deploy README](https://github.com/OpenConext/Stepup-Deploy/blob/develop/README.md) for more detailed information on (installing) the requirements above.

# Testing Stepup-VM installation guide 

This installs a Stepup-VM for testing purposes a.k.a "test mode". Installation of the stepup components is from the prebuild tarballs that are hosted on github. This installation type is recommended for testing Stepup functionality or for testing and developing the Stepup-Deploy Ansible playbook and deploy scripts.

If you are going to do significant development on the Stepup components themselves, installing the Stepup-VM in "development" mode is probably a better option. See the [Development Stepup-VM guide](#Development-stepup-vm-installation-guide) section below for the installation instructions for a development setup.

Ensure that you have all the tools installed:
- Vagrant with the VirtualBox or the VMWare provider
- git, openssl, bash
- Ansible can be installed using pip using pip. Because newer or much older Ansible versions may have incompatibilities it is recommended you stick to a known working Ansible release. To limit the Ansible version to E.g. version 2.8 :
  `pip install "ansible<2.9"`
- keyczart and keytool. These can be installed using pip:
  `pip install python-keyczar`

A fast (wired) internet connection is recommended while setting up the VM. The VM has been configured to cache downloaded rpms and composer packages in the Stepup-VM/vagrant directory, so repeated installs of the VM are faster.

## Setup repositories

We will assume that you are working in a directory `~/workspace`.

* Clone the Stepup-VM (this) repository into `~/workspace`
```
cd ~/workspace/
git clone https://github.com/OpenConext/Stepup-VM
```

* Checkout the Stepup-Deploy repository that matches the Stepup components that you want to deploy. E.g. "master" (latest release), "branch-release-17" (a specific release) or "develop" (current development version)
```
git clone -b master https://github.com/OpenConext/Stepup-Deploy 
```

* Create a symlink named "deploy" in Stepup-VM that points to Stepup-Deploy. This link is used by the various scripts in Stepup-VM that use Stepup-Deploy.
```
ln -s ~/workspace/Stepup-Deploy ~/workspace/Stepup-VM/deploy
```

## Create app.stepup.example.com VM

Vagrant is used to create the app.stepup.example.com VM. Vagrant uses Ansible to provision the VM and to configure the networking in the VM and to do a yum update. This takes a while. The VM is configured with 4 GB of memory if you are not using the VM in development mode you should be able to get away with 2GB. You can change the amount by editing the ~/workspace/Stepup-VM/Vagrant file.

### Update hosts file
Add the following to your hosts-file. This allows you to access the vhosts in the VM by their name from the host:

```
192.168.66.3 app.stepup.example.com gateway.stepup.example.com selfservice.stepup.example.com ra.stepup.example.com tiqr.stepup.example.com tiqr.stepup.example.com middleware.stepup.example.com ks.stepup.example.com keyserver.stepup.example.com db.stepup.example.com ssp.stepup.example.com demo-gssp.stepup.example.com demo-gssp-2.stepup.example.com
```
### Create VM and run the Vagrant provisioning steps
Start the creation of the Virtual machines by running
```
~/workspace/Stepup-VM 
vagrant up
```
This will create and configure the VM. An Ansible provisioning step is configured in Vagrant that creates an Ansible inventory and runs the provision.yml playbook in the VM. You can repeat the provision using `vagrant provision`.

All this takes a while. In the mean time you can continue with the next few steps as these do not require VM.

### Initialise the Ansible environment
Initialise the Ansible environment:
```
cd ~/workspace/Stepup-VM
./init-env.sh
```

### Get a Yubico API key
Get an API key for using the Yubico authentication service at https://upgrade.yubico.com/getapikey/
This requires a YubiKey. Getting the API key is instant and free. The API key consists of a client ID and a secret key for accessing the Yubico authentication service.
Copy the client ID to environment/yubico_client_id and the secret key to environment/yubico_secret_key. E.g:
```
echo '12345' > ./environment/yubico_client_id
echo 'AAAAAAAAAAAAAAAAAAAAAAAAAAA=' > ./environment/yubico_secret_key
```
Put the ID of your YubiKey in environment/yubikey_id. This ID is printed on your YubiKey and is 8 digits. If this ID is less then 8 characters prepend with '0' to make it 8 characters long. E.g.
```
echo '12345678' > ./environment/yubikey_id
```

### Set yubikey secrets and mariadb root password
The password for the mariadb root account is set "password"
The Yubikey secret is set from the ./environment/yubico_secret_key
```
./set_passwords.sh
```

### Deploy the stepup applications into the VM
When Vagrant is done provisioning the VM, continue with the setup of the app VM.
Deploy the stepup components in the app VM:
```
./deploy-release.sh
```

Bootstrap the database
```
./bootstrap-app.sh
```

Now you can login to the selfservice and RA interfaces (username/password: admin/admin):
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


# Development Stepup-VM installation guide

The Stepup-VM in "develop mode" is specifically targeted to developers. The main differences with the testing installation is that the components are installed and run from source and that these sources reside on the host and are mounted into the VM. This facillitates developing using an IDE on the host. The drawback is that this is a more complex setup and that the speed and reliabillity of the mounting in the VM depends on the combination of the host OS and the hypervisor (VirtualBox or Vagrant) that is used. The Vagrant file in this repo includes alternative mouting options that may work better in your particular setup. It may require some experimentation to arrive at a working combination unfortunatly.

## 1. Create the development VM

```
$ ./vagrant-up-dev-vm
```
This command runs `vagrant up`, setting `ENV=dev`. This enables the Vagrant configuration that mounts the `vagrant/src` directory on the host into `/src/` in the VM. This share is used to mount the Stepup component sources from the host in the app VM.

Vagrant creates the `app.stepup.example.com` VM. This VM is going to host the application stack (CentOS7-Nginx-PHP-FPM-MariaDB)

- Vagrant writes the Ansible inventory. "environment/inventory" is a symlink to this inventory.
- Vagrant uses Ansible to provision the VM by running the provision.yml playbook. This:
  - Configures yum to cache RPMs to /vagrant/yum and to hold back kernel packages
  - Runs yum update
  - Configures networking in the VM

## 2. Clone git repositories

```
$ ./clone-repos.sh
```

The script clones read only (i.e. https://) versions of the develop branch of the Stepup repositories from GitHub into the "./src" directory:

The core Stepup components:

- Stepup-Gateway
- Stepup-Middleware
- Stepup-RA
- Stepup-SelfService

GSSPs (these provide additional second factor types):

- Stepup-Azure-MFA
- Stepup-tiqr
- Stepup-Webauthn

Two demo GSSPs for testing. The are two cones of "OpenConext/Stepup-gssp-example":

- stepup-demo-gssp
- stepup-demo-gssp-2

Keyserver that can be used by Tiqr (default not used):

- oath-service-php

You can put your existing repos here or update them as long als you keep the directory names the same.

You may find that you have to change the ACL on the files/directories that are shared with the VM. Each OS behaves different in this respect. It may work out of the box, or it may not.

The script clones the Stepup-Deploy repo as ./deploy. This repository contains the Ansible playbooks for setting up the VMs and for deploying the Stepup applications to them.

## 3. Create an "environment"

```
$ ./init-env.sh
```

This script creates an new Ansible environment. This contains all the configuration for the Stepup VMs. This "environment" will be stored in the "environment" directory and is created from a template environment in Stepup-Deploy (deploy/environments/template). 

The template environment is already setup such that it is almost ready to use for creating the Stepup-VM. During the first step Vagrant created an inventory that is suitable for use with the Stepup-VM. However a few changes need to be made to complete it. You could make these changes directly, however each time you recreate the environment, you need to reapply these changes. So a mechanism was created to make these changes without modifying files created by the template environment:

The Ansible variables that need to be set are put "environment/host_vars/app.stepup.example.com.yml". This file is part of the Stepup-VM repo. The values are read from files in the environment directory. You set the values there.

1. Get an API key for using the Yubico authentication service at https://upgrade.yubico.com/getapikey/ This requires a YubiKey. This gives you a client ID and a secret key for accessing the Yubico authentication service
      
  - Copy the client ID to environment/yubico_client_id. E.g. `echo '12345' > ./environment/yubico_client_id`.
  - Copy the secret key to environment/yubico_secret_key. E.g. `echo 'AAAAAAAAAAAAAAAAAAAAAAAAAAA=' > ./environment/yubico_secret_key`. 
      
2. Put the ID of your YubiKey in environment/yubikey_id. E.g. `echo '12345678' > ./environment/yubikey_id`. This ID is printed on your YubiKey. If this id is less then 8 characters prepend with 0 until it is 8 characters'.

During creation of the new environment new, random, passwords and certificates are generated. Because it is convenient to have some simple known passwords there is a script that sets these passwords:
  
```  
$ ./set_passwords.sh
```
This script sets the mariadb root password to "password". Additionally this script encrypts the value from the "/environment/yubico_secret_key" and writes it to "environment/password/yubico_secret_key".


## 4. Deploy the app server 

```
$ ./deploy-site-app.sh
```

This script runs the Ansible playbook "site.yml" on the app server (app.stepup.example.com). This sets up everything on the server, except the Stepup applications themselves: nginx, php-fpm, logging, mail, firewall
 
Because this is a development server:
- MariaDB galera cluster is bootstrapped and configured as one node and a script is installed to bootstrap the node after boot.

Any additional parameters you add to `deploy-site-app.sh` are passed to Ansible. To only deploy the "app" role use E.g. `./deploy-site-app.sh -t app`

## 5. Add the vhosts to your hosts file

The idea is that you use the a webbrowser from your hosts to access the stepup applications. To be able to do this your hosts needs to able to resolve their DNS names. To do this add the contents of the <Stepup-VM>/hosts file below to your `/etc/hosts` file.

## 6. Deploy the components

At a minimum you need to deploy: stepup-middleware, stepup-gateway, stepup-selfservice and stepup-ra
The other components are (test) GSSPs that provide additional second factor types.

Use the `./deploy-develop.sh` script do deploy the components in develop mode. Running `./deploy-develop.sh` without arguments deploys all components. It stops on error. Heed the hints provided by the script when it fails and read the troubleshooting section below. Not all components can be deployed twice, this happens especially after the components configuration has been written. This is done by the Ansible tasks that follow the composer install task.

To deploy individual components, use `./deploy-develop.sh <component-name>`. E.g. `./deploy-develop.sh stepup-middleware`


## 7. Bootstrap the stepup components

"Bootstrapping" consists of running a set of scripts in the VM that initialise the database schema's that are used by the components, push the middleware configuration and create (bootstrap) the SRAA users.

Run the `./bootstrap-app.sh` script to run all the scripts in the right order. This is the same as logging in to the VM and running the scripts from there. The scrips are in the `/root` directory.

## 8. Done!

Congratulations! Now you should be able to use Stepup-VM in develop mode.

Go to https://selfservice.stepup.example.com and login using user `admin` with password `admin`. You should see the yubikey_id that you set in Step 3 here. The admin user is also SRAA, which means that this account can also login to https://ra.stepup.example.com


# Troubleshooting

## I'm getting an error while creating / setting up the VM's 

All the scrips are written such that they can be safely run again. So you can fix end then retry a step without having to redo everything. Each script contains hints on what to do next. When you get stuck the comments in the scripts may contain additional useful info.

Note that even though a yum / composer cache are kept outside the VM you do need a network connection to (re)create a VM.

(Development mode only)

There has to be an exception to the above of course. After the `composer install` for a component install by `./deploy-develop.sh` is completed its configuration is updated. Once that has happend a `composer install` will fail for many components because the `composer install` will partly revert the component's configuration leading to errors in the configuration. You need to completely revert the configuration to that in the repo allow the composer install to succeed.

Note that you can use `./deploy-develop.sh` to install individual components as well. Use e.g. `./deploy-develop.sh stepup-gateway`

## I'm keep getting weird errors during the composer install step

If you're using the Stepup-VM in develop mode this is the first step that generates a lot of IO to the /src share that is mounted in the VM. If the error is not due to composer running out of memory it looks like the mounting method is not working well for your, sorry. By default the standard method provided by Vagrant is used for mounting. If the does not work try using NFS instead. To do this:

1. Open the `Vagrantfile` and comment the `app.vm.synced_folder "./src/", "/src"` line and uncomment the NFS configuration below it.
2. Reload the VM using the `./vagrant-reload-dev-vm.sh` script

## Where are the logs?

The app server is configured to log all messages to syslog, you can find these in /var/log/messages:
```
$ vagrant ssh
$ sudo tail /var/log/messages
```

## Getting the ID of a YubiKey

The ID of a YubiKey as used in Stepup is an 8 digit number. This number is printed on the yubikey. 

You can also get this ID by decoding the first 12 characters of an OTP generated by the token and prefixing 0's until it is 8 digits long. The output of a YubiKey us ModHex encoded. You can find a ModHex decoder at https://demo.yubico.com/modhex.php. Make sure you set "Format" to "ModHex" before converting.
 
E.g. If the first 12 characters of your YubikeyOutput are "ccccccbdthji" this decodes to the number "1234567". Prefixing a "0" gives a yubikey ID of "01234567". 

## Cannot connect to a VM anymore

If you are using test mode:

- Verify that it is running: 
    ```
    $ vagrant up
    ```
- Reload it:
    ```
    $ vagrant reload
    ```

If you are using the develop mode:

- Verify that it is running: 
    ```
    $ ./vagrant-up-dev-vm.sh
    ```
- Reload it:
    ```
    $ ./vagrant-reload-dev-vm.sh
    ```
    
## Ansible cannot connect to the box anymore

- If you can connect to the box using `vagrant ssh`, provisioning it again can help. This recreates the Ansible inventory and restarts networking in the VM:
    ```
    $ vagrant provision
    ```

- Run Ansible with the "-vvvv" option to get more details.


## VMware Fusion network configuration

The VMs get a fixed IP in the 192.168.66/24 network. This is added by fusion automatically. 
When you experience problems with the 192.168.66/24 network verify that it is setup correctly in `/Library/Preferences/VMware\ Fusion/networking`. 
You can disable DHCP for the 192.168.66.* network.
 
To restart Fusing networking:
```
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --stop
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --start
```

Other useful commands:
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

## Updating the environment

If you or anybody else adds new Ansible variables to the template environment (Stepup-VM/environment/template) the environment of the VM is not automatically updated.
In a production setting this is a manual step. The CHANGELOG will list the relevant changes. Because the Stepup-VM uses the template environment unchanged you can just copy the template over to your environment (assuming you did not make any changes). Use the `./update-env.sh` script to do this.

## How do I update the middleware configuration?

The middleware configuration consists of three parts:

- `config` - The middleware configuration containing SRAA's, mail templates and SAML configuration of the gateway
- `whitelist` - The whitelist containing the schacHomeOrganization values of the institutions that are allowed to use Stepup
- `institution` - The institution specific configuration

Use the `./push-mw.sh` script to update these and specify the part you want to push. E.g. `./push-mw.sh config`

## What are the differences between the Stepup-VM and a production installation of Stepup?

The "charm" of the Stepup-VM is that the configuration of the template environment in Stepup-Deploy is setup to work with it without requiring and changes. To deploy Stepup to another environment (i.e. VM, server(s)) you would have to generate a new environment and look at all the TODO's to adapt it to your situation.

### Enabled roles

In the Stepup-VM some roles are enabled that you would not enable in production. Look at inventory (that was generated by Vagrant provision) to see which roles are enabled for the VM:
- The "dev" role. This role installs development and test tooling like mailcatcher, test IdP and SP, NVM.
- The "proxy" role. This role adds https to http proxy for the public vhosts. You could use this in production probably, but it is not tested / intended for this. E.g. it does not forward HTTP to HTTPS and the HTTPS configuration is likely not up to date with the latest recommendations and standards. For production use your own HTTPS proxy / loadbalancer.
- The "demo-gssp" and "demo-gssp-2" roles. These GSSPs are for testing development only.

### Database

The database used is a MariaDB gallera cluster and is intended to consist of 3 or 5 (or more, but why?) nodes.
