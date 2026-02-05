locals {
  k3s_longhorn_count = 3
}

resource "proxmox_virtual_environment_vm" "k3s_longhorn" {
  count       = local.k3s_longhorn_count
  name        = "k3s-longhorn-${count.index + 1}"
  description = "k3s Longhorn Storage"
  tags        = ["k3s", "longhorn", "cluster"]
  node_name   = "var.proxmox_nodes_k3s" #"proxmox_nodes" #<< defined in terraform.tfvars  # This is across all nodes. You can specify a Proxmox host to target that only
  vm_id       = 621 + count.index
  started     = true

  clone {
    vm_id = 3333   # Pre-existing VM template
    full  = true
  }

  cpu {
    cores = 4
    type  = "host"
  }

  memory {
    dedicated = 8192
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 300 # increased space for longhorn
  }

  network_device {
    bridge = "vmbr0"
    vlan_id = 3
  }

  initialization {
    datastore_id = "local-lvm"

    dns {
      servers = ["9.9.9.9", "1.1.1.1"]
    }

    ip_config {
      ipv4 {
        # Hardcode IPs for predictability
        address = "10.10.30.${121 + count.index}/24" # Example: 10.10.30.111, 112, 113
        gateway = "10.10.20.254"
      }
    }

    user_account {
      username = "hughboi"
      keys     = [var.ssh_public_key]
    }
  }
}