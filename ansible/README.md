### Ansible VM Setup

> [!NOTE] Ansible Cloud-Init
> Technically I do this after I get the cloud-init template up and going, and I full clone that
```sh
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
```
1. Check successfull installation. In output take note of "config file" path
```sh
ansible --version
```

### Inventory
1. Edit Hosts file
```
sudo nano /etc/ansible/hosts
```

template:
```
[pve]
10.10.10.1
10.10.10.2
10.10.10.3
10.10.10.4

[docker]
10.10.10.10

[k3s]
10.10.30.11
10.10.30.12
10.10.30.13
10.10.30.21
10.10.30.22
```

3. Ping machines (test)
```sh
ansible all -m ping
```

### SSH Keys
2. Create new SSH keys. Leave password empty. We'll need ths for all other **Cloud-Init** machines
```sh
ssh-keygen -t ed25519 -C "ansible" -f ~/.ssh/ansible
ls ~/.ssh/ansible*
```

3. Restrict SSH permissions
```sh
chmod 600 ~/.ssh/ansible
```


4. Copy SSH key to remote machine
```sh
cd ./.ssh
ssh-copy-id -i ~/.ssh/ansible.pub hughboi@remote-machine-ip
```

5. Ping with SSH key
```sh
ansible all -m ping --key-file ~/.ssh/ansible
```



### Inventories
List of machines is at /etc/ansible/hosts

### SSH Connections
##### Inventory
1. Configure Inventory file
	1. sudo nano /etc/ansible/hosts
	2. Add IP addresses of remote machines under group
	   [docker]
		10.10.10.31
		10.10.10.32
		10.10.10.33
##### Generate SSH Key for Ansible
1. On Ansible host...
	1. ssh-keygen -t ed25519 -C "ansible" -f ~/.ssh/ansible
		1. 'Leave the password empty so it can be automated'
		2. ls ~/.ssh/ansible* << confirm you see both private and public key
	2. ssh-copy-id -i ~/.ssh/ansible.pub hughboi@remote-machine-ip
2. Test SSH without password
	1. ssh -i ~/.ssh/ansible hughboi@remote-machine-ip
3. Test Ansible connections
	1. ansible all -m ping --key-file ~/.ssh/ansible --ask-pass


##### Enable Public Key Authentication on Remote Machines
- sudo nano /etc/ssh/sshd_config
	- Uncomment 'PubkeyAuthentication yes'
	- 'PasswordAuthentication no'
- sudo systemctl restart sshd


##### Change Inventory to use Ansible Keys
[all:vars]
ansible_user='hughboi'
ansible_become=yes
ansible_become_method=sudo
ansible_ssh_private_key_file=~/.ssh/ansible




### Playbooks
run update: ansible-playbook playbook-update-machines.yml (If i dont have keyfile specified in the hosts, I'll need to add it to the command to specify whcih key file to use. I may also need to add option to ask for password )
	i.e. ansible-playbook playbook-update-machines.yml --key-file ~/.ssh/ansible --ask-become-pass


### Inventory.yaml
- Better granular way to control which hosts are grouped to what rather than doing it from /etc/ansible/hosts


### OS Update
- With my OS-updaet.yml playbook, to run it, do the following.
- 1. cd into ansible
- 2. ansible-playbook OS-update.yml -i inventory.yml --key-file ~/.ssh/ansible
	- This will work if you have key authentication setup
- ansible-playbook OS-update.yml -i inventory.yml --key-file ~/.ssh/ansible --ask-become-pass
	- Use this one if you need to become sudo like on ubuntu machines
