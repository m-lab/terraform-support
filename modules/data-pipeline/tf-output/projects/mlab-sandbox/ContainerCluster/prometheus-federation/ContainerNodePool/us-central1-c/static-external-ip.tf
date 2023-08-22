resource "google_container_node_pool" "static_external_ip" {
  cluster            = "prometheus-federation"
  initial_node_count = 2
  location           = "us-central1-c"

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  name = "static-external-ip"

  node_config {
    disk_size_gb = 100
    disk_type    = "pd-ssd"
    image_type   = "COS_CONTAINERD"

    labels = {
      outbound-ip = "static"
    }

    machine_type = "n2-standard-2"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes    = ["https://www.googleapis.com/auth/datastore", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring"]
    service_account = "default"

    shielded_instance_config {
      enable_integrity_monitoring = true
    }

    taint {
      effect = "NO_SCHEDULE"
      key    = "outbound-ip"
      value  = "static"
    }
  }

  node_count     = 2
  node_locations = ["us-central1-c"]
  project        = "mlab-sandbox"

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  version = "1.25.10-gke.1200"
}
# terraform import google_container_node_pool.static_external_ip mlab-sandbox/us-central1-c/prometheus-federation/static-external-ip
