resource "unifi_user" "proxmox_nodes" {
  for_each = var.nodes
  name       = each.key        # e.g., "pve-srv-1"
  mac        = each.value.mac  # e.g., "aa:bb:cc..."
  fixed_ip   = each.value.ip
  network_id = data.unifi_network.mgmt.id # Assumes you have a network data source
}