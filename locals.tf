locals {
  network_prefix_length = split("/", var.network_cidr)[1]
  template_node_name    = coalesce(var.template_node_name, var.proxmox_node_name)

  control_plane_vms = {
    for index in range(var.control_plane_count) : format("cp-%02d", index + 1) => {
      name          = format("rke2-cp-%02d", index + 1)
      role          = "control-plane"
      role_tag      = "role-control-plane"
      vm_id         = var.control_plane_vm_id_start + index
      ip_address    = cidrhost(var.network_cidr, var.control_plane_ip_start + index)
      cores         = var.control_plane_cores
      memory_mb     = var.control_plane_memory_mb
      disk_gb       = var.control_plane_disk_gb
      startup_order = 10 + index
    }
  }

  worker_node_vms = {
    for index in range(var.worker_node_count) : format("worker-%02d", index + 1) => {
      name          = format("rke2-worker-%02d", index + 1)
      role          = "worker-node"
      role_tag      = "role-worker"
      vm_id         = var.worker_node_vm_id_start + index
      ip_address    = cidrhost(var.network_cidr, var.worker_node_ip_start + index)
      cores         = var.worker_node_cores
      memory_mb     = var.worker_node_memory_mb
      disk_gb       = var.worker_node_disk_gb
      startup_order = 20 + index
    }
  }

  vms = merge(local.control_plane_vms, local.worker_node_vms)
}
