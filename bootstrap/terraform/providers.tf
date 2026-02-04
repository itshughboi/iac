provider "unifi" {
  username = var.unifi_user
  password = var.unifi_password
  api_url  = "https://10.10.10.254" # Your default gateway
  allow_insecure = true             # Because you won't have SSL certs yet
}