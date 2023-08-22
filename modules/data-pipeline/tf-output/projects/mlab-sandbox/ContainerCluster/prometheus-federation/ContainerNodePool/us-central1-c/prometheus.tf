resource "google_container_node_pool" "prometheus" {
  cluster            = "prometheus-federation"
  initial_node_count = 1
  location           = "us-central1-c"

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  name = "prometheus"

  node_config {
    disk_size_gb = 100
    disk_type    = "pd-standard"
    image_type   = "COS_CONTAINERD"

    labels = {
      prometheus-node = "true"
    }

    machine_type = "n2-standard-2"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    service_account = "default"

    shielded_instance_config {
      enable_integrity_monitoring = true
    }

    taint {
      effect = "NO_SCHEDULE"
      key    = "prometheus-node"
      value  = "true"
    }
  }

  node_count     = 1
  node_locations = ["us-central1-c"]
  project        = "mlab-sandbox"

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  version = "1.25.10-gke.1200"
}
# terraform import google_container_node_pool.prometheus mlab-sandbox/us-central1-c/prometheus-federation/prometheus
