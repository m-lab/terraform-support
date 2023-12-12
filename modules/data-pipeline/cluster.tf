resource "google_container_cluster" "data_pipeline" {
  name                     = "data-pipeline"
  initial_node_count       = 1
  location                 = data.google_client_config.current.region
  network                  = google_compute_network.data_pipeline.id
  remove_default_node_pool = true

  resource_labels = {
    data-pipeline = "true"
  }

  subnetwork = google_compute_subnetwork.data_pipeline.id
}

resource "google_container_node_pool" "node_pools" {
  for_each = var.node_pools

  autoscaling {
    max_node_count = each.value["max_node_count"]
    min_node_count = each.value["min_node_count"]
  }

  cluster            = google_container_cluster.data_pipeline.id
  initial_node_count = each.value["initial_node_count"]
  location           = data.google_client_config.current.region
  name               = each.key

  node_config {
    labels          = each.value["labels"]
    machine_type    = each.value["machine_type"]
    oauth_scopes    = each.value["oauth_scopes"]
    service_account = each.value["service_account"]
  }

  upgrade_settings {
    max_surge       = each.value["max_surge"]
    max_unavailable = each.value["max_unavailable"]
  }
}
