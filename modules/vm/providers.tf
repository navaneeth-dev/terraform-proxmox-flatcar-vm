terraform {

  /**

    see:
      - https://registry.terraform.io/providers/bpg/proxmox/latest/docs
   */
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.81.0"
    }

     /**
        see:
          - https://registry.terraform.io/providers/KeisukeYamashita/butane/latest
      */
    butane = {
      source = "KeisukeYamashita/butane"
      version = ">= 0.1.3"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.4"
    }
  }
}
