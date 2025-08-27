#
#  Google OIM VM instances that will Autojoin the platform
#
resource "google_compute_instance" "google_oim_instances" {
  for_each = var.instances.vms

  allow_stopping_for_update = true

  boot_disk {
    auto_delete = false
    source      = google_compute_disk.mlab_boot_disks["${each.key}"].id
  }

  description  = "Platform VMs that are not part of a MIG"
  hostname     = "${each.key}.${data.google_client_config.current.project}.measurement-lab.org"
  machine_type = lookup(each.value, "machine_type", var.instances.attributes.machine_type)

  metadata = {
    probability      = lookup(each.value, "probability", var.instances.attributes.probability),
    iata             = substr(each.key, 6, 3),
    autonode-version = "v0.0.10"
  }

  name = "${each.key}-${data.google_client_config.current.project}-measurement-lab-org"

  network_interface {
    access_config {}
    # For now we will be using the default VPC network
    # network    = google_compute_network.mlab_network.id
    network    = "default"
    stack_type = var.networking.attributes.stack_type
    # Ugly: extract the region from the zone.
    # 2025-08-26: for now, VMs will be IPv4 only and will be part of the default
    # VPC network. Once we can get the necessary ports opened on the
    # "mlab_network" custom VPC network, then we can uncomment this to deploy
    # the VMs to this network which will support IPv6.
    # subnetwork = google_compute_subnetwork.mlab_subnetworks[regex("^([a-z]+-[a-z0-9]+)-[a-z]$", each.value["zone"])[0]].id
  }

  zone = each.value["zone"]
}

resource "google_compute_disk" "mlab_boot_disks" {
  for_each = var.instances.vms
  image    = var.instances.attributes.disk_image
  name     = "${each.key}-${data.google_client_config.current.project}-measurement-lab-org"
  size     = var.instances.attributes.disk_size_gb
  type     = var.instances.attributes.disk_type
  zone     = each.value["zone"]
}
