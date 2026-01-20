### Running the playbook
```
ansible-playbook harden.yaml -i inventory.ini
```


##### .cfg file
- if using a ansible.cfg file, that specifies where the inventory file is so all you have to do is this:
```
ansible-playbook harden.yaml
```