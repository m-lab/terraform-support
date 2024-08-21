resource "google_container_cluster" "autojoin" {
  name = "autojoin"
  # Note: A GKE cluster must have at least one node, but this is going to be
  # removed immediately since we only want externally-managed node pools.
  # See below for the node pools definitions.
  initial_node_count = 1
  network            = google_compute_network.autojoin.id
  # This removes the default node pool.
  remove_default_node_pool = true

  resource_labels = {
    autojoin = "true"
  }

  subnetwork = google_compute_subnetwork.autojoin.id
}

resource "google_container_node_pool" "node_pools" {
  for_each = var.node_pools

  autoscaling {
    max_node_count = each.value["max_node_count"]
    min_node_count = 0
  }

  cluster            = google_container_cluster.autojoin.name
  initial_node_count = each.value["initial_node_count"]
  location           = data.google_client_config.current.region
  name               = each.key

  node_config {
    labels = {
      "${each.key}-node" = "true"
    }

    machine_type = each.value["machine_type"]
    # Note: OAuth scopes are intentionally set to the widest scope because
    # permissions are entirely managed via IAM / service account roles.
    # See https://cloud.google.com/kubernetes-engine/docs/how-to/access-scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    service_account = google_service_account.gke.email
  }

  upgrade_settings {
    max_surge       = each.value["max_surge"]
    max_unavailable = 0
  }
}
