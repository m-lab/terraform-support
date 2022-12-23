#
# Platform instances
#
resource "google_compute_instance" "instances" {
  for_each = var.instances.names
  boot_disk {
    source = google_compute_disk.disks["${each.key}"].id
  }

  hostname     = "${each.key}.${var.project}.measurement-lab.org"
  machine_type = var.instances.attributes.machine_type
  name         = "${each.key}-${var.project}-measurement-lab-org"

  network_interface {
    access_config {
      nat_ip = google_compute_address.addresses["${each.key}"].address
    }
    ipv6_access_config {
      network_tier = "PREMIUM"
    }
    network    = var.networking.attributes.vpc_name
    stack_type = var.networking.attributes.stack_type
    subnetwork = var.instances.attributes.subnetwork
  }

  service_account {
    scopes = var.instances.attributes.scopes
  }

  tags = var.instances.attributes.tags
  zone = each.value
}

resource "google_compute_address" "addresses" {
  for_each     = var.instances.names
  address_type = "EXTERNAL"
  name         = "${each.key}-${var.project}-measurement-lab-org"
  # This regex is ugly, but I can't find a better way to do this.
  region = regex("^([a-z]+-[a-z0-9]+)-[a-z]$", each.value)[0]
}

resource "google_compute_disk" "disks" {
  for_each = var.instances.names
  image    = var.instances.attributes.disk_image
  name     = "${each.key}-${var.project}-measurement-lab-org"
  size     = var.instances.attributes.disk_size_gb
  type     = var.instances.attributes.disk_type
  zone     = each.value
}

#
# Control plane ("API") platform instances
#
resource "google_compute_instance" "api_instances" {
  for_each = toset(var.api_instances.zones)
  boot_disk {
    source = google_compute_disk.api_disks["${each.value}"].id
  }

  machine_type = var.api_instances.attributes.machine_type
  name         = "master-platform-cluster-${each.value}"

  network_interface {
    access_config {
      nat_ip = google_compute_address.api_addresses["${each.value}"].id
    }
    ipv6_access_config {
      network_tier = "PREMIUM"
    }
    network    = var.networking.attributes.vpc_name
    stack_type = var.networking.attributes.stack_type
    subnetwork = var.api_instances.attributes.subnetwork
  }

  service_account {
    scopes = var.api_instances.attributes.scopes
  }

  tags = var.api_instances.attributes.tags
  zone = each.value
}

resource "google_compute_address" "api_addresses" {
  for_each     = toset(var.api_instances.zones)
  address_type = "EXTERNAL"
  name         = "master-platform-cluster-${each.value}"
  region       = var.api_instances.attributes.region
}

resource "google_compute_disk" "api_disks" {
  for_each = toset(var.api_instances.zones)
  image    = var.api_instances.attributes.disk_image
  name     = "master-platform-cluster-${each.value}"
  size     = var.api_instances.attributes.disk_size_gb
  type     = var.api_instances.attributes.disk_type
  zone     = each.value
}
