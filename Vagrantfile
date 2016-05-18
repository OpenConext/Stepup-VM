# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "puppetlabs/centos-7.0-64-nocm"
  
  config.vm.define "app.stepup.example.com" do |app|
    app.vm.hostname = "app.stepup.example.com"
    app.vm.network "private_network", ip: "192.168.66.2", :netmask => "255.255.255.0"
    app.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"] = "1536"
      v.vmx["numvcpus"] = "1"
      #v.gui = true
    end
    app.vm.provider "virtualbox" do |v|
      v.memory = 1536
    end
  end

#  config.vm.define "ks" do |ks|
#    ks.vm.hostname = "demo-ks"
#    ks.vm.network "private_network", ip: "192.168.66.7", :netmask => "255.255.255.0"
#    ks.vm.provider "vmware_fusion" do |v|
#      v.vmx["memsize"] = "1536"
#    end
#    ks.vm.provider "virtualbox" do |v|
#      v.memory = 1536
#    end
#  end

#  config.vm.define "lb" do |lb|
#    lb.vm.hostname = "demo-lb"
#    lb.vm.network "private_network", ip: "192.168.66.6", :netmask => "255.255.255.0"
#    lb.vm.provider "vmware_fusion" do |v|
#      v.vmx["memsize"] = "1536"
#    end
#    lb.vm.provider "virtualbox" do |v|
#      v.memory = 1536
#    end
#  end

  config.vm.define "db.stepup.example.com" do |db|
    db.vm.hostname = "db.stepup.example.com"
    db.vm.network "private_network", ip: "192.168.66.5", :netmask => "255.255.255.0"
    db.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"] = "1536"
      v.vmx["numvcpus"] = "1"
      #v.gui = true
    end
    db.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end
  end


  config.vm.define "manage.stepup.example.com" do |manage|
    manage.vm.hostname = "manage.stepup.example.com"
    manage.vm.network "private_network", ip: "192.168.66.3", :netmask => "255.255.255.0"
    manage.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"] = "1536"
      v.vmx["numvcpus"] = "1"
      #v.gui = true
    end
    manage.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provision.yml"
    ansible.groups = {
      "app" => ["app.stepup.example.com"],
      "stepup-app" => ["app.stepup.example.com"],
      "dbcluster" => ["db.stepup.example.com"],
      "manage" => ["manage.stepup.example.com"],
      "es:children" => ["manage"],
      "proxy:children" => ["stepup-app"],
      "stepup-gateway:children" => ["stepup-app"],
      "stepup-selfservice:children" => ["stepup-app"],
      "stepup-ra:children" => ["stepup-app"],
      "stepup-middleware:children" => ["stepup-app"],
      "stepup-tiqr:children" => ["stepup-app"],
      "stepup-keyserver" => [],
      "lb" => [],
      "ks" => []
    }
    ansible.host_vars = {
          "app.stepup.example.com" => {"host_ipv4" => "192.168.66.2"},
          "manage.stepup.example.com" => {"host_ipv4" => "192.168.66.3"},
          "db.stepup.example.com" => {"host_ipv4" => "192.168.66.5", "backend_ipv4" => "192.168.66.5" }
        }
    #ansible.verbose = "vvvv"
  end

end
