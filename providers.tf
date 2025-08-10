terraform {
  required_version = "> 1.12.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.80.0"
    }
    http = {
      source = "hashicorp/http"
      version = ">= 3.5.0"
    }
  }
}
