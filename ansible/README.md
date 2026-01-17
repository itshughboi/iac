## Ansible VM Setup

> [!NOTE] Ansible Cloud-Init
> Create and full clone a cloud-init template
```sh
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
```
1. Check successful installation. In output take note of "config file" path
```sh
ansible --version
```

### Inventory
1. While you can use the Hosts file by running the below command, it's better to create a new inventory.yaml file to target machines better. Below though is if I want to use hosts file
```sh
sudo nano /etc/ansible/hosts
```
Option 1: See full /ansible/inventory/all_hosts.ini for template hosts.ini file // https://raw.githubusercontent.com/itshughboi/iac/refs/heads/main/ansible/inventory/all_hosts.ini

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


Option 2: inventory.yaml // https://raw.githubusercontent.com/itshughboi/iac/refs/heads/main/ansible/inventory/inventory.yaml
```
all:
  children:
    proxmox:
      hosts:
        pve-srv-1:
          ansible_host: 10.10.10.1
          ansible_user: hughboi
        pve-srv-2:
          ansible_host: 10.10.10.2
          ansible_user: hughboi
        pve-srv-3:
          ansible_host: 10.10.10.3
          ansible_user: hughboi
        pve-srv-3:
          ansible_host: 10.10.10.3
          ansible_user: hughboi
    docker_hosts:
      hosts:
        docker:
          ansible_host: 10.10.10.10
          ansible_user: hughboi
    k3s:
      hosts:
        k3s-master-1:
          ansible_host: 10.10.30.1
          ansible_user: hughboi
        k3s-master-2:
          ansible_host: 10.10.30.2
          ansible_user: hughboi
        k3s-master-3:
          ansible_host: 10.10.30.3
          ansible_user: hughboi
        k3s-worker-1:
          ansible_host: 10.10.30.11
          ansible_user: hughboi
        kes-worker-2:
          ansible_host: 10.10.30.12
          ansible_user: hughboi
		k3s-worker-3:
		  ansible_host: 10.10.30.13
          ansible_user: hughboi
    storage:
      hosts:
        truenas:
          ansible_host: 10.10.10.5
          ansible_user: hughboi
        pbs:
          ansible_host: 10.10.10.6
          ansible_user: hughboi
  vars:
    ansible_ssh_private_key_file: ~/.ssh/ansible
```

- ^^ These allow you to target specific groups from this one inventory file when running playbooks



### SSH Keys
1. Create new SSH keys. Leave password empty so it can be automated. We'll need this for all other **Cloud-Init** machines
```sh
ssh-keygen -t ed25519 -C "ansible" -f ~/.ssh/ansible
ls ~/.ssh/ansible*
```
- You should see both private and public key here

2. Restrict SSH permissions
```sh
chmod 600 ~/.ssh/ansible
```

3. Enable Public Key Authentication on Remote Machines
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

4. Copy SSH key to remote machine. Needs password authentication enabled
```sh
cd ./.ssh
ssh-copy-id -i ~/.ssh/ansible.pub hughboi@remote-machine-ip
```

5. Test Ansible connections with SSH key
```sh
ansible all -m ping --private-key ~/.ssh/ansible
```


Add the following to Inventory file to use Ansible Keys and not have to sepcify private key
```
[all:vars]
ansible_user='hughboi'
ansible_become=yes
ansible_become_method=sudo
ansible_ssh_private_key_file=~/.ssh/ansible
```

#### Verify Inventory & SSH Keys: I may need to attempt ssh, accept the key host, get denied with public key, then try again once it's in authorized hosts
```
ansible all -m ping 
```
