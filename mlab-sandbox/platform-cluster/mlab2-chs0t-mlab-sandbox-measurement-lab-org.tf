resource "google_compute_instance" "mlab2_chs0t_mlab_sandbox_measurement_lab_org" {
  boot_disk {
    source = google_compute_disk.mlab2_chs0t_mlab_sandbox_measurement_lab_org.id
  }

  hostname     = "mlab2-chs0t.mlab-sandbox.measurement-lab.org"
  machine_type = var.machine_type
  name         = "mlab2-chs0t-mlab-sandbox-measurement-lab-org"

  network_interface {
    access_config {
      nat_ip = google_compute_address.mlab2_chs0t_mlab_sandbox_measurement_lab_org.address
    }
    ipv6_access_config {
      network_tier = "PREMIUM"
    }
    network    = var.network
    stack_type = var.stack_type
    subnetwork = var.subnetwork
  }

  project = var.project

  service_account {
    scopes = var.vm_scopes
  }

  tags = var.tags
  zone = "us-east1-c"
}

resource "google_compute_address" "mlab2_chs0t_mlab_sandbox_measurement_lab_org" {
  address_type = "EXTERNAL"
  name         = "mlab2-chs0t-mlab-sandbox-measurement-lab-org"
  project      = var.project
  region       = "us-east1"
}

resource "google_compute_disk" "mlab2_chs0t_mlab_sandbox_measurement_lab_org" {
  image = var.disk_image
  name  = "mlab2-chs0t-mlab-sandbox-measurement-lab-org"
  size  = var.disk_size_gb
  type  = var.disk_type
  zone  = "us-east1-c"
}
