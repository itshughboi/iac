resource "proxmox_virtual_machine" "mgmt_vm" {
  name        = "Athena"
  description = "Management VM - Gitea, DNS, Ansible"
  tags        = ["infrastructure", "management"]
  node_name   = "pve-srv-1" # master node name
  vm_id       = 100

# Ensure the VM starts after creation
  started = true

  lifecycle {
    prevent_destroy = true
}


  clone {
    vm_id = 9999
    full = true
  }

  cpu {
    cores = 4
    type  = "host" 
  }

  memory {
    dedicated = 8192
  }

  disk {
    datastore_id = "local-lvm" # Change to your storage name (e.g., 'ssd-storage')
    interface    = "scsi0" # disk that the template uses
    size         = 50 # Size in GB
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    datastore_id = "local-lvm" # Where the Cloud-init ISO will be stored temporarily

    dns {
      servers = ["9.9.9.9", "1.1.1.1"]
    }
    ip_config {
      ipv4 {
        # Hardcoding the IP for reliability
        address = "10.10.10.8/24" # Adjust the subnet/IP to match your network
        gateway = "10.10.10.254"    # Your router/gateway IP
      }
    }

    user_account {
      username = "hughboi"
      keys     = [var.ssh_public_key]
    }
  }
}
