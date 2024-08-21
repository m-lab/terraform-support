# Allow IAP to SSH into every VM in the autojoin network.
resource "google_compute_firewall" "iap_access" {
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  description   = "Allow IAP to SSH into every VM in the autojoin network"
  name          = "iap-access"
  network       = google_compute_network.autojoin.name
  source_ranges = ["35.235.240.0/20"]
}

# Allow open access to prometheus metrics on select servers
resource "google_compute_firewall" "public_prometheus_monitoring" {
  allow {
    ports    = ["9990-9999"]
    protocol = "tcp"
  }
  
  description   = "Allow open access to prometheus metrics on select servers"
  name          = "public-prometheus-monitoring"
  network       = google_compute_network.autojoin.name
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["public-prometheus-monitoring"]
}
