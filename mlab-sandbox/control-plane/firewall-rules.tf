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

  name          = "kinkade-test-platform-cluster-external"
  network       = google_compute_network.platform_cluster.name
  source_ranges = ["0.0.0.0/0"]
}

# Allow GCP health checks to control plane machines, which should all have the
# network tag "platform-cluster".
#
# 6443: k8s api-server
# 8800: token-server for ePoxy extension allocate_k8s_token
# 8801: bmc-store-password for eponymous ePoxy extension
#
# https://cloud.google.com/load-balancing/docs/health-checks#firewall_rules
resource "google_compute_firewall" "platform_cluster_health_checks" {
  allow {
    ports    = ["6443", "8800", "8801"]
    protocol = "tcp"
  }

  name          = "kinkade-test-platform-cluster-health-checks"
  network       = google_compute_network.platform_cluster.name
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["platform-cluster"]
}

# Allow external access to the ePoxy boot server.
resource "google_compute_firewall" "allow_epoxy_ports" {
  allow {
    ports    = ["443", "4430", "9000"]
    protocol = "tcp"
  }

  name          = "kinkade-test-allow-epoxy-ports"
  network       = google_compute_network.platform_cluster.name
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-epoxy-ports"]
}

# Allow access to anything in the network from instances/services in the
# internal control plane subnet.
resource "google_compute_firewall" "platform_cluster_internal" {
  allow {
    protocol = "all"
  }

  name          = "kinkade-test-platform-cluster-internal"
  network       = google_compute_network.platform_cluster.name
  source_ranges = [google_compute_subnetwork.platform_cluster["${var.api_instances.machine_attributes.region}"].ip_cidr_range]
}

# Allow external access to any port for IPv4 traffic platform VMs.
resource "google_compute_firewall" "platform_cluster_ndt_cloud" {
  allow {
    protocol = "all"
  }

  name          = "kinkade-test-platform-cluster-ndt-cloud"
  network       = google_compute_network.platform_cluster.name
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ndt-cloud"]
}

# Allow external access to any port for IPv6 traffic platform VMs.
resource "google_compute_firewall" "platform_cluster_ndt_cloud_ipv6" {
  allow {
    protocol = "all"
  }

  name          = "kinkade-test-platform-cluster-ndt-cloud-ipv6"
  network       = google_compute_network.platform_cluster.name
  source_ranges = ["::/0"]
  target_tags   = ["ndt-cloud"]
}

# Allow external access to Prometheus
resource "google_compute_firewall" "platform_cluster_prometheus_external" {
  allow {
    ports    = ["22", "80", "443", "9090"]
    protocol = "tcp"
  }

  name          = "kinkade-test-platform-cluster-prometheus-external"
  network       = google_compute_network.platform_cluster.name
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["prometheus-platform-cluster"]
}
