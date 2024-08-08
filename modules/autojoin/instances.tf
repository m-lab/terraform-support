resource "google_service_account" "default" {
  account_id   = "autonode"
  display_name = "Custom SA for the autonode VM instance (managed by Terraform)"
}

resource "google_compute_instance" "default" {
  name         = "autonode"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2204-lts"
    }
    auto_delete = false
  }

  network_interface {
    network = "default"
    access_config {
        network_tier     = "PREMIUM"
    }
  }

  metadata_startup_script = "${file("${path.module}/install-docker.sh")}"

  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}