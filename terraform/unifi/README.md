## Setup:
**Documentation**: https://registry.terraform.io/providers/ubiquiti-community/unifi/latest/docs

> [!DANGER] All changes to Unifi MUST be done with Terraform
> Terraform keeps tracks of objects in the .tfstate. If you make changes in Unifi web ui, those changes do NOT get synced back to terraform and it loses control. If changes are made on Unifi UI, you HAVE to declare those changes in terraform code before next `terraform apply`. For simplicity, you can use terraform for an initial build with networks, but do things like firewalls manually. Can use terraform as a starting point and then dont let it be the source of truth. Just use it as bootstrapping. If that's the case, I should only even run `terraform apply` ONCE!!!
> 


#### Authentication
- **API Key** (Cloud-Managed)
	- Unifi -> Admin & Users -> Terraform -> Create API Key
- **Local Account** (Self-Hosted))
	- Limited Admin
	- 2FA disabled


```sh
git clone https://github.com/itshughboi/iac.git
cd /iac/terraform/unifi
```


- `main.tf`: connects Terraform to Unifi controller + PXE
- `locals.tf`: VLANs
- `firewall.tf`: Firewall rules
- `variables.tf`: references `terraform.tfvars`
- `terraform.tfvars`: inside of .git.ignore. Contains actual values. Copy `terraform.tfvars.example` to `terraform.tfvars`

```
terraform init
terraform plan
terraform apply
```
- Unifi should now be provisioned with all firewall rules, ports, and VLANs including the DHCP + PXE options. View those here: [[Overview]]. One port dedicated to provisioning. Plugging in should from DHCP give provisioning device 10.10.99.100 which Unifi will point all DHCP boot to

> [!DANGER] Add `terraform.tfvars`to Git Ignore 
> NEVER commit this to Git!!!





| Name         | VLAN ID | CIDR           | Notes                  |
| ------------ | ------- | -------------- | ---------------------- |
| Management   | 10      | 10.10.10.0/24  | SSH, Web UI, Unifi     |
| Cluster      | 20      | 10.10.20.0/24  | Corosync               |
| k3s          | 30      | 10.10.30.0/24  |                        |
| Storage      | 40      | 10.10.40.0/24  | TrueNAS, PBS, Longhorn |
| Torrent      | 49      | 172.16.49.0/24 |                        |
| Provisioning | 99      | 10.10.99.0/24  | Netboot                |
