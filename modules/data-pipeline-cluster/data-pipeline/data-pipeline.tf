resource "google_compute_network" "data_pipeline" {
  auto_create_subnetworks = false
  description             = "Communication between backend processing services, e.g. etl, gardener, autoloader, or stats pipelines."
  name                    = "data-pipeline"
  project                 = "mlab-sandbox"
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "data_pipeline_us_central1" {
  ip_cidr_range              = "10.80.0.0/16"
  name                       = "pipeline"
  network                    = google_compute_network.data_pipeline.id
  region                     = "us-central1"
  project                    = "mlab-sandbox"
}

resource "google_container_cluster" "data_pipeline" {

  name    = "data-pipeline"
  project   = "mlab-sandbox"
  location  = "us-central1"

  network = google_compute_network.data_pipeline.id
  subnetwork = google_compute_subnetwork.data_pipeline_us_central1.id

  remove_default_node_pool = true
  initial_node_count       = 1

  resource_labels = {
    data-pipeline = "true"
  }
}
