//
// see
//  - https://thenewstack.io/automate-k3s-cluster-installation-on-flatcar-container-linux/
//
variable "node_name" {
  description = "The name of the node to provision the VM"
  default     = "proxmox"
}

variable "tags" {
  description = "The proxmox virtual machine tags"
  default = []
  type = list(string)
}


variable "bridge" {
  description = "The bridge interface to use for a default single network interface configuration"
  default     = "vmbr0"
  type        = string
}

variable "vlan_id" {
  description = "The VLAN id to use for a default single network interface configuration"
  default     = null
  type        = number
}

variable vm_id {
  description = "The Proxmox integer id of the VM"
  type        = number
}

variable vm_name {
  description = "The name of the virtual machine"
  type        = string
}

variable "vm_description" {
  description = "The description to apply to the Proxmox description (free form)"
  type        = string
  default     = "A Flatcar Linux VM running on Proxmox"
}


variable "storage_images" {
  description = "The name of the datastore to use for storing Flatcar images"
  default     = "local"
}

variable "storage_root" {
  description = "The name of the datastore to store the root filesystem (and the ignition configuration) for the VM"
  default     = "local"
}

/*
  Provide support to the module to map a storage name to a local path on the
  Proxmox nodes filesystem. This is only suitable for storage types that map to
  the local filesystem on the node.

  This mapping is required, because the 'compiled' ignition provided to QEMU via
  the `fw_cfg` command line argument needs a local filesystem path. This workaround
  could be implemented by the bpg/proxmox provider as a 'data' resource in a later
  implementation.
*/
variable storage_path_mapping {
  description = "Mapping of storage name to a local path (this is to support local path name construction)"
  type = map(string)
  default = {
    "local" = "/var/lib/vz"
  }
}

/**
  This allows a fleet of VMs to be deployed in one go.
 */
variable "vm_count" {
  description = "The number of VM's of the given type"
  default     = 1
  type        = number
}

variable "butane_conf" {
  description = "The name/path of the butane file used to configure the Flatcar VM upon first boot"
  type        = string
}
variable "butane_snippet_path" {
  description = "The base path to butane configuration file snippets"
  default     = "config"
  type        = string
}

variable butane_variables {
  description = "An optional map of additional variables to pass to the butane templates"
  type = map(string)
  default = {}
}


variable flatcar_version {
  description = "The version of Flatcar Container Linux to provision (this will be upgraded if it is out of date)"
  type        = string
  default     = "4230.2.1"
}

variable flatcar_channel {
  description = "Which release channel to use for Flatcar Container Linux"
  type        = string
  default     = "stable"
}

variable "flatcar_architecture" {
  default = "amd64"
}

variable cpu {
  description = "The VM cpu parameters"
  type = object({
    cores = optional(number, "1")
    type = optional(string, "qemu64")
  })
  default = {
    cores = 1
    type  = "qemu64"
  }
}

variable memory {
  description = "The VM memory parameters"
  type = object({
    dedicated = optional(number, "512")
    floating = optional(number, "0")
    shared = optional(number, "0")
  })
  default = {
  }
}

variable disks {
  description = "An optional list of disk parameters"
  type = list(object({
    datastore_id = string
    size = number # the size of the disk in gigabytes
    cache = optional(string, "none")
    iothread = optional(bool, false)
    backup = optional(bool, true)
    discard = optional(string, "ignore")
    file_format = optional(string)
  }))
  default = []
}

variable persistent_disks {
  description = "An optional list of persistent disk parameters"
  type = list(object({
    datastore_id = string
    //interface    = string
    size = number
    cache = optional(string, "none")
    iothread = optional(bool, false)
    backup = optional(bool, true)
    discard = optional(string, "ignore")
    file_format = optional(string)
  }))
  default = []
}

/*
    A list of network interfaces.

    The default if no network interface is specified is a single NIC
    connected to the default bridge with the default VLAN.

    In 90% of cases a single NIC is enough more most purposes, but for deploying
    applications with custom storage to non-routable networks (or perhaps
    a virtual firewall), a list of network interfaces can be specified.

*/
variable network_devices {
  description = "An optional list network interfaces"
  type = list(object({
    bridge = optional(string)
    mtu = optional(number, 1)
    vlan_id = optional(number)
    mac_address = optional(string, null)
    queues = optional(number, null)

    enabled = optional(bool, true)
    disconnected = optional(bool, false)
    firewall = optional(bool, false)

  }))
  default = []
}

// The BPG Proxmox provider and modern Flatcar Container Linux both support
// a virtiofs filesystem. This is an upgrade over planfs support.
//
// The BPG Proxmox provider doesn't support provisioning these directory
// mappings at this point in time, so a manual step is required to do this
// on the node in the "Directory Mappings" section for the *Data Center*.
//
// see:
//  - https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#virtiofs-1
variable directories {
  description = "An optional list virtiofs directory mappings"
  type = list(object({
    name = string
    cache = optional(string, "never") // "auto", "always", "never", "metadata"
    direct_io = optional(bool, false)
    expose_acl = optional(bool, false)
    expose_xattr = optional(bool, false)
  }))
  default = []
}

variable image_transfer_timeout {
  description = "How long to wait for images to transfer (download from the internet to Proxmox)"
  type        = number
  default     = 600 /* seconds, aka 10 minutes */
}