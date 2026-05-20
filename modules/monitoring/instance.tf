resource "google_compute_instance" "monitoring" {
  allow_stopping_for_update = true
  description               = "VM for external network monitoring probes (managed by Terraform)"
  machine_type              = "e2-micro"
  name                      = "ipv6-monitoring"
  zone                      = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2404-lts-amd64"
      size  = 20
      type  = "pd-standard"
    }
  }

  metadata_startup_script = file("${path.root}/../scripts/install-docker.sh")

  network_interface {
    access_config {
      nat_ip = google_compute_address.monitoring_ipv4.address
    }
    ipv6_access_config {
      network_tier = "PREMIUM"
    }
    network    = "mlab-platform-network"
    stack_type = "IPV4_IPV6"
    subnetwork = google_compute_subnetwork.monitoring.name
  }

  tags = ["monitoring"]
}
