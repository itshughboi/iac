### Using Playbooks
```
ansible-playbook PLAYBOOKNAME -i inventory.yaml --private-file ~/.ssh/ansible --ask-become-pass
```
###### **inventory.yaml**: relative path to the inventory the playbook will use
###### **private-file**: also can be written **--key-file**. However, if inventory has [all:vars} specifying key file, you can omit this
###### **ask-become-pass**: when a sudo command runs and a password is required on the user you are running sudo on, you may need this sometimes to run the playbook
