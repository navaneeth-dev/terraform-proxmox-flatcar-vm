# Terraform BPG/Proxmox Flatcar Linux VM Module

Use the BPG/Proxmox provider to create a Flatcar Container Linux VM. This module will download 
the Flatcar Image and provision one (or more) virtual machines with a Butane/Ignition
configuration.

The module directly provisions virtual machines from the Flatcar Container Linux QEMU
distribution image. No Proxmox template virtual machine is required or used.

The butane configuration is rendered to ignition using the `KeisukeYamashita/butane`
provider, and provided to the running instance via QEMU fw_cfg parameters. This allows
a large unconstrained Butane configuration.

Long lived persistent disks can automatically be provisioned by creating a secondary
non-running virtual machine that storages the images. This is marked in the terraform as 
being unable to be deleted.

# Usage

Put local secrets into a file `credentials.auto.tfvars` with values of the form:

```
node_name    = "proxmox"
pm_api_url   = "https://proxmox.local:8006/api2/json"
pm_user      = "root@pam"
pm_password  = "a-secret-password"
ssh_username = "user"
```
# Known Limitations


- There is no built-in (simple) way to storage terraform state on the Proxmox host
- Path mapping for the ignition configuration to a host path is required

# Links

- https://www.flatcar.org/
- https://registry.terraform.io/providers/bpg/proxmox/latest/docs
- https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm
- https://registry.terraform.io/providers/KeisukeYamashita/butane/latest

## Terraform Modules

- https://developer.hashicorp.com/terraform/registry/modules/publish
- https://developer.hashicorp.com/terraform/language/modules/develop/structure
