resource "proxmox_virtual_machine" "mgmt_vm" {
  name        = "Athena" # Your Command Center
  description = "Management VM - Gitea, DNS, Ansible"
  tags        = ["infrastructure", "management"]
  node_name   = "pve" 
  vm_id       = 100

  clone {
    vm_id = 9999
  }

  cpu {
    cores = 4
    type  = "host" # Pass-through physical CPU features
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
        source = "dhcp" # Network comes from DHCP
      }
    }

    user_account {
      username = "hughboi"
      keys     = [var.ssh_public_key]
    }
  }
}
