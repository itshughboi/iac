terraform {
  required_providers {
    unifi = {
      source = "ubiquiti-community/unifi"
      version = "~> 0.41.12"
    }
  }
}

### Provider options from official documentation; https://registry.terraform.io/providers/ubiquiti-community/unifi/latest/docs

provider "unifi" {
  api_url        = var.api_url                   # your UniFi Controller URL
  api_key        = var.api_key
  username       = var.unifi_username            # Controller username
  password       = var.unifi_password            # Controller password
  allow_insecure = var.insecure                  # needs to be true if self-signed SSL
  site           = var.unifi_site                # only change if not default site
}


resource "unifi_network" "production" {
  for_each = local.networks

  name    = each.key
  purpose = each.value.purpose
  vlan_id = each.value.vlan
  subnet  = each.value.subnet


## Feature mapping
  igmp_snooping = each.value.igmp
  dhcp_guarded  = each.value.guard

## DHCP Range
  dhcp_enabled = true
  dhcp_start   = cidrhost(each.value.subnet, 100)
  dhcp_stop    = cidrhost(each.value.subnet, 200)


## PXE: All networks point to 10.10.99.100
  dhcpd_boot_enabled  = true
  dhcpd_boot_server   = "10.10.99.100"
  dhcpd_boot_filename = "netboot.xyz.kpxe"



### PXE Boot option 66 & 67
  dynamic "dhcp_options" {
    for_each = each.key == "provisioning" ? [1] : []  # only applies to network "provisioning"
    content {
      option = 66  # TFTP server for PXE
      value  = "10.10.99.99"  # IP of your NetbootXYZ host
    }
    # Optionally add 67: bootfile name, etc.
  }
}