locals {
  # Explicit actions (no magic defaults)
  allow = "accept"
  deny  = "deny"

  # ----------------------------
  # Base rule templates (partials)
  # ----------------------------
  rules = {
    mgmt_admin = {
      proto  = "TCP"
      ports  = "22,80,443"
      source = "management"
      action = local.allow
    }

    storage_access = {
      proto  = "TCP,UDP"
      ports  = "2049,3260"
      action = local.allow
    }

    dns = {
      proto  = "TCP,UDP"
      ports  = "53"
      action = local.allow
    }
  }

  # ----------------------------
  # Zone-based rule definitions
  # ----------------------------
  zone_rules = {
    # Management can administer core networks
    management = [
      for dest in ["management", "cluster", "storage", "provisioning"] :
      merge(local.rules.mgmt_admin, { dest = dest })
    ]

    # K3s needs DNS + storage
    k3s = [
      merge(local.rules.storage_access, {
        source = "k3s"
        dest   = "storage"
      }),
      merge(local.rules.dns, {
        source = "k3s"
        dest   = "management"
      })
    ]

    # Cluster internal communication (e.g. Proxmox / Corosync)
    cluster = [
      {
        proto  = "UDP"
        ports  = "5404-5405"
        source = "cluster"
        dest   = "cluster"
        action = local.allow
      }
    ]

    # Provisioning (PXE + DNS)
    provisioning = [
      {
        proto  = "UDP"
        ports  = "67-68"
        source = "provisioning"
        dest   = "provisioning"
        action = local.allow
      },
      {
        proto  = "UDP"
        ports  = "69"
        source = "provisioning"
        dest   = "provisioning"
        action = local.allow
      },
      {
        proto  = "TCP"
        ports  = "80,443"
        source = "provisioning"
        dest   = "provisioning"
        action = local.allow
      },
      merge(local.rules.dns, {
        source = "provisioning"
        dest   = "management"
      })
    ]

    # Torrent VLAN: explicit isolation (DENY)
    torrent = [
      for dest in ["management", "cluster", "storage", "provisioning"] : {
        proto  = "ALL"
        ports  = "ALL"
        source = "torrent"
        dest   = dest
        action = local.deny
      }
    ]
  }

  # ----------------------------
  # Final ordered rule list
  # Allow rules first, deny rules last
  # ----------------------------
  firewall_rules = flatten([
    local.zone_rules.management,
    local.zone_rules.cluster,
    local.zone_rules.k3s,
    local.zone_rules.provisioning,
    local.zone_rules.torrent
  ])
}
