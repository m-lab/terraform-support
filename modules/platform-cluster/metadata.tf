resource "google_compute_project_metadata" "default" {
  metadata = {
    api_load_balancer      = var.api_instances.cluster_attributes.api_load_balancer
    epoxy_extension_server = var.api_instances.cluster_attributes.epoxy_extension_server
    ssh-keys               = join("\n", [for k, v in var.ssh_keys : "${v.user}:${v.pubkey}"])
  }
}
