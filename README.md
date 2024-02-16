# Proxmox VM Template Terraform Configuration

The configuration in this repository creates a VM template named `cloudinit-debian-{release}` on a specified Proxmox node. The VM is configured with various settings, including the operating system type, CPU type, disk configuration, network device, VGA type, and initialization settings. The VM is set up to use the QEMU Guest Agent for enhanced functionality.

Additionally, this config also ensures that the latest Debian LXC container template is available on the Proxmox node.

## Variables for CI/CD Pipeline

A GitLab environment is created by the CI/CD pipeline for each Proxmox node this Terraform project is deployed to. Each environment is named after the hostname of the node (`pve-node01`, `pve-node02`, etc).

The following variables should be defined for each environment:

**PROXMOX_VE_USERNAME**<br/>
The username and realm for the Proxmox Virtual Environment API

**PROXMOX_VE_PASSWORD**<br/>
The password for the Proxmox Virtual Environment API

**PROXMOX_VE_SSH_USERNAME**<br/>
The username to use for the SSH connection. Defaults to the username used for the Proxmox API connection.

**PROXMOX_VE_SSH_PASSWORD**<br/>
The password to use for the SSH connection. Defaults to the password used for the Proxmox API connection.

The pipeline utilizes [1Password Service Account](https://developer.1password.com/docs/service-accounts) for retrieving passwords [defined as variables](/homelab/proxmox-vm-templates/-/settings/ci_cd) using the [Secret Reference](https://developer.1password.com/docs/cli/secret-references/) syntax.

**OP_SERVICE_ACCOUNT_TOKEN**<br/>
The service account token of the service account to use.