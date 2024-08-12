# Allow open access to prometheus metrics on select servers
resource "google_compute_firewall" "public_prometheus_monitoring" {
  allow {
    ports    = ["9990-9999"]
    protocol = "tcp"
  }
  
  description   = "Allow open access to prometheus metrics on select servers"
  name          = "public-prometheus-monitoring"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["public-prometheus-monitoring"]
}
