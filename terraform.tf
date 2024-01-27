terraform {
  backend "http" {
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.45.0"
    }
  }

  required_version = ">= 1.7"
}
