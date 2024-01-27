provider "proxmox" {
  insecure = true

  ssh {
    agent = true
  }
}


resource "proxmox_virtual_environment_file" "debian_cloud_image" {
  node_name    = var.node_name

  content_type = "iso"
  datastore_id = "local"

  source_file {
    # Obtain with: `shasum -a256 debian-12-genericcloud-amd64.qcow2`
    checksum  = "16e360b50572092ff5c1ed994285bcca961df28c081b7bb5d7c006d35bce4914"
    path      = "http://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
    file_name = "debian-12-genericcloud-amd64.img"
  }
}
