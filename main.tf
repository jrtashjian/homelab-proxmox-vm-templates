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
    checksum  = "ef9270aee834900d5195b257d7580dc96483a298bf54e5c0555385dc23036e90"
    path      = "https://cloud.debian.org/images/cloud/bookworm/20240102-1614/debian-12-genericcloud-amd64-20240102-1614.qcow2"
    file_name = "debian-12-genericcloud-amd64.img"
  }
}
