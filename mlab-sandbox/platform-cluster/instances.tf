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

# "Primary" control plane node, which will have "kubeadm init" run when creating
# the cluster.
resource "google_compute_instance" "us-west2-a" {
  boot_disk {
    source = google_compute_disk.api_disks["us-west2-a"].id
  }

  machine_type = var.api_instances.attributes.machine_type
  name         = "api-platform-cluster-us-west2-a"

  network_interface {
    access_config {
      nat_ip = google_compute_address.api_addresses["us-west2-a"].id
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
  zone = "us-west2-a"
}

# "Secondary" control plane machines, which will have "kubeadm join" run when
# creating the cluster. They will depend on the "primary" machine, since the
# primary machine is responsible for initilizing the cluster, and we don't want
# these to be created until the primary machine already exists and has
# initilized the cluster.
resource "google_compute_instance" "us-west2-b" {
  depends_on = [google_compute_instance.us-west2-a]

  boot_disk {
    source = google_compute_disk.api_disks["us-west2-b"].id
  }

  machine_type = var.api_instances.attributes.machine_type
  name         = "api-platform-cluster-us-west2-b"

  network_interface {
    access_config {
      nat_ip = google_compute_address.api_addresses["us-west2-b"].id
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
  zone = "us-west2-b"
}

resource "google_compute_instance" "us-west2-c" {
  depends_on = [google_compute_instance.us-west2-a]

  boot_disk {
    source = google_compute_disk.api_disks["us-west2-c"].id
  }

  machine_type = var.api_instances.attributes.machine_type
  name         = "api-platform-cluster-us-west2-c"

  network_interface {
    access_config {
      nat_ip = google_compute_address.api_addresses["us-west2-c"].id
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
  zone = "us-west2-c"
}

resource "google_compute_address" "api_addresses" {
  for_each     = var.api_instances.zones
  address_type = "EXTERNAL"
  name         = "api-platform-cluster-${each.key}"
  region       = var.api_instances.attributes.region
}

resource "google_compute_disk" "api_disks" {
  for_each = var.api_instances.zones
  image    = var.api_instances.attributes.disk_image
  name     = "api-platform-cluster-${each.key}"
  size     = var.api_instances.attributes.disk_size_gb
  type     = var.api_instances.attributes.disk_type
  zone     = each.key
}
