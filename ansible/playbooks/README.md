### Using Playbooks
```
ansible-playbook PLAYBOOKNAME -i inventory.yaml --private-key ~/.ssh/ansible --ask-become-pass
```
###### **inventory.yaml**: relative path to the inventory the playbook will use
###### **private-file**: If inventory has [all:vars} specifying key file, you can omit this
###### **ask-become-pass**: when a sudo command runs and a password is required on the user you are running sudo on, you may need this sometimes to run the playbook


#### .cfg file
- if using a ansible.cfg file, that specifies where the inventory file is so all you have to do is this:
```
ansible-playbook playbook-file-name.yaml
```

Example ansible.cfg
```
[defaults]
roles_path = ./roles
inventory = ./inventory.ini
host_key_checking = False
```