resource "google_container_node_pool" "parser" {
  autoscaling {
    max_node_count = 3
    min_node_count = 0
  }

  cluster            = "data-processing"
  initial_node_count = 3
  location           = "us-east1"

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  name = "parser"

  node_config {
    disk_size_gb = 100
    disk_type    = "pd-standard"
    image_type   = "COS_CONTAINERD"

    labels = {
      parser-node = "true"
    }

    machine_type = "n2-standard-16"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform", "https://www.googleapis.com/auth/compute", "https://www.googleapis.com/auth/datastore", "https://www.googleapis.com/auth/devstorage.read_write"]
    service_account = "default"

    shielded_instance_config {
      enable_integrity_monitoring = true
    }
  }

  node_count     = 3
  node_locations = ["us-east1-b", "us-east1-c", "us-east1-d"]
  project        = "mlab-sandbox"

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  version = "1.24.14-gke.1200"
}
# terraform import google_container_node_pool.parser mlab-sandbox/us-east1/data-processing/parser
