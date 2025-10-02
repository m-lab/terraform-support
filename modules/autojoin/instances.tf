resource "google_compute_instance" "autonode" {
  boot_disk {
    auto_delete = true
    source      = google_compute_disk.autonode_boot_disk
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
