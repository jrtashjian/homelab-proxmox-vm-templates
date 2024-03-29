provider "proxmox" {
  insecure = true

  ssh {
    agent = true
  }
}

locals {
  datastore_iso = data.proxmox_virtual_environment_datastores.datastores.datastore_ids[
    index([for v in data.proxmox_virtual_environment_datastores.datastores.content_types : contains(v, "iso")], true)
  ]

  datastore_snippets = data.proxmox_virtual_environment_datastores.datastores.datastore_ids[
    index([for v in data.proxmox_virtual_environment_datastores.datastores.content_types : contains(v, "snippets")], true)
  ]

  datastore_images = data.proxmox_virtual_environment_datastores.datastores.datastore_ids[
    index([for v in data.proxmox_virtual_environment_datastores.datastores.content_types : contains(v, "images")], true)
  ]

  datastore_container_templates = data.proxmox_virtual_environment_datastores.datastores.datastore_ids[
    index([for v in data.proxmox_virtual_environment_datastores.datastores.content_types : contains(v, "vztmpl")], true)
  ]
}

resource "proxmox_virtual_environment_download_file" "debian_container_template" {
  node_name = var.node_name

  content_type = "vztmpl"
  datastore_id = local.datastore_container_templates

  url = "http://download.proxmox.com/images/system/debian-12-standard_12.2-1_amd64.tar.zst"
}

resource "proxmox_virtual_environment_download_file" "debian_cloud_image" {
  node_name = var.node_name

  content_type = "iso"
  datastore_id = local.datastore_iso

  url = "https://cloud.debian.org/images/cloud/bookworm/20240211-1654/debian-12-genericcloud-amd64-20240211-1654.qcow2"

  checksum           = "6856277491c234fa1bc6f250cbd9f0d44f77524479536ecbc0ac536bc07e76322ebb4d42e09605056d6d3879c8eb87db40690a2b5dfe57cb19b0c673fc4c58ca"
  checksum_algorithm = "sha512"

  file_name = "debian-12-genericcloud-amd64.img"
}

resource "proxmox_virtual_environment_file" "debian_vendor_config" {
  node_name = var.node_name

  content_type = "snippets"
  datastore_id = local.datastore_snippets

  source_raw {
    data      = file("debian-vendor-config.yml")
    file_name = "debian-vendor-config.yml"
  }
}

resource "proxmox_virtual_environment_vm" "debian_template" {
  node_name = var.node_name
  name      = "cloudinit-debian-12"
  template  = true

  agent {
    enabled = true
  }

  operating_system {
    type = "l26"
  }

  cpu {
    type = "x86-64-v2-AES"
  }

  disk {
    datastore_id = local.datastore_images
    file_id      = proxmox_virtual_environment_download_file.debian_cloud_image.id
    interface    = "scsi0"
    discard      = "on"
    iothread     = true
  }

  scsi_hardware = "virtio-scsi-single"
  boot_order    = ["scsi0"]

  network_device {
    firewall = true
  }

  vga {
    type = "serial0"
  }

  serial_device {}

  initialization {
    datastore_id = local.datastore_images

    user_account {
      username = var.ansible_user
      password = var.ansible_pass
      keys     = [var.ansible_public_key]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    vendor_data_file_id = proxmox_virtual_environment_file.debian_vendor_config.id
  }
}

data "proxmox_virtual_environment_datastores" "datastores" {
  node_name = var.node_name
}
