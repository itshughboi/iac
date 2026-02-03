### Phase 1: Bootstrap First Node

> [!IMPORTANT] Manual Intervention
> Because I don't have a pxe server yet, we need to manually bootstrap first node before automating the other 3 nodes
> 

1. Prepare Ventoy 
	1. Rename the main partition name (where ISOs live) to be 'PROXMOX_AIC' in order to load the answer.toml file below. ESSENTIAL!
2. Add ISO
	1. Download Proxmox VE ISO: https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso and put it onto Ventoy
3. Add Answer File
	1. Create a answer.toml file and put it adjacent to proxmox.iso in Ventoy partition
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
4. BootUpp Proxmox Node 
	1. On the Proxmox boot menu select the **Automated Installation**
5. Verification
	1. Make sure termainl gives login prompt to IP:8006

