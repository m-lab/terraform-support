resource "google_container_node_pool" "stats_pipeline" {
  autoscaling {
    max_node_count = 2
    min_node_count = 0
  }

  cluster            = "data-processing"
  initial_node_count = 3
  location           = "us-east1"

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  name = "stats-pipeline"

  node_config {
    disk_size_gb = 100
    disk_type    = "pd-standard"
    image_type   = "COS_CONTAINERD"

    labels = {
      stats-pipeline-node = "true"
    }

    machine_type = "n2-highcpu-16"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    service_account = "stats-pipeline@mlab-sandbox.iam.gserviceaccount.com"

    shielded_instance_config {
      enable_integrity_monitoring = true
    }
  }

  node_count     = 0
  node_locations = ["us-east1-b", "us-east1-c", "us-east1-d"]
  project        = "mlab-sandbox"

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  version = "1.24.14-gke.1200"
}
# terraform import google_container_node_pool.stats_pipeline mlab-sandbox/us-east1/data-processing/stats-pipeline