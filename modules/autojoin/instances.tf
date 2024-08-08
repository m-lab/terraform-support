resource "google_compute_instance" "autojoin" {
  name         = "autonode"

  boot_disk {
    auto_delete = false
    initialize_params {
      image = "ubuntu-minimal-2204-lts"
    }
  }

  machine_type = "n2-standard-2"
  metadata_startup_script = "${file("${path.root}/../scripts/install-docker.sh")}"

  network_interface {
    access_config {
      # This empty section makes sure an ephemeral IPv4 is configured for the
      # VM.
    }
    network = "default"
  }

  service_account {
    email  = google_service_account.autonode.email
    scopes = ["cloud-platform"]
  }
}
