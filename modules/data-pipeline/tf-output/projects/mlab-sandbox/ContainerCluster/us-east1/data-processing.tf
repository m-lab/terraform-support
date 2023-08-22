resource "google_container_cluster" "data_processing" {
  addons_config {
    network_policy_config {
      disabled = true
    }
  }

  cluster_autoscaling {
    enabled             = false
  }

  cluster_ipv4_cidr = "10.12.0.0/14"

 # cluster_telemetry {
 #   type = "ENABLED"
 # }

  database_encryption {
    state = "DECRYPTED"
  }

  default_max_pods_per_node = 110
  enable_shielded_nodes     = false
  location                  = "us-east1"

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
  }

  name    = "data-processing"
  network = "projects/mlab-sandbox/global/networks/data-processing"

  network_policy {
    enabled  = false
    provider = "PROVIDER_UNSPECIFIED"
  }

  networking_mode = "ROUTES"

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

  node_locations = ["us-east1-b", "us-east1-c", "us-east1-d"]
  node_version   = "1.24.14-gke.1200"

  #pod_security_policy_config {
  #  enabled = false
  #}

  project = "mlab-sandbox"

  release_channel {
    channel = "STABLE"
  }

  resource_labels = {
    data-processing = "true"
  }

  subnetwork = "projects/mlab-sandbox/regions/us-east1/subnetworks/dp-gardener"
}
# terraform import google_container_cluster.data_processing mlab-sandbox/us-east1/data-processing
