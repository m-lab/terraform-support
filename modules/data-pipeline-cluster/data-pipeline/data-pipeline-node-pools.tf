# home of the gardener.
resource "google_container_node_pool" "default" {
  autoscaling {
    max_node_count = 2
    min_node_count = 0
  }

  cluster            = "data-pipeline"
  initial_node_count = 1
  location           = "us-central1"

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  name = "default"

  node_config {
    disk_size_gb = 100
    disk_type    = "pd-standard"
    image_type   = "COS_CONTAINERD"

    labels = {
      gardener-node = "true"
    }

    machine_type = "n2-standard-4"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes    = ["https://www.googleapis.com/auth/bigquery", "https://www.googleapis.com/auth/compute", "https://www.googleapis.com/auth/datastore", "https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/taskqueue"]
    service_account = "default"

    shielded_instance_config {
      enable_integrity_monitoring = true
    }
  }

  # node_count     = 0
  node_locations = ["us-central1-a", "us-central1-b", "us-central1-c"]
  project        = "mlab-sandbox"

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  version = "1.25.12-gke.500"
}

resource "google_container_node_pool" "parser" {
  autoscaling {
    max_node_count = 3
    min_node_count = 0
  }

  cluster            = "data-pipeline"
  initial_node_count = 3
  location           = "us-central1"

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

  # node_count     = 3
  node_locations = ["us-central1-a", "us-central1-b", "us-central1-c"]
  project        = "mlab-sandbox"

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  version = "1.25.12-gke.500"
}

resource "google_container_node_pool" "downloader_pool" {
  autoscaling {
    max_node_count = 1
    min_node_count = 0
  }

  cluster            = "data-pipeline"
  initial_node_count = 1
  location           = "us-central1"

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
  node_locations = ["us-central1-a", "us-central1-b", "us-central1-c"]
  project        = "mlab-sandbox"

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  version = "1.25.12-gke.500"
}

resource "google_container_node_pool" "prometheus" {
  autoscaling {
    max_node_count = 2
    min_node_count = 1
  }

  cluster            = "data-pipeline"
  initial_node_count = 1
  location           = "us-central1"

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

    machine_type = "n2-standard-4"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes    = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
    service_account = "default"

    shielded_instance_config {
      enable_integrity_monitoring = true
    }
  }

  # node_count     = 1
  node_locations = ["us-central1-a", "us-central1-b", "us-central1-c"]
  project        = "mlab-sandbox"

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  version = "1.25.12-gke.500"
}

resource "google_container_node_pool" "stats_pipeline" {
  autoscaling {
    max_node_count = 2
    min_node_count = 0
  }

  cluster            = "data-pipeline"
  initial_node_count = 3
  location           = "us-central1"

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
  node_locations = ["us-central1-a", "us-central1-b", "us-central1-c"]
  project        = "mlab-sandbox"

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  version = "1.25.12-gke.500"
}
