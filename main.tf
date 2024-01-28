provider "proxmox" {
  insecure = true

  ssh {
    agent = true
  }
}


resource "proxmox_virtual_environment_file" "debian_cloud_image" {
  node_name = var.node_name

  content_type = "iso"
  datastore_id = "local"

  source_file {
    # Obtain with: `shasum -a256 debian-12-genericcloud-amd64.qcow2`
    checksum  = "ef9270aee834900d5195b257d7580dc96483a298bf54e5c0555385dc23036e90"
    path      = "https://cloud.debian.org/images/cloud/bookworm/20240102-1614/debian-12-genericcloud-amd64-20240102-1614.qcow2"
    file_name = "debian-12-genericcloud-amd64.img"
  }
}

resource "proxmox_virtual_environment_file" "debian_vendor_config" {
  node_name = var.node_name

  content_type = "snippets"
  datastore_id = "local"

  source_raw {
    data      = file("debian-vendor-config.yml")
    file_name = "debian-vendor-config.yml"
  }
}

resource "proxmox_virtual_environment_vm" "debian_template" {
  node_name = var.node_name
  name      = "cloudinit-debian-12-gitlab"
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
    datastore_id = var.node_datastore
    file_id      = proxmox_virtual_environment_file.debian_cloud_image.id
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
    datastore_id = var.node_datastore

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