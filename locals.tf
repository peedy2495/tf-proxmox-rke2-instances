locals {
  network_prefix_length = split("/", var.network_cidr)[1]
  template_node_name    = coalesce(var.template_node_name, var.proxmox_node_name)

  control_plane_vms = {
    for index in range(var.control_plane_count) : format("cp-%02d", index + 1) => {
      name          = format("rke2-cp-%02d", index + 1)
      role          = "control-plane"
      vm_id         = var.control_plane_vm_id_start + index
      ip_address    = cidrhost(var.network_cidr, var.control_plane_ip_start + index)
      cores         = var.control_plane_cores
      memory_mb     = var.control_plane_memory_mb
      disk_gb       = var.control_plane_disk_gb
      startup_order = 10 + index
    }
  }

  data_node_vms = {
    for index in range(var.data_node_count) : format("data-%02d", index + 1) => {
      name          = format("rke2-data-%02d", index + 1)
      role          = "data-node"
      vm_id         = var.data_node_vm_id_start + index
      ip_address    = cidrhost(var.network_cidr, var.data_node_ip_start + index)
      cores         = var.data_node_cores
      memory_mb     = var.data_node_memory_mb
      disk_gb       = var.data_node_disk_gb
      startup_order = 20 + index
    }
  }

  vms = merge(local.control_plane_vms, local.data_node_vms)
}
