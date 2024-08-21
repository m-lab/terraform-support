resource "google_compute_instance" "autonode" {
  boot_disk {
    auto_delete = false
    initialize_params {
      image = "ubuntu-minimal-2204-lts"
    }
  }

  description = "Automated deployment and testing of the autonode Docker compose (managed by Terraform)"
  machine_type = "n2-standard-2"
  metadata_startup_script = "${file("${path.root}/../scripts/install-docker.sh")}"
  name = "autonode"

  network_interface {
    access_config {
      nat_ip = google_compute_address.autonode_ipv4.address
    }
    network = google_compute_network.autojoin.name
    subnetwork = google_compute_subnetwork.default.name
  }

  service_account {
    email  = google_service_account.autonode.email
    scopes = ["cloud-platform"]
  }

  tags = ["http-server", "https-server", "public-prometheus-monitoring"]
}
