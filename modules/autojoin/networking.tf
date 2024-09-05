resource "google_compute_network" "autojoin" {
  auto_create_subnetworks = false
  description             = "VPC network for the Autojoin API (managed by Terraform)"
  name                    = "autojoin"
}

resource "google_compute_address" "autonode_ipv4" {
  description = "Static IPv4 for the autonode VM (managed by Terraform)"
  name        = "autonode-ipv4-address"
}

resource "google_compute_subnetwork" "autojoin" {
  name             = "autojoin"
  ip_cidr_range    = "10.70.0.0/16"
  ipv6_access_type = "EXTERNAL"
  network          = google_compute_network.autojoin.id
  stack_type       = "IPV4_IPV6"
}

resource "google_compute_subnetwork" "gae" {
  name             = "gae"
  ip_cidr_range    = "10.80.0.0/16"
  ipv6_access_type = "EXTERNAL"
  network          = google_compute_network.autojoin.id
  region           = var.appengine_region
  stack_type       = "IPV4_IPV6"
}

resource "google_compute_address" "autojoin" {
  name         = "autojoin-ingress-nginx"
  address_type = "EXTERNAL"
  description  = "External IP address for ingress-nginx"
}
