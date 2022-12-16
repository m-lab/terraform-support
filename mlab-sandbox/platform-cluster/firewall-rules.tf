# Allow external access to ports:
#
#   TCP 22: SSH
#   TCP 6443: k8s API servers
#   UDP 8472: VXLAN (flannel)
resource "google_compute_firewall" "platform_cluster_external" {
  allow {
    protocol = "tcp"
    ports    = ["22", "6443"]
  }

  allow {
    protocol = "udp"
    ports    = ["8472"]
  }

  name          = "platform-cluster-external"
  network       = google_compute_network.mlab_platform_network.name
  project       = var.project
  source_ranges = ["0.0.0.0/0"]
}

# Allow GCP health checks.
#
# https://cloud.google.com/load-balancing/docs/health-checks#firewall_rules
resource "google_compute_firewall" "platform_cluster_health_checks" {
  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

  name          = "platform-cluster-health-checks"
  network       = google_compute_network.mlab_platform_network.name
  project       = var.project
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["platform-cluster"]
}

# Allow ePoxy to communicate with services running on control plane nodes:
#
#   TCP 8800: "allocate_k8s_token" extension
#   TCP 8801: "bmc_store_password" extension
#
# https://github.com/m-lab/epoxy-extensions
resource "google_compute_firewall" "platform_cluster_epoxy_extensions" {
  allow {
    protocol = "tcp"
    ports    = ["8800,8801"]
  }

  name          = "platform-cluster-epoxy-extensions"
  network       = google_compute_network.mlab_platform_network.name
  project       = var.project
  source_ranges = [google_compute_subnetwork.epoxy.ip_cidr_range]
}

# Allow access to anything in the network from instances/services in the
# internal k8s subnet.
resource "google_compute_firewall" "platform_cluster_internal" {
  allow {
    protocol = "all"
  }

  name          = "platform-cluster-internal"
  network       = google_compute_network.mlab_platform_network.name
  project       = var.project
  source_ranges = [google_compute_subnetwork.kubernetes_us_west2.ip_cidr_range]
}
