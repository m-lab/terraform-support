resource "google_compute_subnetwork" "monitoring" {
  ip_cidr_range    = var.subnet_cidr
  ipv6_access_type = "EXTERNAL"
  name             = "monitoring"
  network          = "mlab-platform-network"
  region           = var.region
  stack_type       = "IPV4_IPV6"
}

resource "google_compute_address" "monitoring_ipv4" {
  description = "Static external IPv4 address for the monitoring VM (managed by Terraform)"
  name        = "monitoring-ipv4"
  region      = var.region
}
