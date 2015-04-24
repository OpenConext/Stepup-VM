# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "puppetlabs/centos-7.0-64-nocm"
  
  config.vm.define "app" do |app|
    app.vm.hostname = "demo-app"
    app.vm.network "private_network", ip: "192.168.66.2", :netmask => "255.255.255.0"
    app.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"] = "2048"
    end
    app.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end
  end

  config.vm.define "manage" do |manage|
    manage.vm.hostname = "demo-manage"
    manage.vm.network "private_network", ip: "192.168.66.3", :netmask => "255.255.255.0"
    manage.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"] = "2048"
    end
    manage.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provision.yml"
    #ansible.verbose = "vvvv"
  end

end
