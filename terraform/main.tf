resource "proxmox_virtual_machine" "mgmt_vm" {
  name        = "Athena"
  description = "Management VM - Gitea, DNS, Ansible"
  tags        = ["infrastructure", "management"]
  node_name   = "pve" 
  vm_id       = 100

  clone {
    vm_id = 9999
  }

  cpu {
    cores = 4
    type  = "host" 
  }

  memory {
    dedicated = 8192
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    ip_config {
      ipv4 {
        # Hardcoding the IP for reliability
        address = "10.10.10.8" # Adjust the subnet/IP to match your network
        gateway = "10.10.10.254"    # Your router/gateway IP
      }
    }

    user_account {
      username = "hughboi"
      keys     = [var.ssh_public_key]
    }
  }
}
