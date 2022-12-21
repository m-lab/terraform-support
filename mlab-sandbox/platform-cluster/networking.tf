resource "google_compute_network" "mlab_platform_network" {
  auto_create_subnetworks = false
  name                    = "mlab-platform-network"
}

resource "google_compute_subnetwork" "kubernetes" {
  for_each         = var.subnetworks
  ip_cidr_range    = each.value
  ipv6_access_type = "EXTERNAL"
  name             = "kubernetes"
  network          = google_compute_network.mlab_platform_network.id
  region           = each.key
  stack_type       = "IPV4_IPV6"
}

resource "google_compute_subnetwork" "epoxy" {
  ip_cidr_range = "10.3.0.0/16"
  name          = "epoxy"
  network       = google_compute_network.mlab_platform_network.id
  region        = "us-west2"
}
