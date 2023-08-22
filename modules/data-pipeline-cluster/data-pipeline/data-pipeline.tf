resource "google_container_cluster" "data_pipeline" {
  addons_config {
    network_policy_config {
      disabled = true
    }
  }
  # must be greater than zero.
  initial_node_count = 1

  cluster_autoscaling {
    enabled             = false
  }

  # Auto assign.
  # cluster_ipv4_cidr = "10.80.0.0/16"

  database_encryption {
    state = "DECRYPTED"
  }

  # default_max_pods_per_node = 110
  enable_shielded_nodes     = false
  location                  = "us-central1"

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

  name    = "data-pipeline"
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

  node_locations = ["us-central1-a", "us-central1-b", "us-central1-c"]
  node_version   = "1.25.12-gke.500"
  min_master_version = "1.25.12-gke.500"

  project = "mlab-sandbox"

  release_channel {
    channel = "STABLE"
  }

  resource_labels = {
    data-pipeline = "true"
  }

  subnetwork = "projects/mlab-sandbox/regions/us-central1/subnetworks/dp-gardener"
}
