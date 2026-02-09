locals {
  networks = {
    "management"   = { vlan = 10,  subnet = "10.10.10.0/24",  purpose = "corporate" }
    "cluster"      = { vlan = 20,  subnet = "10.10.20.0/24",  purpose = "corporate" }
    "k3s"          = { vlan = 30,  subnet = "10.10.30.0/24",  purpose = "corporate" }
    "storage"      = { vlan = 40,  subnet = "10.10.40.0/24",  purpose = "corporate" }
    "torrent"      = { vlan = 49,  subnet = "172.16.20.0/24", purpose = "corporate" }
    "provisioning" = { vlan = 99,  subnet = "10.10.99.0/24",  purpose = "corporate" }

  }

  firewall_rules = [
    # Allow Management to manage everything (SSH, Web, Proxmox API)
    { name = "mgmt-to-all", src = "management", dst = "management", proto = "tcp", ports = "22,80,443,8006" },
    { name = "mgmt-to-prov", src = "management", dst = "provisioning", proto = "tcp", ports = "22,80,443,8006" },
    
    # PXE Boot Rules: Allows ANY network to reach your Macbook at 10.10.99.100
    { name = "pxe-tftp", src = "management", dst = "provisioning", proto = "udp", ports = "67,68,69" },
    { name = "pxe-http", src = "management", dst = "provisioning", proto = "tcp", ports = "80,443" }
  ]
}