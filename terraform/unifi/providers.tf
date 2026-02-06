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
    "management"   = { vlan = 1,  subnet = "10.10.10.0/24",  purpose = "corporate" }
    "provisioning" = { vlan = 2,  subnet = "10.10.20.0/24",  purpose = "corporate" }
    "k3s"          = { vlan = 3,  subnet = "10.10.30.0/24",  purpose = "corporate" }
    "vpn"          = { vlan = 7,  subnet = "10.10.70.0/24",  purpose = "corporate" }
    "torrent"      = { vlan = 49, subnet = "172.16.20.0/24", purpose = "corporate" }
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