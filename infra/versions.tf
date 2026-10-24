terraform {
  required_version = ">= 1.5"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.81"
    }
  }
}

# Credentials come from PROXMOX_VE_ENDPOINT and PROXMOX_VE_API_TOKEN
# in your environment, never from this file.
provider "proxmox" {
  insecure = false
}