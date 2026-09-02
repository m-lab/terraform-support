resource "google_compute_instance" "autonode" {
  boot_disk {
    auto_delete = true
    source      = google_compute_disk.autonode_boot_disk.id
  }

  description             = "Automated deployment and testing of the autonode Docker compose (managed by Terraform)"
  machine_type            = "n2-standard-2"
  metadata_startup_script = file("${path.root}/../scripts/install-docker.sh")
  name                    = "autonode"

  network_interface {
    access_config {
      nat_ip = google_compute_address.autonode_ipv4.address
    }
    ipv6_access_config {
      network_tier = "PREMIUM"
    }
    network    = google_compute_network.autojoin.name
    stack_type = "IPV4_IPV6"
    subnetwork = google_compute_subnetwork.autojoin.name
  }

  service_account {
    email  = google_service_account.autonode.email
    scopes = ["cloud-platform"]
  }

  tags = ["ndt-server", "public-prometheus-monitoring"]
}

resource "google_compute_disk" "autonode_boot_disk" {
  image = "ubuntu-minimal-2404-lts-amd64"
  name  = "autonode-boot-disk"
  size  = "100"
  type  = "pd-ssd"
}

# Same shape as the autonode VM above, but for the mlab-node Debian package,
# which replaces the Docker Compose deployment. The startup script points apt
# at this project's mlab-node Artifact Registry repository and enables
# periodic upgrades; initial installation/configuration is done by the
# byos-debian deploy pipeline.
resource "google_compute_instance" "autonode_deb" {
  count = var.deploy_autonode_deb ? 1 : 0

  boot_disk {
    auto_delete = true
    source      = google_compute_disk.autonode_deb_boot_disk[0].id
  }

  description             = "Automated deployment and testing of the mlab-node Debian package (managed by Terraform)"
  machine_type            = var.autonode_deb_machine_type
  metadata_startup_script = file("${path.root}/../scripts/setup-autonode-deb.sh")
  name                    = "autonode-deb"
  zone                    = var.autonode_deb_zone

  network_interface {
    access_config {
      nat_ip = google_compute_address.autonode_deb_ipv4[0].address
    }
    ipv6_access_config {
      network_tier = "PREMIUM"
    }
    network    = google_compute_network.autojoin.name
    stack_type = "IPV4_IPV6"
    subnetwork = google_compute_subnetwork.autojoin.name
  }

  service_account {
    email  = google_service_account.autonode.email
    scopes = ["cloud-platform"]
  }

  tags = ["ndt-server", "public-prometheus-monitoring"]
}

resource "google_compute_disk" "autonode_deb_boot_disk" {
  count = var.deploy_autonode_deb ? 1 : 0

  image = "ubuntu-minimal-2404-lts-amd64"
  name  = "autonode-deb-boot-disk"
  size  = "100"
  type  = "pd-ssd"
  zone  = var.autonode_deb_zone
}
