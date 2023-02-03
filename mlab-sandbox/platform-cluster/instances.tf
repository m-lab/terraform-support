#
# Platform instances
#
resource "google_compute_instance" "instances" {
  for_each = var.instances.names

  allow_stopping_for_update = true

  boot_disk {
    source = google_compute_disk.disks["${each.key}"].id
  }

  hostname     = "${each.key}.${var.project}.measurement-lab.org"
  machine_type = var.instances.attributes.machine_type

  metadata = {
    k8s_labels = join(",", [
      "mlab/machine=${split("-", each.key)[0]}",
      "mlab/site=${split("-", each.key)[1]}",
      "mlab/metro=${substr(each.key, 6, 3)}",
      "mlab/type=virtual",
      "mlab/run=ndt",
      "mlab/project=${var.project}"
    ])
  }

  name = "${each.key}-${var.project}-measurement-lab-org"

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
  # This regex is ugly, but I can't find a better way to extract the region from
  # the zone.
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
  for_each = var.api_instances.zones

  allow_stopping_for_update = true

  attached_disk {
    source = google_compute_disk.api_data_disks[each.key].id
    # Device name will be /dev/disk/by-id/google-<name>
    device_name = var.api_instances.machine_attributes.disk_dev_name_data
  }

  boot_disk {
    source = google_compute_disk.api_boot_disks[each.key].id
  }

  machine_type = var.api_instances.machine_attributes.machine_type

  metadata = {
    cluster_data = jsonencode(var.api_instances)
  }

  name = "api-platform-cluster-${each.key}"

  network_interface {
    access_config {
      nat_ip = google_compute_address.api_addresses[each.key].address
    }
    ipv6_access_config {
      network_tier = "PREMIUM"
    }
    network    = google_compute_network.platform_cluster.id
    stack_type = var.networking.attributes.stack_type
    subnetwork = google_compute_subnetwork.platform_cluster[var.api_instances.machine_attributes.region].id
  }

  service_account {
    scopes = var.api_instances.machine_attributes.scopes
  }

  tags = var.api_instances.machine_attributes.tags
  zone = each.key
}

resource "google_compute_address" "api_addresses" {
  for_each     = var.api_instances.zones
  address_type = "EXTERNAL"
  name         = "api-platform-cluster-${each.key}"
  region       = var.api_instances.machine_attributes.region
}

resource "google_compute_disk" "api_boot_disks" {
  for_each = var.api_instances.zones
  image    = var.api_instances.machine_attributes.disk_image
  name     = "api-platform-cluster-boot-${each.key}"
  size     = var.api_instances.machine_attributes.disk_size_gb_boot
  type     = var.api_instances.machine_attributes.disk_type
  zone     = each.key
}

resource "google_compute_disk" "api_data_disks" {
  for_each = var.api_instances.zones
  name     = "api-platform-cluster-data-${each.key}"
  size     = var.api_instances.machine_attributes.disk_size_gb_data
  type     = var.api_instances.machine_attributes.disk_type
  zone     = each.key
}


#
# Prometheus instance
#
resource "google_compute_instance" "prometheus" {
  allow_stopping_for_update = true

  attached_disk {
    source = google_compute_disk.prometheus_data_disk.id
    # Device name will be /dev/disk/by-id/google-<name>
    device_name = "mlab-data"
  }

  boot_disk {
    source = google_compute_disk.prometheus_boot_disk.id
  }

  machine_type = var.prometheus_instance.machine_type

  metadata = {
    k8s_labels = "run=prometheus-server"
  }

  name = "prometheus-platform-cluster"

  network_interface {
    access_config {
      nat_ip = google_compute_address.prometheus_address.address
    }
    ipv6_access_config {
      network_tier = "PREMIUM"
    }
    network    = google_compute_network.platform_cluster.id
    stack_type = var.networking.attributes.stack_type
    subnetwork = google_compute_subnetwork.platform_cluster[var.prometheus_instance.region].id
  }

  service_account {
    scopes = var.prometheus_instance.scopes
  }

  tags = var.prometheus_instance.tags
  zone = var.prometheus_instance.zone
}

resource "google_compute_address" "prometheus_address" {
  address_type = "EXTERNAL"
  name         = "prometheus-platform-cluster"
  region       = var.prometheus_instance.region
}

resource "google_compute_disk" "prometheus_boot_disk" {
  image = var.prometheus_instance.disk_image
  name  = "prometheus-platform-cluster-boot"
  size  = var.prometheus_instance.disk_size_gb_boot
  type  = var.prometheus_instance.disk_type
  zone  = var.prometheus_instance.zone
}

resource "google_compute_disk" "prometheus_data_disk" {
  name = "prometheus-platform-cluster-data"
  size = var.prometheus_instance.disk_size_gb_data
  type = var.prometheus_instance.disk_type
  zone = var.prometheus_instance.zone
}
