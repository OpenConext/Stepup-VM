# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "puppetlabs/centos-7.2-64-nocm"
  #config.vm.box = "centos/7"
  
  # Stepup-Deploy Ansible playbook takes the hostname from the inventory which is generated by Vagrant
  # We define the vm here with it's full hostname because that is what is put in the generated inventory
  # Tip: After spinning up de VM(s) with vagrant you can use bash 4 commandline completion for completing hostname in Vagrant
  #      With ansible-playbook you can use e.g. "-l app*" to save some typing
  #      Also, the app VM set as the default, so e.g. "vagrant ssh" will login to the app vm without having to spell
  #      it out.
  config.vm.define "app.stepup.example.com", primary: true do |app|

    src_path = nil

    if ARGV[0] == "up" or ARGV[0] == "reload" then
        if ENV["ENV"] != "dev" then
          puts("INFO: To create a VM that can mount sources from the host for development purposes")
          puts("INFO: set 'ENV=dev'. E.g run vagrant with:")
          puts("INFO: $ export ENV=dev; vagrant " + ARGV.join(" "))
        else
          src_path = File.dirname(__FILE__) + "/src/"
          puts("INFO: 'ENV=dev' so " + src_path + " will be mounted in the app VM as /src")
        end
      end

    # Let vagrant create a 192.168.66.0/24 network and add a second nic to the VM for it
    # The VM will have two NICs:
    # - The default NIC with a DHCP address, this is the NIC that will be used when "vagrant ssh app.stepup.example.com"
    # -
    app.vm.network :private_network, ip: "192.168.66.3"

    # VMWare fusion specific configuration
    app.vm.provider "vmware_fusion" do |v|
 
      # Setup an additional shared folder for mounting the sources from the host
      #
      # Note that you must to use the vagrant commands vor starting / resuming the VM to get the mount
      # reinstated. A reboot from the VM will not suffice. Use:
      # "vagrant up" to start the VM
      # "vagrant reload" to reboot the VM
      # "vagrant halt" to stop the VM

      if src_path != nil then
        app.vm.synced_folder src_path, "/src"#, :mount_options => ["dmode=777","fmode=666"]
      end

      v.vmx["memsize"] = "2048"
      v.vmx["numvcpus"] = "2"
      #v.gui = true

      # There is a conflict between the way vagrant configures the additional NIC in the VM and the
      # way the NIC's are setup in the box.
      # The puppetlabs box was created using packer, and it uses the default .vmx configuration included
      # with packer. This .vmx has one e1000 ethernet NIC (ethernet0) in PCI slot 33 with 'connectiontype = "nat"'.
      # This NIC becomes ens33 in the VM. The box has a corresponding /etc/sysconfig/network-scripts/ifcfg-ens33
      # setup for DHCP. This works fine in the default setup. However, we want to add another NIC with a fixed IP
      # on a host based network so we can connect to other VMs that run on the host on a known IP.
      # We still need the "default" (DHCP) NIC to access the internet for ntp, downloading rpm's composer etc.
      #
      # The problem is that Vagrant adds the second NIC as ens33, overwriting /etc/sysconfig/network-scripts/ifcfg-ens33
      # with the config for the new NIC.
      # We fix this by a moving the default NIC to PCI slot 32 (ens32 in the VM). Vagrant will setup the
      # new nic for PCI slot33 and configure it in the VM as ens33

      v.vmx["ethernet0.pciSlotNumber"] = "32"

      # We'll use the Ansible provisioner to create a config for the default NIC in
      # /etc/sysconfig/network-scripts/ifcfg-ens32
    end

    # VirtualBox specific configuration
    app.vm.provider "virtualbox" do |v|
      # Use the default (vboxsf)
      v.customize ["modifyvm", :id, "--ioapic", "on"]
      v.customize ["modifyvm", :id, "--memory", "2048"]
      v.customize ["modifyvm", :id, "--cpus", "2"]

      # Setup an additional shared folder for mounting the sources from the host
      #
      # Note that you must to use the vagrant commands vor starting / resuming the VM to get the mount
      # reinstated. A reboot from the VM will not suffice. Use:
      # "vagrant up" to start the VM
      # "vagrant reload" to reboot the VM
      # "vagrant halt" to stop the VM

      if src_path != nil then
        app.vm.synced_folder "./src/", "/src",
          nfs: true,
          linux__nfs_options: ['rw','no_subtree_check','all_squash','no_root_squash','async']
          #:mount_options => ['nolock,vers=3,udp,noatime,actimeo=1']
      end

    end
  end

  config.vm.define "manage.stepup.example.com" do |manage|
    #app.vm.synced_folder ".", "/vagrant", disabled: true

    # Let vagrant create a 192.168.66.0/24 network and add a second nic to the VM for it
    manage.vm.network :private_network, ip: "192.168.66.4"

    manage.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"] = "2048"
      v.vmx["numvcpus"] = "2"

      # Change NIC PCI slot number to 32 (from 33) to reslolve conflict with Vagrant network auto config
      v.vmx["ethernet0.pciSlotNumber"] = "32"

      #v.gui = true
    end

    manage.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "2048"]
      v.customize ["modifyvm", :id, "--cpus", "2"]
    end
  end

  # Let Vagrant generate an "inventory" file for Ansible
  # This inventory file can be used by the Ansible playbooks in Stepup-Deploy
  # To let Vagrant regenerate the inventory file run:
  #
  #     vagrant provision
  #
  # This can useful to repair networking issues. It will rewrite the inventory file for ansible and
  # restart networking in the VM

  config.vm.provision "ansible" do |ansible|

    # Use Ansible to make a few additional changes to the VM. This is not the main deploy of Stepup. This playbook:
    # - Configures YUM to use a RPM package cache in the current directory
    # - Excludes kernel packages from updates
    # - Restarts networking
    ansible.playbook = "provision.yml"

    ansible.groups = {
      "app" => ["app.stepup.example.com"],
      "stepup-app" => ["app.stepup.example.com"],
      "dbcluster:children" => ["stepup-app"],
      "manage" => ["manage.stepup.example.com"],
      "es:children" => ["manage"],
      "proxy:children" => ["stepup-app"],
      "dbconfig:children" => ["stepup-app"],
      "stepup-gateway:children" => ["stepup-app"],
      "stepup-selfservice:children" => ["stepup-app"],
      "stepup-ra:children" => ["stepup-app"],
      "stepup-middleware:children" => ["stepup-app"],
      "stepup-tiqr:children" => ["stepup-app"],
      "stepup-keyserver:children" => ["stepup-app"],
      # Don't use a sparate lb, use the proxy role instead.
      # It set's up a simple reverse proxy using nginx op the app server
      "lb" => [],
      "ks" => [],
      "ks:children" => ["app"],
      "dev" => [],
      "dev:children" => ["app"]
    }

    ansible.host_vars = {
          "app.stepup.example.com" => {"host_ipv4" => "192.168.66.3", "backend_ipv4" => "192.168.66.3"},
          "manage.stepup.example.com" => {"host_ipv4" => "192.168.66.4"}
        }
    # Uncomment the line below to make Ansible more verbose. Useful for troubleshooting ssh and networking issues.
    # ansible.verbose = "vvvv"
  end

end
