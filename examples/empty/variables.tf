variable "pm_api_url" {
  description = "The proxmox api endpoint"
  default     = "https://proxmox:8006/api2/json"
}

//
// see
//  - https://thenewstack.io/automate-k3s-cluster-installation-on-flatcar-container-linux/
//
variable "node_name" {
  default = "proxmox"
}


variable "pm_user" {
  description = "A username for password based authentication of the Proxmox API"
  type        = string
  default     = "root@pam"
}

variable "pm_password" {
  description = "A password for password based authentication of the Proxmox API"
  type        = string
  sensitive   = true
  default     = ""
}

variable "ssh_username" {
  description = "The SSH username used when performing commands that require SSH access to Proxmox"
  default     = "root"
  type        = string
}


variable "storage_name" {
  description = "The name of the datastore to use for storing Flatcar images"
  default     = "local"
}

variable "storage_path" {
  description = "The name of the datastore to use for storing Flatcar images"
  default     = "/var/lib/vz"
}



variable "bridge" {
  default = "vmbr0"
}

variable "vlan_id" {
  default = "109"
}


