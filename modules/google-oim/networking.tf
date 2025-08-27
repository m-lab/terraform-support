resource "google_compute_network" "mlab_network" {
  auto_create_subnetworks = false
  name                    = var.networking.attributes.vpc_name
}

resource "google_compute_subnetwork" "mlab_subnetworks" {
  for_each = var.networking.subnetworks

  ip_cidr_range = each.value.ip_cidr_range
  //ipv6_access_type = "EXTERNAL"
  name       = each.value.name
  network    = google_compute_network.mlab_network.id
  region     = each.value.region
  stack_type = var.networking.attributes.stack_type
}
