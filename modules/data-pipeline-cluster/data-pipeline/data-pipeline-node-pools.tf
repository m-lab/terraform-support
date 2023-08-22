# Nodepool for the gardener and autoloader.
resource "google_container_node_pool" "processor" {

  name           = "processor"
  cluster        = google_container_cluster.data_pipeline.id
  project        = "mlab-sandbox"
  location       = "us-central1"

  initial_node_count = 1
  node_config {
    labels = {
      gardener-node = "true"
      processor-node = "true"
    }
    machine_type = "n2-standard-4"
    oauth_scopes    = [
        "https://www.googleapis.com/auth/bigquery",
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/taskqueue"
    ]
    service_account = "default"
  }

  autoscaling {
    max_node_count = 2
    min_node_count = 0
  }
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

}
resource "google_container_node_pool" "parser" {

  name           = "parser"
  cluster        = google_container_cluster.data_pipeline.id
  project        = "mlab-sandbox"
  location       = "us-central1"

  initial_node_count = 3
  node_config {
    labels = {
      parser-node = "true"
    }
    machine_type = "n2-standard-16"
    oauth_scopes    = [
        "https://www.googleapis.com/auth/cloud-platform",
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/devstorage.read_write"
    ]
    service_account = "default"
  }

  autoscaling {
    max_node_count = 2
    min_node_count = 0
  }
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
}

resource "google_container_node_pool" "downloader" {

  name           = "downloader"
  cluster        = google_container_cluster.data_pipeline.id
  project        = "mlab-sandbox"
  location       = "us-central1"

  initial_node_count = 1
  node_config {
    labels = {
      downloader-node = "true"
    }
    machine_type = "n1-standard-4"
    oauth_scopes = [
        "https://www.googleapis.com/auth/devstorage.read_write",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring"
    ]
    service_account = "default"
  }

  autoscaling {
    max_node_count = 1
    min_node_count = 0
  }
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
}

resource "google_container_node_pool" "prometheus" {

  name     = "prometheus"
  cluster  = google_container_cluster.data_pipeline.id
  project  = "mlab-sandbox"
  location = "us-central1"

  initial_node_count = 1
  node_config {
    labels = {
      prometheus-node = "true"
    }
    machine_type = "n2-standard-4"
    oauth_scopes    = [
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/trace.append"
    ]
    service_account = "default"
  }

  autoscaling {
    max_node_count = 2
    min_node_count = 1
  }
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
}

resource "google_service_account" "stats_pipeline" {
  account_id   = "stats-pipeline"
  description  = "Account for stats-pipeline. R/W access to GCS and BQ"
  display_name = "stats-pipeline"
  project      = "mlab-sandbox"
}

resource "google_container_node_pool" "statistics" {

  name     = "statistics"
  cluster  = google_container_cluster.data_pipeline.id
  project  = "mlab-sandbox"
  location = "us-central1"

  initial_node_count = 1
  node_config {
    labels = {
      stats-pipeline-node = "true"
    }
    machine_type = "n2-highcpu-16"
    metadata = {
      disable-legacy-endpoints = "true"
    }
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    service_account = google_service_account.stats_pipeline.email
  }

  autoscaling {
    max_node_count = 2
    min_node_count = 0
  }
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
}
