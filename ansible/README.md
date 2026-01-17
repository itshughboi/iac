### Ansible VM Setup

> [!NOTE] Ansible Cloud-Init
> Create and full clone a cloud-init template
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
```sh
sudo nano /etc/ansible/hosts
```
See full /ansible/inventory/all_hosts.ini for template hosts.ini file

```
   [k3s]
		10.10.30.1
		10.10.30.2
		10.10.30.3
		10.10.30.11
		10.10.30.12
		10.10.30.13
		
   [masters]
		10.10.30.1
		10.10.30.2
		10.10.30.3

	[workers]
		10.10.30.11
		10.10.30.12
		10.10.30.13
```


2. Ping machines (test)
```sh
ansible all -m ping
```
^^ I had a lot of issues with it using the default id_rsa but i always want to change the name of the cert to be like 'ansible' so i have to specify this when I run ansible commands
```
ansible all -m ping --private-key=ansible
```



### SSH Keys
2. Create new SSH keys. Leave password empty so it can be automated. We'll need ths for all other **Cloud-Init** machines
```sh
ssh-keygen -t ed25519 -C "ansible" -f ~/.ssh/ansible
ls ~/.ssh/ansible*
```
- You should see both private and public key here

3. Restrict SSH permissions
```sh
chmod 600 ~/.ssh/ansible
```

4. Enable Public Key Authentication on Remote Machines
```
sudo nano /etc/ssh/sshd_config
```
```
PubkeyAuthentication yes
PasswordAuthentication no
```
```
sudo systemctl restart sshd
```

4. Copy SSH key to remote machine
```sh
cd ./.ssh
ssh-copy-id -i ~/.ssh/ansible.pub hughboi@remote-machine-ip
```

5. Test Ansible connetions with SSH
```sh
ansible all -m ping --key-file ~/.ssh/ansible
```


Add the following to Inventory file to use Ansible Keys
```
[all:vars]
ansible_user='hughboi'
ansible_become=yes
ansible_become_method=sudo
ansible_ssh_private_key_file=~/.ssh/ansible
```

Test: I may need to attempt ssh, accept the key host, get denied with public key, then try again once it's in authorized hosts
```
ansible all -m ping --key-file ~/.ssh/ansible
```



 sudo like on ubuntu machines
