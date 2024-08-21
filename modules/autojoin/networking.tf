resource "google_compute_network" "autojoin" {
  auto_create_subnetworks = false
  description             = "VPC network for the Autojoin API (managed by Terraform)"
  name                    = "autojoin"
}

resource "google_compute_address" "autonode_ipv4" {
  description = "Static IPv4 for the autonode VM (managed by Terraform)"
  name        = "autonode-ipv4-address"
}

resource "google_compute_subnetwork" "default" {
  name          = "autojoin"
  ip_cidr_range = "10.80.0.0/16"
  network       = google_compute_network.autojoin.id
  region        = data.google_client_config.current.region
}
