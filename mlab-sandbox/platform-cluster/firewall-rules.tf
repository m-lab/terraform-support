# Allow external access to ports:
#
#   TCP 22: SSH
#   TCP 6443: k8s API servers
#   UDP 8472: VXLAN (flannel)
resource "google_compute_firewall" "platform_cluster_external" {
  allow {
    ports    = ["22", "6443"]
    protocol = "tcp"
  }

  allow {
    ports    = ["8472"]
    protocol = "udp"
  }

  name          = "platform-cluster-external"
  network       = google_compute_network.mlab_platform_network.name
  source_ranges = ["0.0.0.0/0"]
}

# Allow GCP health checks.
#
# https://cloud.google.com/load-balancing/docs/health-checks#firewall_rules
resource "google_compute_firewall" "platform_cluster_health_checks" {
  allow {
    ports    = ["6443"]
    protocol = "tcp"
  }

  name          = "platform-cluster-health-checks"
  network       = google_compute_network.mlab_platform_network.name
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
    ports    = ["8800", "8801"]
    protocol = "tcp"
  }

  name          = "platform-cluster-epoxy-extensions"
  network       = google_compute_network.mlab_platform_network.name
  source_ranges = [google_compute_subnetwork.epoxy.ip_cidr_range]
}

# Allow external access to the ePoxy boot server.
resource "google_compute_firewall" "allow_epoxy_ports" {
  allow {
    ports    = ["443", "4430", "9000"]
    protocol = "tcp"
  }

  name          = "allow-epoxy-ports"
  network       = google_compute_network.mlab_platform_network.name
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-epoxy-ports"]
}

# Allow access to anything in the network from instances/services in the
# internal k8s subnet.
resource "google_compute_firewall" "platform_cluster_internal" {
  allow {
    protocol = "all"
  }

  name          = "platform-cluster-internal"
  network       = google_compute_network.mlab_platform_network.name
  source_ranges = [google_compute_subnetwork.kubernetes["us-west2"].ip_cidr_range]
}

# Allow external access to any port for IPv4 traffic platform VMs.
resource "google_compute_firewall" "platform_cluster_ndt_cloud" {
  allow {
    protocol = "all"
  }

  name          = "platform-cluster-ndt-cloud"
  network       = google_compute_network.mlab_platform_network.name
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ndt-cloud"]
}

# Allow external access to any port for IPv6 traffic platform VMs.
resource "google_compute_firewall" "platform_cluster_ndt_cloud_ipv6" {
  allow {
    protocol = "all"
  }

  name          = "platform-cluster-ndt-cloud-ipv6"
  network       = google_compute_network.mlab_platform_network.name
  source_ranges = ["::/0"]
  target_tags   = ["ndt-cloud"]
}

# Allow external access to Prometheus
resource "google_compute_firewall" "platform_cluster_prometheus_external" {
  allow {
    ports    = ["22", "80", "443", "9090"]
    protocol = "tcp"
  }

  name          = "platform-cluster-prometheus-external"
  network       = google_compute_network.mlab_platform_network.name
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["prometheus-platform-cluster"]
}
