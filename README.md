# tf-proxmox-rke2-instances

Terraform for cloning Ubuntu generic Proxmox VMs that will later be configured as an RKE2 cluster with Ansible.

This creates:

- Control-plane VMs from the ordered `management_nodes` list, for example `rke2-production-control-plane-01` through `rke2-production-control-plane-03`
- Worker-node VMs from the ordered `data_nodes` list, for example `rke2-production-worker-01` through `rke2-production-worker-08`

The Proxmox API endpoint defaults to `https://192.168.123.194:8006/`.

## Semaphore Variables

Store secrets in Semaphore and inject them as Terraform variables:

```bash
TF_VAR_proxmox_api_token='terraform@pve!semaphore=...'
TF_VAR_template_vm_id='9000'
TF_VAR_target_env='production'
```

`template_vm_id` must be the VM ID of the vm template used for cloning; the bpg/proxmox provider clones by VM ID rather than by name.

The Ubuntu template already owns user enrollment and credentials, so Terraform does not create users or inject SSH keys.

## Defaults

| Setting | Value |
| --- | --- |
| Network | `192.168.123.0/24` |
| Gateway | `192.168.123.1` |
| Target environment | `production` |
| Control-plane nodes | `mgmt-01` to `mgmt-03` |
| Worker nodes | `data-01` to `data-08` |
| Control-plane IPs | `192.168.123.201` - `192.168.123.203` |
| Worker-node IPs | `192.168.123.211` - `192.168.123.218` |
| Control-plane VM IDs | `201` - `203` |
| Worker-node VM IDs | `211` - `218` |
| Datastore | `local-lvm` |
| Bridge | `vmbr0` |

Override any of these with Semaphore `TF_VAR_*` values or a Semaphore-managed tfvars file.

The topology is driven by the ordered `management_nodes` and `data_nodes` arrays. VM IDs and IPs are derived from their position in each list by applying the corresponding `*_vm_id_start` and `*_ip_start` values.

## Local Usage

```bash
terraform init
terraform plan
terraform apply
```

Use `terraform.tfvars.example` as a non-secret reference for the variables Semaphore should provide.

## Ansible Handoff

The `vm_inventory`, `control_plane_hosts`, and `worker_node_hosts` outputs are shaped for a later Ansible inventory step.
