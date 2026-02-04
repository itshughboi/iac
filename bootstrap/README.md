#End Goal 
Fully operational datacenter style HA Proxmox cluster using IaC principles for deploymet, configuration, and lifecycle of services and virtual machines

### General Overview
-! Pre-requisites: <br>
Spare device (e.g. Macbook / raspberry pi) to run the following:
- netbootxyz
- terraform
- ansible
Unifi Router Functional


1. Bootstrap netbootxyz (iPXE server) and terraform  on spare device
2. Run unifi terraform files to setup VLANs, static IPs and DHCP