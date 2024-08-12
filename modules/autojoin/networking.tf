resource "google_compute_address" "autonode_ipv4" {
  description = "Static IPv4 for the autonode VM (managed by Terraform)"
  name = "autonode-ipv4-address"
}
