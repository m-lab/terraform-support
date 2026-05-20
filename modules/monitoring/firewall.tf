# Allow IAP to SSH into the monitoring VM for config deployment.
resource "google_compute_firewall" "monitoring_iap_ssh" {
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  description   = "Allow IAP to SSH into the monitoring VM (managed by Terraform)"
  name          = "monitoring-iap-ssh"
  network       = "mlab-platform-network"
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["monitoring"]
}

# Allow Prometheus to scrape the monitoring VM via its external IPv4 address.
resource "google_compute_firewall" "monitoring_scrape" {
  allow {
    ports    = ["9115"]
    protocol = "tcp"
  }
  description   = "Allow Prometheus to scrape the monitoring VM (managed by Terraform)"
  name          = "monitoring-scrape"
  network       = "mlab-platform-network"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["monitoring"]
}
