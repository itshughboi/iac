locals {
  zone_rules = {
    "management" = [
      { proto = "TCP", ports = "22,80,443", source = "management", dest = "management" },
      { proto = "TCP", ports = "22,80,443", source = "management", dest = "cluster" },
      { proto = "TCP", ports = "22,80,443", source = "management", dest = "storage" },
      { proto = "TCP", ports = "22,80,443", source = "management", dest = "provisioning" }
    ]

    "cluster" = [
      { proto = "UDP", ports = "5404-5405", source = "cluster", dest = "cluster" }
    ]

    "k3s" = [
      { proto = "TCP,UDP", ports = "53", source = "k3s", dest = "management" },
      { proto = "TCP,UDP", ports = "2049,3260", source = "k3s", dest = "storage" }
    ]

    "storage" = [
      { proto = "TCP,UDP", ports = "2049,3260", source = "management", dest = "storage" },
      { proto = "TCP,UDP", ports = "2049,3260", source = "k3s", dest = "storage" }
    ]

    "provisioning" = [
      { proto = "UDP", ports = "67-68", source = "provisioning", dest = "provisioning" },
      { proto = "UDP", ports = "69", source = "provisioning", dest = "provisioning" },
      { proto = "TCP", ports = "80,443", source = "provisioning", dest = "provisioning" },
      { proto = "TCP,UDP", ports = "53", source = "provisioning", dest = "management" }
    ]

    "torrent" = [
      { proto = "ALL", ports = "ALL", source = "torrent", dest = "management", action = "deny" },
      { proto = "ALL", ports = "ALL", source = "torrent", dest = "cluster", action = "deny" },
      { proto = "ALL", ports = "ALL", source = "torrent", dest = "storage", action = "deny" },
      { proto = "ALL", ports = "ALL", source = "torrent", dest = "provisioning", action = "deny" }
    ]
  }

  # Flatten all the rules into a single map keyed by unique name
  firewall_rules = {
    for zone, rules in local.zone_rules :
    for rule in rules :
    "${rule.source}-${rule.dest}-${replace(rule.ports, ",", "-")}-${lower(rule.proto)}" => merge(rule, {
      name   = "${rule.source}-${rule.dest}-${lower(rule.proto)}"
      action = lookup(rule, "action", "accept") # default to accept if not specified
    })
  }
}