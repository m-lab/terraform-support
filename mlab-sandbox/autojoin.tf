module "autojoin" {
  source = "../modules/autojoin"

  providers = {
    google = google.autojoin
  }

  node_pools = {
    "pipeline" = {
      initial_node_count = 1
      machine_type       = "n2-standard-4"
      max_node_count     = 3
      max_surge          = 1
    },
    "monitoring" = {
      initial_node_count = 1
      machine_type       = "n2-standard-4"
      max_node_count     = 3
      max_surge          = 1
    }
  }

  # On sandbox, GAE was initially set up to be on us-east1, and this cannot
  # be easily changed, se we override the appengine_region here.
  appengine_region = "us-east1"
}
