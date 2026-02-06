
### Best Practice:
- Setup DHCP reservation on Unifi router so that netboot can always be on a dedicated IP for provisioning/PXE booting. Assign it to the provisioning VLAN.
- Setup a webhook from Github so that the answer.toml is always up to date

#### Run Playbook
```
ansible-playbook - i hosts.ini setup-netboot.yaml
```

#### Verify netboot HTTP
```
curl http://10.10.10.x #replace with IP of Le Potato
```