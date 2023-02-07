resource "google_compute_network" "platform_cluster" {
  auto_create_subnetworks = false
  name                    = var.networking.attributes.vpc_name
}

resource "google_compute_subnetwork" "platform_cluster" {
  for_each         = var.networking.subnetworks
  ip_cidr_range    = each.value.ip_cidr_range
  ipv6_access_type = "EXTERNAL"
  name             = each.value.name
  network          = google_compute_network.platform_cluster.id
  region           = each.value.region
  stack_type       = var.networking.attributes.stack_type
}
