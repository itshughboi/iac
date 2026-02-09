terraform {
  required_providers {
    unifi = {
      source = "paultyng/unifi"
      version = "~> 0.41"
    }
  }
}

provider "unifi" {
  api_url = "https://10.10.10.10:8443"  # your UniFi Controller URL
  username       = var.unifi_username            # Controller username
  password       = var.unifi_password            # Controller password
  site           = "default"                  # usually 'default', change if needed
  allow_insecure = true                        # set to true if self-signed SSL
}

# -------------------------
# Create a VLAN / Network
# -------------------------
locals {
  networks = {
    "management"     = { vlan = 10, subnet  = "10.10.10.0/24", purpose = "SSH, Web UI, Proxmox mgmt", firewall = var.firewall_rules.management }
    "cluster"        = { vlan = 20, subnet  = "10.10.20.0/24", purpose = "Proxmox Corosync / HA cluster", firewall = var.firewall_rules.cluster }
    "k3s"            = { vlan = 30, subnet  = "10.10.30.0/24", purpose = "k3s node traffic / pods", firewall = var.firewall_rules.k3s }
    "storage"        = { vlan = 40, subnet  = "10.10.40.0/24", purpose = "TrueNAS, PBS, NFS/iSCSI", firewall = var.firewall_rules.storage }
    "provisioning"   = { vlan = 99, subnet  = "10.10.99.0/24", purpose = "PXE / NetbootXYZ", firewall = var.firewall_rules.provisioning }
    "torrent"        = { vlan = 49, subnet  = "172.16.20.0/24", purpose = "Isolated P2P / untrusted traffic", firewall = var.firewall_rules.torrent }
  }
}

resource "unifi_network" "production" {
  for_each = local.networks

  name    = each.key
  purpose = each.value.purpose
  vlan_id = each.value.vlan
  subnet  = each.value.subnet

  # Dynamic DHCP based on the subnet provided
  # split() and join() ensure we target the correct octets for DHCP ranges
  dhcp_start   = "${join(".", slice(split(".", split("/", each.value.subnet)[0]), 0, 3))}.100"
  dhcp_stop    = "${join(".", slice(split(".", split("/", each.value.subnet)[0]), 0, 3))}.200"
  dhcp_enabled = true
}