### 1. Ansible VM Setup

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

2. Create new SSH keys. Leave password empty. We'll need ths for all other **Cloud-Init** machines
```sh
ssh-keygen -t ed25519 -C "ansible" -f ~/.ssh/ansible
ls ~/.ssh/ansible*
```
1. copy ssh public key from /.ssh to home directory (ansible.pub or id_rsa.pub)
```sh
cd ./.ssh
cp ansible.pub /home/hughboi
```
