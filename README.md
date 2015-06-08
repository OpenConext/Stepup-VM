# Stepup-VM
Stepup-VM - Vagrant VMs that can be used with Stepup-Deploy

## Fusion network configuration

The VMs get a fixed IP in the 192.168.66/24 network. This is added by fusion automaticly, but it enables DHCP, which misses things up again...
Edit `/Library/Preferences/VMware\ Fusion/networking` to disable DHCP for the 192.168.66.* network and then restart Fusing networking:

```
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --stop
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --configure
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --start
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --status
```
