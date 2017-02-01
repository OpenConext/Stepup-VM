# OSX

## Install Ansible

You need Ansible version > 2.2

To install Ansible system wide:

1. Install [Xcode](https://developer.apple.com/xcode/)
2. `sudo easy_install pip`
3. `sudo pip install ansible`

    To install a specific version (2.2.0.0) of Ansible: `sudo pip install ansible==2.2.0.0` \
    To upgrade to the latest version: `sudo pip install ansible --upgrade --ignore-installed`
    The "--ignore-installed" prevents pip from trying to uninstall packages that are part of OSX and that were 
    not installed by pip.
    
4. `sudo pip install python-keyczar`
    
    