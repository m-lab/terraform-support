resource "google_redis_instance" "cache" {
  authorized_network = google_compute_network.autojoin_vpc_network.id
  display_name       = "Redis instance for the Autojoin API (managed by Terraform)"

  lifecycle {
    # Makes sure this instance is never deleted by Terraform.
    prevent_destroy = true
  }

  memory_size_gb = 4
  name           = "autojoin-api"
  redis_version  = "REDIS_7_0"
  tier           = "STANDARD_HA"
}
