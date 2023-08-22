resource "google_container_node_pool" "downloader_pool" {
  autoscaling {
    max_node_count = 1
    min_node_count = 0
  }

  cluster            = "data-processing"
  initial_node_count = 1
  location           = "us-east1"

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  name = "downloader-pool"

  node_config {
    disk_size_gb = 100
    disk_type    = "pd-standard"
    image_type   = "COS_CONTAINERD"

    labels = {
      downloader-node = "true"
    }

    machine_type = "n1-standard-4"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes    = ["https://www.googleapis.com/auth/devstorage.read_write", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring"]
    service_account = "default"

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
# terraform import google_container_node_pool.downloader_pool mlab-sandbox/us-east1/data-processing/downloader-pool
