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
