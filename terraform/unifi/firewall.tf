resource "unifi_firewall_rule" "rules" {
  for_each = locals.firewall_rules

  name    = each.value.name
  action  = each.value.action
  ruleset = "LAN_IN"

  protocol = each.value.proto
  dst_port = each.value.ports

  src_network_id = unifi_network.production[each.value.source].id
  dst_network_id = unifi_network.production[each.value.dest].id
}