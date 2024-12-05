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

# Allow Prometheus to scrape metrics from Autojoin AppEngine instances
resource "google_compute_firewall" "appengine_prometheus_monitoring" {
  allow {
    ports    = ["9090"]
    protocol = "tcp"
  }

  description   = "Allow Prometheus to scrape metrics from Autjoin AppEngine instances"
  name          = "appengine-prometheus-monitoring"
  network       = google_compute_network.autojoin.name
  source_ranges = ["0.0.0.0/0"]
}

# Allow access to NDT servers on ports 80/443
resource "google_compute_firewall" "ndt_access" {
  allow {
    ports    = ["80", "443"]
    protocol = "tcp"
  }
  allow {
    protocol = "icmp"
  }

  description   = "Allow access to NDT servers"
  name          = "ndt-access"
  network       = google_compute_network.autojoin.name
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ndt-server"]
}

# Allow external access to any port for IPv6 traffic platform VMs.
resource "google_compute_firewall" "ndt_access_ipv6" {
  allow {
    ports    = ["80", "443"]
    protocol = "tcp"
  }
  allow {
    protocol = "58" # NOTE: there is no recognized protocol name for ipv6-icmp.
  }

  description   = "Allow IPv6 access to NDT servers"
  name          = "ndt-access-ipv6"
  network       = google_compute_network.autojoin.name
  source_ranges = ["::/0"]
  target_tags   = ["ndt-server"]
}
