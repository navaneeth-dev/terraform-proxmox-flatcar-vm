/*
  This module mostly uses the 'vm' module once per 'count' virtual machines. This means
  the per VM terraform doesn't have to perform as many mutations.

  The flatcar Linux image retrieval is performed once, regardless of the number of instances
  of the virtual machine.
*/
module "vm" {
  count  = var.vm_count
  source = "./modules/vm"

  node_name      = var.node_name
  vm_name        = var.vm_count > 1 ? format("%s-%d", var.vm_name, count.index + 1) : var.vm_name
  vm_description = var.vm_description
  vm_id          = var.vm_id + count.index
  tags           = var.tags

  vm_index         = count.index
  vm_count         = var.vm_count
  cpu              = var.cpu
  memory           = var.memory
  disks            = var.disks
  persistent_disks = var.persistent_disks

  // If no network devices are provided, then put one default device
  // into the VM.  Use multi-queue for up to 8 cores to try to maximise
  // network bandwidth.
  network_devices = length(var.network_devices) > 0 ? var.network_devices : [
    {
      bridge  = var.bridge
      mtu     = 1
      vlan_id = var.vlan_id
      queues  = var.cpu.cores < 8 ? var.cpu.cores : 8
    }
  ]

  butane_conf          = var.butane_conf
  butane_snippet_path  = var.butane_snippet_path
  butane_variables     = var.butane_variables

  storage_root         = var.storage_root
  storage_path_mapping = var.storage_path_mapping

  flatcar_image_id = proxmox_virtual_environment_download_file.flatcar_image.id
}
