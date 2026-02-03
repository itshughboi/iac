terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.66.0"
    }
  }
}

# Define the variable (The Placeholder)
variable "proxmox_api_token" {
  type      = string
  sensitive = true # This hides the value from console logs
}

provider "proxmox" {
  endpoint  = "https://10.10.10.1:8006/" 
  api_token = var.proxmox_api_token       # Reference the variable
  insecure  = true 
}
