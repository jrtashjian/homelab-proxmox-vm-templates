variable "node_name" {
  description = "proxmox node name"
  type        = string
}

variable "node_datastore" {
  description = "proxmox node default datastore"
  type        = string
  default     = "local-zfs"
}

variable "ansible_user" {
  description = "Ansible user"
  type        = string
}

variable "ansible_pass" {
  description = "Ansible password"
  type        = string
  sensitive   = true
}

variable "ansible_public_key" {
  description = "Ansible public key"
  type        = string
}
