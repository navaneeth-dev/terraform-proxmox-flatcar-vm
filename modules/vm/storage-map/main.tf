/**
    A hack to generate the fully qualify path to an absolute storage path. This implementation
    won't scale well in a clustered environment.

    Map a path of the form 'storage:type/path' to an absolute path. In the future this
    could use a 'proxmox_virtual_environment_hardware_mapping_dir' as a way to store
    the path.

    @see
      - https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_hardware_mapping_dir
 */
variable "storage_id" {
  description = "Storage identifier in the form 'name:type/file_name'"
  type        = string

  validation {
    condition     = can(regex("^.+:[^/]+/.+$", var.storage_id))
    error_message = "The 'storage_id' must be in the form 'name:type/file_name', e.g., 'mydisk:import/ubuntu.qcow2'"
  }
}

variable "storage_map" {
  description = "Map from storage name to storage path"
  type = map(string)

  validation {
    condition = (
      can(split(":", var.storage_id)[0]) &&
      contains(keys(var.storage_map), split(":", var.storage_id)[0]) &&
      trimspace(var.storage_map[split(":", var.storage_id)[0]]) != ""
    )
    error_message = "The 'storage_map' must contain a non-empty entry for the storage name derived from 'storage_id'"
  }
}


locals {
  colon_split = split(":", var.storage_id)
  storage_name = local.colon_split[0]
  storage_rest = local.colon_split[1]

  base_path   = var.storage_map[local.storage_name]
  output_path = "${local.base_path}/${local.storage_rest}"
}

output "path" {
  description = "Full resolved path on disk"
  value       = local.output_path
}