resource "proxmox_virtual_environment_vm" "rke2" {
  for_each = local.vms

  name        = each.value.name
  description = "RKE2 ${replace(trimsuffix(each.value.role, "-node"), "-", " ")} node managed by Terraform"
  tags        = concat([each.value.role_tag, local.target_env_tag], var.vm_tags)

  node_name = var.proxmox_node_name
  vm_id     = each.value.vm_id

  clone {
    vm_id        = var.template_vm_id
    node_name    = local.template_node_name
    datastore_id = var.clone_datastore_id
    full         = true
    retries      = 3
  }

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cores
    type  = "host"
  }

  memory {
    dedicated = each.value.memory_mb
    floating  = each.value.memory_mb
  }

  disk {
    datastore_id = var.clone_datastore_id
    interface    = "scsi0"
    size         = each.value.disk_gb
    discard      = "on"
  }

  initialization {
    datastore_id = var.cloud_init_datastore_id

    dns {
      domain  = var.dns_domain
      servers = var.dns_servers
    }

    ip_config {
      ipv4 {
        address = format("%s/%s", each.value.ip_address, local.network_prefix_length)
        gateway = var.network_gateway
      }
    }

  }

  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  operating_system {
    type = "l26"
  }

  serial_device {
    device = "socket"
  }

  scsi_hardware   = "virtio-scsi-single"
  started         = var.start_vms
  on_boot         = true
  stop_on_destroy = true

  startup {
    order    = each.value.startup_order
    up_delay = 30
  }

}
