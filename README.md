# Terraform BPG/Proxmox Flatcar Linux VM Module


Use the BPG/Proxmox provider to create a Flatcar Container Linux VM. This module will download 
the Flatcar Image and provision one (or more) virtual machines with a Butane/Ignition
configuration.

The module directly provisions virtual machines from the Flatcar Container Linux QEMU
distribution image. No Proxmox template virtual machine is required or used.

The butane configuration is rendered to ignition using the `KeisukeYamashita/butane`
provider.

# Links

- https://www.flatcar.org/
- https://registry.terraform.io/providers/bpg/proxmox/latest/docs
- https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm
- https://registry.terraform.io/providers/KeisukeYamashita/butane/latest

## Terraform Modules

- https://developer.hashicorp.com/terraform/registry/modules/publish
- https://developer.hashicorp.com/terraform/language/modules/develop/structure