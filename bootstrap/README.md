#End Goal 
Fully operational datacenter style HA Proxmox cluster using IaC principles for deploymet, configuration, and lifecycle of services and virtual machines

### General Overview
-! Pre-requisites: <br>
Spare device (e.g. Macbook / raspberry pi) to run the following:
- netbootxyz
- terraform
- ansible
Unifi Router Functional


Assuming Unifi Router has at least one network
1. Run unifi terraform files to setup VLANs, static IP and DHCP, and point option 66 to the provisioning IP
2. Provisioning: Bootstrap netbootxyz (iPXE server) or setup DHCP reservation for the MAC on provisioning VLAN and run netboot on MAC. 
3. Plug in servers, boot to PXE, pull config and `answer.toml` file for its MAC address (or none if doing global config) auto provsioning from the provisioning device
--
5. Run the Athena vm terraform to setup management machine
6. Git pull playbooks to that Athena and run the Proxmox HA Cluster join to join the other nodes
7. Run Ansible hardening on all nodes
8. Run the terraform build k3s to provision master, worker, and longhorn vm's across 3 nodes
9. Run Ansible script to install k3s, join, and setup HA
10. Run Ansible script to install rancher, traefik/cert-manager, and other services
11. Run Ansible script to setup monitoring stack


