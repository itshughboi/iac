## Proxmox Integration
1. Create terraform user with Datacenter Admin permissions
    - **Datacenter** -> **Permissions** -> **Users** 
    - **Privilege Separation**: Unchecked

2. Create datacenter API token from Proxmox
    - **Datacenter** -> **Permissions** -> **API Token**
    - Upload the Token Secret to Vaultwarden as you won't see it again. You'll put this into the `terraform.tfvars` file

> [!NOTE] Token can be created via CLI. Document that process
> 
> 

3. Create a `providers.tf` file which will house general configuration for Terraform. You define provider and variables

4. Create a `variables.tf` file which will contain values for variables defined in `providers.tf`

5. Copy the `terraform.tfvars.example` to `terraform.tfvars`. SSH key is usually NOT needed except in very specific use cases.

6. Go into the `athena.tf` file. You will reference the template VM ID ALREADY created in Proxmox using **Packer**
- Define VM name
- Define Hardware 
- Define target node << which proxmox host to deploy on

7. Run Terraform Init on my machine (Macbook) to create terraform state, then run apply
```
terraform init
terraform apply
```

8. You should now see the vm created in Proxmox. Verify hardware and that it boots and has serial console output

#### Destroy
- To destroy the vm we just created, run the following where athena is name of resource defined in `athena.tf`
```
terraform destroy -target=proxmox_virtual_environment_vm.athena
```