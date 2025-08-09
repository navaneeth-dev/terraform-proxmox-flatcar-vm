terraform {

  /**

    see:
      - https://registry.terraform.io/providers/bpg/proxmox/latest/docs
   */
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.80.0"
    }

     /**
     https://registry.terraform.io/providers/KeisukeYamashita/butane/latest
      */
    butane = {
      source = "KeisukeYamashita/butane"
      version = ">= 0.1.3"
    }

    /*
    Convert a butane configuration to an ignition JSON configuration

    WARNING: The current flatcar stable release requires ignition v3.3.0 configurations, which
    are supported by the v0.12 provider. The v0.13 CT provider generated v3.4.0 ignition
    configurations which are not supported with Flatcar v3510.2.6. This is all clearly documented in
    the git [README.md](https://github.com/poseidon/terraform-provider-ct)

    see
      - https://github.com/poseidon/terraform-provider-ct
      - https://registry.terraform.io/providers/poseidon/ct/latest
      - https://registry.terraform.io/providers/poseidon/ct/latest/docs
      - https://www.flatcar.org/docs/latest/provisioning/config-transpiler/
  */
/*    ct = {
      source  = "lucidsolns/ct"
      version = ">= 0.13.1"
    }
*/
    null = {
      source  = "hashicorp/null"
      version = ">=3.2.4"
    }
  }
}
