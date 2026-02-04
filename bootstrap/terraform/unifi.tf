resource "unifi_network" "mgmt" {
  name    = "DataCenter-MGMT"
  vlan_id = 10
  subnet  = "10.10.10.1/24"
  
  # CRITICAL: This points the servers to your laptop/seed node
  dhcpd_boot_enabled  = true
  dhcpd_boot_server   = "10.10.10.5"   # YOUR LAPTOP IP
  dhcpd_boot_filename = "netboot.xyz.efi"
}

resource "unifi_network" "storage" {
  name    = "DataCenter-STORAGE"
  vlan_id = 20
  subnet  = "10.10.20.1/24"
  dhcp_enabled = false # Enterprise storage usually uses static IPs only
}

resource "unifi_network" "k3s" {
  name    = "DataCenter-K3S"
  vlan_id = 30
  subnet  = "10.10.30.1/24"
}