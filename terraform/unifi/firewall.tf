resource "unifi_firewall_rule" "rules" {
  for_each = { for r in local.firewall_rules : r.name => r }

  name    = each.value.name
  action  = "accept"
  ruleset = "LAN_IN"

  protocol = each.value.proto
  dst_port = each.value.ports

  # This links the source and destination to the actual VLAN IDs
  src_network_id = unifi_network.production[each.value.src].id
  dst_network_id = unifi_network.production[each.value.dst].id
}