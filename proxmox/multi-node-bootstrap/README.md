### Phase 1: Bootstrap First Node

> [!IMPORTANT] Manual Intervention
> Because I don't have a pxe server yet, we need to manually bootstrap first node before automating the other 3 nodes
> 

**Prepare Ventoy** 
1. Rename the main partition name (where ISOs live) to be 'PROXMOX_AIC' in order to load the answer.toml file below. ESSENTIAL!
**Add ISO**
2. Download Proxmox VE ISO: https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso and put it onto Ventoy
**Add Answer File**
3. Create a answer.toml file and put it adjacent to proxmox.iso in Ventoy partition
```toml
[global]
keyboard = "us"
timezone = "America/Denver"
# Generate a hashed password: printf "yourpassword" | openssl passwd -6 -stdin
root_password = "$6$rTFai9692MmsAq8I$6y7kogOLaIgjCYwNcMyHmSuMUqXXsU2baJbgkR9d1wuPpwj7Yx8bVhPADOBuHU7qXf.42wVUmyX4y3s4MBtLg/" 
reboot_on_error = false

[network]
source = "from-dhcp" 

[disk]
selection = ["nvme0n1", "sda"] # List of possibilities. Proxmox will try in order and pick first one it finds
filesystem = "zfs"
zfs.raid = "single"
```
**BootUp Proxmox Node** 
1. On the Proxmox boot menu select the **Automated Installation**
2. Wait til i see the login prompt for https://IP:8006



### Phase 2: Bootstrap Clout-Init Template
**Prepare API Token**
1. SSH into node 1 and create a dedicated service account
```sh
# 1. Create a Terraform user
pveum user add terraform@pve --password YOUR_SECRET_PASSWORD

# 2. Give it Administrator permissions (simplest for homelab start)
pveum acl modify / -user terraform@pve -role Administrator

# 3. Generate the API Token
pveum user token add terraform@pve terraform-token --privsep 0
```

> [!IMPORTANT] Copy/Save the value it spits out. 
> This is Terraform's password. Can't see again. Copy it into Vaultwarden when possible

**Create Cloud-Init Template**
- Run these while still SSH'd into node 1
```sh
# Download Ubuntu 22.04 Cloud Image
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img

# Create a VM (ID 9999) for the template
qm create 9999 --name "ubnt-cloud" --memory 4096 --net0 virtio,bridge=vmbr0

# Import the image to storage
qm importdisk 9999 noble-server-cloudimg-amd64.img local-lvm

# Configure VM to use the imported disk
qm set 9999 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9999-disk-0
qm set 9999 --ide2 local-lvm:cloudinit
qm set 9999 --boot c --bootdisk scsi0
qm set 9999 --serial0 socket --vga serial0

# Force the VM to use the serial console for display
qm set 9999 --agent enabled=1

# resize to a larger size to 50 GB
qm disk resize 9999 scsi0 50G

# Convert it to a template
qm template 9999
