module "data-pipeline" {
  source = "../modules/data-pipeline"

  providers = {
    google = google.data-pipeline
  }

  node_pools = {
    "downloader" = {
      initial_node_count = 1
      labels = {
        downloader-node = "true"
      }
      machine_type    = "n2-standard-4"
      max_node_count  = 1
      max_surge       = 1
      max_unavailable = 0
      min_node_count  = 0
      oauth_scopes = [
        "https://www.googleapis.com/auth/devstorage.read_write",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring"
      ]
      service_account = "default"
    },
    "parser" = {
      initial_node_count = 3
      labels = {
        parser-node = "true"
      }
      machine_type    = "n2-standard-16"
      max_node_count  = 3
      max_surge       = 1
      max_unavailable = 0
      min_node_count  = 0
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/devstorage.read_write"
      ]
      service_account = "default"
    },
    "processor" = {
      initial_node_count = 1
      labels = {
        gardener-node  = "true"
        processor-node = "true"
      }
      machine_type    = "n2-standard-4"
      max_node_count  = 2
      max_surge       = 1
      max_unavailable = 0
      min_node_count  = 0
      oauth_scopes = [
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
    },
    "prometheus" = {
      initial_node_count = 1
      labels = {
        prometheus-node = "true"
      }
      machine_type    = "n2-standard-4"
      max_node_count  = 2
      max_surge       = 1
      max_unavailable = 0
      min_node_count  = 0
      oauth_scopes = [
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/trace.append"
      ]
      service_account = "default"
    },
    "statistics" = {
      initial_node_count = 1
      labels = {
        stats-pipeline-node = "true"
      }
      machine_type    = "n2-standard-16"
      max_node_count  = 2
      max_surge       = 1
      max_unavailable = 0
      min_node_count  = 0
      oauth_scopes = [
        "https://www.googleapis.com/auth/bigquery",
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/taskqueue"
      ]
      service_account = "google_service_account.stats_pipeline.email"
    }
  }
}
