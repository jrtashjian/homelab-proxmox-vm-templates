# Proxmox VM Template Terraform Configuration

The configuration in this repository creates a VM template named `cloudinit-debian-{release}` on a specified Proxmox node. The VM is configured with various settings, including the operating system type, CPU type, disk configuration, network device, VGA type, and initialization settings. The VM is set up to use the QEMU Guest Agent for enhanced functionality.

Additionally, this config also ensures that the latest Debian LXC container template is available on the Proxmox node.

## Variables for CI/CD Pipeline

A GitLab environment is created by the CI/CD pipeline for each Proxmox node this Terraform project is deployed to. Each environment is named after the hostname of the node (`pve-node01`, `pve-node02`, etc).

The pipeline utilizes [1Password Service Account](https://developer.1password.com/docs/service-accounts) for retrieving passwords [defined as variables](https://docs.gitlab.com/ee/ci/variables/#define-a-cicd-variable-in-the-ui) using the [Secret Reference](https://developer.1password.com/docs/cli/secret-references/) syntax.

### `OP_SERVICE_ACCOUNT_TOKEN`

The service account token of the service account to use.

---

### `PROXMOX_VE_USERNAME`

The username and realm for the Proxmox Virtual Environment API

### `PROXMOX_VE_PASSWORD`

The password for the Proxmox Virtual Environment API

### `PROXMOX_VE_SSH_USERNAME`

The username to use for the SSH connection. Defaults to the username used for the Proxmox API connection.

### `PROXMOX_VE_SSH_PASSWORD`

The password to use for the SSH connection. Defaults to the password used for the Proxmox API connection.

---

### `TF_VAR_ansible_user`

The username used to SSH into remote hosts with Ansible.

### `TF_VAR_ansible_pass`

The password used to SSH into remote hosts with Ansible.

### `TF_VAR_ansible_public_key`

The public_key used to SSH into remote hosts with Ansible.
