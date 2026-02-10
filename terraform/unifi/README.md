## Setup:
**Documentation**: https://registry.terraform.io/providers/ubiquiti-community/unifi/latest/docs/resources/firewall_rule

### Authentication
1. Authenticate to Unifi:
    - **API Key** (Cloud-Managed) 
        - Unifi -> Admin & Users -> Terraform -> Create API Key
    - **Local Account** (Self-Hosted))
        - Limited Admin
        - 2FA disabled


1. Provider config (handshake) - API key or user/password
2. Network definitions
3. Firewall rules

- `main.tf`: connects Terraform to Unifi controller + PXE
- `locals.tf`: VLANs
- `firewall.tf`: Firewall rules
- `variables.tf`: references `terraform.tfvars`
- `terraform.tfvars`: inside of .git.ignore. Contains actual values. Copy `terraform.tfvars.example` to `terraform.tfvars` 





| Name         | VLAN ID | CIDR           | Notes                  |
| ------------ | ------- | -------------- | ---------------------- |
| Management   | 10      | 10.10.10.0/24  | SSH, Web UI, Unifi     |
| Cluster      | 20      | 10.10.20.0/24  | Corosync               |
| k3s          | 30      | 10.10.30.0/24  |                        |
| Storage      | 40      | 10.10.40.0/24  | TrueNAS, PBS, Longhorn |
| Torrent      | 49      | 172.16.49.0/24 |                        |
| Provisioning | 99      | 10.10.99.0/24  | Netboot                |
