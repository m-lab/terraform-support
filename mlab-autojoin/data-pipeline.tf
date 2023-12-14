module "data-pipeline" {
  source = "../modules/data-pipeline"

  providers = {
    google = google.data-pipeline
  }

  node_pools = {
    "processor" = {
      initial_node_count = 1
      machine_type       = "n2-standard-4"
      max_node_count     = 2
      max_surge          = 1
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
    },
    "prometheus" = {
      initial_node_count = 1
      machine_type       = "n2-standard-4"
      max_node_count     = 2
      max_surge          = 1
      oauth_scopes = [
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/trace.append"
      ]
    }
  }
}
