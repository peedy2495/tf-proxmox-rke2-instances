variable "proxmox_endpoint" {
  description = "Proxmox VE API endpoint."
  type        = string
  default     = "https://192.168.123.194:8006/"
}

variable "proxmox_api_token" {
  description = "Proxmox API token in the form user@realm!tokenid=secret. Store this in Semaphore secrets."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Allow the provider to connect to Proxmox when it uses a self-signed TLS certificate."
  type        = bool
  default     = true
}

variable "proxmox_node_name" {
  description = "Target Proxmox node name."
  type        = string
  default     = "pve"
}

variable "template_vm_id" {
  description = "VM ID of the Proxmox template named 'ubuntu generic'. The bpg provider clones by VM ID."
  type        = number
}

variable "template_node_name" {
  description = "Proxmox node that hosts the source template. Defaults to the target node."
  type        = string
  default     = null
}

variable "clone_datastore_id" {
  description = "Datastore to place cloned VM disks on."
  type        = string
  default     = "local-lvm"
}

variable "cloud_init_datastore_id" {
  description = "Datastore to place cloud-init disks on."
  type        = string
  default     = "local-lvm"
}

variable "network_bridge" {
  description = "Proxmox bridge for the VM network device."
  type        = string
  default     = "vmbr0"
}

variable "network_cidr" {
  description = "IPv4 network CIDR used to calculate static VM addresses."
  type        = string
  default     = "192.168.123.0/24"
}

variable "network_gateway" {
  description = "IPv4 gateway for cloud-init."
  type        = string
  default     = "192.168.123.1"
}

variable "dns_servers" {
  description = "DNS servers for cloud-init."
  type        = list(string)
  default     = ["192.168.123.1", "1.1.1.1"]
}

variable "dns_domain" {
  description = "DNS search domain for cloud-init."
  type        = string
  default     = null
}

variable "target_env" {
  description = "Target environment used in VM names and tags. Use production, staging or development."
  type        = string
  default     = "production"

  validation {
    condition     = contains(["production", "staging", "development"], var.target_env)
    error_message = "target_env must be either production, staging or development."
  }
}

variable "management_nodes" {
  description = "Ordered list of management node names used for control-plane VMs."
  type        = list(string)
  default = [
    "pve",
    "pve",
    "pve",
  ]
}

variable "data_nodes" {
  description = "Ordered list of data node names used for worker-node VMs."
  type        = list(string)
  default = [
    "pve",
    "pve",
    "pve",
    "pve",
  ]
}

variable "control_plane_vm_id_start" {
  description = "First VM ID for control-plane VMs."
  type        = number
  default     = 201
}

variable "worker_node_vm_id_start" {
  description = "First VM ID for worker-node VMs."
  type        = number
  default     = 211
}

variable "control_plane_ip_start" {
  description = "First host number inside network_cidr for control-plane static IPs."
  type        = number
  default     = 201
}

variable "worker_node_ip_start" {
  description = "First host number inside network_cidr for worker-node static IPs."
  type        = number
  default     = 211
}

variable "control_plane_cores" {
  description = "vCPU cores per control-plane VM."
  type        = number
  default     = 2
}

variable "control_plane_memory_mb" {
  description = "Memory in MB per control-plane VM."
  type        = number
  default     = 4096
}

variable "control_plane_disk_gb" {
  description = "Boot disk size in GB per control-plane VM."
  type        = number
  default     = 40
}

variable "worker_node_cores" {
  description = "vCPU cores per worker-node VM."
  type        = number
  default     = 4
}

variable "worker_node_memory_mb" {
  description = "Memory in MB per worker-node VM."
  type        = number
  default     = 8192
}

variable "worker_node_disk_gb" {
  description = "Boot disk size in GB per worker-node VM."
  type        = number
  default     = 80
}

variable "start_vms" {
  description = "Start VMs after creation."
  type        = bool
  default     = true
}

variable "vm_tags" {
  description = "Tags applied to all VMs in Proxmox."
  type        = list(string)
  default     = ["stack-rke2", "tool-ansible", "tool-terraform"]
}
