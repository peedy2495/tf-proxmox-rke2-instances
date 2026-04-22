output "vm_inventory" {
  description = "Inventory data for the follow-up RKE2 Ansible rollout."
  value = {
    for key, vm in proxmox_virtual_environment_vm.rke2 : key => {
      name         = vm.name
      role         = local.vms[key].role
      vm_id        = vm.vm_id
      ip_address   = local.vms[key].ip_address
      ansible_host = local.vms[key].ip_address
    }
  }
}

output "control_plane_hosts" {
  description = "Control-plane hosts for Ansible."
  value = {
    for key, spec in local.control_plane_vms : spec.name => {
      ansible_host = spec.ip_address
      vm_id        = spec.vm_id
    }
  }
}

output "worker_node_hosts" {
  description = "Worker-node hosts for Ansible."
  value = {
    for key, spec in local.worker_node_vms : spec.name => {
      ansible_host = spec.ip_address
      vm_id        = spec.vm_id
    }
  }
}
