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

  # Confine GKE node auto-upgrades to a daily window outside of the daily
  # parsing window (~10:30-18:30 UTC). Node-pool upgrades drain nodes and evict
  # the etl-parser pods; if that happens mid-job, in-flight parse tasks are lost
  # and never re-reported to gardener, which stalls the job until its stale-job
  # tracker reaps it (with no retry), leaving a gap in the day's data. The
  # cluster is on the REGULAR release channel, so node auto-upgrade is mandatory
  # and cannot be disabled; restricting *when* it runs is the available lever.
  # The dates below are arbitrary anchors for the recurrence series; only the
  # time-of-day (00:00-06:00 UTC), the duration, and the daily recurrence matter.
  maintenance_policy {
    recurring_window {
      start_time = "2024-01-01T00:00:00Z"
      end_time   = "2024-01-01T06:00:00Z"
      recurrence = "FREQ=DAILY"
    }
  }
}

resource "google_container_node_pool" "node_pools" {
  for_each = var.node_pools

  autoscaling {
    max_node_count = each.value["max_node_count"]
    min_node_count = 0
  }

  cluster            = google_container_cluster.data_pipeline.name
  initial_node_count = each.value["initial_node_count"]
  location           = data.google_client_config.current.region
  name               = each.key

  node_config {
    labels = {
      "${each.key}-node" = "true"
    }

    machine_type = each.value["machine_type"]
    oauth_scopes = each.value["oauth_scopes"]
    # This is a bit ugly, but TF does not support passing resources as input
    # variables to a module. In this case, all node pools use the default
    # service account except for the statistics node pool.
    service_account = each.key == "statistics" ? google_service_account.stats_pipeline.email : "default"
  }

  upgrade_settings {
    max_surge       = each.value["max_surge"]
    max_unavailable = 0
  }
}
