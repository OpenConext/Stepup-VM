# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "puppetlabs/centos-7.0-64-nocm"
  
  config.vm.define "app" do |app|
    app.vm.hostname = "demo-app"
    app.vm.network "private_network", ip: "192.168.66.2", :netmask => "255.255.255.0"
    app.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"] = "1536"
    end
    app.vm.provider "virtualbox" do |v|
      v.memory = 1536
    end
  end

  config.vm.define "db" do |db|
    db.vm.hostname = "demo-db"
    db.vm.network "private_network", ip: "192.168.66.5", :netmask => "255.255.255.0"
    db.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"] = "1536"
    end
    db.vm.provider "virtualbox" do |v|
      v.memory = 1536
    end
  end

  config.vm.define "db2" do |db2|
    db2.vm.hostname = "demo-db2"
    db2.vm.network "private_network", ip: "192.168.66.7", :netmask => "255.255.255.0"
    db2.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"] = "1536"
    end
    db2.vm.provider "virtualbox" do |v|
      v.memory = 1536
    end
  end

  config.vm.define "lb" do |lb|
    lb.vm.hostname = "demo-lb"
    lb.vm.network "private_network", ip: "192.168.66.6", :netmask => "255.255.255.0"
    lb.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"] = "1536"
    end
    lb.vm.provider "virtualbox" do |v|
      v.memory = 1536
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
